Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0370373115
	for <lists+stable@lfdr.de>; Tue,  4 May 2021 21:55:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232636AbhEDT4N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 May 2021 15:56:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232582AbhEDT4N (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 May 2021 15:56:13 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37A98C061574
        for <stable@vger.kernel.org>; Tue,  4 May 2021 12:55:18 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1le18K-0000rY-Fw; Tue, 04 May 2021 21:55:04 +0200
Received: from pengutronix.de (unknown [IPv6:2a03:f580:87bc:d400:4880:7cee:6dec:c8f9])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 26BE661BF76;
        Tue,  4 May 2021 19:55:00 +0000 (UTC)
Date:   Tue, 4 May 2021 21:54:59 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     kernel test robot <lkp@intel.com>
Cc:     Schrempf Frieder <frieder.schrempf@kontron.de>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Timo =?utf-8?B?U2NobMO8w59sZXI=?= <schluessler@krause.de>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Tim Harvey <tharvey@gateworks.com>, kbuild-all@lists.01.org,
        clang-built-linux@googlegroups.com, stable@vger.kernel.org,
        linux-can@vger.kernel.org
Subject: Re: [PATCH] can: mcp251x: Fix resume from sleep before interface was
 brought up
Message-ID: <20210504195459.hqa65mwiuyzwks4t@pengutronix.de>
References: <bd466d82-db03-38b1-0a13-86aa124680ea@kontron.de>
 <202105050327.Ryh9Vqhg-lkp@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="yjdvkhwb7e4yt662"
Content-Disposition: inline
In-Reply-To: <202105050327.Ryh9Vqhg-lkp@intel.com>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: stable@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--yjdvkhwb7e4yt662
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 05.05.2021 03:25:57, kernel test robot wrote:
> Hi Schrempf,
>=20
> Thank you for the patch! Perhaps something to improve:
>=20
> [auto build test WARNING on mkl-can-next/testing]
> [also build test WARNING on v5.12 next-20210504]
> [If your patch is applied to the wrong git tree, kindly drop us a note.
> And when submitting patch, we suggest to use '--base' as documented in
> https://git-scm.com/docs/git-format-patch]
>=20
> url:    https://github.com/0day-ci/linux/commits/Schrempf-Frieder/can-mcp=
251x-Fix-resume-from-sleep-before-interface-was-brought-up/20210505-000504
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can-nex=
t.git testing
> config: x86_64-randconfig-r012-20210503 (attached as .config)
> compiler: clang version 13.0.0 (https://github.com/llvm/llvm-project 8f5a=
2a5836cc8e4c1def2bdeb022e7b496623439)
> reproduce (this is a W=3D1 build):
>         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbi=
n/make.cross -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         # install x86_64 cross compiling tool for clang build
>         # apt-get install binutils-x86-64-linux-gnu
>         # https://github.com/0day-ci/linux/commit/a6e3fbb55cde65e2254ce03=
51b92997d14724726
>         git remote add linux-review https://github.com/0day-ci/linux
>         git fetch --no-tags linux-review Schrempf-Frieder/can-mcp251x-Fix=
-resume-from-sleep-before-interface-was-brought-up/20210505-000504
>         git checkout a6e3fbb55cde65e2254ce0351b92997d14724726
>         # save the attached .config to linux build tree
>         COMPILER_INSTALL_PATH=3D$HOME/0day COMPILER=3Dclang make.cross W=
=3D1 ARCH=3Dx86_64=20
>=20
> If you fix the issue, kindly add following tag as appropriate
> Reported-by: kernel test robot <lkp@intel.com>
>=20
> All warnings (new ones prefixed by >>):
>=20
> >> drivers/net/can/spi/mcp251x.c:1244:1: warning: unused label 'out_clean=
' [-Wunused-label]
>    out_clean:
>    ^~~~~~~~~~

Thanks, I'll squash that into the original patch.

>    drivers/net/can/spi/mcp251x.c:1335:17: warning: cast to smaller intege=
r type 'enum mcp251x_model' from 'const void *' [-Wvoid-pointer-to-enum-cas=
t]
>                    priv->model =3D (enum mcp251x_model)match;
>                                  ^~~~~~~~~~~~~~~~~~~~~~~~~

This is technically correct, but we only put the enum into the struct
of_device_id:

| static const struct of_device_id mcp251x_of_match[] =3D {
| 	{
| 		.compatible	=3D "microchip,mcp2510",
| 		.data		=3D (void *)CAN_MCP251X_MCP2510,
| 	},
| 	{
| 		.compatible	=3D "microchip,mcp2515",
| 		.data		=3D (void *)CAN_MCP251X_MCP2515,
| 	},
| 	{
| 		.compatible	=3D "microchip,mcp25625",
| 		.data		=3D (void *)CAN_MCP251X_MCP25625,
| 	},
| 	{ }
| };

An intermediate cast to kernel_ulong_t silences the warning:

| -               priv->model =3D (enum mcp251x_model)match;
| +               priv->model =3D (enum mcp251x_model)(kernel_ulong_t)match;

I'll send a patch.

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--yjdvkhwb7e4yt662
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAmCRpo8ACgkQqclaivrt
76losggAmbsH6qsCEOrIajF05YFCLKleh64N+f5ZKdWYdALhhl3IsiyxoIStEvsj
vuKzasUvX6YDGWjomvbTks7CjK8LqUlEiPOAP6Xt+KYkVR+lX73N4qJ/zPW5vfJk
yuGh/AJ14ZEOFw7TojoJMU7OhsRmI+mBTCf2JXFPYbU1DaaUOEzSUPKvoNzisv2r
FJ6WtFURU95zjn7jAczQ0LvN3dMGzPdrgYj6qJ550F0dhrlTe8apJsZg9UniRDS9
TJZTJZ4C3eMieBuJRxibAkYvzF0s+LcADG6/UcJTGKJMULAI5wKesola2+aATI81
YxLjQ9cDQQrBWgkb+E2/WtzdYAfeiw==
=jT2n
-----END PGP SIGNATURE-----

--yjdvkhwb7e4yt662--
