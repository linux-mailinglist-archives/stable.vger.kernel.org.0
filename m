Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61BCB2FB31D
	for <lists+stable@lfdr.de>; Tue, 19 Jan 2021 08:36:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730607AbhASHgQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jan 2021 02:36:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:57930 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730671AbhASHWf (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Jan 2021 02:22:35 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 832DA23120;
        Tue, 19 Jan 2021 07:21:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611040915;
        bh=v4ZXRANqxTm8AXgrGw8/I95EBx658quDLQ3wvEBtIkM=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=kkoJlXa//Fa0VXJ/TCwnwTmRS1iHefbjfRFqDzj7u0fjGIRJJRVgHPuoWaxR+uMEh
         uviOBCAWITQec0Dmu6jzgeulGq5L+DF4v8Q3uDXrAw/NcdH5UT2TEHBNno0rLWc9U3
         1YNNWZxhawWzNe1ILnRSrECnOTKu2Ez0/SY9tKK4Q8QqulrRtjghzSROS0Vlveqtoi
         uGpmaS5xRo7WtPxOiECuYdZX4agzJbhdCQ9q7fBL3uZGZCW36jVRCNjszFiUfiR9oU
         ULd6ronQ6i9rNViTh3pJoFzFTgDeAZo5xK+mDIzoXgvHoPvLFXBoHJLltGakkjmms/
         q1MTiWetmjG0w==
From:   Felipe Balbi <balbi@kernel.org>
To:     Patrik Jakobsson <patrik.r.jakobsson@gmail.com>,
        linux-usb@vger.kernel.org
Cc:     Patrik Jakobsson <patrik.r.jakobsson@gmail.com>,
        Al Cooper <alcooperx@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Subject: Re: [PATCH] usb: bdc: Make bdc pci driver depend on BROKEN
In-Reply-To: <20210118203615.13995-1-patrik.r.jakobsson@gmail.com>
References: <20210118203615.13995-1-patrik.r.jakobsson@gmail.com>
Date:   Tue, 19 Jan 2021 09:21:48 +0200
Message-ID: <87eeihv1bn.fsf@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Patrik Jakobsson <patrik.r.jakobsson@gmail.com> writes:

> The bdc pci driver is going to be removed due to it not existing in the
> wild. This patch turns off compilation of the driver so that stable
> kernels can also pick up the change. This helps the out-of-tree
> facetimehd webcam driver as the pci id conflicts with bdc.
>
> Cc: Al Cooper <alcooperx@gmail.com>
> Cc: Felipe Balbi <balbi@kernel.org>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Patrik Jakobsson <patrik.r.jakobsson@gmail.com>

Acked-by: Felipe Balbi <balbi@kernel.org>

=2D-=20
balbi

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQJFBAEBCAAvFiEElLzh7wn96CXwjh2IzL64meEamQYFAmAGiIwRHGJhbGJpQGtl
cm5lbC5vcmcACgkQzL64meEamQbq7Q//VajGAsA55jEf/5NV/P8Zg9rbaDtoTNE6
GvmISo1+2p/H28TgvVAJ5e83f2aT+ejYWQthpMAO1J1S4p9rXCtmAFp37U/8nIdi
xBKSwA0PeE5DkKvbVPARnb/5GiB4Keruj6w+Ejo7VT+gRu0VWLNv9KT6xB0spQVa
EnpC9CaDWaV3S62zyXtrLFtWto2FVomezAYWEgk0h+ky3QJHUzhhFdo+4+hYkI20
QB5xxPxU2heGbqxSJSb8rCU2qe3l3HW3Jg+vwxVKwJu3/i38qJhltviyOfkwPwr/
a2VtlLocxe7aMjX1NwtU3E+36lZ6eqByPNMPySeAo14hUSBWEq7+CYELv+G/PSR5
JENhL1r4Wwp9lsibcK3vZrmuSldmnFLXyd4hqlJYkcnPYfW5MdlzekyOPSRjONlV
DBEqoMVQUNphjIh0xZ+p9JLLMOWDcKK+NHSXJcGXpy726sp8fMa42Ok1Bx+DDHYa
kzT7OUIWKCslshd7q2IlsZyQ5vzXdPYEMWsdfnLs0qH6+wMzkUgV7PhnMNMw5z1+
+Uf03ybGUgcn4I1qZF/g0auiOPj35Ntd3gVHRBFqq0DF0iqI0fdCGXnc1gzH677Q
poLyUase0PSwwiNqzTr4oTQ9ZWUZfPMnB5A8lLlc8wIKpS6AV4u8Da0yywvPMOEF
BDGbkDBUpyE=
=XwzK
-----END PGP SIGNATURE-----
--=-=-=--
