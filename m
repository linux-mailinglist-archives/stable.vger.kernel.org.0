Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5457B619E20
	for <lists+stable@lfdr.de>; Fri,  4 Nov 2022 18:07:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231446AbiKDRHF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Nov 2022 13:07:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231401AbiKDRHD (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Nov 2022 13:07:03 -0400
Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0927931FA0
        for <stable@vger.kernel.org>; Fri,  4 Nov 2022 10:07:01 -0700 (PDT)
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id C86EE1C09F0; Fri,  4 Nov 2022 18:06:57 +0100 (CET)
Date:   Fri, 4 Nov 2022 18:06:57 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        Dan Carpenter <error27@gmail.com>, llvm@lists.linux.dev,
        Nathan Huckleberry <nhuck@google.com>,
        Abhinav Kumar <quic_abhinavk@quicinc.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.10 38/91] drm/msm: Fix return type of
 mdp4_lvds_connector_mode_valid
Message-ID: <20221104170657.GA29426@duo.ucw.cz>
References: <20221102022055.039689234@linuxfoundation.org>
 <20221102022056.117630968@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="pWyiEgJYm5f9v55/"
Content-Disposition: inline
In-Reply-To: <20221102022056.117630968@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,SPF_HELO_NONE,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--pWyiEgJYm5f9v55/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> [ Upstream commit 0b33a33bd15d5bab73b87152b220a8d0153a4587 ]
>=20
> The mode_valid field in drm_connector_helper_funcs is expected to be of
> type:
> enum drm_mode_status (* mode_valid) (struct drm_connector *connector,
>                                      struct drm_display_mode *mode);
>=20
> The mismatched return type breaks forward edge kCFI since the underlying
> function definition does not match the function hook definition.
>=20
> The return type of mdp4_lvds_connector_mode_valid should be changed from
> int to enum drm_mode_status.

We don't have kCFI in 5.10, IIRC, so we should not need this.

Best regards,
								Pavel
--=20
 'DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk'
 'HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany'


--pWyiEgJYm5f9v55/
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCY2VGsQAKCRAw5/Bqldv6
8miTAKCwgANXY1Qwqo4vzF6TVQRFA47IZQCfRYhkOffY6b9C13WBkOr/T+JszJc=
=KT8s
-----END PGP SIGNATURE-----

--pWyiEgJYm5f9v55/--
