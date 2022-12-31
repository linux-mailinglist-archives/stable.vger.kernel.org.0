Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CF8B65A29C
	for <lists+stable@lfdr.de>; Sat, 31 Dec 2022 04:48:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229681AbiLaDsM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Dec 2022 22:48:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229514AbiLaDsL (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 30 Dec 2022 22:48:11 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4493EB85D;
        Fri, 30 Dec 2022 19:48:11 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id n12so11265915pjp.1;
        Fri, 30 Dec 2022 19:48:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Spjm14Do/Jp5yV7SFep7Vpr7Viq6o6tOkiCvcqVQTjM=;
        b=U9eQxnBx0aalJbgTHWjBiAcAJeeOd7F59KOJa+fCZM8+o0pNgJ48IHR20zw7pZiMQI
         i+/33fFHYFjP4mHb8gc2wMFW76o0qfWpL+HkfWBa2lpx+k7kxTKAeiwtUkGwS/+DebaK
         rTeSp9Q5SCFKgXX2HlCOrSGgYbjQ59NoxFiQlIelHVc3CDk7tK/75jSOTk4mVm2OnpnL
         wazZi/KIIbM+mZDyHAVUQ3A4LoZ9olYO/602LfwqggdHgJEcrogOWbxl3t5WO3JUTibB
         ntEnQJWze10k4KjNxlkJJ44XTcveVVGuHFxob4i+bSMSs6BrvGFiPEEmI+lRoUjPGcgs
         xlWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Spjm14Do/Jp5yV7SFep7Vpr7Viq6o6tOkiCvcqVQTjM=;
        b=M6NP/8kGzaZihYp66oZFtpxFA6Tmrz1dnskJNJ2RrMqSJJIIhSNAXR3rMl/wP1aYrU
         TqPmogiqxdYDmKzXWAiLjpPwHgyemx8HXdMARSwDmdw2ot7m0jFVCneyuilP0h97lWCv
         b3w986cvUjKQt4NPWARuNB/kOgQ+xjRIGVdscNqbf26VsEylYWg/timy4l2Q1isXNEmz
         VpXTvtj56vA9EiBZNos8RUkdv23CgAXBGWqBXg2bHZEVS+M2i2vzAsFcIKlAwoWHDOb5
         Pniy596L8FE/ZDfm8vbhLZ+uMaxohvI5VjKp4vAlnB2ZHnkNvNaG/XlWrbQVfzoB6peg
         o29w==
X-Gm-Message-State: AFqh2kor3YCCygGZIXkQb07wSmIv8kQc+ACsjuJDY/1C7VePbAiFyJ1f
        g2QiDj2M+zzGKLuRmNBF/wY=
X-Google-Smtp-Source: AMrXdXtPiEuwumaS5Bvm2Lw0FFyCy7tWSwCvwiSWT9zvvr5FGh+TdVX19EPByy/vFRPx4ylaKUKBPg==
X-Received: by 2002:a05:6a20:c745:b0:9d:efc0:85 with SMTP id hj5-20020a056a20c74500b0009defc00085mr34127819pzb.45.1672458490783;
        Fri, 30 Dec 2022 19:48:10 -0800 (PST)
Received: from debian.me (subs03-180-214-233-72.three.co.id. [180.214.233.72])
        by smtp.gmail.com with ESMTPSA id h4-20020a056a00000400b005821c109cebsm712143pfk.199.2022.12.30.19.48.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Dec 2022 19:48:08 -0800 (PST)
Received: by debian.me (Postfix, from userid 1000)
        id B7CE5104465; Sat, 31 Dec 2022 10:48:06 +0700 (WIB)
Date:   Sat, 31 Dec 2022 10:48:06 +0700
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.15 000/731] 5.15.86-rc2 review
Message-ID: <Y6+w9gYWpk/TXYC8@debian.me>
References: <20221230094021.575121238@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="xHUjXrYOrP0biQR9"
Content-Disposition: inline
In-Reply-To: <20221230094021.575121238@linuxfoundation.org>
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--xHUjXrYOrP0biQR9
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Dec 30, 2022 at 10:49:11AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.86 release.
> There are 731 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully cross-compiled for arm64 (bcm2711_defconfig, GCC 10.2.0) and
powerpc (ps3_defconfig, GCC 12.2.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--xHUjXrYOrP0biQR9
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEARYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCY6+w9gAKCRD2uYlJVVFO
o2reAQD2kNB/IbQ1m4FsMqibHCMZ3/hbH+ZeMLy4MbDEKtZ1XgEAtovRBnwjLq9o
CjUQ4hvGJHbPtKafn8jS4C2SSL/OwQc=
=H2bP
-----END PGP SIGNATURE-----

--xHUjXrYOrP0biQR9--
