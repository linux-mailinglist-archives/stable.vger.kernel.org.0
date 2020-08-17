Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8EBA2477F0
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 22:07:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729247AbgHQUHQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 16:07:16 -0400
Received: from mga18.intel.com ([134.134.136.126]:1774 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729194AbgHQUHQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 16:07:16 -0400
IronPort-SDR: c8xPcGZBH8HDnR+8V7+1WIejjqXg/FNa51SdOtRgaqH6OVLYWmKfDgBRGPKCP7FSvhdBQIyJpN
 +T7WPHoXvqbA==
X-IronPort-AV: E=McAfee;i="6000,8403,9716"; a="142409434"
X-IronPort-AV: E=Sophos;i="5.76,324,1592895600"; 
   d="scan'208";a="142409434"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Aug 2020 13:07:11 -0700
IronPort-SDR: GijwEHjm1FQyO7GC0PB0K0vcikscUc4/Bt0rb1OR8SWyFkHbHsApMwQpDasp0iRsV9G1hks46W
 SxBbXRH5ki6g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,324,1592895600"; 
   d="scan'208";a="310200018"
Received: from cwilso3-mobl.fi.intel.com (HELO localhost) ([10.214.206.170])
  by orsmga002.jf.intel.com with ESMTP; 17 Aug 2020 13:07:08 -0700
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
In-Reply-To: <20200817195926.12671-1-mika.kuoppala@linux.intel.com>
References: <159766836466.667.7312583547693920058@build.alporthouse.com> <20200817195926.12671-1-mika.kuoppala@linux.intel.com>
Subject: Re: [PATCH] drm/i915: Fix cmd parser desc matching with masks
From:   Chris Wilson <chris.p.wilson@intel.com>
Cc:     Mika Kuoppala <mika.kuoppala@linux.intel.com>,
        stable@vger.kernel.org, Miroslav Benes <mbenes@suse.cz>,
        Takashi Iwai <tiwai@suse.de>,
        Tyler Hicks <tyhicks@canonical.com>,
        Jon Bloomfield <jon.bloomfield@intel.com>
To:     Mika Kuoppala <mika.kuoppala@linux.intel.com>,
        intel-gfx@lists.freedesktop.org
Date:   Mon, 17 Aug 2020 21:07:06 +0100
Message-ID: <159769482670.667.8256738074280538426@build.alporthouse.com>
User-Agent: alot/0.9
Content-Transfer-Encoding: base64
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

UXVvdGluZyBNaWthIEt1b3BwYWxhICgyMDIwLTA4LTE3IDIwOjU5OjI2KQo+IE91ciB2YXJpZXR5
IG9mIGRlZmluZWQgZ3B1IGNvbW1hbmRzIGhhdmUgdGhlIGFjdHVhbAo+IGNvbW1hbmQgaWQgZmll
bGQgYW5kIHBvc3NpYmx5IGxlbmd0aCBhbmQgZmxhZ3MgYXBwbGllZC4KPiAKPiBXZSBkaWQgc3Rh
cnQgdG8gYXBwbHkgdGhlIG1hc2sgZHVyaW5nIGluaXRpYWxpemF0aW9uIG9mCj4gdGhlIGNtZCBk
ZXNjcmlwdG9ycyBidXQgZm9yZ290IHRvIGFsc28gYXBwbHkgaXQgb24gY29tcGFyaXNvbnMuCj4g
Cj4gRml4IGNvbXBhcmlzb25zIGluIG9yZGVyIHRvIHByb3Blcmx5IGRlbnkgYWNjZXNzIHdpdGgK
PiBhc3NvY2lhdGVkIGNvbW1hbmRzLgo+IAo+IHYyOiBmaXggbHJpIHdpdGggY29ycmVjdCBtYXNr
IChDaHJpcykKPiAKPiBSZWZlcmVuY2VzOiA5MjZhYmZmMjFhOGYgKCJkcm0vaTkxNS9jbWRwYXJz
ZXI6IElnbm9yZSBMZW5ndGggb3BlcmFuZHMgZHVyaW5nIGNvbW1hbmQgbWF0Y2hpbmciKQo+IFJl
cG9ydGVkLWJ5OiBOaWNvbGFpIFN0YW5nZSA8bnN0YW5nZUBzdXNlLmRlPgo+IENjOiBzdGFibGVA
dmdlci5rZXJuZWwub3JnICMgdjUuNCsKPiBDYzogTWlyb3NsYXYgQmVuZXMgPG1iZW5lc0BzdXNl
LmN6Pgo+IENjOiBUYWthc2hpIEl3YWkgPHRpd2FpQHN1c2UuZGU+Cj4gQ2M6IFR5bGVyIEhpY2tz
IDx0eWhpY2tzQGNhbm9uaWNhbC5jb20+Cj4gQ2M6IEpvbiBCbG9vbWZpZWxkIDxqb24uYmxvb21m
aWVsZEBpbnRlbC5jb20+Cj4gQ2M6IENocmlzIFdpbHNvbiA8Y2hyaXMucC53aWxzb25AaW50ZWwu
Y29tPgo+IFNpZ25lZC1vZmYtYnk6IE1pa2EgS3VvcHBhbGEgPG1pa2Eua3VvcHBhbGFAbGludXgu
aW50ZWwuY29tPgo+IC0tLQo+ICBkcml2ZXJzL2dwdS9kcm0vaTkxNS9pOTE1X2NtZF9wYXJzZXIu
YyB8IDE0ICsrKysrKysrKystLS0tCj4gIDEgZmlsZSBjaGFuZ2VkLCAxMCBpbnNlcnRpb25zKCsp
LCA0IGRlbGV0aW9ucygtKQo+IAo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL2dwdS9kcm0vaTkxNS9p
OTE1X2NtZF9wYXJzZXIuYyBiL2RyaXZlcnMvZ3B1L2RybS9pOTE1L2k5MTVfY21kX3BhcnNlci5j
Cj4gaW5kZXggMzcyMzU0ZDMzZjU1Li41YWM0YTk5OWYwNWEgMTAwNjQ0Cj4gLS0tIGEvZHJpdmVy
cy9ncHUvZHJtL2k5MTUvaTkxNV9jbWRfcGFyc2VyLmMKPiArKysgYi9kcml2ZXJzL2dwdS9kcm0v
aTkxNS9pOTE1X2NtZF9wYXJzZXIuYwo+IEBAIC0xMjA0LDYgKzEyMDQsMTIgQEAgc3RhdGljIHUz
MiAqY29weV9iYXRjaChzdHJ1Y3QgZHJtX2k5MTVfZ2VtX29iamVjdCAqZHN0X29iaiwKPiAgICAg
ICAgIHJldHVybiBkc3Q7Cj4gIH0KPiAgCj4gK3N0YXRpYyBpbmxpbmUgYm9vbCBjbWRfZGVzY19p
cyhjb25zdCBzdHJ1Y3QgZHJtX2k5MTVfY21kX2Rlc2NyaXB0b3IgKiBjb25zdCBkZXNjLAo+ICsg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICBjb25zdCB1MzIgY21kKQo+ICt7Cj4gKyAgICAg
ICByZXR1cm4gZGVzYy0+Y21kLnZhbHVlID09IChjbWQgJiBkZXNjLT5jbWQubWFzayk7CgpXZSBj
b3VsZCBvYnNlcnZlIHRoYXQgdGhlIG1hc2sgd2UgbmVlZCBpcyBhbHdheXMgLTF1IDw8IDIzLCB3
ZSBkbyB1c2UKdGhhdCBpbmZvIGFscmVhZHkgZm9yIHRoZSBjbWQgaGFzaGluZywgYnV0IG1vcmUg
aW1wb3J0YW50IGlzIHRoYXQgd2UgYXJlCmNvbnNpc3RlbnQgd2l0aCBvdXIgdXNlIG9mIGRlc2Mt
PmNtZC5tYXNrIGV2ZXJ5d2hlcmUgZWxzZS4KClJldmlld2VkLWJ5OiBDaHJpcyBXaWxzb24gPGNo
cmlzQGNocmlzLXdpbHNvbi5jby51az4KLUNocmlzCi0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLQpJbnRlbCBDb3Jwb3Jh
dGlvbiAoVUspIExpbWl0ZWQKUmVnaXN0ZXJlZCBOby4gMTEzNDk0NSAoRW5nbGFuZCkKUmVnaXN0
ZXJlZCBPZmZpY2U6IFBpcGVycyBXYXksIFN3aW5kb24gU04zIDFSSgpWQVQgTm86IDg2MCAyMTcz
IDQ3CgpUaGlzIGUtbWFpbCBhbmQgYW55IGF0dGFjaG1lbnRzIG1heSBjb250YWluIGNvbmZpZGVu
dGlhbCBtYXRlcmlhbCBmb3IKdGhlIHNvbGUgdXNlIG9mIHRoZSBpbnRlbmRlZCByZWNpcGllbnQo
cykuIEFueSByZXZpZXcgb3IgZGlzdHJpYnV0aW9uCmJ5IG90aGVycyBpcyBzdHJpY3RseSBwcm9o
aWJpdGVkLiBJZiB5b3UgYXJlIG5vdCB0aGUgaW50ZW5kZWQKcmVjaXBpZW50LCBwbGVhc2UgY29u
dGFjdCB0aGUgc2VuZGVyIGFuZCBkZWxldGUgYWxsIGNvcGllcy4K

