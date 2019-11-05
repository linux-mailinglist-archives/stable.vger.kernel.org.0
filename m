Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C6C14EFA87
	for <lists+stable@lfdr.de>; Tue,  5 Nov 2019 11:11:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388294AbfKEKLk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Nov 2019 05:11:40 -0500
Received: from mail-eopbgr1400091.outbound.protection.outlook.com ([40.107.140.91]:46700
        "EHLO JPN01-TY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730592AbfKEKLk (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 5 Nov 2019 05:11:40 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gj9p4VZL7IMWLyFggYHmkLyHUiZcRUmvBwLVkjANlArI7DvUSFU0kUxqIBy6Ocq7dHw283lFj2scC6amijpntJr4xdBUpoVzyKPE8k6G7HLU/TgDV6WNxcXAJHBfJ/hZ9osj/hAvXLeVmo06hYWTK+p7pCfx8YH+BSdH8J2yItPLAhZ/h2lNF2Rhtqrpww492HubFsvyJQqikFT8FENkZy7ta7KTplwz6IdCITaRmo7OGMnc+jDfF/WhiRoDjdQP0Dtb/wa7DiftH5nCc92V+LbnBFSp4srUc8k8GW5JOPB1xWv9dDmJumCOmaIRPQ5tPZt5laEYJ9dZnH2DUlU4Lg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fi5xWxGbCUmPkjuGMe2HVD28KcA4GrxmVm7zvc0AR00=;
 b=ZONowZ6KBpk+jhJqQ+c5F5/Y9aqOdw5Skx8bZCavMfeqaolTbxTxcH6HXE1QYgJXa6Rs/Ds3Sm1/avJe6vBknWQ4Rlvis2BJoLeUclIn6F+k7dwSLowh+Sa2buaOlqBk9OHb1+0PLnOzKz0OyREeXnXrDsUgovN4EB4Z306CuwLodfYc+QJwj6/6YEYnhyXS5eC2X7cii+T+8g38a0TVBfmNnk/EdvWWdVywXoFwjlmX56B8cTlxrDNyDVla7OzyEj3ZfxspOzBzUNtieN7RWF/0N5yQ/Up8/jS+R7e2FeJnMDHfUespP+0um+4MrJXB4xxSDscwxZxeCeIUwXun3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector2-renesasgroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fi5xWxGbCUmPkjuGMe2HVD28KcA4GrxmVm7zvc0AR00=;
 b=ikJIiO/h2Z3g5n1Q8E/b9QWpMUGWlZ/DVLvu4xqqPXgsGNTP1BzXTQtRpa/Ld8oOf9K8DXc+LgIwE6iptCgQr4C2EvImunTNOu3NI2ZPMvH6yD7rd61ZtaESZ41WIySU71qXQQgb4ys37qvNJxfPYLaDKi43Y8gLzHqRF2iANQE=
Received: from TYAPR01MB4544.jpnprd01.prod.outlook.com (20.179.175.203) by
 TYAPR01MB4606.jpnprd01.prod.outlook.com (20.179.175.75) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2408.24; Tue, 5 Nov 2019 10:11:37 +0000
Received: from TYAPR01MB4544.jpnprd01.prod.outlook.com
 ([fe80::6998:f6cf:8cf1:2528]) by TYAPR01MB4544.jpnprd01.prod.outlook.com
 ([fe80::6998:f6cf:8cf1:2528%5]) with mapi id 15.20.2408.024; Tue, 5 Nov 2019
 10:11:37 +0000
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
Thread-Index: AQHVk4N42hvhhpMBQEKQIOROE56yvqd8RR0AgAAIBGCAAAltgIAAA1tg
Date:   Tue, 5 Nov 2019 10:11:36 +0000
Message-ID: <TYAPR01MB45440A377DBE627FFFCCC287D87E0@TYAPR01MB4544.jpnprd01.prod.outlook.com>
References: <1572922092-12323-1-git-send-email-yoshihiro.shimoda.uh@renesas.com>
 <1572922092-12323-3-git-send-email-yoshihiro.shimoda.uh@renesas.com>
 <CAMuHMdWrQs49BFaN49odrG3k91d2rsRLPpCSvDcj5DhKeHPPaA@mail.gmail.com>
 <TYAPR01MB45448947CB09B1A8AC1774A8D87E0@TYAPR01MB4544.jpnprd01.prod.outlook.com>
 <CAMuHMdXvFaPwqo2EHiBMTot05KggRNtL56JOrW_MUrBLL6NHxQ@mail.gmail.com>
In-Reply-To: <CAMuHMdXvFaPwqo2EHiBMTot05KggRNtL56JOrW_MUrBLL6NHxQ@mail.gmail.com>
Accept-Language: ja-JP, en-US
Content-Language: ja-JP
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=yoshihiro.shimoda.uh@renesas.com; 
x-originating-ip: [150.249.235.54]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 8228ea0b-143b-4ef1-6aa1-08d761d88b25
x-ms-traffictypediagnostic: TYAPR01MB4606:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <TYAPR01MB460675C04D8702807A067024D87E0@TYAPR01MB4606.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 0212BDE3BE
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(136003)(366004)(396003)(39860400002)(346002)(376002)(199004)(189003)(66476007)(8676002)(66446008)(486006)(8936002)(64756008)(186003)(6506007)(4326008)(14454004)(76176011)(102836004)(33656002)(52536014)(25786009)(53546011)(476003)(446003)(11346002)(5660300002)(256004)(86362001)(6246003)(966005)(99286004)(316002)(54906003)(26005)(81156014)(81166006)(7696005)(71200400001)(71190400001)(478600001)(6436002)(9686003)(76116006)(6306002)(55016002)(66946007)(66066001)(74316002)(2906002)(66556008)(6916009)(305945005)(3846002)(7736002)(229853002)(6116002)(6606295002);DIR:OUT;SFP:1102;SCL:1;SRVR:TYAPR01MB4606;H:TYAPR01MB4544.jpnprd01.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: renesas.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: z2U1/9h5UfVK93NRRirkxsjIn+VEHt5bjh/hYTlpHHuSht76WoNCJ0k2zOqOCOFNRJ7KWLVyACS+yfWr05Mp52V44l/6z4yuRzCELzzeVm6Wlq/RLNw3bDuvZySkWUawkmhYd7R4W1ODcHVf47IgSmuERI0Vv3UP59+b+AXMJb3sHd3EZNfK1/yeeBgvkJNzcrxyMsOQjS6ksXopJd56+lPlYTlRNPNwGA6EX+02TD5mhtweSKwfJq7Z6uqnPrmSbxrqikEWkbaTHfbhZ2Sgj7ge1KgojeJvojwbIcHcw/OjZ8716z+cZWguyT19wnRjMhBT4v32KazGlEoWbt74nPRbB+Xr/mUPwm1ycetjp3xJF1KQqUv2p/Db3NqNxpypSSxRcvh83q1iSVtO2WNgrzb0oLvMN8Hjrh7co1RjmZcX2j1brQjydZ92cVWgQTretGdyB3CuG/LdlhKzT/U+KLPpmtDE1C5YlxjCbhz2mEs=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8228ea0b-143b-4ef1-6aa1-08d761d88b25
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Nov 2019 10:11:36.6822
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +yZBXljEvFMjYu+bLTNhizEVWQQRIooL8SnLIhtMgoB6UYxcJAZQn+7QilvLPIvCQ/yXqK8QMAHJAVSl+TbvrTGThb2QutT9TE08wQVrFFzAiqmaM84k/gaKlOocBQgN
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYAPR01MB4606
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

SGkgR2VlcnQtc2FuLA0KDQo+IEZyb206IEdlZXJ0IFV5dHRlcmhvZXZlbiwgU2VudDogVHVlc2Rh
eSwgTm92ZW1iZXIgNSwgMjAxOSA2OjUzIFBNDQo+IA0KPiBIaSBTaGltb2RhLXNhbiwNCj4gDQo+
IE9uIFR1ZSwgTm92IDUsIDIwMTkgYXQgMTA6MjYgQU0gWW9zaGloaXJvIFNoaW1vZGENCj4gPHlv
c2hpaGlyby5zaGltb2RhLnVoQHJlbmVzYXMuY29tPiB3cm90ZToNCj4gPiA+IEZyb206IEdlZXJ0
IFV5dHRlcmhvZXZlbiwgU2VudDogVHVlc2RheSwgTm92ZW1iZXIgNSwgMjAxOSA1OjUwIFBNDQo+
ID4gPiBPbiBUdWUsIE5vdiA1LCAyMDE5IGF0IDM6NDggQU0gWW9zaGloaXJvIFNoaW1vZGENCj4g
PiA+IDx5b3NoaWhpcm8uc2hpbW9kYS51aEByZW5lc2FzLmNvbT4gd3JvdGU6DQo+ID4gPiA+IEFj
Y29yZGluZyB0byB0aGUgUi1DYXIgR2VuMi8zIG1hbnVhbCwgIkJlIHN1cmUgdG8gd3JpdGUgdGhl
IGluaXRpYWwNCj4gPiA+ID4gdmFsdWUgKD0gSCc4MEZGIDAwMDApIHRvIE1BQ0NUTFIgYmVmb3Jl
IGVuYWJsaW5nIFBDSUVUQ1RMUi5DRklOSVQiLg0KPiA+ID4gPiBUbyBhdm9pZCB1bmV4cGVjdGVk
IGJlaGF2aW9ycywgdGhpcyBwYXRjaCBmaXhlcyBpdC4gTm90ZSB0aGF0DQo+ID4gPiA+IHRoZSBT
UENIRyBiaXQgb2YgTUFDQ1RMUiByZWdpc3RlciBkZXNjcmlwdGlvbiBzYWlkICJPbmx5IHdyaXRp
bmcgMQ0KPiA+ID4gPiBpcyB2YWxpZCBhbmQgd3JpdGluZyAwIGlzIGludmFsaWQiIGJ1dCB0aGlz
ICJpbnZhbGlkIiBtZWFucw0KPiA+ID4gPiAiaWdub3JlZCIsIG5vdCAicHJvaGliaXRlZCIuIFNv
LCBhbnkgZG9jdW1lbnRhdGlvbiBjb25mbGljdCBkb2Vzbid0DQo+ID4gPiA+IGV4aXN0IGFib3V0
IHdyaXRpbmcgdGhlIE1BQ0NUTFIgcmVnaXN0ZXIuDQo+ID4gPiA+DQo+ID4gPiA+IFJlcG9ydGVk
LWJ5OiBFdWdlbml1IFJvc2NhIDxlcm9zY2FAZGUuYWRpdC1qdi5jb20+DQo+ID4gPiA+IEZpeGVz
OiBjMjVkYTQ3Nzg4MDMgKCJQQ0k6IHJjYXI6IEFkZCBSZW5lc2FzIFItQ2FyIFBDSWUgZHJpdmVy
IikNCj4gPiA+ID4gRml4ZXM6IGJlMjBiYmNiMGE4YyAoIlBDSTogcmNhcjogQWRkIHRoZSBpbml0
aWFsaXphdGlvbiBvZiBQQ0llIGxpbmsgaW4gcmVzdW1lX25vaXJxKCkiKQ0KPiA+ID4gPiBDYzog
PHN0YWJsZUB2Z2VyLmtlcm5lbC5vcmc+ICMgdjUuMisNCj4gPiA+ID4gU2lnbmVkLW9mZi1ieTog
WW9zaGloaXJvIFNoaW1vZGEgPHlvc2hpaGlyby5zaGltb2RhLnVoQHJlbmVzYXMuY29tPg0KPiA+
ID4NCj4gPiA+IFRoYW5rcyBmb3IgeW91ciBwYXRjaCENCj4gPiA+DQo+ID4gPiA+IC0tLSBhL2Ry
aXZlcnMvcGNpL2NvbnRyb2xsZXIvcGNpZS1yY2FyLmMNCj4gPiA+ID4gKysrIGIvZHJpdmVycy9w
Y2kvY29udHJvbGxlci9wY2llLXJjYXIuYw0KPiA+ID4gPiBAQCAtOTEsOCArOTEsMTIgQEANCj4g
PiA+ID4gICNkZWZpbmUgIExJTktfU1BFRURfMl81R1RTICAgICAoMSA8PCAxNikNCj4gPiA+ID4g
ICNkZWZpbmUgIExJTktfU1BFRURfNV8wR1RTICAgICAoMiA8PCAxNikNCj4gPiA+ID4gICNkZWZp
bmUgTUFDQ1RMUiAgICAgICAgICAgICAgICAgICAgICAgIDB4MDExMDU4DQo+ID4gPiA+ICsjZGVm
aW5lICBNQUNDVExSX1JFU0VSVkVEMjNfMTYgR0VOTUFTSygyMywgMTYpDQo+ID4gPg0KPiA+ID4g
TUFDQ1RMUl9ORlRTX01BU0s/DQo+ID4NCj4gPiBJIHNob3VsZCBoYXZlIHNhaWQgb24gcHJldmlv
dXMgZW1haWwgdGhyZWFkIFsxXSB0aG91Z2gsDQo+ID4gc2luY2UgU0g3Nzg2IFBDSUUgSFcgbWFu
dWFsIHNhaWQgTkZUUyAoTkZUUykgYnV0DQo+ID4gYW55IFItQ2FyIFNvQ3MnIEhXIG1hbnVhbCBz
YWlkIGp1c3QgUmVzZXJ2ZWQgd2l0aCBIJ0ZGLA0KPiA+IHNvIHRoYXQgSSBwcmVmZXIgdG8gZGVz
Y3JpYmUgUkVTRVJWRUQgaW5zdGVhZCBvZiBORlRTLg0KPiA+IERvIHlvdSBhZ3JlZT8NCj4gPg0K
PiA+IFsxXQ0KPiA+IGh0dHBzOi8vbWFyYy5pbmZvLz9sPWxpbnV4LXJlbmVzYXMtc29jJm09MTU3
MjQyNDIyMzI3MzY4Jnc9Mg0KPiANCj4gTXkgcGVyc29uYWwgc3RhbmNlIGlzIHRvIG1ha2UgaXQg
YXMgZWFzeSBhcyBwb3NzaWJsZSBmb3IgdGhlIHJlYWRlciBvZg0KPiB0aGUgY29kZSAoIm9wdGlt
aXplIGZvciByZWFkaW5nLCBub3QgZm9yIHdyaXRpbmciKSwgYXMgY29kZSBpcyB3cml0dGVuIG9u
Y2UsDQo+IGJ1dCByZWFkIG1hbnkgbW9yZSB0aW1lcyBsYXRlci4NCj4gVGhpcyBpcyBub3QgdGhl
IGZpcnN0IHRpbWUgcmVnaXN0ZXIgYml0cyB3ZXJlIGRvY3VtZW50ZWQgYmVmb3JlLCBhbmQgY2hh
bmdlZA0KPiB0byByZXNlcnZlZCBsYXRlci4NCj4gSW4gdGhpcyBjYXNlIHRoZSByZXNlbWJsYW5j
ZSB0byB0aGUgU0g3Nzg2IFBDSWUgYmxvY2sgaXMgb2J2aW91cywgYW5kDQo+IHRoZSBTSDc3ODYg
aGFyZHdhcmUgdXNlcidzIG1hbnVhbCBpcyBhdmFpbGFibGUgcHVibGljbHkuDQoNClRoYW5rIHlv
dSBmb3Igc2hhcmluZyB5b3VyIHN0YW5jZS4gSSB1bmRlcnN0b29kIGl0LiBTbywgSSdsbCBmaXgg
aXQgYXMgZm9sbG93aW5nLg0KSXMgaXQgYWNjZXB0YWJsZT8NCg0KI2RlZmluZSAgTUFDQ1RMUl9O
RlRTX01BU0sJR0VOTUFTSygyMywgMTYpCS8qIFRoZSBuYW1lIGlzIGZyb20gU0g3Nzg2ICovDQoN
CkJlc3QgcmVnYXJkcywNCllvc2hpaGlybyBTaGltb2RhDQoNCj4gR3J7b2V0amUsZWV0aW5nfXMs
DQo+IA0KPiAgICAgICAgICAgICAgICAgICAgICAgICBHZWVydA0KPiANCj4gLS0NCj4gR2VlcnQg
VXl0dGVyaG9ldmVuIC0tIFRoZXJlJ3MgbG90cyBvZiBMaW51eCBiZXlvbmQgaWEzMiAtLSBnZWVy
dEBsaW51eC1tNjhrLm9yZw0KPiANCj4gSW4gcGVyc29uYWwgY29udmVyc2F0aW9ucyB3aXRoIHRl
Y2huaWNhbCBwZW9wbGUsIEkgY2FsbCBteXNlbGYgYSBoYWNrZXIuIEJ1dA0KPiB3aGVuIEknbSB0
YWxraW5nIHRvIGpvdXJuYWxpc3RzIEkganVzdCBzYXkgInByb2dyYW1tZXIiIG9yIHNvbWV0aGlu
ZyBsaWtlIHRoYXQuDQo+ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgLS0gTGludXMg
VG9ydmFsZHMNCg==
