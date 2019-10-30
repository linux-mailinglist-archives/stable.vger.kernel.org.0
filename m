Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4442FE9A70
	for <lists+stable@lfdr.de>; Wed, 30 Oct 2019 11:55:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726709AbfJ3KzC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Oct 2019 06:55:02 -0400
Received: from mail-eopbgr1400112.outbound.protection.outlook.com ([40.107.140.112]:16256
        "EHLO JPN01-TY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726184AbfJ3KzB (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 30 Oct 2019 06:55:01 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nikVD3MiJyI4j6QZbP6QMpLuWuo8Ciuo6TxBFnqUq1PPbbzwmUtMSFXlNO8uq30CO3za2yL9JLWmvZSlnHCDp1zZIXWm801Myl5YxT4ILIJAbktEmr1GTvBtvPsWFh0hkFKVhI3vfp5BZEsEVOy+uAjm6+gu245yBAqQ1kZi4vEpGnTJz4DiDzR03qaICyS79pXQaQbrIYLBBnueeV4xvqw6Pq+Ia+ojMQ3MsQvbGyG7aWMvmzA7OYhr0l/HCjh4Wg8/CPGbHBo6XgVfAO7XORlSNN0Wq2NmKtkIYhvofeYfYBOJKANexCfmByoSFkUAopquiySKbZPGHLIKUcwqPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fTBnueVLT5wFN+5wbmvt0C5NwdxD2Eu4NzUz5Y2SZis=;
 b=lkMkePywubP58+GM/ZD9o8Rt5Bx5w2ewyuLnN6blSIlVc/RZW56jLayszZmOp/ccSNJgOU3LvlDWTsT96Tej0d/SFj3rzE1RmqGx2ZwDXixVd7sOoIH8dg/+7YmHndx9xpKzEImpsfAqILgjKzEsviyObgfXonRryEKV67/IC4GkLDyguC87h/s0Po2Xi+u8UXFVwV9vuo3em20JGVbOrO5WVRI1bysyawNII3uHFUVjqf0xv2R49ewnEnOYfHlfm9+A1EpI0Ye075+uXs+56TahXjS5D1Hndo3V/u2mxzBq0sZZs9UC0Sw4suSR5Kh9bfjwjH6F+L7CeSXcpj4lzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector2-renesasgroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fTBnueVLT5wFN+5wbmvt0C5NwdxD2Eu4NzUz5Y2SZis=;
 b=rz9gnA0yFK/UkiBOY0rcAATbfWAV72vfDYgsB/74rTxRt4zS2nESwgzt4dWyO/Dk7R2nwHKK9RCDKBezwmOanrhnZ2k1vgdyWTDuecJ+CU3wHf3PMpt4LQpGAqA/8DbWdB+I2xmX2YV1dZL5O2gmwTTqotF8ZzpIuH8N3WzHLPE=
Received: from TYAPR01MB4544.jpnprd01.prod.outlook.com (20.179.175.203) by
 TYAPR01MB3198.jpnprd01.prod.outlook.com (20.177.103.82) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2387.24; Wed, 30 Oct 2019 10:54:58 +0000
Received: from TYAPR01MB4544.jpnprd01.prod.outlook.com
 ([fe80::548:32de:c810:1947]) by TYAPR01MB4544.jpnprd01.prod.outlook.com
 ([fe80::548:32de:c810:1947%4]) with mapi id 15.20.2387.028; Wed, 30 Oct 2019
 10:54:58 +0000
From:   Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
To:     Geert Uytterhoeven <geert@linux-m68k.org>
CC:     "REE erosca@DE.ADIT-JV.COM" <erosca@DE.ADIT-JV.COM>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        "horms@verge.net.au" <horms@verge.net.au>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Yohhei Fukui <yohhei.fukui@denso-ten.com>,
        Asano Yasushi <yasano@jp.adit-jv.com>,
        Steffen Pengel <spengel@jp.adit-jv.com>,
        Andrew Gabbasov <andrew_gabbasov@mentor.com>,
        Eugeniu Rosca <roscaeugeniu@gmail.com>
Subject: RE: [PATCH v4] PCI: rcar: Fix missing MACCTLR register setting in
 rcar_pcie_hw_init()
Thread-Topic: [PATCH v4] PCI: rcar: Fix missing MACCTLR register setting in
 rcar_pcie_hw_init()
Thread-Index: AQHVf+9qjSU3Sv51RE+DQhHbHCYXz6dxzQWAgAC8WBCAAG87AIAAJ8fA
Date:   Wed, 30 Oct 2019 10:54:58 +0000
Message-ID: <TYAPR01MB4544F1923120021A1D6A31D8D8600@TYAPR01MB4544.jpnprd01.prod.outlook.com>
References: <1570769432-15358-1-git-send-email-yoshihiro.shimoda.uh@renesas.com>
 <20191029143753.GA28404@vmlxhi-102.adit-jv.com>
 <TYAPR01MB45441F470C83E7CAEF4D72E0D8600@TYAPR01MB4544.jpnprd01.prod.outlook.com>
 <CAMuHMdXxhrJ0bqGi3JZkjgrr7=p-_NfA7Lmd8q32=Ho4tEXw0A@mail.gmail.com>
In-Reply-To: <CAMuHMdXxhrJ0bqGi3JZkjgrr7=p-_NfA7Lmd8q32=Ho4tEXw0A@mail.gmail.com>
Accept-Language: ja-JP, en-US
Content-Language: ja-JP
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=yoshihiro.shimoda.uh@renesas.com; 
x-originating-ip: [150.249.235.54]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 0d3ad0cc-f4c0-41bd-1baa-08d75d279b30
x-ms-traffictypediagnostic: TYAPR01MB3198:
x-ld-processed: 53d82571-da19-47e4-9cb4-625a166a4a2a,ExtAddr
x-microsoft-antispam-prvs: <TYAPR01MB319838585A350CA844872334D8600@TYAPR01MB3198.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 02065A9E77
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(346002)(39860400002)(376002)(136003)(396003)(366004)(189003)(199004)(2906002)(71190400001)(6246003)(3846002)(7416002)(6916009)(33656002)(71200400001)(256004)(6116002)(4326008)(7696005)(229853002)(52536014)(5660300002)(99286004)(86362001)(9686003)(66946007)(11346002)(14454004)(66066001)(446003)(102836004)(486006)(6506007)(74316002)(478600001)(476003)(55016002)(7736002)(6436002)(186003)(26005)(8936002)(81156014)(81166006)(305945005)(8676002)(316002)(25786009)(66476007)(76176011)(64756008)(66556008)(66446008)(54906003)(76116006);DIR:OUT;SFP:1102;SCL:1;SRVR:TYAPR01MB3198;H:TYAPR01MB4544.jpnprd01.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: renesas.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: fJq4Luc766nQY838iICt37MbNJjNoBLszmuwWZBBPXTCalBwQjQct/zBKzvJBkCx4WC0LoWji2Rqdmz0AYzvFLHmCBl5J8opE7kBQ+dWM2vWeXZbJk1VvNvGxocB5oVkW633RbUVK5qjI7laLCbXYgIBoxNEX2rshV+DCEfO3ASJDczbZEKOhyrPfzdxjsnvOco9Gs/+50h9+zldRphH6EUwrUwLTcGEtmNm/IjQr08dJYcecZiDpJFzGaymSmhF75dL8+doIHhnvNl17aGel6HhOuyhrImZwIvowcbELacRKV6nSB+AzehUAZYQRogEF6MCermBcMQCXYF6chpRZvCzweTXD21RLQAaTGrRFXqo/RJsDQlGHZH9OLIduS2bAE1DEmn3F95DXblezQnPZ5kyxTUR3r2BXWVUpF6wL5OOv+yXNIejMrGbdCbHS+7N
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0d3ad0cc-f4c0-41bd-1baa-08d75d279b30
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Oct 2019 10:54:58.2544
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yshSKBbcn0EifbMO81HacByi4tIHUEXNiYYC+zJXxGbqdMq371IwYfzc2oEVdwQbF3hEL4ZgT2Xr6BaFzxkxfLkFVtp+3S+G0tObndJZ0iPI/ygOpjK5GJ7WfbWp3y3O
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYAPR01MB3198
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

SGkgR2VlcnQtc2FuLA0KDQo+IEZyb206IEdlZXJ0IFV5dHRlcmhvZXZlbiwgU2VudDogV2VkbmVz
ZGF5LCBPY3RvYmVyIDMwLCAyMDE5IDU6MzAgUE0NCjxzbmlwPg0KPiA+ID4gWW91ciBkZXZlbG9w
bWVudCBhbmQgcmV2aWV3aW5nIGVmZm9ydCB0byByZWFjaCB2NCBpcyB2ZXJ5IGFwcHJlY2lhdGVk
Lg0KPiA+ID4NCj4gPiA+IEhvd2V2ZXIsIGluIHRoZSBjb250ZXh0IG9mIHNvbWUgaW50ZXJuYWwg
cmV2aWV3cyBvZiB0aGlzIHBhdGNoLCB3ZSBhcmUNCj4gPiA+IGhhdmluZyBoYXJkIHRpbWVzIHJl
Y29uY2lsaW5nIHRoZSBjaGFuZ2Ugd2l0aCBvdXIgKHBvc3NpYmx5IGluY29tcGxldGUNCj4gPiA+
IG9yIGluYWNjdXJhdGUpIGludGVycHJldGF0aW9uIG9mIHRoZSBSLUNhcjMgSFcgVXNlcuKAmXMg
TWFudWFsIChSZXYuMi4wMA0KPiA+ID4gSnVsIDIwMTkpLiBUaGUgbGF0dGVyIHNheXMgaW4NCj4g
PiA+IENoYXB0ZXIgIjU0LiBQQ0lFIENvbnRyb2xsZXIiIC8gIigyKSBJbml0aWFsIFNldHRpbmcg
b2YgUENJIEV4cHJlc3MiOg0KPiA+ID4NCj4gPiA+ICAtLS0tc25pcC0tLS0NCj4gPiA+ICBCZSBz
dXJlIHRvIHdyaXRlIHRoZSBpbml0aWFsIHZhbHVlICg9IEgnODBGRiAwMDAwKSB0byBNQUNDVExS
IGJlZm9yZQ0KPiA+ID4gIGVuYWJsaW5nIFBDSUVUQ1RMUi5DRklOSVQuDQo+ID4gPiAgLS0tLXNu
aXAtLS0tDQo+ID4gPg0KPiA+ID4gSXMgbXkgYXNzdW1wdGlvbiBjb3JyZWN0IHRoYXQgdGhlIGRl
c2NyaXB0aW9uIG9mIHRoaXMgcGF0Y2ggaXMgYQ0KPiA+ID4gcmV3b3JkaW5nIG9mIHRoZSBhYm92
ZSBxdW90ZSBmcm9tIHRoZSBtYW51YWwgPHNuaXA+DQo+ID4NCj4gPiBZb3UgYXJlIGNvcnJlY3Qu
IFNpbmNlIHRoZSByZXNldCB2YWx1ZSBvZiBNQUNDVExSIGlzIEgnODBGRiAwMDAxLCBJIHRob3Vn
aHQNCj4gPiBjbGVhcmluZyB0aGUgTFNCIGJpdCB3YXMgZW5vdWdoLg0KPiA+IEhvd2V2ZXIsIGFz
IHlvdXIgc2l0dWF0aW9uLCBJIHRoaW5rIEkgc2hvdWxkIGhhdmUgZGVzY3JpYmVkIHRoZSBhYm92
ZSBxdW90ZQ0KPiA+IGZyb20gdGhlIG1hbnVhbCBhbmQgaGF2ZSBzdWNoIGEgY29kZSAod3JpdGlu
ZyB0aGUgdmFsdWUgaW5zdGVhZCBvZiBjbGVhcmluZw0KPiA+IHRoZSBMU0Igb25seSkuDQo+ID4N
Cj4gPiA+IElmIGl0IGlzIG9ubHkgdGhlIExTQiB3aGljaCAic2hvdWxkIGJlIHdyaXR0ZW4gdG8g
MCBiZWZvcmUgZW5hYmxpbmcNCj4gPiA+IFBDSUVUQ1RMUi5DRklOSVQiLCB3b3VsZCB5b3UgYWdy
ZWUgdGhhdCB0aGUgc3RhdGVtZW50IHF1b3RlZCBmcm9tIHRoZQ0KPiA+ID4gbWFudWFsIHdvdWxk
IGJldHRlciBiZSByZXBocmFzZWQgYXBwcm9wcmlhdGVseT8gVElBLg0KPiA+DQo+ID4gQXMgSSBt
ZW50aW9uZWQgYWJvdmUsIEkgdGhpbmsgdGhlIGFib3ZlIHF1b3RlIGZyb20gdGhlIG1hbnVhbCBp
cyBiZXR0ZXINCj4gPiB0aGFuIHJlcGhyYXNlZC4NCj4gPg0KPiA+IFNlcmdlaSwgR2VlcnQtc2Fu
LCBJIHRoaW5rIHdlIHNob3VsZCByZXZlcnQgdGhpcyBwYXRjaCBhbmQgZml4IGNvZGUvY29tbWl0
DQo+ID4gbG9nIHRvIGZvbGxvdyB0aGUgbWFudWFsLiBXaGF0IGRvIHlvdSB0aGluaz8NCj4gDQo+
IFRoZSBpbml0aWFsIHZhbHVlIG1lbnRpb25lZCBpbiB0aGUgbWFudWFsIG1ha2VzIHNlbnNlIHRv
IG1lLg0KPiBPZiBjb3Vyc2Ugd2hlbiB1c2luZyB0aGF0LCAjZGVmaW5lcyBzaG91bGQgYmUgYWRk
ZWQgZm9yIGJpdHMgdXNlZCwgdG8NCj4gYXZvaWQgd3JpdGluZyB0aGUgbWFnaWNhbCB2YWx1ZSAi
MHg4MGZmMDAwMSIuDQoNClRoYW5rIHlvdSBmb3IgeW91ciByZXBseSEgU28sIEknbGwgc3VibWl0
IHR3byBwYXRjaGVzIChyZXZlcnQgaXQgYXQgZmlyc3QNCmFuZCB0aGVuIGZpeCBhZ2FpbikgbGF0
ZXIuDQoNCj4gSW5pdGlhbGx5LCB0aGUgImZmIiBwYXJ0IHdvcnJpZWQgbWUuICBGb3J0dW5hdGVs
eSBzb21lIGFyY2hhZW9sb2d5IGxlYXJuZWQNCj4gbWUgdGhhdCB0aGVzZSBiaXRzIHdoZXJlIGNh
bGxlZCAiTkZUUyIgaW4gdGhlIFNINzc4NiBIYXJkd2FyZSBVc2VyJ3MNCj4gTWFudWFsLCBhbmQg
dXNlZCB0byBzcGVjaWZ5IHRoZSBudW1iZXIgb2YgRmFzdCBUcmFpbmluZyBTZXF1ZW5jZXMgdG8N
Cj4gYmUgdHJhbnNmZXJyZWQgd2hlbiB0aGUgTUFDIHJldHVybnMgZnJvbSBMMCB0byBMMHMgKDYt
LTI1NSkuDQo+IA0KPiBhcmNoL3NoL2RyaXZlcnMvcGNpL3BjaWUtc2g3Nzg2LmMgc2VlbXMgdG8g
YmUgYXdhcmUgb2YgdGhpczoNCj4gDQo+ICAgICAgICAgLyoNCj4gICAgICAgICAgKiBTZXQgZmFz
dCB0cmFpbmluZyBzZXF1ZW5jZXMgdG8gdGhlIG1heGltdW0gMjU1LA0KPiAgICAgICAgICAqIGFu
ZCBlbmFibGUgTUFDIGRhdGEgc2NyYW1ibGluZy4NCj4gICAgICAgICAgKi8NCj4gICAgICAgICBk
YXRhID0gcGNpX3JlYWRfcmVnKGNoYW4sIFNINEFfUENJRU1BQ0NUTFIpOw0KPiAgICAgICAgIGRh
dGEgJj0gflBDSUVNQUNDVExSX1NDUl9ESVM7DQo+ICAgICAgICAgZGF0YSB8PSAoMHhmZiA8PCAx
Nik7DQo+ICAgICAgICAgcGNpX3dyaXRlX3JlZyhjaGFuLCBkYXRhLCBTSDRBX1BDSUVNQUNDVExS
KTsNCg0KSSBkaWRuJ3Qga25vdyB0aGF0Li4NCg0KPiBObyBpZGVhIHdoeSB0aGlzIHdhcyBkZWVt
ZWQgbm90LXRvLWJlLW1vZGlmaWVkIGJ5IHRoZSB1c2VyIGxhdGVyDQo+IChhcyBvZiBSLUNhciBI
MSkuDQoNClNhbWUgaGVyZS4uLg0KDQpCZXN0IHJlZ2FyZHMsDQpZb3NoaWhpcm8gU2hpbW9kYQ0K
DQo+IEdye29ldGplLGVldGluZ31zLA0KPiANCj4gICAgICAgICAgICAgICAgICAgICAgICAgR2Vl
cnQNCj4gDQo+IC0tDQo+IEdlZXJ0IFV5dHRlcmhvZXZlbiAtLSBUaGVyZSdzIGxvdHMgb2YgTGlu
dXggYmV5b25kIGlhMzIgLS0gZ2VlcnRAbGludXgtbTY4ay5vcmcNCj4gDQo+IEluIHBlcnNvbmFs
IGNvbnZlcnNhdGlvbnMgd2l0aCB0ZWNobmljYWwgcGVvcGxlLCBJIGNhbGwgbXlzZWxmIGEgaGFj
a2VyLiBCdXQNCj4gd2hlbiBJJ20gdGFsa2luZyB0byBqb3VybmFsaXN0cyBJIGp1c3Qgc2F5ICJw
cm9ncmFtbWVyIiBvciBzb21ldGhpbmcgbGlrZSB0aGF0Lg0KPiAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgIC0tIExpbnVzIFRvcnZhbGRzDQo=
