Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAF3D47B42F
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 21:05:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233732AbhLTUFG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 15:05:06 -0500
Received: from smtp-fw-80006.amazon.com ([99.78.197.217]:13850 "EHLO
        smtp-fw-80006.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234439AbhLTUFF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 15:05:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1640030706; x=1671566706;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=PlB/I6ZXo0q3QfPNMy3q+Zv1SU8CJUTUbOr+Ly2eink=;
  b=QrlgcxjH7mIHKpaAr7f85+ScpzMJz9GtbXGGYn9bZT1grtdM2cS9EA3j
   AzmufpAekj0vYoJc5VUfUv9aYHkyKDZBXv1R+S1bQQzI1bJkxiNSLZVmC
   XEyYR4uoa9mz5nZmO6Wukd4Ys4sLVFDPRYfpjubgD68KYJiyglMi8pkv/
   0=;
X-IronPort-AV: E=Sophos;i="5.88,221,1635206400"; 
   d="scan'208";a="49773605"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-iad-1e-204be258.us-east-1.amazon.com) ([10.25.36.214])
  by smtp-border-fw-80006.pdx80.corp.amazon.com with ESMTP; 20 Dec 2021 20:04:48 +0000
Received: from EX13D16EUB003.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-iad-1e-204be258.us-east-1.amazon.com (Postfix) with ESMTPS id 1642A42B5E;
        Mon, 20 Dec 2021 20:04:44 +0000 (UTC)
Received: from [192.168.15.223] (10.43.161.246) by
 EX13D16EUB003.ant.amazon.com (10.43.166.99) with Microsoft SMTP Server (TLS)
 id 15.0.1497.26; Mon, 20 Dec 2021 20:04:38 +0000
Message-ID: <0aa6bada-be03-a5bb-2ba6-57536c42276c@amazon.com>
Date:   Mon, 20 Dec 2021 22:04:27 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.4.0
Subject: =?UTF-8?B?UmU6IFtQQVRDSCB2McKgXSBuaXRyb19lbmNsYXZlczogQWRkIG1tYXBf?=
 =?UTF-8?Q?read=5flock=28=29_for_the_get=5fuser=5fpages=28=29_call?=
Content-Language: en-US
To:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>
CC:     Alexandru Ciobotaru <alcioa@amazon.com>,
        Alexandru Vasile <lexnv@amazon.com>,
        Marcelo Cerri <marcelo.cerri@canonical.com>,
        "Paolo Bonzini" <pbonzini@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Tim Gardner <tim.gardner@canonical.com>,
        kvm <kvm@vger.kernel.org>,
        ne-devel-upstream <ne-devel-upstream@amazon.com>,
        stable <stable@vger.kernel.org>
References: <20211218103525.26739-1-andraprs@amazon.com>
 <87o85btyso.fsf@redhat.com>
From:   "Paraschiv, Andra-Irina" <andraprs@amazon.com>
In-Reply-To: <87o85btyso.fsf@redhat.com>
X-Originating-IP: [10.43.161.246]
X-ClientProxiedBy: EX13P01UWB002.ant.amazon.com (10.43.161.191) To
 EX13D16EUB003.ant.amazon.com (10.43.166.99)
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

