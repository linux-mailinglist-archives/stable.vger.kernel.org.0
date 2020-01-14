Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 20724139FDA
	for <lists+stable@lfdr.de>; Tue, 14 Jan 2020 04:18:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729652AbgANDSG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jan 2020 22:18:06 -0500
Received: from mail-eopbgr70085.outbound.protection.outlook.com ([40.107.7.85]:2913
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729668AbgANDSG (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Jan 2020 22:18:06 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W3XW+1uCmXabdtyXC5h0OkpKz8YE6SHpGSc4M2ZTsVTCTM3pS+lrVXJxIgAGqC9yFftmQJ5SmzFcOBMO4v6pFqkZ2o5UDK1LbWQ695f6of9hPcpXUn00DXWDJEuB539MOyDCVpoT7i6qdvYlsR54ClYVY1C4jsT956Nzii7iAWjIAhOkvIiVC12XSQ2mhzQeozgLreIxXrLY9Xn+/Tfo3Pm+buE9vNo3dhbQqlduEVN+OEOjhWmwFx6IovHFhFV+5aKLTv9tLiLyVAJO0Dt519BAehxbtdJe+SLGh96i8rBp4a3V4di9X+RzvDjsYqVPAetCDip8XJuxlaoMoikLjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/J/t03lXe/mby0Ojg8UGgZC/VdbcD/9A/O1K1wB3tSQ=;
 b=lFe0x4WSECcChl2KGCd2N+zPGA/v5DFgdDrUCrv6/I01SdjngFLDuZommIZOEUcGWZn++ITOT9brSt7xNNMxsua/eb7dvn8e9eKUQOD4orYzQa9Q4Qrs6vyfKbor0F5Uy2h+qN6RacwJ1donFiHnVsDM08/Yk3AWGOlxwG5qgUZxjkYkq4y70lwdl+WnJASRnjhz8lkEa08ydEgbfwWuJkudfCnS1nldgT+LTfUOLrabAq4qTA0k8xZZzhk2Fw6mRCGhWDKBayeSlLJyHiXUH+DG/sQMZMbUMteUbu5+zSMo01TRQH3zXJWqB29WQ2zZVoUGPDChI2h2iwM6yZB0RA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/J/t03lXe/mby0Ojg8UGgZC/VdbcD/9A/O1K1wB3tSQ=;
 b=aaTHZjWiCJN5wKkoQ2wyVtvpi3sM8f2lzgiJCSnUa1eVJozMINDO0Sjo6NbG2wGF30Q+TUXPS/ZBWCFCIwv/T4BJDhP7fjCVpkBm5J1xXeVDEgwf9tqFjFHyKjo22byg09BqQ4zgfD2QaFZiyuREMJEOx0GTooD77m/i9TbSIkU=
Received: from AM0PR04MB4481.eurprd04.prod.outlook.com (52.135.147.15) by
 AM0PR04MB6755.eurprd04.prod.outlook.com (20.179.252.75) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2623.11; Tue, 14 Jan 2020 03:18:02 +0000
Received: from AM0PR04MB4481.eurprd04.prod.outlook.com
 ([fe80::91e2:17:b3f4:d422]) by AM0PR04MB4481.eurprd04.prod.outlook.com
 ([fe80::91e2:17:b3f4:d422%3]) with mapi id 15.20.2623.015; Tue, 14 Jan 2020
 03:18:02 +0000
Received: from localhost.localdomain (119.31.174.66) by HK2PR0302CA0002.apcprd03.prod.outlook.com (2603:1096:202::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.20.2644.6 via Frontend Transport; Tue, 14 Jan 2020 03:17:56 +0000
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
Subject: [PATCH 3/4] clk: imx: imx8mn: fix a53 cpu clock
Thread-Topic: [PATCH 3/4] clk: imx: imx8mn: fix a53 cpu clock
Thread-Index: AQHVyok6naombU1qmk27o48yvh/8Qw==
Date:   Tue, 14 Jan 2020 03:18:02 +0000
Message-ID: <1578971599-4277-4-git-send-email-peng.fan@nxp.com>
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
x-ms-office365-filtering-correlation-id: 548e0b29-a0c1-4f23-3369-08d798a05d27
x-ms-traffictypediagnostic: AM0PR04MB6755:|AM0PR04MB6755:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM0PR04MB67558219F590AA61780E708888340@AM0PR04MB6755.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5516;
x-forefront-prvs: 028256169F
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(136003)(396003)(376002)(366004)(346002)(199004)(189003)(6506007)(478600001)(4326008)(2906002)(66556008)(66476007)(16526019)(64756008)(66446008)(186003)(66946007)(81156014)(81166006)(6512007)(26005)(6666004)(5660300002)(52116002)(8676002)(6486002)(71200400001)(2616005)(956004)(8936002)(86362001)(36756003)(69590400006)(7416002)(316002)(110136005)(54906003)(44832011)(6636002)(32563001);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR04MB6755;H:AM0PR04MB4481.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: voNxWwdgd9MjlXEOW8fzR2RYc7NenOtRiZ/KlnYWOg3XcsKbTxk2SdxXrsODCF5pwXRYVUYcmJUZ3bldmj/W6scyz/ToYL66xUjcbmyH5RyKcbsUkPzG0PPsGXzXjxYDT7I0AjPti4+QU1WTExbk36hkAKqOySjpjtC75g/i8eKwNs1pD4fHBRDJ7zaSBOt2GbxprJCwXiT9Pd31WIQFhEaVfpYh2pKbUhJAiUslaV/RRQItOdTJYBNFGCWI0KY2fLc6n2nZZnQ8RbFUCArrgq1DFgUl47n9h951j9sTOrF7+4e9uEPQj59o3B0MfucWX1UCf8k9CclJ8UQho26w+d33dzgAYNpyRmFfYP2N9McvJHqwcTEVLm29QYeTxsRSuKAHLgzw/HVJ7DXQSEIgExpGCKYnvFL/gA1r5Jg76IR6/tUXg/ZnLDT/E4OyZAkJ6vcxj0AZPkiBuWOkKWrhNTol6l+j0YIZuBLOYn5RIoI9b1CeKabT8N9U8XF/6RAx/Y/lvfcNq+i0H6sjM5x9oA==
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 548e0b29-a0c1-4f23-3369-08d798a05d27
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Jan 2020 03:18:02.3962
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gXjdXVBaUVuYhp0rPmKqE5SXYmqCbchZpK4dcolJhRsJ+5sJcnrUCW+d6FIAYzQX3fnBwJnxU1TB6YRSlYApsA==
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
Mark arm_a53_core as critical clk.

Fixes: 96d6392b54db ("clk: imx: Add support for i.MX8MN clock driver")
Cc: stable@vger.kernel.org
Reviewed-by: Jacky Bai <ping.bai@nxp.com>
Signed-off-by: Peng Fan <peng.fan@nxp.com>
---
 drivers/clk/imx/clk-imx8mn.c             | 16 ++++++++++++----
 include/dt-bindings/clock/imx8mn-clock.h |  4 +++-
 2 files changed, 15 insertions(+), 5 deletions(-)

diff --git a/drivers/clk/imx/clk-imx8mn.c b/drivers/clk/imx/clk-imx8mn.c
index ce2ba3dce483..01c1034834fc 100644
--- a/drivers/clk/imx/clk-imx8mn.c
+++ b/drivers/clk/imx/clk-imx8mn.c
@@ -40,6 +40,8 @@ static const char * const imx8mn_a53_sels[] =3D {"osc_24m=
", "arm_pll_out", "sys_pl
 					       "sys_pll2_1000m", "sys_pll1_800m", "sys_pll1_400m",
 					       "audio_pll1_out", "sys_pll3_out", };
=20
+static const char * const imx8mn_a53_core_sels[] =3D {"arm_a53_div", "arm_=
pll_out", };
+
 static const char * const imx8mn_gpu_core_sels[] =3D {"osc_24m", "gpu_pll_=
out", "sys_pll1_800m",
 						    "sys_pll3_out", "sys_pll2_1000m", "audio_pll1_out",
 						    "video_pll1_out", "audio_pll2_out", };
@@ -419,6 +421,9 @@ static int imx8mn_clocks_probe(struct platform_device *=
pdev)
 	hws[IMX8MN_CLK_GPU_CORE_DIV] =3D imx8m_clk_hw_composite_core("gpu_core_di=
v", imx8mn_gpu_core_sels, base + 0x8180);
 	hws[IMX8MN_CLK_GPU_SHADER_DIV] =3D imx8m_clk_hw_composite_core("gpu_shade=
r_div", imx8mn_gpu_shader_sels, base + 0x8200);
=20
+	/* CORE SEL */
+	hws[IMX8MN_CLK_A53_CORE] =3D imx_clk_hw_mux2_flags("arm_a53_core", base +=
 0x9880, 24, 1, imx8mn_a53_core_sels, ARRAY_SIZE(imx8mn_a53_core_sels), CLK=
_IS_CRITICAL);
+
 	/* BUS */
 	hws[IMX8MN_CLK_MAIN_AXI] =3D imx8m_clk_hw_composite_critical("main_axi", =
imx8mn_main_axi_sels, base + 0x8800);
 	hws[IMX8MN_CLK_ENET_AXI] =3D imx8m_clk_hw_composite("enet_axi", imx8mn_en=
et_axi_sels, base + 0x8880);
@@ -547,11 +552,14 @@ static int imx8mn_clocks_probe(struct platform_device=
 *pdev)
=20
 	hws[IMX8MN_CLK_DRAM_ALT_ROOT] =3D imx_clk_hw_fixed_factor("dram_alt_root"=
, "dram_alt", 1, 4);
=20
-	hws[IMX8MN_CLK_ARM] =3D imx_clk_hw_cpu("arm", "arm_a53_div",
-					   hws[IMX8MN_CLK_A53_DIV]->clk,
-					   hws[IMX8MN_CLK_A53_SRC]->clk,
+	clk_hw_set_parent(hws[IMX8MN_CLK_A53_SRC], hws[IMX8MN_SYS_PLL1_800M]);
+	clk_hw_set_parent(hws[IMX8MN_CLK_A53_CORE], hws[IMX8MN_ARM_PLL_OUT]);
+
+	hws[IMX8MN_CLK_ARM] =3D imx_clk_hw_cpu("arm", "arm_a53_core",
+					   hws[IMX8MN_CLK_A53_CORE]->clk,
+					   hws[IMX8MN_CLK_A53_CORE]->clk,
 					   hws[IMX8MN_ARM_PLL_OUT]->clk,
-					   hws[IMX8MN_SYS_PLL1_800M]->clk);
+					   hws[IMX8MN_CLK_A53_DIV]->clk);
=20
 	imx_check_clk_hws(hws, IMX8MN_CLK_END);
=20
diff --git a/include/dt-bindings/clock/imx8mn-clock.h b/include/dt-bindings=
/clock/imx8mn-clock.h
index 0f2b8423ce1d..7ec4c24d6e06 100644
--- a/include/dt-bindings/clock/imx8mn-clock.h
+++ b/include/dt-bindings/clock/imx8mn-clock.h
@@ -228,6 +228,8 @@
 #define IMX8MN_SYS_PLL2_333M_CG			209
 #define IMX8MN_SYS_PLL2_500M_CG			210
=20
-#define IMX8MN_CLK_END				211
+#define IMX8MN_CLK_A53_CORE			211
+
+#define IMX8MN_CLK_END				212
=20
 #endif
--=20
2.16.4

