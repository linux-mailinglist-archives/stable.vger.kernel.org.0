Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F271B611FE0
	for <lists+stable@lfdr.de>; Sat, 29 Oct 2022 05:58:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229494AbiJ2D6p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Oct 2022 23:58:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbiJ2D6o (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 28 Oct 2022 23:58:44 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95A7F1E3F7;
        Fri, 28 Oct 2022 20:58:43 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id u6so6432381plq.12;
        Fri, 28 Oct 2022 20:58:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=A7c41syvrqLd1TaUkrLMYrwSJWuVCOYiGp5QPZ0BwAs=;
        b=EX35N5btl+RPixEyb/OfCM8er35FHxyM4NBG1+rGmanBl3Oc2dfLV83LKM49hKIKEd
         T0VaFiilf2kLa/5RyaWkWTvr0on5b97opn+8PQIg5Y7L+i7zedj7xP44/XlDk5mVQuj3
         OKIIzILvxz7qB+CZu6GRlhKfDYpp58VvhP07tfKzAW4K1u1n7DQKL2zw0zzPX5yyYkLs
         kiizxLlU+Da19hVkzp3W3JZIH4bP9O5tVLwt1LQXV0HaCnHrPzUrzpz9iaClvbiN2Ki9
         1Jg412TXBIDB+qD3Sc0Gp6+oVY5co9tR6PJua22TV0QXxWFet5W98quqomi/qm2HrLWv
         PgIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=A7c41syvrqLd1TaUkrLMYrwSJWuVCOYiGp5QPZ0BwAs=;
        b=pHE5KrTFUP7+8Q1II+Smi5qJ29QZgtPQNmNVKN2Q5i4K2ilRcNivcTczlDtufO5Z+A
         4VUNW0qwrTKHHHgZRPa0CoyyYRdcIkAobs8dmN1r+g1WkxsQ6FZZIdDZfxBsChK8Z3Bj
         TZ+6ExYoM3GPrq8XpGz78Pr98kRAVivQxMy0szhmbCTjFS5WI12mImYPshiNToB9D+Em
         NDNVkYm8GOxEqjXUPJNQyWhX4QSg3mBK1i04pmRIg4yFlsvLwrVy6euDLDalBzw/TEZ9
         y47Kas0KvNCZLjkKAy8jB7PEGBIvRxvrEPQJtzuOR1HR8Yf0JZ780Dhx8bfi5Q0+wk+a
         bT1A==
X-Gm-Message-State: ACrzQf1DU6jQ79UVgkAoEj3jh4QZSx9Y7VbETGXV8Hqyqt/yT1LnS1Dn
        RpSuEEcP1NEgpWiPsyOTjSo=
X-Google-Smtp-Source: AMsMyM7+eJHdlt7ANQd6iczHetGfS/17ZERbO+1PQQhYnN8ZJCeVPhiysyYEnbphEwK6KlOSjKjHCA==
X-Received: by 2002:a17:902:bc83:b0:187:85a:28b4 with SMTP id bb3-20020a170902bc8300b00187085a28b4mr356873plb.96.1667015923072;
        Fri, 28 Oct 2022 20:58:43 -0700 (PDT)
Received: from debian.me (subs02-180-214-232-66.three.co.id. [180.214.232.66])
        by smtp.gmail.com with ESMTPSA id u1-20020a17090add4100b0020adab4ab37sm205457pjv.31.2022.10.28.20.58.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Oct 2022 20:58:42 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
        id 4F56B104035; Sat, 29 Oct 2022 10:58:39 +0700 (WIB)
Date:   Sat, 29 Oct 2022 10:58:38 +0700
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net
Subject: Re: [PATCH 5.15 00/78] 5.15.76-rc2 review
Message-ID: <Y1yk7sz2aBHb9a1t@debian.me>
References: <20221028120302.594918388@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="qssvbHuPXMPpCfaV"
Content-Disposition: inline
In-Reply-To: <20221028120302.594918388@linuxfoundation.org>
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--qssvbHuPXMPpCfaV
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 28, 2022 at 02:04:05PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.76 release.
> There are 78 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully cross-compiled for arm64 (bcm2711_defconfig, GCC 10.2.0) and
powerpc (ps3_defconfig, GCC 12.1.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>=20

--=20
An old man doll... just what I always wanted! - Clara

--qssvbHuPXMPpCfaV
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCY1yk6AAKCRD2uYlJVVFO
o2a0AP9y95qXermEVKYVo+Byvrab0z+Lc0AEiw4tg/9Cg/NAJwEA/8sNUexhkOvd
aFUTrQgKyMoXijPBLxyewgzD1nqsbQ8=
=eXSA
-----END PGP SIGNATURE-----

--qssvbHuPXMPpCfaV--
