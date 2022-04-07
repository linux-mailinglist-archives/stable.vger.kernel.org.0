Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 030654F7F94
	for <lists+stable@lfdr.de>; Thu,  7 Apr 2022 14:53:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231686AbiDGMzo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Apr 2022 08:55:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245539AbiDGMzn (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 Apr 2022 08:55:43 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9EEC25A493;
        Thu,  7 Apr 2022 05:53:39 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 95A79210DF;
        Thu,  7 Apr 2022 12:53:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1649336018; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/EuTQDDNt7SlKZvq8vUG4vSUxDPXDs3qHzbCGwSVzWM=;
        b=LGj17H47bAtUxspDmYaq2rczUJIP3ND7VaPahOHbVgS26sH1r3xtU3BsbjE/65ldmi7Ebg
        w6tFh3XIC3D+Vzlp2paPKF+uBsCM850iGcxSSOJan2pc8SrhjUnw7ZdkIGN3tQ0YCUy2F/
        3u8k82tdGFYOMTyzYY5pMsIcBw/fUt4=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 59A8E13485;
        Thu,  7 Apr 2022 12:53:38 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id t7iQFNLeTmJGIAAAMHmgww
        (envelope-from <jgross@suse.com>); Thu, 07 Apr 2022 12:53:38 +0000
Message-ID: <bd29e3c6-45ef-cfe3-4c86-567c2d9ab728@suse.com>
Date:   Thu, 7 Apr 2022 14:53:37 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH v2] mm, page_alloc: fix build_zonerefs_node()
Content-Language: en-US
To:     David Hildenbrand <david@redhat.com>,
        xen-devel@lists.xenproject.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Cc:     Andrew Morton <akpm@linux-foundation.org>, stable@vger.kernel.org,
        =?UTF-8?Q?Marek_Marczykowski-G=c3=b3recki?= 
        <marmarek@invisiblethingslab.com>, Michal Hocko <mhocko@suse.com>
References: <20220407120637.9035-1-jgross@suse.com>
 <42046fe0-d4da-625d-6412-b5459b80ee11@redhat.com>
From:   Juergen Gross <jgross@suse.com>
In-Reply-To: <42046fe0-d4da-625d-6412-b5459b80ee11@redhat.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------t04bfqdDWv4XrdQIqVux6Csd"
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------t04bfqdDWv4XrdQIqVux6Csd
Content-Type: multipart/mixed; boundary="------------Z4GSgTHl0SATVg0EAu030Dy6";
 protected-headers="v1"
From: Juergen Gross <jgross@suse.com>
To: David Hildenbrand <david@redhat.com>, xen-devel@lists.xenproject.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, stable@vger.kernel.org,
 =?UTF-8?Q?Marek_Marczykowski-G=c3=b3recki?=
 <marmarek@invisiblethingslab.com>, Michal Hocko <mhocko@suse.com>
Message-ID: <bd29e3c6-45ef-cfe3-4c86-567c2d9ab728@suse.com>
Subject: Re: [PATCH v2] mm, page_alloc: fix build_zonerefs_node()
References: <20220407120637.9035-1-jgross@suse.com>
 <42046fe0-d4da-625d-6412-b5459b80ee11@redhat.com>
In-Reply-To: <42046fe0-d4da-625d-6412-b5459b80ee11@redhat.com>

--------------Z4GSgTHl0SATVg0EAu030Dy6
Content-Type: multipart/mixed; boundary="------------izDrloGJ8V3l9n3GAw6J6OtS"

