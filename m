Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4970B139FD4
	for <lists+stable@lfdr.de>; Tue, 14 Jan 2020 04:17:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729728AbgANDRy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jan 2020 22:17:54 -0500
Received: from mail-eopbgr70042.outbound.protection.outlook.com ([40.107.7.42]:12741
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729072AbgANDRx (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Jan 2020 22:17:53 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Roo+m7FyyVLXvj4alQZAJeOu8xqGZiaST+gswVbPlWLjEtj9TZS0QKHYvap+GIefBhdwDxII08ABp2bHuorWjbzAgugURvBpFxJ0NavyNm2iGv89OpUTx0Gbd01I6mMq7CnZxtSI6zCUjlZPixCVY72b8eC6cBS6WhLKptda21BBEujV2SIkZ6H78upE5gY5Rw6EmH8dX5T/j23fyZGpStKtikfw4ayK1ABKVB2wqIG2N8QsuM9lxfx5vI7pHYF2gYXtRZqsWQ9rnTPPvaCMMffkipvLNwnebeE/vcY06eBE8Yl1JF4sggaDbbWYieMU3jG8+dFe1fmOe015nPXa1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bd41YTO7V2vcKq1lyuaUJUAGRBryQvukGajgNO7u/Vw=;
 b=Cc3jybfCDUoIiFX3upUo6XdhmeeAC3/s6LgUN+aYwSTvUrWVv+b7tC7vH51LOk+44SLW2vV3726kvzF568IA9G1oLrW+xuFnWUaq13i6IFJK7EUtXmcad7rSKLdV8dkFe2Wc1JEA1qAiXNqKANmvne/0Gs4LqPB3WirnEdQJPm5ZLo6CAC9glVqzK/gR80I+1MmYRZXDO081Qqa5JtAYfjSB+5RE+1QqJ7Fx7tY2oQjSyOuKtJtDNnYrzUDb10x5Sv13WDJwTeyy6adpZSHcrCABeB57QSNjKWphKO7dMqlsAQHg6HOL3F+q+6OOzqP21Corju+0GXjLOXEv1RHF1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bd41YTO7V2vcKq1lyuaUJUAGRBryQvukGajgNO7u/Vw=;
 b=fkW8VVzkGlkChmjjtUcJRXR8tSHaXATco9i0ZAq8i8Q6JgBuOwbvgbMiFRAAGy0HxkqADITwRiaJequIVOfiHXO7DPdrNtgEKjOTkA5vHwBTqfg68+8T2N6M+myFFEBhTjPHhjN1J1SoMsy0ltHvHnrWX7TLoH5K8nvK3g8rvZ0=
Received: from AM0PR04MB4481.eurprd04.prod.outlook.com (52.135.147.15) by
 AM0PR04MB6755.eurprd04.prod.outlook.com (20.179.252.75) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2623.11; Tue, 14 Jan 2020 03:17:49 +0000
Received: from AM0PR04MB4481.eurprd04.prod.outlook.com
 ([fe80::91e2:17:b3f4:d422]) by AM0PR04MB4481.eurprd04.prod.outlook.com
 ([fe80::91e2:17:b3f4:d422%3]) with mapi id 15.20.2623.015; Tue, 14 Jan 2020
 03:17:49 +0000
Received: from localhost.localdomain (119.31.174.66) by HK2PR0302CA0002.apcprd03.prod.outlook.com (2603:1096:202::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.20.2644.6 via Frontend Transport; Tue, 14 Jan 2020 03:17:44 +0000
From:   Peng Fan <peng.fan@nxp.com>
To:     "sboyd@kernel.org" <sboyd@kernel.org>,
        "shawnguo@kernel.org" <shawnguo@kernel.org>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        "festevam@gmail.com" <festevam@gmail.com>,
        Abel Vesa <abel.vesa@nxp.com>,
        Leonard Crestez <leonard.crestez@nxp.com>
CC:     "kernel@pengutronix.de" <kernel@pengutronix.de>,
        dl-linux-imx <linux-imx@nxp.com>,
        Aisheng Dong <aisheng.dong@nxp.com>,
        "linux-clk@vger.kernel.org" <linux-clk@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Anson Huang <anson.huang@nxp.com>,
        Jacky Bai <ping.bai@nxp.com>,
        "l.stach@pengutronix.de" <l.stach@pengutronix.de>,
        Peng Fan <peng.fan@nxp.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: [PATCH 1/4] clk: imx: imx8mq: fix a53 cpu clock
Thread-Topic: [PATCH 1/4] clk: imx: imx8mq: fix a53 cpu clock
Thread-Index: AQHVyokzBaGSUiSHrEmXWJ8R7ZCvJA==
Date:   Tue, 14 Jan 2020 03:17:49 +0000
Message-ID: <1578971599-4277-2-git-send-email-peng.fan@nxp.com>
References: <1578971599-4277-1-git-send-email-peng.fan@nxp.com>
In-Reply-To: <1578971599-4277-1-git-send-email-peng.fan@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.7.4
x-clientproxiedby: HK2PR0302CA0002.apcprd03.prod.outlook.com
 (2603:1096:202::12) To AM0PR04MB4481.eurprd04.prod.outlook.com
 (2603:10a6:208:70::15)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=peng.fan@nxp.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [119.31.174.66]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 359d0b08-f4c2-4cbd-b739-08d798a0559c
x-ms-traffictypediagnostic: AM0PR04MB6755:|AM0PR04MB6755:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM0PR04MB67554EE8C153762F0D82D3E588340@AM0PR04MB6755.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3173;
x-forefront-prvs: 028256169F
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(136003)(396003)(376002)(366004)(346002)(199004)(189003)(6506007)(478600001)(4326008)(2906002)(66556008)(66476007)(16526019)(64756008)(66446008)(186003)(66946007)(81156014)(81166006)(6512007)(26005)(5660300002)(52116002)(8676002)(6486002)(71200400001)(2616005)(956004)(8936002)(86362001)(36756003)(69590400006)(7416002)(316002)(110136005)(54906003)(44832011)(6636002)(32563001);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR04MB6755;H:AM0PR04MB4481.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 5h3gDqRpSWli+BJfu92ZRgcoCLsZ9htcooKvtug6pxBzbNWFmu5btCZMq+vWNaVc7H6IVMYJVOc/ERDTFzJpqt8a0xk54cigZyrieopdbgV2ljOkc2nkfzkGGOrnVmU2OeFi50wRR3m9lUgBt/PjTK4fwXnPOIbslM8+KFTqTaBKaq6A5ANbreEEUQRys32UVU5yvz2nTMHZ1Lk/xHN15sz/OX4aStnPlK2ig3opAvh7/74aQwmwSWWb3RUOd9zbcaIqX8p7qd4IcxFp7ZEWfQkDZGmqRH/2MrEXu3BklKAkf+oruPZhsa2eBwRyn4SzyloB64lqvhqPZkkqALZNz41f4Qu7BAid4fnGNYiNGqj0GQZBhOEws1OKOJkpesp7DfyvGhQ7lXQzCD5CXtepXNftSedE4iMVvzg8eOzL4yk48iq5S8jBVsduXkLws6bfbqGNKBCAbFJHG1jQso2IG2l5FzJeDAInkgTTgrUI1AQ6FBfL324qjnAz41gX2vhit9Z6O6GRaEzWofIKqaLmfQ==
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 359d0b08-f4c2-4cbd-b739-08d798a0559c
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Jan 2020 03:17:49.7626
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +KWK3+ErCUqwaZamN1TLB22R4CUhR/4UEPmuuqNSsJ0BvTXwF3oZ+vL3+MrC9h/yxyFXQ1svJ3Zo6aZh+nu4nw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB6755
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peng Fan <peng.fan@nxp.com>

The A53 CCM clk root only accepts input up to 1GHz, CCM A53 root
signoff timing is 1Ghz, however the A53 core which sources from CCM
root could run above 1GHz which voilates the CCM.

There is a CORE_SEL slice before A53 core, we need configure the
CORE_SEL slice source from ARM PLL, not A53 CCM clk root.

The A53 CCM clk root should only be used when need to change ARM PLL
frequency.

Add arm_a53_core clk that could source from arm_a53_div and arm_pll_out.
Configure a53 ccm root sources from 800MHz sys pll
Configure a53 core sources from arm_pll_out
Mark arm_a53_core as critical clock

Fixes: db27e40b27f1 ("clk: imx8mq: Add the missing ARM clock")
Cc: stable@vger.kernel.org
Reviewed-by: Jacky Bai <ping.bai@nxp.com>
Signed-off-by: Peng Fan <peng.fan@nxp.com>
---
 drivers/clk/imx/clk-imx8mq.c             | 16 ++++++++++++----
 include/dt-bindings/clock/imx8mq-clock.h |  4 +++-
 2 files changed, 15 insertions(+), 5 deletions(-)

diff --git a/drivers/clk/imx/clk-imx8mq.c b/drivers/clk/imx/clk-imx8mq.c
index b031183ff427..82a16b8e98a9 100644
--- a/drivers/clk/imx/clk-imx8mq.c
+++ b/drivers/clk/imx/clk-imx8mq.c
@@ -41,6 +41,8 @@ static const char * const video2_pll_out_sels[] =3D {"vid=
eo2_pll1_ref_sel", };
 static const char * const imx8mq_a53_sels[] =3D {"osc_25m", "arm_pll_out",=
 "sys2_pll_500m", "sys2_pll_1000m",
 					"sys1_pll_800m", "sys1_pll_400m", "audio_pll1_out", "sys3_pll_out", }=
;
=20
+static const char * const imx8mq_a53_core_sels[] =3D {"arm_a53_div", "arm_=
pll_out", };
+
 static const char * const imx8mq_arm_m4_sels[] =3D {"osc_25m", "sys2_pll_2=
00m", "sys2_pll_250m", "sys1_pll_266m",
 					"sys1_pll_800m", "audio_pll1_out", "video_pll1_out", "sys3_pll_out", =
};
=20
@@ -411,6 +413,9 @@ static int imx8mq_clocks_probe(struct platform_device *=
pdev)
 	hws[IMX8MQ_CLK_GPU_CORE_DIV] =3D imx8m_clk_hw_composite_core("gpu_core_di=
v", imx8mq_gpu_core_sels, base + 0x8180);
 	hws[IMX8MQ_CLK_GPU_SHADER_DIV] =3D imx8m_clk_hw_composite("gpu_shader_div=
", imx8mq_gpu_shader_sels, base + 0x8200);
=20
+	/* CORE SEL */
+	hws[IMX8MQ_CLK_A53_CORE] =3D imx_clk_hw_mux2_flags("arm_a53_core", base +=
 0x9880, 24, 1, imx8mq_a53_core_sels, ARRAY_SIZE(imx8mq_a53_core_sels), CLK=
_IS_CRITICAL);
+
 	/* BUS */
 	hws[IMX8MQ_CLK_MAIN_AXI] =3D imx8m_clk_hw_composite_critical("main_axi", =
imx8mq_main_axi_sels, base + 0x8800);
 	hws[IMX8MQ_CLK_ENET_AXI] =3D imx8m_clk_hw_composite("enet_axi", imx8mq_en=
et_axi_sels, base + 0x8880);
@@ -574,11 +579,14 @@ static int imx8mq_clocks_probe(struct platform_device=
 *pdev)
 	hws[IMX8MQ_GPT_3M_CLK] =3D imx_clk_hw_fixed_factor("gpt_3m", "osc_25m", 1=
, 8);
 	hws[IMX8MQ_CLK_DRAM_ALT_ROOT] =3D imx_clk_hw_fixed_factor("dram_alt_root"=
, "dram_alt", 1, 4);
=20
-	hws[IMX8MQ_CLK_ARM] =3D imx_clk_hw_cpu("arm", "arm_a53_div",
-					   hws[IMX8MQ_CLK_A53_DIV]->clk,
-					   hws[IMX8MQ_CLK_A53_SRC]->clk,
+	clk_hw_set_parent(hws[IMX8MQ_CLK_A53_SRC], hws[IMX8MQ_SYS1_PLL_800M]);
+	clk_hw_set_parent(hws[IMX8MQ_CLK_A53_CORE], hws[IMX8MQ_ARM_PLL_OUT]);
+
+	hws[IMX8MQ_CLK_ARM] =3D imx_clk_hw_cpu("arm", "arm_a53_core",
+					   hws[IMX8MQ_CLK_A53_CORE]->clk,
+					   hws[IMX8MQ_CLK_A53_CORE]->clk,
 					   hws[IMX8MQ_ARM_PLL_OUT]->clk,
-					   hws[IMX8MQ_SYS1_PLL_800M]->clk);
+					   hws[IMX8MQ_CLK_A53_DIV]->clk);
=20
 	imx_check_clk_hws(hws, IMX8MQ_CLK_END);
=20
diff --git a/include/dt-bindings/clock/imx8mq-clock.h b/include/dt-bindings=
/clock/imx8mq-clock.h
index 3bab9b21c8d7..ac71e9e502b8 100644
--- a/include/dt-bindings/clock/imx8mq-clock.h
+++ b/include/dt-bindings/clock/imx8mq-clock.h
@@ -424,6 +424,8 @@
 #define IMX8MQ_SYS2_PLL_500M_CG			283
 #define IMX8MQ_SYS2_PLL_1000M_CG		284
=20
-#define IMX8MQ_CLK_END				285
+#define IMX8MQ_CLK_A53_CORE			285
+
+#define IMX8MQ_CLK_END				286
=20
 #endif /* __DT_BINDINGS_CLOCK_IMX8MQ_H */
--=20
2.16.4

