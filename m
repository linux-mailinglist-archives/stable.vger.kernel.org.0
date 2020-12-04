Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4DF62CE52E
	for <lists+stable@lfdr.de>; Fri,  4 Dec 2020 02:36:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725918AbgLDBe4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Dec 2020 20:34:56 -0500
Received: from mailgw01.mediatek.com ([210.61.82.183]:45172 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725903AbgLDBe4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Dec 2020 20:34:56 -0500
X-UUID: 0bc7a8b8818f4c6e8ea4af27196f3ffb-20201204
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=qpJag3JOEGGUczkknHZEtGGVXhrvUUQwFODEalRuGIQ=;
        b=k2WlSq/iAxSGxWVmbKEwPGM07ymL5zzz3mARqAJnwnbtYgtS4ecSyt9y+VdPMoHxp7Hr4ELb43RVV7eqh3ISXTw00cwXcHY0fltqpnPAvwwNhDrrG/I9eftHyonHGZR9Q5IVos8X5wiLyvKYGp4dHTvQIFLWHk74/PFhtq8WB2M=;
X-UUID: 0bc7a8b8818f4c6e8ea4af27196f3ffb-20201204
Received: from mtkcas07.mediatek.inc [(172.21.101.84)] by mailgw01.mediatek.com
        (envelope-from <miles.chen@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.14 Build 0819 with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 110740681; Fri, 04 Dec 2020 09:34:10 +0800
Received: from mtkcas11.mediatek.inc (172.21.101.40) by
 mtkmbs01n2.mediatek.inc (172.21.101.79) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Fri, 4 Dec 2020 09:34:07 +0800
Received: from [172.21.77.33] (172.21.77.33) by mtkcas11.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 4 Dec 2020 09:34:09 +0800
Message-ID: <1607045648.22275.7.camel@mtkswgap22>
Subject: Re: [PATCH v2] proc: use untagged_addr() for pagemap_read addresses
From:   Miles Chen <miles.chen@mediatek.com>
To:     Catalin Marinas <catalin.marinas@arm.com>
CC:     Alexey Dobriyan <adobriyan@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
        <linux-mediatek@lists.infradead.org>, <wsd_upstream@mediatek.com>,
        Andrey Konovalov <andreyknvl@google.com>,
        Alexander Potapenko <glider@google.com>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>,
        Andrey Ryabinin <aryabinin@virtuozzo.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Marco Elver <elver@google.com>,
        "Will Deacon" <will@kernel.org>,
        "Eric W . Biederman" <ebiederm@xmission.com>,
        Song Bao Hua <song.bao.hua@hisilicon.com>,
        <stable@vger.kernel.org>
Date:   Fri, 4 Dec 2020 09:34:08 +0800
In-Reply-To: <20201203113020.GE2224@gaia>
References: <20201127050738.14440-1-miles.chen@mediatek.com>
         <20201203113020.GE2224@gaia>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
X-TM-SNTS-SMTP: 552F8B8F974629EEEA03397AF0B305287B0DA99E5025DF5071FD727CF3EB5E5F2000:8
X-MTK:  N
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

T24gVGh1LCAyMDIwLTEyLTAzIGF0IDExOjMwICswMDAwLCBDYXRhbGluIE1hcmluYXMgd3JvdGU6
DQo+IE9uIEZyaSwgTm92IDI3LCAyMDIwIGF0IDAxOjA3OjM4UE0gKzA4MDAsIE1pbGVzIENoZW4g
d3JvdGU6DQo+ID4gQ2M6IFdpbGwgRGVhY29uIDx3aWxsLmRlYWNvbkBhcm0uY29tPg0KPiANCj4g
VGhhdCBzaG91bGQgYmUgd2lsbEBrZXJuZWwub3JnLg0KDQpvaywgSSB3aWxsIGZpeCBpdCBhbmQg
c3VibWl0IHYzDQo+IA0KPiA+IGRpZmYgLS1naXQgYS9mcy9wcm9jL3Rhc2tfbW11LmMgYi9mcy9w
cm9jL3Rhc2tfbW11LmMNCj4gPiBpbmRleCAyMTdhYTI3MDVkNWQuLjkyYjI3NzM4OGYwNSAxMDA2
NDQNCj4gPiAtLS0gYS9mcy9wcm9jL3Rhc2tfbW11LmMNCj4gPiArKysgYi9mcy9wcm9jL3Rhc2tf
bW11LmMNCj4gPiBAQCAtMTU5OSwxMSArMTU5OSwxNSBAQCBzdGF0aWMgc3NpemVfdCBwYWdlbWFw
X3JlYWQoc3RydWN0IGZpbGUgKmZpbGUsIGNoYXIgX191c2VyICpidWYsDQo+ID4gIA0KPiA+ICAJ
c3JjID0gKnBwb3M7DQo+ID4gIAlzdnBmbiA9IHNyYyAvIFBNX0VOVFJZX0JZVEVTOw0KPiA+IC0J
c3RhcnRfdmFkZHIgPSBzdnBmbiA8PCBQQUdFX1NISUZUOw0KPiA+ICAJZW5kX3ZhZGRyID0gbW0t
PnRhc2tfc2l6ZTsNCj4gPiAgDQo+ID4gIAkvKiB3YXRjaCBvdXQgZm9yIHdyYXBhcm91bmQgKi8N
Cj4gPiAtCWlmIChzdnBmbiA+IG1tLT50YXNrX3NpemUgPj4gUEFHRV9TSElGVCkNCj4gPiArCXN0
YXJ0X3ZhZGRyID0gZW5kX3ZhZGRyOw0KPiA+ICsJaWYgKHN2cGZuIDwgKFVMT05HX01BWCA+PiBQ
QUdFX1NISUZUKSkNCj4gDQo+IERvZXMgdGhpcyBuZWVkIHRvIGJlIHN0cmljdCBsZXNzLXRoYW4/
IEkgdGhpbmsgYSBsZXNzLXRoYW4gb3IgZXF1YWwNCj4gd291bGQgd29yayBiZXR0ZXIuDQoNClRo
YW5rcywgSSB3aWxsIGZpeCBpdCBhbmQgc3VibWl0IHYzLg0KPiANCj4gPiArCQlzdGFydF92YWRk
ciA9IHVudGFnZ2VkX2FkZHIoc3ZwZm4gPDwgUEFHRV9TSElGVCk7DQo+ID4gKw0KPiA+ICsJLyog
RW5zdXJlIHRoZSBhZGRyZXNzIGlzIGluc2lkZSB0aGUgdGFzayAqLw0KPiA+ICsJaWYgKHN0YXJ0
X3ZhZGRyID4gbW0tPnRhc2tfc2l6ZSkNCj4gPiAgCQlzdGFydF92YWRkciA9IGVuZF92YWRkcjsN
Cj4gDQo+IE90aGVyd2lzZSB0aGUgbG9naWMgbG9va3MgZmluZSB0byBtZS4gV2l0aCB0aGUgYWJv
dmU6DQo+IA0KPiBSZXZpZXdlZC1ieTogQ2F0YWxpbiBNYXJpbmFzIDxjYXRhbGluLm1hcmluYXNA
YXJtLmNvbT4NCg0K

