Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E668B64E8DE
	for <lists+stable@lfdr.de>; Fri, 16 Dec 2022 10:51:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230103AbiLPJvT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Dec 2022 04:51:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229506AbiLPJvS (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Dec 2022 04:51:18 -0500
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB64030F68;
        Fri, 16 Dec 2022 01:51:16 -0800 (PST)
Received: by mail-pl1-x62e.google.com with SMTP id m4so1804784pls.4;
        Fri, 16 Dec 2022 01:51:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=60NkYdzUVc4ugspOkWoX2E7c3V0ybSgQKa2fBToU1oE=;
        b=F4Rw3yoDtedDA7R/PDEBjuW+OFvfbFC+aYXItqyhvrQarZzoqGEBjvdkuIkxsYQwyL
         xTCZuRkXZ/irlV4q6l3bnjw/j7YbktKB0QiHi4tlFd8ySUE2WjAhc9X2cDg3IQeJB/E0
         p7Y9M22h1j1hWDY4lrNLN5GWpqt1lvRwW2UzJ71u8SQRPzUSt4eKdsL0/ijCXw+w6vYx
         5LaH5m4lVtEEkSN7rSabAGFWv3IfgqXn7gu9bNtM6DEODEfWKydOELKkwLG9SIQuFYta
         +yGMfzobeg+OEl5pIDw6Eu89XUshEq7wFk4ignhJNyBKpow8PPho25mjWl6YJlsfAHIF
         R6Nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=60NkYdzUVc4ugspOkWoX2E7c3V0ybSgQKa2fBToU1oE=;
        b=wYrkFl5/q5WKQYpCvghJ/Hm5GT+JmPwpup6CzKO7Ucc24qThY+XGUvWveS0w8W02CL
         Fa9/nMEPI9x9dLfkJpXeQUnN94Od2IpgaRpzbSHDMq8uBaXS/x8ET7JEogR8OX4q5kyU
         CAC0rbSqrb5GR1lDHOR/zNNs2BMlQUdzYSsHkQhPgpGtzwlYPM4ljODCUACnkCfbKe9A
         g/AUVg2WgCbkI2qh3a/dInmQK9LK2TsjSIIBR70Jn4yQ7jyYkJqGsjEh9hWZ3PIvfsMv
         LfKFyyVi3rRXrvnfea4ELqipLgWILrC/Mt15ZBZ5JiGv4Mts7HBF0ig7kQsKHQ3CkZfj
         DyLg==
X-Gm-Message-State: ANoB5pk5L90S0uorAReUxPOx+3kTCyKd8/3peOS5YzieGkIlJ3vBirDU
        pjCrKoUR2qW6TsME+qWVb00=
X-Google-Smtp-Source: AA0mqf6VTExRhdd9tKtj2GLDRYat99+cuGg2pjSGDbfeIaDj747S9GwjKK7uAUpdVLxeNgiVP3XJRA==
X-Received: by 2002:a17:90b:2d83:b0:219:e002:1ba3 with SMTP id sj3-20020a17090b2d8300b00219e0021ba3mr33608411pjb.9.1671184276334;
        Fri, 16 Dec 2022 01:51:16 -0800 (PST)
Received: from debian.me (subs03-180-214-233-84.three.co.id. [180.214.233.84])
        by smtp.gmail.com with ESMTPSA id u3-20020a17090add4300b002135a57029dsm991511pjv.29.2022.12.16.01.51.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Dec 2022 01:51:15 -0800 (PST)
Received: by debian.me (Postfix, from userid 1000)
        id 24AAE103E00; Fri, 16 Dec 2022 16:51:11 +0700 (WIB)
Date:   Fri, 16 Dec 2022 16:51:11 +0700
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.0 00/16] 6.0.14-rc1 review
Message-ID: <Y5w/j0Q3DLzLAJXo@debian.me>
References: <20221215172908.162858817@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="Gb3aCbW83YrRToag"
Content-Disposition: inline
In-Reply-To: <20221215172908.162858817@linuxfoundation.org>
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--Gb3aCbW83YrRToag
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Dec 15, 2022 at 07:10:44PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.0.14 release.
> There are 16 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully cross-compiled for arm64 (bcm2711_defconfig, GCC 10.2.0) and
powerpc (ps3_defconfig, GCC 12.2.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--Gb3aCbW83YrRToag
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCY5w/iwAKCRD2uYlJVVFO
oy2aAP9tOXaBQdY6BRm0L1BWTo/pUAm8/VU1uCoBqixus/gmmwEAgQkYrtjKkp91
toeRdUS01sQRiJy/lNmUDzCFYA/puwc=
=28q1
-----END PGP SIGNATURE-----

--Gb3aCbW83YrRToag--
