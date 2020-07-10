Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AC7521B347
	for <lists+stable@lfdr.de>; Fri, 10 Jul 2020 12:40:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726774AbgGJKkT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Jul 2020 06:40:19 -0400
Received: from mail-mw2nam12on2050.outbound.protection.outlook.com ([40.107.244.50]:22712
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726369AbgGJKkN (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 10 Jul 2020 06:40:13 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KobHSK2l8ib+72BR6fzzwjMbZHjQiz26gfodskNDpzzEsJeooVTpUHryZt3a5ylYsvnlvigXvcC/WsiPAdhQ9rLxjYHJs4u+lFXi1oDAR0KuTGM+QmK/iGPr6EURaogjyKbp7JUK516ioh0Y0HVwfE9Da8b0Cj9BC63RSJj2Cd0lAkMyD1uhApLMluBKYgHHylz44BjLK3VzuQNXm5HN/DezsVSBn9kFc8hsw0qnOw3vfpX+hdMhYy0NBkhx8SXj2MGyKCn/YxhJk6lhvPyiQsExZft8aWV15VVYaUMxuou+u5QINnGW24QY5X4i5h9c3P3WVTn7286d6z6GxSlVBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ArcNTvGzqv+1cEkFAILr3fNuML5gS/xxaFNHbS6s8b8=;
 b=WcmudmNvTG1RhDRLNj6LTOmFRtmE5AxuZXqmtNYiar7CkMovp84lN30EeguC6j1WiVEHc9rP5nbhBMuK+6UyLqGUATAbdCEZ/uvedU30jSCgYprCzcPp0rlsAUHXD/8DOauWETWQ9dmbjttwiVlBhnjsLG6bgg8V1VfrOuyvWf/GRvPx3PgZq+Q9YRBBt6YilBlGLY73ZwQSSyI5rShHQWPoS+QnqqvPMOm4Rzsqthb5QXwUCBgGF6xE9KRDUzebC/gxJLzW/6GfG6eCf82O/mJkP6gnMQ9ieAgGWKfqRMwv9it73Z0w9Bq5VG8eyvgPWWWc51208un0mmdYRVo4Fw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=infinera.com; dmarc=pass action=none header.from=infinera.com;
 dkim=pass header.d=infinera.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=infinera.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ArcNTvGzqv+1cEkFAILr3fNuML5gS/xxaFNHbS6s8b8=;
 b=N3eeoaK/Kb9jKYLnThZ3QQRw0P4H+u8Tdvsuky5e+66sHnMF16FJaMyeEfP5q94jKLJfa7yOMsmBIn0112TZbuUKY3KWLqx+tb5wiZrSQVGeZu07enrKyIn7jMA+2RXujrYM0zbhcBuwiMNNL7xi1YpVU+B30fX5P6YGz66tBiQ=
Received: from MWHPR1001MB2190.namprd10.prod.outlook.com
 (2603:10b6:301:2e::20) by MWHPR10MB1677.namprd10.prod.outlook.com
 (2603:10b6:301:a::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.23; Fri, 10 Jul
 2020 10:40:09 +0000
Received: from MWHPR1001MB2190.namprd10.prod.outlook.com
 ([fe80::b439:ba0:98d6:c2d1]) by MWHPR1001MB2190.namprd10.prod.outlook.com
 ([fe80::b439:ba0:98d6:c2d1%5]) with mapi id 15.20.3174.021; Fri, 10 Jul 2020
 10:40:08 +0000
From:   Joakim Tjernlund <Joakim.Tjernlund@infinera.com>
To:     "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
Subject: Re: [PATCH] cdc-acm: acm_init: Set initial BAUD to B0
Thread-Topic: [PATCH] cdc-acm: acm_init: Set initial BAUD to B0
Thread-Index: AQHWVp10AvhYW+hsHEuT/7Zwfc2fs6kAnkqAgAABb4A=
Date:   Fri, 10 Jul 2020 10:40:08 +0000
Message-ID: <a73d776095222a9a8951dd38f41e9b14f8470622.camel@infinera.com>
References: <20200710093518.22272-1-joakim.tjernlund@infinera.com>
         <20200710103459.GA1203263@kroah.com>
In-Reply-To: <20200710103459.GA1203263@kroah.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.37.3 
authentication-results: linuxfoundation.org; dkim=none (message not signed)
 header.d=none;linuxfoundation.org; dmarc=none action=none
 header.from=infinera.com;
x-originating-ip: [88.131.87.201]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b30074ad-20aa-40f5-4ca7-08d824bd9dd1
x-ms-traffictypediagnostic: MWHPR10MB1677:
x-microsoft-antispam-prvs: <MWHPR10MB16774D06CF06B38EA03C9AB3F4650@MWHPR10MB1677.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1060;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: pGdkkwc4KqVFt/BXdeMwgPDhm94XuOOWl4/iNM4RyGnUVdwMxxKLOU3c6+vI+nJsw9Q1LLSCfSR9JoD4DQRPnTI18mq/bOB122rGzfQDVidWQ3Lp0Ku6QiFiYCYC9OUTZhlD3B9Ak02UNWVUQiLmQ2sW2M8GEbMFafAcBfsXWwQ2n9RYj7vy7Q+gPbj4TbPhmzNJKs0ZlF1Sz9NCuffNoOX0piQoXQrXiW/cFn1qdPwr9rcBQuiGqnq9jjnZfchZ+a5mvLvQgSBP4+f16AO7cqZpM5kz6U5nBGGr7KHFsEat/fN8HhRcw1Dwk/OosSAs
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2190.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(39860400002)(346002)(136003)(366004)(396003)(6486002)(71200400001)(66446008)(64756008)(66556008)(66476007)(316002)(54906003)(36756003)(91956017)(76116006)(66946007)(2906002)(83380400001)(6512007)(86362001)(478600001)(6916009)(6506007)(26005)(2616005)(5660300002)(8936002)(8676002)(186003)(4326008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: Caj7V3fCcenxslxUS5VproErll7c6ekrjyynmpzX8ezhw7kXWFeNWZjjBivClfmaJIUBWr8ZWhJfunguzP7hBloBWHizN1o/nVtKYBTc/xfjwziG+a4hthJe//NZ825wOPVTGpUQty8GEy7B4VL8UKynI4XrE4XOylZf1kiBhRikUdd2uuJxduDFv5eP20WhmescR2P6CfPzCQya7BeZEpmT7d+h8g3ljg8zM75/Oimhha1tLSTspDYmpkiYOCtI9ewUaPtgoS4mpSUPCOCcRxKnh8Q4MU2XH+C3mMr7F5YJOtuXwFl4vsKSVJxGg4Vn6RB3OsSNiR1mIK+26nUhYfUasXJgUkasuROnhtY1k3X7XyTKtJJkGAWf0fLbapuknLX/F2wKax+AHdnfSsFCJKuIVdmMMQhlYLOTyaDVsKnsfIKoeQLL3HSI9bQyErZQSEYWZndrcsxYdarUDbBBtoS9ty+Da7ok1JHRH3Y1kLdb0zzCJEpZNQianutzN9XP
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <851D7D956A4A5F469569B5DD6911450A@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: infinera.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2190.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b30074ad-20aa-40f5-4ca7-08d824bd9dd1
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Jul 2020 10:40:08.5974
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 285643de-5f5b-4b03-a153-0ae2dc8aaf77
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: v+yMnNm+OsRYJFOX+m9VygkWZlD8ielw4yKRkCLrBikfndmDhpqVpcJpsaurHJgqxWzYM+gxQDVa7p2BcLyQ/Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1677
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

T24gRnJpLCAyMDIwLTA3LTEwIGF0IDEyOjM0ICswMjAwLCBHcmVnIEtIIHdyb3RlOg0KDQo+IE9u
IEZyaSwgSnVsIDEwLCAyMDIwIGF0IDExOjM1OjE4QU0gKzAyMDAsIEpvYWtpbSBUamVybmx1bmQg
d3JvdGU6DQo+ID4gQk8gd2lsbCBkaXNhYmxlIFVTQiBpbnB1dCB1bnRpbCB0aGUgZGV2aWNlIG9w
ZW5zLiBUaGlzIHdpbGwNCj4gPiBhdm9pZCBnYXJiYWdlIGNoYXJzIHdhaXRpbmcgZmxvb2QgdGhl
IFRUWS4gVGhpcyBtaW1pY3MgYSByZWFsIFVBUlQNCj4gPiBkZXZpY2UgYmV0dGVyLg0KPiA+IEZv
ciBpbml0aWFsIHRlcm1pb3MgdG8gcmVhY2ggVVNCIGNvcmUsIFVTQiBkcml2ZXIgaGFzIHRvIGJl
DQo+ID4gcmVnaXN0ZXJlZCBiZWZvcmUgVFRZIGRyaXZlci4NCj4gDQo+IFlvdSBhcmUgZG9pbmcg
dHdvIGRpZmZlcmVudCB0aGluZ3MgaGVyZSwgcGxlYXNlIGJyZWFrIHRoaXMgdXAgaW50byAyDQo+
IHBhdGNoZXMsIHdpdGggZ29vZCBkb2N1bWVudGF0aW9uIGZvciBib3RoIG9mIHRoZW0uDQoNCk9L
DQoNCj4gDQo+IEFuZCBhbnkgcmVhc29uIHlvdSBkaWRuJ3Qgc2VuZCB0aGlzIHRvIHRoZSBwZW9w
bGUgbGlzdGVkIGluDQo+IHNjcmlwdHMvZ2V0X21haW50YWluZXJzLnBsIHdoZW4gcnVuIG9uIHRo
aXMgcGF0Y2g/DQoNCmhtbSwgbm8uIEkganVzdCBkaWRuJ3QgY2hlY2ssIHNvcnJ5Lg0KDQo+IA0K
PiA+IA0KPiA+IFNpZ25lZC1vZmYtYnk6IEpvYWtpbSBUamVybmx1bmQgPGpvYWtpbS50amVybmx1
bmRAaW5maW5lcmEuY29tPg0KPiA+IENjOiBzdGFibGVAdmdlci5rZXJuZWwub3JnDQo+ID4gLS0t
DQo+ID4gDQo+ID4gwqBJIGhvcGUgdGhpcyBjaGFuZ2UgbWFrZXMgc2Vuc2UgdG8geW91LCBpZiBz
byBJIGJlbGl2ZQ0KPiA+IMKgdHR5VVNCIGNvdWxkIGRvIHRoZSBzYW1lLg0KPiA+IA0KPiA+IMKg
ZHJpdmVycy91c2IvY2xhc3MvY2RjLWFjbS5jIHwgOCArKysrLS0tLQ0KPiA+IMKgMSBmaWxlIGNo
YW5nZWQsIDQgaW5zZXJ0aW9ucygrKSwgNCBkZWxldGlvbnMoLSkNCj4gPiANCj4gPiBkaWZmIC0t
Z2l0IGEvZHJpdmVycy91c2IvY2xhc3MvY2RjLWFjbS5jIGIvZHJpdmVycy91c2IvY2xhc3MvY2Rj
LWFjbS5jDQo+ID4gaW5kZXggNzUxZjAwMjg1ZWU2Li41NjgwZjcxMjAwZTUgMTAwNjQ0DQo+ID4g
LS0tIGEvZHJpdmVycy91c2IvY2xhc3MvY2RjLWFjbS5jDQo+ID4gKysrIGIvZHJpdmVycy91c2Iv
Y2xhc3MvY2RjLWFjbS5jDQo+ID4gQEAgLTE5OTksMTkgKzE5OTksMTkgQEAgc3RhdGljIGludCBf
X2luaXQgYWNtX2luaXQodm9pZCkNCj4gPiDCoMKgwqDCoMKgwqBhY21fdHR5X2RyaXZlci0+c3Vi
dHlwZSA9IFNFUklBTF9UWVBFX05PUk1BTCwNCj4gPiDCoMKgwqDCoMKgwqBhY21fdHR5X2RyaXZl
ci0+ZmxhZ3MgPSBUVFlfRFJJVkVSX1JFQUxfUkFXIHwgVFRZX0RSSVZFUl9EWU5BTUlDX0RFVjsN
Cj4gPiDCoMKgwqDCoMKgwqBhY21fdHR5X2RyaXZlci0+aW5pdF90ZXJtaW9zID0gdHR5X3N0ZF90
ZXJtaW9zOw0KPiA+IC0gICAgIGFjbV90dHlfZHJpdmVyLT5pbml0X3Rlcm1pb3MuY19jZmxhZyA9
IEI5NjAwIHwgQ1M4IHwgQ1JFQUQgfA0KPiA+ICsgICAgIGFjbV90dHlfZHJpdmVyLT5pbml0X3Rl
cm1pb3MuY19jZmxhZyA9IEIwIHwgQ1M4IHwgQ1JFQUQgfA0KPiA+IMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBIVVBDTCB8
IENMT0NBTDsNCj4gDQo+IEh1aD8gIEFyZSB5b3Ugc3VyZSB0aGlzIHdvcmtzPw0KPiANCj4gPiDC
oMKgwqDCoMKgwqB0dHlfc2V0X29wZXJhdGlvbnMoYWNtX3R0eV9kcml2ZXIsICZhY21fb3BzKTsN
Cj4gPiANCj4gPiAtICAgICByZXR2YWwgPSB0dHlfcmVnaXN0ZXJfZHJpdmVyKGFjbV90dHlfZHJp
dmVyKTsNCj4gPiArICAgICByZXR2YWwgPSB1c2JfcmVnaXN0ZXIoJmFjbV9kcml2ZXIpOw0KPiA+
IMKgwqDCoMKgwqDCoGlmIChyZXR2YWwpIHsNCj4gPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgcHV0X3R0eV9kcml2ZXIoYWNtX3R0eV9kcml2ZXIpOw0KPiA+IMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqByZXR1cm4gcmV0dmFsOw0KPiA+IMKgwqDCoMKgwqDCoH0NCj4gPiANCj4gPiAt
ICAgICByZXR2YWwgPSB1c2JfcmVnaXN0ZXIoJmFjbV9kcml2ZXIpOw0KPiA+ICsgICAgIHJldHZh
bCA9IHR0eV9yZWdpc3Rlcl9kcml2ZXIoYWNtX3R0eV9kcml2ZXIpOw0KPiA+IMKgwqDCoMKgwqDC
oGlmIChyZXR2YWwpIHsNCj4gPiAtICAgICAgICAgICAgIHR0eV91bnJlZ2lzdGVyX2RyaXZlcihh
Y21fdHR5X2RyaXZlcik7DQo+ID4gKyAgICAgICAgICAgICB1c2JfZGVyZWdpc3RlcigmYWNtX2Ry
aXZlcik7DQo+IA0KPiBXaHkgYXJlIHlvdSBzd2l0Y2hpbmcgdGhlc2UgYXJvdW5kPyAgSSB0aGlu
ayBJIGtub3csIGJ1dCB5b3UgZG9uJ3QNCj4gcmVhbGx5IHNheS4uLg0KPiANCj4gdGhhbmtzLA0K
PiANCj4gZ3JlZyBrLWgNCg0K
