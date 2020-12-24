Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 675122E2681
	for <lists+stable@lfdr.de>; Thu, 24 Dec 2020 12:53:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727081AbgLXLw7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Dec 2020 06:52:59 -0500
Received: from mailgw01.mediatek.com ([210.61.82.183]:51683 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726186AbgLXLw7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 24 Dec 2020 06:52:59 -0500
X-UUID: 7df082fdcf394686b3ae0e0585d18cd1-20201224
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:In-Reply-To:Date:CC:To:From:Subject:Message-ID; bh=GVd/uEmz3BT2bNSrN2oF0YBq2VYSrsG41VAyyl5jBoY=;
        b=BhD+v+xV/9Tzasv1YPdXRudo3W0jvdly8Ic2C49NN2ZP+Zlr45uIGhKj0RmQNKLQRxmCFmpR8Dk/+JmNT9j2WfDYrHL6mekH60y7HoSnKn2TMtJffz5zd6MYah+9PhAzFFfEmF/xa+Nl65XunxKMkv3n4LzhpZOIyNYik4BsXdo=;
X-UUID: 7df082fdcf394686b3ae0e0585d18cd1-20201224
Received: from mtkcas06.mediatek.inc [(172.21.101.30)] by mailgw01.mediatek.com
        (envelope-from <kuan-ying.lee@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.14 Build 0819 with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 1303805721; Thu, 24 Dec 2020 19:52:12 +0800
Received: from mtkcas11.mediatek.inc (172.21.101.40) by
 mtkmbs08n2.mediatek.inc (172.21.101.56) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Thu, 24 Dec 2020 19:52:03 +0800
Received: from [172.21.84.99] (172.21.84.99) by mtkcas11.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 24 Dec 2020 19:52:03 +0800
Message-ID: <1608810724.9171.65.camel@mtksdccf07>
Subject: Re: [to-be-updated] kasan-fix-memory-leak-of-kasan-quarantine.patch
 removed from -mm tree
From:   Kuan-Ying Lee <Kuan-Ying.Lee@mediatek.com>
To:     <akpm@linux-foundation.org>
CC:     <mm-commits@vger.kernel.org>, <stable@vger.kernel.org>,
        <matthias.bgg@gmail.com>, <glider@google.com>,
        <dvyukov@google.com>, <aryabinin@virtuozzo.com>,
        <miles.chen@mediatek.com>
Date:   Thu, 24 Dec 2020 19:52:04 +0800
In-Reply-To: <20201222190426.zM-LA%akpm@linux-foundation.org>
References: <20201222190426.zM-LA%akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
X-TM-SNTS-SMTP: B296D1DBEB0960FDFD2B5CE45D6DF1CE3B3B7FCF88E98D3C2C544FB30480C0152000:8
X-MTK:  N
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

T24gVHVlLCAyMDIwLTEyLTIyIGF0IDExOjA0IC0wODAwLCBha3BtQGxpbnV4LWZvdW5kYXRpb24u
b3JnIHdyb3RlOg0KPiBUaGUgcGF0Y2ggdGl0bGVkDQo+ICAgICAgU3ViamVjdDoga2FzYW46IGZp
eCBtZW1vcnkgbGVhayBvZiBrYXNhbiBxdWFyYW50aW5lDQo+IGhhcyBiZWVuIHJlbW92ZWQgZnJv
bSB0aGUgLW1tIHRyZWUuICBJdHMgZmlsZW5hbWUgd2FzDQo+ICAgICAga2FzYW4tZml4LW1lbW9y
eS1sZWFrLW9mLWthc2FuLXF1YXJhbnRpbmUucGF0Y2gNCj4gDQo+IFRoaXMgcGF0Y2ggd2FzIGRy
b3BwZWQgYmVjYXVzZSBhbiB1cGRhdGVkIHZlcnNpb24gd2lsbCBiZSBtZXJnZWQNCj4gDQo+IC0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLQ0KPiBG
cm9tOiBLdWFuLVlpbmcgTGVlIDxLdWFuLVlpbmcuTGVlQG1lZGlhdGVrLmNvbT4NCj4gU3ViamVj
dDoga2FzYW46IGZpeCBtZW1vcnkgbGVhayBvZiBrYXNhbiBxdWFyYW50aW5lDQo+IA0KPiBXaGVu
IGNwdSBpcyBnb2luZyBvZmZsaW5lLCBzZXQgcS0+b2ZmbGluZSBhcyB0cnVlIGFuZCBpbnRlcnJ1
cHQgaGFwcGVuZWQuIA0KPiBUaGUgaW50ZXJydXB0IG1heSBjYWxsIHRoZSBxdWFyYW50aW5lX3B1
dC4gIEJ1dCBxdWFyYW50aW5lX3B1dCBkbyBub3QgZnJlZQ0KPiB0aGUgdGhlIG9iamVjdC4gIFRo
ZSBvYmplY3Qgd2lsbCBjYXVzZSBtZW1vcnkgbGVhay4NCj4gDQo+IEFkZCBxbGlua19mcmVlKCkg
dG8gZnJlZSB0aGUgb2JqZWN0Lg0KPiANCj4gTGluazogaHR0cHM6Ly9sa21sLmtlcm5lbC5vcmcv
ci8xNjA4MjA3NDg3LTMwNTM3LTItZ2l0LXNlbmQtZW1haWwtS3Vhbi1ZaW5nLkxlZUBtZWRpYXRl
ay5jb20NCj4gRml4ZXM6IDZjODJkNDVjN2YwMyAoa2FzYW46IGZpeCBvYmplY3QgcmVtYWluaW5n
IGluIG9mZmxpbmUgcGVyLWNwdSBxdWFyYW50aW5lKQ0KPiBTaWduZWQtb2ZmLWJ5OiBLdWFuLVlp
bmcgTGVlIDxLdWFuLVlpbmcuTGVlQG1lZGlhdGVrLmNvbT4NCj4gQ2M6IEFuZHJleSBSeWFiaW5p
biA8YXJ5YWJpbmluQHZpcnR1b3p6by5jb20+DQo+IENjOiBBbGV4YW5kZXIgUG90YXBlbmtvIDxn
bGlkZXJAZ29vZ2xlLmNvbT4NCj4gQ2M6IERtaXRyeSBWeXVrb3YgPGR2eXVrb3ZAZ29vZ2xlLmNv
bT4NCj4gQ2M6IE1hdHRoaWFzIEJydWdnZXIgPG1hdHRoaWFzLmJnZ0BnbWFpbC5jb20+DQo+IENj
OiA8c3RhYmxlQHZnZXIua2VybmVsLm9yZz4gICAgWzUuMTAtXQ0KPiBTaWduZWQtb2ZmLWJ5OiBB
bmRyZXcgTW9ydG9uIDxha3BtQGxpbnV4LWZvdW5kYXRpb24ub3JnPg0KPiAtLS0NCj4gDQo+ICBt
bS9rYXNhbi9xdWFyYW50aW5lLmMgfCAgICAxICsNCj4gIDEgZmlsZSBjaGFuZ2VkLCAxIGluc2Vy
dGlvbigrKQ0KPiANCj4gLS0tIGEvbW0va2FzYW4vcXVhcmFudGluZS5jfmthc2FuLWZpeC1tZW1v
cnktbGVhay1vZi1rYXNhbi1xdWFyYW50aW5lDQo+ICsrKyBhL21tL2thc2FuL3F1YXJhbnRpbmUu
Yw0KPiBAQCAtMTk0LDYgKzE5NCw3IEBAIGJvb2wgcXVhcmFudGluZV9wdXQoc3RydWN0IGttZW1f
Y2FjaGUgKmMNCj4gIA0KPiAgCXEgPSB0aGlzX2NwdV9wdHIoJmNwdV9xdWFyYW50aW5lKTsNCj4g
IAlpZiAocS0+b2ZmbGluZSkgew0KPiArCQlxbGlua19mcmVlKCZpbmZvLT5xdWFyYW50aW5lX2xp
bmssIGNhY2hlKTsNCj4gIAkJbG9jYWxfaXJxX3Jlc3RvcmUoZmxhZ3MpOw0KPiAgCQlyZXR1cm4g
ZmFsc2U7DQo+ICAJfQ0KPiBfDQo+IA0KPiBQYXRjaGVzIGN1cnJlbnRseSBpbiAtbW0gd2hpY2gg
bWlnaHQgYmUgZnJvbSBLdWFuLVlpbmcuTGVlQG1lZGlhdGVrLmNvbSBhcmUNCj4gDQo+IA0KDQpI
aSBBbmRyZXcsDQoNClNvcnJ5IHRvIGJvdGhlci4NCkFmdGVyIHJlY2VudGx5IGthc2FuIHNlcmll
cyBtZXJnZWQgaW50byBtYWlubGluZSwgdGhlIG1lbW9yeSBsZWFrDQppc3N1ZSBoYXMgYmVlbiBm
aXhlZC4gV2UgZG9uJ3QgbmVlZCB0aGlzIHBhdGNoIGFueW1vcmUuDQoNClRoaXMgcGF0Y2ggc3Rh
dGUgY2FuIGJlIGNoYW5nZWQgdG8gb2Jzb2xldGUuDQoNClBsZWFzZSBhYmFuZG9uIHRoaXMgcGF0
Y2guDQoNClRoYW5rcy4NCg0K

