Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 066BA591F19
	for <lists+stable@lfdr.de>; Sun, 14 Aug 2022 10:36:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229484AbiHNIgp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 14 Aug 2022 04:36:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbiHNIgp (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 14 Aug 2022 04:36:45 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF2C81B7B9;
        Sun, 14 Aug 2022 01:36:43 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 6103134485;
        Sun, 14 Aug 2022 08:36:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1660466202; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=BtkuN3DMeDpEGsqws8y1K6SIKbIDDdJvEBSwfSS2EGM=;
        b=IgynDYGcazg+5xEpalEo1VJOYIRBWPNxtwa3itFj3iWjDH78sble5gK+U5RgUHUTt4NdPK
        +0TT0ghpFydJYhMzmU7iuZUEoRZrrrasOhgRbCAf1aU18eFiJb+Wj9WYsz3T3rOFRZPmcq
        wIgNPpqXPZm9zwSQ7cLDbqlAXALgB84=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 0BB9913AAE;
        Sun, 14 Aug 2022 08:36:42 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id La0MARq0+GLMNgAAMHmgww
        (envelope-from <jgross@suse.com>); Sun, 14 Aug 2022 08:36:42 +0000
Message-ID: <63d3b8db-2877-d413-405b-186498e542b6@suse.com>
Date:   Sun, 14 Aug 2022 10:36:41 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH v4 0/3] xen-blk{back,front}: Fix two bugs in
 'feature_persistent'
Content-Language: en-US
To:     SeongJae Park <sj@kernel.org>, roger.pau@citrix.com
Cc:     axboe@kernel.dk, boris.ostrovsky@oracle.com, olekstysh@gmail.com,
        andrii.chepurnyi82@gmail.com, mheyne@amazon.de,
        xen-devel@lists.xenproject.org, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20220715225108.193398-1-sj@kernel.org>
From:   Juergen Gross <jgross@suse.com>
In-Reply-To: <20220715225108.193398-1-sj@kernel.org>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------jiTB6OM2Ipz0IBM22NaksarS"
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
--------------jiTB6OM2Ipz0IBM22NaksarS
Content-Type: multipart/mixed; boundary="------------5Cp6QDD4ughbMr9MtVtA2ME0";
 protected-headers="v1"
From: Juergen Gross <jgross@suse.com>
To: SeongJae Park <sj@kernel.org>, roger.pau@citrix.com
Cc: axboe@kernel.dk, boris.ostrovsky@oracle.com, olekstysh@gmail.com,
 andrii.chepurnyi82@gmail.com, mheyne@amazon.de,
 xen-devel@lists.xenproject.org, linux-block@vger.kernel.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
Message-ID: <63d3b8db-2877-d413-405b-186498e542b6@suse.com>
Subject: Re: [PATCH v4 0/3] xen-blk{back,front}: Fix two bugs in
 'feature_persistent'
References: <20220715225108.193398-1-sj@kernel.org>
In-Reply-To: <20220715225108.193398-1-sj@kernel.org>

--------------5Cp6QDD4ughbMr9MtVtA2ME0
Content-Type: multipart/mixed; boundary="------------gqQAum1BpSXYvefTeiVZOgS8"

