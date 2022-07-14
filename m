Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA4805744A1
	for <lists+stable@lfdr.de>; Thu, 14 Jul 2022 07:41:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234194AbiGNFlD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Jul 2022 01:41:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234088AbiGNFlC (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Jul 2022 01:41:02 -0400
X-Greylist: delayed 168861 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 13 Jul 2022 22:41:01 PDT
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01A4528E25;
        Wed, 13 Jul 2022 22:41:00 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id C40C020747;
        Thu, 14 Jul 2022 05:40:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1657777258; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=kAq092ltVUBWQNZDOKFuQWJGrOCULwke+LSsN6A0008=;
        b=BDxnnTYbDliTqNPAGxJQcmtxtJ91yE0YnzjLc9B4LPSp+yOaVw58c5xY0AwVhjk7TCSeZ/
        POtVRR5WxAT7yTr8kpZwb9Loh537jTwlylrnmDDpK0XUszumlrUqvMUwE9ckLOOK0VcEEI
        5dGBI2yYwoSww+tvYCNP7YVyp9dPy1M=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 162ED13322;
        Thu, 14 Jul 2022 05:40:58 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id /vQUBGqsz2IyGAAAMHmgww
        (envelope-from <jgross@suse.com>); Thu, 14 Jul 2022 05:40:58 +0000
Message-ID: <ec4b2791-886f-4d52-ab39-b0c07489c4ca@suse.com>
Date:   Thu, 14 Jul 2022 07:40:57 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Content-Language: en-US
To:     Chuck Zmudzinski <brchuckz@aol.com>, linux-kernel@vger.kernel.org
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
From:   Juergen Gross <jgross@suse.com>
Subject: Re: [PATCH v2] Subject: x86/PAT: Report PAT on CPUs that support PAT
 without MTRR
In-Reply-To: <9d5070ae4f3e956a95d3f50e24f1a93488b9ff52.1657671676.git.brchuckz@aol.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------p9W413CsZm9DGQsW6OKQfOn1"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------p9W413CsZm9DGQsW6OKQfOn1
Content-Type: multipart/mixed; boundary="------------qMuRanS00Ra20EBwdeSS8owL";
 protected-headers="v1"
From: Juergen Gross <jgross@suse.com>
To: Chuck Zmudzinski <brchuckz@aol.com>, linux-kernel@vger.kernel.org
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
Message-ID: <ec4b2791-886f-4d52-ab39-b0c07489c4ca@suse.com>
Subject: Re: [PATCH v2] Subject: x86/PAT: Report PAT on CPUs that support PAT
 without MTRR
References: <9d5070ae4f3e956a95d3f50e24f1a93488b9ff52.1657671676.git.brchuckz.ref@aol.com>
 <9d5070ae4f3e956a95d3f50e24f1a93488b9ff52.1657671676.git.brchuckz@aol.com>
In-Reply-To: <9d5070ae4f3e956a95d3f50e24f1a93488b9ff52.1657671676.git.brchuckz@aol.com>

--------------qMuRanS00Ra20EBwdeSS8owL
Content-Type: multipart/mixed; boundary="------------b1Xo8o7Ir2db0LhahKG1l0Lz"

--------------b1Xo8o7Ir2db0LhahKG1l0Lz
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gMTMuMDcuMjIgMDM6MzYsIENodWNrIFptdWR6aW5za2kgd3JvdGU6DQo+IFRoZSBjb21t
aXQgOTljMTNiOGM4ODk2ZDdiY2I5Mjc1M2JmDQo+ICgieDg2L21tL3BhdDogRG9uJ3QgcmVw
b3J0IFBBVCBvbiBDUFVzIHRoYXQgZG9uJ3Qgc3VwcG9ydCBpdCIpDQo+IGluY29ycmVjdGx5
IGZhaWxlZCB0byBhY2NvdW50IGZvciB0aGUgY2FzZSBpbiBpbml0X2NhY2hlX21vZGVzKCkg
d2hlbg0KPiBDUFVzIGRvIHN1cHBvcnQgUEFUIGFuZCBmYWxzZWx5IHJlcG9ydGVkIFBBVCB0
byBiZSBkaXNhYmxlZCB3aGVuIGluDQo+IGZhY3QgUEFUIGlzIGVuYWJsZWQuIEluIHNvbWUg
ZW52aXJvbm1lbnRzLCBub3RhYmx5IGluIFhlbiBQViBkb21haW5zLA0KPiBNVFJSIGlzIGRp
c2FibGVkIGJ1dCBQQVQgaXMgc3RpbGwgZW5hYmxlZCwgYW5kIHRoYXQgaXMgdGhlIGNhc2UN
Cj4gdGhhdCB0aGUgYWZvcmVtZW50aW9uZWQgY29tbWl0IGZhaWxlZCB0byBhY2NvdW50IGZv
ci4NCj4gDQo+IEFzIGFuIHVuZm9ydHVuYXRlIGNvbnNlcXVuY2UsIHRoZSBwYXRfZW5hYmxl
ZCgpIGZ1bmN0aW9uIGN1cnJlbnRseSBkb2VzDQo+IG5vdCBjb3JyZWN0bHkgcmVwb3J0IHRo
YXQgUEFUIGlzIGVuYWJsZWQgaW4gc3VjaCBlbnZpcm9ubWVudHMuIFRoZSBmaXgNCj4gaXMg
aW1wbGVtZW50ZWQgaW4gaW5pdF9jYWNoZV9tb2RlcygpIGJ5IHNldHRpbmcgcGF0X2JwX2Vu
YWJsZWQgdG8gdHJ1ZQ0KPiBpbiBpbml0X2NhY2hlX21vZGVzKCkgZm9yIHRoZSBjYXNlIHRo
YXQgY29tbWl0IDk5YzEzYjhjODg5NmQ3YmNiOTI3NTNiZg0KPiAoIng4Ni9tbS9wYXQ6IERv
bid0IHJlcG9ydCBQQVQgb24gQ1BVcyB0aGF0IGRvbid0IHN1cHBvcnQgaXQiKSBmYWlsZWQN
Cj4gdG8gYWNjb3VudCBmb3IuDQo+IA0KPiBUaGlzIGFwcHJvYWNoIGFycmFuZ2VzIGZvciBw
YXRfZW5hYmxlZCgpIHRvIHJldHVybiB0cnVlIGluIHRoZSBYZW4gUFYNCj4gZW52aXJvbm1l
bnQgd2l0aG91dCB1bmRlcm1pbmluZyB0aGUgcmVzdCBvZiBQQVQgTVNSIG1hbmFnZW1lbnQg
bG9naWMNCj4gdGhhdCBjb25zaWRlcnMgUEFUIHRvIGJlIGRpc2FibGVkOiBTcGVjaWZpY2Fs
bHksIG5vIHdyaXRlcyB0byB0aGUgUEFUDQo+IE1TUiBzaG91bGQgb2NjdXIuDQo+IA0KPiBU
aGlzIHBhdGNoIGZpeGVzIGEgcmVncmVzc2lvbiB0aGF0IHNvbWUgdXNlcnMgYXJlIGV4cGVy
aWVuY2luZyB3aXRoDQo+IExpbnV4IGFzIGEgWGVuIERvbTAgZHJpdmluZyBwYXJ0aWN1bGFy
IEludGVsIGdyYXBoaWNzIGRldmljZXMgYnkNCj4gY29ycmVjdGx5IHJlcG9ydGluZyB0byB0
aGUgSW50ZWwgaTkxNSBkcml2ZXIgdGhhdCBQQVQgaXMgZW5hYmxlZCB3aGVyZQ0KPiBwcmV2
aW91c2x5IGl0IHdhcyBmYWxzZWx5IHJlcG9ydGluZyB0aGF0IFBBVCBpcyBkaXNhYmxlZC4g
U29tZSB1c2Vycw0KPiBhcmUgZXhwZXJpZW5jaW5nIHN5c3RlbSBoYW5ncyBpbiBYZW4gUFYg
RG9tMCBhbmQgYWxsIHVzZXJzIG9uIFhlbiBQVg0KPiBEb20wIGFyZSBleHBlcmllbmNpbmcg
cmVkdWNlZCBncmFwaGljcyBwZXJmb3JtYW5jZSBiZWNhdXNlIHRoZSBrZXlpbmcgb2YNCj4g
dGhlIHVzZSBvZiBXQyBtYXBwaW5ncyB0byBwYXRfZW5hYmxlZCgpIChzZWUgYXJjaF9jYW5f
cGNpX21tYXBfd2MoKSkNCj4gbWVhbnMgdGhhdCBpbiBwYXJ0aWN1bGFyIGdyYXBoaWNzIGZy
YW1lIGJ1ZmZlciBhY2Nlc3NlcyBhcmUgcXVpdGUgYSBiaXQNCj4gbGVzcyBwZXJmb3JtYW50
IHRoYW4gcG9zc2libGUgd2l0aG91dCB0aGlzIHBhdGNoLg0KPiANCj4gQWxzbywgd2l0aCB0
aGUgY3VycmVudCBjb2RlLCBpbiB0aGUgWGVuIFBWIGVudmlyb25tZW50LCBQQVQgd2lsbCBu
b3QgYmUNCj4gZGlzYWJsZWQgaWYgdGhlIGFkbWluaXN0cmF0b3Igc2V0cyB0aGUgIm5vcGF0
IiBib290IG9wdGlvbi4gSW50cm9kdWNlDQo+IGEgbmV3IGJvb2xlYW4gdmFyaWFibGUsIHBh
dF9mb3JjZV9kaXNhYmxlLCB0byBmb3JjaWJseSBkaXNhYmxlIFBBVA0KPiB3aGVuIHRoZSBh
ZG1pbmlzdHJhdG9yIHNldHMgdGhlICJub3BhdCIgb3B0aW9uIHRvIG92ZXJyaWRlIHRoZSBk
ZWZhdWx0DQo+IGJlaGF2aW9yIG9mIHVzaW5nIHRoZSBQQVQgY29uZmlndXJhdGlvbiB0aGF0
IFhlbiBoYXMgcHJvdmlkZWQuDQo+IA0KPiBGb3IgdGhlIG5ldyBib29sZWFuIHRvIGxpdmUg
aW4gLmluaXQuZGF0YSwgaW5pdF9jYWNoZV9tb2RlcygpIGFsc28gbmVlZHMNCj4gbW92aW5n
IHRvIC5pbml0LnRleHQgKHdoZXJlIGl0IGNvdWxkL3Nob3VsZCBoYXZlIGxpdmVkIGFscmVh
ZHkgYmVmb3JlKS4NCj4gDQo+IEZpeGVzOiA5OWMxM2I4Yzg4OTZkN2JjYjkyNzUzYmYgKCJ4
ODYvbW0vcGF0OiBEb24ndCByZXBvcnQgUEFUIG9uIENQVXMgdGhhdCBkb24ndCBzdXBwb3J0
IGl0IikNCj4gQ28tZGV2ZWxvcGVkLWJ5OiBKYW4gQmV1bGljaCA8amJldWxpY2hAc3VzZS5j
b20+DQo+IENjOiBzdGFibGVAdmdlci5rZXJuZWwub3JnDQo+IFNpZ25lZC1vZmYtYnk6IENo
dWNrIFptdWR6aW5za2kgPGJyY2h1Y2t6QGFvbC5jb20+DQo+IC0tLQ0KPiB2MjogKkFkZCBm
b3JjZV9wYXRfZGlzYWJsZWQgdmFyaWFibGUgdG8gZml4ICJub3BhdCIgb24gWGVuIFBWIChK
YW4gQmV1bGljaCkNCj4gICAgICAqQWRkIHRoZSBuZWNlc3NhcnkgY29kZSB0byBpbmNvcnBv
cmF0ZSB0aGUgIm5vcGF0IiBmaXgNCj4gICAgICAqdm9pZCBpbml0X2NhY2hlX21vZGVzKHZv
aWQpIC0+IHZvaWQgX19pbml0IGluaXRfY2FjaGVfbW9kZXModm9pZCkNCj4gICAgICAqQWRk
IEphbiBCZXVsaWNoIGFzIENvLWRldmVsb3BlciAoSmFuIGhhcyBub3Qgc2lnbmVkIG9mZiB5
ZXQpDQo+ICAgICAgKkV4cGFuZCB0aGUgY29tbWl0IG1lc3NhZ2UgdG8gaW5jbHVkZSByZWxl
dmFudCBwYXJ0cyBvZiB0aGUgY29tbWl0DQo+ICAgICAgIG1lc3NhZ2Ugb2YgSmFuIEJldWxp
Y2gncyBwcm9wb3NlZCBwYXRjaCBmb3IgdGhpcyBwcm9ibGVtDQo+ICAgICAgKkZpeCAnZWxz
ZSBpZiAuLi4geycgcGxhY2VtZW50IGFuZCBpbmRlbnRhdGlvbg0KPiAgICAgICpSZW1vdmUg
aW5kaWNhdGlvbiB0aGUgYmFja3BvcnQgdG8gc3RhYmxlIGJyYW5jaGVzIGlzIG9ubHkgYmFj
ayB0byA1LjE3LnkNCj4gDQo+IEkgdGhpbmsgdGhlc2UgY2hhbmdlcyBhZGRyZXNzIGFsbCB0
aGUgY29tbWVudHMgb24gdGhlIG9yaWdpbmFsIHBhdGNoDQo+IA0KPiBJIGFkZGVkIEphbiBC
ZXVsaWNoIGFzIGEgQ28tZGV2ZWxvcGVyIGJlY2F1c2UgSnVlcmdlbiBHcm9zcyBhc2tlZCBt
ZSB0bw0KPiBpbmNsdWRlIEphbidzIGlkZWEgZm9yIGZpeGluZyAibm9wYXQiIHRoYXQgd2Fz
IG1pc3NpbmcgZnJvbSB0aGUgZmlyc3QNCj4gdmVyc2lvbiBvZiB0aGUgcGF0Y2guDQo+IA0K
PiBUaGUgcGF0Y2ggaGFzIGJlZW4gdGVzdGVkLCBpdCB3b3JrcyBhcyBleHBlY3RlZCB3aXRo
IGFuZCB3aXRob3V0IG5vcGF0DQo+IGluIHRoZSBYZW4gUFYgRG9tMCBlbnZpcm9ubWVudC4g
VGhhdCBpcywgIm5vcGF0IiBjYXVzZXMgdGhlIHN5c3RlbSB0bw0KPiBleGhpYml0IHRoZSBl
ZmZlY3RzIGFuZCBwcm9ibGVtcyB0aGF0IGxhY2sgb2YgUEFUIHN1cHBvcnQgY2F1c2VzLg0K
PiANCj4gICBhcmNoL3g4Ni9tbS9wYXQvbWVtdHlwZS5jIHwgMTYgKysrKysrKysrKysrKyst
LQ0KPiAgIDEgZmlsZSBjaGFuZ2VkLCAxNCBpbnNlcnRpb25zKCspLCAyIGRlbGV0aW9ucygt
KQ0KPiANCj4gZGlmZiAtLWdpdCBhL2FyY2gveDg2L21tL3BhdC9tZW10eXBlLmMgYi9hcmNo
L3g4Ni9tbS9wYXQvbWVtdHlwZS5jDQo+IGluZGV4IGQ1ZWY2NGRkZDM1ZS4uMTBhMzdkMzA5
ZDIzIDEwMDY0NA0KPiAtLS0gYS9hcmNoL3g4Ni9tbS9wYXQvbWVtdHlwZS5jDQo+ICsrKyBi
L2FyY2gveDg2L21tL3BhdC9tZW10eXBlLmMNCj4gQEAgLTYyLDYgKzYyLDcgQEANCj4gICAN
Cj4gICBzdGF0aWMgYm9vbCBfX3JlYWRfbW9zdGx5IHBhdF9icF9pbml0aWFsaXplZDsNCj4g
ICBzdGF0aWMgYm9vbCBfX3JlYWRfbW9zdGx5IHBhdF9kaXNhYmxlZCA9ICFJU19FTkFCTEVE
KENPTkZJR19YODZfUEFUKTsNCj4gK3N0YXRpYyBib29sIF9faW5pdGRhdGEgcGF0X2ZvcmNl
X2Rpc2FibGVkID0gIUlTX0VOQUJMRUQoQ09ORklHX1g4Nl9QQVQpOw0KPiAgIHN0YXRpYyBi
b29sIF9fcmVhZF9tb3N0bHkgcGF0X2JwX2VuYWJsZWQ7DQo+ICAgc3RhdGljIGJvb2wgX19y
ZWFkX21vc3RseSBwYXRfY21faW5pdGlhbGl6ZWQ7DQo+ICAgDQo+IEBAIC04Niw2ICs4Nyw3
IEBAIHZvaWQgcGF0X2Rpc2FibGUoY29uc3QgY2hhciAqbXNnX3JlYXNvbikNCj4gICBzdGF0
aWMgaW50IF9faW5pdCBub3BhdChjaGFyICpzdHIpDQo+ICAgew0KPiAgIAlwYXRfZGlzYWJs
ZSgiUEFUIHN1cHBvcnQgZGlzYWJsZWQgdmlhIGJvb3Qgb3B0aW9uLiIpOw0KPiArCXBhdF9m
b3JjZV9kaXNhYmxlZCA9IHRydWU7DQo+ICAgCXJldHVybiAwOw0KPiAgIH0NCj4gICBlYXJs
eV9wYXJhbSgibm9wYXQiLCBub3BhdCk7DQo+IEBAIC0yNzIsNyArMjc0LDcgQEAgc3RhdGlj
IHZvaWQgcGF0X2FwX2luaXQodTY0IHBhdCkNCj4gICAJd3Jtc3JsKE1TUl9JQTMyX0NSX1BB
VCwgcGF0KTsNCj4gICB9DQo+ICAgDQo+IC12b2lkIGluaXRfY2FjaGVfbW9kZXModm9pZCkN
Cj4gK3ZvaWQgX19pbml0IGluaXRfY2FjaGVfbW9kZXModm9pZCkNCj4gICB7DQo+ICAgCXU2
NCBwYXQgPSAwOw0KPiAgIA0KPiBAQCAtMjkyLDcgKzI5NCw3IEBAIHZvaWQgaW5pdF9jYWNo
ZV9tb2Rlcyh2b2lkKQ0KPiAgIAkJcmRtc3JsKE1TUl9JQTMyX0NSX1BBVCwgcGF0KTsNCj4g
ICAJfQ0KPiAgIA0KPiAtCWlmICghcGF0KSB7DQo+ICsJaWYgKCFwYXQgfHwgcGF0X2ZvcmNl
X2Rpc2FibGVkKSB7DQoNCkNhbiB3ZSBqdXN0IHJlbW92ZSB0aGlzIG1vZGlmaWNhdGlvbiBh
bmQgLi4uDQoNCj4gICAJCS8qDQo+ICAgCQkgKiBObyBQQVQuIEVtdWxhdGUgdGhlIFBBVCB0
YWJsZSB0aGF0IGNvcnJlc3BvbmRzIHRvIHRoZSB0d28NCj4gICAJCSAqIGNhY2hlIGJpdHMs
IFBXVCAoV3JpdGUgVGhyb3VnaCkgYW5kIFBDRCAoQ2FjaGUgRGlzYWJsZSkuDQo+IEBAIC0z
MTMsNiArMzE1LDE2IEBAIHZvaWQgaW5pdF9jYWNoZV9tb2Rlcyh2b2lkKQ0KPiAgIAkJICov
DQo+ICAgCQlwYXQgPSBQQVQoMCwgV0IpIHwgUEFUKDEsIFdUKSB8IFBBVCgyLCBVQ19NSU5V
UykgfCBQQVQoMywgVUMpIHwNCj4gICAJCSAgICAgIFBBVCg0LCBXQikgfCBQQVQoNSwgV1Qp
IHwgUEFUKDYsIFVDX01JTlVTKSB8IFBBVCg3LCBVQyk7DQo+ICsJfSBlbHNlIGlmICghcGF0
X2JwX2VuYWJsZWQpIHsNCg0KLi4uIHVzZQ0KDQorCX0gZWxzZSBpZiAoIXBhdF9icF9lbmFi
bGVkICYmICFwYXRfZm9yY2VfZGlzYWJsZWQpIHsNCg0KaGVyZT8NCg0KVGhpcyB3aWxsIHJl
c3VsdCBpbiB0aGUgZGVzaXJlZCBvdXRjb21lIGluIGFsbCBjYXNlcyBJTU86IElmIFBBVCB3
YXNuJ3QNCmRpc2FibGVkIHZpYSAibm9wYXQiIGFuZCB0aGUgUEFUIE1TUiBoYXMgYSBub24t
emVybyB2YWx1ZSAoZnJvbSBCSU9TIG9yDQpIeXBlcnZpc29yKSBhbmQgUEFUIGhhcyBiZWVu
IGRpc2FibGVkIGltcGxpY2l0bHkgKGUuZy4gZHVlIHRvIGxhY2sgb2YNCk1UUlIpLCB0aGVu
IFBBVCB3aWxsIGJlIHNldCB0byAiZW5hYmxlZCIgYWdhaW4uDQoNCj4gKwkJLyoNCj4gKwkJ
ICogSW4gc29tZSBlbnZpcm9ubWVudHMsIHNwZWNpZmljYWxseSBYZW4gUFYsIFBBVA0KPiAr
CQkgKiBpbml0aWFsaXphdGlvbiBpcyBza2lwcGVkIGJlY2F1c2UgTVRSUnMgYXJlIGRpc2Fi
bGVkIGV2ZW4NCj4gKwkJICogdGhvdWdoIFBBVCBpcyBhdmFpbGFibGUuIEluIHN1Y2ggZW52
aXJvbm1lbnRzLCBzZXQgUEFUIHRvDQo+ICsJCSAqIGVuYWJsZWQgdG8gY29ycmVjdGx5IGlu
ZGljYXRlIHRvIGNhbGxlcnMgb2YgcGF0X2VuYWJsZWQoKQ0KPiArCQkgKiB0aGF0IENQVSBz
dXBwb3J0IGZvciBQQVQgaXMgYXZhaWxhYmxlLg0KPiArCQkgKi8NCj4gKwkJcGF0X2JwX2Vu
YWJsZWQgPSB0cnVlOw0KPiArCQlwcl9pbmZvKCJ4ODYvUEFUOiBQQVQgZW5hYmxlZCBieSBp
bml0X2NhY2hlX21vZGVzXG4iKTsNCj4gICAJfQ0KPiAgIA0KPiAgIAlfX2luaXRfY2FjaGVf
bW9kZXMocGF0KTsNCg0KDQpKdWVyZ2VuDQo=
--------------b1Xo8o7Ir2db0LhahKG1l0Lz
Content-Type: application/pgp-keys; name="OpenPGP_0xB0DE9DD628BF132F.asc"
Content-Disposition: attachment; filename="OpenPGP_0xB0DE9DD628BF132F.asc"
Content-Description: OpenPGP public key
Content-Transfer-Encoding: quoted-printable

-----BEGIN PGP PUBLIC KEY BLOCK-----

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
jR/i1DG86lem3iBDXzXsZDn8R38=3D
=3D2wuH
-----END PGP PUBLIC KEY BLOCK-----

--------------b1Xo8o7Ir2db0LhahKG1l0Lz--

--------------qMuRanS00Ra20EBwdeSS8owL--

--------------p9W413CsZm9DGQsW6OKQfOn1
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsB5BAABCAAjFiEEhRJncuj2BJSl0Jf3sN6d1ii/Ey8FAmLPrGkFAwAAAAAACgkQsN6d1ii/Ey8r
DAf/b61zHAl4g35QZy+u4+OHCls9BYx8Z5X9jhGw36lCViIhFKGxeCZrnO2Q2RTIKpYWXbi1IHqa
PHZgz56Y1js1/NTD3rnXCR5kmUMpjyCEsiFNMnz9oUgRsL+IhhL62iYlBzeb5KBk/bWCapBfgb3F
doIgbnBmnAjwU/UzDgHcddpRLaOq3InqeqoQzYPAyu02uJiJC0uL2muEU7ZEMatAt3fSfbYBiPgJ
BmWwjFb5jPP9aELJ3zzbWo7CJU4cEpF6/eWj3cmSuK8sRvzFkzgS22WOGmrJVOZoj+/bAFS1QVlW
TetCZVIRGKrru1QUJMHUpAryatfaDwxJi7ceFuptXg==
=tp+D
-----END PGP SIGNATURE-----

--------------p9W413CsZm9DGQsW6OKQfOn1--
