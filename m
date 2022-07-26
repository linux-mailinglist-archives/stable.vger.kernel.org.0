Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B185581690
	for <lists+stable@lfdr.de>; Tue, 26 Jul 2022 17:38:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230064AbiGZPis (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Jul 2022 11:38:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229495AbiGZPir (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Jul 2022 11:38:47 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF4232BB11;
        Tue, 26 Jul 2022 08:38:46 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 78E1838035;
        Tue, 26 Jul 2022 15:38:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1658849925; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ryV1HJCptD0nwoReqYwbenCXh0WLmaSLGVPdKV3OZ14=;
        b=oxDbM3ouJt673YP87UvBW499CowgY+FeAY/kCRWrqJAQTAWICJIZC7yUWhQ7JY7TKDHuyC
        /40cBCMyiHSDW6Wd0xi+ETMvlAL8eZ8rgVdh0EWS1Bfe4zkRjGpthrjXHA0en+uBe/kGU7
        zGV+zyx4S9quiN3P4mRDyHEK9hQ0qAo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1658849925;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ryV1HJCptD0nwoReqYwbenCXh0WLmaSLGVPdKV3OZ14=;
        b=wVWhmq4c1eki7+2Og2//EDM8hO+eRAgiuV9boY2r1sORV3wDD+rD7d3h4W3ZCsBXv84lfN
        kNsMhtQy03K+SCBw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 498CE13A7C;
        Tue, 26 Jul 2022 15:38:45 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id UF4GEYUK4GIkXAAAMHmgww
        (envelope-from <tzimmermann@suse.de>); Tue, 26 Jul 2022 15:38:45 +0000
Message-ID: <7ca66bcf-a29a-987c-4606-9209590dae91@suse.de>
Date:   Tue, 26 Jul 2022 17:38:44 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH] drm/simpledrm: Fix return type of
 simpledrm_simple_display_pipe_mode_valid()
Content-Language: en-US
To:     Sami Tolvanen <samitolvanen@google.com>,
        Nathan Chancellor <nathan@kernel.org>
Cc:     =?UTF-8?Q?Tomasz_Pawe=c5=82_Gajc?= <tpgxyz@gmail.com>,
        Kees Cook <keescook@chromium.org>, llvm@lists.linux.dev,
        LKML <linux-kernel@vger.kernel.org>,
        dri-devel@lists.freedesktop.org,
        Javier Martinez Canillas <javierm@redhat.com>,
        "# 3.4.x" <stable@vger.kernel.org>
References: <20220725233629.223223-1-nathan@kernel.org>
 <CABCJKuf1gYZZb9U-zwjkvvRUUh9GvYsHF=8zub=pr9tG4BqtkA@mail.gmail.com>
From:   Thomas Zimmermann <tzimmermann@suse.de>
In-Reply-To: <CABCJKuf1gYZZb9U-zwjkvvRUUh9GvYsHF=8zub=pr9tG4BqtkA@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------SKFncP8NLk0WuC8ZPEwA4780"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------SKFncP8NLk0WuC8ZPEwA4780
Content-Type: multipart/mixed; boundary="------------DMeztSdmW47OO0pR4AMxD1YJ";
 protected-headers="v1"
From: Thomas Zimmermann <tzimmermann@suse.de>
To: Sami Tolvanen <samitolvanen@google.com>,
 Nathan Chancellor <nathan@kernel.org>
Cc: =?UTF-8?Q?Tomasz_Pawe=c5=82_Gajc?= <tpgxyz@gmail.com>,
 Kees Cook <keescook@chromium.org>, llvm@lists.linux.dev,
 LKML <linux-kernel@vger.kernel.org>, dri-devel@lists.freedesktop.org,
 Javier Martinez Canillas <javierm@redhat.com>,
 "# 3.4.x" <stable@vger.kernel.org>
Message-ID: <7ca66bcf-a29a-987c-4606-9209590dae91@suse.de>
Subject: Re: [PATCH] drm/simpledrm: Fix return type of
 simpledrm_simple_display_pipe_mode_valid()
References: <20220725233629.223223-1-nathan@kernel.org>
 <CABCJKuf1gYZZb9U-zwjkvvRUUh9GvYsHF=8zub=pr9tG4BqtkA@mail.gmail.com>
In-Reply-To: <CABCJKuf1gYZZb9U-zwjkvvRUUh9GvYsHF=8zub=pr9tG4BqtkA@mail.gmail.com>

--------------DMeztSdmW47OO0pR4AMxD1YJ
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

SGkNCg0KQW0gMjYuMDcuMjIgdW0gMDI6MTIgc2NocmllYiBTYW1pIFRvbHZhbmVuOg0KPiBP
biBNb24sIEp1bCAyNSwgMjAyMiBhdCA0OjM3IFBNIE5hdGhhbiBDaGFuY2VsbG9yIDxuYXRo
YW5Aa2VybmVsLm9yZz4gd3JvdGU6DQo+Pg0KPj4gV2hlbiBib290aW5nIGEga2VybmVsIGNv
bXBpbGVkIHdpdGggY2xhbmcncyBDRkkgcHJvdGVjdGlvbg0KPj4gKENPTkZJR19DRklfQ0xB
TkcpLCB0aGVyZSBpcyBhIENGSSBmYWlsdXJlIGluDQo+PiBkcm1fc2ltcGxlX2ttc19jcnRj
X21vZGVfdmFsaWQoKSB3aGVuIHRyeWluZyB0byBjYWxsDQo+PiBzaW1wbGVkcm1fc2ltcGxl
X2Rpc3BsYXlfcGlwZV9tb2RlX3ZhbGlkKCkgdGhyb3VnaCAtPm1vZGVfdmFsaWQoKToNCj4+
DQo+PiBbICAgIDAuMzIyODAyXSBDRkkgZmFpbHVyZSAodGFyZ2V0OiBzaW1wbGVkcm1fc2lt
cGxlX2Rpc3BsYXlfcGlwZV9tb2RlX3ZhbGlkKzB4MC8weDgpOg0KPj4gLi4uDQo+PiBbICAg
IDAuMzI0OTI4XSBDYWxsIHRyYWNlOg0KPj4gWyAgICAwLjMyNDk2OV0gIF9fdWJzYW5faGFu
ZGxlX2NmaV9jaGVja19mYWlsKzB4NTgvMHg2MA0KPj4gWyAgICAwLjMyNTA1M10gIF9fY2Zp
X2NoZWNrX2ZhaWwrMHgzYy8weDQ0DQo+PiBbICAgIDAuMzI1MTIwXSAgX19jZmlfc2xvd3Bh
dGhfZGlhZysweDE3OC8weDIwMA0KPj4gWyAgICAwLjMyNTE5Ml0gIGRybV9zaW1wbGVfa21z
X2NydGNfbW9kZV92YWxpZCsweDU4LzB4ODANCj4+IFsgICAgMC4zMjUyNzldICBfX2RybV9o
ZWxwZXJfdXBkYXRlX2FuZF92YWxpZGF0ZSsweDMxYy8weDQ2NA0KPj4gLi4uDQo+Pg0KPj4g
VGhlIC0+bW9kZV92YWxpZCgpIG1lbWJlciBpbiAnc3RydWN0IGRybV9zaW1wbGVfZGlzcGxh
eV9waXBlX2Z1bmNzJw0KPj4gZXhwZWN0cyBhIHJldHVybiB0eXBlIG9mICdlbnVtIGRybV9t
b2RlX3N0YXR1cycsIG5vdCAnaW50Jy4gQ29ycmVjdCBpdA0KPj4gdG8gZml4IHRoZSBDRkkg
ZmFpbHVyZS4NCj4+DQo+PiBDYzogc3RhYmxlQHZnZXIua2VybmVsLm9yZw0KPj4gRml4ZXM6
IDExZThmNWZkMjIzYiAoImRybTogQWRkIHNpbXBsZWRybSBkcml2ZXIiKQ0KPj4gTGluazog
aHR0cHM6Ly9naXRodWIuY29tL0NsYW5nQnVpbHRMaW51eC9saW51eC9pc3N1ZXMvMTY0Nw0K
Pj4gUmVwb3J0ZWQtYnk6IFRvbWFzeiBQYXdlxYIgR2FqYyA8dHBneHl6QGdtYWlsLmNvbT4N
Cj4+IFNpZ25lZC1vZmYtYnk6IE5hdGhhbiBDaGFuY2VsbG9yIDxuYXRoYW5Aa2VybmVsLm9y
Zz4NCj4+IC0tLQ0KPj4gICBkcml2ZXJzL2dwdS9kcm0vdGlueS9zaW1wbGVkcm0uYyB8IDIg
Ky0NCj4+ICAgMSBmaWxlIGNoYW5nZWQsIDEgaW5zZXJ0aW9uKCspLCAxIGRlbGV0aW9uKC0p
DQo+Pg0KPj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvZ3B1L2RybS90aW55L3NpbXBsZWRybS5j
IGIvZHJpdmVycy9ncHUvZHJtL3Rpbnkvc2ltcGxlZHJtLmMNCj4+IGluZGV4IDc2ODI0MmE3
OGUyYi4uNTQyMjM2MzY5MGU3IDEwMDY0NA0KPj4gLS0tIGEvZHJpdmVycy9ncHUvZHJtL3Rp
bnkvc2ltcGxlZHJtLmMNCj4+ICsrKyBiL2RyaXZlcnMvZ3B1L2RybS90aW55L3NpbXBsZWRy
bS5jDQo+PiBAQCAtNjI3LDcgKzYyNyw3IEBAIHN0YXRpYyBjb25zdCBzdHJ1Y3QgZHJtX2Nv
bm5lY3Rvcl9mdW5jcyBzaW1wbGVkcm1fY29ubmVjdG9yX2Z1bmNzID0gew0KPj4gICAgICAg
ICAgLmF0b21pY19kZXN0cm95X3N0YXRlID0gZHJtX2F0b21pY19oZWxwZXJfY29ubmVjdG9y
X2Rlc3Ryb3lfc3RhdGUsDQo+PiAgIH07DQo+Pg0KPj4gLXN0YXRpYyBpbnQNCj4+ICtzdGF0
aWMgZW51bSBkcm1fbW9kZV9zdGF0dXMNCj4+ICAgc2ltcGxlZHJtX3NpbXBsZV9kaXNwbGF5
X3BpcGVfbW9kZV92YWxpZChzdHJ1Y3QgZHJtX3NpbXBsZV9kaXNwbGF5X3BpcGUgKnBpcGUs
DQo+PiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgY29uc3Qgc3RydWN0
IGRybV9kaXNwbGF5X21vZGUgKm1vZGUpDQo+PiAgIHsNCj4gDQo+IFRoYW5rcyBmb3IgZml4
aW5nIHRoaXMsIE5hdGhhbiEgVGhlIHBhdGNoIGxvb2tzIGNvcnJlY3QgdG8gbWUuDQo+IA0K
PiBSZXZpZXdlZC1ieTogU2FtaSBUb2x2YW5lbiA8c2FtaXRvbHZhbmVuQGdvb2dsZS5jb20+
DQoNClRoYW5rcyBhIGxvdC4gSSd2ZSBhZGRlZCB0aGUgcGF0Y2ggdG8gZHJtLW1pc2MtZml4
ZXMuDQoNCkJlc3QgcmVnYXJkcw0KVGhvbWFzDQoNCj4gDQo+IFNhbWkNCg0KLS0gDQpUaG9t
YXMgWmltbWVybWFubg0KR3JhcGhpY3MgRHJpdmVyIERldmVsb3Blcg0KU1VTRSBTb2Z0d2Fy
ZSBTb2x1dGlvbnMgR2VybWFueSBHbWJIDQpNYXhmZWxkc3RyLiA1LCA5MDQwOSBOw7xybmJl
cmcsIEdlcm1hbnkNCihIUkIgMzY4MDksIEFHIE7DvHJuYmVyZykNCkdlc2Now6RmdHNmw7xo
cmVyOiBJdm8gVG90ZXYNCg==

--------------DMeztSdmW47OO0pR4AMxD1YJ--

--------------SKFncP8NLk0WuC8ZPEwA4780
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEExndm/fpuMUdwYFFolh/E3EQov+AFAmLgCoQFAwAAAAAACgkQlh/E3EQov+Bc
Tw/9H50TvFSe7qFoU2rFqatLpiWndYty9se0fN37IM/B852asCzBl/o5FNbJE2M2CU4hU9t74GlZ
bIOPUJ5yKZAzfFYgqJ2IhwyDvhFMqUxsu7r2P7bcMsSWA+88KfrT1NpKGDdbdsUjfOTCM7TPNaP5
QJf+0j/KbN9vRBqkxLp7ocRNN7Lim7E1Ub/Wullxpg9rQQxWOLZh6pL3mP4gvQybVx/5qQADsd8G
feKN5CIYRxFboTn/wErBmop9lTOy5WLnxuqPws90C2xTKHuDxTr88hlcstUMJQFGS71BWNi0MPQo
K8XVPSo7jXmrGnDYxwqppZGnTo4FjKMhsTTGs6o1cfAr1yCA+OQu0qQLQLKHeVuFvUzVhNeLFlUF
TmNC9zzcoeI6B2Rv+9sgU6gx9kvAPjwFMTTEe+bz2HzwqvQwxoNNHSKEJeAGyayZd9KANn5INAjb
NcnIkTQyM7dzXgWC2gohrHL5yYjhIBrkwq3H0Bcjw1/iQQubxJkDAEIDFEyn30LnAP+IKxT0Vy2J
VHHwWnLJZtUc81e4nI7Gflf1N2GJZAqQoycMrn4ZmLsMb5W7PsNZggakaZlTS86nElIDbdzlqLZz
4i7aIvdLZAbJKJgFDy+l4Wb0GeI8tCOInDDSiXcicnEhFGm3crKD3vIRpfSa/k4SYIYVNVApEl++
e28=
=D0wX
-----END PGP SIGNATURE-----

--------------SKFncP8NLk0WuC8ZPEwA4780--
