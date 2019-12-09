Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E38511680D
	for <lists+stable@lfdr.de>; Mon,  9 Dec 2019 09:20:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727163AbfLIIUB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Dec 2019 03:20:01 -0500
Received: from mail-eopbgr30055.outbound.protection.outlook.com ([40.107.3.55]:33891
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727084AbfLIIUB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Dec 2019 03:20:01 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A01GesBGeY3+jGz4ge0MqBK0dZNm00mOGKIs/d7L+wFVLuOHgO8843Cq4gzjchnTQCgju3NlYO5/844pCxEc0JnGdNBvXZoxOO/0nYXKW5gZgqPz5Sp1iNlkeoIcFPGNu61kTo2dwHNg6LHTTeifFbxclBkWIbhkq9bm2t9Gx9upnjxBWq3W8Ih8VTloMNZXu+CDvgabI7r8IFUxKO5OgcTkyPRjcHGIqCANasiJo9BKFtiDDO/AzVE92AcD3O8wFfri2GDiDXdHuGJm+YSUXXcSjqYy2vV3bRhih2G8oOL7KvBmjyAcfSYZSepmSm6bhJ+bIOc+Iw/BHfO81RQnHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V/0nlNRR4KsLmjhSPFU0wvPfWw8ccbIg1qKl7F9TlC8=;
 b=f7SgTj3BdGgBQOgQig/CboQN0/mWqevHYWceMMTUCVecfECXLMf6jgEbaKEYHAhUYSJ8sNs5TTjfXcvEng/ai8ivh95vrSdNbtsW1aMeEwDdq4LVpo69LQLN2eu3PcblEs7qxHUVq4+u1rODohsyN797au6Regxbddp2AfxLOsOkpmMIkV0jk3Yo1bCtqG5dZ+KJQe25IjwnX6G+j3njzmC6dnAH2+6v9tq0COwXHRp7tSs6rD0XsIgUZInmAYDVPuxPSxEvlMOuVIGxFC4cT66zD9t2siA+bjdhjhGxpM+9+9LQcMRU62Jy+LPzmyaUO6+1UArlNRfhzW7mPxQwdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V/0nlNRR4KsLmjhSPFU0wvPfWw8ccbIg1qKl7F9TlC8=;
 b=SC3tCdn2cBgz+uk0FrQpiMxdXlRZNPPGlweIN3UroDwEX8YMonNR7V32motrP28Do7mbkO/WWr88igVzLIHEhG4t4Xxwp4izZFV66m/c2ZOt2H8A/bFLcDtK8wdzm3WfsQtrG3So0zM02Hdf5ot1RUS2kkd/Qf6eJKB+Zdy+3xY=
Received: from AM0PR04MB4481.eurprd04.prod.outlook.com (52.135.147.15) by
 AM0PR04MB5123.eurprd04.prod.outlook.com (20.176.214.81) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2516.12; Mon, 9 Dec 2019 08:19:55 +0000
Received: from AM0PR04MB4481.eurprd04.prod.outlook.com
 ([fe80::505:87e7:6b49:3d29]) by AM0PR04MB4481.eurprd04.prod.outlook.com
 ([fe80::505:87e7:6b49:3d29%7]) with mapi id 15.20.2516.018; Mon, 9 Dec 2019
 08:19:55 +0000
From:   Peng Fan <peng.fan@nxp.com>
To:     "sboyd@kernel.org" <sboyd@kernel.org>,
        "shawnguo@kernel.org" <shawnguo@kernel.org>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        "festevam@gmail.com" <festevam@gmail.com>,
        Abel Vesa <abel.vesa@nxp.com>
CC:     "kernel@pengutronix.de" <kernel@pengutronix.de>,
        dl-linux-imx <linux-imx@nxp.com>,
        Aisheng Dong <aisheng.dong@nxp.com>,
        "linux-clk@vger.kernel.org" <linux-clk@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Leonard Crestez <leonard.crestez@nxp.com>,
        Peng Fan <peng.fan@nxp.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: [PATCH V2] clk: imx: pll14xx: fix clk_pll14xx_wait_lock
Thread-Topic: [PATCH V2] clk: imx: pll14xx: fix clk_pll14xx_wait_lock
Thread-Index: AQHVrmlwcc3x7P8/l0KrSdq2pbgfNA==
Date:   Mon, 9 Dec 2019 08:19:55 +0000
Message-ID: <1575879445-15386-1-git-send-email-peng.fan@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.7.4
x-clientproxiedby: HK2PR03CA0065.apcprd03.prod.outlook.com
 (2603:1096:202:17::35) To AM0PR04MB4481.eurprd04.prod.outlook.com
 (2603:10a6:208:70::15)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=peng.fan@nxp.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [119.31.174.66]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 422d5345-ed97-4948-1e84-08d77c80928f
x-ms-traffictypediagnostic: AM0PR04MB5123:|AM0PR04MB5123:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM0PR04MB5123FCD5915FF4D731CB9A3E88580@AM0PR04MB5123.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:497;
x-forefront-prvs: 02462830BE
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(136003)(39860400002)(376002)(396003)(366004)(189003)(199004)(86362001)(478600001)(99286004)(6636002)(66556008)(66476007)(305945005)(2906002)(5660300002)(6486002)(54906003)(110136005)(66446008)(64756008)(4744005)(316002)(36756003)(8676002)(44832011)(2616005)(6506007)(186003)(52116002)(6512007)(4326008)(50226002)(102836004)(66946007)(26005)(8936002)(81166006)(81156014)(71200400001)(71190400001);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR04MB5123;H:AM0PR04MB4481.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: nlvcYqQGmh57h6cyRUJrklFdRNq//zRXD6Wv1AckfX7sBV+ol9cx/uBcHsoqsHHr4RqcLOpEUCtzxZSoC2WxQdVlnuQWBmIqvoEQvBzcbf5OdEt8BMMaeORQmHcaJGuLd44B8Yamq63DwBH1D+sWEEERbb9A7dsl+skZPK3KDA8H9sX7TUcrGPxDZUwZvYggwYzBpzVPyuDp3C6j2m6PL3KRrwkfkdbyxsbeHj2tc74OPw4XJIcpl+N99FKFu9OAHCcSMBl4ifxLy/I6QNBY4S02eoIyj5NYedDm9w/65Wmb43QhDL9V2XTeRaEdRFdb9T46qHVItL2YSW6G7yMx12JJCJgfkEeGZk5xrGTqkYH7h6j2O4/d/HKK9iAul01+6WWLboDCMrHe8Quu29HBFwnAg2kGYX6X+l/fBOKn1SmvVH4JRx2ehl/fUwI/dJTP
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 422d5345-ed97-4948-1e84-08d77c80928f
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Dec 2019 08:19:55.6283
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rFA4Y43uULC2pAP7QYKWszpu0DsZYwip+1l8LI/AWSOlHc2T3xNCfHHQRxoUIR8FWPzYt57YeVd/bR1NqN60dQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB5123
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peng Fan <peng.fan@nxp.com>

The usage of readl_poll_timeout is wrong, the 3rd parameter(cond)
should be "val & LOCK_STATUS" not "val & LOCK_TIMEOUT_US",
It is not check whether the pll locked, LOCK_STATUS reflects the mask,
not LOCK_TIMEOUT_US.

Fixes: 8646d4dcc7fb ("clk: imx: Add PLLs driver for imx8mm soc")
Cc: <stable@vger.kernel.org>
Reviewed-by: Abel Vesa <abel.vesa@nxp.com>
Signed-off-by: Peng Fan <peng.fan@nxp.com>
---

V2:
 Update commit log, and add tag.

 drivers/clk/imx/clk-pll14xx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/imx/clk-pll14xx.c b/drivers/clk/imx/clk-pll14xx.c
index a6d31a7262ef..e2384271ed83 100644
--- a/drivers/clk/imx/clk-pll14xx.c
+++ b/drivers/clk/imx/clk-pll14xx.c
@@ -166,7 +166,7 @@ static int clk_pll14xx_wait_lock(struct clk_pll14xx *pl=
l)
 {
 	u32 val;
=20
-	return readl_poll_timeout(pll->base, val, val & LOCK_TIMEOUT_US, 0,
+	return readl_poll_timeout(pll->base, val, val & LOCK_STATUS, 0,
 			LOCK_TIMEOUT_US);
 }
=20
--=20
2.16.4

