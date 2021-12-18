Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FCCC479A60
	for <lists+stable@lfdr.de>; Sat, 18 Dec 2021 11:43:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231704AbhLRKnt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 18 Dec 2021 05:43:49 -0500
Received: from smtp-fw-6001.amazon.com ([52.95.48.154]:30590 "EHLO
        smtp-fw-6001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229480AbhLRKnt (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 18 Dec 2021 05:43:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1639824230; x=1671360230;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=fxdFjM0cO1TR0GpqiG4Wy5h+pHx/lt1vemJ+nv9c92k=;
  b=gbb7uF73mhcRI6+bm0NmugBpguQARPAQdyty0N+OLNKadndQJOVLiKYQ
   tD+TcFrHbwoPOf1zWXlxUodP7LRfDGBRNi+auSMJy3lmx8CVSv+uqZxzo
   qY9JO5nyCo/AVmu3aD+BXUdqoCQ66ATXLgFHYGHKN5yXq+vxTB6PXC6jV
   Y=;
X-IronPort-AV: E=Sophos;i="5.88,216,1635206400"; 
   d="scan'208";a="164451902"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-iad-1a-1ac2810f.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-6001.iad6.amazon.com with ESMTP; 18 Dec 2021 10:43:39 +0000
Received: from EX13D16EUB003.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-iad-1a-1ac2810f.us-east-1.amazon.com (Postfix) with ESMTPS id EF9E5812B3;
        Sat, 18 Dec 2021 10:43:35 +0000 (UTC)
Received: from [192.168.18.37] (10.43.161.102) by EX13D16EUB003.ant.amazon.com
 (10.43.166.99) with Microsoft SMTP Server (TLS) id 15.0.1497.26; Sat, 18 Dec
 2021 10:43:28 +0000
Message-ID: <fccc4545-2a8e-df40-f7ba-ae48651dda39@amazon.com>
Date:   Sat, 18 Dec 2021 12:43:24 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.4.0
Subject: =?UTF-8?B?UmU6IFtQQVRDSCB2McKgXSBuaXRyb19lbmNsYXZlczogQWRkIG1tYXBf?=
 =?UTF-8?Q?read=5flock=28=29_for_the_get=5fuser=5fpages=28=29_call?=
Content-Language: en-US
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
From:   "Paraschiv, Andra-Irina" <andraprs@amazon.com>
In-Reply-To: <20211218103525.26739-1-andraprs@amazon.com>
X-Originating-IP: [10.43.161.102]
X-ClientProxiedBy: EX13D12UWC004.ant.amazon.com (10.43.162.182) To
 EX13D16EUB003.ant.amazon.com (10.43.166.99)
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

CgpPbiAxOC4xMi4yMDIxIDEyOjM1LCBBbmRyYSBQYXJhc2NoaXYgd3JvdGU6Cj4gQWZ0ZXIgY29t
bWl0IDViNzhlZDI0ZThlYyAobW0vcGFnZW1hcDogYWRkIG1tYXBfYXNzZXJ0X2xvY2tlZCgpCj4g
YW5ub3RhdGlvbnMgdG8gZmluZF92bWEqKCkpLCB0aGUgY2FsbCB0byBnZXRfdXNlcl9wYWdlcygp
IHdpbGwgdHJpZ2dlcgo+IHRoZSBtbWFwIGFzc2VydC4KPiAKPiBzdGF0aWMgaW5saW5lIHZvaWQg
bW1hcF9hc3NlcnRfbG9ja2VkKHN0cnVjdCBtbV9zdHJ1Y3QgKm1tKQo+IHsKPiAJbG9ja2RlcF9h
c3NlcnRfaGVsZCgmbW0tPm1tYXBfbG9jayk7Cj4gCVZNX0JVR19PTl9NTSghcndzZW1faXNfbG9j
a2VkKCZtbS0+bW1hcF9sb2NrKSwgbW0pOwo+IH0KPiAKPiBbICAgNjIuNTIxNDEwXSBrZXJuZWwg
QlVHIGF0IGluY2x1ZGUvbGludXgvbW1hcF9sb2NrLmg6MTU2IQo+IC4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uCj4gWyAgIDYyLjUzODkz
OF0gUklQOiAwMDEwOmZpbmRfdm1hKzB4MzIvMHg4MAo+IC4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uCj4gWyAgIDYyLjYwNTg4OV0gQ2Fs
bCBUcmFjZToKPiBbICAgNjIuNjA4NTAyXSAgPFRBU0s+Cj4gWyAgIDYyLjYxMDk1Nl0gID8gbG9j
a190aW1lcl9iYXNlKzB4NjEvMHg4MAo+IFsgICA2Mi42MTQxMDZdICBmaW5kX2V4dGVuZF92bWEr
MHgxOS8weDgwCj4gWyAgIDYyLjYxNzE5NV0gIF9fZ2V0X3VzZXJfcGFnZXMrMHg5Yi8weDZhMAo+
IFsgICA2Mi42MjAzNTZdICBfX2d1cF9sb25ndGVybV9sb2NrZWQrMHg0MmQvMHg0NTAKPiBbICAg
NjIuNjIzNzIxXSAgPyBmaW5pc2hfd2FpdCsweDQxLzB4ODAKPiBbICAgNjIuNjI2NzQ4XSAgPyBf
X2ttYWxsb2MrMHgxNzgvMHgyZjAKPiBbICAgNjIuNjI5NzY4XSAgbmVfc2V0X3VzZXJfbWVtb3J5
X3JlZ2lvbl9pb2N0bC5pc3JhLjArMHgyMjUvMHg2YTAgW25pdHJvX2VuY2xhdmVzXQo+IFsgICA2
Mi42MzU3NzZdICBuZV9lbmNsYXZlX2lvY3RsKzB4MWNmLzB4NmQ3IFtuaXRyb19lbmNsYXZlc10K
PiBbICAgNjIuNjM5NTQxXSAgX194NjRfc3lzX2lvY3RsKzB4ODIvMHhiMAo+IFsgICA2Mi42NDI2
MjBdICBkb19zeXNjYWxsXzY0KzB4M2IvMHg5MAo+IFsgICA2Mi42NDU2NDJdICBlbnRyeV9TWVND
QUxMXzY0X2FmdGVyX2h3ZnJhbWUrMHg0NC8weGFlCj4gCj4gQWRkIG1tYXBfcmVhZF9sb2NrKCkg
Zm9yIHRoZSBnZXRfdXNlcl9wYWdlcygpIGNhbGwgd2hlbiBzZXR0aW5nIHRoZQo+IGVuY2xhdmUg
bWVtb3J5IHJlZ2lvbnMuCj4gCj4gU2lnbmVkLW9mZi1ieTogQW5kcmEgUGFyYXNjaGl2IDxhbmRy
YXByc0BhbWF6b24uY29tPgo+IENjOiBzdGFibGVAdmdlci5rZXJuZWwub3JnCj4gLS0tCgpHcmVn
LCBjYW4geW91IHBsZWFzZSBpbmNsdWRlIHRoaXMgZml4IGluIHRoZSBxdWV1ZSBmb3IgdjUuMTYg
YW5kIHRoZW4gaW4gCnRoZSBvbmUgZm9yIHRoZSB2NS4xNSBzdGFibGUgdHJlZS4gTGV0IG1lIGtu
b3cgaWYgYW55IHVwZGF0ZXMgYXJlIApuZWNlc3NhcnkgZm9yIHRoZSBwYXRjaC4KClRoYW5rcywK
QW5kcmEKCj4gICBkcml2ZXJzL3ZpcnQvbml0cm9fZW5jbGF2ZXMvbmVfbWlzY19kZXYuYyB8IDUg
KysrKysKPiAgIDEgZmlsZSBjaGFuZ2VkLCA1IGluc2VydGlvbnMoKykKPiAKPiBkaWZmIC0tZ2l0
IGEvZHJpdmVycy92aXJ0L25pdHJvX2VuY2xhdmVzL25lX21pc2NfZGV2LmMgYi9kcml2ZXJzL3Zp
cnQvbml0cm9fZW5jbGF2ZXMvbmVfbWlzY19kZXYuYwo+IGluZGV4IDg5Mzk2MTJlZTBlMC4uNmM1
MWZmMDI0MDM2IDEwMDY0NAo+IC0tLSBhL2RyaXZlcnMvdmlydC9uaXRyb19lbmNsYXZlcy9uZV9t
aXNjX2Rldi5jCj4gKysrIGIvZHJpdmVycy92aXJ0L25pdHJvX2VuY2xhdmVzL25lX21pc2NfZGV2
LmMKPiBAQCAtODg2LDggKzg4NiwxMyBAQCBzdGF0aWMgaW50IG5lX3NldF91c2VyX21lbW9yeV9y
ZWdpb25faW9jdGwoc3RydWN0IG5lX2VuY2xhdmUgKm5lX2VuY2xhdmUsCj4gICAJCQlnb3RvIHB1
dF9wYWdlczsKPiAgIAkJfQo+ICAgCj4gKwkJbW1hcF9yZWFkX2xvY2soY3VycmVudC0+bW0pOwo+
ICsKPiAgIAkJZ3VwX3JjID0gZ2V0X3VzZXJfcGFnZXMobWVtX3JlZ2lvbi51c2Vyc3BhY2VfYWRk
ciArIG1lbW9yeV9zaXplLCAxLCBGT0xMX0dFVCwKPiAgIAkJCQkJbmVfbWVtX3JlZ2lvbi0+cGFn
ZXMgKyBpLCBOVUxMKTsKPiArCj4gKwkJbW1hcF9yZWFkX3VubG9jayhjdXJyZW50LT5tbSk7Cj4g
Kwo+ICAgCQlpZiAoZ3VwX3JjIDwgMCkgewo+ICAgCQkJcmMgPSBndXBfcmM7Cj4gICAKCgoKQW1h
em9uIERldmVsb3BtZW50IENlbnRlciAoUm9tYW5pYSkgUy5SLkwuIHJlZ2lzdGVyZWQgb2ZmaWNl
OiAyN0EgU2YuIExhemFyIFN0cmVldCwgVUJDNSwgZmxvb3IgMiwgSWFzaSwgSWFzaSBDb3VudHks
IDcwMDA0NSwgUm9tYW5pYS4gUmVnaXN0ZXJlZCBpbiBSb21hbmlhLiBSZWdpc3RyYXRpb24gbnVt
YmVyIEoyMi8yNjIxLzIwMDUuCg==

