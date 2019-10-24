Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9B45BE3C05
	for <lists+stable@lfdr.de>; Thu, 24 Oct 2019 21:32:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406102AbfJXTcc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Oct 2019 15:32:32 -0400
Received: from heliosphere.sirena.org.uk ([172.104.155.198]:55344 "EHLO
        heliosphere.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405801AbfJXTcc (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 24 Oct 2019 15:32:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sirena.org.uk; s=20170815-heliosphere; h=In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=vttDbr1v3prfmmWDLzJK+9NKCnOd94v+/MHN5g7eafo=; b=CbE96/yh2YdFVA3lDo3rtgUW1
        1nKGHL5oUytt+gNKSOzQltYdAVrbAYGCVdJRDWR5ElYjyGcNuSfoi39rOSctuCSd82zqjizgevvl/
        RItWIKeeCoaAlflHirdSRmTem7K9x/GW5JqAO0MdF/ne4ysAJoQm40sjHSG8N3Yunv5xU=;
Received: from cpc102320-sgyl38-2-0-cust46.18-2.cable.virginm.net ([82.37.168.47] helo=ypsilon.sirena.org.uk)
        by heliosphere.sirena.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <broonie@sirena.co.uk>)
        id 1iNiqP-0003zz-Rk; Thu, 24 Oct 2019 19:32:25 +0000
Received: by ypsilon.sirena.org.uk (Postfix, from userid 1000)
        id 55273274293C; Thu, 24 Oct 2019 20:32:25 +0100 (BST)
Date:   Thu, 24 Oct 2019 20:32:25 +0100
From:   Mark Brown <broonie@kernel.org>
To:     Gregory CLEMENT <gregory.clement@bootlin.com>
Cc:     linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Ludovic Desroches <ludovic.desroches@microchip.com>,
        linux-arm-kernel@lists.infradead.org,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        "kernelci.org bot" <bot@kernelci.org>, stable@vger.kernel.org
Subject: Re: [PATCH] spi: Fix NULL pointer when setting SPI_CS_HIGH for GPIO
 CS
Message-ID: <20191024193225.GM46373@sirena.co.uk>
References: <20191024141309.22434-1-gregory.clement@bootlin.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="0+35XlDF45POFHfm"
Content-Disposition: inline
In-Reply-To: <20191024141309.22434-1-gregory.clement@bootlin.com>
X-Cookie: Filmed before a live audience.
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--0+35XlDF45POFHfm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 24, 2019 at 04:13:09PM +0200, Gregory CLEMENT wrote:
> Even if the flag use_gpio_descriptors is set, it is possible that
> cs_gpiods was not allocated, which leads to a kernel crash:
>=20
> Unable to handle kernel NULL pointer dereference at virtual address 00000=
000
> pgd =3D (ptrval)
> [00000000] *pgd=3D00000000
> Internal error: Oops: 5 [#1] ARM
> Modules linked in:
> CPU: 0 PID: 1 Comm: swapper Tainted: G        W         5.4.0-rc3 #1
> Hardware name: NVIDIA Tegra SoC (Flattened Device Tree)
> PC is at of_register_spi_device+0x20c/0x38c
> LR is at __of_find_property+0x3c/0x60
> pc : [<c09b45dc>]    lr : [<c0c47a98>]    psr: 20000013

Please think hard before including complete backtraces in upstream
reports, they are very large and contain almost no useful information
relative to their size so often obscure the relevant content in your
message. If part of the backtrace is usefully illustrative then it's
usually better to pull out the relevant sections.

--0+35XlDF45POFHfm
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAl2x/EgACgkQJNaLcl1U
h9Dc+Qf7BOBELW73o6MOZxD5Uq2/Eahp26z5rN7PMc+EvRwda/BzHGhUTsTrotmX
ppdm6tsBosW3dH8P6tbwXIIJHO11BO4ma/pbO5ZZloEqeo3Zvxt89+AxZD4roa26
GEnDMWLNn2Y3L0YENJzNelC3RMBY7sIv7wMgiGZR7qadTFrx6Y3v+VLAEEEsSnA6
f3AmuiyCWtiNyuhi1gIst/hGeDzLyNOGVJuNfH7SV4RbQVN51k9Cam5JEaBB6NjK
PTKDGt0u2CGaKQxTZRHb8al+SznFqEk0eKU06KEWpdcPJAOPW24cLVXl2YAb6b2l
yg1Wz4gE+9D908qKFUl3e+fimC6N+A==
=pES0
-----END PGP SIGNATURE-----

--0+35XlDF45POFHfm--
