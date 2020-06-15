Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D4061F900A
	for <lists+stable@lfdr.de>; Mon, 15 Jun 2020 09:37:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728417AbgFOHh3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Jun 2020 03:37:29 -0400
Received: from mail-eopbgr00076.outbound.protection.outlook.com ([40.107.0.76]:64598
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726318AbgFOHh2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Jun 2020 03:37:28 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EKFXTU1LoZ2W/4G0JL7XgnuV69pp0zJOr2kj8uNHnt74Vk5PvUPdq+j2hwCIGynmalmSYwNFLr+PMWtvZEQ0lGKO/08qeQSDpJURluXki3m38X37jyqCUncTlEHCWEFuRqv9wVkSSbRkheIj2q1G5fq1a0jd5RBZsf3EpN9XIGSY01A/klYV8DYqsaZ8txcBhP+sW7furNAr4JdJShji2iMFsn83s89L7LjwLEvjJ0Ys77grKlMwrYNrSLYr1CZGsIP6Zdhg3WpF05pUbYvcfAUivW2ZZ8zmtNRtvh+vOT6s3Y2kAsDpq/uPrEqLlnFz2K10He45XI80fVRV8QKkRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bQSf9O5WmKW5GIkJKC6HimzJrd4gunbiKnLFeLbZbsU=;
 b=k1hAu+YshaMg9IKKMwDkxlf64V7RZM8SHaAp71NVVwleBKWyezVBLbLhnZFmsMHaFOAdNC8ZNTGliYa4sxnx3v93L7gGakkjU361ESVpvIrlSbxPme7NH6Ltmf8pE+xwqYIcCZufecSNLEyZjfKsaPNdt5ETB8S0WKOSr42iaVMLloI1fZ8d1A7CHgOIME0KsoJvvv3hJFmruyW3EUhOJqWltZK6FnwBEeyo3jL1poIAj0us/zBunh8sQphFJKAb/TKHbamFiBLfwCzr467HkIwB/MW65tYb8tGhN1Ac0ZyYo+jHzeNPtfRcHMNAXPBjB0v7xrKdvoKBykRcshZXog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bQSf9O5WmKW5GIkJKC6HimzJrd4gunbiKnLFeLbZbsU=;
 b=hLuy10CWD4hFvCY265xOXuRQHaJjdXKOSQDXfIZPckE0taRs/iAX0EYBv6VFJefDOyRWsovucoILQxvfa5Au+mLoYdvZQ6ptO4xJedh9Cjhkyknm9KCxD6sFOdcwh9Qk3tUTICkSmdV0EYC2DlrBtRqINJYElR1syFRl61q+3NM=
Received: from AM6PR04MB4966.eurprd04.prod.outlook.com (2603:10a6:20b:2::14)
 by AM6PR04MB5927.eurprd04.prod.outlook.com (2603:10a6:20b:a8::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3088.19; Mon, 15 Jun
 2020 07:37:24 +0000
Received: from AM6PR04MB4966.eurprd04.prod.outlook.com
 ([fe80::3c6c:a0e9:9a4e:c51d]) by AM6PR04MB4966.eurprd04.prod.outlook.com
 ([fe80::3c6c:a0e9:9a4e:c51d%7]) with mapi id 15.20.3088.028; Mon, 15 Jun 2020
 07:37:24 +0000
From:   Aisheng Dong <aisheng.dong@nxp.com>
To:     Wolfram Sang <wsa@kernel.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>
CC:     Krzysztof Kozlowski <krzk@kernel.org>,
        Fabio Estevam <festevam@gmail.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        dl-linux-imx <linux-imx@nxp.com>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Shawn Guo <shawnguo@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>
Subject: RE: [PATCH] i2c: imx: Fix external abort on early interrupt
Thread-Topic: [PATCH] i2c: imx: Fix external abort on early interrupt
Thread-Index: AQHWPy2cjBhRFIV1v0u8QuYNZxLtCqjUstOAgAAG0YCAAAdfAIAABweAgAAC9oCAAAI8gIAAE/cAgAAHfwCAAAu5gIAEWpxQ
Date:   Mon, 15 Jun 2020 07:37:23 +0000
Message-ID: <AM6PR04MB4966B531C6591B86ED2A0D96809C0@AM6PR04MB4966.eurprd04.prod.outlook.com>
References: <1591796802-23504-1-git-send-email-krzk@kernel.org>
 <20200612090517.GA3030@ninjato> <20200612092941.GA25990@pi3>
 <20200612095604.GA17763@ninjato> <20200612102113.GA26056@pi3>
 <20200612103149.2onoflu5qgwaooli@pengutronix.de> <20200612103949.GB26056@pi3>
 <20200612115116.GA18557@ninjato>
 <859e8211-2c56-8dd5-d6fb-33e4358e4128@pengutronix.de>
 <20200612130003.GB18557@ninjato>
In-Reply-To: <20200612130003.GB18557@ninjato>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [119.31.174.66]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: c82b7b95-3c04-45ac-df2c-08d810fef1f5
x-ms-traffictypediagnostic: AM6PR04MB5927:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM6PR04MB5927C5786558C327B6904CC6809C0@AM6PR04MB5927.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 04359FAD81
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: EdbobW2vCWHk1CHbIJWRWl4ezH6FFtkZPMaxEhGZ7SSNTWSQdhKjwVjQSq0cdvg/cC8tAmc4DY+utYAAvl9tacdwlVwJm1i/o+LOCiWCRhoe17/Cd1m8RgD24lSgspMEcx5erjcsNiMstD5Lwt8Cm+o9Iyxmhxs+TN6QIM1rnDKlKJW1qwOe+YIWKPuP2mpYWl9e2+fPK8JJiowQwCZLQHzQuXxvqXuIoEXdzUf3fF/5uLo40SnZIP/ls+yFiCJu6UquWEguK6O1CC1qTMc6n765ogP4WhXjrf+xmuiiRik0el1gs/t+LbPJgAGgC/Pb
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR04MB4966.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(346002)(396003)(39860400002)(136003)(366004)(86362001)(186003)(478600001)(7416002)(26005)(52536014)(7696005)(4326008)(2906002)(6506007)(53546011)(5660300002)(55016002)(54906003)(9686003)(316002)(66946007)(33656002)(66556008)(66476007)(64756008)(66446008)(44832011)(8936002)(83380400001)(110136005)(8676002)(71200400001)(76116006);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: abUlt5EjDopSeKXm3W4QHV0rlCB3OyAa6TFqWGjpW4u1yyqfL6SG2LuNyN/DlRCMA5fUL61mxtWjBsgD+5aIHFFyTp22Knj7V+4N49xJp7yLxogQoQUJexAmtEJYME2nKJSExW5HxwadWTEewbx1uqHF0A66C9ITgIb3JKXZ0ZNBnvrtRIRzfm+vL+RTi52XWSHrC4xw8SAcE2leca/+3eu89keA3EkqF5HN1bh9fmQnoOQXfgHzXYGrlwCdTFA2+df15Ll/9vZKXrMgTfX8j4j0oLTFFb0TEF0bWs5oO459lX6uSig0klUM4IL0+KI8wcv6wnWTG4fc3LOE4n5xgaMfz1Zl1gg21qo4tFHJ6Z052oF4vg4H6MejQLVq+peixiY3nGnOzTcX05XpNOFeFpHoSgVhiMFkPXTQOfZwaULOKmlfLSaGVjmhiEJt8rGvSH4r2aARtqR8xkGfmRtr6600U47IOxCGq4+BBWjnbng=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c82b7b95-3c04-45ac-df2c-08d810fef1f5
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jun 2020 07:37:23.8766
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FU/KxCEBs8j4QOnWVIb+xbXgop+rBOqUbvDSn2rLbfRmGTDJDzSfQPVUSMZ2XYRpEPN43Ng/woyXdaYaCdb4eg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR04MB5927
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

PiBGcm9tOiBXb2xmcmFtIFNhbmcgPHdzYUBrZXJuZWwub3JnPg0KPiBTZW50OiBGcmlkYXksIEp1
bmUgMTIsIDIwMjAgOTowMCBQTQ0KPiANCj4gT24gRnJpLCBKdW4gMTIsIDIwMjAgYXQgMDI6MTg6
MDZQTSArMDIwMCwgTWFyYyBLbGVpbmUtQnVkZGUgd3JvdGU6DQo+ID4gT24gNi8xMi8yMCAxOjUx
IFBNLCBXb2xmcmFtIFNhbmcgd3JvdGU6DQo+ID4gPg0KPiA+ID4+IFRoaXMgYmFzaWNhbGx5IGtp
bGxzIHRoZSBjb25jZXB0IG9mIGRldm0gZm9yIGludGVycnVwdHMuIFNvbWUgb3RoZXINCj4gPiA+
DQo+ID4gPiBJdCBvbmx5IHdvcmtzIHdoZW4geW91IGNhbiBlbnN1cmUgeW91IGhhdmUgYWxsIGlu
dGVycnVwdHMgZGlzYWJsZWQNCj4gPiA+IChhbmQgbm9uZSBwZW5kaW5nKSBpbiByZW1vdmUoKSBv
ciB0aGUgZXJyb3IgcGF0aHMgb2YgcHJvYmUoKSBldGMuDQo+ID4NCj4gPiBCdXQgd2hlbiByZXF1
ZXN0aW5nIHRoZSBpbnRlcnJ1cHQgYXMgc2hhcmVkIHRoZSBpbnRlcnJ1cHQgaGFuZGxlciBjYW4N
Cj4gPiBnZXQgY2FsbGVkIGFueSB0aW1lLCBldmVuIGlmIHlvdSBoYXZlIGRpc2FibGVkIHRoZSBJ
UlEgc291cmNlIGluIHlvdXINCj4gPiBJUCBjb3JlLi4uLlRoZSBzaGFyZWQgSVJRIGRlYnVnIGNv
ZGUgdGVzdHMgdGhpcy4NCj4gDQo+IFllcywgc28geW91J2QgbmVlZCBzb21ldGhpbmcgbGlrZQ0K
PiANCj4gCWlmIChjbGtzX2FyZV9vZmYpDQo+IAkJcmV0dXJuIElSUV9OT05FOw0KPiANCg0KSSB1
bmRlcnN0YW5kIHRoaXMuIEJ1dCAuLg0KDQo+IG9yIHNraXAgZGV2bV8gZm9yIGludGVycnVwdHMg
YW5kIGhhbmRsZSBpdCBtYW51YWxseS4gKElJUkMgdGhlIGlucHV0IHN1YnN5c3RlbQ0KPiByZWFs
bHkgZnJvd25zIHVwb24gZGV2bSArIGlycXMgZm9yIHN1Y2ggcmVhc29ucykNCj4gDQo+IEQnYWNj
b3JkPw0KDQpIYW5kbGUgaXQgbWFudWFsbHkgbG9va3MgdG8gbWUgY2FuIG9ubHkgYWRkcmVzcyB0
aGUgaXNzdWUgZm9yIHByb2JlIGVycm9yIHBhdGguDQpCdXQgaG93IGNhbiBpdCBoYW5kbGUgdGhl
IG5vcm1hbCBydW5uaW5nIGNhc2VzIHRoYXQgc2hhcmVkIGlycSBhcnJpdmVkIHdoZW4gZGV2aWNl
DQppcyBpbiBydW50aW1lIHN1c3BlbmQgc3RhdGU/DQoNClJlZ2FyZHMNCkFpc2hlbmcNCg0K
