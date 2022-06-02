Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6255B53B66B
	for <lists+stable@lfdr.de>; Thu,  2 Jun 2022 11:54:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233238AbiFBJyi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jun 2022 05:54:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231395AbiFBJyh (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Jun 2022 05:54:37 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A457F33E3E;
        Thu,  2 Jun 2022 02:54:36 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 629321F99A;
        Thu,  2 Jun 2022 09:54:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1654163675; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Y+zb1z8ZfmyQ511e2hgXKSEcDrjipQXOzf/DXU4KCD0=;
        b=ueLr4R7P6F8mSupk6/9LCgD2EOYMRBSix21XvcnqViBp0f+DsmdJUtdEewZyd2pyH+2kA/
        9yRO4QtuWGtXHsKPjvzzK6lVYLzl56AXvU3L0SaQjsbc/HTSuRO8QDIbX/ozD7ZL/5UU5/
        sd3+ZF/iUeB3a2JCHNagwzYEscCKyPw=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 1A114134F3;
        Thu,  2 Jun 2022 09:54:35 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id hxLpBNuImGJpUAAAMHmgww
        (envelope-from <jgross@suse.com>); Thu, 02 Jun 2022 09:54:35 +0000
Message-ID: <f4c96c08-9f87-e0d1-9b07-b8d654f36e2d@suse.com>
Date:   Thu, 2 Jun 2022 11:54:34 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH v2] xen/gntdev: Avoid blocking in unmap_grant_pages()
Content-Language: en-US
To:     Demi Marie Obenour <demi@invisiblethingslab.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Jennifer Herbert <jennifer.herbert@citrix.com>,
        =?UTF-8?Q?Marek_Marczykowski-G=c3=b3recki?= 
        <marmarek@invisiblethingslab.com>
Cc:     xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
References: <20220525184153.6059-1-demi@invisiblethingslab.com>
 <00c0b10c-a35d-6729-5b4f-424febd9d5a3@suse.com> <YpUD3PnPoGj84jMq@itl-email>
From:   Juergen Gross <jgross@suse.com>
In-Reply-To: <YpUD3PnPoGj84jMq@itl-email>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------y5L0b7i63kwPIVxx9zNZmi1G"
X-Spam-Status: No, score=-7.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------y5L0b7i63kwPIVxx9zNZmi1G
Content-Type: multipart/mixed; boundary="------------u5JGZ2POLcDttpEs0aSKpENK";
 protected-headers="v1"
From: Juergen Gross <jgross@suse.com>
To: Demi Marie Obenour <demi@invisiblethingslab.com>,
 Boris Ostrovsky <boris.ostrovsky@oracle.com>,
 Stefano Stabellini <sstabellini@kernel.org>,
 Jennifer Herbert <jennifer.herbert@citrix.com>,
 =?UTF-8?Q?Marek_Marczykowski-G=c3=b3recki?= <marmarek@invisiblethingslab.com>
Cc: xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
Message-ID: <f4c96c08-9f87-e0d1-9b07-b8d654f36e2d@suse.com>
Subject: Re: [PATCH v2] xen/gntdev: Avoid blocking in unmap_grant_pages()
References: <20220525184153.6059-1-demi@invisiblethingslab.com>
 <00c0b10c-a35d-6729-5b4f-424febd9d5a3@suse.com> <YpUD3PnPoGj84jMq@itl-email>
In-Reply-To: <YpUD3PnPoGj84jMq@itl-email>

--------------u5JGZ2POLcDttpEs0aSKpENK
Content-Type: multipart/mixed; boundary="------------etPTrSgLchsz5EqajCsT55hr"

