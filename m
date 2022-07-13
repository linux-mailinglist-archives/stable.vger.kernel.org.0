Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C35B572C31
	for <lists+stable@lfdr.de>; Wed, 13 Jul 2022 06:12:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230003AbiGMEMH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Jul 2022 00:12:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229568AbiGMEMG (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 Jul 2022 00:12:06 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F09BCD9160;
        Tue, 12 Jul 2022 21:12:04 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 0E0D0339CE;
        Wed, 13 Jul 2022 04:12:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1657685523; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=iyWYPbpylJGOKlEX5X9yWX8NaU7kqmnI8rc17bkFUxQ=;
        b=dGBUErlfIX6CEf2AWtf4SMC+NFpFjAmjKJOXZMzHOjH5z88QDh/BHZNz4FHtRbwSNbhgYW
        pSXMBGqsF2p2Q4O4ZS+LSMlZTchfpA6XowxRcQDsBwn/NZ7GtDHe/tjJpf9RN1Jyt/DMAg
        e8DFymeAA6saMkJPN8zaAmhHm+sZCus=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 5C15C13754;
        Wed, 13 Jul 2022 04:12:02 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id BTVgFBJGzmIrXQAAMHmgww
        (envelope-from <jgross@suse.com>); Wed, 13 Jul 2022 04:12:02 +0000
Message-ID: <b0724b11-f384-3d68-09b4-9c83c7470510@suse.com>
Date:   Wed, 13 Jul 2022 06:12:01 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH v2] Subject: x86/PAT: Report PAT on CPUs that support PAT
 without MTRR
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
In-Reply-To: <9d5070ae4f3e956a95d3f50e24f1a93488b9ff52.1657671676.git.brchuckz@aol.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------YY2eSglKxMQZzJilSEwbwsWi"
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
--------------YY2eSglKxMQZzJilSEwbwsWi
Content-Type: multipart/mixed; boundary="------------JJ0idYU9PXoqFAqKQe0kItgC";
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
Message-ID: <b0724b11-f384-3d68-09b4-9c83c7470510@suse.com>
Subject: Re: [PATCH v2] Subject: x86/PAT: Report PAT on CPUs that support PAT
 without MTRR
References: <9d5070ae4f3e956a95d3f50e24f1a93488b9ff52.1657671676.git.brchuckz.ref@aol.com>
 <9d5070ae4f3e956a95d3f50e24f1a93488b9ff52.1657671676.git.brchuckz@aol.com>
In-Reply-To: <9d5070ae4f3e956a95d3f50e24f1a93488b9ff52.1657671676.git.brchuckz@aol.com>

--------------JJ0idYU9PXoqFAqKQe0kItgC
Content-Type: multipart/mixed; boundary="------------6i4tEvXDX4ICZGgoY5V4imS5"

--------------6i4tEvXDX4ICZGgoY5V4imS5
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
dWNrIFptdWR6aW5za2kgPGJyY2h1Y2t6QGFvbC5jb20+DQoNClJldmlld2VkLWJ5OiBKdWVy
Z2VuIEdyb3NzIDxqZ3Jvc3NAc3VzZS5jb20+DQoNCg0KSnVlcmdlbg0K
--------------6i4tEvXDX4ICZGgoY5V4imS5
Content-Type: application/pgp-keys; name="OpenPGP_0xB0DE9DD628BF132F.asc"
Content-Disposition: attachment; filename="OpenPGP_0xB0DE9DD628BF132F.asc"
Content-Description: OpenPGP public key
Content-Transfer-Encoding: quoted-printable

-----BEGIN PGP PUBLIC KEY BLOCK-----

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
jR/i1DG86lem3iBDXzXsZDn8R38=3D
=3D2wuH
-----END PGP PUBLIC KEY BLOCK-----

--------------6i4tEvXDX4ICZGgoY5V4imS5--

--------------JJ0idYU9PXoqFAqKQe0kItgC--

--------------YY2eSglKxMQZzJilSEwbwsWi
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsB5BAABCAAjFiEEhRJncuj2BJSl0Jf3sN6d1ii/Ey8FAmLORhEFAwAAAAAACgkQsN6d1ii/Ey/h
rQf/S/Ui31Ud7GWGhjh1Kl1P60FaXqDpFMwbIYzJzsav9ireUo5hKaBrou4tPdxCoBlYEklo5Lr7
A2ATEigiDJkyovq/1XEtmle3qKF9G5DDZH25x1r56OgzQYpkGVqRqQZgoEh1AXsBygNj1psuakIY
/EbL5sD2EAMVeK9IBePjSOD/Q5FZNkxvQR+bEcA68ia7pOOT9VqSPAL2DlbRvraSXSTz/dgxEbYl
yu1W3j0e6fiA7CDdL+aJX1RRRwCrRB/h87tTpAONS025Si8mtGT2xq4sPqfP6KcWoqmmS3+d+66g
Ji0eBV8EgJmZ8V+MAzb3T0jIinO2r95AnwPSsl1JwQ==
=cxEJ
-----END PGP SIGNATURE-----

--------------YY2eSglKxMQZzJilSEwbwsWi--
