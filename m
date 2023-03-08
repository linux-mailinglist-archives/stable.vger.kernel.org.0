Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 004CD6AFDCA
	for <lists+stable@lfdr.de>; Wed,  8 Mar 2023 05:19:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229582AbjCHETs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 23:19:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229799AbjCHETr (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 23:19:47 -0500
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4610F9DE05;
        Tue,  7 Mar 2023 20:19:46 -0800 (PST)
Received: by mail-pl1-x62b.google.com with SMTP id x11so12005448pln.12;
        Tue, 07 Mar 2023 20:19:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678249186;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=NdnP2NuqTUPQR9c97oNwJuHVigZrUCMRYT3RPXB4eg8=;
        b=CGW32gDUCcp59MH5OiqxQi4X/6gx3MXDB8I8Ct3qXET3WQhZ/Bnkc1I9D38/g3OrB9
         rCXrf+TgjAvAxsq725JWYYtXxpXgaQt5VSRmqXC9DJ6SqmGJmjTF5MX+g6HNjThlPE9E
         WRkDWkEtCL+zOB44OMU5hg+Lb+BKMXMxApSl9yzrWGI/WrILwKta7+DQ703n5YMx7Zqt
         K0QArZGzeU40rsTCXDbGlZ3SOnGL0j5/N5ZParu3xXmR42PJFXaKP+hAjdex93eSncqP
         VEQxYraDPElrsVIbkVn0hoiqlMxR55bLRnwC5H7l70n3JZHNmQ5aYT0CEuI/4ETBUMRX
         vJ0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678249186;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NdnP2NuqTUPQR9c97oNwJuHVigZrUCMRYT3RPXB4eg8=;
        b=e7Kt3hFR8pv1xumGhB999l09yTM4Pmx2LQ917yerR6BWKo5+r8T+zUUvW2g8AzcjE4
         HW1DdyscZnc1jPeQn+poqvrdgDBBKCHOcR8Uc97sUoKDHJ5MIUJgoRG06WnaRzLRDXZr
         MQax5u7hkOTxvzFw7JrhTXuULUrqZZgkmL/6ppUKG81JaFR24hfEKiVVfeUbw9GmCgym
         zulSW0yId+7Rsue4mkjwPsGJV9b23ZaRHEgqgqE4qXqD8W5E6pP5XSeUzFnqFHe1AxNp
         z9EIcAALmQbfP+87eoio09Y3B0Nzt4S9nUGms7X2j0l9vJBgZN5YR4KZp9kqa2JUmHal
         PnYQ==
X-Gm-Message-State: AO0yUKVQ6nrxOxqil7OsSQV75bil1CQ7nMRFCkXvkJt5WqyTPImoBdMH
        2H/KaImqWOWAh132/gbA98Q=
X-Google-Smtp-Source: AK7set9jbSODgLHbXn/kAV+3HwfXtJO5bm8WTPGni05zefS9xzKFRCjNuJf0+6IAVIjT35vJc3HJyg==
X-Received: by 2002:a05:6a20:4290:b0:bf:5d4e:704b with SMTP id o16-20020a056a20429000b000bf5d4e704bmr18072653pzj.32.1678249185667;
        Tue, 07 Mar 2023 20:19:45 -0800 (PST)
Received: from debian.me (subs02-180-214-232-18.three.co.id. [180.214.232.18])
        by smtp.gmail.com with ESMTPSA id s2-20020aa78282000000b005905d2fe760sm8640309pfm.155.2023.03.07.20.19.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Mar 2023 20:19:45 -0800 (PST)
Received: by debian.me (Postfix, from userid 1000)
        id B189F1065BB; Wed,  8 Mar 2023 11:19:41 +0700 (WIB)
Date:   Wed, 8 Mar 2023 11:19:41 +0700
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.15 000/567] 5.15.99-rc1 review
Message-ID: <ZAgM3QKYAjAwUPAC@debian.me>
References: <20230307165905.838066027@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="bUJ/i8HoDBY6xz5R"
Content-Disposition: inline
In-Reply-To: <20230307165905.838066027@linuxfoundation.org>
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--bUJ/i8HoDBY6xz5R
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 07, 2023 at 05:55:36PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.99 release.
> There are 567 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully cross-compiled for arm64 (bcm2711_defconfig, GCC 10.2.0) and
powerpc (ps3_defconfig, GCC 12.2.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--bUJ/i8HoDBY6xz5R
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZAgM1wAKCRD2uYlJVVFO
ozYNAP9XfjII4wqBZaXGJxzXWRLdClapsON4hmRauDKRPGMM9QEAkWpRvIRY0hFX
Jr8fqUFjjsTY59i1MLn15rW0FiNJqAI=
=jRwl
-----END PGP SIGNATURE-----

--bUJ/i8HoDBY6xz5R--
