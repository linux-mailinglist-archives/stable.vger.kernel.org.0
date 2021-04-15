Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9E7B36095C
	for <lists+stable@lfdr.de>; Thu, 15 Apr 2021 14:26:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232997AbhDOM0T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Apr 2021 08:26:19 -0400
Received: from frasgout.his.huawei.com ([185.176.79.56]:2867 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232975AbhDOM0Q (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Apr 2021 08:26:16 -0400
Received: from fraeml715-chm.china.huawei.com (unknown [172.18.147.206])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4FLdbb1Rksz68BPR;
        Thu, 15 Apr 2021 20:15:55 +0800 (CST)
Received: from fraeml714-chm.china.huawei.com (10.206.15.33) by
 fraeml715-chm.china.huawei.com (10.206.15.34) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Thu, 15 Apr 2021 14:25:50 +0200
Received: from fraeml714-chm.china.huawei.com ([10.206.15.33]) by
 fraeml714-chm.china.huawei.com ([10.206.15.33]) with mapi id 15.01.2106.013;
 Thu, 15 Apr 2021 14:25:50 +0200
From:   Roberto Sassu <roberto.sassu@huawei.com>
To:     Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Jeff Mahoney <jeffm@suse.com>
CC:     "linux-integrity@vger.kernel.org" <linux-integrity@vger.kernel.org>,
        "linux-security-module@vger.kernel.org" 
        <linux-security-module@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "selinux@vger.kernel.org" <selinux@vger.kernel.org>,
        "reiserfs-devel@vger.kernel.org" <reiserfs-devel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "zohar@linux.ibm.com" <zohar@linux.ibm.com>,
        "jmorris@namei.org" <jmorris@namei.org>,
        "paul@paul-moore.com" <paul@paul-moore.com>,
        "casey@schaufler-ca.com" <casey@schaufler-ca.com>
Subject: RE: [PATCH 1/5] xattr: Complete constify ->name member of "struct
 xattr"
Thread-Topic: [PATCH 1/5] xattr: Complete constify ->name member of "struct
 xattr"
Thread-Index: AQHXMd7FDBbRfOc0Vkms8LxU+cs6Xqq1TVmAgAAzkSA=
Date:   Thu, 15 Apr 2021 12:25:49 +0000
Message-ID: <eedc6f82d59b4084b529788efd43e10b@huawei.com>
References: <20210415100435.18619-1-roberto.sassu@huawei.com>
 <20210415100435.18619-2-roberto.sassu@huawei.com>
 <164b0933-0917-457e-4dad-245ea13cbe52@i-love.sakura.ne.jp>
In-Reply-To: <164b0933-0917-457e-4dad-245ea13cbe52@i-love.sakura.ne.jp>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.48.215.118]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

PiBGcm9tOiBUZXRzdW8gSGFuZGEgW21haWx0bzpwZW5ndWluLWtlcm5lbEBpLWxvdmUuc2FrdXJh
Lm5lLmpwXQ0KPiBTZW50OiBUaHVyc2RheSwgQXByaWwgMTUsIDIwMjEgMToyMCBQTQ0KPiBPbiAy
MDIxLzA0LzE1IDE5OjA0LCBSb2JlcnRvIFNhc3N1IHdyb3RlOg0KPiA+IFRoaXMgcGF0Y2ggY29t
cGxldGVzIGNvbW1pdCA5NTQ4OTA2YjJiYjcgKCd4YXR0cjogQ29uc3RpZnkgLT5uYW1lDQo+IG1l
bWJlciBvZg0KPiA+ICJzdHJ1Y3QgeGF0dHIiJykuIEl0IGZpeGVzIHRoZSBkb2N1bWVudGF0aW9u
IG9mIHRoZSBpbm9kZV9pbml0X3NlY3VyaXR5DQo+ID4gaG9vaywgYnkgcmVtb3ZpbmcgdGhlIHhh
dHRyIG5hbWUgZnJvbSB0aGUgb2JqZWN0cyB0aGF0IGFyZSBleHBlY3RlZCB0bw0KPiBiZQ0KPiA+
IGFsbG9jYXRlZCBieSBMU01zIChvbmx5IHRoZSB2YWx1ZSBpcyBhbGxvY2F0ZWQpLiBBbHNvLCBp
dCByZW1vdmVzIHRoZQ0KPiA+IGtmcmVlKCkgb2YgbmFtZSBhbmQgc2V0dGluZyBpdCB0byBOVUxM
IGluIHRoZSByZWlzZXJmcyBjb2RlLg0KPiANCj4gR29vZCBjYXRjaCwgYnV0IHdlbGwsIGdyZXAg
ZG9lcyBub3QgZmluZCBhbnkgcmVpc2VyZnNfc2VjdXJpdHlfZnJlZSgpIGNhbGxlcnMuDQo+IElz
IHJlaXNlcmZzX3NlY3VyaXR5X2ZyZWUoKSBhIGRlYWQgY29kZT8NCg0KVWhtLCBJIGFsc28gZG9u
J3Qgc2VlIGl0Lg0KDQpUaGFua3MNCg0KUm9iZXJ0bw0KDQpIVUFXRUkgVEVDSE5PTE9HSUVTIER1
ZXNzZWxkb3JmIEdtYkgsIEhSQiA1NjA2Mw0KTWFuYWdpbmcgRGlyZWN0b3I6IExpIFBlbmcsIExp
IEppYW4sIFNoaSBZYW5saQ0K
