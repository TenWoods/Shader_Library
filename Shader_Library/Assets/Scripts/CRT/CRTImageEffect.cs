using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
[RequireComponent(typeof(Camera))]
public class CRTImageEffect : MonoBehaviour 
{
	public Shader crtShader;
	public Texture2D basePixel;
	[Range(1, 100)]
	public int pixelNum = 10;

	public Material CRTMaterial
	{
		get
		{
			return CheckShaderAndMaterial();
		}
	}
	private Material m_material = null;

	private void OnRenderImage(RenderTexture screen, RenderTexture result)
	{
		if (CRTMaterial != null)
		{
			m_material.SetTexture("_PixelTex", basePixel);
			m_material.SetInt("_PixelNum", pixelNum);
			Graphics.Blit(screen, result, m_material);
		}
		else
		{
			Graphics.Blit(screen, result);
		}
	}

	private Material CheckShaderAndMaterial()
	{
		if (crtShader == null)
		{
			return null;
		}
		if (crtShader.isSupported && m_material != null && m_material.shader == crtShader)
		{
			return m_material;
		}
		if (!crtShader.isSupported)
		{
			return null;
		}
		else
		{
			m_material = new Material(crtShader);
			m_material.hideFlags = HideFlags.DontSave;
			if (m_material)
			{
				return m_material;
			}
			else
			{
				return null;
			}
		}
	}

}
