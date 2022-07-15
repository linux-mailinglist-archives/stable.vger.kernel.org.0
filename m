Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E96BE575A75
	for <lists+stable@lfdr.de>; Fri, 15 Jul 2022 06:26:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229436AbiGOEW6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jul 2022 00:22:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229599AbiGOEW5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Jul 2022 00:22:57 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E03A878234;
        Thu, 14 Jul 2022 21:22:54 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 8315433C2D;
        Fri, 15 Jul 2022 04:22:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1657858973; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=YUFV8lGLyNcki2QXaB/06UGYVGKE3MtbnfRGU8W6WMw=;
        b=lVjAsTowSb+Kb0dq2tiRXFv8Pe6UMXCgY9MU0LuegIzrwtrvZVqqDt/EsgR9w1+ehnndEC
        DWQ7/i/ydNIrgjPpP365OJAqmb9uKJN82scuAr72KEsM8kqA6Xek0rXwK2tX5miuz7vCjD
        u/bYeBLWroXdfgmtJawB+QOCgA3zu6g=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id D57C3133A6;
        Fri, 15 Jul 2022 04:22:52 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id OGKqMpzr0GKySwAAMHmgww
        (envelope-from <jgross@suse.com>); Fri, 15 Jul 2022 04:22:52 +0000
Message-ID: <fa6f1dd4-02b6-779e-2ee4-12644d1b3c3f@suse.com>
Date:   Fri, 15 Jul 2022 06:22:52 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Content-Language: en-US
To:     Chuck Zmudzinski <brchuckz@netscape.net>,
        Chuck Zmudzinski <brchuckz@aol.com>,
        linux-kernel@vger.kernel.org
Cc:     Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Dan Williams <dan.j.williams@intel.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Jane Chu <jane.chu@oracle.com>,
        Tianyu Lan <Tianyu.Lan@microsoft.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Sean Christopherson <seanjc@google.com>,
        Jan Beulich <jbeulich@suse.com>,
        xen-devel@lists.xenproject.org, stable@vger.kernel.org
References: <9d5070ae4f3e956a95d3f50e24f1a93488b9ff52.1657671676.git.brchuckz.ref@aol.com>
 <9d5070ae4f3e956a95d3f50e24f1a93488b9ff52.1657671676.git.brchuckz@aol.com>
 <ec4b2791-886f-4d52-ab39-b0c07489c4ca@suse.com>
 <c0a19463-b46f-e757-c1f9-21d4c2f8bc54@netscape.net>
From:   Juergen Gross <jgross@suse.com>
Subject: Re: [PATCH v2] Subject: x86/PAT: Report PAT on CPUs that support PAT
 without MTRR
In-Reply-To: <c0a19463-b46f-e757-c1f9-21d4c2f8bc54@netscape.net>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------EQ4qcO3BsuuirRREa53dJEtQ"
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------EQ4qcO3BsuuirRREa53dJEtQ
Content-Type: multipart/mixed; boundary="------------bxKcZEHZlX70PgXzH2z1YL6d";
 protected-headers="v1"
From: Juergen Gross <jgross@suse.com>
To: Chuck Zmudzinski <brchuckz@netscape.net>,
 Chuck Zmudzinski <brchuckz@aol.com>, linux-kernel@vger.kernel.org
Cc: Dave Hansen <dave.hansen@linux.intel.com>,
 Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
 Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, x86@kernel.org,
 "H. Peter Anvin" <hpa@zytor.com>, Dan Williams <dan.j.williams@intel.com>,
 "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
 Tom Lendacky <thomas.lendacky@amd.com>, Jane Chu <jane.chu@oracle.com>,
 Tianyu Lan <Tianyu.Lan@microsoft.com>, Randy Dunlap <rdunlap@infradead.org>,
 Sean Christopherson <seanjc@google.com>, Jan Beulich <jbeulich@suse.com>,
 xen-devel@lists.xenproject.org, stable@vger.kernel.org
Message-ID: <fa6f1dd4-02b6-779e-2ee4-12644d1b3c3f@suse.com>
Subject: Re: [PATCH v2] Subject: x86/PAT: Report PAT on CPUs that support PAT
 without MTRR
References: <9d5070ae4f3e956a95d3f50e24f1a93488b9ff52.1657671676.git.brchuckz.ref@aol.com>
 <9d5070ae4f3e956a95d3f50e24f1a93488b9ff52.1657671676.git.brchuckz@aol.com>
 <ec4b2791-886f-4d52-ab39-b0c07489c4ca@suse.com>
 <c0a19463-b46f-e757-c1f9-21d4c2f8bc54@netscape.net>
