using UnityEngine;
using System.Collections;

public class BlendTreeController : MonoBehaviour
{

    private Animator animator;
    private float velZ, velX;

    private void Awake()
    {
        animator = GetComponent<Animator>();
    }

    /**
    * 移動
    */
    void Update()
    {
        velZ = Input.GetAxis("Vertical");
        velX = Input.GetAxis("Horizontal");
        animator.SetFloat("velZ", velZ);
        animator.SetFloat("velX", velX);
    }
}