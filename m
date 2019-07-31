Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8A9C77BDCF
	for <lists+stable@lfdr.de>; Wed, 31 Jul 2019 11:58:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728997AbfGaJ6f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 31 Jul 2019 05:58:35 -0400
Received: from mail-eopbgr1410090.outbound.protection.outlook.com ([40.107.141.90]:11115
        "EHLO JPN01-OS2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728996AbfGaJ6f (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 31 Jul 2019 05:58:35 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A0WEaXFJfSdoOjL1JSd07s54kj6dZsumYi9c2vEmF4aLHLjJXjXPL1M1zrAPNnTwt1wyfDR3stjScOz8xiVOvpTwg5pa7BjMU2pVkDBNJ9UPv3axv/JgpiWwfN01N1JFtyLNRL0Rom/qINO+QD0B8Ycf+eLyPlg7PmtzycBJZrTm77qGncKtfJVqyzV4F7StHXietOLwiXmKnb1cIv7fGusVh4zPoK60oPPWHPPJ62IDvi0qz8flpN4liq429HUBVXe6okDfe6q4cpSXWOyZRSJHX/1ce0jlNNHV+CIZQrO657OOzj4iUazgqoBjG7TddgC5vjuq+kOpTtvDKMYx0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CMp3YtS4wCIucwyFoj6GQZKQTJ+7805ULG6CeFkscfk=;
 b=lMfJ9h0H5Q0cFS6QxD14dtVdhH3k6olR6Lu9ooUzL/KEyYsl7YVACpf30vzwspmvvsujN9SKUqWdQdQ7ifeQ54gnWB4+mcNru0Ef12EW2Js+0jHVtWPAPRqDd+DG+OKdxMGqcjfRGeAaAyLa/IIEYUso0PHTQTczPg2QuVW3najzHXurgszVoAOIuP4OkOB9BWvTJ2zUw7g2r23enUd69pA61LoWXDxe5RQLlbhfclgwD/sTLZHc/xY3QUt0p+GksauMx33ghmzpS4ULKvTs3wOgygVNElVzfVfz2O4JbLqC3gTiMw0okhpSpg7iqGKHaiRNubeAzhAxBEU/UZibkg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=renesas.com;dmarc=pass action=none
 header.from=renesas.com;dkim=pass header.d=renesas.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector2-renesasgroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CMp3YtS4wCIucwyFoj6GQZKQTJ+7805ULG6CeFkscfk=;
 b=kUhRcSb9BIymyuinU2RxTfZ7yeC3BR5BaEamVN1+aCwVBXVwKl2n4zEpnoL98ZwYv9AL7lgQVgzxzOiZYWacaRqncGNkqsJBiX8VrFqDDPozOK2xoTICHCZqBDILOEBfiSOMsvARoPtrWK+pux5sonqiZHfUf+0CHkHPyOBVguo=
Received: from TYAPR01MB4544.jpnprd01.prod.outlook.com (20.179.174.85) by
 TYAPR01MB2672.jpnprd01.prod.outlook.com (20.177.105.85) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2136.14; Wed, 31 Jul 2019 09:58:31 +0000
Received: from TYAPR01MB4544.jpnprd01.prod.outlook.com
 ([fe80::5c8d:f422:6a44:57a9]) by TYAPR01MB4544.jpnprd01.prod.outlook.com
 ([fe80::5c8d:f422:6a44:57a9%5]) with mapi id 15.20.2136.010; Wed, 31 Jul 2019
 09:58:31 +0000
From:   Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
To:     Geert Uytterhoeven <geert@linux-m68k.org>
CC:     Kishon Vijay Abraham I <kishon@ti.com>,
        Pavel Machek <pavel@denx.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Subject: RE: [PATCH] phy: renesas: rcar-gen3-usb2: Fix sysfs interface of
 "role"
Thread-Topic: [PATCH] phy: renesas: rcar-gen3-usb2: Fix sysfs interface of
 "role"
Thread-Index: AQHVR362otT33prCaEaK92EBfQQMwabkdToAgAAHfuA=
Date:   Wed, 31 Jul 2019 09:58:30 +0000
Message-ID: <TYAPR01MB4544CFAACC4C81316CF0760DD8DF0@TYAPR01MB4544.jpnprd01.prod.outlook.com>
References: <1564563689-25863-1-git-send-email-yoshihiro.shimoda.uh@renesas.com>
 <CAMuHMdWhA2xxKKEmmobZDDKGnWNfO4xDb6m6gM16CCFX-1UyTQ@mail.gmail.com>
In-Reply-To: <CAMuHMdWhA2xxKKEmmobZDDKGnWNfO4xDb6m6gM16CCFX-1UyTQ@mail.gmail.com>
Accept-Language: ja-JP, en-US
Content-Language: ja-JP
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=yoshihiro.shimoda.uh@renesas.com; 
x-originating-ip: [118.238.235.108]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 737e20b0-b13d-49e2-baae-08d7159da47e
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:TYAPR01MB2672;
x-ms-traffictypediagnostic: TYAPR01MB2672:
x-microsoft-antispam-prvs: <TYAPR01MB2672B8DE347C65A9738C44CDD8DF0@TYAPR01MB2672.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5236;
x-forefront-prvs: 011579F31F
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(39860400002)(366004)(376002)(136003)(396003)(346002)(189003)(199004)(25786009)(14454004)(3846002)(2906002)(6916009)(6116002)(33656002)(26005)(53546011)(6506007)(54906003)(4326008)(316002)(7696005)(6436002)(99286004)(229853002)(446003)(53936002)(478600001)(76176011)(55016002)(9686003)(11346002)(186003)(66066001)(476003)(305945005)(66556008)(66446008)(71190400001)(71200400001)(7736002)(74316002)(8936002)(6246003)(486006)(8676002)(102836004)(66476007)(86362001)(64756008)(256004)(81166006)(52536014)(76116006)(5660300002)(81156014)(66946007)(68736007);DIR:OUT;SFP:1102;SCL:1;SRVR:TYAPR01MB2672;H:TYAPR01MB4544.jpnprd01.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: renesas.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: u3iK9iFwc4nzwS2nross6tJ7uBFufAE7s2wbxcj07RrY/mVoBBLirnIXMYEkK/2L9jufMSgqHuIdrD1a7WKd9QZ4ZlWfnfiUJZDz1Zy4fl1yR70U4Xl/+IgyT/pn53U+GfO1dfiJxnaQUABP7SU9CZg1TxMvK1hPIeRWWCWb/8ys9ZrdoT3F83DbMeC/9Cwpd9KySbhloLvvaANUIICmi4Z/Wd1eaA0lFseJ2OW7bAPWe/AJAxgvY7rB6zv67deaz5w1aVfn/PJmB5VzFqFQQmuV+WdL4psUa+IVujBGq3eHUoPtdv9C3IP+RvhcezF8A0yFWc9L2x0Kx+3xIHh6WI4irdem20Lrvd7YjTiqr+Sa2F6ai4CR1Dzi3k0nhKJYlv3v2pUXg4wzhW2HAPKPt2z8kC7FUBg7AAj7a7tvHok=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 737e20b0-b13d-49e2-baae-08d7159da47e
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Jul 2019 09:58:30.7433
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yoshihiro.shimoda.uh@renesas.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYAPR01MB2672
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

SGkgR2VlcnQtc2FuLA0KDQo+IEZyb206IEdlZXJ0IFV5dHRlcmhvZXZlbiwgU2VudDogV2VkbmVz
ZGF5LCBKdWx5IDMxLCAyMDE5IDY6MjcgUE0NCj4gDQo+IEhpIFNoaW1vZGEtc2FuLA0KPiANCj4g
T24gV2VkLCBKdWwgMzEsIDIwMTkgYXQgMTE6MDQgQU0gWW9zaGloaXJvIFNoaW1vZGENCj4gPHlv
c2hpaGlyby5zaGltb2RhLnVoQHJlbmVzYXMuY29tPiB3cm90ZToNCj4gPiBTaW5jZSB0aGUgcm9s
ZV9zdG9yZSgpIHVzZXMgc3RybmNtcCgpLCBpdCdzIHBvc3NpYmxlIHRvIHJlZmVyDQo+ID4gb3V0
LW9mLW1lbW9yeSBpZiB0aGUgc3lzZnMgZGF0YSBzaXplIGlzIHNtYWxsZXIgdGhhbiBzdHJsZW4o
Imhvc3QiKS4NCj4gPiBUaGlzIHBhdGNoIGZpeGVzIGl0IGJ5IHVzaW5nIHN5c2ZzX3N0cmVxKCkg
aW5zdGVhZCBvZiBzdHJuY21wKCkuDQo+ID4NCj4gPiBSZXBvcnRlZC1ieTogUGF2ZWwgTWFjaGVr
IDxwYXZlbEBkZW54LmRlPg0KPiA+IEZpeGVzOiA5YmI4Njc3N2ZiNzEgKCJwaHk6IHJjYXItZ2Vu
My11c2IyOiBhZGQgc3lzZnMgZm9yIHVzYiByb2xlIHN3YXAiKQ0KPiA+IENjOiA8c3RhYmxlQHZn
ZXIua2VybmVsLm9yZz4gIyB2NC4xMCsNCj4gPiBTaWduZWQtb2ZmLWJ5OiBZb3NoaWhpcm8gU2hp
bW9kYSA8eW9zaGloaXJvLnNoaW1vZGEudWhAcmVuZXNhcy5jb20+DQo+IA0KPiBSZXZpZXdlZC1i
eTogR2VlcnQgVXl0dGVyaG9ldmVuIDxnZWVydCtyZW5lc2FzQGdsaWRlci5iZT4NCg0KVGhhbmsg
eW91IGZvciB5b3VyIHJldmlldyENCg0KPiA+IC0tLQ0KPiA+ICBKdXN0IGEgcmVjb3JkLiBUaGUg
cm9sZV9zdG9yZSgpIGRvZXNuJ3QgbmVlZCB0byBjaGVjayB0aGUgY291bnQgYmVjYXVzZQ0KPiA+
ICB0aGUgc3lzZnNfc3RyZXEoKSBjaGVja3MgdGhlIGZpcnN0IGFyZ3VtZW50IGlzIE5VTEwgb3Ig
bm90Lg0KPiANCj4gSXMgdGhhdCB3YXQgeW91IG1lYW4/IHN5c2ZzX3N0cmVxKCkgZG9lc24ndCBz
ZWVtIHRvIGNoZWNrIGZvciBOVUxMIHBvaW50ZXJzLg0KDQpPb3BzLCBzb3JyeSBmb3IgdW5jbGVh
ci4gSSBtZWFudCBhIE5VTEwtdGVybWluYXRlZCBzdHJpbmcsIG5vdCBOVUxMIHBvaW50ZXIuDQoN
Cj4gSXNuJ3QgdGhlIHJlYWwgcmVhc29uIHRoYXQgc3lzZnMgKGtlcm5mcykgZ3VhcmFudGVlcyB0
aGF0IHRoZSBwYXNzZWQgYnVmZmVyDQo+IGlzIE5VTC10ZXJtaW5hdGVkPw0KDQpJIGRvZXNuJ3Qg
Y2hlY2sgaW4gZGV0YWlsLCBidXQgSSBhc3N1bWUgc28uDQoNCkJlc3QgcmVnYXJkcywNCllvc2hp
aGlybyBTaGltb2RhDQoNCj4gR3J7b2V0amUsZWV0aW5nfXMsDQo+IA0KPiAgICAgICAgICAgICAg
ICAgICAgICAgICBHZWVydA0KPiANCj4gLS0NCj4gR2VlcnQgVXl0dGVyaG9ldmVuIC0tIFRoZXJl
J3MgbG90cyBvZiBMaW51eCBiZXlvbmQgaWEzMiAtLSBnZWVydEBsaW51eC1tNjhrLm9yZw0KPiAN
Cj4gSW4gcGVyc29uYWwgY29udmVyc2F0aW9ucyB3aXRoIHRlY2huaWNhbCBwZW9wbGUsIEkgY2Fs
bCBteXNlbGYgYSBoYWNrZXIuIEJ1dA0KPiB3aGVuIEknbSB0YWxraW5nIHRvIGpvdXJuYWxpc3Rz
IEkganVzdCBzYXkgInByb2dyYW1tZXIiIG9yIHNvbWV0aGluZyBsaWtlIHRoYXQuDQo+ICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgLS0gTGludXMgVG9ydmFsZHMNCg==