In-Reply-To: <c0a19463-b46f-e757-c1f9-21d4c2f8bc54@netscape.net>

--------------bxKcZEHZlX70PgXzH2z1YL6d
Content-Type: multipart/mixed; boundary="------------uCPvqSlE4vvTlN2SPxRYkRDj"

--------------uCPvqSlE4vvTlN2SPxRYkRDj
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gMTUuMDcuMjIgMDQ6MTksIENodWNrIFptdWR6aW5za2kgd3JvdGU6DQo+IE9uIDcvMTQv
MjAyMiAxOjQwIEFNLCBKdWVyZ2VuIEdyb3NzIHdyb3RlOg0KPj4gT24gMTMuMDcuMjIgMDM6
MzYsIENodWNrIFptdWR6aW5za2kgd3JvdGU6DQo+Pj4gVGhlIGNvbW1pdCA5OWMxM2I4Yzg4
OTZkN2JjYjkyNzUzYmYNCj4+PiAoIng4Ni9tbS9wYXQ6IERvbid0IHJlcG9ydCBQQVQgb24g
Q1BVcyB0aGF0IGRvbid0IHN1cHBvcnQgaXQiKQ0KPj4+IGluY29ycmVjdGx5IGZhaWxlZCB0
byBhY2NvdW50IGZvciB0aGUgY2FzZSBpbiBpbml0X2NhY2hlX21vZGVzKCkgd2hlbg0KPj4+
IENQVXMgZG8gc3VwcG9ydCBQQVQgYW5kIGZhbHNlbHkgcmVwb3J0ZWQgUEFUIHRvIGJlIGRp
c2FibGVkIHdoZW4gaW4NCj4+PiBmYWN0IFBBVCBpcyBlbmFibGVkLiBJbiBzb21lIGVudmly
b25tZW50cywgbm90YWJseSBpbiBYZW4gUFYgZG9tYWlucywNCj4+PiBNVFJSIGlzIGRpc2Fi
bGVkIGJ1dCBQQVQgaXMgc3RpbGwgZW5hYmxlZCwgYW5kIHRoYXQgaXMgdGhlIGNhc2UNCj4+
PiB0aGF0IHRoZSBhZm9yZW1lbnRpb25lZCBjb21taXQgZmFpbGVkIHRvIGFjY291bnQgZm9y
Lg0KPj4+DQo+Pj4gQXMgYW4gdW5mb3J0dW5hdGUgY29uc2VxdW5jZSwgdGhlIHBhdF9lbmFi
bGVkKCkgZnVuY3Rpb24gY3VycmVudGx5IGRvZXMNCj4+PiBub3QgY29ycmVjdGx5IHJlcG9y
dCB0aGF0IFBBVCBpcyBlbmFibGVkIGluIHN1Y2ggZW52aXJvbm1lbnRzLiBUaGUgZml4DQo+
Pj4gaXMgaW1wbGVtZW50ZWQgaW4gaW5pdF9jYWNoZV9tb2RlcygpIGJ5IHNldHRpbmcgcGF0
X2JwX2VuYWJsZWQgdG8gdHJ1ZQ0KPj4+IGluIGluaXRfY2FjaGVfbW9kZXMoKSBmb3IgdGhl
IGNhc2UgdGhhdCBjb21taXQgOTljMTNiOGM4ODk2ZDdiY2I5Mjc1M2JmDQo+Pj4gKCJ4ODYv
bW0vcGF0OiBEb24ndCByZXBvcnQgUEFUIG9uIENQVXMgdGhhdCBkb24ndCBzdXBwb3J0IGl0
IikgZmFpbGVkDQo+Pj4gdG8gYWNjb3VudCBmb3IuDQo+Pj4NCj4+PiBUaGlzIGFwcHJvYWNo
IGFycmFuZ2VzIGZvciBwYXRfZW5hYmxlZCgpIHRvIHJldHVybiB0cnVlIGluIHRoZSBYZW4g
UFYNCj4+PiBlbnZpcm9ubWVudCB3aXRob3V0IHVuZGVybWluaW5nIHRoZSByZXN0IG9mIFBB
VCBNU1IgbWFuYWdlbWVudCBsb2dpYw0KPj4+IHRoYXQgY29uc2lkZXJzIFBBVCB0byBiZSBk
aXNhYmxlZDogU3BlY2lmaWNhbGx5LCBubyB3cml0ZXMgdG8gdGhlIFBBVA0KPj4+IE1TUiBz
aG91bGQgb2NjdXIuDQo+Pj4NCj4+PiBUaGlzIHBhdGNoIGZpeGVzIGEgcmVncmVzc2lvbiB0
aGF0IHNvbWUgdXNlcnMgYXJlIGV4cGVyaWVuY2luZyB3aXRoDQo+Pj4gTGludXggYXMgYSBY
ZW4gRG9tMCBkcml2aW5nIHBhcnRpY3VsYXIgSW50ZWwgZ3JhcGhpY3MgZGV2aWNlcyBieQ0K
Pj4+IGNvcnJlY3RseSByZXBvcnRpbmcgdG8gdGhlIEludGVsIGk5MTUgZHJpdmVyIHRoYXQg
UEFUIGlzIGVuYWJsZWQgd2hlcmUNCj4+PiBwcmV2aW91c2x5IGl0IHdhcyBmYWxzZWx5IHJl
cG9ydGluZyB0aGF0IFBBVCBpcyBkaXNhYmxlZC4gU29tZSB1c2Vycw0KPj4+IGFyZSBleHBl
cmllbmNpbmcgc3lzdGVtIGhhbmdzIGluIFhlbiBQViBEb20wIGFuZCBhbGwgdXNlcnMgb24g
WGVuIFBWDQo+Pj4gRG9tMCBhcmUgZXhwZXJpZW5jaW5nIHJlZHVjZWQgZ3JhcGhpY3MgcGVy
Zm9ybWFuY2UgYmVjYXVzZSB0aGUga2V5aW5nIG9mDQo+Pj4gdGhlIHVzZSBvZiBXQyBtYXBw
aW5ncyB0byBwYXRfZW5hYmxlZCgpIChzZWUgYXJjaF9jYW5fcGNpX21tYXBfd2MoKSkNCj4+
PiBtZWFucyB0aGF0IGluIHBhcnRpY3VsYXIgZ3JhcGhpY3MgZnJhbWUgYnVmZmVyIGFjY2Vz
c2VzIGFyZSBxdWl0ZSBhIGJpdA0KPj4+IGxlc3MgcGVyZm9ybWFudCB0aGFuIHBvc3NpYmxl
IHdpdGhvdXQgdGhpcyBwYXRjaC4NCj4+Pg0KPj4+IEFsc28sIHdpdGggdGhlIGN1cnJlbnQg
Y29kZSwgaW4gdGhlIFhlbiBQViBlbnZpcm9ubWVudCwgUEFUIHdpbGwgbm90IGJlDQo+Pj4g
ZGlzYWJsZWQgaWYgdGhlIGFkbWluaXN0cmF0b3Igc2V0cyB0aGUgIm5vcGF0IiBib290IG9w
dGlvbi4gSW50cm9kdWNlDQo+Pj4gYSBuZXcgYm9vbGVhbiB2YXJpYWJsZSwgcGF0X2ZvcmNl
X2Rpc2FibGUsIHRvIGZvcmNpYmx5IGRpc2FibGUgUEFUDQo+Pj4gd2hlbiB0aGUgYWRtaW5p
c3RyYXRvciBzZXRzIHRoZSAibm9wYXQiIG9wdGlvbiB0byBvdmVycmlkZSB0aGUgZGVmYXVs
dA0KPj4+IGJlaGF2aW9yIG9mIHVzaW5nIHRoZSBQQVQgY29uZmlndXJhdGlvbiB0aGF0IFhl
biBoYXMgcHJvdmlkZWQuDQo+Pj4NCj4+PiBGb3IgdGhlIG5ldyBib29sZWFuIHRvIGxpdmUg
aW4gLmluaXQuZGF0YSwgaW5pdF9jYWNoZV9tb2RlcygpIGFsc28gbmVlZHMNCj4+PiBtb3Zp
bmcgdG8gLmluaXQudGV4dCAod2hlcmUgaXQgY291bGQvc2hvdWxkIGhhdmUgbGl2ZWQgYWxy
ZWFkeSBiZWZvcmUpLg0KPj4+DQo+Pj4gRml4ZXM6IDk5YzEzYjhjODg5NmQ3YmNiOTI3NTNi
ZiAoIng4Ni9tbS9wYXQ6IERvbid0IHJlcG9ydCBQQVQgb24gQ1BVcyB0aGF0IGRvbid0IHN1
cHBvcnQgaXQiKQ0KPj4+IENvLWRldmVsb3BlZC1ieTogSmFuIEJldWxpY2ggPGpiZXVsaWNo
QHN1c2UuY29tPg0KPj4+IENjOiBzdGFibGVAdmdlci5rZXJuZWwub3JnDQo+Pj4gU2lnbmVk
LW9mZi1ieTogQ2h1Y2sgWm11ZHppbnNraSA8YnJjaHVja3pAYW9sLmNvbT4NCj4+PiAtLS0N
Cj4+PiB2MjogKkFkZCBmb3JjZV9wYXRfZGlzYWJsZWQgdmFyaWFibGUgdG8gZml4ICJub3Bh
dCIgb24gWGVuIFBWIChKYW4gQmV1bGljaCkNCj4+PiAgICAgICAqQWRkIHRoZSBuZWNlc3Nh
cnkgY29kZSB0byBpbmNvcnBvcmF0ZSB0aGUgIm5vcGF0IiBmaXgNCj4+PiAgICAgICAqdm9p
ZCBpbml0X2NhY2hlX21vZGVzKHZvaWQpIC0+IHZvaWQgX19pbml0IGluaXRfY2FjaGVfbW9k
ZXModm9pZCkNCj4+PiAgICAgICAqQWRkIEphbiBCZXVsaWNoIGFzIENvLWRldmVsb3BlciAo
SmFuIGhhcyBub3Qgc2lnbmVkIG9mZiB5ZXQpDQo+Pj4gICAgICAgKkV4cGFuZCB0aGUgY29t
bWl0IG1lc3NhZ2UgdG8gaW5jbHVkZSByZWxldmFudCBwYXJ0cyBvZiB0aGUgY29tbWl0DQo+
Pj4gICAgICAgIG1lc3NhZ2Ugb2YgSmFuIEJldWxpY2gncyBwcm9wb3NlZCBwYXRjaCBmb3Ig
dGhpcyBwcm9ibGVtDQo+Pj4gICAgICAgKkZpeCAnZWxzZSBpZiAuLi4geycgcGxhY2VtZW50
IGFuZCBpbmRlbnRhdGlvbg0KPj4+ICAgICAgICpSZW1vdmUgaW5kaWNhdGlvbiB0aGUgYmFj
a3BvcnQgdG8gc3RhYmxlIGJyYW5jaGVzIGlzIG9ubHkgYmFjayB0byA1LjE3LnkNCj4+Pg0K
Pj4+IEkgdGhpbmsgdGhlc2UgY2hhbmdlcyBhZGRyZXNzIGFsbCB0aGUgY29tbWVudHMgb24g
dGhlIG9yaWdpbmFsIHBhdGNoDQo+Pj4NCj4+PiBJIGFkZGVkIEphbiBCZXVsaWNoIGFzIGEg
Q28tZGV2ZWxvcGVyIGJlY2F1c2UgSnVlcmdlbiBHcm9zcyBhc2tlZCBtZSB0bw0KPj4+IGlu
Y2x1ZGUgSmFuJ3MgaWRlYSBmb3IgZml4aW5nICJub3BhdCIgdGhhdCB3YXMgbWlzc2luZyBm
cm9tIHRoZSBmaXJzdA0KPj4+IHZlcnNpb24gb2YgdGhlIHBhdGNoLg0KPj4+DQo+Pj4gVGhl
IHBhdGNoIGhhcyBiZWVuIHRlc3RlZCwgaXQgd29ya3MgYXMgZXhwZWN0ZWQgd2l0aCBhbmQg
d2l0aG91dCBub3BhdA0KPj4+IGluIHRoZSBYZW4gUFYgRG9tMCBlbnZpcm9ubWVudC4gVGhh
dCBpcywgIm5vcGF0IiBjYXVzZXMgdGhlIHN5c3RlbSB0bw0KPj4+IGV4aGliaXQgdGhlIGVm
ZmVjdHMgYW5kIHByb2JsZW1zIHRoYXQgbGFjayBvZiBQQVQgc3VwcG9ydCBjYXVzZXMuDQo+
Pj4NCj4+PiAgICBhcmNoL3g4Ni9tbS9wYXQvbWVtdHlwZS5jIHwgMTYgKysrKysrKysrKysr
KystLQ0KPj4+ICAgIDEgZmlsZSBjaGFuZ2VkLCAxNCBpbnNlcnRpb25zKCspLCAyIGRlbGV0
aW9ucygtKQ0KPj4+DQo+Pj4gZGlmZiAtLWdpdCBhL2FyY2gveDg2L21tL3BhdC9tZW10eXBl
LmMgYi9hcmNoL3g4Ni9tbS9wYXQvbWVtdHlwZS5jDQo+Pj4gaW5kZXggZDVlZjY0ZGRkMzVl
Li4xMGEzN2QzMDlkMjMgMTAwNjQ0DQo+Pj4gLS0tIGEvYXJjaC94ODYvbW0vcGF0L21lbXR5
cGUuYw0KPj4+ICsrKyBiL2FyY2gveDg2L21tL3BhdC9tZW10eXBlLmMNCj4+PiBAQCAtNjIs
NiArNjIsNyBAQA0KPj4+ICAgIA0KPj4+ICAgIHN0YXRpYyBib29sIF9fcmVhZF9tb3N0bHkg
cGF0X2JwX2luaXRpYWxpemVkOw0KPj4+ICAgIHN0YXRpYyBib29sIF9fcmVhZF9tb3N0bHkg
cGF0X2Rpc2FibGVkID0gIUlTX0VOQUJMRUQoQ09ORklHX1g4Nl9QQVQpOw0KPj4+ICtzdGF0
aWMgYm9vbCBfX2luaXRkYXRhIHBhdF9mb3JjZV9kaXNhYmxlZCA9ICFJU19FTkFCTEVEKENP
TkZJR19YODZfUEFUKTsNCj4+PiAgICBzdGF0aWMgYm9vbCBfX3JlYWRfbW9zdGx5IHBhdF9i
cF9lbmFibGVkOw0KPj4+ICAgIHN0YXRpYyBib29sIF9fcmVhZF9tb3N0bHkgcGF0X2NtX2lu
aXRpYWxpemVkOw0KPj4+ICAgIA0KPj4+IEBAIC04Niw2ICs4Nyw3IEBAIHZvaWQgcGF0X2Rp
c2FibGUoY29uc3QgY2hhciAqbXNnX3JlYXNvbikNCj4+PiAgICBzdGF0aWMgaW50IF9faW5p
dCBub3BhdChjaGFyICpzdHIpDQo+Pj4gICAgew0KPj4+ICAgIAlwYXRfZGlzYWJsZSgiUEFU
IHN1cHBvcnQgZGlzYWJsZWQgdmlhIGJvb3Qgb3B0aW9uLiIpOw0KPj4+ICsJcGF0X2ZvcmNl
X2Rpc2FibGVkID0gdHJ1ZTsNCj4+PiAgICAJcmV0dXJuIDA7DQo+Pj4gICAgfQ0KPj4+ICAg
IGVhcmx5X3BhcmFtKCJub3BhdCIsIG5vcGF0KTsNCj4+PiBAQCAtMjcyLDcgKzI3NCw3IEBA
IHN0YXRpYyB2b2lkIHBhdF9hcF9pbml0KHU2NCBwYXQpDQo+Pj4gICAgCXdybXNybChNU1Jf
SUEzMl9DUl9QQVQsIHBhdCk7DQo+Pj4gICAgfQ0KPj4+ICAgIA0KPj4+IC12b2lkIGluaXRf
Y2FjaGVfbW9kZXModm9pZCkNCj4+PiArdm9pZCBfX2luaXQgaW5pdF9jYWNoZV9tb2Rlcyh2
b2lkKQ0KPj4+ICAgIHsNCj4+PiAgICAJdTY0IHBhdCA9IDA7DQo+Pj4gICAgDQo+Pj4gQEAg
LTI5Miw3ICsyOTQsNyBAQCB2b2lkIGluaXRfY2FjaGVfbW9kZXModm9pZCkNCj4+PiAgICAJ
CXJkbXNybChNU1JfSUEzMl9DUl9QQVQsIHBhdCk7DQo+Pj4gICAgCX0NCj4+PiAgICANCj4+
PiAtCWlmICghcGF0KSB7DQo+Pj4gKwlpZiAoIXBhdCB8fCBwYXRfZm9yY2VfZGlzYWJsZWQp
IHsNCj4+DQo+PiBDYW4gd2UganVzdCByZW1vdmUgdGhpcyBtb2RpZmljYXRpb24gYW5kIC4u
Lg0KPj4NCj4+PiAgICAJCS8qDQo+Pj4gICAgCQkgKiBObyBQQVQuIEVtdWxhdGUgdGhlIFBB
VCB0YWJsZSB0aGF0IGNvcnJlc3BvbmRzIHRvIHRoZSB0d28NCj4+PiAgICAJCSAqIGNhY2hl
IGJpdHMsIFBXVCAoV3JpdGUgVGhyb3VnaCkgYW5kIFBDRCAoQ2FjaGUgRGlzYWJsZSkuDQo+
Pj4gQEAgLTMxMyw2ICszMTUsMTYgQEAgdm9pZCBpbml0X2NhY2hlX21vZGVzKHZvaWQpDQo+
Pj4gICAgCQkgKi8NCj4+PiAgICAJCXBhdCA9IFBBVCgwLCBXQikgfCBQQVQoMSwgV1QpIHwg
UEFUKDIsIFVDX01JTlVTKSB8IFBBVCgzLCBVQykgfA0KPj4+ICAgIAkJICAgICAgUEFUKDQs
IFdCKSB8IFBBVCg1LCBXVCkgfCBQQVQoNiwgVUNfTUlOVVMpIHwgUEFUKDcsIFVDKTsNCj4+
PiArCX0gZWxzZSBpZiAoIXBhdF9icF9lbmFibGVkKSB7DQo+Pg0KPj4gLi4uIHVzZQ0KPj4N
Cj4+ICsJfSBlbHNlIGlmICghcGF0X2JwX2VuYWJsZWQgJiYgIXBhdF9mb3JjZV9kaXNhYmxl
ZCkgew0KPj4NCj4+IGhlcmU/DQo+Pg0KPj4gVGhpcyB3aWxsIHJlc3VsdCBpbiB0aGUgZGVz
aXJlZCBvdXRjb21lIGluIGFsbCBjYXNlcyBJTU86IElmIFBBVCB3YXNuJ3QNCj4+IGRpc2Fi
bGVkIHZpYSAibm9wYXQiIGFuZCB0aGUgUEFUIE1TUiBoYXMgYSBub24temVybyB2YWx1ZSAo
ZnJvbSBCSU9TIG9yDQo+PiBIeXBlcnZpc29yKSBhbmQgUEFUIGhhcyBiZWVuIGRpc2FibGVk
IGltcGxpY2l0bHkgKGUuZy4gZHVlIHRvIGxhY2sgb2YNCj4+IE1UUlIpLCB0aGVuIFBBVCB3
aWxsIGJlIHNldCB0byAiZW5hYmxlZCIgYWdhaW4uDQo+IA0KPiBXaXRoIHRoYXQsIHlvdSBj
YW4gYWxzbyBjb21wbGV0ZWx5IHJlbW92ZSB0aGUgbmV3IEJvb2xlYW4gLSBpdA0KPiB3aWxs
IGJlIGEgbWVhbmluZ2xlc3MgdmFyaWFibGUgd2FzdGluZyBtZW1vcnkuIFRoaXMgd2lsbCBh
bHNvIG1ha2UNCg0KTm8sIGl0IGlzIG1ha2luZyBhIGRpZmZlcmVuY2Ugd2l0aCAibm9wYXQi
IGhhdmluZyBiZWVuIHNwZWNpZmllZC4NCg0KSW4gdGhlIFhlbiBQViBjYXNlIHdlIHdpbGwg
aGF2ZSBwYXRfYnBfZW5hYmxlZCA9PSBmYWxzZSBkdWUgdG8gdGhlDQpsYWNrIG9mIE1UUlIu
IFdlIGRvbid0IHdhbnQgdG8gc2V0IGl0IHRvIHRydWUgaWYgIm5vcGF0IiBoYXMgYmVlbg0K
c3BlY2lmaWVkIG9uIHRoZSBjb21tYW5kIGxpbmUsIHNvIHBhdF9mb3JjZV9kaXNhYmxlZCBz
aG91bGQgbm90IGJlDQp0cnVlIHdoZW4gd2UgYXJlIHNldHRpbmcgcGF0X2JwX2VuYWJsZWQg
dG8gdHJ1ZSBhZ2Fpbi4NCg0KPiBteSBwYXRjaCBtb3JlIG9yIGxlc3MgZG8gd2hhdCBKYW4n
cyBwYXRjaCBkb2VzIC0gdGhlICJub3BhdCIgb3B0aW9uDQo+IHdpbGwgbm90IGNhdXNlIHRo
ZSBzaXR1YXRpb24gd2hlbiB0aGUgUEFUIE1TUiBkb2VzIG5vdCBtYXRjaCB0aGUNCj4gc29m
dHdhcmUgdmlldy4gU28geW91IGFyZSBiYXNpY2FsbHkgcHJvcG9zaW5nIGp1c3QgZ29pbmcg
YmFjayB0bw0KPiBteSBvcmlnaW5hbCBwYXRjaCwgYWZ0ZXIgZml4aW5nIHRoZSBzdHlsZSBw
cm9ibGVtcywgb2YgY291cnNlLiBUaGF0DQo+IGFsc28gd291bGQgc29sdmUgdGhlIHByb2Js
ZW0gb2YgbmVlZGluZyBKYW4ncyBTLW8tYi4gSSBhbSBpbmNsaW5lZCwNCj4gaG93ZXZlciwg
dG8gd2FpdCBmb3IgYSBtYWludGFpbmVyIHdobyBoYXMgcG93ZXIgdG8gYWN0dWFsbHkgZG8g
dGhlDQo+IGNvbW1pdCwgdG8gbWFrZSBhIGNvbW1lbnQuIFlvdXIgUi1iIHRvIG15IHYyIGRp
ZCBub3QgaGF2ZSBtdWNoIGNsb3V0DQo+IHdpdGggdGhlIGFjdHVhbCBtYWludGFpbmVycywg
YXMgZmFyIGFzIEkgY2FuIHRlbGwuIEkgYW0gc29tZXdoYXQgYW5ub3llZA0KPiB0aGF0IGl0
IHdhcyBhdCB5b3VyIHN1Z2dlc3Rpb24gdGhhdCBteSB2MiBlbmRlZCB1cCBjb25mdXNpbmcg
dGhlDQo+IG1haW4gaXNzdWUsIHRoZSByZWdyZXNzaW9uLCB3aXRoIHRoZSByZWQgaGVycmlu
ZyBvZiB0aGUgIm5vcGF0Ig0KPiBvcHRpb24uDQoNCkknbSBzb3JyeSBmb3IgdGhhdC4NCg0K
DQpKdWVyZ2VuDQo=
--------------uCPvqSlE4vvTlN2SPxRYkRDj
Content-Type: application/pgp-keys; name="OpenPGP_0xB0DE9DD628BF132F.asc"
Content-Disposition: attachment; filename="OpenPGP_0xB0DE9DD628BF132F.asc"
Content-Description: OpenPGP public key
Content-Transfer-Encoding: quoted-printable

