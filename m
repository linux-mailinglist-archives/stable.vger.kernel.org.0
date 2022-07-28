Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2219583BB0
	for <lists+stable@lfdr.de>; Thu, 28 Jul 2022 12:04:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234971AbiG1KEx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Jul 2022 06:04:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234721AbiG1KEw (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 28 Jul 2022 06:04:52 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E42116172E;
        Thu, 28 Jul 2022 03:04:51 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 78964352FB;
        Thu, 28 Jul 2022 10:04:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1659002690; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=rAjMGFetxknKAp3P1Zsa1MsyfL4VONX+33JH2YlbvgU=;
        b=f8RdGUGzYwDu47BoQKj5FysDAuhbttPDUSAMNBOb88RUSVl+a/8PwOVxARx0YrmbMlEzfU
        1jib+its8F83s5W/vljKKuG2UP1WSF9L9jpBr77pP0eazU4VFZxPxFayIEv3w7jyNXIyCb
        vCdBnQzNFL+v/ewSR4jxK5wuhSloveQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1659002690;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=rAjMGFetxknKAp3P1Zsa1MsyfL4VONX+33JH2YlbvgU=;
        b=q1wwJNd4zV0O7tH1Gt+Uiz1PSRzeUy2pUEGcyxfFHmYpzLx3itLNNDWCPlgWE0UoGYQPaY
        w3ZKxE4b3uy/RHAw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 05DC513A7E;
        Thu, 28 Jul 2022 10:04:49 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id F/uHO0Ff4mLUXgAAMHmgww
        (envelope-from <jslaby@suse.cz>); Thu, 28 Jul 2022 10:04:49 +0000
Message-ID: <137f3701-99e7-c73d-5993-52f3299171e5@suse.cz>
Date:   Thu, 28 Jul 2022 12:04:45 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH 5.18 000/158] 5.18.15-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
References: <20220727161021.428340041@linuxfoundation.org>
From:   Jiri Slaby <jslaby@suse.cz>
In-Reply-To: <20220727161021.428340041@linuxfoundation.org>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------ZjwzbGp81QnI3L0C02XoW0tc"
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_SOFTFAIL autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------ZjwzbGp81QnI3L0C02XoW0tc
Content-Type: multipart/mixed; boundary="------------Ju0X5dHOCd8k3xyvaOTMbwxO";
 protected-headers="v1"
From: Jiri Slaby <jslaby@suse.cz>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 linux-kernel@vger.kernel.org
Cc: stable@vger.kernel.org, torvalds@linux-foundation.org,
 akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
 patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
 jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
 slade@sladewatkins.com
Message-ID: <137f3701-99e7-c73d-5993-52f3299171e5@suse.cz>
Subject: Re: [PATCH 5.18 000/158] 5.18.15-rc1 review
References: <20220727161021.428340041@linuxfoundation.org>
In-Reply-To: <20220727161021.428340041@linuxfoundation.org>

