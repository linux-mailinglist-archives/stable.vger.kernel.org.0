Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C808186A61
	for <lists+stable@lfdr.de>; Mon, 16 Mar 2020 12:51:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730899AbgCPLvA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Mar 2020 07:51:00 -0400
Received: from foss.arm.com ([217.140.110.172]:46802 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730882AbgCPLvA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Mar 2020 07:51:00 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DD1D330E;
        Mon, 16 Mar 2020 04:50:59 -0700 (PDT)
Received: from localhost (unknown [10.37.6.21])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5FF693F52E;
        Mon, 16 Mar 2020 04:50:59 -0700 (PDT)
Date:   Mon, 16 Mar 2020 11:50:57 +0000
From:   Mark Brown <broonie@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Vignesh Raghavendra <vigneshr@ti.com>,
        linux-spi@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.5 01/41] spi: spi-omap2-mcspi: Handle DMA size
 restriction on AM65x
Message-ID: <20200316115057.GB5010@sirena.org.uk>
References: <20200316023319.749-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="mxv5cy4qt+RJ9ypb"
Content-Disposition: inline
In-Reply-To: <20200316023319.749-1-sashal@kernel.org>
X-Cookie: I thought YOU silenced the guard!
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--mxv5cy4qt+RJ9ypb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Mar 15, 2020 at 10:32:39PM -0400, Sasha Levin wrote:
> From: Vignesh Raghavendra <vigneshr@ti.com>
>=20
> [ Upstream commit e4e8276a4f652be2c7bb783a0155d4adb85f5d7d ]
>=20
> On AM654, McSPI can only support 4K - 1 bytes per transfer when DMA is
> enabled. Therefore populate master->max_transfer_size callback to
> inform client drivers of this restriction when DMA channels are
> available.

As ever this only provides information to other drivers which may be
buggy.

--mxv5cy4qt+RJ9ypb
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAl5vaCEACgkQJNaLcl1U
h9Dyuwf/fRi4iGdV1A9vW0+wTm8Pznka9n9+PoM5TuqyP0qrul8iIK7h/H6xS7bF
wRQVfQDzo/SfuONZlUUZOvtQXevqHPOtFl2x3Qe1sVnE39byJc6qu/EDsrNYVLgg
DLzo+493Fh+HQgfAb+b80kh9XbZ4rN0qSsyPpt7Ygqj8EpG/so3qCir1BtkKBYAx
nVN/HglbGLu0VosqwfRzpUSgPp0mQlVVhrBX3eyL62c3GQ3+R2Fk9namhq4GYNDv
rcKj4Fi/WhkKOIzmjwPtep6I4uY5ZnM6XVFxa1KuM2p7NVMWlvSZhdn2wvWR0kOr
+dB4D+JEBdndXoBkq3Ywisrppx4JNQ==
=73L/
-----END PGP SIGNATURE-----

--mxv5cy4qt+RJ9ypb--
