Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB77556D504
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 08:56:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229684AbiGKG4a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 02:56:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbiGKG43 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 02:56:29 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D86CC14013;
        Sun, 10 Jul 2022 23:56:27 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 96ADA2278C;
        Mon, 11 Jul 2022 06:56:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1657522586; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=15Lpxz7m/K0zmimJDOhkk99KZ262WAFilVkSyIFpJJg=;
        b=EG22l+Os5xB7oc2o9ZQykOVm8vboQT6lzZfdTrJ4KKdp5+opfAPk82/1xIMr+SbPlN2Us0
        QPvDy828nFggMq0eTDCbOyCggIsCpiavdEZYRIekAQ4BS8y66Aoqk6XMiV/MlKaZPCoLqP
        SrJPQG3ZdngwqGMwRrXRTnb/LMENQ44=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 6288C13524;
        Mon, 11 Jul 2022 06:56:26 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id LLo3FprJy2JHfAAAMHmgww
        (envelope-from <jgross@suse.com>); Mon, 11 Jul 2022 06:56:26 +0000
Message-ID: <bba1f8da-37c0-2d23-f529-8b2d866e69cf@suse.com>
Date:   Mon, 11 Jul 2022 08:56:25 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH v3] xen/gntdev: Ignore failure to unmap
 INVALID_GRANT_HANDLE
Content-Language: en-US
To:     Demi Marie Obenour <demi@invisiblethingslab.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>
Cc:     xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
References: <20220710230522.1563-1-demi@invisiblethingslab.com>
From:   Juergen Gross <jgross@suse.com>
In-Reply-To: <20220710230522.1563-1-demi@invisiblethingslab.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------HR0G2TUKyxlINMlPASC2HsHD"
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
--------------HR0G2TUKyxlINMlPASC2HsHD
Content-Type: multipart/mixed; boundary="------------FfnGwjMERaMxLXCAN0gshF2I";
 protected-headers="v1"
From: Juergen Gross <jgross@suse.com>
To: Demi Marie Obenour <demi@invisiblethingslab.com>,
 Stefano Stabellini <sstabellini@kernel.org>,
 Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>
Cc: xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
Message-ID: <bba1f8da-37c0-2d23-f529-8b2d866e69cf@suse.com>
Subject: Re: [PATCH v3] xen/gntdev: Ignore failure to unmap
 INVALID_GRANT_HANDLE
References: <20220710230522.1563-1-demi@invisiblethingslab.com>
In-Reply-To: <20220710230522.1563-1-demi@invisiblethingslab.com>

--------------FfnGwjMERaMxLXCAN0gshF2I
Content-Type: multipart/mixed; boundary="------------AHvtRssDqnEsWxYK0zAsGoED"