-----BEGIN PGP PUBLIC KEY BLOCK-----

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
jR/i1DG86lem3iBDXzXsZDn8R38=3D
=3D2wuH
-----END PGP PUBLIC KEY BLOCK-----

--------------uCPvqSlE4vvTlN2SPxRYkRDj--

--------------bxKcZEHZlX70PgXzH2z1YL6d--

--------------EQ4qcO3BsuuirRREa53dJEtQ
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsB5BAABCAAjFiEEhRJncuj2BJSl0Jf3sN6d1ii/Ey8FAmLQ65wFAwAAAAAACgkQsN6d1ii/Ey9e
Qwf/UHgmea7UlSta7tPdTRjaaf0ASXWWmDzU2Qn4O93SjjaNQUcSmKYashsA7ApSoOLpl+hRblRG
9cmQCDsZ1tFgTsz9svEtKKVX4DMeWf+ToAtWmVt9nj54IpNCrFS8Fw7R+yUTmTqOE9tMk0mFP43i
4ofYa99WvCtMOLvbN8GY7YQK3VrlJ8MSWYz7CByyomp8tNyeELvVd/oIzVbZrJCO2FSm0Rr6kjsp
/IsPLGdomu2HPv+EsQG9J/JjNVB7ZTC/mvdUrfAwgpXqprjZgxCiSjOearn4TKWmEiAJQ1MkcCG0
mXG9XuLeVOcjV7JLQZcpLTxvw6g2cVImhFAZi3lflg==
=SqTB
-----END PGP SIGNATURE-----

--------------EQ4qcO3BsuuirRREa53dJEtQ--