--------------izDrloGJ8V3l9n3GAw6J6OtS
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gMDcuMDQuMjIgMTQ6NDUsIERhdmlkIEhpbGRlbmJyYW5kIHdyb3RlOg0KPiBPbiAwNy4w
NC4yMiAxNDowNiwgSnVlcmdlbiBHcm9zcyB3cm90ZToNCj4+IFNpbmNlIGNvbW1pdCA2YWEz
MDNkZWZiNzQgKCJtbSwgdm1zY2FuOiBvbmx5IGFsbG9jYXRlIGFuZCByZWNsYWltIGZyb20N
Cj4+IHpvbmVzIHdpdGggcGFnZXMgbWFuYWdlZCBieSB0aGUgYnVkZHkgYWxsb2NhdG9yIikg
b25seSB6b25lcyB3aXRoIGZyZWUNCj4+IG1lbW9yeSBhcmUgaW5jbHVkZWQgaW4gYSBidWls
dCB6b25lbGlzdC4gVGhpcyBpcyBwcm9ibGVtYXRpYyB3aGVuIGUuZy4NCj4+IGFsbCBtZW1v
cnkgb2YgYSB6b25lIGhhcyBiZWVuIGJhbGxvb25lZCBvdXQgd2hlbiB6b25lbGlzdHMgYXJl
IGJlaW5nDQo+PiByZWJ1aWx0Lg0KPj4NCj4+IFRoZSBkZWNpc2lvbiB3aGV0aGVyIHRvIHJl
YnVpbGQgdGhlIHpvbmVsaXN0cyB3aGVuIG9ubGluaW5nIG5ldyBtZW1vcnkNCj4+IGlzIGRv
bmUgYmFzZWQgb24gcG9wdWxhdGVkX3pvbmUoKSByZXR1cm5pbmcgMCBmb3IgdGhlIHpvbmUg
dGhlIG1lbW9yeQ0KPj4gd2lsbCBiZSBhZGRlZCB0by4gVGhlIG5ldyB6b25lIGlzIGFkZGVk
IHRvIHRoZSB6b25lbGlzdHMgb25seSwgaWYgaXQNCj4+IGhhcyBmcmVlIG1lbW9yeSBwYWdl
cyAobWFuYWdlZF96b25lKCkgcmV0dXJucyBhIG5vbi16ZXJvIHZhbHVlKSBhZnRlcg0KPj4g
dGhlIG1lbW9yeSBoYXMgYmVlbiBvbmxpbmVkLiBUaGlzIGltcGxpZXMsIHRoYXQgb25saW5p
bmcgbWVtb3J5IHdpbGwNCj4+IGFsd2F5cyBmcmVlIHRoZSBhZGRlZCBwYWdlcyB0byB0aGUg
YWxsb2NhdG9yIGltbWVkaWF0ZWx5LCBidXQgdGhpcyBpcw0KPj4gbm90IHRydWUgaW4gYWxs
IGNhc2VzOiB3aGVuIGUuZy4gcnVubmluZyBhcyBhIFhlbiBndWVzdCB0aGUgb25saW5lZA0K
Pj4gbmV3IG1lbW9yeSB3aWxsIGJlIGFkZGVkIG9ubHkgdG8gdGhlIGJhbGxvb25lZCBtZW1v
cnkgbGlzdCwgaXQgd2lsbCBiZQ0KPj4gZnJlZWQgb25seSB3aGVuIHRoZSBndWVzdCBpcyBi
ZWluZyBiYWxsb29uZWQgdXAgYWZ0ZXJ3YXJkcy4NCj4+DQo+PiBBbm90aGVyIHByb2JsZW0g
d2l0aCB1c2luZyBtYW5hZ2VkX3pvbmUoKSBmb3IgdGhlIGRlY2lzaW9uIHdoZXRoZXIgYQ0K
Pj4gem9uZSBpcyBiZWluZyBhZGRlZCB0byB0aGUgem9uZWxpc3RzIGlzLCB0aGF0IGEgem9u
ZSB3aXRoIGFsbCBtZW1vcnkNCj4+IHVzZWQgd2lsbCBpbiBmYWN0IGJlIHJlbW92ZWQgZnJv
bSBhbGwgem9uZWxpc3RzIGluIGNhc2UgdGhlIHpvbmVsaXN0cw0KPj4gaGFwcGVuIHRvIGJl
IHJlYnVpbHQuDQo+Pg0KPj4gVXNlIHBvcHVsYXRlZF96b25lKCkgd2hlbiBidWlsZGluZyBh
IHpvbmVsaXN0IGFzIGl0IGhhcyBiZWVuIGRvbmUNCj4+IGJlZm9yZSB0aGF0IGNvbW1pdC4N
Cj4+DQo+PiBDYzogc3RhYmxlQHZnZXIua2VybmVsLm9yZw0KPj4gRml4ZXM6IDZhYTMwM2Rl
ZmI3NCAoIm1tLCB2bXNjYW46IG9ubHkgYWxsb2NhdGUgYW5kIHJlY2xhaW0gZnJvbSB6b25l
cyB3aXRoIHBhZ2VzIG1hbmFnZWQgYnkgdGhlIGJ1ZGR5IGFsbG9jYXRvciIpDQo+PiBSZXBv
cnRlZC1ieTogTWFyZWsgTWFyY3p5a293c2tpLUfDs3JlY2tpIDxtYXJtYXJla0BpbnZpc2li
bGV0aGluZ3NsYWIuY29tPg0KPj4gU2lnbmVkLW9mZi1ieTogSnVlcmdlbiBHcm9zcyA8amdy
b3NzQHN1c2UuY29tPg0KPj4gQWNrZWQtYnk6IE1pY2hhbCBIb2NrbyA8bWhvY2tvQHN1c2Uu
Y29tPg0KPj4gLS0tDQo+PiBWMjoNCj4+IC0gdXBkYXRlZCBjb21taXQgbWVzc2FnZSAoTWlj
aGFsIEhvY2tvKQ0KPj4gLS0tDQo+PiAgIG1tL3BhZ2VfYWxsb2MuYyB8IDIgKy0NCj4+ICAg
MSBmaWxlIGNoYW5nZWQsIDEgaW5zZXJ0aW9uKCspLCAxIGRlbGV0aW9uKC0pDQo+Pg0KPj4g
ZGlmZiAtLWdpdCBhL21tL3BhZ2VfYWxsb2MuYyBiL21tL3BhZ2VfYWxsb2MuYw0KPj4gaW5k
ZXggYmRjOGY2MGFlNDYyLi4zZDA2NjJhZjMyODkgMTAwNjQ0DQo+PiAtLS0gYS9tbS9wYWdl
X2FsbG9jLmMNCj4+ICsrKyBiL21tL3BhZ2VfYWxsb2MuYw0KPj4gQEAgLTYxMjgsNyArNjEy
OCw3IEBAIHN0YXRpYyBpbnQgYnVpbGRfem9uZXJlZnNfbm9kZShwZ19kYXRhX3QgKnBnZGF0
LCBzdHJ1Y3Qgem9uZXJlZiAqem9uZXJlZnMpDQo+PiAgIAlkbyB7DQo+PiAgIAkJem9uZV90
eXBlLS07DQo+PiAgIAkJem9uZSA9IHBnZGF0LT5ub2RlX3pvbmVzICsgem9uZV90eXBlOw0K
Pj4gLQkJaWYgKG1hbmFnZWRfem9uZSh6b25lKSkgew0KPj4gKwkJaWYgKHBvcHVsYXRlZF96
b25lKHpvbmUpKSB7DQo+PiAgIAkJCXpvbmVyZWZfc2V0X3pvbmUoem9uZSwgJnpvbmVyZWZz
W25yX3pvbmVzKytdKTsNCj4+ICAgCQkJY2hlY2tfaGlnaGVzdF96b25lKHpvbmVfdHlwZSk7
DQo+PiAgIAkJfQ0KPiANCj4gRGlkIHlvdSBkcm9wIG15IEFjaz8NCg0KT2gsIHNvcnJ5IGZv
ciB0aGF0Lg0KDQo+IEFsc28sIEknZCBhcHByZWNpYXRlIGdldHRpbmcgQ0NlZCBvbiBwYXRj
aGVzIHdoZXJlIEkgY29tbWVudGVkLg0KDQpXaWxsIGRvIGluIGZ1dHVyZS4NCg0KDQpKdWVy
Z2VuDQo=
--------------izDrloGJ8V3l9n3GAw6J6OtS
Content-Type: application/pgp-keys; name="OpenPGP_0xB0DE9DD628BF132F.asc"
Content-Disposition: attachment; filename="OpenPGP_0xB0DE9DD628BF132F.asc"
Content-Description: OpenPGP public key
Content-Transfer-Encoding: quoted-printable

