using UnityEngine;

public class ToggleRootMotion : StateMachineBehaviour
{
    public bool enableRootMotion = false; // �o�Ӫ��A���n Root Motion

    bool prev;
    public override void OnStateEnter(Animator animator, AnimatorStateInfo stateInfo, int layerIndex)
    {
        prev = animator.applyRootMotion;
        animator.applyRootMotion = enableRootMotion;
    }
    public override void OnStateExit(Animator animator, AnimatorStateInfo stateInfo, int layerIndex)
    {
        animator.applyRootMotion = prev; // ���}���٭�
    }
}
