Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 132652FFF9C
	for <lists+stable@lfdr.de>; Fri, 22 Jan 2021 10:57:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726917AbhAVJ5I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Jan 2021 04:57:08 -0500
Received: from rtits2.realtek.com ([211.75.126.72]:42344 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726513AbhAVJ4l (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 22 Jan 2021 04:56:41 -0500
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.73 with qID 10M9ti7N3019722, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexmbs04.realtek.com.tw[172.21.6.97])
        by rtits2.realtek.com.tw (8.15.2/2.70/5.88) with ESMTPS id 10M9ti7N3019722
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 22 Jan 2021 17:55:44 +0800
Received: from RTEXDAG02.realtek.com.tw (172.21.6.101) by
 RTEXMBS04.realtek.com.tw (172.21.6.97) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Fri, 22 Jan 2021 17:55:44 +0800
Received: from RTEXMBS01.realtek.com.tw (172.21.6.94) by
 RTEXDAG02.realtek.com.tw (172.21.6.101) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Fri, 22 Jan 2021 17:55:44 +0800
Received: from RTEXMBS01.realtek.com.tw ([fe80::5d07:e256:a2a2:81ee]) by
 RTEXMBS01.realtek.com.tw ([fe80::5d07:e256:a2a2:81ee%5]) with mapi id
 15.01.2106.006; Fri, 22 Jan 2021 17:55:44 +0800
From:   =?big5?B?p2Sp/rzhIFJpY2t5?= <ricky_wu@realtek.com>
To:     Greg KH <gregkh@linuxfoundation.org>
CC:     "arnd@arndb.de" <arnd@arndb.de>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "vaibhavgupta40@gmail.com" <vaibhavgupta40@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH v4] Fixes: misc: rtsx: init value of aspm_enabled
Thread-Topic: [PATCH v4] Fixes: misc: rtsx: init value of aspm_enabled
Thread-Index: AQHW8JdG6LTWRBWsI02tcgPbuCBziaoyybOAgACITkA=
Date:   Fri, 22 Jan 2021 09:55:44 +0000
Message-ID: <c55d960dd9424914b48638afcdfb81d1@realtek.com>
References: <20210122081906.19100-1-ricky_wu@realtek.com>
 <YAqMkU4fR5z6aG1Z@kroah.com>
In-Reply-To: <YAqMkU4fR5z6aG1Z@kroah.com>
Accept-Language: zh-TW, en-US
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.22.88.99]
Content-Type: text/plain; charset="big5"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBHcmVnIEtIIDxncmVna2hAbGlu
dXhmb3VuZGF0aW9uLm9yZz4NCj4gU2VudDogRnJpZGF5LCBKYW51YXJ5IDIyLCAyMDIxIDQ6Mjgg
UE0NCj4gVG86IKdkqf684SBSaWNreSA8cmlja3lfd3VAcmVhbHRlay5jb20+DQo+IENjOiBhcm5k
QGFybmRiLmRlOyBiaGVsZ2Fhc0Bnb29nbGUuY29tOyB2YWliaGF2Z3VwdGE0MEBnbWFpbC5jb207
DQo+IGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmc7IHN0YWJsZUB2Z2VyLmtlcm5lbC5vcmcN
Cj4gU3ViamVjdDogUmU6IFtQQVRDSCB2NF0gRml4ZXM6IG1pc2M6IHJ0c3g6IGluaXQgdmFsdWUg
b2YgYXNwbV9lbmFibGVkDQo+IA0KPiBPbiBGcmksIEphbiAyMiwgMjAyMSBhdCAwNDoxOTowNlBN
ICswODAwLCByaWNreV93dUByZWFsdGVrLmNvbSB3cm90ZToNCj4gPiBGcm9tOiBSaWNreSBXdSA8
cmlja3lfd3VAcmVhbHRlay5jb20+DQo+ID4NCj4gPiBtYWtlIHN1cmUgQVNQTSBzdGF0ZSBzeW5j
IHdpdGggcGNyLT5hc3BtX2VuYWJsZWQgaW5pdCB2YWx1ZQ0KPiA+IHBjci0+YXNwbV9lbmFibGVk
DQo+ID4NCj4gPiBDYzogc3RhYmxlQHZnZXIua2VybmVsLm9yZw0KPiA+IFNpZ25lZC1vZmYtYnk6
IFJpY2t5IFd1IDxyaWNreV93dUByZWFsdGVrLmNvbT4NCj4gPiAtLS0NCj4gPg0KPiA+IHYyOiBm
aXhlZCBjb25kaXRpb25zIGluIHYxIGlmLXN0YXRlbWVudA0KPiA+IHYzOiBnaXZlIGRlc2NyaXB0
aW9uIGZvciB2MSBhbmQgdjINCj4gPiB2NDogbW92ZSB2ZXJzaW9uIGNoYW5nZSBiZWxvdyAtLS0N
Cj4gDQo+IFdoYXQgY29tbWl0IGlkIGRvZXMgdGhpcyBmaXg/ICBIb3cgZmFyIGJhY2sgc2hvdWxk
IHRoZSBzdGFibGUgYmFja3BvcnRpbmcgZ28/DQo+IFRoYXQncyB3aGF0IHdlIHVzZSB0aGUgRml4
ZXM6IGxpbmUgZm9yLg0KPiANCkkgdGhpbmsgSSBtaXN1bmRlcnN0YW5kaW5nIHlvdQ0KRml4IGNv
bW1pdCBpZDogIGQ5MjgwNjFjMzE0M2RlMzZjMTc2NTBjZTdiNjA3NjBmZWZiODMzNmMNClNvIEkg
bmVlZCB0byBoYXZlIHY1IGFuZCBhZGQgIkZpeGVzOiIgdGFnIGxpa2UgYmVsb3cgaW4gdGhlIHNp
Z25lZCBvZmYgYnkgYXJlYT8NCg0KIkZpeGVzOiBkOTI4MDYxYzMxNDNkZTM2YzE3NjUwY2U3YjYw
NzYwZmVmYjgzMzZjIg0KDQp0aGFua3MgDQoNClJpY2t5DQo+IA0KPiAtLS0tLS1QbGVhc2UgY29u
c2lkZXIgdGhlIGVudmlyb25tZW50IGJlZm9yZSBwcmludGluZyB0aGlzIGUtbWFpbC4NCg==
