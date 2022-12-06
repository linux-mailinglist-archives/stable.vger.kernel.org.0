Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFE68643C0A
	for <lists+stable@lfdr.de>; Tue,  6 Dec 2022 05:02:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231990AbiLFEC3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Dec 2022 23:02:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230348AbiLFEC1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Dec 2022 23:02:27 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06C2C22B2F;
        Mon,  5 Dec 2022 20:02:25 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id hd14-20020a17090b458e00b0021909875bccso452847pjb.1;
        Mon, 05 Dec 2022 20:02:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=GxJ6ul68u180AtVN4nQh0WHt0yT7zOpzV9hXJDFZMLo=;
        b=Tp59IgO4ZGd1EihgNcau2gKogXQ+6GvDlxMqYMW6uaCDyCqkgmIOPg04qqA5yDfCeJ
         DC1iS8xYnpFw0K/KI8BFQ7uH1Y0DR0nA1ja7fbxcbxo+ElkH0ZjOpTH9HF+yGUVMc2m3
         /QSNKGtyAmCqlPPAbmAPNY85Kq9k6YpTk5m894ejrUECIJ2KznKqFsrAENx9QGNPyEJj
         dK3wLzq1dr+q+GVLy9SwJZ5PWktISYaOyFxK8tsRnXI8aUu9251YqWttxASqUQfSh3QT
         a198z8ad/vCPDzt52am082DPuLVGIi9lD0/qxXiPuxTgw+bV2yC4WA3jKkf2J+gxMdoN
         zJXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GxJ6ul68u180AtVN4nQh0WHt0yT7zOpzV9hXJDFZMLo=;
        b=28dWUkhfNjBz4bQmtyTJIm4AIj470iwxcwhO+WrHVQX8V5CgWm0lCCT33HAp4+Bg8E
         a6crBEF8q8/sRthRJ01b7/9dtIrWGurr8ONU/6c0xHF6Xn5Jo2JWc0JBrRI4WRPlOTjp
         6Nzxkqf82zdjYW1z+aVacfiDuu4ds646vuJzwpT1N+pB+vAY7SvMIc+57eOwshTBelOa
         wCGfMmzzqZOVN3S0w9eEVV/2tA1qyRBPNAJHmxEoUI0HHOVcp/pYpz+i9mr15Oe/iQQu
         sJi1nkNT7ENbdrDz8nKykZw8G/f0d1mtuaHU9j+Y+181+5m99ZaV9sgb54HYjXZhhzhq
         c1Iw==
X-Gm-Message-State: ANoB5pmQAxCAogh+l7LyOywpr4VDmh4I7NfUR1Cn4LdJAGy0+EfjxreX
        nTnPgmnEXful7xyvIRCgcoo=
X-Google-Smtp-Source: AA0mqf4ehpTHzhprPT5QWnH2VhKKXF2yIO5dSxMYnVq8qYo5Bmv8np+h62HZzf245xRpCtDmLxgTag==
X-Received: by 2002:a17:90a:b390:b0:219:68f8:7aad with SMTP id e16-20020a17090ab39000b0021968f87aadmr13117425pjr.34.1670299345519;
        Mon, 05 Dec 2022 20:02:25 -0800 (PST)
Received: from debian.me (subs02-180-214-232-2.three.co.id. [180.214.232.2])
        by smtp.gmail.com with ESMTPSA id y6-20020a17090322c600b00188f8badbcdsm5825822plg.137.2022.12.05.20.02.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Dec 2022 20:02:24 -0800 (PST)
Received: by debian.me (Postfix, from userid 1000)
        id B4EFB104011; Tue,  6 Dec 2022 11:02:21 +0700 (WIB)
Date:   Tue, 6 Dec 2022 11:02:21 +0700
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.15 000/120] 5.15.82-rc1 review
Message-ID: <Y46+zXhrp3LY0cuA@debian.me>
References: <20221205190806.528972574@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="2tKqQ4RZLc+GC7Hr"
Content-Disposition: inline
In-Reply-To: <20221205190806.528972574@linuxfoundation.org>
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--2tKqQ4RZLc+GC7Hr
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 05, 2022 at 08:09:00PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.82 release.
> There are 120 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully cross-compiled for arm64 (bcm2711_defconfig, GCC 10.2.0) and
powerpc (ps3_defconfig, GCC 12.2.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--2tKqQ4RZLc+GC7Hr
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCY46+xgAKCRD2uYlJVVFO
oxqbAPwMTSRGCfPvqvWwCe1OiuvnlisHnp2D1teuZLaHOvzTBQEA63snzrTGh0pB
gfsZ0xaZh7DyWXXNDjwyNfKX441t8QI=
=NAxP
-----END PGP SIGNATURE-----

--2tKqQ4RZLc+GC7Hr--