--------------AHvtRssDqnEsWxYK0zAsGoED
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gMTEuMDcuMjIgMDE6MDUsIERlbWkgTWFyaWUgT2Jlbm91ciB3cm90ZToNCj4gVGhlIGVy
cm9yIHBhdGhzIG9mIGdudGRldl9tbWFwKCkgY2FuIGNhbGwgdW5tYXBfZ3JhbnRfcGFnZXMo
KSBldmVuDQo+IHRob3VnaCBub3QgYWxsIG9mIHRoZSBwYWdlcyBoYXZlIGJlZW4gc3VjY2Vz
c2Z1bGx5IG1hcHBlZC4gIFRoaXMgd2lsbA0KPiB0cmlnZ2VyIHRoZSBXQVJOX09OKClzIGlu
IF9fdW5tYXBfZ3JhbnRfcGFnZXNfZG9uZSgpLiAgVGhlIG51bWJlciBvZg0KPiB3YXJuaW5n
cyBjYW4gYmUgdmVyeSBsYXJnZTsgSSBoYXZlIG9ic2VydmVkIHRob3VzYW5kcyBvZiBsaW5l
cyBvZg0KPiB3YXJuaW5ncyBpbiB0aGUgc3lzdGVtZCBqb3VybmFsLg0KPiANCj4gQXZvaWQg
dGhpcyBwcm9ibGVtIGJ5IG9ubHkgd2FybmluZyBvbiB1bm1hcHBpbmcgZmFpbHVyZSBpZiB0
aGUgaGFuZGxlDQo+IGJlaW5nIHVubWFwcGVkIGlzIG5vdCBJTlZBTElEX0dSQU5UX0hBTkRM
RS4gIFRoZSBoYW5kbGUgZmllbGQgb2YgYW55DQo+IHBhZ2UgdGhhdCB3YXMgbm90IHN1Y2Nl
c3NmdWxseSBtYXBwZWQgd2lsbCBiZSBJTlZBTElEX0dSQU5UX0hBTkRMRSwgc28NCj4gdGhp
cyBjYXRjaGVzIGFsbCBjYXNlcyB3aGVyZSB1bm1hcHBpbmcgY2FuIGxlZ2l0aW1hdGVseSBm
YWlsLg0KPiANCj4gU3VnZ2VzdGVkLWJ5OiBKdWVyZ2VuIEdyb3NzIDxqZ3Jvc3NAc3VzZS5j
b20+DQo+IENjOiBzdGFibGVAdmdlci5rZXJuZWwub3JnDQo+IFNpZ25lZC1vZmYtYnk6IERl
bWkgTWFyaWUgT2Jlbm91ciA8ZGVtaUBpbnZpc2libGV0aGluZ3NsYWIuY29tPg0KPiBGaXhl
czogZGJlOTdjZmY3ZGQ5ICgieGVuL2dudGRldjogQXZvaWQgYmxvY2tpbmcgaW4gdW5tYXBf
Z3JhbnRfcGFnZXMoKSIpDQoNClJldmlld2VkLWJ5OiBKdWVyZ2VuIEdyb3NzIDxqZ3Jvc3NA
c3VzZS5jb20+DQoNCg0KSnVlcmdlbg0K
--------------AHvtRssDqnEsWxYK0zAsGoED
Content-Type: application/pgp-keys; name="OpenPGP_0xB0DE9DD628BF132F.asc"
Content-Disposition: attachment; filename="OpenPGP_0xB0DE9DD628BF132F.asc"
Content-Description: OpenPGP public key
Content-Transfer-Encoding: quoted-printable

-----BEGIN PGP PUBLIC KEY BLOCK-----

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
jR/i1DG86lem3iBDXzXsZDn8R38=3D
=3D2wuH
-----END PGP PUBLIC KEY BLOCK-----

--------------AHvtRssDqnEsWxYK0zAsGoED--

--------------FfnGwjMERaMxLXCAN0gshF2I--

--------------HR0G2TUKyxlINMlPASC2HsHD
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsB5BAABCAAjFiEEhRJncuj2BJSl0Jf3sN6d1ii/Ey8FAmLLyZoFAwAAAAAACgkQsN6d1ii/Ey9f
KQf/W7zjk+LXMrWE/S19874/suItM4FQcKcLzdhBb5qFpObCR+bp1Mzgba1u+nOSeFvrR0Sda+Wo
z1IvYewJ9/D4b5Lz1GXCNXBqL9PtTISn2aI61qPbA+s5Uo5yBr5bJiKah3GOqeunscsEtnbliFtL
bn5rhhxVLruKScJgHxpxqPzGmRwHtESkMqS4ctJ+ACPZnQOnc7zteJR9UmSStl6GPzVsV1j15wbn
/0ESdpnEYS7sPuIJ5cHluUTL2KdrBC6py51k2tejWgMJYYvQ2u5wGG96HLaO5qgU0JfXIFsgrfBh
iEl/ENtMn2x6W5Xrvp89Fw6/U/t99BefPzw5ZkZUig==
=mJgN
-----END PGP SIGNATURE-----

--------------HR0G2TUKyxlINMlPASC2HsHD--
