Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90C6964A729
	for <lists+stable@lfdr.de>; Mon, 12 Dec 2022 19:35:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233270AbiLLSeo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Dec 2022 13:34:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234214AbiLLSdi (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Dec 2022 13:33:38 -0500
Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 057AD10B59;
        Mon, 12 Dec 2022 10:32:01 -0800 (PST)
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 962541C09DB; Mon, 12 Dec 2022 19:31:59 +0100 (CET)
Date:   Mon, 12 Dec 2022 19:31:59 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        yuehaibing@huawei.com, keescook@chromium.org
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.10 000/106] 5.10.159-rc1 review
Message-ID: <Y5dzn4y73kgwuas+@duo.ucw.cz>
References: <20221212130924.863767275@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="os3BK4mzJ0NoTXgk"
Content-Disposition: inline
In-Reply-To: <20221212130924.863767275@linuxfoundation.org>
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NEUTRAL autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--os3BK4mzJ0NoTXgk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 5.10.159 release.
> There are 106 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.


> YueHaibing <yuehaibing@huawei.com>
>     net: broadcom: Add PTP_1588_CLOCK_OPTIONAL dependency for BCMGENET un=
der ARCH_BCM2835

This one is not suitable for 5.10, we don't have
PTP_1588_CLOCK_OPTIONAL there.

> Kees Cook <keescook@chromium.org>
>     ALSA: seq: Fix function prototype mismatch in
> snd_seq_expand_var_event

This is useful fo kCFI, but we don't have kCFI in 5.10 and others.

Best regards,
								Pavel
--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--os3BK4mzJ0NoTXgk
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCY5dznwAKCRAw5/Bqldv6
8pB4AKChD0dIRIi0VEIS0k32S7FVgKHmcgCdEGjRfL2RBSBy7Zn6tLhlbtKa2l4=
=Q6Tw
-----END PGP SIGNATURE-----

--os3BK4mzJ0NoTXgk--
