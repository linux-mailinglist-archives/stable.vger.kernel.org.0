Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA13921B309
	for <lists+stable@lfdr.de>; Fri, 10 Jul 2020 12:16:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726840AbgGJKQi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Jul 2020 06:16:38 -0400
Received: from mail-bn8nam12on2061.outbound.protection.outlook.com ([40.107.237.61]:6044
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726496AbgGJKQh (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 10 Jul 2020 06:16:37 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LcNIZ0oJWnx0eUrnSoEcW4UvPkee/27pNnlm05G4B9Tg5jauUJfHGZg23PCoi6imAfQVyGMXWBJ0g9vv9ObnNhICBDZOXqccrAmaBGD81X6+ljRxJMInyY+TI+N2Loz4pSSWgbsZNHszBi0CuX5ph+CB8sSXGkeX8/ChJrKxxF+EDUDMyf1lXHbK16a9AtoXCsFS7H4JVf/Gh7Wq/qmLuQhUb536HEipZkEeUvANZVxDXOFCittspPm2IOGBVq86K33mjw24houlAsNOKKZ2LxDdYGFIUS7PptlxSC6PveVSTCR1WAKzMI+eZn9ZiywdTa/1qrP4UikWSYq4Lbxl1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3Mir0SMXVfwJiDGdE9u3Ae+HxyhPPuzFxqLz2PMZRNY=;
 b=bkef2RT0hUIxW7X8s+2M99oEmEXiS3i7IqQTSHEpsKaXfEsyps6MKBdX496zGKbqJoKtB72cDQSNgETp5lZKy9Lcjkp9IXw2JIC9cg/3IIL0GvlKredEv8z8BUmkX+XkIiM0akDs10D/nhO1VOOr7MvkVFavqbV9R4QGGgOmUdR5zYsiF+eTx+Pa0OzvUJLlz9icr9dIhE9mFekz1XXMPqYCPdxwieemGkhyCbungpsVZy8boTUFaJRy5gA/vMtPk6QXxCUNZV6uJpmEc+8vM4nlwfVSPSm+63w53ftCTrZG0uNDjS1++GBlnCQ72RzI4qy9o+sVzCZyFEfdUD7Qjg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=infinera.com; dmarc=pass action=none header.from=infinera.com;
 dkim=pass header.d=infinera.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=infinera.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3Mir0SMXVfwJiDGdE9u3Ae+HxyhPPuzFxqLz2PMZRNY=;
 b=Rqr0WIVf76xvnbhkeTTWAvFyt1hTfAweWpRdcFEQDmZrOLnhtXA9xhXZOLMm0N1bES3vq3HaOQsqabNOe+UcAX7y5mVeBZM3BUtgbtRq/QJfLHOu+VK6kKLYkvBHVP2IPJ9TrzJ0SgvgLoB3ciHSlcYnch/4psU1XG6hqTgKCio=
Received: from MWHPR1001MB2190.namprd10.prod.outlook.com
 (2603:10b6:301:2e::20) by MWHPR10MB1469.namprd10.prod.outlook.com
 (2603:10b6:300:1f::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.22; Fri, 10 Jul
 2020 10:16:33 +0000
Received: from MWHPR1001MB2190.namprd10.prod.outlook.com
 ([fe80::b439:ba0:98d6:c2d1]) by MWHPR1001MB2190.namprd10.prod.outlook.com
 ([fe80::b439:ba0:98d6:c2d1%5]) with mapi id 15.20.3174.021; Fri, 10 Jul 2020
 10:16:33 +0000
From:   Joakim Tjernlund <Joakim.Tjernlund@infinera.com>
To:     "johan@kernel.org" <johan@kernel.org>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
Subject: Re: [PATCH] cdc-acm: acm_init: Set initial BAUD to B0
Thread-Topic: [PATCH] cdc-acm: acm_init: Set initial BAUD to B0
Thread-Index: AQHWVp10AvhYW+hsHEuT/7Zwfc2fs6kAkwyAgAAGFgA=
Date:   Fri, 10 Jul 2020 10:16:33 +0000
Message-ID: <b4fca29185bfce940bf52813b5f92af27282c738.camel@infinera.com>
References: <20200710093518.22272-1-joakim.tjernlund@infinera.com>
         <20200710095445.GS3453@localhost>
In-Reply-To: <20200710095445.GS3453@localhost>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.37.3 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=infinera.com;
x-originating-ip: [88.131.87.201]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a237b358-2739-44d5-c59a-08d824ba5240
x-ms-traffictypediagnostic: MWHPR10MB1469:
x-microsoft-antispam-prvs: <MWHPR10MB1469F3D5899CF1AA9E1FCB32F4650@MWHPR10MB1469.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4714;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: K1QMzdBc/Ksg6DU2SIdKBSExR1Mgwk26A2NhveA5jXnMGQK6eABeiaXOcQfOh05lgMAY5zvd1Aqyyp8sL9YjkvRxgtz/eUDXTqFEPc5swt8/+gVrUdv2viDZbrPbzTlerIAy2c06hYeYCg597N48pLW1O+lip3LZUicB84PxjkJbDloDFqa2BfrAjQtbs6JXBL4o6ar78TR1mcy5UjUYtI47FQt6JThev2C/eYHS74NwtrYcMHD4477rZHWcg/K8GYbYDTW644k1J6rK6nz9bzeBTX24/g82ArngcJD9GCY8jOTVesp5X1nlkMl5U4Dn
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2190.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(136003)(376002)(346002)(39860400002)(366004)(36756003)(64756008)(66476007)(2616005)(66446008)(316002)(4326008)(6506007)(76116006)(2906002)(8676002)(8936002)(86362001)(91956017)(83380400001)(66556008)(6486002)(26005)(186003)(71200400001)(54906003)(66946007)(5660300002)(6512007)(6916009)(478600001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: ztLcSON0Wy2wroBDaKbm7PE5oLOoFzL9mLcWCAnqSwqlhaUUmp7R5cfqaQMc7SlbQDy7ALYbWcCYOKzqQtIafa92kX6qPh0VnFIMn7TBpo/wvub7OdmML71E0aUfeyC9zgEGBb1WH8OM6TQFnhm7CreVItWFaYetfhCDnVjWJ5kC10AR7pgprwkflCIvr6MvWW/wJrkK84H+fqFIM1Eg2CnBDUY45S2cfd2aGpbOdRsV9PR49x5gLdm2EnrFwmSdqsCdohBVJbr3ZnLilYmWo2OqeQB9/oKgzx+hr7zJNd/IV4oSK8UjkzULrSvv0RxkiD5hfgZkXNP4dJ/36o1je/xvimip8zW3LbmtKgjIugWh+7z2wxa+as3EDr6ybyzFsk2ofAPWplnjqQwEMyJCGfbLuRFmQzdbxkyLzmGoFxCef0xOEV39Gx5QBaFJc1uSl2bstwYl+HbOQseaMcjnM5gZ1QMxJUxYnXYp0ZOAniQSENvIxYdRotLd7zDTzaHf
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <0C2ABAC57B5BAC46AABD1C8DE5145DF5@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: infinera.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2190.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a237b358-2739-44d5-c59a-08d824ba5240
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Jul 2020 10:16:33.3439
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 285643de-5f5b-4b03-a153-0ae2dc8aaf77
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: STg7CbCDnvd6EK+ov7oEzf6HyTSe7rsS+8XNEy/1ooBZG/B89tYd9fWcb7/q0Jk8OSQU2T9YKUuw2BU3xWTrWQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1469
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

T24gRnJpLCAyMDIwLTA3LTEwIGF0IDExOjU0ICswMjAwLCBKb2hhbiBIb3ZvbGQgd3JvdGU6DQo+
IENBVVRJT046IFRoaXMgZW1haWwgb3JpZ2luYXRlZCBmcm9tIG91dHNpZGUgb2YgdGhlIG9yZ2Fu
aXphdGlvbi4gRG8gbm90IGNsaWNrIGxpbmtzIG9yIG9wZW4gYXR0YWNobWVudHMgdW5sZXNzIHlv
dSByZWNvZ25pemUgdGhlIHNlbmRlciBhbmQga25vdyB0aGUgY29udGVudCBpcyBzYWZlLg0KPiAN
Cj4gDQo+IE9uIEZyaSwgSnVsIDEwLCAyMDIwIGF0IDExOjM1OjE4QU0gKzAyMDAsIEpvYWtpbSBU
amVybmx1bmQgd3JvdGU6DQo+ID4gQk8gd2lsbCBkaXNhYmxlIFVTQiBpbnB1dCB1bnRpbCB0aGUg
ZGV2aWNlIG9wZW5zLiBUaGlzIHdpbGwNCj4gPiBhdm9pZCBnYXJiYWdlIGNoYXJzIHdhaXRpbmcg
Zmxvb2QgdGhlIFRUWS4gVGhpcyBtaW1pY3MgYSByZWFsIFVBUlQNCj4gPiBkZXZpY2UgYmV0dGVy
Lg0KPiA+IEZvciBpbml0aWFsIHRlcm1pb3MgdG8gcmVhY2ggVVNCIGNvcmUsIFVTQiBkcml2ZXIg
aGFzIHRvIGJlDQo+ID4gcmVnaXN0ZXJlZCBiZWZvcmUgVFRZIGRyaXZlci4NCj4gPiANCj4gPiBT
aWduZWQtb2ZmLWJ5OiBKb2FraW0gVGplcm5sdW5kIDxqb2FraW0udGplcm5sdW5kQGluZmluZXJh
LmNvbT4NCj4gPiBDYzogc3RhYmxlQHZnZXIua2VybmVsLm9yZw0KPiA+IC0tLQ0KPiA+IA0KPiA+
IMKgSSBob3BlIHRoaXMgY2hhbmdlIG1ha2VzIHNlbnNlIHRvIHlvdSwgaWYgc28gSSBiZWxpdmUN
Cj4gPiDCoHR0eVVTQiBjb3VsZCBkbyB0aGUgc2FtZS4NCj4gDQo+IE5vLCB0aGlzIGRvZXNuJ3Qg
bWFrZSBzZW5zZS4gQjAgaXMgdXNlZCB0byBoYW5nIHVwIGFuIGFscmVhZHkgb3BlbiB0dHkuDQoN
ClRoaXMgaXMgYXQgbW9kdWxlIGluaXQgc28gdGhlcmUgaXMgbm8gdHR5IHlldC4NCmFjbV9wcm9i
ZSgpIHdpbGwgbGF0ZXIgc2V0Og0KICAgICAgICBhY20tPmxpbmUuZHdEVEVSYXRlID0gY3B1X3Rv
X2xlMzIoOTYwMCk7DQoJYWNtLT5saW5lLmJEYXRhQml0cyA9IDg7DQoJYWNtX3NldF9saW5lKGFj
bSwgJmFjbS0+bGluZSk7DQoNCj4gDQo+IEZ1cnRoZXJtb3JlLCB0aGlzIGNoYW5nZSBvbmx5IGFm
ZmVjdHMgdGhlIGluaXRpYWwgdGVybWluYWwgc2V0dGluZ3MgYW5kDQo+IHdvbid0IGhhdmUgYW55
IGVmZmVjdCB0aGUgbmV4dCB0aW1lIHlvdSBvcGVuIHRoZSBzYW1lIHBvcnQuDQoNCmhtbSwgaXQg
aXMgbm90IGlkZWFsIGJ1dCBhY21fcHJvYmUoKSB3aWxsIGxhdGVyIHNldDoNCiAgICAgICAgYWNt
LT5saW5lLmR3RFRFUmF0ZSA9IGNwdV90b19sZTMyKDk2MDApOw0KCWFjbS0+bGluZS5iRGF0YUJp
dHMgPSA4Ow0KCWFjbV9zZXRfbGluZShhY20sICZhY20tPmxpbmUpOw0KDQpCdXQsIHdvdWxkIGl0
IG5vdCBtYWtlIHNlbnNlIHRvIG5vdCBhY2NlcHQgaW5wdXQgdW50aWwgVFRZIGlzIG9wZW5lZCA/
DQpUaGF0IHdvdWxkIGJlIG1vcmUgaW5saW5lIHdpdGggYSByZWFsIFJTMjMyLCB3b3VsZCBpdCBu
b3Q/DQo+IA0KPiBXaHkgbm90IGZpeCB5b3VyIGZpcm13YXJlIHNvIHRoYXQgaXQgZG9lc24ndCB0
cmFuc21pdCBiZWZvcmUgRFRSIGlzDQo+IGFzc2VydGVkIGR1cmluZyBvcGVuKCk/DQoNCkkgd291
bGQgYnV0IGl0IGlzIG5vdCBteSBmaXJtd2FyZSwgaXQgaXMgYSByZWFkeSBtYWRlIFVTQiB0byBV
QVJUIGNoaXAuIHdpbGwgdGFsaw0KdG8gdGhlIG1hbnVmYWN0dXJlciB0aG91Z2guDQoNCg0KPiA+
IMKgZHJpdmVycy91c2IvY2xhc3MvY2RjLWFjbS5jIHwgOCArKysrLS0tLQ0KPiA+IMKgMSBmaWxl
IGNoYW5nZWQsIDQgaW5zZXJ0aW9ucygrKSwgNCBkZWxldGlvbnMoLSkNCj4gPiANCj4gPiBkaWZm
IC0tZ2l0IGEvZHJpdmVycy91c2IvY2xhc3MvY2RjLWFjbS5jIGIvZHJpdmVycy91c2IvY2xhc3Mv
Y2RjLWFjbS5jDQo+ID4gaW5kZXggNzUxZjAwMjg1ZWU2Li41NjgwZjcxMjAwZTUgMTAwNjQ0DQo+
ID4gLS0tIGEvZHJpdmVycy91c2IvY2xhc3MvY2RjLWFjbS5jDQo+ID4gKysrIGIvZHJpdmVycy91
c2IvY2xhc3MvY2RjLWFjbS5jDQo+ID4gQEAgLTE5OTksMTkgKzE5OTksMTkgQEAgc3RhdGljIGlu
dCBfX2luaXQgYWNtX2luaXQodm9pZCkNCj4gPiDCoMKgwqDCoMKgwqBhY21fdHR5X2RyaXZlci0+
c3VidHlwZSA9IFNFUklBTF9UWVBFX05PUk1BTCwNCj4gPiDCoMKgwqDCoMKgwqBhY21fdHR5X2Ry
aXZlci0+ZmxhZ3MgPSBUVFlfRFJJVkVSX1JFQUxfUkFXIHwgVFRZX0RSSVZFUl9EWU5BTUlDX0RF
VjsNCj4gPiDCoMKgwqDCoMKgwqBhY21fdHR5X2RyaXZlci0+aW5pdF90ZXJtaW9zID0gdHR5X3N0
ZF90ZXJtaW9zOw0KPiA+IC0gICAgIGFjbV90dHlfZHJpdmVyLT5pbml0X3Rlcm1pb3MuY19jZmxh
ZyA9IEI5NjAwIHwgQ1M4IHwgQ1JFQUQgfA0KPiA+ICsgICAgIGFjbV90dHlfZHJpdmVyLT5pbml0
X3Rlcm1pb3MuY19jZmxhZyA9IEIwIHwgQ1M4IHwgQ1JFQUQgfA0KPiA+IMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBIVVBD
TCB8IENMT0NBTDsNCj4gPiDCoMKgwqDCoMKgwqB0dHlfc2V0X29wZXJhdGlvbnMoYWNtX3R0eV9k
cml2ZXIsICZhY21fb3BzKTsNCj4gPiANCj4gPiAtICAgICByZXR2YWwgPSB0dHlfcmVnaXN0ZXJf
ZHJpdmVyKGFjbV90dHlfZHJpdmVyKTsNCj4gPiArICAgICByZXR2YWwgPSB1c2JfcmVnaXN0ZXIo
JmFjbV9kcml2ZXIpOw0KPiA+IMKgwqDCoMKgwqDCoGlmIChyZXR2YWwpIHsNCj4gPiDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgcHV0X3R0eV9kcml2ZXIoYWNtX3R0eV9kcml2ZXIpOw0KPiA+
IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqByZXR1cm4gcmV0dmFsOw0KPiA+IMKgwqDCoMKg
wqDCoH0NCj4gPiANCj4gPiAtICAgICByZXR2YWwgPSB1c2JfcmVnaXN0ZXIoJmFjbV9kcml2ZXIp
Ow0KPiA+ICsgICAgIHJldHZhbCA9IHR0eV9yZWdpc3Rlcl9kcml2ZXIoYWNtX3R0eV9kcml2ZXIp
Ow0KPiA+IMKgwqDCoMKgwqDCoGlmIChyZXR2YWwpIHsNCj4gPiAtICAgICAgICAgICAgIHR0eV91
bnJlZ2lzdGVyX2RyaXZlcihhY21fdHR5X2RyaXZlcik7DQo+ID4gKyAgICAgICAgICAgICB1c2Jf
ZGVyZWdpc3RlcigmYWNtX2RyaXZlcik7DQo+ID4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oHB1dF90dHlfZHJpdmVyKGFjbV90dHlfZHJpdmVyKTsNCj4gPiDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgcmV0dXJuIHJldHZhbDsNCj4gPiDCoMKgwqDCoMKgwqB9DQo+IA0KPiBKb2hhbg0K
DQo=