--------------Ju0X5dHOCd8k3xyvaOTMbwxO
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gMjcuIDA3LiAyMiwgMTg6MTEsIEdyZWcgS3JvYWgtSGFydG1hbiB3cm90ZToNCj4gVGhp
cyBpcyB0aGUgc3RhcnQgb2YgdGhlIHN0YWJsZSByZXZpZXcgY3ljbGUgZm9yIHRoZSA1LjE4
LjE1IHJlbGVhc2UuDQo+IFRoZXJlIGFyZSAxNTggcGF0Y2hlcyBpbiB0aGlzIHNlcmllcywg
YWxsIHdpbGwgYmUgcG9zdGVkIGFzIGEgcmVzcG9uc2UNCj4gdG8gdGhpcyBvbmUuICBJZiBh
bnlvbmUgaGFzIGFueSBpc3N1ZXMgd2l0aCB0aGVzZSBiZWluZyBhcHBsaWVkLCBwbGVhc2UN
Cj4gbGV0IG1lIGtub3cuDQo+IA0KPiBSZXNwb25zZXMgc2hvdWxkIGJlIG1hZGUgYnkgRnJp
LCAyOSBKdWwgMjAyMiAxNjowOTo1MCArMDAwMC4NCj4gQW55dGhpbmcgcmVjZWl2ZWQgYWZ0
ZXIgdGhhdCB0aW1lIG1pZ2h0IGJlIHRvbyBsYXRlLg0KPiANCj4gVGhlIHdob2xlIHBhdGNo
IHNlcmllcyBjYW4gYmUgZm91bmQgaW4gb25lIHBhdGNoIGF0Og0KPiAJaHR0cHM6Ly93d3cu
a2VybmVsLm9yZy9wdWIvbGludXgva2VybmVsL3Y1Lngvc3RhYmxlLXJldmlldy9wYXRjaC01
LjE4LjE1LXJjMS5neg0KPiBvciBpbiB0aGUgZ2l0IHRyZWUgYW5kIGJyYW5jaCBhdDoNCj4g
CWdpdDovL2dpdC5rZXJuZWwub3JnL3B1Yi9zY20vbGludXgva2VybmVsL2dpdC9zdGFibGUv
bGludXgtc3RhYmxlLXJjLmdpdCBsaW51eC01LjE4LnkNCj4gYW5kIHRoZSBkaWZmc3RhdCBj
YW4gYmUgZm91bmQgYmVsb3cuDQoNCm9wZW5TVVNFIGNvbmZpZ3PCueKBviBhbGwgZ3JlZW4u
DQoNClRlc3RlZC1ieTogSmlyaSBTbGFieSA8amlyaXNsYWJ5QGtlcm5lbC5vcmc+DQoNCsK5
4oG+IGFybXY2aGwgYXJtdjdobCBhcm02NCBpMzg2IHBwYzY0IHBwYzY0bGUgcmlzY3Y2NCBz
MzkweCB4ODZfNjQNCg0KLS0gDQpqcw0Kc3VzZSBsYWJzDQo=

--------------Ju0X5dHOCd8k3xyvaOTMbwxO--

--------------ZjwzbGp81QnI3L0C02XoW0tc
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEE1pWBVg1LlveO4uo2vSWxBAa0cEkFAmLiXz0ACgkQvSWxBAa0
cEkK5w/+K7YHk0pw6DQ6MAvkb9bwjtdjZH6J+/PO6buM1KWKBottGV9inPgZSttQ
o329eYMi0VNJ2hgbbLrCnjMiQ5zwKZqw1SEjBAIDKNzGxvkxL4b13xJyB4wGHkmd
Dw1k0wjs7te6Jj+uVwtsC1e+7hLHoTSRakNKzbbUlHevS+tZl2+u38kt9FhivmxY
irdaOtJh+aenS15CMDam5vNvbtTsNxtKpqrSpUJBwdN3SqJiU2zYFHmHAV29n8bB
n2XUySRyF/DJRQmmZa2Sk6/ivG+oxPKXBqPStG/mfiXnucVkWyBiwafKBmMzuAgR
XkrPAaD66tP6QbcwhtdcYPsybEl31QarlGQNl6jZJ6XbjwRmxpgmJBT4Tv67Tz3D
nVs0s6QFTOU4Bb4qNuVPr1KKgOwvVOtKvoDhRFc3mXdmzsO3XVGWtq6s7l+xw3K2
NjxTaPTfVWPOCFTO1DXt7lnJLStctqbij3YU+jTWoVoKq9cdqNG9qyrNXr0sl58o
z9RLYDCO+Tz1hCOAyxtXEYEarc9VM08e/tKtkEZAl24ecr5vROyMcpNeYM/b/LVD
7KNFq/FiMPPEzRLC+tx1f1Xx8B9SGEeO2t6ATEK0tjlOClH4Sx+THY03Hh1d7P0z
zDgUjVelhitovTKDduA2L5k8aO61ykNonMDEmvHMp7JOb3AVaNk=
=tqVH
-----END PGP SIGNATURE-----

--------------ZjwzbGp81QnI3L0C02XoW0tc--