-----BEGIN PGP PUBLIC KEY BLOCK-----

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
jR/i1DG86lem3iBDXzXsZDn8R38=3D
=3D2wuH
-----END PGP PUBLIC KEY BLOCK-----

--------------izDrloGJ8V3l9n3GAw6J6OtS--

--------------Z4GSgTHl0SATVg0EAu030Dy6--

--------------t04bfqdDWv4XrdQIqVux6Csd
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsB5BAABCAAjFiEEhRJncuj2BJSl0Jf3sN6d1ii/Ey8FAmJO3tEFAwAAAAAACgkQsN6d1ii/Ey/N
7wf/Q6ls4N2V/vkNWRdh1a7qLQuOcrlxdBS3Om7l3hk+u508DrODIMwB4XViur0F0dLmy+MCI1PC
aVsIUkokUlOia2J/wHC+c4MxmkvWz0+fTrhgWMwl0voREDdhtZLXuO4U+axxo5d0D25/BmF+z+PL
ge4zgPYgQjEMF84xmTnLOsywX+eQ5fieoU21y98doQ+di2y+GPu1hms2+w3mdZHL3xGdDc8OyNdJ
WZDmDYZnelXI9LyZSt9lPHaO2X2Vn5b3IhWMBoaTxHuvjSiMe4gVuuZvWoDiQc0WZm9jA77iGhoU
5lbLRjyDnbbXNmW+YYLbJEIzj8kcAxxaLAuwOHnHdQ==
=Yhvw
-----END PGP SIGNATURE-----

--------------t04bfqdDWv4XrdQIqVux6Csd--
