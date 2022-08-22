Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30CF659BBB4
	for <lists+stable@lfdr.de>; Mon, 22 Aug 2022 10:33:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233080AbiHVIcc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Aug 2022 04:32:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233654AbiHVIcb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Aug 2022 04:32:31 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C76561CFFB;
        Mon, 22 Aug 2022 01:32:30 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 6C03934037;
        Mon, 22 Aug 2022 08:32:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1661157149; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=YBMHlxVmRfLJjdcsb9JN2XfRkOc0r2io3/c8PMrp5Zg=;
        b=icJfnhFkDLsHocZk0v+61JzDhs9YtDK9r/QFfn0l5WsTz3uwZAThEcJAyrMe7szDxbwzs0
        pLqOIh3CC46WUnTEjvZT8GG7njXN6FGyUSbxPwc3twKBNym10lIE6cFqiP/gw21VL72t4H
        3FmcZO2SU8CI87FbwEcg9LbX9d6Ok68=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 14EFA1332D;
        Mon, 22 Aug 2022 08:32:29 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id Z4gxAx0/A2OYWQAAMHmgww
        (envelope-from <jgross@suse.com>); Mon, 22 Aug 2022 08:32:29 +0000
Message-ID: <e2ea61ad-3ff3-2ba7-3426-834b87fe85a3@suse.com>
Date:   Mon, 22 Aug 2022 10:32:28 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH v2 01/10] x86/mtrr: fix MTRR fixup on APs
Content-Language: en-US
To:     Borislav Petkov <bp@alien8.de>
Cc:     xen-devel@lists.xenproject.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, stable@vger.kernel.org
References: <20220820092533.29420-1-jgross@suse.com>
 <20220820092533.29420-2-jgross@suse.com> <YwIkV7mYAC4Ebbwb@zn.tnic>
 <YwKmcFuKlq3/MzVi@zn.tnic> <f205da1c-db33-299c-5fc6-922a8ebd1983@suse.com>
 <YwM+GPu8hFowl2R7@zn.tnic>
From:   Juergen Gross <jgross@suse.com>
In-Reply-To: <YwM+GPu8hFowl2R7@zn.tnic>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------TqzcXoH02scFtcsznY39KkrM"
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
--------------TqzcXoH02scFtcsznY39KkrM
Content-Type: multipart/mixed; boundary="------------0VUZCoAFrKER0Qjvl6TZZK0W";
 protected-headers="v1"
From: Juergen Gross <jgross@suse.com>
To: Borislav Petkov <bp@alien8.de>
Cc: xen-devel@lists.xenproject.org, x86@kernel.org,
 linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
 Ingo Molnar <mingo@redhat.com>, Dave Hansen <dave.hansen@linux.intel.com>,
 "H. Peter Anvin" <hpa@zytor.com>, stable@vger.kernel.org
Message-ID: <e2ea61ad-3ff3-2ba7-3426-834b87fe85a3@suse.com>
Subject: Re: [PATCH v2 01/10] x86/mtrr: fix MTRR fixup on APs
References: <20220820092533.29420-1-jgross@suse.com>
 <20220820092533.29420-2-jgross@suse.com> <YwIkV7mYAC4Ebbwb@zn.tnic>
 <YwKmcFuKlq3/MzVi@zn.tnic> <f205da1c-db33-299c-5fc6-922a8ebd1983@suse.com>
 <YwM+GPu8hFowl2R7@zn.tnic>
In-Reply-To: <YwM+GPu8hFowl2R7@zn.tnic>

--------------0VUZCoAFrKER0Qjvl6TZZK0W
Content-Type: multipart/mixed; boundary="------------Z9SNFeC13wkqDPMRx3a68VCc"

