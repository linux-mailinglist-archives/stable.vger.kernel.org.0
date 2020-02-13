Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D39ED15BC25
	for <lists+stable@lfdr.de>; Thu, 13 Feb 2020 10:53:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729459AbgBMJxX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Feb 2020 04:53:23 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:39438 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729440AbgBMJxW (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Feb 2020 04:53:22 -0500
Received: from 1.general.smb.uk.vpn ([10.172.193.28])
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <stefan.bader@canonical.com>)
        id 1j2BBQ-0005Dm-FC; Thu, 13 Feb 2020 09:53:20 +0000
Subject: Re: Backports 4.14, 4.9, 4.4: dm: fix potential for
 q->make_request_fn NULL pointer
From:   Stefan Bader <stefan.bader@canonical.com>
To:     stable@vger.kernel.org, snitzer@redhat.com
References: <20200213094928.30487-1-stefan.bader@canonical.com>
Autocrypt: addr=stefan.bader@canonical.com; prefer-encrypt=mutual; keydata=
 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
 2Iat+yfjuNhlNAJs
Message-ID: <d7452285-87ee-335e-f214-4b88e13c5ba8@canonical.com>
Date:   Thu, 13 Feb 2020 10:53:12 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200213094928.30487-1-stefan.bader@canonical.com>
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="UeAGFHBoPz5T4ugW9qFua017fTPoHVNQf"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--UeAGFHBoPz5T4ugW9qFua017fTPoHVNQf
Content-Type: multipart/mixed; boundary="ZldwD5q9477hdj0L5VZOYCHjONS2c2qaR"

--ZldwD5q9477hdj0L5VZOYCHjONS2c2qaR
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 13.02.20 10:49, Stefan Bader wrote:
> Following are the backports into the 3 stable trees mentioned. Unfortun=
ately
> context required ajustments for each tree. Mike, I would appreciate if =
you
> could glance over those to double check. Thanks.
>=20
> -Stefan
>=20
Something went wrong sending this the first time and ate the 4.4.y backpo=
rt. I
am re-sending the whole batch.

-Stefan



--ZldwD5q9477hdj0L5VZOYCHjONS2c2qaR--

--UeAGFHBoPz5T4ugW9qFua017fTPoHVNQf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEE2118yvOZTjOV2k0+6Gdd7svuzqMFAl5FHI8ACgkQ6Gdd7svu
zqPE4hAAwVqRXoUN6cjMOuKVu2I2SCDmX8k5PI+i5okx7CyP58Z0gbeuXq0dFUVZ
Y5IDybZ8Upg8qFQl2WnOhLWzvsrj8ManXr4lqJl6ucf/SXoq4NsEqreu7NCLT6N+
qtXptoMBfxWMNtcIxbnxkj0whWmthjvQIu8zz84GQaUDJ4JorB4JnUcCT/Qu5lJH
jKVnBIkVho++tIOopUM6XS3zEO0qnWgHkpC89oZGpqd+6gWZ9IpVRn73mJ9bcvPY
65V46hhqfNluDI6g+tD0F8K0TApH3sAs+A2KFzPflG4IHX1nVLfFQJUdNSTvSzfI
PP2Qrq5OJSwdQa3bv4ADaLOL6WtqzckZIAMC3ACsL1wVFbnwyqo/wqeg75ffK7sk
BWQysrmMtWFcDvRJjlipa2JBq+WX2STmoc+pSjYqdaD+krGVbPkOXjaqpXRG4qSQ
1NVjY69VAeaN6qDOZAmCEKFyfp8wFsGQRtG28qz5ekAuCS/C1h29sRGEzGlBbxwe
qtN23bZXwro7/5WNLj0QoypDKR6BNwWp5OMq4rr576intyEHFJkSHytpu5qnZ6QZ
ZVnutraYuBWIWiszECU7I+2FrtPhuxuNqKSv9QU1ULUbab8+Xf60ge+m7rrn7xRG
41zYuCpKMcyTk0oRrdqQMCOGf+igx7+VllHzZUne/9isih8oRe4=
=GmxA
-----END PGP SIGNATURE-----

--UeAGFHBoPz5T4ugW9qFua017fTPoHVNQf--
