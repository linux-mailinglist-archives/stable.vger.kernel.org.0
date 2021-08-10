Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 954283E84D6
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 22:55:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233946AbhHJUzv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 16:55:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:48188 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234556AbhHJUzh (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Aug 2021 16:55:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 42FE561100;
        Tue, 10 Aug 2021 20:55:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628628914;
        bh=lXVCb81Ds/VdhoshPZIHAlr3P7ZKsCBLDSx3SIJXrYw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BdC54j871H68/YQ2QalAxXiBsMwC6eUDQufRWlDZava2qtmjEG5DsLAyHE6lJK0vE
         gvQfwIrqjeIcp6/mxTlmi4vemk6rtmohIEmjZsSzX4ju+0SOjd1DwCi+Qh/S3g5jKP
         K8YicFnZaXBTmrgA0TQv8pEjH2ozaN8+aAVLrrSpqoDqTeod0NaatkdrLViIepGUc6
         Q5r1JLOV+5c0/6a/uxV0yXtd16BFDoOYVQ1ySiZrowCq1nzFlrBf5JZgI9dsBbcK16
         u70Z/s1QFUq1DOe6h5TqGn+9RlzzfgpWjqok17FXe38EEUTEIeRa1uaqVCacAZsM0R
         wp8Y7pjs2mbVw==
Date:   Tue, 10 Aug 2021 22:55:11 +0200
From:   Wolfram Sang <wsa@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH v2] i2c: dev: zero out array used for i2c reads from
 userspace
Message-ID: <YRLnr24IBwe5HS+j@kunai>
Mail-Followup-To: Wolfram Sang <wsa@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        stable <stable@vger.kernel.org>
References: <20210729143532.47240-1-gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="9Swibbr0MaEeP+pe"
Content-Disposition: inline
In-Reply-To: <20210729143532.47240-1-gregkh@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--9Swibbr0MaEeP+pe
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 29, 2021 at 04:35:32PM +0200, Greg Kroah-Hartman wrote:
> If an i2c driver happens to not provide the full amount of data that a
> user asks for, it is possible that some uninitialized data could be sent
> to userspace.  While all in-kernel drivers look to be safe, just be sure
> by initializing the buffer to zero before it is passed to the i2c driver
> so that any future drivers will not have this issue.
>=20
> Also properly copy the amount of data recvieved to the userspace buffer,
> as pointed out by Dan Carpenter.
>=20
> Reported-by: Eric Dumazet <edumazet@google.com>
> Cc: Dan Carpenter <dan.carpenter@oracle.com>
> Cc: stable <stable@vger.kernel.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Fixed checkpatch warning "WARNING: Invalid email format for stable:
'stable <stable@vger.kernel.org>', prefer 'stable@vger.kernel.org' " and
applied to for-current, thanks!


--9Swibbr0MaEeP+pe
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEOZGx6rniZ1Gk92RdFA3kzBSgKbYFAmES568ACgkQFA3kzBSg
KbYTXhAAlT/K3AtvhsnMS3vwbfA+wSr0BYsT6io4lLdFK7t1KZbtTiH08jhSWe0Z
nZrWxmgCGmQ0zHTDJslFzZz2LtuLE/rhSDqz/pW5l1rKfkOSdeATwmvoU/COZ30i
O0Gx9DYR/BFANzOEJa8OGApuGeloah6X/5JDRDCZbqU2ZoLPFzJumkQxk4TesLBq
QwrMXWhl5hsuccfEeEVOuyqpXqkNDCnVgqK1MFqAGawQvMlbiYa5wbn5PR0VKAO0
IVzz9YLIP+fxyssk0IA1NxiJn5aIqVjlW2wfX5Tu3yT8lJAH/11i3MNfwzMO/XvS
7IMr00AafqQkAi6ZRvRpn9G0wWL5twuv+weOuJsDgYqyGGX0KWAugEV9PibSV5n3
4+b8Yb70kwQvAFOz19nBUlIDchVh1Wm8svMJSZO78CGeXmQZLbDfomB0Gvfpjhb8
hsMzl4SNBqvywRVFqtbj9mVDCjtyMyKNZfY9OOo67mT7PcNPhXUJS/xRmP697oom
2/l/Iq07xP54i1gEMLhZcNAChJFOXeKbCzL3z/qduvhgbLyXHzwK8wa9jDizk8Ez
cJ8/nFqa3c9KPrbzst8ql7RNNNHu3DfPslw7rvI52/s8Uqk3Y3DRh5/x9qC6V0j6
N3Awz9C1CFixVkwGbtzcwd3WKOzglqf9X2nd93yQrX2S9Ldry7s=
=8fOf
-----END PGP SIGNATURE-----

--9Swibbr0MaEeP+pe--
