Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (unknown [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 17BAE1A628C
	for <lists+stable@lfdr.de>; Mon, 13 Apr 2020 07:41:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729024AbgDMFlo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Apr 2020 01:41:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.18]:42700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729023AbgDMFlg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Apr 2020 01:41:36 -0400
Received: from mo-csw.securemx.jp (mo-csw1114.securemx.jp [210.130.202.156])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBAA1C008666;
        Sun, 12 Apr 2020 22:16:20 -0700 (PDT)
Received: by mo-csw.securemx.jp (mx-mo-csw1114) id 03D5GBsT009900; Mon, 13 Apr 2020 14:16:11 +0900
X-Iguazu-Qid: 2wHI1scKF74gMrXPIv
X-Iguazu-QSIG: v=2; s=0; t=1586754971; q=2wHI1scKF74gMrXPIv; m=+uUkiahhM+/kgfStACiTUqhYbVkSDDOVc5sBHqetGWY=
Received: from imx2.toshiba.co.jp (imx2.toshiba.co.jp [106.186.93.51])
        by relay.securemx.jp (mx-mr1110) id 03D5GACG010275;
        Mon, 13 Apr 2020 14:16:10 +0900
Received: from enc01.localdomain ([106.186.93.100])
        by imx2.toshiba.co.jp  with ESMTP id 03D5GAkk027566;
        Mon, 13 Apr 2020 14:16:10 +0900 (JST)
Received: from hop001.toshiba.co.jp ([133.199.164.63])
        by enc01.localdomain  with ESMTP id 03D5G9ko014743;
        Mon, 13 Apr 2020 14:16:10 +0900
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GrpxuhPyD/f0XZ2wKYdlmev2pFXYV+jk4VXlUDLSP+0RM1DLeq31/raSpIkeaqSlfJEiasDesybJwbKaOj4B1MIZfYjKsaqrDPHC5dRoEu7/dCTrhcBKR5oE+bPRHbV4QNTWDHXD7R396vug4yy/cQlu4VnJbgVk9NWXD/z9rMXJeQ9l1GtdZq6vYh1P1aMCzjZ0kFyPLeL00DkDOpdO7seO/+NJizO/UZ3tIusZA7uegsSTZzsHwP6P+wh50q09f1J5P70jD7hwwyGNdu2F7Y9UItlg9wZqRX1UZm9078MqR8WvXvwyqqwtJSIQ1H105qnKdOxrFktvDlDwSGmFBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z4oTgdYn4CaiSwQyNcfkY5y8wtGC54XEKZzfbvtAKp8=;
 b=D8RMZ9OpKo35+6a+yJgR9BwmPnp2LjByhPakpMzPt9u09A06UJ1Di14aEw2MFJqcObaC5zq4I/JiHXaTIFnJiuiktQo35YQpbOki/vG/+4jl/hXTL+H+wTu2BCS2TU5vtnKGriW5Jafw//ELsaizU2vN69ZXg9+WIBJWRJQ3pzU9fZfTnm0Q2tOVSuYHbGmMvd5tFnlgGHzby5xCrfkLb10oqQTlMY+zwyW2BB1tNAV7ApUWa1zSdT61A3oL2/9D6Q6c4fPRLzo4dF+GvPRfCqqdlxhZDeFKUm+vfPie3Ov2t5gUDUot4ygb5eQYGR6xnO2pA73URHoU1t1tiTsKiw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=toshiba.co.jp; dmarc=pass action=none
 header.from=toshiba.co.jp; dkim=pass header.d=toshiba.co.jp; arc=none
From:   <nobuhiro1.iwamatsu@toshiba.co.jp>
To:     <gregkh@linuxfoundation.org>, <linux-kernel@vger.kernel.org>
CC:     <stable@vger.kernel.org>, <clew@codeaurora.org>,
        <aneela@codeaurora.org>, <bjorn.andersson@linaro.org>,
        <lee.jones@linaro.org>
Subject: RE: [PATCH 4.14 36/38] rpmsg: glink: Remove chunk size word align
 warning
Thread-Topic: [PATCH 4.14 36/38] rpmsg: glink: Remove chunk size word align
 warning
Thread-Index: AQHWD/ySKswUQRH7EkmmljOG6xvi9qh2gwjA
Date:   Mon, 13 Apr 2020 05:16:05 +0000
X-TSB-HOP: ON
Message-ID: <OSAPR01MB3667845337B13FB2398B8AB892DD0@OSAPR01MB3667.jpnprd01.prod.outlook.com>
References: <20200411115437.795556138@linuxfoundation.org>
 <20200411115441.303886448@linuxfoundation.org>
In-Reply-To: <20200411115441.303886448@linuxfoundation.org>
Accept-Language: ja-JP, en-US
Content-Language: ja-JP
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=nobuhiro1.iwamatsu@toshiba.co.jp; 
x-originating-ip: [209.137.146.201]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d24c923c-0c18-4e17-4805-08d7df69c432
x-ms-traffictypediagnostic: OSAPR01MB4962:
x-microsoft-antispam-prvs: <OSAPR01MB4962CB5416EDCA65FFA5BA1D92DD0@OSAPR01MB4962.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:53;
x-forefront-prvs: 037291602B
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OSAPR01MB3667.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(39860400002)(366004)(376002)(346002)(136003)(396003)(64756008)(86362001)(66556008)(71200400001)(5660300002)(9686003)(8676002)(55016002)(81156014)(4326008)(66476007)(8936002)(76116006)(52536014)(33656002)(54906003)(26005)(66446008)(66946007)(110136005)(2906002)(6506007)(478600001)(316002)(53546011)(186003)(7696005);DIR:OUT;SFP:1101;
received-spf: None (protection.outlook.com: toshiba.co.jp does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: oxrhzQIt5FqpwFLJTSFfTtvPqEFJRghgWn7/cM8GgVYR+RGUoFXdv5b+9HT8RWnn6LNzYD7u311ebzIQJ7KE2Uwbx1cHDVp4sm6tMJw+LUkSVwhPEMvKwKskhjlRgBX7Dl734N3pyJOHZdhs+asiedNY1zLg+AEqEPfk4G0nnUU66pKuKpF0dr1L2X8cXIS0htsJLeoee/xzBD+ZOzkohNhJMC3Cwj2q297jopXdTzYIRL2O0qDjIXggKeaaZSyYMxIEXAwNLbVadzl23jL8WhnIXmpFXMdoZqLKuR1kNovkLK+OQHhxn3bKQ8ybZQfW9zk8YF25343YB6ypryx1yaQ+QivVrFJljpgAC0taVtkFrObK0mja6dRRPeOnaziVKXZQv5pAHB87jk/FY+MPbAj/tcRx8nNflc80TGH7Rw2TSlL4VCdbymZw5eGM6jCq
x-ms-exchange-antispam-messagedata: fKFN1Drq64hP8AotDAOUCPkfLVEJNJb5eOEPIj++uKptf9WP7kNI1GOSEAMiFXV8qQ9fJWw13mv3GdarBI63jgMYf/s5FOjsX3uovWZx921cxUiye04+9DUdvL7ythvOyFwUsQYrqnBjF9FdTJChsg==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: d24c923c-0c18-4e17-4805-08d7df69c432
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Apr 2020 05:16:05.1484
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f109924e-fb71-4ba0-b2cc-65dcdf6fbe4f
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YP9VCOwUIpNOpcGMV4z9VPhwMffy7OoxjyT7/7mVhCivCEQmj5jA7jzjP4OIPVnaj+uWWyhAU8quo9E88cFtluK+QdS6lxEcRSPGek0bCOncDBLZyiT1Bwni5HBy/NUA
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSAPR01MB4962
X-OriginatorOrg: toshiba.co.jp
MSSCP.TransferMailToMossAgent: 103
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

SGksDQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogc3RhYmxlLW93bmVy
QHZnZXIua2VybmVsLm9yZyBbbWFpbHRvOnN0YWJsZS1vd25lckB2Z2VyLmtlcm5lbC5vcmddIE9u
IEJlaGFsZiBPZiBHcmVnIEtyb2FoLUhhcnRtYW4NCj4gU2VudDogU2F0dXJkYXksIEFwcmlsIDEx
LCAyMDIwIDk6MDkgUE0NCj4gVG86IGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmcNCj4gQ2M6
IEdyZWcgS3JvYWgtSGFydG1hbiA8Z3JlZ2toQGxpbnV4Zm91bmRhdGlvbi5vcmc+OyBzdGFibGVA
dmdlci5rZXJuZWwub3JnOyBDaHJpcyBMZXcgPGNsZXdAY29kZWF1cm9yYS5vcmc+OyBBcnVuDQo+
IEt1bWFyIE5lZWxha2FudGFtIDxhbmVlbGFAY29kZWF1cm9yYS5vcmc+OyBCam9ybiBBbmRlcnNz
b24gPGJqb3JuLmFuZGVyc3NvbkBsaW5hcm8ub3JnPjsgTGVlIEpvbmVzDQo+IDxsZWUuam9uZXNA
bGluYXJvLm9yZz4NCj4gU3ViamVjdDogW1BBVENIIDQuMTQgMzYvMzhdIHJwbXNnOiBnbGluazog
UmVtb3ZlIGNodW5rIHNpemUgd29yZCBhbGlnbiB3YXJuaW5nDQo+IA0KPiBGcm9tOiBDaHJpcyBM
ZXcgPGNsZXdAY29kZWF1cm9yYS5vcmc+DQo+IA0KPiBjb21taXQgZjBiZWI0YmE5YjE4NWQ0OTdj
OGVmZTdiMzQ5MzYzNzAwMDkyYWVlMCB1cHN0cmVhbS4NCj4gDQo+IEl0IGlzIHBvc3NpYmxlIGZv
ciB0aGUgY2h1bmsgc2l6ZXMgY29taW5nIGZyb20gdGhlIG5vbiBSUE0gcmVtb3RlIHByb2NzDQo+
IHRvIG5vdCBiZSB3b3JkIGFsaWduZWQuIFJlbW92ZSB0aGUgYWxpZ25tZW50IHdhcm5pbmcgYW5k
IGNvbnRpbnVlIHRvDQo+IHJlYWQgZnJvbSB0aGUgRklGTyBzbyBleGVjdXRpb24gaXMgbm90IHN0
YWxsZWQuDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBDaHJpcyBMZXcgPGNsZXdAY29kZWF1cm9yYS5v
cmc+DQo+IFNpZ25lZC1vZmYtYnk6IEFydW4gS3VtYXIgTmVlbGFrYW50YW0gPGFuZWVsYUBjb2Rl
YXVyb3JhLm9yZz4NCj4gU2lnbmVkLW9mZi1ieTogQmpvcm4gQW5kZXJzc29uIDxiam9ybi5hbmRl
cnNzb25AbGluYXJvLm9yZz4NCj4gU2lnbmVkLW9mZi1ieTogTGVlIEpvbmVzIDxsZWUuam9uZXNA
bGluYXJvLm9yZz4NCj4gU2lnbmVkLW9mZi1ieTogR3JlZyBLcm9haC1IYXJ0bWFuIDxncmVna2hA
bGludXhmb3VuZGF0aW9uLm9yZz4NCg0KVGhpcyBjb21taXQgYWxzbyBzZWVtcyB0byByZXF1aXJl
IHRoZSBmb2xsb3dpbmcgY29tbWl0czoNCg0KY29tbWl0IDkyODAwMmE1ZTlkYWIyZGRjMWEwZmUz
ZTAwNzM5ZTg5YmUzMGRjNmINCkF1dGhvcjogQXJ1biBLdW1hciBOZWVsYWthbnRhbSA8YW5lZWxh
QGNvZGVhdXJvcmEub3JnPg0KRGF0ZTogICBXZWQgT2N0IDMgMTc6MDg6MjAgMjAxOCArMDUzMA0K
DQogICAgcnBtc2c6IGdsaW5rOiBzbWVtOiBTdXBwb3J0IHJ4IHBlYWsgZm9yIHNpemUgbGVzcyB0
aGFuIDQgYnl0ZXMNCiAgICANCiAgICBUaGUgY3VycmVudCByeCBwZWFrIGZ1bmN0aW9uIGZhaWxz
IHRvIHJlYWQgdGhlIGRhdGEgaWYgc2l6ZSBpcw0KICAgIGxlc3MgdGhhbiA0Ynl0ZXMuDQogICAg
DQogICAgVXNlIG1lbWNweV9mcm9taW8gdG8gc3VwcG9ydCBkYXRhIHJlYWRzIG9mIHNpemUgbGVz
cyB0aGFuIDQgYnl0ZXMuDQogICAgDQogICAgQ2M6IHN0YWJsZUB2Z2VyLmtlcm5lbC5vcmcNCiAg
ICBGaXhlczogZjBiZWI0YmE5YjE4ICgicnBtc2c6IGdsaW5rOiBSZW1vdmUgY2h1bmsgc2l6ZSB3
b3JkIGFsaWduIHdhcm5pbmciKQ0KICAgIFNpZ25lZC1vZmYtYnk6IEFydW4gS3VtYXIgTmVlbGFr
YW50YW0gPGFuZWVsYUBjb2RlYXVyb3JhLm9yZz4NCiAgICBTaWduZWQtb2ZmLWJ5OiBCam9ybiBB
bmRlcnNzb24gPGJqb3JuLmFuZGVyc3NvbkBsaW5hcm8ub3JnPg0KDQpUaGlzIGZpeGVzIGNvbW1p
dCBuZWVkIHRvIGFwcGx5IDQuMTkuDQoNCkJlc3QgcmVnYXJkcywNCiAgTm9idWhpcm8NCg0KPiAN
Cj4gLS0tDQo+ICBkcml2ZXJzL3JwbXNnL3Fjb21fZ2xpbmtfbmF0aXZlLmMgfCAgICAzIC0tLQ0K
PiAgMSBmaWxlIGNoYW5nZWQsIDMgZGVsZXRpb25zKC0pDQo+IA0KPiAtLS0gYS9kcml2ZXJzL3Jw
bXNnL3Fjb21fZ2xpbmtfbmF0aXZlLmMNCj4gKysrIGIvZHJpdmVycy9ycG1zZy9xY29tX2dsaW5r
X25hdGl2ZS5jDQo+IEBAIC04MTEsOSArODExLDYgQEAgc3RhdGljIGludCBxY29tX2dsaW5rX3J4
X2RhdGEoc3RydWN0IHFjbw0KPiAgCQlyZXR1cm4gLUVBR0FJTjsNCj4gIAl9DQo+IA0KPiAtCWlm
IChXQVJOKGNodW5rX3NpemUgJSA0LCAiSW5jb21pbmcgZGF0YSBtdXN0IGJlIHdvcmQgYWxpZ25l
ZFxuIikpDQo+IC0JCXJldHVybiAtRUlOVkFMOw0KPiAtDQo+ICAJcmNpZCA9IGxlMTZfdG9fY3B1
KGhkci5tc2cucGFyYW0xKTsNCj4gIAlzcGluX2xvY2tfaXJxc2F2ZSgmZ2xpbmstPmlkcl9sb2Nr
LCBmbGFncyk7DQo+ICAJY2hhbm5lbCA9IGlkcl9maW5kKCZnbGluay0+cmNpZHMsIHJjaWQpOw0K
PiANCg0K
