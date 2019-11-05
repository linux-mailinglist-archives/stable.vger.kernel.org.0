Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D496DEFB62
	for <lists+stable@lfdr.de>; Tue,  5 Nov 2019 11:33:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388868AbfKEKdp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Nov 2019 05:33:45 -0500
Received: from mail-eopbgr1410109.outbound.protection.outlook.com ([40.107.141.109]:6166
        "EHLO JPN01-OS2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388307AbfKEKdo (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 5 Nov 2019 05:33:44 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mudVO5JTf0vON20GVh3gADnIic8bjC73hPc/JLuB4pUY1ZmcYhw61bAMyD9P/JroCM7FNoqydrIqpTlfZ2fTUZj/XqnoXuxhtuOXvtRqeS3YyikdhktOfp3yqlK/rNCG0P2xvlrsMp0mVE5WBi4TPq+JP7HvGslW81yac5HYpbTmMuGVDtKEPwfxOJSUtCIbMiGtnQ4OdiGjRKa0+n/FZGnJdPhrvaXJ68GBBYu6g5HCuytuybEz3aK0W1h7IsgTbRKRuBJD4sGz6zTTQBLOMxxId0SB1IxWVeisxOyGo+42p/HDcTK8ZsQRYnFDVwUuOkdyG7HJR5wKFYpE+5vssw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ao9cs5WA77A4V3La1eNrh9nS+oExCnNoWNafwqaUKXk=;
 b=BH21fic4gRB7A0BCzUc+STOsdgRw4eG3FD3LJDva7CCXao5YjYPKBEaBmG0dObQlgN8x0eXz68g1PTpLSB15X63fK39NOoCv18/I1Fo5LuqQdYvOA9Zlr7McWkDxTxq8uh5cjGXObKVdyTpywUsMlPMS8YlVn/QiGYUy+EUneG2S/ah+7TefdERPfzu7YPp8Lej+iQ8RTw4JtWTwAvzpLw4SYKhjDPuhvhNfL6lGdtDVejZtaUjfEHldWUgnr1ZQQ3aXLpcdCUIo6YEMANUFEgCIKiLdkOB6TxwNTyPa/VkTWm6+H1xwSjvM9HGINrZPfPEE+lVFjHkSYdKcNAiraA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector2-renesasgroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ao9cs5WA77A4V3La1eNrh9nS+oExCnNoWNafwqaUKXk=;
 b=J4MRCIlc/iRE0C+LXYM9qJOJU2TkEOBnjVscw2g4ORAp0/OQPJCiQZ/7YuD7CIc+xIAfXlYknHyIM/D4Pny62q1qBrf4xFvvZ3SG4G+8VIekvBXqcwpAu9ASaWecU2SbaGJAFqdhDp4xGpNPZ98+pMGMRpGoBX8FBS9UdcjoGRk=
Received: from TYAPR01MB4544.jpnprd01.prod.outlook.com (20.179.175.203) by
 TYAPR01MB3664.jpnprd01.prod.outlook.com (20.178.137.81) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2408.24; Tue, 5 Nov 2019 10:33:41 +0000
Received: from TYAPR01MB4544.jpnprd01.prod.outlook.com
 ([fe80::6998:f6cf:8cf1:2528]) by TYAPR01MB4544.jpnprd01.prod.outlook.com
 ([fe80::6998:f6cf:8cf1:2528%5]) with mapi id 15.20.2408.024; Tue, 5 Nov 2019
 10:33:41 +0000
From:   Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
To:     Geert Uytterhoeven <geert@linux-m68k.org>
CC:     Marek Vasut <marek.vasut+renesas@gmail.com>,
        linux-pci <linux-pci@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Subject: RE: [PATCH v3 2/2] PCI: rcar: Fix missing MACCTLR register setting in
 initialize sequence
Thread-Topic: [PATCH v3 2/2] PCI: rcar: Fix missing MACCTLR register setting
 in initialize sequence
Thread-Index: AQHVk4N42hvhhpMBQEKQIOROE56yvqd8RR0AgAAIBGCAAAltgIAAA1tggAAF/4CAAAHUUA==
Date:   Tue, 5 Nov 2019 10:33:41 +0000
Message-ID: <TYAPR01MB45446B3C9E115EB0526D7270D87E0@TYAPR01MB4544.jpnprd01.prod.outlook.com>
References: <1572922092-12323-1-git-send-email-yoshihiro.shimoda.uh@renesas.com>
 <1572922092-12323-3-git-send-email-yoshihiro.shimoda.uh@renesas.com>
 <CAMuHMdWrQs49BFaN49odrG3k91d2rsRLPpCSvDcj5DhKeHPPaA@mail.gmail.com>
 <TYAPR01MB45448947CB09B1A8AC1774A8D87E0@TYAPR01MB4544.jpnprd01.prod.outlook.com>
 <CAMuHMdXvFaPwqo2EHiBMTot05KggRNtL56JOrW_MUrBLL6NHxQ@mail.gmail.com>
 <TYAPR01MB45440A377DBE627FFFCCC287D87E0@TYAPR01MB4544.jpnprd01.prod.outlook.com>
 <CAMuHMdUW5Zb1FXf8OzOYJjZh=yxi3f_s0D-qy3Xw-HEGQRi54A@mail.gmail.com>
In-Reply-To: <CAMuHMdUW5Zb1FXf8OzOYJjZh=yxi3f_s0D-qy3Xw-HEGQRi54A@mail.gmail.com>
Accept-Language: ja-JP, en-US
Content-Language: ja-JP
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=yoshihiro.shimoda.uh@renesas.com; 
x-originating-ip: [150.249.235.54]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 6dc00f06-d007-4dc2-8456-08d761dba06a
x-ms-traffictypediagnostic: TYAPR01MB3664:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <TYAPR01MB366449C53967896EAEEF3AAAD87E0@TYAPR01MB3664.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0212BDE3BE
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(346002)(396003)(376002)(366004)(39860400002)(136003)(189003)(199004)(64756008)(66556008)(11346002)(256004)(66946007)(66446008)(52536014)(478600001)(3846002)(55016002)(99286004)(7696005)(14454004)(66066001)(6436002)(71190400001)(6116002)(966005)(9686003)(6246003)(6306002)(316002)(2906002)(86362001)(102836004)(446003)(476003)(66476007)(486006)(26005)(71200400001)(4326008)(76116006)(8936002)(81156014)(76176011)(74316002)(305945005)(7736002)(6916009)(81166006)(5660300002)(25786009)(8676002)(229853002)(33656002)(54906003)(186003)(6506007)(6606295002);DIR:OUT;SFP:1102;SCL:1;SRVR:TYAPR01MB3664;H:TYAPR01MB4544.jpnprd01.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: renesas.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 75ZUuz5+GCug7xN2OKLlypf3DwyY7mvg2imIopjq4dYP+szlGlSwRYiySWbpq0QQk2kFocnFPeZhEh4JZJhE2HfOXha/2J87iEcixPjrpo7v+OGIMFNHrvfA5j9VgNX73IT2/7Hk1f67/9/gci6+ZQD50B7UxGsoxnEyWqIQZd1aIFAhXTV61KG4wG661wzVPqPUiUCJSlJgs9GPg171YV/EHuMmqLSNL5llBnaDId2qLvdYxLCcPqLWh9s+6prQ6nys1hZwo2ON37p0q0w5IOUW/C4prOcgYgEiH/p8WutFMhOwtGhwDo5G0uPQJ5ov6DxDLvW7CtbpAZlKMJZtL9XRJLlOAXC52lDY2DXFw2MvSH+6bZ3TvwMcUEbPw4oFqTv9m1LgtZYg4nRJmzgpe3cWpOsI5r00wSPW1u1RzcXCGKqTyztNJFMBAxtkNiffngikf6Dl4++MgDbf2UkG+jyCJv+uTXs8V8SE+pD1ij4=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6dc00f06-d007-4dc2-8456-08d761dba06a
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Nov 2019 10:33:41.1522
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6ziht9qtrtnWdiNeh00h5/Ch6s4cnNQCCuH1R0w1f+ulFPctP7aRfgUIeM4mjyzdptI3eKHBBqjoNH1e38IPFQP/fLFymQGM8OpbwhQ8aQKIFOiDNzRbKC5h6vIlncLK
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYAPR01MB3664
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

SGkgR2VlcnQtc2FuLA0KDQo+IEZyb206IEdlZXJ0IFV5dHRlcmhvZXZlbiwgU2VudDogVHVlc2Rh
eSwgTm92ZW1iZXIgNSwgMjAxOSA3OjI2IFBNDQo8c25pcD4NCj4gPiA+ID4gPiA+IC0tLSBhL2Ry
aXZlcnMvcGNpL2NvbnRyb2xsZXIvcGNpZS1yY2FyLmMNCj4gPiA+ID4gPiA+ICsrKyBiL2RyaXZl
cnMvcGNpL2NvbnRyb2xsZXIvcGNpZS1yY2FyLmMNCj4gPiA+ID4gPiA+IEBAIC05MSw4ICs5MSwx
MiBAQA0KPiA+ID4gPiA+ID4gICNkZWZpbmUgIExJTktfU1BFRURfMl81R1RTICAgICAoMSA8PCAx
NikNCj4gPiA+ID4gPiA+ICAjZGVmaW5lICBMSU5LX1NQRUVEXzVfMEdUUyAgICAgKDIgPDwgMTYp
DQo+ID4gPiA+ID4gPiAgI2RlZmluZSBNQUNDVExSICAgICAgICAgICAgICAgICAgICAgICAgMHgw
MTEwNTgNCj4gPiA+ID4gPiA+ICsjZGVmaW5lICBNQUNDVExSX1JFU0VSVkVEMjNfMTYgR0VOTUFT
SygyMywgMTYpDQo+ID4gPiA+ID4NCj4gPiA+ID4gPiBNQUNDVExSX05GVFNfTUFTSz8NCj4gPiA+
ID4NCj4gPiA+ID4gSSBzaG91bGQgaGF2ZSBzYWlkIG9uIHByZXZpb3VzIGVtYWlsIHRocmVhZCBb
MV0gdGhvdWdoLA0KPiA+ID4gPiBzaW5jZSBTSDc3ODYgUENJRSBIVyBtYW51YWwgc2FpZCBORlRT
IChORlRTKSBidXQNCj4gPiA+ID4gYW55IFItQ2FyIFNvQ3MnIEhXIG1hbnVhbCBzYWlkIGp1c3Qg
UmVzZXJ2ZWQgd2l0aCBIJ0ZGLA0KPiA+ID4gPiBzbyB0aGF0IEkgcHJlZmVyIHRvIGRlc2NyaWJl
IFJFU0VSVkVEIGluc3RlYWQgb2YgTkZUUy4NCj4gPiA+ID4gRG8geW91IGFncmVlPw0KPiA+ID4g
Pg0KPiA+ID4gPiBbMV0NCj4gPiA+ID4gaHR0cHM6Ly9tYXJjLmluZm8vP2w9bGludXgtcmVuZXNh
cy1zb2MmbT0xNTcyNDI0MjIzMjczNjgmdz0yDQo+ID4gPg0KPiA+ID4gTXkgcGVyc29uYWwgc3Rh
bmNlIGlzIHRvIG1ha2UgaXQgYXMgZWFzeSBhcyBwb3NzaWJsZSBmb3IgdGhlIHJlYWRlciBvZg0K
PiA+ID4gdGhlIGNvZGUgKCJvcHRpbWl6ZSBmb3IgcmVhZGluZywgbm90IGZvciB3cml0aW5nIiks
IGFzIGNvZGUgaXMgd3JpdHRlbiBvbmNlLA0KPiA+ID4gYnV0IHJlYWQgbWFueSBtb3JlIHRpbWVz
IGxhdGVyLg0KPiA+ID4gVGhpcyBpcyBub3QgdGhlIGZpcnN0IHRpbWUgcmVnaXN0ZXIgYml0cyB3
ZXJlIGRvY3VtZW50ZWQgYmVmb3JlLCBhbmQgY2hhbmdlZA0KPiA+ID4gdG8gcmVzZXJ2ZWQgbGF0
ZXIuDQo+ID4gPiBJbiB0aGlzIGNhc2UgdGhlIHJlc2VtYmxhbmNlIHRvIHRoZSBTSDc3ODYgUENJ
ZSBibG9jayBpcyBvYnZpb3VzLCBhbmQNCj4gPiA+IHRoZSBTSDc3ODYgaGFyZHdhcmUgdXNlcidz
IG1hbnVhbCBpcyBhdmFpbGFibGUgcHVibGljbHkuDQo+ID4NCj4gPiBUaGFuayB5b3UgZm9yIHNo
YXJpbmcgeW91ciBzdGFuY2UuIEkgdW5kZXJzdG9vZCBpdC4gU28sIEknbGwgZml4IGl0IGFzIGZv
bGxvd2luZy4NCj4gPiBJcyBpdCBhY2NlcHRhYmxlPw0KPiA+DQo+ID4gI2RlZmluZSAgTUFDQ1RM
Ul9ORlRTX01BU0sgICAgICBHRU5NQVNLKDIzLCAxNikgLyogVGhlIG5hbWUgaXMgZnJvbSBTSDc3
ODYgKi8NCj4gDQo+IFNvdW5kcyBncmVhdCB0byBtZS4NCj4gVGhhbmtzIQ0KDQpUaGFuayB5b3Ug
Zm9yIHRoZSByZXBseSEgSSBnb3QgaXQhDQoNCkJlc3QgcmVnYXJkcywNCllvc2hpaGlybyBTaGlt
b2RhDQoNCg==
