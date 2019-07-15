Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC01B6825F
	for <lists+stable@lfdr.de>; Mon, 15 Jul 2019 04:55:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728921AbfGOCzs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 14 Jul 2019 22:55:48 -0400
Received: from mail-eopbgr50081.outbound.protection.outlook.com ([40.107.5.81]:15000
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726025AbfGOCzs (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 14 Jul 2019 22:55:48 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NfSAbomGBhbPDUsGHK1oKeleeb0WsyVlThxvnjGtFt0az7yeXexqDEzdtfg7RImqGgFkdeX2XwOtP6szXZXk0cZxMRpLerGV6sfj5vjJQxGi3OgrqUuVe3vcddCCNRJVhYZ2kY7p5mGrBgW71hGsVglY9pM5BuOfVCF2j5TpAE38e+JMfJzWlgrCcgsyCxiRdcZAyZ4/uZmz90+FpXy+hUlorPIUbSsVl++bfmXV0PpNcXEovr7Uxczylqidbq31Doak+nCjfY9zZwVxFgzpImDir9yEa5R1X8vdpdGFtglmGp/ypvYhNrmY8wwU6KyjKfXdX4NXrd51j8rv+5ZChA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jQoQKyp9ZpO6n6q0pUNdmkgFUgmV18JgaRhoA7DI/B4=;
 b=nTv+ohY/DEUg8kRl39fWdoWhE1wpXUL8vtmNSOlHsMFB+TL0l/j2ZFhm1bD9yoFUu5r4vlNbNw1VIaCsadIg15CoFOa0YlISgdBpGh08LekUvHl26sTg/agmZg6cllji2E6tyImxlRq1LtX+7O9gBXTIWIFAAH1yC129+pOV7DQ0r24kAGl3nkxJFiJgiQviu6kXUW358zNz9JIUNc6pvDMZwljLihnDM5y7WSvCjYJbNvqKTwaVr8qP11OcPu/pHjDj2qt1RZcS/twxlMAr7zgb1PVcBHfEAHk6nbD62mLmDJFqJ28IlrMM+VOvQOG+VaZl9TsuArRCKcScDnXt0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=nxp.com;dmarc=pass action=none header.from=nxp.com;dkim=pass
 header.d=nxp.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jQoQKyp9ZpO6n6q0pUNdmkgFUgmV18JgaRhoA7DI/B4=;
 b=DgR8Muusg64+okD7qMR0FhWOJPiV1rl7+MCclTjEz4HKur3GLJlpC8P6c/eXY0OEZgu3GpK+Jk8c5iasgbRuU76hkkmVosh05wDavXzuyE4Jif52VqOMfBzI+YEgOyZnbXBBMRhba1AbnAqk1RUxgtB+YM95J11rHRze83byMIg=
Received: from AM0PR04MB4481.eurprd04.prod.outlook.com (52.135.147.15) by
 AM0PR04MB4564.eurprd04.prod.outlook.com (52.135.149.14) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2073.14; Mon, 15 Jul 2019 02:55:43 +0000
Received: from AM0PR04MB4481.eurprd04.prod.outlook.com
 ([fe80::2023:c0e5:8a63:2e47]) by AM0PR04MB4481.eurprd04.prod.outlook.com
 ([fe80::2023:c0e5:8a63:2e47%5]) with mapi id 15.20.2052.020; Mon, 15 Jul 2019
 02:55:43 +0000
From:   Peng Fan <peng.fan@nxp.com>
To:     "mturquette@baylibre.com" <mturquette@baylibre.com>,
        "sboyd@kernel.org" <sboyd@kernel.org>,
        "shawnguo@kernel.org" <shawnguo@kernel.org>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "festevam@gmail.com" <festevam@gmail.com>
CC:     dl-linux-imx <linux-imx@nxp.com>,
        Leonard Crestez <leonard.crestez@nxp.com>,
        Anson Huang <anson.huang@nxp.com>,
        Jacky Bai <ping.bai@nxp.com>,
        "linux-clk@vger.kernel.org" <linux-clk@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "van.freenix@gmail.com" <van.freenix@gmail.com>,
        Peng Fan <peng.fan@nxp.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: [PATCH] clk: imx: imx8mm: fix audio pll setting
Thread-Topic: [PATCH] clk: imx: imx8mm: fix audio pll setting
Thread-Index: AQHVOrjKqRILo4kj1ESmmUTSG4SPJQ==
Date:   Mon, 15 Jul 2019 02:55:43 +0000
Message-ID: <1563157783-31846-1-git-send-email-peng.fan@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.7.4
x-clientproxiedby: HK0P153CA0011.APCP153.PROD.OUTLOOK.COM
 (2603:1096:203:18::23) To AM0PR04MB4481.eurprd04.prod.outlook.com
 (2603:10a6:208:70::15)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=peng.fan@nxp.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [119.31.174.66]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 90be77a5-80e8-46e5-3808-08d708cfed30
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM0PR04MB4564;
x-ms-traffictypediagnostic: AM0PR04MB4564:
x-microsoft-antispam-prvs: <AM0PR04MB4564B49C82BE0F3BEDD7621388CF0@AM0PR04MB4564.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-forefront-prvs: 00997889E7
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(136003)(39860400002)(396003)(346002)(376002)(189003)(199004)(2201001)(2501003)(68736007)(6506007)(26005)(386003)(6486002)(36756003)(86362001)(52116002)(316002)(54906003)(110136005)(6436002)(102836004)(7736002)(305945005)(14454004)(7416002)(64756008)(66476007)(71200400001)(71190400001)(66556008)(66446008)(50226002)(2906002)(25786009)(3846002)(66066001)(476003)(81166006)(99286004)(486006)(81156014)(8936002)(66946007)(2616005)(6116002)(8676002)(53936002)(256004)(5660300002)(478600001)(14444005)(186003)(4326008)(44832011)(6512007)(32563001);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR04MB4564;H:AM0PR04MB4481.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: iGmtbuVmqbZwSo+3xdRAWGERNJlEMF4DsReAv1XgDb7R7PW+w64qLwOfNLc4EmFcR/+8kNViCp/U573YStXKw3yHvC6nfSHwliIuowWWCKi0Yvg5rfJCx2AgJ7CjPyn/JCSmFmXbLBFdeoF6Bghu5Ib3GLjylKLB+gDUOvHlyN3hg8Q+OP0dJi96ccT5Pmw6iU/M28h8epNsIM9SxxeVohxFl15QjXzIFGMdw+l4Pqi4OSTrlye3X+b0UDMZRjA+vRoQFuBMyIyF7XydlUFnWq3IUfztnj0SxVyDcgOqvo3fdPQy8M8y+G+7X8fvUaK/IpdN8aq0in5uqg79o0qLWomwGb0Nko5Uatm4LTrw+lFUTAqbDM5rUmQ90CeD9lCE1s6flTswwjA6wiON+/h97cXQ7EbV4JkTdGxsdPOeCJs=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 90be77a5-80e8-46e5-3808-08d708cfed30
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jul 2019 02:55:43.0365
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: peng.fan@nxp.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB4564
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peng Fan <peng.fan@nxp.com>

The AUDIO PLL max support 650M, so the original clk settings violate
spec. This patch makes the output 786432000 -> 393216000,
and 722534400 -> 361267200 to aligned with NXP vendor kernel without any
impact on audio functionality and go within 650MHz PLL limit.

Cc: <stable@vger.kernel.org>
Fixes: ba5625c3e272 ("clk: imx: Add clock driver support for imx8mm")
Signed-off-by: Peng Fan <peng.fan@nxp.com>
---
 drivers/clk/imx/clk-imx8mm.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/imx/clk-imx8mm.c b/drivers/clk/imx/clk-imx8mm.c
index 3a873e0e278f..b72bad064d8d 100644
--- a/drivers/clk/imx/clk-imx8mm.c
+++ b/drivers/clk/imx/clk-imx8mm.c
@@ -55,8 +55,8 @@ static const struct imx_pll14xx_rate_table imx8mm_pll1416=
x_tbl[] =3D {
 };
=20
 static const struct imx_pll14xx_rate_table imx8mm_audiopll_tbl[] =3D {
-	PLL_1443X_RATE(786432000U, 655, 5, 2, 23593),
-	PLL_1443X_RATE(722534400U, 301, 5, 1, 3670),
+	PLL_1443X_RATE(393216000U, 262, 2, 3, 9437),
+	PLL_1443X_RATE(361267200U, 361, 3, 3, 17511),
 };
=20
 static const struct imx_pll14xx_rate_table imx8mm_videopll_tbl[] =3D {
--=20
2.16.4