--------------etPTrSgLchsz5EqajCsT55hr
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gMzAuMDUuMjIgMTk6NTAsIERlbWkgTWFyaWUgT2Jlbm91ciB3cm90ZToNCj4gT24gTW9u
LCBNYXkgMzAsIDIwMjIgYXQgMDg6NDE6MjBBTSArMDIwMCwgSnVlcmdlbiBHcm9zcyB3cm90
ZToNCj4+IE9uIDI1LjA1LjIyIDIwOjQxLCBEZW1pIE1hcmllIE9iZW5vdXIgd3JvdGU6DQo+
Pj4gdW5tYXBfZ3JhbnRfcGFnZXMoKSBjdXJyZW50bHkgd2FpdHMgZm9yIHRoZSBwYWdlcyB0
byBubyBsb25nZXIgYmUgdXNlZC4NCj4+PiBJbiBodHRwczovL2dpdGh1Yi5jb20vUXViZXNP
Uy9xdWJlcy1pc3N1ZXMvaXNzdWVzLzc0ODEsIHRoaXMgbGVhZCB0byBhDQo+Pj4gZGVhZGxv
Y2sgYWdhaW5zdCBpOTE1OiBpOTE1IHdhcyB3YWl0aW5nIGZvciBnbnRkZXYncyBNTVUgbm90
aWZpZXIgdG8NCj4+PiBmaW5pc2gsIHdoaWxlIGdudGRldiB3YXMgd2FpdGluZyBmb3IgaTkx
NSB0byBmcmVlIGl0cyBwYWdlcy4gIEkgYWxzbw0KPj4+IGJlbGlldmUgdGhpcyBpcyByZXNw
b25zaWJsZSBmb3IgdmFyaW91cyBkZWFkbG9ja3MgSSBoYXZlIGV4cGVyaWVuY2VkIGluDQo+
Pj4gdGhlIHBhc3QuDQo+Pj4NCj4+PiBBdm9pZCB0aGVzZSBwcm9ibGVtcyBieSBtYWtpbmcg
dW5tYXBfZ3JhbnRfcGFnZXMgYXN5bmMuICBUaGlzIHJlcXVpcmVzDQo+Pj4gbWFraW5nIGl0
IHJldHVybiB2b2lkLCBhcyBhbnkgZXJyb3JzIHdpbGwgbm90IGJlIGF2YWlsYWJsZSB3aGVu
IHRoZQ0KPj4+IGZ1bmN0aW9uIHJldHVybnMuICBGb3J0dW5hdGVseSwgdGhlIG9ubHkgdXNl
IG9mIHRoZSByZXR1cm4gdmFsdWUgaXMgYQ0KPj4+IFdBUk5fT04oKSwgd2hpY2ggY2FuIGJl
IHJlcGxhY2VkIGJ5IGEgV0FSTl9PTiB3aGVuIHRoZSBlcnJvciBpcw0KPj4+IGRldGVjdGVk
LiAgQWRkaXRpb25hbGx5LCBhIGZhaWxlZCBjYWxsIHdpbGwgbm90IHByZXZlbnQgZnVydGhl
ciBjYWxscw0KPj4+IGZyb20gYmVpbmcgbWFkZSwgYnV0IHRoaXMgaXMgaGFybWxlc3MuDQo+
Pj4NCj4+PiBCZWNhdXNlIHVubWFwX2dyYW50X3BhZ2VzIGlzIG5vdyBhc3luYywgdGhlIGdy
YW50IGhhbmRsZSB3aWxsIGJlIHNlbnQgdG8NCj4+PiBJTlZBTElEX0dSQU5UX0hBTkRMRSB0
b28gbGF0ZSB0byBwcmV2ZW50IG11bHRpcGxlIHVubWFwcyBvZiB0aGUgc2FtZQ0KPj4+IGhh
bmRsZS4gIEluc3RlYWQsIGEgc2VwYXJhdGUgYm9vbCBhcnJheSBpcyBhbGxvY2F0ZWQgZm9y
IHRoaXMgcHVycG9zZS4NCj4+PiBUaGlzIHdhc3RlcyBtZW1vcnksIGJ1dCBzdHVmZmluZyB0
aGlzIGluZm9ybWF0aW9uIGluIHBhZGRpbmcgYnl0ZXMgaXMNCj4+PiB0b28gZnJhZ2lsZS4g
IEZ1cnRoZXJtb3JlLCBpdCBpcyBuZWNlc3NhcnkgdG8gZ3JhYiBhIHJlZmVyZW5jZSB0byB0
aGUNCj4+PiBtYXAgYmVmb3JlIG1ha2luZyB0aGUgYXN5bmNocm9ub3VzIGNhbGwsIGFuZCBy
ZWxlYXNlIHRoZSByZWZlcmVuY2Ugd2hlbg0KPj4+IHRoZSBjYWxsIHJldHVybnMuDQo+Pg0K
Pj4gSSB0aGluayB0aGVyZSBpcyBldmVuIG1vcmUgc3luY2luZyBuZWVkZWQ6DQo+Pg0KPj4g
LSBJbiB0aGUgZXJyb3IgcGF0aCBvZiBnbnRkZXZfbW1hcCgpIHVubWFwX2dyYW50X3BhZ2Vz
KCkgaXMgYmVpbmcgY2FsbGVkIGFuZA0KPj4gICAgaXQgaXMgYXNzdW1lZCwgbWFwIGlzIGF2
YWlsYWJsZSBhZnRlcndhcmRzIGFnYWluLiBUaGlzIHNob3VsZCBiZSByYXRoZXIgZWFzeQ0K
Pj4gICAgdG8gYXZvaWQgYnkgYWRkaW5nIGEgY291bnRlciBvZiBhY3RpdmUgbWFwcGluZ3Mg
dG8gc3RydWN0IGdudGRldl9ncmFudF9tYXANCj4+ICAgIChudW1iZXIgb2YgcGFnZXMgbm90
IGJlaW5nIHVubWFwcGVkIHlldCkuIEluIGNhc2UgdGhpcyBjb3VudGVyIGlzIG5vdCB6ZXJv
DQo+PiAgICBnbnRkZXZfbW1hcCgpIHNob3VsZCBiYWlsIG91dCBlYXJseS4NCj4gDQo+IElz
IGl0IHBvc3NpYmxlIHRvIGp1c3QgdW5tYXAgdGhlIHBhZ2VzIGRpcmVjdGx5IGhlcmU/ICBJ
IGRvbuKAmXQgdGhpbmsNCj4gdGhlcmUgY2FuIGJlIGFueSBvdGhlciB1c2VycyBvZiB0aGVz
ZSBwYWdlcyB5ZXQuICBVc2Vyc3BhY2UgY291bGQgcmFjZQ0KPiBhZ2FpbnN0IHRoZSB1bm1h
cCBhbmQgY2F1c2UgYSBwYWdlIGZhdWx0LCBidXQgdGhhdCBzaG91bGQganVzdCBjYXVzZQ0K
PiB1c2Vyc3BhY2UgdG8gZ2V0IFNJR1NFR1Ygb3IgU0lHQlVTLiAgSW4gYW55IGNhc2UgdGhp
cyBjb2RlIGNhbiB1c2UgdGhlDQo+IHN5bmMgdmVyc2lvbjsgaWYgaXQgZ2V0cyBibG9ja2Vk
IHRoYXTigJlzIHVzZXJzcGFjZeKAmXMgcHJvYmxlbS4NCj4gDQo+PiAtIGdudGRldl9wdXRf
bWFwKCkgaXMgY2FsbGluZyB1bm1hcF9ncmFudF9wYWdlcygpIGluIGNhc2UgdGhlIHJlZmNv
dW50IGhhcw0KPj4gICAgZHJvcHBlZCB0byB6ZXJvLiBUaGlzIGNhbGwgY2FuIHNldCB0aGUg
cmVmY291bnQgdG8gMSBhZ2Fpbiwgc28gdGhlcmUgaXMNCj4+ICAgIGFub3RoZXIgZGVsYXkg
bmVlZGVkIGJlZm9yZSBmcmVlaW5nIG1hcC4gSSB0aGluayB1bm1hcF9ncmFudF9wYWdlcygp
IHNob3VsZA0KPj4gICAgcmV0dXJuIGluIGNhc2UgdGhlIGNvdW50IG9mIG1hcHBlZCBwYWdl
cyBpcyB6ZXJvIChzZWUgYWJvdmUpLCB0aHVzIGF2b2lkaW5nDQo+PiAgICB0byBpbmNyZW1l
bnQgdGhlIHJlZmNvdW50IG9mIG1hcCBpZiBub3RoaW5nIGlzIHRvIGJlIGRvbmUuIFRoaXMg
d291bGQgZW5hYmxlDQo+PiAgICBnbnRkZXZfcHV0X21hcCgpIHRvIGp1c3QgcmV0dXJuIGFm
dGVyIHRoZSBjYWxsIG9mIHVubWFwX2dyYW50X3BhZ2VzKCkgaW4gY2FzZQ0KPj4gICAgdGhl
IHJlZmNvdW50IGhhcyBiZWVuIGluY3JlbWVudGVkIGFnYWluLg0KPiANCj4gSSB3aWxsIGNo
YW5nZSB0aGlzIGluIHYzLCBidXQgSSBkbyB3b25kZXIgaWYgZ250ZGV2IGlzIHVzaW5nIHRo
ZSB3cm9uZw0KPiBNTVUgbm90aWZpZXIgY2FsbGJhY2suICBJdCBzZWVtcyB0aGF0IHRoZSBh
cHByb3ByaWF0ZSBjYWxsYmFjayBpcw0KPiBhY3R1YWxseSByZWxlYXNlKCk6IGlmIEkgdW5k
ZXJzdGFuZCBjb3JyZWN0bHksIHJlbGVhc2UoKSBpcyBjYWxsZWQNCj4gcHJlY2lzZWx5IHdo
ZW4gdGhlIHJlZmNvdW50IG9uIHRoZSBwaHlzaWNhbCBwYWdlIGlzIGFib3V0IHRvIGRyb3Ag
dG8gMCwNCj4gYW5kIHRoYXQgaXMgd2hhdCB3ZSB3YW50Lg0KDQpObywgSSBkb24ndCB0aGlu
ayB0aGlzIGlzIGNvcnJlY3QuDQoNCnJlbGVhc2UoKSBpcyBiZWluZyBjYWxsZWQgd2hlbiB0
aGUgcmVmY291bnQgb2YgdGhlIGFkZHJlc3Mgc3BhY2UgaXMgYWJvdXQNCnRvIGRyb3AgdG8g
MC4gSXQgaGFzIG5vIHBhZ2UgZ3JhbnVsYXJpdHkuDQoNCg0KSnVlcmdlbg0K
--------------etPTrSgLchsz5EqajCsT55hr
Content-Type: application/pgp-keys; name="OpenPGP_0xB0DE9DD628BF132F.asc"
Content-Disposition: attachment; filename="OpenPGP_0xB0DE9DD628BF132F.asc"
Content-Description: OpenPGP public key
Content-Transfer-Encoding: quoted-printable

