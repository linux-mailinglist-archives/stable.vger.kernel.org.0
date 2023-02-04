Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58F8E68A7F5
	for <lists+stable@lfdr.de>; Sat,  4 Feb 2023 04:28:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229760AbjBDD2a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Feb 2023 22:28:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbjBDD23 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Feb 2023 22:28:29 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6E8CA5CA;
        Fri,  3 Feb 2023 19:28:28 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id l4-20020a17090a850400b0023013402671so10536508pjn.5;
        Fri, 03 Feb 2023 19:28:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=CmdIpFXX/Pnd+rThHPSIEqn/ETUzOMU9w26EKl0vXWA=;
        b=FaQQgRbSWlX6tu/FaH7yaf8hQo2SHcLcvhh+G+lbUttH4FO+9+mHKW+PvIkqQC08P9
         IBvcZDTimIZZfqW92uIUEk0T0jPj4xi9492J2A+wfjGK9hDOwEOGijyVYhzhaT8pZNMt
         BbG84gUM5ZgSCCLw0+1MxOEqPC9epG+8mCU2c+v5UlcLQE7sxcFQc8OMB7tuM70aK4+R
         ipgDLvLqjadVTODjotX6B7QaK0gsu8eB62jn+0XEOZb5/oXfOI8gN7QBHgzag7Zw6yyu
         rnd0AKr8pHK75QBBYfOnFtg0xylFylPmU9Ku07zqGPsHb9v9HJ8bGW3MWhJitNvWGCrp
         iQvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CmdIpFXX/Pnd+rThHPSIEqn/ETUzOMU9w26EKl0vXWA=;
        b=UTZz1l8J9cCPUnWe6NoENpDeC3dbM37CTsFiG4ICuM/m9HWOrUuWFeZz78/xNY0CM5
         //Klrafx5/3dUyUcqF1W41EBoorAHWVxRyBOIHh4NSBG0whou90RKg07ZhDjz/BTzbUk
         xSn7wVHZ+YrAhWVk16g2TiAYuX0eDKuGks5WpKEpZC/xQ2gTwub3wwddo7NUbPEXqE2+
         xu6GTjmXimD1xJ8G9JDEh8l5FaJSW93hNuOTYx/fhEfwf+BmPRMGc9IDstOnMhSKLAE/
         riCcOzfmGfJVV2KYzU7aUQLgwJa+btF9v4rJXDBI4hmp4h1gUqJsboZBY5yJbVUKg7X7
         DykA==
X-Gm-Message-State: AO0yUKX4GyUE+u9Q+iAuReMfp3rcgPdY52zjtrnb47OzVM5FufP5Wq3+
        2krH4D20IAAKCepxeVDkDKxn2fqVtXTKxA==
X-Google-Smtp-Source: AK7set+U1kE9VIbXjv60qobe9B9PSImxBIcUvcu0G5TQsQPkLsxmHIFlCLxBJagQRby/ps5Dl2OcCw==
X-Received: by 2002:a17:902:e0d5:b0:196:3feb:1f1e with SMTP id e21-20020a170902e0d500b001963feb1f1emr9398591pla.47.1675481308285;
        Fri, 03 Feb 2023 19:28:28 -0800 (PST)
Received: from debian.me (subs02-180-214-232-73.three.co.id. [180.214.232.73])
        by smtp.gmail.com with ESMTPSA id t7-20020aa79387000000b0058d9623e7f1sm2576612pfe.73.2023.02.03.19.28.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Feb 2023 19:28:27 -0800 (PST)
Received: by debian.me (Postfix, from userid 1000)
        id 54C361052EA; Sat,  4 Feb 2023 10:28:23 +0700 (WIB)
Date:   Sat, 4 Feb 2023 10:28:22 +0700
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.1 00/28] 6.1.10-rc1 review
Message-ID: <Y93Q1iUQbFluIJPZ@debian.me>
References: <20230203101009.946745030@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="eKrxPjNJTcq3O9+b"
Content-Disposition: inline
In-Reply-To: <20230203101009.946745030@linuxfoundation.org>
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--eKrxPjNJTcq3O9+b
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Feb 03, 2023 at 11:12:48AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.10 release.
> There are 28 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully cross-compiled for arm64 (bcm2711_defconfig, GCC 10.2.0) and
powerpc (ps3_defconfig, GCC 12.2.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--eKrxPjNJTcq3O9+b
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCY93QzQAKCRD2uYlJVVFO
oztAAQCdjQyW8RqqYKwJH6cAjdNb40AxsP35XFAy3/AaWulmeAD+OAwoLS5PJwwv
WeHJEmjhaC0KoMnLb/W9Uk6AX1mSgAg=
=0bAs
-----END PGP SIGNATURE-----

--eKrxPjNJTcq3O9+b--
