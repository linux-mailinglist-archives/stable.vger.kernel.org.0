Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1A3F21BA4F
	for <lists+stable@lfdr.de>; Fri, 10 Jul 2020 18:05:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727078AbgGJQFc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Jul 2020 12:05:32 -0400
Received: from mail-mw2nam12on2043.outbound.protection.outlook.com ([40.107.244.43]:22497
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727074AbgGJQFc (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 10 Jul 2020 12:05:32 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZLcpjVI7F1Qi+idGfRnEjpsy9AY5b3RMTLXkHk6epxGcB21qUOLf+LQpJ2nQqt7pAjy4T3Kjoe2CLXp8lsLcaRAgo5pBWdlv5w7zw7z8u+0INPtdwZh6TyuY35XHKG6KSKmJaPerYsAD9J1T4v9Jdnu+IMcgsXTYJNTnJx/HUa/RPJdbit8sZhojJ4V8Ns9hD8vexi1vnwwse3eW6u+jIg90u6uNiObZtnrTTryPD0Gs+vAkDcszYlhG5rE2Mj951NXUEBS7mpk71BBameldlI1SuLSWBX1BhK4ARzYVxCUKTqqkGhmwrnstrwsNX3/2/OKL8/lZD9EuX9Rh5uUd9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HEzriAykbgR8CWGeNQfhEMwwC19XDkQAsouBB29nVaM=;
 b=CqlqgpivbdkpDyuMDyDkEx+HyEIgzSDBDe1TZnh+xH6yVPu4Z84vTY9GhO7rcrbAPSPrkAQ4UE08tGuet09GkLM8yCWNsAgnWdrWvEmW9QxLzF2laGeIpwHEb//+pNIB7/4TC644eEcZd51DduKGcR1mBlrhQ0rJddx76+/AnJk6ww4pyGTz90Vpcrc0O40/390KM6pCtyhgPAG9sUlgjCNWJ6U0VFsLLSBo6EZXPXIYaKxBE7jw/6izroH57za5ShxyD6ZH8jpPSNDNdKQKVrkgA0sXty9uHRqaFxIGqd80KUdHKYu3GUgNwQvn31j0g3WXCdz886Jd90eb0lqUXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=infinera.com; dmarc=pass action=none header.from=infinera.com;
 dkim=pass header.d=infinera.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=infinera.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HEzriAykbgR8CWGeNQfhEMwwC19XDkQAsouBB29nVaM=;
 b=I0CDDllmZqaTKegCSt/+0+6DrKnvLWk9e0ntAa6j1XiizGhsAurJV7jq8jYNavy10vOT36fusW8XQvVj4Y/qVbyatRlzs5Zliwoe5waV7hO68+RDEO/yog+0DW40zDIHBM+BKIhZNbA6l+6Ako8F0ifaKok2Cd9p+dm0+sj+RKQ=
Received: from DM5PR1001MB2186.namprd10.prod.outlook.com (2603:10b6:4:35::35)
 by DM5PR10MB1386.namprd10.prod.outlook.com (2603:10b6:3:7::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3174.22; Fri, 10 Jul 2020 16:05:29 +0000
Received: from DM5PR1001MB2186.namprd10.prod.outlook.com
 ([fe80::d086:8298:6d8a:e6ff]) by DM5PR1001MB2186.namprd10.prod.outlook.com
 ([fe80::d086:8298:6d8a:e6ff%6]) with mapi id 15.20.3153.031; Fri, 10 Jul 2020
 16:05:29 +0000
From:   Joakim Tjernlund <Joakim.Tjernlund@infinera.com>
To:     "johan@kernel.org" <johan@kernel.org>
CC:     "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
Subject: Re: [PATCH] cdc-acm: acm_init: Set initial BAUD to B0
Thread-Topic: [PATCH] cdc-acm: acm_init: Set initial BAUD to B0
Thread-Index: AQHWVp10AvhYW+hsHEuT/7Zwfc2fs6kAnkqAgAADKICAACARgIAAOR6A
Date:   Fri, 10 Jul 2020 16:05:29 +0000
Message-ID: <4bf0e060e72c4f1c7c53da6bbd5aa883028d1bc3.camel@infinera.com>
References: <20200710093518.22272-1-joakim.tjernlund@infinera.com>
         <20200710103459.GA1203263@kroah.com>
         <428dc1e66dfa5fb604233046013f9fe35c4d9b5e.camel@infinera.com>
         <20200710124103.GU3453@localhost>
In-Reply-To: <20200710124103.GU3453@localhost>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.37.3 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=infinera.com;
x-originating-ip: [88.131.87.201]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1d017452-3676-4580-0d2d-08d824eb1146
x-ms-traffictypediagnostic: DM5PR10MB1386:
x-microsoft-antispam-prvs: <DM5PR10MB1386E29617143E6022BB6A9FF4650@DM5PR10MB1386.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 3gi6fuIDoVS3VGG4VgHybbSFYW/4ah+oEOY/rLj25tExmg0ZNY83yPz8lPHjAsbHjRfMc5d3ANQmTOgDsuoT7mGuY0tAOxbnPEJh0CGlI6ZiNzIL0Tlzobqu/STVouoPpCzgyN+P9dkUHJHsX/edvQ6rEvWKDINYod70sFJd6nrBune1Hb1N6RkpAFgIjp9ido70MXdkVEzfLYG8pW3QSuHuYcZ3kAiQvxW01E5PPD+bQckFdMg3eIlBv+NJ/chls4SICW1zAXVVtep9m8DoCmxZpIAezVOE/Qd/XdkQHu3NTKNXxweystOVDa/V3eO7pxIsipS1FZ7+oWux0VIjAA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR1001MB2186.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(136003)(376002)(396003)(346002)(39860400002)(6916009)(76116006)(26005)(91956017)(71200400001)(66946007)(6506007)(186003)(66446008)(64756008)(66556008)(66476007)(2616005)(6486002)(6512007)(5660300002)(8676002)(478600001)(4326008)(2906002)(36756003)(86362001)(54906003)(8936002)(316002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: yqJyKTst6q19XLpQfcuBVUC/EEShHFwrMZMl56De5BU9SOT9AwG3DRF2JmMk7faPqkCWb6Q262dro6CNcj8PAlC1kWtu79Ud+BPnycVoE++BzfE7YOHAtaGKIxEBbL+0LRnO+FGZdbxrlBZ+EXIMBGlUcAabXUcYBin00KXjdS+eXWIjibIaYzWZpS9kb7WtAPMeYM9KkI8+UqCjvfYP+dTsIv8TppoJmjRcsSdHoZHtVMCUxRSjB5LcaXGsUWfKQfLghiYKvbGddAw5rep/byO/giTGrG0pm6zN4CyMWlyLhiX0dn5HhLn2958DT1QQeI1M+bysknP9ZOosims53OUoGmOJiKg7Y6Uo5U9m0F6dC6s8pjHYW5Wr08dTOu6RIeNQd6PG6ztHFx9P5C0GFgJpogQJ+9mHemeFbK/4+Nmibjf04kOj4/GOSitRtHRBnc0Cw3GaFx3eKH7O2M0NCYn8UFqwhc7zmRibkeAYCKXsQPYs+0V868LK5HiRdx6E
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <AD0AA891216F7A41BAC8AA90197383E6@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: infinera.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR1001MB2186.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1d017452-3676-4580-0d2d-08d824eb1146
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Jul 2020 16:05:29.7783
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 285643de-5f5b-4b03-a153-0ae2dc8aaf77
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qi9gU6IQA+E/km8WztzmpXMski4bMa/OzksHwbhxHCpWb4H1fymBUeUISuxez+AMIg3c4vieNWF+MFfjcsVQAQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR10MB1386
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

T24gRnJpLCAyMDIwLTA3LTEwIGF0IDE0OjQxICswMjAwLCBKb2hhbiBIb3ZvbGQgd3JvdGU6DQo+
IENBVVRJT046IFRoaXMgZW1haWwgb3JpZ2luYXRlZCBmcm9tIG91dHNpZGUgb2YgdGhlIG9yZ2Fu
aXphdGlvbi4gRG8gbm90IGNsaWNrIGxpbmtzIG9yIG9wZW4gYXR0YWNobWVudHMgdW5sZXNzIHlv
dSByZWNvZ25pemUgdGhlIHNlbmRlciBhbmQga25vdyB0aGUgY29udGVudCBpcyBzYWZlLg0KPiAN
Cj4gDQo+IE9uIEZyaSwgSnVsIDEwLCAyMDIwIGF0IDEwOjQ2OjE5QU0gKzAwMDAsIEpvYWtpbSBU
amVybmx1bmQgd3JvdGU6DQo+ID4gT24gRnJpLCAyMDIwLTA3LTEwIGF0IDEyOjM0ICswMjAwLCBH
cmVnIEtIIHdyb3RlOg0KPiA+ID4gDQo+ID4gPiBPbiBGcmksIEp1bCAxMCwgMjAyMCBhdCAxMToz
NToxOEFNICswMjAwLCBKb2FraW0gVGplcm5sdW5kIHdyb3RlOg0KPiANCj4gPiA+ID4gwqDCoMKg
wqDCoMKgdHR5X3NldF9vcGVyYXRpb25zKGFjbV90dHlfZHJpdmVyLCAmYWNtX29wcyk7DQo+ID4g
PiA+IA0KPiA+ID4gPiAtICAgICByZXR2YWwgPSB0dHlfcmVnaXN0ZXJfZHJpdmVyKGFjbV90dHlf
ZHJpdmVyKTsNCj4gPiA+ID4gKyAgICAgcmV0dmFsID0gdXNiX3JlZ2lzdGVyKCZhY21fZHJpdmVy
KTsNCj4gPiA+ID4gwqDCoMKgwqDCoMKgaWYgKHJldHZhbCkgew0KPiA+ID4gPiDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgcHV0X3R0eV9kcml2ZXIoYWNtX3R0eV9kcml2ZXIpOw0KPiA+ID4g
PiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgcmV0dXJuIHJldHZhbDsNCj4gPiA+ID4gwqDC
oMKgwqDCoMKgfQ0KPiA+ID4gPiANCj4gPiA+ID4gLSAgICAgcmV0dmFsID0gdXNiX3JlZ2lzdGVy
KCZhY21fZHJpdmVyKTsNCj4gPiA+ID4gKyAgICAgcmV0dmFsID0gdHR5X3JlZ2lzdGVyX2RyaXZl
cihhY21fdHR5X2RyaXZlcik7DQo+ID4gPiA+IMKgwqDCoMKgwqDCoGlmIChyZXR2YWwpIHsNCj4g
PiA+ID4gLSAgICAgICAgICAgICB0dHlfdW5yZWdpc3Rlcl9kcml2ZXIoYWNtX3R0eV9kcml2ZXIp
Ow0KPiA+ID4gPiArICAgICAgICAgICAgIHVzYl9kZXJlZ2lzdGVyKCZhY21fZHJpdmVyKTsNCj4g
PiA+IA0KPiA+ID4gV2h5IGFyZSB5b3Ugc3dpdGNoaW5nIHRoZXNlIGFyb3VuZD8gIEkgdGhpbmsg
SSBrbm93LCBidXQgeW91IGRvbid0DQo+ID4gPiByZWFsbHkgc2F5Li4uDQo+ID4gDQo+ID4gSSB3
cm90ZToNCj4gPiDCoMKgwqBGb3IgaW5pdGlhbCB0ZXJtaW9zIHRvIHJlYWNoIFVTQiBjb3JlLCBV
U0IgZHJpdmVyIGhhcyB0byBiZQ0KPiA+IMKgwqDCoHJlZ2lzdGVyZWQgYmVmb3JlIFRUWSBkcml2
ZXIuDQo+ID4gRm91bmQgb3V0IHRoYXQgYnkgdHJpYWwgYW5kIGVycm9yLiBJc24ndCB0aGF0IGNs
ZWFyIGVub3VnaD8NCj4gDQo+IE5vLCB0aGF0IG1ha2VzIG5vIHNlbnNlIGF0IGFsbCBzaW5jZSBV
U0IgY29yZSBkb2VzIG5vdCBjYXJlIGFib3V0DQo+IGluaXRfdGVybWlvcy4NCg0KQnV0IHlvdSBp
bnN0YWxsIGFjbV9vcHMgaW50byB0dHk6DQoJdHR5X3NldF9vcGVyYXRpb25zKGFjbV90dHlfZHJp
dmVyLCAmYWNtX29wcyk7DQpQZXJoYXBzIHRoZXJlIGlzIGEgY2FsbCBpbnRvIGFjbV9vcHM/DQoN
CkFueWhvdywgZG9lcyBpdCBub3QgbWFrZSBzZW5zZSB0byBoYXZlIHVzYiBiZWZvcmUgdHR5IGFz
IHR0eSB1c2VzIHVzYj8NCg0KQ2FuIEkgYXNrIHRoaXMgdG9vOg0KIHdoYXQgaXMgdGhlIGRpZmZl
cmVuY2UgYmV0d2VlbiBhY21fdHR5X2luc3RhbGwgYW5kIGFjbV90dHlfb3BlbiA/IEJvdGggc2Vl
bXMgdG8gYmUgY2FsbGVkIGF0IG9wZW4oMikNCnNlZW1zIHRvIG1lIHRoYXQgaW5zdGFsbCBjb3Vs
ZCBiZSBmb2xkZWQgaW50byBvcGVuID8NCg0KIEpvY2tlDQo=