-----BEGIN PGP PUBLIC KEY BLOCK-----

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
jR/i1DG86lem3iBDXzXsZDn8R38=3D
=3D2wuH
-----END PGP PUBLIC KEY BLOCK-----

--------------etPTrSgLchsz5EqajCsT55hr--

--------------u5JGZ2POLcDttpEs0aSKpENK--

--------------y5L0b7i63kwPIVxx9zNZmi1G
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsB5BAABCAAjFiEEhRJncuj2BJSl0Jf3sN6d1ii/Ey8FAmKYiNoFAwAAAAAACgkQsN6d1ii/Ey+q
7ggAkvIDKvAzNM5SG+gjnxFkbxikvZcBfjkneXTiYxO+IKXD67Wbrw+mqQAN5geOpUeYyNKCZVJV
zdDedKrY25LpR0LT1U/LGWesrxjw2dVLIkNL0IOe5X1DHuVtGDbbgjrfp7qqZPNHvFEsQRohNbox
oij9GZMWxAIuHmfCBK+kYttp7BAqtTTFmJ/3SnT20IjZHzL8hfBJ8vaJ4sM4eteN62PdMCN/5Jg8
2dY0rdFCYvjG0VHjvg3E3b0WhGEPhW4etZQwVCcTaNBbOiOQZelNXvncrz8HTdAi8wPYhuU21v9C
sHGuUNh6KROfz49dA2tjfb3a8cm6JRASNoW4kIEDNw==
=qnL6
-----END PGP SIGNATURE-----

--------------y5L0b7i63kwPIVxx9zNZmi1G--
