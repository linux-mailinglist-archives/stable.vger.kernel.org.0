Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 128C468E6A1
	for <lists+stable@lfdr.de>; Wed,  8 Feb 2023 04:39:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229530AbjBHDjx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Feb 2023 22:39:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229881AbjBHDjv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Feb 2023 22:39:51 -0500
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01C5C25E31;
        Tue,  7 Feb 2023 19:39:51 -0800 (PST)
Received: by mail-pl1-x62c.google.com with SMTP id m2so17900576plg.4;
        Tue, 07 Feb 2023 19:39:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=3qoy2xyLaqsHrOi8xllBz13k08/6Kk2GsLxxK01cGUU=;
        b=RNVZLjM0HwHxVDilEWHzDWIBZPH5fPee7+9/Y9yGiQBvxzQ0Q3g6oK+LiJCSJedw3r
         TBGhwvmKNiaLHp6NebN5KL2WFGAO8KXYTj1MF2NEQ1lZgjK9lOXGjlHkBtiJcX4HngJ2
         2MLmr8HdkFqwnzxnKRjrgo9E5hmrUj8VmekbBj9p05xo/k+Mc6PauOwLu+eFioJhIL/N
         ehZQFchgNZ4rLa6UmLkf4iFxh14fWpfvdpYVfOTMuUj5ws8X7gHDfQ3KSIYmeOaoK3vF
         bn+OW4ZsPaGksJo5ODXqQhoT26Cd88ERC4JFWMG3iwotLIrr+8/3Kh0X14ogoTeiBsF2
         XjnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3qoy2xyLaqsHrOi8xllBz13k08/6Kk2GsLxxK01cGUU=;
        b=XX5SvJxUeNZkOeOGsUHLh/VpCc1O6ERvBp8RIHjeHfxtQ6GOKB3OBiT3L46tDKMfXq
         JmtAYZCDBhIGam5EaMTyZ5j1d4D1UekL7HLSLP81sLhNBsex/8sMvgftqyQNb4Ov/5l8
         n/M37hG2V/DwRGFZ6jjhwoye4+4Z76tohEf0w2UsfpEJEA7jwm1H+5QQNotYyi7AF1le
         llIq/qg+JufejAJzXBiHQrF4GVEExo6m+kS08lrGaFbcTu1rl/rBmTxxiYaTZkuDx0iL
         XhHwDyVpBMHuzBwtDfeWRp8cZxeNCmhKArUNj5SLKlRTaAC9Jj6RO8t/L3kYSYu1CVfF
         Ffkg==
X-Gm-Message-State: AO0yUKWvkjCVqLg5c2cYxwlKzZu5H9KQE2738a1kzokYe/8Ox0481yDE
        5etXdL/Rg0aprnrLU5G30x4CHCmZATY=
X-Google-Smtp-Source: AK7set/NzwMs9/QJ6+wP8u0jhNtHwUltio6xYvWRwn8bT7dvJlP9brX5fgbW97Gt7Fbys1u+WOAUpg==
X-Received: by 2002:a17:90b:33c7:b0:22c:aaaf:8de7 with SMTP id lk7-20020a17090b33c700b0022caaaf8de7mr6766680pjb.5.1675827590458;
        Tue, 07 Feb 2023 19:39:50 -0800 (PST)
Received: from debian.me (subs28-116-206-12-49.three.co.id. [116.206.12.49])
        by smtp.gmail.com with ESMTPSA id n4-20020a17090a394400b0022c0622cc16sm282557pjf.54.2023.02.07.19.39.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Feb 2023 19:39:49 -0800 (PST)
Received: by debian.me (Postfix, from userid 1000)
        id 9F23810558B; Wed,  8 Feb 2023 10:39:46 +0700 (WIB)
Date:   Wed, 8 Feb 2023 10:39:46 +0700
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.1 000/208] 6.1.11-rc1 review
Message-ID: <Y+MZgo5UGq8lK4E5@debian.me>
References: <20230207125634.292109991@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="qGnjtW81c0Yd9x5l"
Content-Disposition: inline
In-Reply-To: <20230207125634.292109991@linuxfoundation.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--qGnjtW81c0Yd9x5l
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 07, 2023 at 01:54:14PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.11 release.
> There are 208 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully cross-compiled for arm64 (bcm2711_defconfig, GCC 10.2.0) and
powerpc (ps3_defconfig, GCC 12.2.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--qGnjtW81c0Yd9x5l
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCY+MZfgAKCRD2uYlJVVFO
owCGAP9JYQpAdOsgFeiQ6IEDjeVfuTM2MJv9J2BWgALmNbBkAgEArem8HhAza5iq
4uvEWlDVNhYyrDXUN8qhKEXwz304tg0=
=wCdc
-----END PGP SIGNATURE-----

--qGnjtW81c0Yd9x5l--
