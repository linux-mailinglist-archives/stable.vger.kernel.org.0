Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ABDD11221F5
	for <lists+stable@lfdr.de>; Tue, 17 Dec 2019 03:27:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726594AbfLQC1n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 21:27:43 -0500
Received: from us03-smtprelay2.synopsys.com ([149.117.87.133]:43752 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726313AbfLQC1n (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Dec 2019 21:27:43 -0500
Received: from mailhost.synopsys.com (badc-mailhost1.synopsys.com [10.192.0.17])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 441ABC00C1;
        Tue, 17 Dec 2019 02:27:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1576549662; bh=tED33+/qSSFVlYl+GzgK7CFpsoiQB25SOJyY7Sgo77M=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=YTd+9OHd/Kb9OK/OMF45gnF8g4LK6pky3q6B/cEbNmcW5mzJyXg2zfEGRVboD7Kpp
         vnPV722/LkV8LdoK+vz8eC2izTBpjka9rmiMO30iDQPMSgrsYO7WLfpanDmCO5p9Iu
         8Ep8n9uOU6ph2R01DtGK8v+BFUx5dQZflkVxZmD8CFngppDvPYBgQS/aJ+4fvHOkqx
         BDxL9apYNu1JRF5ZnI4C1bSABv+f1VTXukmCT3Wzk4e0/ywAj6cq7UHxhScJMWMs+C
         yg7TtGrEmiDNOuNsrWNhLhvan6T4wlmKMNn/1KFX88FZQiZIiokQN7nb0wsIeWaZOO
         /XA4v8RuEAkGg==
Received: from US01WEHTC3.internal.synopsys.com (us01wehtc3.internal.synopsys.com [10.15.84.232])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPS id C5189A00BA;
        Tue, 17 Dec 2019 02:27:41 +0000 (UTC)
Received: from US01HYBRID2.internal.synopsys.com (10.15.246.24) by
 US01WEHTC3.internal.synopsys.com (10.15.84.232) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Mon, 16 Dec 2019 18:27:41 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (10.202.3.67) by
 mrs.synopsys.com (10.15.246.24) with Microsoft SMTP Server (TLS) id
 14.3.408.0; Mon, 16 Dec 2019 18:27:41 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WNuN4pRAuvRdkkE4G1VhJLiaK2ePkKxnOLUKCVunsO6GyPQRTfASFgy9KPx3o0rRmit93ZUtIRZAqeCB7z3wRx5rjWrdqNbkzTaHSbnLm3jxUVvrAr5Zd6ntcC8ZWXg5dKNDFaUY35cdWBBDrbLJJ8xgkj3TWl5n57daIIkBzez0ZvWjF6gNyPcGtsPyB3Nj8OuwqXgYVB1zaHhTiqPzkE7VRHks5+Rv+jjeXnK67kCVcQhGLUxIZW3WLX7wYKAOnarasRANRJ/kCtvylZgZz/QKHxrjK2F+zaxTgVBwZX7rYOUBPNhs5gIA4X1KK1JY78HM539a6wHUjmLMtBojzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tED33+/qSSFVlYl+GzgK7CFpsoiQB25SOJyY7Sgo77M=;
 b=KxciSnUZvHOFAUWUAhsk03Quc/Ns3ACvQK8ulc9TH9FEwL4FRoyL15QJROBxFf2FlBluxqphM+4Ryeeqxvf4X0P6nU99+2HMiQ2669NI1OwNROGHcHXBQqmngJfcyP4Zq121DY8LH/FUiJnhyLZto4+5WGWDqsJaGWy5PEPV7CSPCqcVXYXxaCqY3sj64BnbywJLJt3/X5UTHwtFFFSYGUDEnkhYz2uAP+86hrYCh+Dl+NuR5FxCuNhMKzN2Z90nQebhfmhGY365pvWKD9GaRn2pi2uuMythXEzDV3jaCxNjkmlmuPlkPA5dGh+lsyeMecN/XcaxCVXYZJ9ADlPSmg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synopsys.com; dmarc=pass action=none header.from=synopsys.com;
 dkim=pass header.d=synopsys.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=synopsys.onmicrosoft.com; s=selector2-synopsys-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tED33+/qSSFVlYl+GzgK7CFpsoiQB25SOJyY7Sgo77M=;
 b=IKeFI/Wzwy6b/aQTLqZuReL7nLWv0C2m4haNY34ZlHmqVdRxO6mjTdMIdc/ok6SMZIDNVbElzh4s95ayXHV2+EbbPYuMJLSKwc9ZjFBHMFQs5q1eyF5XGTxVkBslPE8Q19YbZdfWO7II/RfO0f9HlxfA8Ip5Tq68wrs24pcVbMk=
Received: from CY4PR1201MB0037.namprd12.prod.outlook.com (10.172.78.22) by
 CY4PR1201MB0214.namprd12.prod.outlook.com (10.174.54.141) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2538.16; Tue, 17 Dec 2019 02:27:39 +0000
Received: from CY4PR1201MB0037.namprd12.prod.outlook.com
 ([fe80::5d88:202f:2fff:24b4]) by CY4PR1201MB0037.namprd12.prod.outlook.com
 ([fe80::5d88:202f:2fff:24b4%8]) with mapi id 15.20.2538.019; Tue, 17 Dec 2019
 02:27:39 +0000
From:   Thinh Nguyen <Thinh.Nguyen@synopsys.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thinh Nguyen <Thinh.Nguyen@synopsys.com>
CC:     Felipe Balbi <balbi@kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        John Youn <John.Youn@synopsys.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] usb: dwc3: gadget: Fix request complete check
Thread-Topic: [PATCH] usb: dwc3: gadget: Fix request complete check
Thread-Index: AQHVsigAd9WQJ29skU2jXDoNP4DdNqe48UuAgAKBpgCAAivYAA==
Date:   Tue, 17 Dec 2019 02:27:39 +0000
Message-ID: <15fe8fac-10b5-c753-6a2d-0a81eeec6887@synopsys.com>
References: <ac5a3593a94fdaa3d92e6352356b5f7a01ccdc7c.1576291140.git.thinhn@synopsys.com>
 <5a7554e4-a12e-d29c-1767-5dd75183922f@synopsys.com>
 <20191215171812.GA853060@kroah.com>
In-Reply-To: <20191215171812.GA853060@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=thinhn@synopsys.com; 
x-originating-ip: [149.117.75.13]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 654ced12-e361-4070-f267-08d78298afe4
x-ms-traffictypediagnostic: CY4PR1201MB0214:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CY4PR1201MB02141676B2FBE94A36959F75AA500@CY4PR1201MB0214.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 02543CD7CD
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(366004)(396003)(39860400002)(346002)(376002)(189003)(199004)(66684002)(186003)(6512007)(26005)(316002)(6506007)(71200400001)(8676002)(81156014)(76116006)(81166006)(8936002)(66556008)(66476007)(66946007)(66446008)(64756008)(2906002)(478600001)(4326008)(54906003)(31686004)(86362001)(2616005)(110136005)(36756003)(6486002)(5660300002)(31696002);DIR:OUT;SFP:1102;SCL:1;SRVR:CY4PR1201MB0214;H:CY4PR1201MB0037.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: synopsys.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 2StKyQxEnGmQMcrrRH+47lvwFpeg/0Cx8Y3GHmq7pRzgI9aGk2Kp9NapxvgOprNlPIDgrGUMND7VIg5a3vdwvbW0ZMJsLVbZdrG/hlUK9swauQ/05KPOCDAHZxJSCZBHPvyz0tFFl8vzd50U3MDSVwCyw1RL2rxnZxpAsZ3W4KWgk8q6IL8mz012p1BsaY7iu3n8LhVfamhW5mi0p2LWXx0Ez1PJGK6tM+G77y3i0uUvjeutcV6xVkHMSCODimTb+jJJMb9ulZD2Cr6yqCJjx03q0op5Bf/u9zNbpbrMWAbHKI+3OyaRtU3QYm1PXkMMm3deYUWgQhuR7RbTY0nB7VtgxazfoCbsSMnn5KjKaeKkuPSw9D3e6ILZgQlD6lacZO0cSgFJ82dC30dQBEmXw9bpL/Awok0lz59IQIy1K/9bvJFsJgyv1jI61AC5AF/WWn1PKYUOmL/Zkooy2aYJtmPvCkHnMuPepqVkpImCfJk/j3eeGDFqIQ7Wv2NzkeKa
Content-Type: text/plain; charset="utf-8"
Content-ID: <B2D3D7A3D441D14EBC046BF4BE005134@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 654ced12-e361-4070-f267-08d78298afe4
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Dec 2019 02:27:39.2242
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: KsDDef0Atm6WVAPhR6uzrm8T3s97+jpzaMV0TxI5Tt+m4zrbvHhKCea81JdZ7fcY6U9lfxfm13lJcbPiT+AK8w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1201MB0214
X-OriginatorOrg: synopsys.com
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

SGksDQoNCkdyZWcgS3JvYWgtSGFydG1hbiB3cm90ZToNCj4gT24gU2F0LCBEZWMgMTQsIDIwMTkg
YXQgMDM6MDE6NDBBTSArMDAwMCwgVGhpbmggTmd1eWVuIHdyb3RlOg0KPj4gSGkgR3JlZyBhbmQg
RmVsaXBlLA0KPj4NCj4+IFRoaW5oIE5ndXllbiB3cm90ZToNCj4+PiBXZSBjYW4gb25seSBjaGVj
ayBmb3IgSU4gZGlyZWN0aW9uIGlmIHRoZSByZXF1ZXN0IGhhZCBjb21wbGV0ZWQuIEZvciBPVVQN
Cj4+PiBkaXJlY3Rpb24sIGl0J3MgcGVyZmVjdGx5IGZpbmUgdGhhdCB0aGUgaG9zdCBjYW4gc2Vu
ZCBsZXNzIHRoYW4gdGhlDQo+Pj4gc2V0dXAgbGVuZ3RoLiBMZXQncyByZXR1cm4gdHJ1ZSBmYWxs
IGFsbCBjYXNlcyBvZiBPVVQgZGlyZWN0aW9uLg0KPj4+DQo+Pj4gRml4ZXM6IGUwYzQyY2U1OTBm
ZSAoInVzYjogZHdjMzogZ2FkZ2V0OiBzaW1wbGlmeSBJT0MgaGFuZGxpbmciKQ0KPj4+DQo+Pj4g
Q2M6IHN0YWJsZUB2Z2VyLmtlcm5lbC5vcmcNCj4+PiBTaWduZWQtb2ZmLWJ5OiBUaGluaCBOZ3V5
ZW4gPHRoaW5obkBzeW5vcHN5cy5jb20+DQo+Pj4gLS0tDQo+Pj4gICAgZHJpdmVycy91c2IvZHdj
My9nYWRnZXQuYyB8IDcgKysrKysrKw0KPj4+ICAgIDEgZmlsZSBjaGFuZ2VkLCA3IGluc2VydGlv
bnMoKykNCj4+Pg0KPj4+IGRpZmYgLS1naXQgYS9kcml2ZXJzL3VzYi9kd2MzL2dhZGdldC5jIGIv
ZHJpdmVycy91c2IvZHdjMy9nYWRnZXQuYw0KPj4+IGluZGV4IGIzZjg1MTRkMWYyNy4uZWRjNDc4
YzIwODQ2IDEwMDY0NA0KPj4+IC0tLSBhL2RyaXZlcnMvdXNiL2R3YzMvZ2FkZ2V0LmMNCj4+PiAr
KysgYi9kcml2ZXJzL3VzYi9kd2MzL2dhZGdldC5jDQo+Pj4gQEAgLTI0NzAsNiArMjQ3MCwxMyBA
QCBzdGF0aWMgaW50IGR3YzNfZ2FkZ2V0X2VwX3JlY2xhaW1fdHJiX2xpbmVhcihzdHJ1Y3QgZHdj
M19lcCAqZGVwLA0KPj4+ICAgIA0KPj4+ICAgIHN0YXRpYyBib29sIGR3YzNfZ2FkZ2V0X2VwX3Jl
cXVlc3RfY29tcGxldGVkKHN0cnVjdCBkd2MzX3JlcXVlc3QgKnJlcSkNCj4+PiAgICB7DQo+Pj4g
KwkvKg0KPj4+ICsJICogRm9yIE9VVCBkaXJlY3Rpb24sIGhvc3QgbWF5IHNlbmQgbGVzcyB0aGFu
IHRoZSBzZXR1cA0KPj4+ICsJICogbGVuZ3RoLiBSZXR1cm4gdHJ1ZSBmb3IgYWxsIE9VVCByZXF1
ZXN0cy4NCj4+PiArCSAqLw0KPj4+ICsJaWYgKCFyZXEtPmRpcmVjdGlvbikNCj4+PiArCQlyZXR1
cm4gdHJ1ZTsNCj4+PiArDQo+Pj4gICAgCXJldHVybiByZXEtPnJlcXVlc3QuYWN0dWFsID09IHJl
cS0+cmVxdWVzdC5sZW5ndGg7DQo+Pj4gICAgfQ0KPj4+ICAgIA0KPj4gTm90IHN1cmUgaWYgaXQn
cyB0b28gbGF0ZSwgYnV0IGFmdGVyIFRlamFzJ3MgcGF0Y2gqIHRoYXQgZml4ZXMgdGhlIFNHDQo+
PiBjaGVjayBpbiBkd2MzLCBpdCBleHBvc2VzIGFub3RoZXIgaXNzdWUuIFdpdGhvdXQgdGhpcyBw
YXRjaCwgcXVpdGUgYSBmZXcNCj4+IGZ1bmN0aW9uIGRyaXZlcnMgd2lsbCBub3Qgd29yayB3aXRo
IGR3YzMuDQo+Pg0KPj4gSWYgd2UgY2FuIHBpY2sgaXQgdXAgYmVmb3JlIHRoZSBuZXh0IG1lcmdl
LCBpdCdkIGJlIGdyZWF0Lg0KPiBXaGF0IGV4YWN0bHkgYnJlYWtzIHdpdGhvdXQgdGhpcyBwYXRj
aD8gIEFuZCBob3cgd2FzIHRoZSBvcmlnaW5hbCBwYXRjaA0KPiBldmVyIHRlc3RlZD8NCj4NCj4g
dGhhbmtzLA0KPg0KPiBncmVnIGstaA0KDQpJZiB0aGUgaG9zdCBoYXBwZW5zIHRvIHNlbmQgbGVz
cyB0aGFuIHRoZSBzZXR1cCBsZW5ndGgsIHRoZW4gdGhlIGR3YzMgDQpkcml2ZXIgdGhpbmtzIHRo
YXQgdGhlIGNvbnRyb2xsZXIgaGFzbid0IGNvbXBsZXRlZCBwcm9jZXNzaW5nIHRoZSANCnJlcXVl
c3QuIEl0IHdpbGwgdHJ5IHRvIHJlc3RhcnQgdGhlIHRyYW5zZmVyIHdpdGhvdXQgZ2l2aW5nIGJh
Y2sgdGhlIA0KcmVxdWVzdCB0byB0aGUgZnVuY3Rpb24gZHJpdmVyLiBBcyBhIHJlc3VsdCwgdGhl
IGZ1bmN0aW9uIGRyaXZlciBtYXkgbm90IA0KYmUgYWJsZSBwcm9jZWVkIGFzIHRoZSBkd2MzIGRy
aXZlciBzdGlsbCBvd25zIHRoZSByZXF1ZXN0Lg0KDQpBcyB5b3UgYXJlIGF3YXJlLCBUZWphcydz
IHBhdGNoIGlzIHN0aWxsIGNvcnJlY3QuIFdlIGp1c3QgZGlkbid0IGRvIGEgDQpmdWxsIHRlc3Qg
c3VpdGUgd2l0aCB0aGF0IHBhdGNoIHRvIGZpbmQgbW9yZSBpc3N1ZXMuIEp1c3Qgc28gaGFwcGVu
ZWQgDQp0aGF0IGhpcyBwYXRjaCB1bmNvdmVyZWQgYW5vdGhlciBjcml0aWNhbCBpc3N1ZSBpbiBk
d2MzLiBUaGF0J3Mgd2h5IEkgDQpzZW50IHRoZSBwcmV2aW91cyBlbWFpbCBob3BpbmcgdGhhdCB3
ZSBjYW4gZ2V0IHRoaXMgZml4IGluIGJlZm9yZSB0aGUgDQpuZXh0IHB1bGwgcmVxdWVzdC4gU2Vl
bXMgbGlrZSBpdCdzIHRvbyBsYXRlIG5vdywgYnV0IHRoYXQgc2hvdWxkIGJlIGZpbmUuDQoNClRo
YW5rcyBHcmVnLA0KVGhpbmgNCg0KDQo=
