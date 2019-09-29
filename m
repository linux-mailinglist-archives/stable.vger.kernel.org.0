Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 058F5C17D8
	for <lists+stable@lfdr.de>; Sun, 29 Sep 2019 19:40:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729162AbfI2RkL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Sep 2019 13:40:11 -0400
Received: from mx2.mailbox.org ([80.241.60.215]:33536 "EHLO mx2.mailbox.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730266AbfI2RkG (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Sep 2019 13:40:06 -0400
Received: from smtp2.mailbox.org (smtp1.mailbox.org [IPv6:2001:67c:2050:105:465:1:1:0])
        (using TLSv1.2 with cipher ECDHE-RSA-CHACHA20-POLY1305 (256/256 bits))
        (No client certificate requested)
        by mx2.mailbox.org (Postfix) with ESMTPS id 8D7E2A1BDC;
        Sun, 29 Sep 2019 19:40:00 +0200 (CEST)
X-Virus-Scanned: amavisd-new at heinlein-support.de
Received: from smtp2.mailbox.org ([80.241.60.240])
        by spamfilter01.heinlein-hosting.de (spamfilter01.heinlein-hosting.de [80.241.56.115]) (amavisd-new, port 10030)
        with ESMTP id RUpa3_VXc25g; Sun, 29 Sep 2019 19:39:55 +0200 (CEST)
Subject: Re: [PATCH AUTOSEL 5.2 17/42] MIPS: lantiq: update the clock alias'
 for the mainline PCIe PHY driver
To:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Paul Burton <paul.burton@mips.com>, linux-mips@vger.kernel.org,
        devicetree@vger.kernel.org, john@phrozen.org, kishon@ti.com,
        ralf@linux-mips.org, robh+dt@kernel.org, mark.rutland@arm.com,
        ms@dev.tdt.de
References: <20190929173244.8918-1-sashal@kernel.org>
 <20190929173244.8918-17-sashal@kernel.org>
From:   Hauke Mehrtens <hauke@hauke-m.de>
Openpgp: preference=signencrypt
Autocrypt: addr=hauke@hauke-m.de; keydata=
 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
Message-ID: <fe9161b3-2402-e5a8-959b-63c807be3e08@hauke-m.de>
Date:   Sun, 29 Sep 2019 19:39:49 +0200
MIME-Version: 1.0
In-Reply-To: <20190929173244.8918-17-sashal@kernel.org>
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="vqoTqJDMAjIg6ueVBxDecZGi6pvZH2A4r"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--vqoTqJDMAjIg6ueVBxDecZGi6pvZH2A4r
Content-Type: multipart/mixed; boundary="tCCip87R52w8X4Q5c7TDn45CxU5mAHeAK";
 protected-headers="v1"
From: Hauke Mehrtens <hauke@hauke-m.de>
To: Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
Cc: Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
 Paul Burton <paul.burton@mips.com>, linux-mips@vger.kernel.org,
 devicetree@vger.kernel.org, john@phrozen.org, kishon@ti.com,
 ralf@linux-mips.org, robh+dt@kernel.org, mark.rutland@arm.com, ms@dev.tdt.de
Message-ID: <fe9161b3-2402-e5a8-959b-63c807be3e08@hauke-m.de>
Subject: Re: [PATCH AUTOSEL 5.2 17/42] MIPS: lantiq: update the clock alias'
 for the mainline PCIe PHY driver
References: <20190929173244.8918-1-sashal@kernel.org>
 <20190929173244.8918-17-sashal@kernel.org>
In-Reply-To: <20190929173244.8918-17-sashal@kernel.org>

--tCCip87R52w8X4Q5c7TDn45CxU5mAHeAK
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 9/29/19 7:32 PM, Sasha Levin wrote:
> From: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
>=20
> [ Upstream commit ed90302be64a53d9031c8ce05428c358b16a5d96 ]
>=20
> The mainline PCIe PHY driver has it's own devicetree node. Update the
> clock alias so the mainline driver finds the clocks.
>=20
> The first PCIe PHY is located at 0x1f106800 and exists on VRX200, ARX30=
0
> and GRX390.
> The second PCIe PHY is located at 0x1f700400 and exists on ARX300 and
> GRX390.
> The third PCIe PHY is located at 0x1f106a00 and exists onl on GRX390.
> Lantiq's board support package (called "UGW") names these registers
> "PDI".
>=20
> Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>=

> Signed-off-by: Paul Burton <paul.burton@mips.com>
> Cc: linux-mips@vger.kernel.org
> Cc: devicetree@vger.kernel.org
> Cc: john@phrozen.org
> Cc: kishon@ti.com
> Cc: ralf@linux-mips.org
> Cc: robh+dt@kernel.org
> Cc: linux-kernel@vger.kernel.org
> Cc: hauke@hauke-m.de
> Cc: mark.rutland@arm.com
> Cc: ms@dev.tdt.de
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  arch/mips/lantiq/xway/sysctrl.c | 16 ++++++++--------
>  1 file changed, 8 insertions(+), 8 deletions(-)

Hi Sasha,

This change only makes sense with the new upstream PCIe phy driver which
was added to kernel 5.4 [0], older kernel versions do not have this PCIe
PHY driver. I would not backport these changes to older kernel versions.

[0]: https://git.kernel.org/linus/e52a632195bf43d1a91ae699e7536a6ead736aa=
7

Hauke


--tCCip87R52w8X4Q5c7TDn45CxU5mAHeAK--

--vqoTqJDMAjIg6ueVBxDecZGi6pvZH2A4r
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEyz0/uAcd+JwXmwtD8bdnhZyy68cFAl2Q7GUACgkQ8bdnhZyy
68cvowgAll6A19TIk6q/0VGvrhPBHP0XaBlVjuzvZjgKHGmrmViFb8fesc2v6i6r
KqJ3y9WX2Y2nhxNXQYTC16moUp2uDFASAWZNfQScUg01hIuLKe04CDqHGPWv3rc3
qHYNxUR9nMZojXormiaRIt0t3zGQ5LXSMSb+6hN9Bils2o8aAduI8qPJX09wecg8
dpRj70JZyRyZvESXaCzfJEB8DNNGJhx31m7gz0IKTEM9oKp4AUvKxeoAUw1Kgli4
KDHjfCY5KyYXVaF6sUbprBmULWtOICj5Vr9mJ+EB7uI5vkT90QmtlZ1koEIKd6SN
hogxu60ae+dR7jJaEFPp087Y3ne5Yg==
=jZKA
-----END PGP SIGNATURE-----

--vqoTqJDMAjIg6ueVBxDecZGi6pvZH2A4r--
