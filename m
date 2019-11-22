Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E14581071E4
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 13:01:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727589AbfKVMA5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 07:00:57 -0500
Received: from mail-eopbgr10081.outbound.protection.outlook.com ([40.107.1.81]:30222
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727109AbfKVMA5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 07:00:57 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=THJ5FaXWUNrF7KMRZgQ5JGr3hnskCklAYWEl65rpl5gf6ws7BGUoba8MyjRqTAjaSwkYMQV1GSVqaivGCTZwOZ1Een6BSp3fhN/s0ahXUT52Uxmfzmb67WEq/K1J63E0ddD38yF68rP1soOl2BKrvHYiuwxRevzLGkH1lZrShXMqqhiNTk+1tKhjQZqX9i/kRFd1yc1cYLrVT4bP3ueKYHZCC90qoQiuM7CDoek5Kf9gykYEtYUjq6ozfVKkng6O8QISkJ5jdms647sAJPen5v9QqKzp3I91/gpj2asQ0rkgRmjouE1Jb1O/PyDqjB0KfSUX36AWSI4Sh1s7tTVa2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XCMT0XJc+8EXgdudeEpRkg/+cSKzs9jVs9BWZVT7ix0=;
 b=Q0HpWR5lpngh4lHNO99avi1POGAN1Prly5o/i+jy/R5QFLL2q0AWaFYS1YtL9nSLGQYjZLHPf/ylpO1iOnP8LJ/Kb7wifBoFCH0FBxEVH7db0wiwNRIa17Ster1d13PeOqKHyisuMY1tT3HCfeiIbYqNpnyCgd048cU3Fk9HVeSNEovuBCrf94HTbhJFghLkqhVYvjHVVm344X/mvo289MDsVcCsYoPV6woUqGrGu8IKPJ6j0gwOXlyAwrw98960yyvan+f/bm2bnROZGphQ5WqmsY1Lc+cN6bF2C1A94F9drg5emIv3GAUpn0vyCEuu450xTtjVCMrQ9OGZT2O8mA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XCMT0XJc+8EXgdudeEpRkg/+cSKzs9jVs9BWZVT7ix0=;
 b=rlQGDxIkTg6w7pyLGIJDs+ghbzius8LnmkyrNIOola00Nb14KtVNPaOamNz0DflpxbZvGCW7bqzBTCL+AotYExU2f/RxyfLTrjtHRGj4JKDpedyVLTlMUvPijr5/ull6hF0tZ9b9hVjH5H8MBK2HzNIVxMqm6RH/dAig/5aE++E=
Received: from AM0PR04MB4211.eurprd04.prod.outlook.com (52.134.92.158) by
 AM0PR04MB6482.eurprd04.prod.outlook.com (20.179.254.96) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2474.16; Fri, 22 Nov 2019 12:00:52 +0000
Received: from AM0PR04MB4211.eurprd04.prod.outlook.com
 ([fe80::103c:4fb1:b9f8:edea]) by AM0PR04MB4211.eurprd04.prod.outlook.com
 ([fe80::103c:4fb1:b9f8:edea%6]) with mapi id 15.20.2474.021; Fri, 22 Nov 2019
 12:00:52 +0000
From:   Aisheng Dong <aisheng.dong@nxp.com>
To:     Peng Fan <peng.fan@nxp.com>, "sboyd@kernel.org" <sboyd@kernel.org>,
        "shawnguo@kernel.org" <shawnguo@kernel.org>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        "festevam@gmail.com" <festevam@gmail.com>,
        Abel Vesa <abel.vesa@nxp.com>
CC:     "kernel@pengutronix.de" <kernel@pengutronix.de>,
        dl-linux-imx <linux-imx@nxp.com>,
        "linux-clk@vger.kernel.org" <linux-clk@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Leonard Crestez <leonard.crestez@nxp.com>,
        Alice Guo <alice.guo@nxp.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH V2] clk: imx: clk-imx7ulp: Add missing sentinel of
 ulp_div_table
Thread-Topic: [PATCH V2] clk: imx: clk-imx7ulp: Add missing sentinel of
 ulp_div_table
