Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A6D564060E
	for <lists+stable@lfdr.de>; Fri,  2 Dec 2022 12:49:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232598AbiLBLtR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Dec 2022 06:49:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233366AbiLBLtN (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Dec 2022 06:49:13 -0500
Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE14EC4625;
        Fri,  2 Dec 2022 03:49:11 -0800 (PST)
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id CFD5F1C09FE; Fri,  2 Dec 2022 12:49:09 +0100 (CET)
Date:   Fri, 2 Dec 2022 12:49:09 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        mlevitsk@redhat.com, samuel.thibault@ens-lyon.org,
        pawell@cadence.com
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.10 000/162] 5.10.157-rc1 review
Message-ID: <Y4nmNb46aqbm7JuS@duo.ucw.cz>
References: <20221130180528.466039523@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="bpIs/ozp+cN40TDf"
Content-Disposition: inline
In-Reply-To: <20221130180528.466039523@linuxfoundation.org>
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NEUTRAL autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--bpIs/ozp+cN40TDf
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

[If I cc-ed you, you are author of one of patches below. Please take a
look.]

> Responses should be made by Fri, 02 Dec 2022 18:05:05 +0000.
> Anything received after that time might be too late.

I hope to make it :-). I

> Pawel Laszczak <pawell@cadence.com>
>     usb: cdnsp: Device side header file for CDNSP driver
>=20
> Pawel Laszczak <pawell@cadence.com>
>     usb: cdns3: Add support for DRD CDNSP

These two together are 1500+ lines, and are marked as Stable-dep-of:
9d5333c93134 ("usb: cdns3: host: fix endless superspeed hub port
reset") . But we don't have that one in 5.10 tree. Likely we should
not have these either.

> Maxim Levitsky <mlevitsk@redhat.com>
>     KVM: x86: emulator: update the emulation mode after rsm

No. The patch does not do anything. Mainline commit this referenced
changed the return value, this changes just a comment. Wrong backport?

> Samuel Thibault <samuel.thibault@ens-lyon.org>
>     speakup: Generate speakupmap.h automatically

Ok, so this one rewrites some header generation and is buggy. 500+ lines.

> =C4=90o=C3=A0n Tr=E1=BA=A7n C=C3=B4ng Danh <congdanhqx@gmail.com>
>     speakup: replace utils' u_char with unsigned char

With this patch fixing it. The rewrite is marked as stable depedncency
of the fix, but fix would not be needed if we did not apply the
rewrite. We should not have these two in stable.

Best regards,
								Pavel

--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--bpIs/ozp+cN40TDf
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCY4nmNQAKCRAw5/Bqldv6
8slCAJ9szYXOohy0lnupI0Mkyz6PA/P5VQCeJJG/B7MCigs9ur+cypbg+M7O2us=
=EERt
-----END PGP SIGNATURE-----

--bpIs/ozp+cN40TDf--
