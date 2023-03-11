Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F45B6B5827
	for <lists+stable@lfdr.de>; Sat, 11 Mar 2023 05:14:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229522AbjCKEN6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 23:13:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229552AbjCKEN4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 23:13:56 -0500
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 521CB76049;
        Fri, 10 Mar 2023 20:13:55 -0800 (PST)
Received: by mail-pl1-x62c.google.com with SMTP id p6so7748827plf.0;
        Fri, 10 Mar 2023 20:13:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678508035;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=z4wrNUARGjvj/HU6mgRGoiN0wUdfzuQZe9FSkh3ZviA=;
        b=pSdTEWFHXcWVIZUh4KoPl7zWCe7fQ8upiLOy4UVnFPpqvonfGP0801WnCu4N+NVIjz
         Ru+Nyh9DM4VWyz8RXUJ+xU3SVfSEUDQ1QBnhbIoZ7pn45vA9gbZEDc6a8q5YTm1eKZe6
         Xz0GHejRsTcMIanVrxwKy9xdc9Vnja7TW7+fNfZlBScU1Ol1dCesiO+Lp4znbwOq+EQT
         0CJDmACacANWeCKXHwbfsLluQgLpEf9AQmn1LFpfNjJAcuUgCHHKTeVXVXFdPQ4Zfz3+
         IkWS9nrk0J1OuZM+HcJpyrdBd/5ynQmCId2+ksKxRevYWitmPJgL5adgFgJHigV+JOqX
         vUXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678508035;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=z4wrNUARGjvj/HU6mgRGoiN0wUdfzuQZe9FSkh3ZviA=;
        b=03sk1ZAqrOEzXEK1uM0RSMFRPnznb6QydBkrtPjh/UVJYTm9uN8lzpiA/9tBFGVuzW
         4wb9etNcMgRipfgPo4H5s21nYa5ufhb7amqtTFEKnJIxlqPWmFRJapEf13VuVsExu+Je
         21NTaYudrSPSzCckxLjbvFZ5MGc3s+DXT57ee2plIeigcCBAfiOZfN5ryijqFd7hOuPG
         g97IvWXEU3VmdnPptgvxnOZvuzGJtT/kOh7qJceZfXSfJYJ2btGebp+UL8AfSUe+wkg3
         fAkBoPnoPBaQfXk09VFTDW9Kb76z9u71I8Gokb3p/KIH2zKIlH47rvDHg8PdSD61VHsJ
         Kimw==
X-Gm-Message-State: AO0yUKUDYOsXQl8Or5m4CDzjqmQHy54UCjjYGFCo2a5GEadGOg4d/qrf
        ZkFv9S8iJDxTMfCfkclDbgY=
X-Google-Smtp-Source: AK7set/VndVMN8a2gidiWncHpSkIdCVoB5h64xS7mFcKibXLjzQwUaQwYhzCkeeFHLbUvyD0fRql0g==
X-Received: by 2002:a17:902:d4c3:b0:19c:c184:d211 with SMTP id o3-20020a170902d4c300b0019cc184d211mr33492300plg.37.1678508034805;
        Fri, 10 Mar 2023 20:13:54 -0800 (PST)
Received: from debian.me (subs28-116-206-12-51.three.co.id. [116.206.12.51])
        by smtp.gmail.com with ESMTPSA id kt7-20020a170903088700b00186a2274382sm717312plb.76.2023.03.10.20.13.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Mar 2023 20:13:54 -0800 (PST)
Received: by debian.me (Postfix, from userid 1000)
        id DE76D106674; Sat, 11 Mar 2023 11:13:51 +0700 (WIB)
Date:   Sat, 11 Mar 2023 11:13:51 +0700
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.1 000/200] 6.1.17-rc1 review
Message-ID: <ZAv///zz+tUCIgdv@debian.me>
References: <20230310133717.050159289@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="KeVNMFZt8x5fBdGy"
Content-Disposition: inline
In-Reply-To: <20230310133717.050159289@linuxfoundation.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--KeVNMFZt8x5fBdGy
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 10, 2023 at 02:36:47PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.17 release.
> There are 200 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully cross-compiled for arm64 (bcm2711_defconfig, GCC 10.2.0) and
powerpc (ps3_defconfig, GCC 12.2.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--KeVNMFZt8x5fBdGy
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZAv//wAKCRD2uYlJVVFO
o7hCAP93Vv0oXBK0Or1ACOgmPTyWxOxKJL8GcHI1tumxoPHR1wD/YioOdLpf2dd8
OUi/j16zWRTrjWNCN2H1cKbjK+L+0AA=
=d7DB
-----END PGP SIGNATURE-----

--KeVNMFZt8x5fBdGy--