CgpPbiAyMC4xMi4yMDIxIDExOjIzLCBWaXRhbHkgS3V6bmV0c292IHdyb3RlOgo+IAo+IEFuZHJh
IFBhcmFzY2hpdiA8YW5kcmFwcnNAYW1hem9uLmNvbT4gd3JpdGVzOgo+IAo+PiBBZnRlciBjb21t
aXQgNWI3OGVkMjRlOGVjIChtbS9wYWdlbWFwOiBhZGQgbW1hcF9hc3NlcnRfbG9ja2VkKCkKPj4g
YW5ub3RhdGlvbnMgdG8gZmluZF92bWEqKCkpLCB0aGUgY2FsbCB0byBnZXRfdXNlcl9wYWdlcygp
IHdpbGwgdHJpZ2dlcgo+PiB0aGUgbW1hcCBhc3NlcnQuCj4+Cj4+IHN0YXRpYyBpbmxpbmUgdm9p
ZCBtbWFwX2Fzc2VydF9sb2NrZWQoc3RydWN0IG1tX3N0cnVjdCAqbW0pCj4+IHsKPj4gICAgICAg
IGxvY2tkZXBfYXNzZXJ0X2hlbGQoJm1tLT5tbWFwX2xvY2spOwo+PiAgICAgICAgVk1fQlVHX09O
X01NKCFyd3NlbV9pc19sb2NrZWQoJm1tLT5tbWFwX2xvY2spLCBtbSk7Cj4+IH0KPj4KPj4gWyAg
IDYyLjUyMTQxMF0ga2VybmVsIEJVRyBhdCBpbmNsdWRlL2xpbnV4L21tYXBfbG9jay5oOjE1NiEK
Pj4gLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4KPj4gWyAgIDYyLjUzODkzOF0gUklQOiAwMDEwOmZpbmRfdm1hKzB4MzIvMHg4MAo+PiAu
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Lgo+PiBbICAgNjIuNjA1ODg5XSBDYWxsIFRyYWNlOgo+PiBbICAgNjIuNjA4NTAyXSAgPFRBU0s+
Cj4+IFsgICA2Mi42MTA5NTZdICA/IGxvY2tfdGltZXJfYmFzZSsweDYxLzB4ODAKPj4gWyAgIDYy
LjYxNDEwNl0gIGZpbmRfZXh0ZW5kX3ZtYSsweDE5LzB4ODAKPj4gWyAgIDYyLjYxNzE5NV0gIF9f
Z2V0X3VzZXJfcGFnZXMrMHg5Yi8weDZhMAo+PiBbICAgNjIuNjIwMzU2XSAgX19ndXBfbG9uZ3Rl
cm1fbG9ja2VkKzB4NDJkLzB4NDUwCj4+IFsgICA2Mi42MjM3MjFdICA/IGZpbmlzaF93YWl0KzB4
NDEvMHg4MAo+PiBbICAgNjIuNjI2NzQ4XSAgPyBfX2ttYWxsb2MrMHgxNzgvMHgyZjAKPj4gWyAg
IDYyLjYyOTc2OF0gIG5lX3NldF91c2VyX21lbW9yeV9yZWdpb25faW9jdGwuaXNyYS4wKzB4MjI1
LzB4NmEwIFtuaXRyb19lbmNsYXZlc10KPj4gWyAgIDYyLjYzNTc3Nl0gIG5lX2VuY2xhdmVfaW9j
dGwrMHgxY2YvMHg2ZDcgW25pdHJvX2VuY2xhdmVzXQo+PiBbICAgNjIuNjM5NTQxXSAgX194NjRf
c3lzX2lvY3RsKzB4ODIvMHhiMAo+PiBbICAgNjIuNjQyNjIwXSAgZG9fc3lzY2FsbF82NCsweDNi
LzB4OTAKPj4gWyAgIDYyLjY0NTY0Ml0gIGVudHJ5X1NZU0NBTExfNjRfYWZ0ZXJfaHdmcmFtZSsw
eDQ0LzB4YWUKPj4KPj4gQWRkIG1tYXBfcmVhZF9sb2NrKCkgZm9yIHRoZSBnZXRfdXNlcl9wYWdl
cygpIGNhbGwgd2hlbiBzZXR0aW5nIHRoZQo+PiBlbmNsYXZlIG1lbW9yeSByZWdpb25zLgo+Pgo+
PiBTaWduZWQtb2ZmLWJ5OiBBbmRyYSBQYXJhc2NoaXYgPGFuZHJhcHJzQGFtYXpvbi5jb20+Cj4+
IENjOiBzdGFibGVAdmdlci5rZXJuZWwub3JnCj4gCj4gSW4gY2FzZSBjb21taXQgNWI3OGVkMjRl
OGVjIGJyb2tlIE5pdHJvIEVuY2xhdmVzIGRyaXZlciwgd2UgbmVlZCB0bwo+IGV4cGxpY2l0bHkg
c3RhdGUgdGhpczoKPiAKPiBGaXhlczogNWI3OGVkMjRlOGVjICgibW0vcGFnZW1hcDogYWRkIG1t
YXBfYXNzZXJ0X2xvY2tlZCgpIGFubm90YXRpb25zIHRvIGZpbmRfdm1hKigpIikKCkFkZGVkIHRv
IHRoZSBjb21taXQgbWVzc2FnZS4KCj4gCj4+IC0tLQo+PiAgIGRyaXZlcnMvdmlydC9uaXRyb19l
bmNsYXZlcy9uZV9taXNjX2Rldi5jIHwgNSArKysrKwo+PiAgIDEgZmlsZSBjaGFuZ2VkLCA1IGlu
c2VydGlvbnMoKykKPj4KPj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvdmlydC9uaXRyb19lbmNsYXZl
cy9uZV9taXNjX2Rldi5jIGIvZHJpdmVycy92aXJ0L25pdHJvX2VuY2xhdmVzL25lX21pc2NfZGV2
LmMKPj4gaW5kZXggODkzOTYxMmVlMGUwLi42YzUxZmYwMjQwMzYgMTAwNjQ0Cj4+IC0tLSBhL2Ry
aXZlcnMvdmlydC9uaXRyb19lbmNsYXZlcy9uZV9taXNjX2Rldi5jCj4+ICsrKyBiL2RyaXZlcnMv
dmlydC9uaXRyb19lbmNsYXZlcy9uZV9taXNjX2Rldi5jCj4+IEBAIC04ODYsOCArODg2LDEzIEBA
IHN0YXRpYyBpbnQgbmVfc2V0X3VzZXJfbWVtb3J5X3JlZ2lvbl9pb2N0bChzdHJ1Y3QgbmVfZW5j
bGF2ZSAqbmVfZW5jbGF2ZSwKPj4gICAgICAgICAgICAgICAgICAgICAgICBnb3RvIHB1dF9wYWdl
czsKPj4gICAgICAgICAgICAgICAgfQo+Pgo+PiArICAgICAgICAgICAgIG1tYXBfcmVhZF9sb2Nr
KGN1cnJlbnQtPm1tKTsKPj4gKwo+PiAgICAgICAgICAgICAgICBndXBfcmMgPSBnZXRfdXNlcl9w
YWdlcyhtZW1fcmVnaW9uLnVzZXJzcGFjZV9hZGRyICsgbWVtb3J5X3NpemUsIDEsIEZPTExfR0VU
LAo+PiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBuZV9tZW1fcmVnaW9u
LT5wYWdlcyArIGksIE5VTEwpOwo+PiArCj4+ICsgICAgICAgICAgICAgbW1hcF9yZWFkX3VubG9j
ayhjdXJyZW50LT5tbSk7Cj4+ICsKPiAKPiBUaGlzIGxvb2tzIHZlcnkgbXVjaCBsaWtlIGdldF91
c2VyX3BhZ2VzX3VubG9ja2VkKCksIEkgdGhpbmsgd2UgY2FuIHVzZQo+IGl0IGluc3RlYWQgb2Yg
b3Blbi1jb2RpbmcgaXQuCgpJbmRlZWQsIGl0J3MgbWVudGlvbmVkIGFzIHdlbGwgaW4gdGhlIGNv
bW1lbnQgZm9yIApnZXRfdXNlcl9wYWdlc191bmxvY2tlZCgpIHRoaXMgcGF0dGVybiBvZiBtbWFw
X3JlYWRfbG9jaygpIC8gCmdldF91c2VyX3BhZ2VzKCkgLyBtbWFwX3JlYWRfdW5sb2NrKCkuCgpU
aGFuayB5b3UgZm9yIHRoZSBmZWVkYmFjaywgVml0YWx5LiBJIHNlbnQgdjIgdGhhdCBpbmNsdWRl
cyB0aGUgCm1lbnRpb25lZCB1cGRhdGVzLgoKVGhhbmtzLApBbmRyYQoKCj4gCj4+ICAgICAgICAg
ICAgICAgIGlmIChndXBfcmMgPCAwKSB7Cj4+ICAgICAgICAgICAgICAgICAgICAgICAgcmMgPSBn
dXBfcmM7Cj4gCj4gLS0KPiBWaXRhbHkKPiAKCgoKQW1hem9uIERldmVsb3BtZW50IENlbnRlciAo
Um9tYW5pYSkgUy5SLkwuIHJlZ2lzdGVyZWQgb2ZmaWNlOiAyN0EgU2YuIExhemFyIFN0cmVldCwg
VUJDNSwgZmxvb3IgMiwgSWFzaSwgSWFzaSBDb3VudHksIDcwMDA0NSwgUm9tYW5pYS4gUmVnaXN0
ZXJlZCBpbiBSb21hbmlhLiBSZWdpc3RyYXRpb24gbnVtYmVyIEoyMi8yNjIxLzIwMDUuCg==

