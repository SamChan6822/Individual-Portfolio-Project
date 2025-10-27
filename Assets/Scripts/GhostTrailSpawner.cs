using System.Collections;
using UnityEngine;

public class GhostTrailSpawner : MonoBehaviour
{
    [Header("Prefab / 基本參數")]
    public ParticleSystem particlePrefab;
    [Min(0.01f)] public float interval = 0.08f;
    [Min(0f)] public float duration = 0.6f;

    [Header("生成位置與釋放")]
    public Transform follow;
    public bool parentUnderThis = true;
    public float extraAlive = 1f;

    [Header("隨機化")]
    public Vector2 startSizeRange = new Vector2(0.8f, 1.2f);   // 尺寸倍率
    public Vector2 rotationZRange = new Vector2(-20f, 20f);    // Z 旋轉（Billboard 生效）
    public Vector3 rotation3DMin = new Vector3(0, 0, 0);       // Mesh/Non-billboard 用
    public Vector3 rotation3DMax = new Vector3(0, 0, 0);
    public bool use3DRotation = false;                          // 若 Renderer 不是 Billboard，勾這個

    Coroutine routine;

    // Timeline 觸發
    public void StartSpawn() => StartSpawnFor(duration);
    public void StartSpawnFor(float seconds)
    {
        StopSpawn();
        routine = StartCoroutine(SpawnFor(seconds));
    }
    public void StopSpawn()
    {
        if (routine != null) { StopCoroutine(routine); routine = null; }
    }

    IEnumerator SpawnFor(float seconds)
    {
        float t = 0f;
        var wait = new WaitForSeconds(interval);
        while (t < seconds)
        {
            SpawnOne();
            t += interval;
            yield return wait;
        }
        routine = null;
    }

    void SpawnOne()
    {
        if (!particlePrefab) return;

        Vector3 pos = follow ? follow.position : transform.position;
        Quaternion rot = follow ? follow.rotation : transform.rotation;

        var ps = Instantiate(particlePrefab, pos, rot,
                             parentUnderThis ? transform : null);

        // —— 隨機尺寸 —— //
        var main = ps.main;
        float sizeMul = Random.Range(startSizeRange.x, startSizeRange.y);
        if (main.startSize3D)
        {
            // 3D 尺寸
            Vector3 s = main.startSizeXMultiplier * Vector3.right
                      + main.startSizeYMultiplier * Vector3.up
                      + main.startSizeZMultiplier * Vector3.forward;
            main.startSizeXMultiplier *= sizeMul;
            main.startSizeYMultiplier *= sizeMul;
            main.startSizeZMultiplier *= sizeMul;
        }
        else
        {
            main.startSizeMultiplier *= sizeMul;
        }

        // —— 隨機旋轉 —— //
        if (use3DRotation)
        {
            // 適用 Renderer 非 Billboard（如 Mesh、Stretched Billboard 等）
            float rx = Random.Range(rotation3DMin.x, rotation3DMax.x);
            float ry = Random.Range(rotation3DMin.y, rotation3DMax.y);
            float rz = Random.Range(rotation3DMin.z, rotation3DMax.z);
            ps.transform.Rotate(rx, ry, rz, Space.Self);
        }
        else
        {
            // Billboard 粒子只吃 Z 軸旋轉
            float z = Random.Range(rotationZRange.x, rotationZRange.y) * Mathf.Deg2Rad;
            main.startRotation = new ParticleSystem.MinMaxCurve(main.startRotation.constant + z);
        }

        ps.Play();

        float life = ps.main.duration + ps.main.startLifetimeMultiplier + extraAlive;
        Destroy(ps.gameObject, life);
    }

    void OnDisable() { StopSpawn(); }
}
