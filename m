Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1ACA637461
	for <lists+stable@lfdr.de>; Thu, 24 Nov 2022 09:48:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229730AbiKXIsM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Nov 2022 03:48:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229653AbiKXIsH (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 24 Nov 2022 03:48:07 -0500
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DF1627179;
        Thu, 24 Nov 2022 00:48:06 -0800 (PST)
Received: by mail-pf1-x42b.google.com with SMTP id 140so1073326pfz.6;
        Thu, 24 Nov 2022 00:48:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=qAFlJHtEN7OU9vMklNmbG9vzoWkur+SNbaJzwynOShI=;
        b=iwoEnsc1mZXk5zMDeAQoFIw5p9TG0uHr9uFU2hEI7Oq7DTbuvMuwrIgcVm5USdWwn4
         m66k557ZkbtZI9fB4dEipyKpMSfRq8giTBh+6Dtr4WKV4l5Fh63m7DhR0z7J4tRgC+d1
         tTOxFDzCYd/gV/wQwxJKK+1hqhFSrvImoc2x9yTkE5z7h5nKKylRqnmj6JFXmVHwaMzq
         7b2d772ff5nlitogikUNchDlDDsSf+BEvk8s5P1HNvust/PiwN8VVQqjVVDnhEbZH6ze
         HxysKiwNC0Rkq6uBPY38hC3QAGZxbt81q/XXUdCg/YMpRQYIMg+EArH9ZXkvvnnfgc8v
         LptA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qAFlJHtEN7OU9vMklNmbG9vzoWkur+SNbaJzwynOShI=;
        b=Sfih5/LcBkV22EkIBuXns4m7hk3v52kLtN7r9CW5uAWGu3DzehebvGNxfOOVUS/4gH
         mtlmC28DF4V5muG/LZSCI5YmTcmtsVacnHPS+Q8u5FZnVCcEtuSqLQ+yYwuWTik4QDkO
         iK2JmYI0CjmB7qkm+8BCJGS8umuveD1DI8Mtb5/Nt/jkfiZXmeQO6zPqsMkqzv6sYJLf
         bod4WEE+EE/yfDOi0dbkgUm9iCBwz5wpIii5hTb3pnToF9jnI0b+5eTIcbnEdt5gNMbt
         R3Pwcc1XLVXlOB/TExSkDqD/DcGl/ioFccC6kqyhw1adrfXbnnh9dv6T8kaOzpfyO2yn
         +UtA==
X-Gm-Message-State: ANoB5plwz2ShjwFTsAKhaX6Ke5NzYE80WEZCvW4OH09qsLudDb6hsKex
        wA3kgyclMShzcrFV3Tvw+Ao=
X-Google-Smtp-Source: AA0mqf5CHt4qVyr791m8JquWGV264mdeop/I2b1AGtn+WGxpK/dyjgQ6FvaXEPQxMVAUE8p5bxuUMA==
X-Received: by 2002:a63:2001:0:b0:477:b0d0:bbee with SMTP id g1-20020a632001000000b00477b0d0bbeemr8646819pgg.51.1669279686108;
        Thu, 24 Nov 2022 00:48:06 -0800 (PST)
Received: from debian.me (subs32-116-206-28-44.three.co.id. [116.206.28.44])
        by smtp.gmail.com with ESMTPSA id a9-20020a170902ecc900b001886ff82680sm677275plh.127.2022.11.24.00.48.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Nov 2022 00:48:05 -0800 (PST)
Received: by debian.me (Postfix, from userid 1000)
        id DF28E103FAA; Thu, 24 Nov 2022 15:48:00 +0700 (WIB)
Date:   Thu, 24 Nov 2022 15:48:00 +0700
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.0 000/314] 6.0.10-rc1 review
Message-ID: <Y38vwA4WrG2Hp/oT@debian.me>
References: <20221123084625.457073469@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="iHe3S5Sc3E10kqvR"
Content-Disposition: inline
In-Reply-To: <20221123084625.457073469@linuxfoundation.org>
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--iHe3S5Sc3E10kqvR
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 23, 2022 at 09:47:25AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.0.10 release.
> There are 314 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully cross-compiled for arm64 (bcm2711_defconfig, GCC 10.2.0) and
powerpc (ps3_defconfig, GCC 12.2.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>=20

--=20
An old man doll... just what I always wanted! - Clara

--iHe3S5Sc3E10kqvR
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCY38vtwAKCRD2uYlJVVFO
o9IdAP90sqMnAg6OZ/JBMbwt6qfX9zEht2wTrZ49mQPgxhUwUQEA39Om6crPMAlG
H9dJw+RSAlop+FFPg6u/OA9uSRP0bwg=
=ujca
-----END PGP SIGNATURE-----

--iHe3S5Sc3E10kqvR--
