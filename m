Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D215F65E5F5
	for <lists+stable@lfdr.de>; Thu,  5 Jan 2023 08:20:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230414AbjAEHUw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Jan 2023 02:20:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230379AbjAEHUw (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Jan 2023 02:20:52 -0500
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2ADAA3FA08;
        Wed,  4 Jan 2023 23:20:51 -0800 (PST)
Received: by mail-pl1-x629.google.com with SMTP id g16so28869767plq.12;
        Wed, 04 Jan 2023 23:20:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=7uciCeGRvBIYUUaGmyJ6ozxbZXS75DYR36RY29vGfjg=;
        b=iujW6ddxHafvumcE80G/XnOj8nO3vndEy4A4/DjXJt6Rr/O2McbgvptVI9TCk581Ps
         O1FBoNaDD2j4O0yDjULGVX8LPl7cwWir4/zsdTNlPhLhLbuNtIuqoLrWTk2x5fYPY1RS
         qbzzGIL0OU67jMbcQGrtuPmVWWHoguRlNSbniDEKUL2HUkUraeZwxfh7p3MhsWdLEeh0
         vp2DR0DqFVQLdPUS4n4ErbI3MgwYpTUyisRl1SJE7OFEWbjvupnRFTREaNAoc7mabmR5
         Q6I75aDH7szl5tplBtm51pULNqQIMF4Ik4g16g6COxNOWWUyxFHj561GnF4kxt6LKAcG
         +hAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7uciCeGRvBIYUUaGmyJ6ozxbZXS75DYR36RY29vGfjg=;
        b=YHMEqPp/GR7eJkXNRv2dvIupswu5FAPkKtoAB0Z1QDombo88raWtuy5DM7yWRBwB6C
         NWgLp8G5dGLRFq4RHHolkBZoH3brroN+Oj3Ecg7YfROOmFctGeXyqkWhy+l8yasHIzNy
         lUunYei3FP8HZ/zBd1/egp+5iqlegKZmCNa1wj3fxXaQHJvWjosAQb3dlKnwWejaBMGp
         XTfaUpA3vL570Q5LEBL29Ym7O4ZWIHjuW94Dzq1f6MrzwNrnjCMZxX8K3ABfKx43w8i6
         3U3yW6Iqw/z+ld177IY2tz/R/gkcsgYXGcuS+7K44+KtosgR9e853GsoCoRZabMc6o4N
         6OIw==
X-Gm-Message-State: AFqh2kr/LxWD78ycTy8y/FmVOcNJR62ifJETl4oxJGJDBvAmBnt3k2fZ
        qYrF7Hs2hh+KDVnJmrpQ6ZUcnRTCb/0=
X-Google-Smtp-Source: AMrXdXuznreNVNCf5FUnRCD5knZscaMY7dzaTt7omnF/gnOIjyq2m0CXzaUJEKtin5kjYqOQ1X9x0g==
X-Received: by 2002:a17:90a:c795:b0:225:bd44:cf0e with SMTP id gn21-20020a17090ac79500b00225bd44cf0emr48734053pjb.32.1672903250685;
        Wed, 04 Jan 2023 23:20:50 -0800 (PST)
Received: from debian.me (subs03-180-214-233-80.three.co.id. [180.214.233.80])
        by smtp.gmail.com with ESMTPSA id y2-20020a17090a6c8200b00212e5fe09d7sm677294pjj.10.2023.01.04.23.20.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Jan 2023 23:20:50 -0800 (PST)
Received: by debian.me (Postfix, from userid 1000)
        id EC296104732; Thu,  5 Jan 2023 14:20:47 +0700 (WIB)
Date:   Thu, 5 Jan 2023 14:20:47 +0700
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.0 000/177] 6.0.18-rc1 review
Message-ID: <Y7Z6TwyOaJOMDXMT@debian.me>
References: <20230104160507.635888536@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="8P+3z6rJGwSdx8v5"
Content-Disposition: inline
In-Reply-To: <20230104160507.635888536@linuxfoundation.org>
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--8P+3z6rJGwSdx8v5
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 04, 2023 at 05:04:51PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.0.18 release.
> There are 177 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20
=20
Successfully cross-compiled for arm64 (bcm2711_defconfig, GCC 10.2.0) and
powerpc (ps3_defconfig, GCC 12.2.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--8P+3z6rJGwSdx8v5
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEARYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCY7Z6TwAKCRD2uYlJVVFO
o8r9AQCrikKFnFK5sHuO0mFHk5PF6q8ztv2rzepmL1E7fgtrSAD/dnmlbqu31IzQ
d2md9l51jQLLInYTx596smxqgIip6As=
=GNDy
-----END PGP SIGNATURE-----

--8P+3z6rJGwSdx8v5--
