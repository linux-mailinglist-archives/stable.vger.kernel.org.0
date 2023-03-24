Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 282E76C8215
	for <lists+stable@lfdr.de>; Fri, 24 Mar 2023 17:04:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229468AbjCXQES (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Mar 2023 12:04:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229864AbjCXQES (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Mar 2023 12:04:18 -0400
Received: from maynard.decadent.org.uk (maynard.decadent.org.uk [95.217.213.242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53F8149D6
        for <stable@vger.kernel.org>; Fri, 24 Mar 2023 09:04:17 -0700 (PDT)
Received: from [213.219.167.32] (helo=deadeye)
        by maynard with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1pfjtj-0007wN-3A; Fri, 24 Mar 2023 17:04:11 +0100
Received: from ben by deadeye with local (Exim 4.96)
        (envelope-from <ben@decadent.org.uk>)
        id 1pfjth-006hhE-2P;
        Fri, 24 Mar 2023 17:04:09 +0100
Message-ID: <b646aaccc85b06c63c824bfd5c5c2249d8ce1de0.camel@decadent.org.uk>
Subject: Re: [PATCH 4.19 161/252] x86/microcode/amd: Remove
 load_microcode_amd()s bsp parameter
From:   Ben Hutchings <ben@decadent.org.uk>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     "Borislav Petkov (AMD)" <bp@alien8.de>, patches@lists.linux.dev,
        stable <stable@vger.kernel.org>
Date:   Fri, 24 Mar 2023 17:04:05 +0100
In-Reply-To: <ZBhb21/xkOC1dyIH@kroah.com>
References: <20230310133718.803482157@linuxfoundation.org>
         <20230310133723.713256658@linuxfoundation.org>
         <e2af9b33fb0f6e22146388a186cf0152abbac629.camel@decadent.org.uk>
         <ZBhb21/xkOC1dyIH@kroah.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-ueSA0XmjEF5wmV+RdF4D"
User-Agent: Evolution 3.46.4-1 
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 213.219.167.32
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on maynard); SAEximRunCond expanded to false
X-Spam-Status: No, score=0.0 required=5.0 tests=SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--=-ueSA0XmjEF5wmV+RdF4D
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2023-03-20 at 14:12 +0100, Greg Kroah-Hartman wrote:
> On Sat, Mar 18, 2023 at 02:49:53AM +0100, Ben Hutchings wrote:
> > On Fri, 2023-03-10 at 14:38 +0100, Greg Kroah-Hartman wrote:
> > > From: Borislav Petkov (AMD) <bp@alien8.de>
> > >=20
> > > commit 2355370cd941cbb20882cc3f34460f9f2b8f9a18 upstream.
> > >=20
> > > It is always the BSP.
> > >=20
> > > No functional changes.
> > >=20
> >=20
> > Does this not depend on commit 2071c0aeda22 "x86/microcode: Simplify
> > init path even more"?  That hasn't been backported to any stable
> > branches.
>=20
> It didn't seem to need it to at least build properly.  And it doesn't
> apply to the stable branches, so are you sure it's needed?

This commit message says that load_microcode_amd() is always called
with bsp=3Dtrue.  That doesn't seem to have been true before commit
2071c0aeda22, though I haven't tested it.

Ben.

--=20
Ben Hutchings
Usenet is essentially a HUGE group of people passing notes in class.
                 - Rachel Kadel, `A Quick Guide to Newsgroup Etiquette'

--=-ueSA0XmjEF5wmV+RdF4D
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAmQdyfUACgkQ57/I7JWG
EQmVFQ/+LphgpHWx619d4sYkxJa3dPtWckBWaMVSRtKofBc90Wl4c91uXo13N7pe
SmeClsvobLsnmDX46542DW1JJx3L0KFlNXBPC8+3PnjOVfyDYdpKmdcqUB/Ht0TN
Fpv7fnYYcHxriopb/OOXQPcpLZAQ2kPP4RakVwgvcmG119IQOE8dE/HXuiw0ytO3
rAStqlACcoudlRAcNh5VbZSTolXr3CG+3T+GxCl5ZM1bZb6KQ7YHPCzUir44AVXe
t5OM6WjQ1weaoWNPdSo0bydkqkHIUOktNRPoBl5WyNdeguFAbLEAjLDfgahb6Iss
hqjiMr5/QGw3uymagMinITZSqV+QKfMf24M1izjgzb94T2cROx3wcg91eP4nt+Vx
5DP0SWqrwG4Skqn0B14Fg2AJtbDaFsM1nJoc9NdXF4kmWPMyh2sMYv3lWTJ6/Gk8
A+ebP7xe0sDbrfJ5IMX9NLg8impMknt379PIzf9xKYWFmJU/QqWFm4hU54jSzV43
2I+a6XJVzIXLssKL3lKGpngsi/2dxPR7Byv1MWrOQ/4oIzjlrp/XWsTdMmO3KBHd
M0LHxUOrmhBDQjOXgLbjMG82Jmn/OA0lvaCRQNnQQRN7Cx/zNtAcjg37yzakO5zL
ty/9TzdpKgC6Zf/F8FiWlPWrDocGTgRPMr2wFoPK4uAu+R/J4bA=
=IAmY
-----END PGP SIGNATURE-----

--=-ueSA0XmjEF5wmV+RdF4D--
