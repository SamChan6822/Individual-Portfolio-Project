using UnityEngine;

public class ToggleRootMotion : StateMachineBehaviour
{
    public bool enableRootMotion = false; // 這個狀態不要 Root Motion

    bool prev;
    public override void OnStateEnter(Animator animator, AnimatorStateInfo stateInfo, int layerIndex)
    {
        prev = animator.applyRootMotion;
        animator.applyRootMotion = enableRootMotion;
    }
    public override void OnStateExit(Animator animator, AnimatorStateInfo stateInfo, int layerIndex)
    {
        animator.applyRootMotion = prev; // 離開時還原
    }
}
