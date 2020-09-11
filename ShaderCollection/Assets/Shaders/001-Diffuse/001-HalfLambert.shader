Shader "Unlit/001-HalfLambert"
{
    Properties
    {
        _Diffuse("Diffuse", Color) = (1,1,1,1)
    }

    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"
            #include "Lighting.cginc"

            fixed4 _Diffuse;

            struct v2f
            {
                float4 vertex: SV_POSITION;
                fixed3 color: Color;
            };

            v2f vert (appdata_base v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT;
                
                // 漫反射 光颜色 * 漫反射颜色 * saturate( 单位法线向量 * 单位光线向量)
                fixed3 worldNormal = UnityObjectToWorldNormal(v.normal);
                fixed3 worldLight = normalize(_WorldSpaceLightPos0.xyz);

                fixed3 diffuse = _LightColor0.rgb * _Diffuse.rgb * saturate(dot(worldNormal, worldLight) * 0.5 + 0.5);
                o.color = ambient + diffuse;
                return o;
            }

            fixed4 frag( v2f i): SV_Target
            {
                return fixed4(i.color, 1);
            }

            ENDCG
        }
    }
}
