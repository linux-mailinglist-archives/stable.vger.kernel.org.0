Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F1F76129BC
	for <lists+stable@lfdr.de>; Sun, 30 Oct 2022 10:54:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229833AbiJ3Jya (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 30 Oct 2022 05:54:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229565AbiJ3Jy2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 30 Oct 2022 05:54:28 -0400
Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0E51CE39
        for <stable@vger.kernel.org>; Sun, 30 Oct 2022 02:54:25 -0700 (PDT)
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 011A71C0049; Sun, 30 Oct 2022 10:54:23 +0100 (CET)
Date:   Sun, 30 Oct 2022 10:54:23 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        Alexander Graf <graf@amazon.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 5.10 12/79] kvm: Add support for arch compat vm ioctls
Message-ID: <20221030095423.GA25519@duo.ucw.cz>
References: <20221027165054.270676357@linuxfoundation.org>
 <20221027165054.739599117@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="dDRMvlgZJXvWKvBx"
Content-Disposition: inline
In-Reply-To: <20221027165054.739599117@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NEUTRAL autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--dDRMvlgZJXvWKvBx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> commit ed51862f2f57cbce6fed2d4278cfe70a490899fd upstream.
>=20
> We will introduce the first architecture specific compat vm ioctl in the
> next patch. Add all necessary boilerplate to allow architectures to
> override compat vm ioctls when necessary.

AFAICT this introduces hooks, but they are not used at least in 5.10.

We should not need this...?

Best regards,
								Pavel
--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--dDRMvlgZJXvWKvBx
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCY15JzwAKCRAw5/Bqldv6
8hZhAJ49Y6nA19pezH8aEO7CiULR25OX/QCfU2+NrWQgLMPZutHIt44PESpQRYQ=
=4ECv
-----END PGP SIGNATURE-----

--dDRMvlgZJXvWKvBx--