--------------gqQAum1BpSXYvefTeiVZOgS8
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gMTYuMDcuMjIgMDA6NTEsIFNlb25nSmFlIFBhcmsgd3JvdGU6DQo+IEludHJvZHVjdGlv
biBvZiAnZmVhdHVyZV9wZXJzaXN0ZW50JyBtYWRlIHR3byBidWdzLiAgRmlyc3Qgb25lIGlz
IHdyb25nDQo+IG92ZXJ3cml0ZSBvZiAndmJkLT5mZWF0dXJlX2dudF9wZXJzaXN0ZW50JyBp
biAnYmxrYmFjaycgZHVlIHRvIHdyb25nDQo+IHBhcmFtZXRlciB2YWx1ZSBjYWNoaW5nIHBv
c2l0aW9uLCBhbmQgdGhlIHNlY29uZCBvbmUgaXMgdW5pbnRlbmRlZA0KPiBiZWhhdmlvcmFs
IGNoYW5nZSB0aGF0IGNvdWxkIGJyZWFrIHByZXZpb3VzIGR5bmFtaWMgZnJvbnRlbmQvYmFj
a2VuZA0KPiBwZXJzaXN0ZW50IGZlYXR1cmUgc3VwcG9ydCBjaGFuZ2VzLiAgVGhpcyBwYXRj
aHNldCBmaXhlcyB0aGUgaXNzdWVzLg0KPiANCj4gQ2hhbmdlcyBmcm9tIHYzDQo+IChodHRw
czovL2xvcmUua2VybmVsLm9yZy94ZW4tZGV2ZWwvMjAyMjA3MTUxNzU1MjEuMTI2NjQ5LTEt
c2pAa2VybmVsLm9yZy8pDQo+IC0gU3BsaXQgJ2Jsa2JhY2snIHBhdGNoIGZvciBlYWNoIG9m
IHRoZSB0d28gaXNzdWVzDQo+IC0gQWRkICdSZXBvcnRlZC1ieTogQW5kcmlpIENoZXB1cm55
aSA8YW5kcmlpLmNoZXB1cm55aTgyQGdtYWlsLmNvbT4nDQo+IA0KPiBDaGFuZ2VzIGZyb20g
djINCj4gKGh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL3hlbi1kZXZlbC8yMDIyMDcxNDIyNDQx
MC41MTE0Ny0xLXNqQGtlcm5lbC5vcmcvKQ0KPiAtIEtlZXAgdGhlIGJlaGF2aW9yYWwgY2hh
bmdlIG9mIHYxDQo+IC0gVXBkYXRlIGJsa2Zyb250J3MgY291bnRlcnBhcnQgdG8gZm9sbG93
IHRoZSBjaGFuZ2VkIGJlaGF2aW9yDQo+IC0gVXBkYXRlIGRvY3VtZW50cyBmb3IgdGhlIGNo
YW5nZWQgYmVoYXZpb3INCj4gDQo+IENoYW5nZXMgZnJvbSB2MQ0KPiAoaHR0cHM6Ly9sb3Jl
Lmtlcm5lbC5vcmcveGVuLWRldmVsLzIwMjIwMTA2MDkxMDEzLjEyNjA3Ni0xLW1oZXluZUBh
bWF6b24uZGUvKQ0KPiAtIEF2b2lkIHRoZSBiZWhhdmlvcmFsIGNoYW5nZQ0KPiAgICAoaHR0
cHM6Ly9sb3JlLmtlcm5lbC5vcmcveGVuLWRldmVsLzIwMjIwMTIxMTAyMzA5LjI3ODAyLTEt
c2pAa2VybmVsLm9yZy8pDQo+IC0gUmViYXNlIG9uIGxhdGVzdCB4ZW4vdGlwL2xpbnV4LW5l
eHQNCj4gLSBSZS13b3JrIGJ5IFNlb25nSmFlIFBhcmsgPHNqQGtlcm5lbC5vcmc+DQo+IC0g
Q2Mgc3RhYmxlQA0KPiANCj4gTWF4aW1pbGlhbiBIZXluZSAoMSk6DQo+ICAgIHhlbi1ibGti
YWNrOiBBcHBseSAnZmVhdHVyZV9wZXJzaXN0ZW50JyBwYXJhbWV0ZXIgd2hlbiBjb25uZWN0
DQo+IA0KPiBTZW9uZ0phZSBQYXJrICgyKToNCj4gICAgeGVuLWJsa2JhY2s6IGZpeCBwZXJz
aXN0ZW50IGdyYW50cyBuZWdvdGlhdGlvbg0KPiAgICB4ZW4tYmxrZnJvbnQ6IEFwcGx5ICdm
ZWF0dXJlX3BlcnNpc3RlbnQnIHBhcmFtZXRlciB3aGVuIGNvbm5lY3QNCj4gDQo+ICAgLi4u
L0FCSS90ZXN0aW5nL3N5c2ZzLWRyaXZlci14ZW4tYmxrYmFjayAgICAgIHwgIDIgKy0NCj4g
ICAuLi4vQUJJL3Rlc3Rpbmcvc3lzZnMtZHJpdmVyLXhlbi1ibGtmcm9udCAgICAgfCAgMiAr
LQ0KPiAgIGRyaXZlcnMvYmxvY2sveGVuLWJsa2JhY2sveGVuYnVzLmMgICAgICAgICAgICB8
IDIwICsrKysrKysrLS0tLS0tLS0tLS0NCj4gICBkcml2ZXJzL2Jsb2NrL3hlbi1ibGtmcm9u
dC5jICAgICAgICAgICAgICAgICAgfCAgNCArLS0tDQo+ICAgNCBmaWxlcyBjaGFuZ2VkLCAx
MSBpbnNlcnRpb25zKCspLCAxNyBkZWxldGlvbnMoLSkNCj4gDQoNClNlcmllcyBwdXNoZWQg
dG8geGVuL3RpcC5naXQgZm9yLWxpbnVzLTYuMA0KDQoNCkp1ZXJnZW4NCg==
--------------gqQAum1BpSXYvefTeiVZOgS8
Content-Type: application/pgp-keys; name="OpenPGP_0xB0DE9DD628BF132F.asc"
Content-Disposition: attachment; filename="OpenPGP_0xB0DE9DD628BF132F.asc"
Content-Description: OpenPGP public key
Content-Transfer-Encoding: quoted-printable

-----BEGIN PGP PUBLIC KEY BLOCK-----

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
jR/i1DG86lem3iBDXzXsZDn8R38=3D
=3D2wuH
-----END PGP PUBLIC KEY BLOCK-----

--------------gqQAum1BpSXYvefTeiVZOgS8--

--------------5Cp6QDD4ughbMr9MtVtA2ME0--

--------------jiTB6OM2Ipz0IBM22NaksarS
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsB5BAABCAAjFiEEhRJncuj2BJSl0Jf3sN6d1ii/Ey8FAmL4tBkFAwAAAAAACgkQsN6d1ii/Ey+8
dAgAnNX9zMIKXbLr/WMD6B7Mo8kKoybfFhvSfzgduXHj+9/kzhnvaJ5Ysyil8toOm8QD+VmtgOy0
8ep+hv9sBbTtx+ja7WIVfDhPgSDE7VVdJf556XHqXtCkFz0PI10gIR18w0dRhJR/g8kbLXUzWHRQ
ZymNdzLIWbh/qz43FfXnV1xkHEkIjr98tau1EqL0Q26+6DeGECwE5iaWEYu1bGLYHDDLXKgrAm61
lkI+/vJSMMfkg10aOfgLMUM54r7R7tlf/yrAqBt2Iz6c6qOxAG+zv9ZUkU/C5VAsqGJZtYz6sqcy
DHuViBfCHgINRImcH8GTmXxwcaVdy7NP1fjHAV4MnQ==
=XCwS
-----END PGP SIGNATURE-----

--------------jiTB6OM2Ipz0IBM22NaksarS--