--------------Z9SNFeC13wkqDPMRx3a68VCc
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gMjIuMDguMjIgMTA6MjgsIEJvcmlzbGF2IFBldGtvdiB3cm90ZToNCj4gT24gTW9uLCBB
dWcgMjIsIDIwMjIgYXQgMDc6MTc6NDBBTSArMDIwMCwgSnVlcmdlbiBHcm9zcyB3cm90ZToN
Cj4+IEFuZCB0aGVuIHRoZXJlIGlzIG10cnJfc3RhdGVfd2FybigpIGluIGFyY2gveDg2L2tl
cm5lbC9jcHUvbXRyci9nZW5lcmljLmMNCj4+IHdoaWNoIGhhcyBhIGNvbW1lbnQgc2F5aW5n
Og0KPj4NCj4+IC8qIFNvbWUgQklPUydzIGFyZSBtZXNzZWQgdXAgYW5kIGRvbid0IHNldCBh
bGwgTVRSUnMgdGhlIHNhbWUhICovDQo+IA0KPiBUaGF0IHRoaW5nIGFsc28gc2F5czoNCj4g
DQo+ICAgICAgICAgIHByX2luZm8oIm10cnI6IHByb2JhYmx5IHlvdXIgQklPUyBkb2VzIG5v
dCBzZXR1cCBhbGwgQ1BVcy5cbiIpOw0KPiAgICAgICAgICBwcl9pbmZvKCJtdHJyOiBjb3Jy
ZWN0ZWQgY29uZmlndXJhdGlvbi5cbiIpOw0KPiANCj4gYmVjYXVzZSBpdCdsbCBnbyBhbmQg
Zm9yY2Ugb24gYWxsIENQVXMgdGhlIE1UUlIgc3RhdGUgaXQgcmVhZCBmcm9tIHRoZQ0KPiBC
U1AgaW4gbXRycl9icF9pbml0LT5nZXRfbXRycl9zdGF0ZS4NCj4gDQo+PiBZZXMsIHRoZSBj
aGFuY2VzIGFyZSBzbGltIHRvIGhpdCBzdWNoIGEgYm94LA0KPiANCj4gV2VsbCwgbXkgd29y
a3N0YXRpb24gc2F5czoNCj4gDQo+ICQgZG1lc2cgfCBncmVwIC1pIG10cnINCj4gWyAgICAw
LjM5MTUxNF0gbXRycjogeW91ciBDUFVzIGhhZCBpbmNvbnNpc3RlbnQgdmFyaWFibGUgTVRS
UiBzZXR0aW5ncw0KPiBbICAgIDAuMzk1MTk5XSBtdHJyOiBwcm9iYWJseSB5b3VyIEJJT1Mg
ZG9lcyBub3Qgc2V0dXAgYWxsIENQVXMuDQo+IFsgICAgMC4zOTkxOTldIG10cnI6IGNvcnJl
Y3RlZCBjb25maWd1cmF0aW9uLg0KPiANCj4gYnV0IHRoYXQncyB0aGUgdmFyaWFibGUgTVRS
UnMuDQo+IA0KPj4gYnV0IHlvdXIgcmVhc29uaW5nIHN1Z2dlc3RzIEkgc2hvdWxkIHJlbW92
ZSB0aGUgcmVsYXRlZCBjb2RlPw0KPiANCj4gTXkgcmVhc29uaW5nIHNheXMgeW91IHNob3Vs
ZCBub3QgZG8gYW55dGhpbmcgYXQgYWxsIGhlcmUgLSB3b3JrcyBhcw0KPiBhZHZlcnRpemVk
LiA6LSkNCj4gDQoNCkFuZCB3aGF0IGFib3V0IHRoZToNCg0KICAgcHJfd2FybigibXRycjog
eW91ciBDUFVzIGhhZCBpbmNvbnNpc3RlbnQgTVRSUmRlZlR5cGUgc2V0dGluZ3NcbiIpOw0K
DQpUaGlzIGlzIHRoZSBjYXNlIHRoZSBwYXRjaCB3b3VsZCBmaXguDQoNCg0KSnVlcmdlbg0K

--------------Z9SNFeC13wkqDPMRx3a68VCc
Content-Type: application/pgp-keys; name="OpenPGP_0xB0DE9DD628BF132F.asc"
Content-Disposition: attachment; filename="OpenPGP_0xB0DE9DD628BF132F.asc"
Content-Description: OpenPGP public key
Content-Transfer-Encoding: quoted-printable

-----BEGIN PGP PUBLIC KEY BLOCK-----

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
jR/i1DG86lem3iBDXzXsZDn8R38=3D
=3D2wuH
-----END PGP PUBLIC KEY BLOCK-----

--------------Z9SNFeC13wkqDPMRx3a68VCc--

--------------0VUZCoAFrKER0Qjvl6TZZK0W--

--------------TqzcXoH02scFtcsznY39KkrM
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsB5BAABCAAjFiEEhRJncuj2BJSl0Jf3sN6d1ii/Ey8FAmMDPxwFAwAAAAAACgkQsN6d1ii/Ey83
cAgAhiIUUi99IKd0SSNSDWWivhDoNdBoM+lDglLgfwGduXBvtAEVAzKB7gnRPq/aIxDdvOyDtZ3+
9kRwwahRjvPZS7xStuCFZgfsh7RJrWI29QNzJUGJ7RpaoWZn1RjeMIOcKhjqULlvJ1xS8L4/jp2S
Me+JbtuDDYc4+2PrdvcyflPCzZEmF93fJaWkM+MpjCMy9OvsLjolZVnMODa0tyxWP8mC1lwCVmsy
nxzQxST1HfZ29Sgct8eXpUD2LnhQLrJitt6295FNjTkBI1akijLMLil2Dyxr3JSqmA3wJVXl0EtU
734MXSjm+Au+VzQzUH48WDbiaLZ/jGVFJnfoRLdBLg==
=ppbM
-----END PGP SIGNATURE-----

--------------TqzcXoH02scFtcsznY39KkrM--
