Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDD224833DE
	for <lists+stable@lfdr.de>; Mon,  3 Jan 2022 16:04:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233628AbiACPEJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jan 2022 10:04:09 -0500
Received: from smtp-fw-6002.amazon.com ([52.95.49.90]:34139 "EHLO
        smtp-fw-6002.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229978AbiACPEJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Jan 2022 10:04:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1641222249; x=1672758249;
  h=message-id:date:mime-version:subject:from:to:cc:
   references:in-reply-to:content-transfer-encoding;
  bh=6DDI/5rt+hvVm8HYZLjfL2SPPunScVsJPs0AFGYZLjY=;
  b=HMUMto6ITRNvyRccg0XapIQgQILY40gTBe0vxqMNyX5PZVxsvfM4oL9j
   0MO6jGnT+z1+0GIghYK/Q5xogacrbJNX9n76UDHbBuNIox/NWf4zR+nBe
   eCgslxd577n14GsoR4/d6R796LGCj6oosD5oeJhyXxoSpLaDP2BI30QdU
   0=;
X-IronPort-AV: E=Sophos;i="5.88,258,1635206400"; 
   d="scan'208";a="165934371"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-iad-1e-98691110.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-6002.iad6.amazon.com with ESMTP; 03 Jan 2022 15:03:56 +0000
Received: from EX13D16EUB003.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-iad-1e-98691110.us-east-1.amazon.com (Postfix) with ESMTPS id D578381342;
        Mon,  3 Jan 2022 15:03:53 +0000 (UTC)
Received: from [192.168.16.229] (10.43.160.87) by EX13D16EUB003.ant.amazon.com
 (10.43.166.99) with Microsoft SMTP Server (TLS) id 15.0.1497.26; Mon, 3 Jan
 2022 15:03:47 +0000
Message-ID: <0185a841-72df-1c8f-7e5f-d64dd18cee57@amazon.com>
Date:   Mon, 3 Jan 2022 17:03:37 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.4.0
Subject: =?UTF-8?B?UmU6IFtQQVRDSCB2McKgXSBuaXRyb19lbmNsYXZlczogQWRkIG1tYXBf?=
 =?UTF-8?Q?read=5flock=28=29_for_the_get=5fuser=5fpages=28=29_call?=
Content-Language: en-US
From:   "Paraschiv, Andra-Irina" <andraprs@amazon.com>
To:     linux-kernel <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>
CC:     Alexandru Ciobotaru <alcioa@amazon.com>,
        Alexandru Vasile <lexnv@amazon.com>,
        Marcelo Cerri <marcelo.cerri@canonical.com>,
        "Paolo Bonzini" <pbonzini@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Tim Gardner <tim.gardner@canonical.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        kvm <kvm@vger.kernel.org>,
        ne-devel-upstream <ne-devel-upstream@amazon.com>,
        stable <stable@vger.kernel.org>
References: <20211218103525.26739-1-andraprs@amazon.com>
 <fccc4545-2a8e-df40-f7ba-ae48651dda39@amazon.com>
In-Reply-To: <fccc4545-2a8e-df40-f7ba-ae48651dda39@amazon.com>
X-Originating-IP: [10.43.160.87]
X-ClientProxiedBy: EX13D17UWB004.ant.amazon.com (10.43.161.132) To
 EX13D16EUB003.ant.amazon.com (10.43.166.99)
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

CgpPbiAxOC4xMi4yMDIxIDEyOjQzLCBQYXJhc2NoaXYsIEFuZHJhLUlyaW5hIHdyb3RlOgo+IAo+
IAo+IE9uIDE4LjEyLjIwMjEgMTI6MzUsIEFuZHJhIFBhcmFzY2hpdiB3cm90ZToKPj4gQWZ0ZXIg
Y29tbWl0IDViNzhlZDI0ZThlYyAobW0vcGFnZW1hcDogYWRkIG1tYXBfYXNzZXJ0X2xvY2tlZCgp
Cj4+IGFubm90YXRpb25zIHRvIGZpbmRfdm1hKigpKSwgdGhlIGNhbGwgdG8gZ2V0X3VzZXJfcGFn
ZXMoKSB3aWxsIHRyaWdnZXIKPj4gdGhlIG1tYXAgYXNzZXJ0Lgo+Pgo+PiBzdGF0aWMgaW5saW5l
IHZvaWQgbW1hcF9hc3NlcnRfbG9ja2VkKHN0cnVjdCBtbV9zdHJ1Y3QgKm1tKQo+PiB7Cj4+IMKg
wqDCoMKgbG9ja2RlcF9hc3NlcnRfaGVsZCgmbW0tPm1tYXBfbG9jayk7Cj4+IMKgwqDCoMKgVk1f
QlVHX09OX01NKCFyd3NlbV9pc19sb2NrZWQoJm1tLT5tbWFwX2xvY2spLCBtbSk7Cj4+IH0KPj4K
Pj4gW8KgwqAgNjIuNTIxNDEwXSBrZXJuZWwgQlVHIGF0IGluY2x1ZGUvbGludXgvbW1hcF9sb2Nr
Lmg6MTU2IQo+PiAuLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLgo+PiBbwqDCoCA2Mi41Mzg5MzhdIFJJUDogMDAxMDpmaW5kX3ZtYSsweDMy
LzB4ODAKPj4gLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4KPj4gW8KgwqAgNjIuNjA1ODg5XSBDYWxsIFRyYWNlOgo+PiBbwqDCoCA2Mi42
MDg1MDJdwqAgPFRBU0s+Cj4+IFvCoMKgIDYyLjYxMDk1Nl3CoCA/IGxvY2tfdGltZXJfYmFzZSsw
eDYxLzB4ODAKPj4gW8KgwqAgNjIuNjE0MTA2XcKgIGZpbmRfZXh0ZW5kX3ZtYSsweDE5LzB4ODAK
Pj4gW8KgwqAgNjIuNjE3MTk1XcKgIF9fZ2V0X3VzZXJfcGFnZXMrMHg5Yi8weDZhMAo+PiBbwqDC
oCA2Mi42MjAzNTZdwqAgX19ndXBfbG9uZ3Rlcm1fbG9ja2VkKzB4NDJkLzB4NDUwCj4+IFvCoMKg
IDYyLjYyMzcyMV3CoCA/IGZpbmlzaF93YWl0KzB4NDEvMHg4MAo+PiBbwqDCoCA2Mi42MjY3NDhd
wqAgPyBfX2ttYWxsb2MrMHgxNzgvMHgyZjAKPj4gW8KgwqAgNjIuNjI5NzY4XcKgIG5lX3NldF91
c2VyX21lbW9yeV9yZWdpb25faW9jdGwuaXNyYS4wKzB4MjI1LzB4NmEwIAo+PiBbbml0cm9fZW5j
bGF2ZXNdCj4+IFvCoMKgIDYyLjYzNTc3Nl3CoCBuZV9lbmNsYXZlX2lvY3RsKzB4MWNmLzB4NmQ3
IFtuaXRyb19lbmNsYXZlc10KPj4gW8KgwqAgNjIuNjM5NTQxXcKgIF9feDY0X3N5c19pb2N0bCsw
eDgyLzB4YjAKPj4gW8KgwqAgNjIuNjQyNjIwXcKgIGRvX3N5c2NhbGxfNjQrMHgzYi8weDkwCj4+
IFvCoMKgIDYyLjY0NTY0Ml3CoCBlbnRyeV9TWVNDQUxMXzY0X2FmdGVyX2h3ZnJhbWUrMHg0NC8w
eGFlCj4+Cj4+IEFkZCBtbWFwX3JlYWRfbG9jaygpIGZvciB0aGUgZ2V0X3VzZXJfcGFnZXMoKSBj
YWxsIHdoZW4gc2V0dGluZyB0aGUKPj4gZW5jbGF2ZSBtZW1vcnkgcmVnaW9ucy4KPj4KPj4gU2ln
bmVkLW9mZi1ieTogQW5kcmEgUGFyYXNjaGl2IDxhbmRyYXByc0BhbWF6b24uY29tPgo+PiBDYzog
c3RhYmxlQHZnZXIua2VybmVsLm9yZwo+PiAtLS0KPiAKPiBHcmVnLCBjYW4geW91IHBsZWFzZSBp
bmNsdWRlIHRoaXMgZml4IGluIHRoZSBxdWV1ZSBmb3IgdjUuMTYgYW5kIHRoZW4gaW4gCj4gdGhl
IG9uZSBmb3IgdGhlIHY1LjE1IHN0YWJsZSB0cmVlLiBMZXQgbWUga25vdyBpZiBhbnkgdXBkYXRl
cyBhcmUgCj4gbmVjZXNzYXJ5IGZvciB0aGUgcGF0Y2guCj4gCgpUaGFuayB5b3UsIEdyZWcsIGZv
ciBoZWxwaW5nIHdpdGggdGhlIG1lcmdlIG9mIHYyIGZvciB0aGlzIHBhdGNoLgoKQW5kcmEKCj4g
Cj4+IMKgIGRyaXZlcnMvdmlydC9uaXRyb19lbmNsYXZlcy9uZV9taXNjX2Rldi5jIHwgNSArKysr
Kwo+PiDCoCAxIGZpbGUgY2hhbmdlZCwgNSBpbnNlcnRpb25zKCspCj4+Cj4+IGRpZmYgLS1naXQg
YS9kcml2ZXJzL3ZpcnQvbml0cm9fZW5jbGF2ZXMvbmVfbWlzY19kZXYuYyAKPj4gYi9kcml2ZXJz
L3ZpcnQvbml0cm9fZW5jbGF2ZXMvbmVfbWlzY19kZXYuYwo+PiBpbmRleCA4OTM5NjEyZWUwZTAu
LjZjNTFmZjAyNDAzNiAxMDA2NDQKPj4gLS0tIGEvZHJpdmVycy92aXJ0L25pdHJvX2VuY2xhdmVz
L25lX21pc2NfZGV2LmMKPj4gKysrIGIvZHJpdmVycy92aXJ0L25pdHJvX2VuY2xhdmVzL25lX21p
c2NfZGV2LmMKPj4gQEAgLTg4Niw4ICs4ODYsMTMgQEAgc3RhdGljIGludCBuZV9zZXRfdXNlcl9t
ZW1vcnlfcmVnaW9uX2lvY3RsKHN0cnVjdCAKPj4gbmVfZW5jbGF2ZSAqbmVfZW5jbGF2ZSwKPj4g
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgZ290byBwdXRfcGFnZXM7Cj4+IMKgwqDCoMKgwqDC
oMKgwqDCoCB9Cj4+ICvCoMKgwqDCoMKgwqDCoCBtbWFwX3JlYWRfbG9jayhjdXJyZW50LT5tbSk7
Cj4+ICsKPj4gwqDCoMKgwqDCoMKgwqDCoMKgIGd1cF9yYyA9IGdldF91c2VyX3BhZ2VzKG1lbV9y
ZWdpb24udXNlcnNwYWNlX2FkZHIgKyAKPj4gbWVtb3J5X3NpemUsIDEsIEZPTExfR0VULAo+PiDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgbmVfbWVtX3JlZ2lvbi0+
cGFnZXMgKyBpLCBOVUxMKTsKPj4gKwo+PiArwqDCoMKgwqDCoMKgwqAgbW1hcF9yZWFkX3VubG9j
ayhjdXJyZW50LT5tbSk7Cj4+ICsKPj4gwqDCoMKgwqDCoMKgwqDCoMKgIGlmIChndXBfcmMgPCAw
KSB7Cj4+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHJjID0gZ3VwX3JjOwoKCgpBbWF6b24g
RGV2ZWxvcG1lbnQgQ2VudGVyIChSb21hbmlhKSBTLlIuTC4gcmVnaXN0ZXJlZCBvZmZpY2U6IDI3
QSBTZi4gTGF6YXIgU3RyZWV0LCBVQkM1LCBmbG9vciAyLCBJYXNpLCBJYXNpIENvdW50eSwgNzAw
MDQ1LCBSb21hbmlhLiBSZWdpc3RlcmVkIGluIFJvbWFuaWEuIFJlZ2lzdHJhdGlvbiBudW1iZXIg
SjIyLzI2MjEvMjAwNS4K