Thread-Index: AQHVoRxJ5RRsuDSV80CDoqBvpvLXvKeXFpyg
Date:   Fri, 22 Nov 2019 12:00:51 +0000
Message-ID: <AM0PR04MB42114B6D9AE5CFB89887EA9080490@AM0PR04MB4211.eurprd04.prod.outlook.com>
References: <1574416982-3467-1-git-send-email-peng.fan@nxp.com>
In-Reply-To: <1574416982-3467-1-git-send-email-peng.fan@nxp.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=aisheng.dong@nxp.com; 
x-originating-ip: [119.31.174.66]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 1d1585da-1ff0-44ee-a4a4-08d76f439f2a
x-ms-traffictypediagnostic: AM0PR04MB6482:|AM0PR04MB6482:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM0PR04MB6482B659A54363E4C599658080490@AM0PR04MB6482.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:873;
x-forefront-prvs: 02296943FF
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(376002)(396003)(366004)(39860400002)(346002)(189003)(199004)(66066001)(81156014)(81166006)(229853002)(74316002)(86362001)(6636002)(6246003)(2201001)(14444005)(6436002)(8676002)(305945005)(9686003)(7736002)(33656002)(4744005)(3846002)(478600001)(66556008)(64756008)(2501003)(76116006)(66476007)(6116002)(99286004)(14454004)(66946007)(66446008)(8936002)(186003)(25786009)(7696005)(52536014)(54906003)(102836004)(110136005)(316002)(6506007)(53546011)(26005)(76176011)(4326008)(44832011)(256004)(11346002)(71200400001)(55016002)(446003)(5660300002)(71190400001)(2906002);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR04MB6482;H:AM0PR04MB4211.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: JW8bZ+8Q8OdO3ii298N+3rFMogKYH5jceI6NCS7ZdZ0GAOEeHspNFK8Uh5BRB1QCqsCsJvtr11xBhrNfyqhSmzUoRAH8oVd2vnLDwejB5F/uM5zDlrZhNCUF0EoBTQb0HXtVlpjtKlBPrMqi7YCxarBX2dWOz5o2JnHRPwtEKMkaHWH0lP+oJVKDDOJGblxx/kJNeJUvCHp5PPWURBsSN48tZkXGUcIASD4Hd9vaRDNIp+kxinCtp5KME5swWOMlihn82LjTuiVXb7oTQEpdcHZDo+IwtDv1qCWODmgapkZjnjFnfMa5YPB7kvpNtVychBklNw1A61I1N1R1UeAC4hXagTDTYOOzt6plZcoi1KSfnT/ctrziaXF9bMBTyg5zUGIP5C6lOIVvczrvxBc+6UyBEsMnuaMWs+9ntsuSssMmgMrFXKnHCjOAChmWsWoY
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1d1585da-1ff0-44ee-a4a4-08d76f439f2a
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Nov 2019 12:00:51.9468
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nN0rVOo5b18lwmUaftFgifgVlqLDDV7qxVCgT3EfUp8YyrCg2tvaCn1m71YT0eWSzfyc6I/xj9up0kFDzApacw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB6482
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

PiBGcm9tOiBQZW5nIEZhbiA8cGVuZy5mYW5AbnhwLmNvbT4NCj4gU2VudDogRnJpZGF5LCBOb3Zl
bWJlciAyMiwgMjAxOSA2OjA1IFBNDQo+IFN1YmplY3Q6IFtQQVRDSCBWMl0gY2xrOiBpbXg6IGNs
ay1pbXg3dWxwOiBBZGQgbWlzc2luZyBzZW50aW5lbCBvZiB1bHBfZGl2X3RhYmxlDQo+IA0KPiBU
aGVyZSBzaG91bGQgYmUgYSBzZW50aW5lbCBvZiB1bHBfZGl2X3RhYmxlLCBvdGhlcndpc2UgX2dl
dF90YWJsZV9kaXYgbWF5DQo+IGFjY2VzcyBkYXRhIG91dCBvZiB0aGUgYXJyYXkuDQo+IA0KPiBG
aXhlczogYjEyNjAwNjdhYzNkICgiY2xrOiBpbXg6IGFkZCBpbXg3dWxwIGNsayBkcml2ZXIiKQ0K
PiBDYzogc3RhYmxlQHZnZXIua2VybmVsLm9yZw0KPiBTaWduZWQtb2ZmLWJ5OiBQZW5nIEZhbiA8
cGVuZy5mYW5AbnhwLmNvbT4NCg0KUmV2aWV3ZWQtYnk6IERvbmcgQWlzaGVuZyA8YWlzaGVuZy5k
b25nQG54cC5jb20+DQoNClJlZ2FyZHMNCkFpc2hlbg0KDQo=
