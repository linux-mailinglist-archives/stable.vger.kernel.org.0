Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F5E5533ACC
	for <lists+stable@lfdr.de>; Wed, 25 May 2022 12:45:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229492AbiEYKpH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 May 2022 06:45:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229462AbiEYKpH (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 25 May 2022 06:45:07 -0400
Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 721E2994CE;
        Wed, 25 May 2022 03:45:05 -0700 (PDT)
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id BC7081C0B92; Wed, 25 May 2022 12:45:03 +0200 (CEST)
Date:   Wed, 25 May 2022 12:45:03 +0200
From:   Pavel Machek <pavel@ucw.cz>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Sasha Neftin <sasha.neftin@intel.com>,
        Nechama Kraus <nechamax.kraus@linux.intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
Subject: Re: [PATCH 5.10 07/97] igc: Update I226_K device ID
Message-ID: <20220525104503.GA30018@duo.ucw.cz>
References: <20220523165812.244140613@linuxfoundation.org>
 <20220523165813.521480921@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="yrj/dFKFPuw6o+aM"
Content-Disposition: inline
In-Reply-To: <20220523165813.521480921@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--yrj/dFKFPuw6o+aM
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> From: Sasha Neftin <sasha.neftin@intel.com>
>=20
> commit 79cc8322b6d82747cb63ea464146c0bf5b5a6bc1 upstream.
>=20
> The device ID for I226_K was incorrectly assigned, update the device
> ID to the correct one.
>=20
> Fixes: bfa5e98c9de4 ("igc: Add new device ID")

I don't see updating the ID, I see adding an unused define. I don't
think this is suitable for stable. Same thing goes for previous two
patches, they don't really fix anything.

5106 O   Greg Kroah =E2=94=9C=E2=94=80>[PATCH 5.10 05/97] igc: Remove _I_PH=
Y_ID checking
5107 O   Greg Kroah =E2=94=9C=E2=94=80>[PATCH 5.10 06/97] igc: Remove phy->=
type checking
5108     Greg Kroah =E2=94=9C=E2=94=80>[PATCH 5.10 07/97] igc: Update I226_=
K device ID

Best regards,
								Pavel
							=09
> +++ b/drivers/net/ethernet/intel/igc/igc_hw.h
> @@ -22,6 +22,7 @@
>  #define IGC_DEV_ID_I220_V			0x15F7
>  #define IGC_DEV_ID_I225_K			0x3100
>  #define IGC_DEV_ID_I225_K2			0x3101
> +#define IGC_DEV_ID_I226_K			0x3102
>  #define IGC_DEV_ID_I225_LMVP			0x5502
>  #define IGC_DEV_ID_I225_IT			0x0D9F
>  #define IGC_DEV_ID_I226_LM			0x125B
>=20

--=20
People of Russia, stop Putin before his war on Ukraine escalates.

--yrj/dFKFPuw6o+aM
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCYo4IrwAKCRAw5/Bqldv6
8kwmAJ9cyWUX2tP3BInVgW7t7yK1iiM1YQCfT1tidpECvUsSK8StZXKtxlG1D7Y=
=PBmz
-----END PGP SIGNATURE-----

--yrj/dFKFPuw6o+aM--
