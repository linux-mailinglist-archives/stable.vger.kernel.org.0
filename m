Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 57AA9EF8A5
	for <lists+stable@lfdr.de>; Tue,  5 Nov 2019 10:26:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730667AbfKEJ0m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Nov 2019 04:26:42 -0500
Received: from mail-eopbgr1410100.outbound.protection.outlook.com ([40.107.141.100]:13496
        "EHLO JPN01-OS2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730655AbfKEJ0m (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 5 Nov 2019 04:26:42 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BAS/j3jL56+ywaRqKXAxqTX2QnBLnwIJreXcByl5GO25fza+yQiaUNll6/r9PvILoFOjfQ1IuhGn0/29x/fwr0uKj/jLMvt1zHtBj4gPWNM2xwl+/JlePd6hGJZbmoc/cHG8IvE08hUV3535M3lSGdpnNpSPQRvlOkxxRiPGeu7XwLSMUTDelm3arcBfIYK4XT4cJv/ZEb6tHVdqm1huIdJWlQOptvqZao1lh9K3iKMijZY6roJxFwP1Zu2jN7ddis6vuWE6EraNl2chzN1yDrUShBKNbZwgIUE5MZ2wIWwPva9IU4GMJfzU8VJu3OjjVwHUB0XRR/eRlt5rB/hIvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T70YEzhKFRVEohe7CiSuSJ+vsoGB47An0B+2BYeGK6o=;
 b=NiYXzc37i4RDeQtDe8GbQuc0fpLwi+1sxGdlwNZz2rKRfIBuYKsS0kEUPDyINh+mSDhCsXFZnvBRh/gtJQ093VhAQTMIdSc9yee4JJrczMUMrmlEFvTIXtCxfeM467WPTqTVu4LguOM3GfQlnZM4+giTK9iSM2hB0QatywUjjSDkU45FiPkDk+qOcO+N7Gs+rmeBukSkFKje4+pskwbNs/kxvNTLtTYhptW6lHVap9zNs38oPEVg7kIz4Vewh3Grs93Fq3pC65j4MKkZqCvpg1Fhq+Jg33/AN7Cik1UkUQMtJAxAHvhmWlo2ir0ZeyWLmsjXJfP6LVmxTDzD8LMNSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector2-renesasgroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T70YEzhKFRVEohe7CiSuSJ+vsoGB47An0B+2BYeGK6o=;
 b=Qt2r21zLUwUrTwQD3HPrEIl9ZaTRDe3tJwcy3nV/7B91oEo3b88Jc8rKdArJymK2RYTzO3h8NnQ8eZORXaUb43LEtnmNR2OgT7QAGDtbbUMBwm0bZVD7XZwbiI+3XvjN/s15Sanr1p7Y2yGptif/tIcyS6wJpCP94O5vNt0DH1s=
Received: from TYAPR01MB4544.jpnprd01.prod.outlook.com (20.179.175.203) by
 TYAPR01MB2749.jpnprd01.prod.outlook.com (20.177.101.203) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2408.24; Tue, 5 Nov 2019 09:26:39 +0000
Received: from TYAPR01MB4544.jpnprd01.prod.outlook.com
 ([fe80::6998:f6cf:8cf1:2528]) by TYAPR01MB4544.jpnprd01.prod.outlook.com
 ([fe80::6998:f6cf:8cf1:2528%5]) with mapi id 15.20.2408.024; Tue, 5 Nov 2019
 09:26:39 +0000
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
Thread-Index: AQHVk4N42hvhhpMBQEKQIOROE56yvqd8RR0AgAAIBGA=
Date:   Tue, 5 Nov 2019 09:26:39 +0000
Message-ID: <TYAPR01MB45448947CB09B1A8AC1774A8D87E0@TYAPR01MB4544.jpnprd01.prod.outlook.com>
References: <1572922092-12323-1-git-send-email-yoshihiro.shimoda.uh@renesas.com>
 <1572922092-12323-3-git-send-email-yoshihiro.shimoda.uh@renesas.com>
 <CAMuHMdWrQs49BFaN49odrG3k91d2rsRLPpCSvDcj5DhKeHPPaA@mail.gmail.com>
In-Reply-To: <CAMuHMdWrQs49BFaN49odrG3k91d2rsRLPpCSvDcj5DhKeHPPaA@mail.gmail.com>
Accept-Language: ja-JP, en-US
Content-Language: ja-JP
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=yoshihiro.shimoda.uh@renesas.com; 
x-originating-ip: [150.249.235.54]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: a032612a-2d2c-410f-fd44-08d761d24325
x-ms-traffictypediagnostic: TYAPR01MB2749:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <TYAPR01MB2749F69631D7A1CD68668C00D87E0@TYAPR01MB2749.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0212BDE3BE
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(376002)(366004)(136003)(396003)(39860400002)(346002)(199004)(189003)(66556008)(9686003)(66946007)(64756008)(53546011)(76176011)(6916009)(6306002)(76116006)(966005)(66476007)(229853002)(55016002)(256004)(26005)(54906003)(99286004)(186003)(6506007)(6436002)(66446008)(7696005)(316002)(446003)(486006)(476003)(8936002)(66066001)(6246003)(305945005)(102836004)(3846002)(6116002)(478600001)(14454004)(86362001)(5660300002)(52536014)(4326008)(71200400001)(2906002)(8676002)(74316002)(71190400001)(33656002)(25786009)(7736002)(11346002)(81166006)(81156014)(6606295002);DIR:OUT;SFP:1102;SCL:1;SRVR:TYAPR01MB2749;H:TYAPR01MB4544.jpnprd01.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: renesas.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: NsggHutIQezleF6kewFuCkKSUGsfHrLxQ1DywK/Bq/R76KQdmwBNZfKKijf8Cilx2XCSHCV0l55cVzjufHBRn3f9DtYi78OJU7Q5J/rYz5tyFA/PMU3Im4D3oBF6KvbMoyL8MknhsCc+tD4e8IpHcFpXWexiyVNzQQw5U79MvxfaQpbp+AVjtz+MGCEEOe+4BHdBT6PX4CWA9LTcLY76GHo1F4EGKieljgQDfDhOhEvl/bKSLPxfTuCCdMVSc5zk+tYqhTwMDOun2+9R1ZM+0FHYt3pHWhcIEZ9jOJXOeCS3CqiN6sZCFJ1MIto5hCC5voENmSK/rZ+wVZDunL8m8225e/rhlYDv2mz3UUI8tVCS68kB4TCkZV0aBqy1t73JLJaN5OZ+WHVvulZUIuI+r6ycbbfr8cqL7R8wcoHnfXhHIWUQ3Hk/dlkuH047Em3CXX76J1kuyLjIWMKVXUQNanaTaJdMGvl/peWliQd/sZ8=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a032612a-2d2c-410f-fd44-08d761d24325
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Nov 2019 09:26:39.2564
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: uDfrrdmo9E2Cq3p3scy5LgBbd3G+MhtZ0liRUFGK6PYYM6d47UBixB43/61slQ+NuOddKL51RY4yKFpLjpa+qVMH951JOP9XcK+hl3l7Y5kH6bKXVIyCGXvCvFGw9ucW
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYAPR01MB2749
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

SGkgR2VlcnQtc2FuLA0KDQpUaGFuayB5b3UgZm9yIHlvdXIgcmV2aWV3IQ0KDQo+IEZyb206IEdl
ZXJ0IFV5dHRlcmhvZXZlbiwgU2VudDogVHVlc2RheSwgTm92ZW1iZXIgNSwgMjAxOSA1OjUwIFBN
DQo+IA0KPiBIaSBTaGltb2RhLXNhbiwNCj4gDQo+IE9uIFR1ZSwgTm92IDUsIDIwMTkgYXQgMzo0
OCBBTSBZb3NoaWhpcm8gU2hpbW9kYQ0KPiA8eW9zaGloaXJvLnNoaW1vZGEudWhAcmVuZXNhcy5j
b20+IHdyb3RlOg0KPiA+IEFjY29yZGluZyB0byB0aGUgUi1DYXIgR2VuMi8zIG1hbnVhbCwgIkJl
IHN1cmUgdG8gd3JpdGUgdGhlIGluaXRpYWwNCj4gPiB2YWx1ZSAoPSBIJzgwRkYgMDAwMCkgdG8g
TUFDQ1RMUiBiZWZvcmUgZW5hYmxpbmcgUENJRVRDVExSLkNGSU5JVCIuDQo+ID4gVG8gYXZvaWQg
dW5leHBlY3RlZCBiZWhhdmlvcnMsIHRoaXMgcGF0Y2ggZml4ZXMgaXQuIE5vdGUgdGhhdA0KPiA+
IHRoZSBTUENIRyBiaXQgb2YgTUFDQ1RMUiByZWdpc3RlciBkZXNjcmlwdGlvbiBzYWlkICJPbmx5
IHdyaXRpbmcgMQ0KPiA+IGlzIHZhbGlkIGFuZCB3cml0aW5nIDAgaXMgaW52YWxpZCIgYnV0IHRo
aXMgImludmFsaWQiIG1lYW5zDQo+ID4gImlnbm9yZWQiLCBub3QgInByb2hpYml0ZWQiLiBTbywg
YW55IGRvY3VtZW50YXRpb24gY29uZmxpY3QgZG9lc24ndA0KPiA+IGV4aXN0IGFib3V0IHdyaXRp
bmcgdGhlIE1BQ0NUTFIgcmVnaXN0ZXIuDQo+ID4NCj4gPiBSZXBvcnRlZC1ieTogRXVnZW5pdSBS
b3NjYSA8ZXJvc2NhQGRlLmFkaXQtanYuY29tPg0KPiA+IEZpeGVzOiBjMjVkYTQ3Nzg4MDMgKCJQ
Q0k6IHJjYXI6IEFkZCBSZW5lc2FzIFItQ2FyIFBDSWUgZHJpdmVyIikNCj4gPiBGaXhlczogYmUy
MGJiY2IwYThjICgiUENJOiByY2FyOiBBZGQgdGhlIGluaXRpYWxpemF0aW9uIG9mIFBDSWUgbGlu
ayBpbiByZXN1bWVfbm9pcnEoKSIpDQo+ID4gQ2M6IDxzdGFibGVAdmdlci5rZXJuZWwub3JnPiAj
IHY1LjIrDQo+ID4gU2lnbmVkLW9mZi1ieTogWW9zaGloaXJvIFNoaW1vZGEgPHlvc2hpaGlyby5z
aGltb2RhLnVoQHJlbmVzYXMuY29tPg0KPiANCj4gVGhhbmtzIGZvciB5b3VyIHBhdGNoIQ0KPiAN
Cj4gPiAtLS0gYS9kcml2ZXJzL3BjaS9jb250cm9sbGVyL3BjaWUtcmNhci5jDQo+ID4gKysrIGIv
ZHJpdmVycy9wY2kvY29udHJvbGxlci9wY2llLXJjYXIuYw0KPiA+IEBAIC05MSw4ICs5MSwxMiBA
QA0KPiA+ICAjZGVmaW5lICBMSU5LX1NQRUVEXzJfNUdUUyAgICAgKDEgPDwgMTYpDQo+ID4gICNk
ZWZpbmUgIExJTktfU1BFRURfNV8wR1RTICAgICAoMiA8PCAxNikNCj4gPiAgI2RlZmluZSBNQUND
VExSICAgICAgICAgICAgICAgICAgICAgICAgMHgwMTEwNTgNCj4gPiArI2RlZmluZSAgTUFDQ1RM
Ul9SRVNFUlZFRDIzXzE2IEdFTk1BU0soMjMsIDE2KQ0KPiANCj4gTUFDQ1RMUl9ORlRTX01BU0s/
DQoNCkkgc2hvdWxkIGhhdmUgc2FpZCBvbiBwcmV2aW91cyBlbWFpbCB0aHJlYWQgWzFdIHRob3Vn
aCwNCnNpbmNlIFNINzc4NiBQQ0lFIEhXIG1hbnVhbCBzYWlkIE5GVFMgKE5GVFMpIGJ1dA0KYW55
IFItQ2FyIFNvQ3MnIEhXIG1hbnVhbCBzYWlkIGp1c3QgUmVzZXJ2ZWQgd2l0aCBIJ0ZGLA0Kc28g
dGhhdCBJIHByZWZlciB0byBkZXNjcmliZSBSRVNFUlZFRCBpbnN0ZWFkIG9mIE5GVFMuDQpEbyB5
b3UgYWdyZWU/DQoNClsxXQ0KaHR0cHM6Ly9tYXJjLmluZm8vP2w9bGludXgtcmVuZXNhcy1zb2Mm
bT0xNTcyNDI0MjIzMjczNjgmdz0yDQoNCj4gPiAgI2RlZmluZSAgU1BFRURfQ0hBTkdFICAgICAg
ICAgIEJJVCgyNCkNCj4gPiAgI2RlZmluZSAgU0NSQU1CTEVfRElTQUJMRSAgICAgIEJJVCgyNykN
Cj4gPiArI2RlZmluZSAgTFRTTURJUyAgICAgICAgICAgICAgIEJJVCgzMSkNCj4gPiArICAgICAg
ICAvKiBCZSBzdXJlIHRvIHdyaXRlIHRoZSBpbml0aWFsIHZhbHVlIChIJzgwRkYgMDAwMCkgdG8g
TUFDQ1RMUiAqLw0KPiANCj4gRG8gd2UgbmVlZCB0aGlzIGNvbW1lbnQ/DQoNCkl0J3MgYSBsaXR0
bGUgcmVkdW5kYW50LiBTbywgSSdsbCByZW1vdmUgaXQuDQoNCj4gPiArI2RlZmluZSAgTUFDQ1RM
Ul9JTklUX1ZBTCAgICAgIChMVFNNRElTIHwgTUFDQ1RMUl9SRVNFUlZFRDIzXzE2KQ0KPiA+ICAj
ZGVmaW5lIFBNU1IgICAgICAgICAgICAgICAgICAgMHgwMTEwNWMNCj4gPiAgI2RlZmluZSBNQUNT
MlIgICAgICAgICAgICAgICAgIDB4MDExMDc4DQo+ID4gICNkZWZpbmUgTUFDQ0dTUFNFVFIgICAg
ICAgICAgICAweDAxMTA4NA0KPiANCj4gV2l0aCB0aGUgYWJvdmUgZml4ZWQ6DQo+IFJldmlld2Vk
LWJ5OiBHZWVydCBVeXR0ZXJob2V2ZW4gPGdlZXJ0K3JlbmVzYXNAZ2xpZGVyLmJlPg0KDQpUaGFu
a3MhDQoNCkJlc3QgcmVnYXJkcywNCllvc2hpaGlybyBTaGltb2RhDQoNCg==
