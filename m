Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC3FE1F9156
	for <lists+stable@lfdr.de>; Mon, 15 Jun 2020 10:27:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728861AbgFOI13 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Jun 2020 04:27:29 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([146.101.78.151]:33233 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728496AbgFOI13 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Jun 2020 04:27:29 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-243-iJtaD7E4PGOFKa-5GEiBiQ-1; Mon, 15 Jun 2020 09:27:25 +0100
X-MC-Unique: iJtaD7E4PGOFKa-5GEiBiQ-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Mon, 15 Jun 2020 09:27:24 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Mon, 15 Jun 2020 09:27:24 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Christian Brauner' <christian.brauner@ubuntu.com>,
        Kees Cook <keescook@chromium.org>
CC:     Sargun Dhillon <sargun@sargun.me>,
        Giuseppe Scrivano <gscrivan@redhat.com>,
        Robert Sesek <rsesek@google.com>,
        Chris Palmer <palmer@google.com>, Jann Horn <jannh@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "containers@lists.linux-foundation.org" 
        <containers@lists.linux-foundation.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Matt Denton <mpdenton@google.com>, Tejun Heo <tj@kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>
Subject: RE: [PATCH v3 1/4] fs, net: Standardize on file_receive helper to
 move fds across processes
Thread-Topic: [PATCH v3 1/4] fs, net: Standardize on file_receive helper to
 move fds across processes
Thread-Index: AQHWP+BcCi14oegu0U6J73sUpcDiU6jTfHDAgACI+YCAAKH2YIAAp2qKgAQNYhA=
Date:   Mon, 15 Jun 2020 08:27:24 +0000
Message-ID: <e54c39728d944de782394f4632bc7b1e@AcuMS.aculab.com>
References: <202006092227.D2D0E1F8F@keescook>
 <20200610081237.GA23425@ircssh-2.c.rugged-nimbus-611.internal>
 <202006101953.899EFB53@keescook>
 <20200611100114.awdjswsd7fdm2uzr@wittgenstein>
 <20200611110630.GB30103@ircssh-2.c.rugged-nimbus-611.internal>
 <067f494d55c14753a31657f958cb0a6e@AcuMS.aculab.com>
 <202006111634.8237E6A5C6@keescook>
 <94407449bedd4ba58d85446401ff0a42@AcuMS.aculab.com>
 <20200612104629.GA15814@ircssh-2.c.rugged-nimbus-611.internal>
 <202006120806.E770867EF@keescook>
 <20200612182816.okwylihs6u6wkgxd@wittgenstein>
In-Reply-To: <20200612182816.okwylihs6u6wkgxd@wittgenstein>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: aculab.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

RnJvbTogQ2hyaXN0aWFuIEJyYXVuZXINCj4gU2VudDogMTIgSnVuZSAyMDIwIDE5OjI4DQouLi4N
Cj4gPiA+IAlpZiAoc2l6ZSA8IDMyKQ0KPiA+ID4gCQlyZXR1cm4gLUVJTlZBTDsNCj4gPiA+IAlp
ZiAoc2l6ZSA+IFBBR0VfU0laRSkNCj4gPiA+IAkJcmV0dXJuIC1FMkJJRzsNCj4gPg0KPiA+IChU
YW5nZXQ6IHdoYXQgd2FzIHRoZSByZWFzb24gZm9yIGNvcHlfc3RydWN0X2Zyb21fdXNlcigpIG5v
dCBpbmNsdWRpbmcNCj4gPiB0aGUgbWluL21heCBjaGVjaz8gSSBoYXZlIGEgbWVtb3J5IG9mIEFs
IG9iamVjdGluZyB0byBoYXZpbmcgYW4NCj4gPiAiaW50ZXJuYWwiIGxpbWl0PykNCj4gDQo+IEFs
IGRpZG4ndCB3YW50IHRoZSBQQUdFX1NJWkUgbGltaXQgaW4gdGhlcmUgYmVjYXVzZSB0aGVyZSdz
IG5vdGhpbmcNCj4gaW5oZXJlbnRseSB3cm9uZyB3aXRoIGNvcHlpbmcgaW5zYW5lIGFtb3VudHMg
b2YgbWVtb3J5Lg0KDQpUaGUgcHJvYmxlbSBpcyByZWFsbHkgYWxsb3dpbmcgYSB1c2VyIHByb2Nl
c3MgdG8gYWxsb2NhdGUNCnVuYm91bmRlZCBibG9ja3Mgb2YgbWVtb3J5LCBub3QgdGhlIGNvcHkg
aXRzZWxmLg0KDQpUaGUgbGltaXQgZm9yIElPVygpIGV0YyBpcyAxNmsgLSBub3QgYSBwcm9ibGVt
Lg0KSWYgYSAzMmJpdCBzaXplIGlzIHNldCB0byBqdXN0IHVuZGVyIDRHQiBzbyB5b3UgcmVhbGx5
IHdhbnQNCnRvIGFsbG9jYXRlIDRHQiBvZiBtZW1vcnkgdGhlbiBmaW5kIHRoZSByZXF1ZXN0IGlz
IGdhcmJhZ2UuDQpTZWVtcyBsaWtlIGEgbmljZSBEb1MgYXR0YWNrLg0KQSA2NGJpdCBzaXplIGNh
biBiZSB3b3JzZS4NCg0KUG90ZW50aWFsbHkgdGhlIGxpbWl0IHNob3VsZCBiZSBpbiBtZW1kdXBf
dXNlcigpIGl0c2VsZi4NCkFuZCBwb3NzaWJseSBhbiBleHRyYSBwYXJhbWV0ZXIgZ2l2aW5nIGEg
cGVyLWNhbGwgbG93ZXI/IGxpbWl0Lg0KDQoJRGF2aWQNCg0KLQ0KUmVnaXN0ZXJlZCBBZGRyZXNz
IExha2VzaWRlLCBCcmFtbGV5IFJvYWQsIE1vdW50IEZhcm0sIE1pbHRvbiBLZXluZXMsIE1LMSAx
UFQsIFVLDQpSZWdpc3RyYXRpb24gTm86IDEzOTczODYgKFdhbGVzKQ0K

