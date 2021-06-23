Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C2623B1B61
	for <lists+stable@lfdr.de>; Wed, 23 Jun 2021 15:43:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230496AbhFWNp0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Jun 2021 09:45:26 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.86.151]:52656 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230298AbhFWNpZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Jun 2021 09:45:25 -0400
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-263-si2JVMyPPtOU_tjpJ7Q3cw-1; Wed, 23 Jun 2021 14:43:05 +0100
X-MC-Unique: si2JVMyPPtOU_tjpJ7Q3cw-1
Received: from AcuMS.Aculab.com (10.202.163.4) by AcuMS.aculab.com
 (10.202.163.4) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 23 Jun
 2021 14:43:04 +0100
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.018; Wed, 23 Jun 2021 14:43:04 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Guillaume Tucker' <guillaume.tucker@collabora.com>,
        Kees Cook <keescook@chromium.org>,
        Shuah Khan <shuah@kernel.org>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v2] selftests/lkdtm: Use /bin/sh not $SHELL
Thread-Topic: [PATCH v2] selftests/lkdtm: Use /bin/sh not $SHELL
Thread-Index: AQHXaCznpjkpNTpwjEW+kA8o/GdKZashmKhg
Date:   Wed, 23 Jun 2021 13:43:04 +0000
Message-ID: <42f26361db6f481e980ac349bf0079ef@AcuMS.aculab.com>
References: <20210619025834.2505201-1-keescook@chromium.org>
 <e958209b-8621-57ca-01d6-2e76b05dab4c@collabora.com>
In-Reply-To: <e958209b-8621-57ca-01d6-2e76b05dab4c@collabora.com>
Accept-Language: en-GB, en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=C51A453 smtp.mailfrom=david.laight@aculab.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: aculab.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

RnJvbTogR3VpbGxhdW1lIFR1Y2tlcg0KPiBTZW50OiAyMyBKdW5lIDIwMjEgMTM6NDANCi4uLg0K
PiA+IGRpZmYgLS1naXQgYS90b29scy90ZXN0aW5nL3NlbGZ0ZXN0cy9sa2R0bS9ydW4uc2ggYi90
b29scy90ZXN0aW5nL3NlbGZ0ZXN0cy9sa2R0bS9ydW4uc2gNCj4gPiBpbmRleCBiYjdhMTc3NTMw
N2IuLjBmOWYyMmFjMDA0YiAxMDA3NTUNCj4gPiAtLS0gYS90b29scy90ZXN0aW5nL3NlbGZ0ZXN0
cy9sa2R0bS9ydW4uc2gNCj4gPiArKysgYi90b29scy90ZXN0aW5nL3NlbGZ0ZXN0cy9sa2R0bS9y
dW4uc2gNCj4gPiBAQCAtNzgsOCArNzgsOSBAQCBkbWVzZyA+ICIkRE1FU0ciDQo+ID4NCj4gPiAg
IyBNb3N0IHNoZWxscyB5ZWxsIGFib3V0IHNpZ25hbHMgYW5kIHdlJ3JlIGV4cGVjdGluZyB0aGUg
ImNhdCIgcHJvY2Vzcw0KPiA+ICAjIHRvIHVzdWFsbHkgYmUga2lsbGVkIGJ5IHRoZSBrZXJuZWwu
IFNvIHdlIGhhdmUgdG8gcnVuIGl0IGluIGEgc3ViLXNoZWxsDQo+ID4gLSMgYW5kIHNpbGVuY2Ug
ZXJyb3JzLg0KPiA+IC0oJFNIRUxMIC1jICdjYXQgPChlY2hvICciJHRlc3QiJykgPiciJFRSSUdH
RVIiIDI+L2Rldi9udWxsKSB8fCB0cnVlDQo+ID4gKyMgdG8gYXZvaWQgdGVybWluYXRpbmcgdGhp
cyBzY3JpcHQuIExlYXZlIHN0ZGVyciBhbG9uZSwganVzdCBpbiBjYXNlDQo+ID4gKyMgc29tZXRo
aW5nIF9lbHNlXyBoYXBwZW5zLg0KPiA+ICsoL2Jpbi9zaCAtYyAnKGVjaG8gJyIkdGVzdCInKSB8
IGNhdCA+JyIkVFJJR0dFUiIpIHx8IHRydWUNCg0KSSB3YXMgaGF2aW5nIHRyb3VibGUgcGFyc2lu
ZyB0aGF0IGNvbW1hbmQgLSBhbmQgSSdtIGdvb2QNCmF0IHNoZWxsIHNjcmlwdHMuDQpJIHRoaW5r
IHRoZSBleHRyYSBzdWJzaGVsbCB0aGUgJ2VjaG8nIGlzIGluIGRvZXNuJ3QgaGVscC4NCkluIGZh
Y3QsIGlzIGVpdGhlciBzdWJzaGVsbCBuZWVkZWQ/DQpTdXJlbHk6DQovYmluL3NoIC1jICJlY2hv
ICckdGVzdCcgfCBjYXQgPiR0cmlnZ2VyIiB8fCB0cnVlDQp3aWxsIHdvcmsganVzdCBhcyB3ZWxs
Pw0KDQoJRGF2aWQNCg0KLQ0KUmVnaXN0ZXJlZCBBZGRyZXNzIExha2VzaWRlLCBCcmFtbGV5IFJv
YWQsIE1vdW50IEZhcm0sIE1pbHRvbiBLZXluZXMsIE1LMSAxUFQsIFVLDQpSZWdpc3RyYXRpb24g
Tm86IDEzOTczODYgKFdhbGVzKQ0K

