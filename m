Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 87CA770E56
	for <lists+stable@lfdr.de>; Tue, 23 Jul 2019 02:56:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730658AbfGWA4w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Jul 2019 20:56:52 -0400
Received: from mail-eopbgr80089.outbound.protection.outlook.com ([40.107.8.89]:17230
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728679AbfGWA4w (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Jul 2019 20:56:52 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fLjszwKIGOtF4Uvhw3zxUADTNBqvc95tWKQRsyHK1bcfzzEr8xbq7wgVvQG/gtD+1E/53Iysf+sMMU6rrKbY+xzMPITOrUVA72d/MsCaHY6xcPoqasMMaKm7pjUZKOlKKYhkYX5+w4a6W540FN5X8DAKh5Rp34MpJqgikS+aAEvtTN3oQ7GNxLc5J1oegx96M+Bw+7hVogkEy330oGNTcWwBQaEVKAbjP2OOtxsUACVOTTF43wgKvqlelrSm73qIT/fJ031ZarZddLInSMTIpSFDKvZO1Wjqdgr1SRof4oacKnUAxLJ1pFhAZbg4NX3ZiXY2rOwr91jflFXYIA7vvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2i0WmTErKnjdY6v4nm4iXLBxTZGu71iCTTFKfLzfNoc=;
 b=VOMo4bTbqzEgg8nMBYPXmES4wZL5PqH8HnodV/xH9EAY5h/vFVhy1U8064ruKxqEaX7TEg9H5Oa8YPj8AQQyRAPLXBHdQdgvxor2tDWzCbH0W+IOUmgQKCmkTXOR+OXSsMg6N+Awaa4vRJGf1uW9hhYCtNy8zxcdNeGGrx44a7OrWr5FsHyYDYhNKe9SbzWHLZJLYKpdCNN8IdjhqHdtOJWl4wEvx9QjWBh9/GtD9XkQAaYsuS/oC1tLi8XgNN1Ej6fjmUuYGvGNaVTnhpupLw1kAROJRy5ep1MGc5UxkQdcHkdfMa3apacm7pFDM9EB1R3Tk0of6UXqJfYUkTA4Lg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=nxp.com;dmarc=pass action=none header.from=nxp.com;dkim=pass
 header.d=nxp.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2i0WmTErKnjdY6v4nm4iXLBxTZGu71iCTTFKfLzfNoc=;
 b=bkYeL3+k6B7vosPFKlIJArp9pQAdwdrAmjH6kutQpgf3+77n8/iZ0qvJY54aBEHaa46Ueru+wcX9grMternivbN3XY/EHPEBn4cfBHxNa140mvjxCOsJSuIgy/t3rWVX83UE3wcTj7HbCFnBnwD8Jk0WJyXwg+8tRnPanlP8imE=
Received: from AM0PR04MB4481.eurprd04.prod.outlook.com (52.135.147.15) by
 AM0PR04MB5763.eurprd04.prod.outlook.com (20.178.117.75) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2094.16; Tue, 23 Jul 2019 00:56:47 +0000
Received: from AM0PR04MB4481.eurprd04.prod.outlook.com
 ([fe80::2023:c0e5:8a63:2e47]) by AM0PR04MB4481.eurprd04.prod.outlook.com
 ([fe80::2023:c0e5:8a63:2e47%5]) with mapi id 15.20.2094.011; Tue, 23 Jul 2019
 00:56:47 +0000
From:   Peng Fan <peng.fan@nxp.com>
To:     Stephen Boyd <sboyd@kernel.org>,
        "festevam@gmail.com" <festevam@gmail.com>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "mturquette@baylibre.com" <mturquette@baylibre.com>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        "shawnguo@kernel.org" <shawnguo@kernel.org>
CC:     dl-linux-imx <linux-imx@nxp.com>,
        Leonard Crestez <leonard.crestez@nxp.com>,
        Anson Huang <anson.huang@nxp.com>,
        Jacky Bai <ping.bai@nxp.com>,
        "linux-clk@vger.kernel.org" <linux-clk@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "van.freenix@gmail.com" <van.freenix@gmail.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH] clk: imx: imx8mm: fix audio pll setting
Thread-Topic: [PATCH] clk: imx: imx8mm: fix audio pll setting
Thread-Index: AQHVOrjKqRILo4kj1ESmmUTSG4SPJabXPg0AgAAvSDA=
Date:   Tue, 23 Jul 2019 00:56:47 +0000
Message-ID: <AM0PR04MB44815D9F3B2ABC00D0CF311288C70@AM0PR04MB4481.eurprd04.prod.outlook.com>
References: <1563157783-31846-1-git-send-email-peng.fan@nxp.com>
 <20190722220645.C51BC219BE@mail.kernel.org>
In-Reply-To: <20190722220645.C51BC219BE@mail.kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=peng.fan@nxp.com; 
x-originating-ip: [119.31.174.71]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: af149ee4-5aa8-4909-d091-08d70f08a36d
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM0PR04MB5763;
x-ms-traffictypediagnostic: AM0PR04MB5763:
x-microsoft-antispam-prvs: <AM0PR04MB5763F7879112970DC5A6277B88C70@AM0PR04MB5763.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 0107098B6C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(366004)(346002)(376002)(396003)(136003)(189003)(199004)(54906003)(11346002)(476003)(110136005)(316002)(66446008)(66556008)(6246003)(64756008)(229853002)(66946007)(66476007)(76116006)(446003)(33656002)(9686003)(76176011)(55016002)(44832011)(2201001)(66066001)(3846002)(2906002)(6116002)(71200400001)(71190400001)(81166006)(81156014)(53936002)(4744005)(7696005)(86362001)(8936002)(14444005)(25786009)(74316002)(7416002)(7736002)(305945005)(2501003)(8676002)(478600001)(26005)(6506007)(5660300002)(102836004)(52536014)(99286004)(486006)(186003)(256004)(4326008)(14454004)(68736007)(6436002)(32563001);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR04MB5763;H:AM0PR04MB4481.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 6xxQ+OeQRQ+eX/NE46zPTPsOgXJZNJvi1qyzEZfU1rJKwsfOBaxRAb5xMFwOzOmIkpd4KmJEmYzQf8LEQoaI3i3c5wVnKusTJ8t4qKSIoyM0M8djLuqOeUKXxXwEwxCyE9hGTo5+k2rc2yoFIgiKl8yFBuQHZ6HHERoXcNDOtD5iojm1CYFm9GXGQnFff7smk2PocenFHic0Y5ze4F0HSPOCv424+wQ3KupDOQLHFSNqtY0BvpWFr8wKX+FqxItfYXTlKM9caYjini+8bAvpiS7pGGG5WLDzlsxhKyT/W8O6ZzAh8ZIKJkqh73y6ePKKJlTr1d4enK8wRJ1aRAn/qPvpAyirwyJeePkQXdg0wy707Uo+wmveUNkHumpaZ8ymw5hemJeJ7DZ9hm+kenYB/WgMBh0dii0GF3Pnsf2EF1A=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: af149ee4-5aa8-4909-d091-08d70f08a36d
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jul 2019 00:56:47.1373
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: peng.fan@nxp.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB5763
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

SGkgU3RlcGhlbiwNCg0KPiBTdWJqZWN0OiBSZTogW1BBVENIXSBjbGs6IGlteDogaW14OG1tOiBm
aXggYXVkaW8gcGxsIHNldHRpbmcNCj4gDQo+IFF1b3RpbmcgUGVuZyBGYW4gKDIwMTktMDctMTQg
MTk6NTU6NDMpDQo+ID4gRnJvbTogUGVuZyBGYW4gPHBlbmcuZmFuQG54cC5jb20+DQo+ID4NCj4g
PiBUaGUgQVVESU8gUExMIG1heCBzdXBwb3J0IDY1ME0sIHNvIHRoZSBvcmlnaW5hbCBjbGsgc2V0
dGluZ3MgdmlvbGF0ZQ0KPiA+IHNwZWMuIFRoaXMgcGF0Y2ggbWFrZXMgdGhlIG91dHB1dCA3ODY0
MzIwMDAgLT4gMzkzMjE2MDAwLCBhbmQNCj4gPiA3MjI1MzQ0MDAgLT4gMzYxMjY3MjAwIHRvIGFs
aWduZWQgd2l0aCBOWFAgdmVuZG9yIGtlcm5lbCB3aXRob3V0IGFueQ0KPiA+IGltcGFjdCBvbiBh
dWRpbyBmdW5jdGlvbmFsaXR5IGFuZCBnbyB3aXRoaW4gNjUwTUh6IFBMTCBsaW1pdC4NCj4gPg0K
PiA+IENjOiA8c3RhYmxlQHZnZXIua2VybmVsLm9yZz4NCj4gPiBGaXhlczogYmE1NjI1YzNlMjcy
ICgiY2xrOiBpbXg6IEFkZCBjbG9jayBkcml2ZXIgc3VwcG9ydCBmb3IgaW14OG1tIikNCj4gPiBT
aWduZWQtb2ZmLWJ5OiBQZW5nIEZhbiA8cGVuZy5mYW5AbnhwLmNvbT4NCj4gPiAtLS0NCj4gDQo+
IElzIHRoaXMgYSBwcm9ibGVtIHJpZ2h0IG5vdywgaS5lLiBzaG91bGQgSSBhcHBseSB0aGlzIHRv
IGNsay1maXhlcz8gT3IgY2FuIHRoaXMgd2FpdA0KPiB1bnRpbCBuZXh0IG1lcmdlIHdpbmRvdz8N
Cg0KQ291bGQgd2FpdCB1bnRpbCBuZXh0IG1lcmdlIHdpbmRvdy4NCg0KVGhhbmtzLA0KUGVuZy4N
Cg0K
