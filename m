Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 943F12BAA8C
	for <lists+stable@lfdr.de>; Fri, 20 Nov 2020 13:52:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728091AbgKTMwE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Nov 2020 07:52:04 -0500
Received: from frasgout.his.huawei.com ([185.176.79.56]:2136 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726586AbgKTMwD (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 Nov 2020 07:52:03 -0500
Received: from fraeml702-chm.china.huawei.com (unknown [172.18.147.200])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4CcxGl1WXgz67Fvf;
        Fri, 20 Nov 2020 20:50:23 +0800 (CST)
Received: from fraeml714-chm.china.huawei.com (10.206.15.33) by
 fraeml702-chm.china.huawei.com (10.206.15.51) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1913.5; Fri, 20 Nov 2020 13:52:00 +0100
Received: from fraeml714-chm.china.huawei.com ([10.206.15.33]) by
 fraeml714-chm.china.huawei.com ([10.206.15.33]) with mapi id 15.01.1913.007;
 Fri, 20 Nov 2020 13:52:00 +0100
From:   Roberto Sassu <roberto.sassu@huawei.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>,
        Mimi Zohar <zohar@linux.ibm.com>
CC:     Christoph Hellwig <hch@infradead.org>,
        "linux-integrity@vger.kernel.org" <linux-integrity@vger.kernel.org>,
        "linux-security-module@vger.kernel.org" 
        <linux-security-module@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Silviu Vlasceanu <Silviu.Vlasceanu@huawei.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Paul Moore <paul@paul-moore.com>,
        "Casey Schaufler" <casey@schaufler-ca.com>,
        Stephen Smalley <stephen.smalley.work@gmail.com>,
        John Johansen <john.johansen@canonical.com>,
        Kees Cook <keescook@chromium.org>,
        "James Morris" <jmorris@namei.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        "Micah Morton" <mortonm@chromium.org>
Subject: RE: [RESEND][PATCH] ima: Set and clear FMODE_CAN_READ in
 ima_calc_file_hash()
Thread-Topic: [RESEND][PATCH] ima: Set and clear FMODE_CAN_READ in
 ima_calc_file_hash()
Thread-Index: AQHWuZM+vbqfejrqe02000rC0h3xoqnHabyAgAMLzKCAAG/IAIAABvEAgAAOKACAAAEYgIAAB9QAgAAHL4CAAY8zAIAAU72AgAABvoCAAAHXAIAD/8pw
Date:   Fri, 20 Nov 2020 12:52:00 +0000
Message-ID: <6dafff7889d34bc799b4c5bfd0bfebc8@huawei.com>
References: <20201113080132.16591-1-roberto.sassu@huawei.com>
 <20201114111057.GA16415@infradead.org>
 <0fd0fb3360194d909ba48f13220f9302@huawei.com>
 <20201116162202.GA15010@infradead.org>
 <c556508437ffc10d3873fe25cbbba3484ca574df.camel@linux.ibm.com>
 <CAHk-=wiso=-Fhe2m042CfBNUGhoVB1Pry14DF64uUgztHVOW0g@mail.gmail.com>
 <20201116174127.GA4578@infradead.org>
 <CAHk-=wjd0RNthZQTLVsnK_d9SFYH0rug2tkezLLB0J-YZzVC+Q@mail.gmail.com>
 <3f8cc7c9462353ac2eef58e39beee079bdd9c7b4.camel@linux.ibm.com>
 <CAHk-=wih-ibNUxeiKpuKrw3Rd2=QEAZ8zgRWt_CORAjbZykRWQ@mail.gmail.com>
 <5d8fa26d376999f703aac9103166a572fc0df437.camel@linux.ibm.com>
 <CAHk-=wiPfWZYsAqhQry=mhAbKei8bHZDyVPJS0XHZz_FH9Jymw@mail.gmail.com>
 <CAHk-=wjinHpYRk_F1qiaXbXcMtn-ZHKkPkBvZpDJHjoN_2o4ag@mail.gmail.com>
In-Reply-To: <CAHk-=wjinHpYRk_F1qiaXbXcMtn-ZHKkPkBvZpDJHjoN_2o4ag@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.220.96.108]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

PiBGcm9tOiBMaW51cyBUb3J2YWxkcyBbbWFpbHRvOnRvcnZhbGRzQGxpbnV4LWZvdW5kYXRpb24u
b3JnXQ0KPiBTZW50OiBXZWRuZXNkYXksIE5vdmVtYmVyIDE4LCAyMDIwIDEyOjM3IEFNDQo+IE9u
IFR1ZSwgTm92IDE3LCAyMDIwIGF0IDM6MjkgUE0gTGludXMgVG9ydmFsZHMNCj4gPHRvcnZhbGRz
QGxpbnV4LWZvdW5kYXRpb24ub3JnPiB3cm90ZToNCj4gPg0KPiA+IE9uIFR1ZSwgTm92IDE3LCAy
MDIwIGF0IDM6MjQgUE0gTWltaSBab2hhciA8em9oYXJAbGludXguaWJtLmNvbT4NCj4gd3JvdGU6
DQo+ID4gPg0KPiA+ID4gSSByZWFsbHkgd2lzaCBpdCB3YXNuJ3QgbmVlZGVkLg0KPiA+DQo+ID4g
U2VyaW91c2x5LCBJIGdldCB0aGUgZmVlbGluZyB0aGF0IElNQSBpcyBjb21wbGV0ZWx5IG1pcy1k
ZXNpZ25lZCwgYW5kDQo+ID4gaXMgZG9pbmcgYWN0aXZlbHkgYmFkIHRoaW5ncy4NCj4gPg0KPiA+
IFdobyB1c2VzIHRoaXMgImZlYXR1cmUiLCBhbmQgd2hvIGNhcmVzPyBCZWNhdXNlIEkgd291bGQg
c3VnZ2VzdCB5b3UNCj4gPiBqdXN0IGNoYW5nZSB0aGUgcG9saWN5IGFuZCBiZSBkb25lIHdpdGgg
aXQuDQo+IA0KPiBBbm90aGVyIGFsdGVybmF0aXZlIGlzIHRvIGNoYW5nZSB0aGUgcG9saWN5IGFu
ZCBzYXkgImFueSB3cml0ZS1vbmx5DQo+IG9wZW4gZ2V0cyB0dXJuZWQgaW50byBhIHJlYWQtd3Jp
dGUgb3BlbiIuDQoNCk9uZSBpc3N1ZSB0aGF0IHdvdWxkIGFyaXNlIGZyb20gZG9pbmcgaXQgaXMg
dGhhdCBzZWN1cml0eSBwb2xpY2llcyBuZWVkDQp0byBiZSBtb2RpZmllZCB0byBncmFudCB0aGUg
YWRkaXRpb25hbCByZWFkIHBlcm1pc3Npb24uIElmIHRoZSBvcGVuDQpmbGFnIGlzIGFkZGVkIGVh
cmx5LCB0aGUgTFNNIGhvb2sgc2VjdXJpdHlfZmlsZV9vcGVuKCkgd2lsbCBzZWUgaXQuDQoNClRo
aXMgc29sdXRpb24gc2VlbXMgbm90IG9wdGltYWwsIGFzIHdlIGFyZSBnaXZpbmcgdG8gcHJvY2Vz
c2VzIGENCnBlcm1pc3Npb24gdGhhdCB0aGV5IHdvdWxkbid0IHJlYWxseSB0YWtlIGFkdmFudGFn
ZSBvZiwgc2luY2UgdGhlDQpjb250ZW50IHJlYWQgcmVtYWlucyBpbiBrZXJuZWwgc3BhY2UuIEFu
ZCBhbiBhZGRpdGlvbmFsIHBlcm1pc3Npb24NCmlzIGEgcGVybWlzc2lvbiB0aGF0IGNhbiBiZSBl
eHBsb2l0ZWQuDQoNCkFzIE1pbWkgc2FpZCwgd2UgYWxyZWFkeSBoYXZlIGEgc2Vjb25kIG9wZW4g
d2l0aCBkZW50cnlfb3BlbigpIHdoZW4NCnRoZSBvcmlnaW5hbCBmaWxlIGRlc2NyaXB0b3IgaXMg
bm90IHN1aXRhYmxlLiBUaGUgb25seSBwcm9ibGVtLCB3aGljaCBpcw0Kd2h5IGNoYW5naW5nIHRo
ZSBtb2RlIGlzIHN0aWxsIHRoZXJlLCBpcyB0aGF0IGEgcHJvY2VzcyBzdGlsbCBtaWdodCBub3QN
CmhhdmUgdGhlIHByaXZpbGVnZSB0byByZWFkLCBhbmQgdGhpcyBpcyBhIGxlZ2l0aW1hdGUgY2Fz
ZS4NCg0KV2UgY291bGQgYXNzaWduIGEgbW9yZSBwb3dlcmZ1bCBjcmVkZW50aWFsIHRvIHRoZSBw
cm9jZXNzLCBzaW5jZQ0KZGVudHJ5X29wZW4oKSBhY2NlcHRzIGEgY3JlZGVudGlhbCBhcyBhbiBh
cmd1bWVudC4gV2UgY291bGQgb2J0YWluDQpzdWNoIHBvd2VyZnVsIGNyZWRlbnRpYWwgZnJvbSBw
cmVwYXJlX2tlcm5lbF9jcmVkKCkuIFRoaXMgb3B0aW9uDQpoYXMgYmV0dGVyIGNoYW5jZXMgdG8g
d29yayB3aXRob3V0IG1vZGlmeWluZyBleGlzdGluZyBzZWN1cml0eSBwb2xpY2llcw0KYXMgbGlr
ZWx5IHRob3NlIHBvbGljaWVzIGFscmVhZHkgYXNzaWduZWQgdGhlIHJlcXVpcmVkIHByaXZpbGVn
ZSB0byB0aGUNCmtlcm5lbC4gSG93ZXZlciwgZG9pbmcgc28gbWlnaHQgbm90IGJlIHdoYXQgTFNN
IHBlb3BsZSByZWNvbW1lbmQuDQoNCkFueSBzdWdnZXN0aW9uPw0KDQpUaGFua3MNCg0KUm9iZXJ0
bw0KDQpIVUFXRUkgVEVDSE5PTE9HSUVTIER1ZXNzZWxkb3JmIEdtYkgsIEhSQiA1NjA2Mw0KTWFu
YWdpbmcgRGlyZWN0b3I6IExpIFBlbmcsIExpIEppYW4sIFNoaSBZYW5saQ0K
