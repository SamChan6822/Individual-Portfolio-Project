// Made with Amplify Shader Editor v1.9.8.1
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "VFX/ASE ScDistort 2025"
{
	Properties
	{
		[Foldout(1,2,0,0)]_Foldout1("基本参数 _Foldout", Float) = 1
		_AllAlphaInt("通道强度", Range( 0 , 5)) = 1
		[Enum(Off,4,On,6)]_ZTest("渲染置顶", Float) = 4
		[Foldout(2,2,1,0)]_DepthFoldout("软粒子 _Foldout", Float) = 0
		[Enum(Off,0,On,1)]_ZWrite("开启深度", Float) = 0
		[Toggle]_DepthOneMinus("反向", Float) = 0
		[Enum(UnityEngine.Rendering.CullMode)]_RenderFace("双面显示", Float) = 0
		_DepthSize("软粒子强度", Range( 0 , 100)) = 1
		[Foldout(1,2,0,1)]_Foldout2("基础贴图 _Foldout", Float) = 1
		[HDR]_MainColor("基础颜色", Color) = (1,1,1,1)
		[KeywordEnum(A,R,G,B)] _MainA("基础贴图通道", Float) = 0
		[NoScaleOffset][SingleLineTexture]_MainTex("基础贴图", 2D) = "white" {}
		_MainUV("基础贴图UV", Vector) = (1,1,0,0)
		_MainSpeedUV("XYSpeed_ZWClamp", Vector) = (0,0,0,0)
		_MainTexRot("旋转角度", Range( -360 , 360)) = 0
		[Toggle(_MAINPOLAR_ON)] _MainPolar("极坐标", Float) = 0
		[KeywordEnum(Off,Offset,Scale)] _MainPUV("自定义1UV模式", Float) = 0
		[Foldout(1,2,1,0)]_MaskTex1("遮罩贴图_Foldout", Float) = 0
		_MaskIntensity("遮罩贴图强度", Range( 0 , 10)) = 1
		[KeywordEnum(A,R,G,B)] _MaskRGBA("遮罩贴图通道", Float) = 0
		[NoScaleOffset][SingleLineTexture]_MaskTex("遮罩贴图", 2D) = "white" {}
		_MaskUV("遮罩贴图UV", Vector) = (1,1,0,0)
		_MaskTexSpeedUV("XYSpeed_ZWClamp", Vector) = (0,0,0,0)
		_MaskTexRot("旋转角度", Range( -360 , 360)) = 0
		[Toggle(_MASKPARUV2_ON)] _MaskParUV2("自定义2UV_XY", Float) = 0
		[Toggle(_MASKPOLAR1_ON)] _MaskPolar1("极坐标", Float) = 0
		[Toggle_Switch]_Toggle1("开启附加遮罩", Float) = 0
		[Foldout(1,3,0,1,_Toggle1)]_OpeAddMask("附加遮罩设置 _Foldout", Float) = 1
		[KeywordEnum(Multiply,Addtive)] _MaskBlend("遮罩混合模式", Float) = 0
		[KeywordEnum(A,R,G,B)] _AddMaskRGBA("附加遮罩通道", Float) = 0
		_AddMaskIntensity("附加遮罩贴图强度", Range( 0 , 10)) = 1
		[NoScaleOffset][SingleLineTexture]_AddMaskTex1("附加遮罩贴图", 2D) = "white" {}
		_AddMaskUV("附加遮罩UV", Vector) = (1,1,0,0)
		_AddMaskSpeedUV("XYSpeed_ZWClamp", Vector) = (0,0,0,0)
		_AddMaskTexRot("旋转角度", Range( -360 , 360)) = 0
		[Toggle(_ADDMASKPOLAR_ON)] _AddMaskPolar("极坐标", Float) = 0
		[Foldout(1,2,1,0)]_ScDistortFoldout("热浪扭曲 _Foldout", Float) = 0
		_ScDistortIntColor("去除颜色", Range( 0 , 1)) = 0
		_ScDistortInt("扭曲强度", Range( 0 , 1)) = 0
		[Foldout(1,2,0,1)]_RenderQueue("渲染属性 _Foldout", Float) = 1
		[HideInInspector][Enum(UnityEngine.Rendering.BlendMode)]_SrcBlend("Src Blend", Float) = 5
		[HideInInspector][Enum(UnityEngine.Rendering.BlendMode)]_DstBlend("Dst Blend", Float) = 10

	}

	SubShader
	{
		

		Tags { "RenderType"="Transparent" "Queue"="Transparent" }
	LOD 100

		CGINCLUDE
		#pragma target 3.0
		ENDCG
		Blend [_SrcBlend] [_DstBlend], [_SrcBlend] [_DstBlend]
		AlphaToMask Off
		Cull [_RenderFace]
		ColorMask RGBA
		ZWrite [_ZWrite]
		ZTest [_ZTest]
		

		GrabPass{ }

		Pass
		{
			Name "Unlit"

			CGPROGRAM

			#define ASE_VERSION 19801
			#if defined(UNITY_STEREO_INSTANCING_ENABLED) || defined(UNITY_STEREO_MULTIVIEW_ENABLED)
			#define ASE_DECLARE_SCREENSPACE_TEXTURE(tex) UNITY_DECLARE_SCREENSPACE_TEXTURE(tex);
			#else
			#define ASE_DECLARE_SCREENSPACE_TEXTURE(tex) UNITY_DECLARE_SCREENSPACE_TEXTURE(tex)
			#endif


			#ifndef UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX
			//only defining to not throw compilation error over Unity 5.5
			#define UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(input)
			#endif
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_instancing
			#include "UnityCG.cginc"
			#include "UnityShaderVariables.cginc"
			#define ASE_NEEDS_FRAG_COLOR
			#pragma shader_feature_local _MAINPUV_OFF _MAINPUV_OFFSET _MAINPUV_SCALE
			#pragma shader_feature_local _MAINPOLAR_ON
			#pragma shader_feature_local _MASKPARUV2_ON
			#pragma shader_feature_local _MASKPOLAR1_ON
			#pragma shader_feature_local _ADDMASKPOLAR_ON
			#pragma shader_feature _MAINA_A _MAINA_R _MAINA_G _MAINA_B
			#pragma shader_feature _MASKRGBA_A _MASKRGBA_R _MASKRGBA_G _MASKRGBA_B
			#pragma shader_feature_local _MASKBLEND_MULTIPLY _MASKBLEND_ADDTIVE
			#pragma shader_feature _ADDMASKRGBA_A _ADDMASKRGBA_R _ADDMASKRGBA_G _ADDMASKRGBA_B


			struct appdata
			{
				float4 vertex : POSITION;
				float4 color : COLOR;
				float4 ase_texcoord : TEXCOORD0;
				float4 ase_texcoord1 : TEXCOORD1;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct v2f
			{
				float4 vertex : SV_POSITION;
				#ifdef ASE_NEEDS_FRAG_WORLD_POSITION
				float3 worldPos : TEXCOORD0;
				#endif
				float4 ase_texcoord1 : TEXCOORD1;
				float4 ase_texcoord2 : TEXCOORD2;
				float4 ase_color : COLOR;
				float4 ase_texcoord3 : TEXCOORD3;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			uniform float _Foldout2;
			uniform float _ZTest;
			uniform float _ZWrite;
			uniform float _RenderFace;
			uniform float _Foldout1;
			uniform float _RenderQueue;
			uniform float _DstBlend;
			uniform float _SrcBlend;
			uniform float _OpeAddMask;
			uniform sampler2D _MainTex;
			uniform float4 _MainSpeedUV;
			uniform float4 _MainTex_ST;
			uniform float _MainTexRot;
			uniform float4 _MainUV;
			uniform sampler2D _MaskTex;
			uniform float4 _MaskTexSpeedUV;
			uniform float4 _MaskTex_ST;
			uniform float _MaskTexRot;
			uniform float4 _MaskUV;
			uniform float _MaskIntensity;
			uniform sampler2D _AddMaskTex1;
			uniform float4 _AddMaskSpeedUV;
			uniform float4 _AddMaskTex1_ST;
			uniform float _AddMaskTexRot;
			uniform float4 _AddMaskUV;
			uniform float _AddMaskIntensity;
			uniform float _Toggle1;
			uniform float _MaskTex1;
			uniform float4 _MainColor;
			uniform float _AllAlphaInt;
			UNITY_DECLARE_DEPTH_TEXTURE( _CameraDepthTexture );
			uniform float4 _CameraDepthTexture_TexelSize;
			uniform float _DepthSize;
			uniform float _DepthOneMinus;
			uniform float _DepthFoldout;
			ASE_DECLARE_SCREENSPACE_TEXTURE( _GrabTexture )
			uniform float _ScDistortInt;
			uniform float _ScDistortIntColor;
			uniform float _ScDistortFoldout;
			inline float4 ASE_ComputeGrabScreenPos( float4 pos )
			{
				#if UNITY_UV_STARTS_AT_TOP
				float scale = -1.0;
				#else
				float scale = 1.0;
				#endif
				float4 o = pos;
				o.y = pos.w * 0.5f;
				o.y = ( pos.y - o.y ) * _ProjectionParams.x * scale + o.y;
				return o;
			}
			


			v2f vert ( appdata v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				UNITY_TRANSFER_INSTANCE_ID(v, o);

				float4 ase_positionCS = UnityObjectToClipPos( v.vertex );
				float4 screenPos = ComputeScreenPos( ase_positionCS );
				o.ase_texcoord3 = screenPos;
				
				o.ase_texcoord1 = v.ase_texcoord;
				o.ase_texcoord2 = v.ase_texcoord1;
				o.ase_color = v.color;
				float3 vertexValue = float3(0, 0, 0);
				#if ASE_ABSOLUTE_VERTEX_POS
				vertexValue = v.vertex.xyz;
				#endif
				vertexValue = vertexValue;
				#if ASE_ABSOLUTE_VERTEX_POS
				v.vertex.xyz = vertexValue;
				#else
				v.vertex.xyz += vertexValue;
				#endif
				o.vertex = UnityObjectToClipPos(v.vertex);

				#ifdef ASE_NEEDS_FRAG_WORLD_POSITION
				o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
				#endif
				return o;
			}

			fixed4 frag (v2f i ) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID(i);
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(i);
				fixed4 finalColor;
				#ifdef ASE_NEEDS_FRAG_WORLD_POSITION
				float3 WorldPosition = i.worldPos;
				#endif
				float2 appendResult72 = (float2(_MainSpeedUV.x , _MainSpeedUV.y));
				float2 uv_MainTex = i.ase_texcoord1.xy * _MainTex_ST.xy + _MainTex_ST.zw;
				float2 temp_output_112_0 = ( uv_MainTex - float2( 0.5,0.5 ) );
				float2 break108 = temp_output_112_0;
				float2 appendResult111 = (float2(( length( temp_output_112_0 ) * 2.0 ) , ( atan2( break108.x , break108.y ) * ( 1.0 / 6.28318548202515 ) )));
				#ifdef _MAINPOLAR_ON
				float2 staticSwitch70 = appendResult111;
				#else
				float2 staticSwitch70 = uv_MainTex;
				#endif
				float cos74 = cos( ( ( _MainTexRot / -180.0 ) * UNITY_PI ) );
				float sin74 = sin( ( ( _MainTexRot / -180.0 ) * UNITY_PI ) );
				float2 rotator74 = mul( staticSwitch70 - float2( 0.5,0.5 ) , float2x2( cos74 , -sin74 , sin74 , cos74 )) + float2( 0.5,0.5 );
				float2 panner75 = ( -1.0 * _Time.y * appendResult72 + rotator74);
				float2 appendResult73 = (float2(i.ase_texcoord2.xy.x , i.ase_texcoord2.xy.y));
				#if defined( _MAINPUV_OFF )
				float2 staticSwitch83 = panner75;
				#elif defined( _MAINPUV_OFFSET )
				float2 staticSwitch83 = ( panner75 + appendResult73 );
				#elif defined( _MAINPUV_SCALE )
				float2 staticSwitch83 = ( panner75 * ( appendResult73 + float2( 1,1 ) ) );
				#else
				float2 staticSwitch83 = panner75;
				#endif
				float2 break87 = ( ( staticSwitch83 * (_MainUV).xy ) + (_MainUV).zw );
				float lerpResult91 = lerp( break87.x , saturate( break87.x ) , _MainSpeedUV.z);
				float lerpResult90 = lerp( break87.y , saturate( break87.y ) , _MainSpeedUV.w);
				float2 appendResult92 = (float2(lerpResult91 , lerpResult90));
				float4 tex2DNode60 = tex2D( _MainTex, appendResult92 );
				float2 appendResult131 = (float2(_MaskTexSpeedUV.x , _MaskTexSpeedUV.y));
				float2 uv_MaskTex = i.ase_texcoord1.xy * _MaskTex_ST.xy + _MaskTex_ST.zw;
				float2 temp_output_13_0_g39 = ( uv_MaskTex - float2( 0.5,0.5 ) );
				float2 break21_g39 = temp_output_13_0_g39;
				float2 appendResult25_g39 = (float2(( length( temp_output_13_0_g39 ) * 2.0 ) , ( atan2( break21_g39.x , break21_g39.y ) * ( 1.0 / 6.28318548202515 ) )));
				#ifdef _MASKPOLAR1_ON
				float2 staticSwitch127 = appendResult25_g39;
				#else
				float2 staticSwitch127 = uv_MaskTex;
				#endif
				float cos132 = cos( ( ( _MaskTexRot / -180.0 ) * UNITY_PI ) );
				float sin132 = sin( ( ( _MaskTexRot / -180.0 ) * UNITY_PI ) );
				float2 rotator132 = mul( staticSwitch127 - float2( 0.5,0.5 ) , float2x2( cos132 , -sin132 , sin132 , cos132 )) + float2( 0.5,0.5 );
				float2 panner136 = ( -1.0 * _Time.y * appendResult131 + rotator132);
				float2 appendResult140 = (float2(i.ase_texcoord2.z , i.ase_texcoord2.w));
				#ifdef _MASKPARUV2_ON
				float2 staticSwitch152 = ( panner136 + appendResult140 );
				#else
				float2 staticSwitch152 = panner136;
				#endif
				float4 temp_output_1_0_g61 = _MaskUV;
				float2 break159 = ( ( staticSwitch152 * (temp_output_1_0_g61).xy ) + (temp_output_1_0_g61).zw );
				float lerpResult166 = lerp( break159.x , saturate( break159.x ) , _MaskTexSpeedUV.z);
				float lerpResult165 = lerp( break159.y , saturate( break159.y ) , _MaskTexSpeedUV.w);
				float2 appendResult169 = (float2(lerpResult166 , lerpResult165));
				float4 tex2DNode171 = tex2D( _MaskTex, appendResult169 );
				float3 MaskColor183 = ( tex2DNode171.rgb * _MaskIntensity );
				float2 appendResult141 = (float2(_AddMaskSpeedUV.x , _AddMaskSpeedUV.y));
				float2 uv_AddMaskTex1 = i.ase_texcoord1.xy * _AddMaskTex1_ST.xy + _AddMaskTex1_ST.zw;
				float2 temp_output_13_0_g57 = ( uv_AddMaskTex1 - float2( 0.5,0.5 ) );
				float2 break21_g57 = temp_output_13_0_g57;
				float2 appendResult25_g57 = (float2(( length( temp_output_13_0_g57 ) * 2.0 ) , ( atan2( break21_g57.x , break21_g57.y ) * ( 1.0 / 6.28318548202515 ) )));
				#ifdef _ADDMASKPOLAR_ON
				float2 staticSwitch139 = appendResult25_g57;
				#else
				float2 staticSwitch139 = uv_AddMaskTex1;
				#endif
				float cos142 = cos( ( ( _AddMaskTexRot / -180.0 ) * UNITY_PI ) );
				float sin142 = sin( ( ( _AddMaskTexRot / -180.0 ) * UNITY_PI ) );
				float2 rotator142 = mul( staticSwitch139 - float2( 0.5,0.5 ) , float2x2( cos142 , -sin142 , sin142 , cos142 )) + float2( 0.5,0.5 );
				float2 panner147 = ( -1.0 * _Time.y * appendResult141 + rotator142);
				float4 temp_output_1_0_g60 = _AddMaskUV;
				float2 break160 = ( ( panner147 * (temp_output_1_0_g60).xy ) + (temp_output_1_0_g60).zw );
				float lerpResult168 = lerp( break160.x , saturate( break160.x ) , _AddMaskSpeedUV.z);
				float lerpResult167 = lerp( break160.y , saturate( break160.y ) , _AddMaskSpeedUV.w);
				float2 appendResult170 = (float2(lerpResult168 , lerpResult167));
				float4 tex2DNode172 = tex2D( _AddMaskTex1, appendResult170 );
				float3 AddMaskColor184 = ( tex2DNode172.rgb * _AddMaskIntensity );
				#ifdef _MAINPOLAR_ON
				float3 staticSwitch199 = ( MaskColor183 + AddMaskColor184 );
				#else
				float3 staticSwitch199 = ( MaskColor183 * AddMaskColor184 );
				#endif
				float3 lerpResult201 = lerp( MaskColor183 , staticSwitch199 , _Toggle1);
				float3 lerpResult205 = lerp( tex2DNode60.rgb , ( lerpResult201 * tex2DNode60.rgb ) , _MaskTex1);
				float3 _ScDistortColor58 = ( ( i.ase_texcoord1.z + 1.0 ) * lerpResult205 * (i.ase_color).rgb * _MainColor.rgb );
				#if defined( _MAINA_A )
				float staticSwitch61 = tex2DNode60.a;
				#elif defined( _MAINA_R )
				float staticSwitch61 = tex2DNode60.r;
				#elif defined( _MAINA_G )
				float staticSwitch61 = tex2DNode60.g;
				#elif defined( _MAINA_B )
				float staticSwitch61 = tex2DNode60.b;
				#else
				float staticSwitch61 = tex2DNode60.a;
				#endif
				#if defined( _MASKRGBA_A )
				float staticSwitch174 = tex2DNode171.a;
				#elif defined( _MASKRGBA_R )
				float staticSwitch174 = tex2DNode171.r;
				#elif defined( _MASKRGBA_G )
				float staticSwitch174 = tex2DNode171.g;
				#elif defined( _MASKRGBA_B )
				float staticSwitch174 = tex2DNode171.b;
				#else
				float staticSwitch174 = tex2DNode171.a;
				#endif
				float MaskAlphaTex180 = ( _MaskIntensity * staticSwitch174 );
				#if defined( _ADDMASKRGBA_A )
				float staticSwitch175 = tex2DNode172.a;
				#elif defined( _ADDMASKRGBA_R )
				float staticSwitch175 = tex2DNode172.r;
				#elif defined( _ADDMASKRGBA_G )
				float staticSwitch175 = tex2DNode172.g;
				#elif defined( _ADDMASKRGBA_B )
				float staticSwitch175 = tex2DNode172.b;
				#else
				float staticSwitch175 = tex2DNode172.a;
				#endif
				float AddMaskAlphaTex179 = ( _AddMaskIntensity * staticSwitch175 );
				#if defined( _MASKBLEND_MULTIPLY )
				float staticSwitch192 = ( AddMaskAlphaTex179 * MaskAlphaTex180 );
				#elif defined( _MASKBLEND_ADDTIVE )
				float staticSwitch192 = ( MaskAlphaTex180 + AddMaskAlphaTex179 );
				#else
				float staticSwitch192 = ( AddMaskAlphaTex179 * MaskAlphaTex180 );
				#endif
				float lerpResult200 = lerp( MaskAlphaTex180 , staticSwitch192 , _Toggle1);
				float lerpResult206 = lerp( staticSwitch61 , ( lerpResult200 * staticSwitch61 ) , _MaskTex1);
				float clampResult46 = clamp( ( lerpResult206 * _AllAlphaInt ) , 0.0 , 1.0 );
				float4 screenPos = i.ase_texcoord3;
				float4 ase_positionSSNorm = screenPos / screenPos.w;
				ase_positionSSNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_positionSSNorm.z : ase_positionSSNorm.z * 0.5 + 0.5;
				float screenDepth39 = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE( _CameraDepthTexture, ase_positionSSNorm.xy ));
				float distanceDepth39 = abs( ( screenDepth39 - LinearEyeDepth( ase_positionSSNorm.z ) ) / ( _DepthSize ) );
				float clampResult42 = clamp( distanceDepth39 , 0.0 , 1.0 );
				float lerpResult47 = lerp( clampResult42 , ( 1.0 - clampResult42 ) , _DepthOneMinus);
				float lerpResult55 = lerp( clampResult46 , ( clampResult46 * lerpResult47 ) , _DepthFoldout);
				float _ScDistortAlpha59 = ( _MainColor.a * i.ase_color.a * lerpResult55 );
				float4 appendResult33 = (float4(_ScDistortColor58 , _ScDistortAlpha59));
				float3 temp_output_25_0 = ( _ScDistortColor58 * _ScDistortAlpha59 );
				float4 ase_grabScreenPos = ASE_ComputeGrabScreenPos( screenPos );
				float4 ase_grabScreenPosNorm = ase_grabScreenPos / ase_grabScreenPos.w;
				float4 screenColor30 = UNITY_SAMPLE_SCREENSPACE_TEXTURE(_GrabTexture,( float4( ( temp_output_25_0 * _ScDistortInt ) , 0.0 ) + ase_grabScreenPosNorm ).xy);
				float4 lerpResult34 = lerp( ( float4( temp_output_25_0 , 0.0 ) + screenColor30 ) , screenColor30 , _ScDistortIntColor);
				float4 lerpResult36 = lerp( appendResult33 , lerpResult34 , _ScDistortFoldout);
				float4 ScColor37 = lerpResult36;
				

				finalColor = ScColor37;
				return finalColor;
			}
			ENDCG
		}
	}
	CustomEditor "Scarecrow.SimpleShaderGUI"
	
	Fallback Off
}
/*ASEBEGIN
Version=19801
Node;AmplifyShaderEditor.CommentaryNode;118;-5712,-144;Inherit;False;5781.296;684.9227;MaskTex;31;183;181;180;177;174;173;171;169;166;165;162;161;159;157;155;152;146;145;140;136;135;132;131;128;127;126;124;123;121;120;119;//遮罩贴图;0.5408804,0,0.226931,1;0;0
Node;AmplifyShaderEditor.TexturePropertyNode;119;-5664,-80;Inherit;True;Property;_MaskTex;遮罩贴图;21;2;[NoScaleOffset];[SingleLineTexture];Create;False;0;0;0;False;0;False;None;None;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.RangedFloatNode;120;-5424,272;Inherit;False;Property;_MaskTexRot;旋转角度;24;0;Create;False;0;0;0;False;0;False;0;172.72;-360;360;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;121;-5312,16;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;122;-5648,608;Inherit;False;5535.775;806.9974;AddMask;28;185;184;182;179;178;176;175;172;170;168;167;164;163;160;158;154;150;147;142;141;139;138;137;134;133;130;129;125;//附加遮罩;0.5849056,0,0.3178318,1;0;0
Node;AmplifyShaderEditor.TexturePropertyNode;65;-6240,-2224;Inherit;True;Property;_MainTex;基础贴图;11;2;[NoScaleOffset];[SingleLineTexture];Create;False;0;0;0;False;0;False;None;None;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.SimpleDivideOpNode;123;-5104,272;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;-180;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;124;-5008,96;Inherit;False;ASE Punction Polar Coordinates;-1;;39;6295e741d0b8bb742a0beaebdf1e106c;0;1;14;FLOAT2;0,0;False;1;FLOAT2;37
Node;AmplifyShaderEditor.TexturePropertyNode;125;-5408,720;Inherit;True;Property;_AddMaskTex1;附加遮罩贴图;32;2;[NoScaleOffset];[SingleLineTexture];Create;False;0;0;0;False;0;False;None;None;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.TextureCoordinatesNode;66;-5936,-2160;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PiNode;126;-4928,272;Inherit;False;1;0;FLOAT;1.37;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;127;-4640,16;Inherit;False;Property;_MaskPolar1;极坐标;26;0;Create;False;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT2;0,0;False;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT2;0,0;False;6;FLOAT2;0,0;False;7;FLOAT2;0,0;False;8;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector4Node;128;-4672,256;Inherit;False;Property;_MaskTexSpeedUV;XYSpeed_ZWClamp;23;0;Create;False;1;;0;0;False;0;False;0,0,0,0;0,0,0,0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;129;-5120,848;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;130;-5088,1072;Inherit;False;Property;_AddMaskTexRot;旋转角度;35;0;Create;False;0;0;0;False;0;False;0;172.72;-360;360;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;101;-5600,-1760;Inherit;False;588.9905;563.3602;scale of angle value;6;110;109;108;104;103;102;;0,0,0,1;0;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;112;-5664,-1936;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT2;0.5,0.5;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;131;-4144,96;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RotatorNode;132;-4336,32;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0.5,0.5;False;2;FLOAT;1.54;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;133;-4752,1072;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;-180;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;134;-4912,960;Inherit;False;ASE Punction Polar Coordinates;-1;;57;6295e741d0b8bb742a0beaebdf1e106c;0;1;14;FLOAT2;0,0;False;1;FLOAT2;37
Node;AmplifyShaderEditor.TexCoordVertexDataNode;135;-4032,144;Inherit;False;1;4;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;103;-5520,-1600;Inherit;False;Constant;_Float6;Float 3;0;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TauNode;104;-5488,-1520;Inherit;False;0;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;108;-5488,-1696;Inherit;False;FLOAT2;1;0;FLOAT2;0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.PannerNode;136;-3824,16;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;-1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector4Node;137;-4544,1168;Inherit;False;Property;_AddMaskSpeedUV;XYSpeed_ZWClamp;34;0;Create;False;1;;0;0;False;0;False;0,0,0,0;0,0,0,0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PiNode;138;-4560,1072;Inherit;False;1;0;FLOAT;1.37;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;139;-4624,848;Inherit;False;Property;_AddMaskPolar;极坐标;36;0;Create;False;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT2;0,0;False;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT2;0,0;False;6;FLOAT2;0,0;False;7;FLOAT2;0,0;False;8;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;140;-3760,192;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;105;-5376,-1888;Inherit;False;Constant;_Float7;Float 2;0;0;Create;True;0;0;0;False;0;False;2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LengthOpNode;106;-5376,-1968;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;102;-5344,-1600;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ATan2OpNode;109;-5376,-1696;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;141;-4192,992;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RotatorNode;142;-4288,848;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0.5,0.5;False;2;FLOAT;1.54;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;145;-3472,144;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;62;-5336.69,-2304.115;Inherit;False;Property;_MainTexRot;旋转角度;14;0;Create;False;0;0;0;False;0;False;0;172.72;-360;360;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;107;-5216,-1968;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;110;-5200,-1696;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector4Node;146;-3328,240;Inherit;False;Property;_MaskUV;遮罩贴图UV;22;0;Create;False;0;0;0;False;0;False;1,1,0,0;1,1,0,0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector4Node;150;-3952,1136;Inherit;False;Property;_AddMaskUV;附加遮罩UV;33;0;Create;False;0;0;0;False;0;False;1,1,0,0;1,1,0,0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PannerNode;147;-3936,848;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;-1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.StaticSwitch;152;-3264,16;Inherit;False;Property;_MaskParUV2;自定义2UV_XY;25;0;Create;False;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT2;0,0;False;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT2;0,0;False;6;FLOAT2;0,0;False;7;FLOAT2;0,0;False;8;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;67;-5016.69,-2304.115;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;-180;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;111;-5008,-1984;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.FunctionNode;154;-3568,1040;Inherit;False;ASE Punction 4To2X2;-1;;60;a37e6b5664211be4bb4ef5d2b8e7977f;0;1;1;FLOAT4;1,1,0,0;False;2;FLOAT2;0;FLOAT2;4
Node;AmplifyShaderEditor.FunctionNode;155;-2896,240;Inherit;False;ASE Punction 4To2X2;-1;;61;a37e6b5664211be4bb4ef5d2b8e7977f;0;1;1;FLOAT4;1,1,0,0;False;2;FLOAT2;0;FLOAT2;4
Node;AmplifyShaderEditor.PiNode;63;-4824.69,-2304.115;Inherit;False;1;0;FLOAT;1.37;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;70;-4904.69,-2160.115;Inherit;False;Property;_MainPolar;极坐标;15;0;Create;False;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT2;0,0;False;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT2;0,0;False;6;FLOAT2;0,0;False;7;FLOAT2;0,0;False;8;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TexCoordVertexDataNode;71;-4856.69,-1872.115;Inherit;False;1;2;0;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector4Node;69;-4656,-2016;Inherit;False;Property;_MainSpeedUV;XYSpeed_ZWClamp;13;0;Create;False;1;;0;0;False;0;False;0,0,0,0;0,0,0,0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FunctionNode;157;-2512,16;Inherit;False;ASE Punction TillingAndOffset;-1;;62;1ec60dd5a2c884842b826af2bb016f51;0;3;1;FLOAT2;0,0;False;5;FLOAT2;1,1;False;6;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.FunctionNode;158;-3216,848;Inherit;False;ASE Punction TillingAndOffset;-1;;63;1ec60dd5a2c884842b826af2bb016f51;0;3;1;FLOAT2;0,0;False;5;FLOAT2;1,1;False;6;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;73;-4472.69,-1872.115;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RotatorNode;74;-4504.69,-2160.115;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0.5,0.5;False;2;FLOAT;1.54;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;72;-4320,-2048;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.BreakToComponentsNode;159;-2080,64;Inherit;False;FLOAT2;1;0;FLOAT2;0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.BreakToComponentsNode;160;-2704,848;Inherit;False;FLOAT2;1;0;FLOAT2;0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.SimpleAddOpNode;76;-3912.69,-1856.115;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;1,1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;75;-4048,-2240;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;-1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SaturateNode;161;-1872,384;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;162;-1856,208;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;163;-2400,1168;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;164;-2512,928;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector4Node;81;-3352.69,-1888.115;Inherit;False;Property;_MainUV;基础贴图UV;12;0;Create;False;0;0;0;False;0;False;1,1,0,0;1,1,0,0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;80;-3504,-2096;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;79;-3568,-1888;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.LerpOp;165;-1568,368;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;166;-1568,192;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;167;-2128,1152;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;168;-2208,848;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;113;-2915.52,-1646.978;Inherit;False;True;True;False;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.StaticSwitch;83;-3184,-2240;Inherit;False;Property;_MainPUV;自定义1UV模式;17;0;Create;False;0;0;0;False;0;False;0;0;0;True;;KeywordEnum;3;Off;Offset;Scale;Create;True;True;All;9;1;FLOAT2;0,0;False;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT2;0,0;False;6;FLOAT2;0,0;False;7;FLOAT2;0,0;False;8;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;169;-1344,48;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;170;-1936,848;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ComponentMaskNode;114;-2819.52,-1502.978;Inherit;False;False;False;True;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;115;-2736,-2224;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;172;-1680,736;Inherit;True;Property;_TextureSample2;Texture Sample 1;13;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.SamplerNode;171;-1104,128;Inherit;True;Property;_TextureSample1;Texture Sample 1;13;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.SimpleAddOpNode;116;-2400,-2256;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.StaticSwitch;175;-1376,1072;Inherit;False;Property;_AddMaskRGBA;附加遮罩通道;30;0;Create;False;0;0;0;False;0;False;0;0;0;True;;KeywordEnum;4;A;R;G;B;Create;False;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;176;-1344,816;Inherit;False;Property;_AddMaskIntensity;附加遮罩贴图强度;31;0;Create;False;0;0;0;True;0;False;1;1;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;173;-832,16;Inherit;False;Property;_MaskIntensity;遮罩贴图强度;19;0;Create;False;0;0;0;True;0;False;1;1;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;174;-656,336;Inherit;False;Property;_MaskRGBA;遮罩贴图通道;20;0;Create;False;0;0;0;True;0;False;0;0;0;True;;KeywordEnum;4;A;R;G;B;Create;False;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;87;-2200.69,-2144.115;Inherit;False;FLOAT2;1;0;FLOAT2;0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;177;-384,192;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;178;-1088,1056;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;89;-2064,-2016;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;88;-2096,-1888;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;179;-736,1120;Inherit;False;AddMaskAlphaTex;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;180;-160,192;Inherit;False;MaskAlphaTex;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;187;-1680,-2608;Inherit;False;916;426.8999;Comment;5;192;191;190;189;188;;1,1,1,1;0;0
Node;AmplifyShaderEditor.LerpOp;90;-1680,-1888;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;91;-1680,-2032;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;188;-1616,-2320;Inherit;False;179;AddMaskAlphaTex;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;189;-1632,-2560;Inherit;False;180;MaskAlphaTex;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;92;-1360,-1936;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;190;-1248,-2432;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;191;-1232,-2320;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;60;-994.5703,-2023.756;Inherit;True;Property;_TextureSample0;Texture Sample 0;1;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;181;-400,-32;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;182;-1072,720;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StaticSwitch;192;-976,-2432;Inherit;False;Property;_MaskBlend;遮罩混合模式;29;0;Create;False;0;0;0;False;1;;False;0;0;0;True;;KeywordEnum;2;Multiply;Addtive;Create;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;193;-800,-2656;Inherit;False;Property;_Toggle1;开启附加遮罩;27;0;Create;False;0;0;0;True;1;Toggle_Switch;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;38;-911.8047,-1231.207;Inherit;False;Property;_DepthSize;软粒子强度;7;0;Create;False;0;0;0;False;0;False;1;0;0;100;0;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;61;-576,-1856;Inherit;False;Property;_MainA;基础贴图通道;10;0;Create;False;0;0;0;False;0;False;0;0;0;True;;KeywordEnum;4;A;R;G;B;Create;False;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;183;-160,-32;Inherit;False;MaskColor;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;184;-816,816;Inherit;False;AddMaskColor;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode;194;-1888,-2992;Inherit;False;1156;330.8999;Comment;5;199;198;197;196;195;;1,1,1,1;0;0
Node;AmplifyShaderEditor.LerpOp;200;-592,-2528;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DepthFade;39;-559.8047,-1263.207;Inherit;False;True;False;True;2;1;FLOAT3;0,0,0;False;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;195;-1872,-2784;Inherit;False;184;AddMaskColor;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;196;-1840,-2944;Inherit;False;183;MaskColor;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;203;-320,-2032;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;204;-96,-2752;Inherit;False;Property;_MaskTex1;遮罩贴图_Foldout;18;0;Create;False;0;0;0;True;1;Foldout(1,2,1,0);False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;41;-687.8047,-1439.207;Inherit;False;Property;_AllAlphaInt;通道强度;1;0;Create;False;0;0;0;True;0;False;1;1;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;42;-271.8047,-1263.207;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;197;-1472,-2800;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;198;-1520,-2912;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp;206;-176,-2352;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;44;-143.8047,-1119.207;Inherit;False;Property;_DepthOneMinus;反向;5;1;[Toggle];Create;False;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;45;-127.8047,-1199.207;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;43;-240,-1808;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;199;-1232,-2832;Inherit;False;Property;_Keyword0;Keyword 0;15;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Reference;70;True;True;All;9;1;FLOAT3;0,0,0;False;0;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;5;FLOAT3;0,0,0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp;47;48.19531,-1263.207;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;46;-48,-1632;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;201;-608,-2928;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.TexCoordVertexDataNode;48;-399.8047,-2255.207;Inherit;False;0;4;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.VertexColorNode;49;-79.80469,-1807.207;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;51;576.1953,-1423.207;Inherit;False;Property;_DepthFoldout;软粒子 _Foldout;3;0;Create;False;0;0;0;True;1;Foldout(2,2,1,0);False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;50;336,-1536;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;202;-279.2188,-2630.333;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;53;-15.80469,-2175.207;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;54;160.1953,-1807.207;Inherit;False;True;True;True;False;1;0;COLOR;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ColorNode;117;432,-1840;Inherit;False;Property;_MainColor;基础颜色;9;1;[HDR];Create;False;0;0;0;False;0;False;1,1,1,1;1,1,1,1;True;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.LerpOp;55;784,-1600;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;205;92.67908,-2429.678;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;56;576.1953,-1967.207;Inherit;False;4;4;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;57;976.1953,-1711.207;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;59;1152.195,-1711.207;Inherit;False;_ScDistortAlpha;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;58;1168,-1968;Inherit;False;_ScDistortColor;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;23;-1360,-832;Inherit;False;59;_ScDistortAlpha;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;24;-1344,-928;Inherit;False;58;_ScDistortColor;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;25;-1056,-816;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;26;-1312,-576;Inherit;False;Property;_ScDistortInt;扭曲强度;39;0;Create;False;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;28;-864,-592;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GrabScreenPosition;27;-1360,-432;Inherit;False;0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;29;-640,-544;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.ScreenColorNode;30;-416,-576;Inherit;False;Global;_GrabScreen0;Grab Screen 0;63;0;Create;True;0;0;0;False;0;False;Object;-1;False;False;False;False;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;32;-256,-816;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;31;-448,-384;Inherit;False;Property;_ScDistortIntColor;去除颜色;38;0;Create;False;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;33;-528,-912;Inherit;False;COLOR;4;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;35;448,-608;Inherit;False;Property;_ScDistortFoldout;热浪扭曲 _Foldout;37;0;Create;False;0;0;0;True;1;Foldout(1,2,1,0);False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;34;-64,-544;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;93;-5446.93,-3019.08;Inherit;False;672.667;360.2833;;7;100;99;98;97;96;95;94;//基本参数设置;1,0,0,1;0;0
Node;AmplifyShaderEditor.LerpOp;36;688,-912;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;64;-5864.69,-2304.115;Inherit;False;Property;_Foldout2;基础贴图 _Foldout;8;0;Create;False;0;0;0;True;1;Foldout(1,2,0,1);False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;96;-4966.93,-2875.08;Inherit;False;Property;_ZTest;渲染置顶;2;1;[Enum];Create;False;0;2;Off;4;On;6;0;True;0;False;4;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;97;-4959.743,-2970.32;Inherit;False;Property;_ZWrite;开启深度;4;1;[Enum];Create;False;0;2;Off;0;On;1;0;True;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;98;-5398.93,-2875.08;Inherit;False;Property;_RenderFace;双面显示;6;1;[Enum];Create;False;0;0;1;UnityEngine.Rendering.CullMode;True;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;99;-5398.93,-2971.08;Inherit;False;Property;_Foldout1;基本参数 _Foldout;0;0;Create;False;0;0;0;True;1;Foldout(1,2,0,0);False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;100;-5408,-2784;Inherit;False;Property;_RenderQueue;渲染属性 _Foldout;40;0;Create;False;0;0;0;True;1;Foldout(1,2,0,1);False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;94;-5174.93,-2875.08;Inherit;False;Property;_DstBlend;Dst Blend;42;2;[HideInInspector];[Enum];Create;False;0;0;1;UnityEngine.Rendering.BlendMode;True;0;True;10;10;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;95;-5174.93,-2971.08;Inherit;False;Property;_SrcBlend;Src Blend;41;2;[HideInInspector];[Enum];Create;False;0;0;1;UnityEngine.Rendering.BlendMode;True;0;True;5;5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;37;912,-912;Inherit;False;ScColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;185;-5616,656;Inherit;False;Property;_OpeAddMask;附加遮罩设置 _Foldout;28;0;Create;False;0;0;1;;True;1;Foldout(1,3,0,1,_Toggle1);False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;21;1280,-912;Float;False;True;-1;3;Scarecrow.SimpleShaderGUI;100;5;VFX/ASE ScDistort 2025;0770190933193b94aaa3065e307002fa;True;Unlit;0;0;Unlit;2;True;True;2;5;True;_SrcBlend;10;True;_DstBlend;2;5;True;_SrcBlend;10;True;_DstBlend;True;0;False;;0;False;;False;False;False;False;False;False;False;False;False;True;0;False;;True;True;2;True;_RenderFace;False;True;True;True;True;True;0;False;;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;True;True;2;True;_ZWrite;True;0;True;_ZTest;True;False;0;False;;0;False;;True;2;RenderType=Transparent=RenderType;Queue=Transparent=Queue=0;True;2;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;0;;0;0;Standard;1;Vertex Position,InvertActionOnDeselection;1;0;0;1;True;False;;False;0
WireConnection;121;2;119;0
WireConnection;123;0;120;0
WireConnection;124;14;121;0
WireConnection;66;2;65;0
WireConnection;126;0;123;0
WireConnection;127;1;121;0
WireConnection;127;0;124;37
WireConnection;129;2;125;0
WireConnection;112;0;66;0
WireConnection;131;0;128;1
WireConnection;131;1;128;2
WireConnection;132;0;127;0
WireConnection;132;2;126;0
WireConnection;133;0;130;0
WireConnection;134;14;129;0
WireConnection;108;0;112;0
WireConnection;136;0;132;0
WireConnection;136;2;131;0
WireConnection;138;0;133;0
WireConnection;139;1;129;0
WireConnection;139;0;134;37
WireConnection;140;0;135;3
WireConnection;140;1;135;4
WireConnection;106;0;112;0
WireConnection;102;0;103;0
WireConnection;102;1;104;0
WireConnection;109;0;108;0
WireConnection;109;1;108;1
WireConnection;141;0;137;1
WireConnection;141;1;137;2
WireConnection;142;0;139;0
WireConnection;142;2;138;0
WireConnection;145;0;136;0
WireConnection;145;1;140;0
WireConnection;107;0;106;0
WireConnection;107;1;105;0
WireConnection;110;0;109;0
WireConnection;110;1;102;0
WireConnection;147;0;142;0
WireConnection;147;2;141;0
WireConnection;152;1;136;0
WireConnection;152;0;145;0
WireConnection;67;0;62;0
WireConnection;111;0;107;0
WireConnection;111;1;110;0
WireConnection;154;1;150;0
WireConnection;155;1;146;0
WireConnection;63;0;67;0
WireConnection;70;1;66;0
WireConnection;70;0;111;0
WireConnection;157;1;152;0
WireConnection;157;5;155;0
WireConnection;157;6;155;4
WireConnection;158;1;147;0
WireConnection;158;5;154;0
WireConnection;158;6;154;4
WireConnection;73;0;71;1
WireConnection;73;1;71;2
WireConnection;74;0;70;0
WireConnection;74;2;63;0
WireConnection;72;0;69;1
WireConnection;72;1;69;2
WireConnection;159;0;157;0
WireConnection;160;0;158;0
WireConnection;76;0;73;0
WireConnection;75;0;74;0
WireConnection;75;2;72;0
WireConnection;161;0;159;1
WireConnection;162;0;159;0
WireConnection;163;0;160;1
WireConnection;164;0;160;0
WireConnection;80;0;75;0
WireConnection;80;1;73;0
WireConnection;79;0;75;0
WireConnection;79;1;76;0
WireConnection;165;0;159;1
WireConnection;165;1;161;0
WireConnection;165;2;128;4
WireConnection;166;0;159;0
WireConnection;166;1;162;0
WireConnection;166;2;128;3
WireConnection;167;0;160;1
WireConnection;167;1;163;0
WireConnection;167;2;137;4
WireConnection;168;0;160;0
WireConnection;168;1;164;0
WireConnection;168;2;137;3
WireConnection;113;0;81;0
WireConnection;83;1;75;0
WireConnection;83;0;80;0
WireConnection;83;2;79;0
WireConnection;169;0;166;0
WireConnection;169;1;165;0
WireConnection;170;0;168;0
WireConnection;170;1;167;0
WireConnection;114;0;81;0
WireConnection;115;0;83;0
WireConnection;115;1;113;0
WireConnection;172;0;125;0
WireConnection;172;1;170;0
WireConnection;171;0;119;0
WireConnection;171;1;169;0
WireConnection;116;0;115;0
WireConnection;116;1;114;0
WireConnection;175;1;172;4
WireConnection;175;0;172;1
WireConnection;175;2;172;2
WireConnection;175;3;172;3
WireConnection;174;1;171;4
WireConnection;174;0;171;1
WireConnection;174;2;171;2
WireConnection;174;3;171;3
WireConnection;87;0;116;0
WireConnection;177;0;173;0
WireConnection;177;1;174;0
WireConnection;178;0;176;0
WireConnection;178;1;175;0
WireConnection;89;0;87;0
WireConnection;88;0;87;1
WireConnection;179;0;178;0
WireConnection;180;0;177;0
WireConnection;90;0;87;1
WireConnection;90;1;88;0
WireConnection;90;2;69;4
WireConnection;91;0;87;0
WireConnection;91;1;89;0
WireConnection;91;2;69;3
WireConnection;92;0;91;0
WireConnection;92;1;90;0
WireConnection;190;0;188;0
WireConnection;190;1;189;0
WireConnection;191;0;189;0
WireConnection;191;1;188;0
WireConnection;60;0;65;0
WireConnection;60;1;92;0
WireConnection;181;0;171;5
WireConnection;181;1;173;0
WireConnection;182;0;172;5
WireConnection;182;1;176;0
WireConnection;192;1;190;0
WireConnection;192;0;191;0
WireConnection;61;1;60;4
WireConnection;61;0;60;1
WireConnection;61;2;60;2
WireConnection;61;3;60;3
WireConnection;183;0;181;0
WireConnection;184;0;182;0
WireConnection;200;0;189;0
WireConnection;200;1;192;0
WireConnection;200;2;193;0
WireConnection;39;0;38;0
WireConnection;203;0;200;0
WireConnection;203;1;61;0
WireConnection;42;0;39;0
WireConnection;197;0;196;0
WireConnection;197;1;195;0
WireConnection;198;0;196;0
WireConnection;198;1;195;0
WireConnection;206;0;61;0
WireConnection;206;1;203;0
WireConnection;206;2;204;0
WireConnection;45;0;42;0
WireConnection;43;0;206;0
WireConnection;43;1;41;0
WireConnection;199;1;198;0
WireConnection;199;0;197;0
WireConnection;47;0;42;0
WireConnection;47;1;45;0
WireConnection;47;2;44;0
WireConnection;46;0;43;0
WireConnection;201;0;196;0
WireConnection;201;1;199;0
WireConnection;201;2;193;0
WireConnection;50;0;46;0
WireConnection;50;1;47;0
WireConnection;202;0;201;0
WireConnection;202;1;60;5
WireConnection;53;0;48;3
WireConnection;54;0;49;0
WireConnection;55;0;46;0
WireConnection;55;1;50;0
WireConnection;55;2;51;0
WireConnection;205;0;60;5
WireConnection;205;1;202;0
WireConnection;205;2;204;0
WireConnection;56;0;53;0
WireConnection;56;1;205;0
WireConnection;56;2;54;0
WireConnection;56;3;117;5
WireConnection;57;0;117;4
WireConnection;57;1;49;4
WireConnection;57;2;55;0
WireConnection;59;0;57;0
WireConnection;58;0;56;0
WireConnection;25;0;24;0
WireConnection;25;1;23;0
WireConnection;28;0;25;0
WireConnection;28;1;26;0
WireConnection;29;0;28;0
WireConnection;29;1;27;0
WireConnection;30;0;29;0
WireConnection;32;0;25;0
WireConnection;32;1;30;0
WireConnection;33;0;24;0
WireConnection;33;3;23;0
WireConnection;34;0;32;0
WireConnection;34;1;30;0
WireConnection;34;2;31;0
WireConnection;36;0;33;0
WireConnection;36;1;34;0
WireConnection;36;2;35;0
WireConnection;37;0;36;0
WireConnection;21;0;37;0
ASEEND*/
//CHKSM=74BCEF25E93F37235D83FB1810B08097C0C7AB9A