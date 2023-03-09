Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DC246B1A3F
	for <lists+stable@lfdr.de>; Thu,  9 Mar 2023 05:00:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229639AbjCIEAH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Mar 2023 23:00:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229634AbjCIEAG (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Mar 2023 23:00:06 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0970F67031;
        Wed,  8 Mar 2023 20:00:04 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id 6-20020a17090a190600b00237c5b6ecd7so4694701pjg.4;
        Wed, 08 Mar 2023 20:00:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678334403;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=IO2HukOAG93wp8Ck/l5gtQzjgmqxHWZs4HqHAokMTKA=;
        b=XrVkrppvNGPofaZJVDKW+UcWN4PGB7IFH9Mt8St75HAlYwY4J8HPbWp4qtLToingyL
         3HPKVVKermidtivDYR64f+PZHBjiIgSvauctV/e56dP9sKoYBKKy+2I7vHTPo/GtNevA
         FVn3DifuijKV5IxvCEmGTNKWMoHb6AErvEbs8//SF0UEYwGsmMG2SPUhGhPbW1bnsNgz
         LKNPbTg2d9ieDJX7C914HxNbXHRHqurkcjypwU4B4/MPGBbyxbna5RbiLzw0h5lSAto+
         iIPLVGLBDNHLcD1NuIhbkulaWqtCYQMjQj+cT7wYKhaBCXJw7hR2HoUyPQFcpz/LwDYz
         hQMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678334403;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IO2HukOAG93wp8Ck/l5gtQzjgmqxHWZs4HqHAokMTKA=;
        b=MnW0zTwk2F9d2xv7dFGilxtS4Dgyg4ivhqRg1BrjKmotbUK21J2pmN5VmbqNgg9kdP
         72ZEmZujOBZRXiadABEb1Y40H6xC+V5c46L1Ib7hA9rmmtc+/Kf7vdEwMfU/eypnsx2r
         ia/t2+AFD5Nuqycd3G//zRzKYnyWFgmpGj8MyQw7pEYoP6vLtNs7E8ENb4q5yEeNwijr
         v1yGDO7OUu6SP9Jx8+eeAmN0jeuu5yQe2PW7Oz5aYDhZxIdtDTiI2npmgd8czShozZp5
         Wj/fOSM7IBiDp5mAMkezEPhvtwzujxndlLIj0GTied2gzNIovp9sMGMV0iBN3/XIjsjz
         SL0g==
X-Gm-Message-State: AO0yUKX2L6TzpLUe/5UMkFfPABZaE5tQ11qoX5fVFAtCteJc7Ozy2rtB
        pJ0mHqhRJEfcEv5Kp6c0utY=
X-Google-Smtp-Source: AK7set/GXvNVsUXMfn40uSuXeO/48WlgjZkGxN/0XvUoJtna33EVZloRC19GjsBxtbQ5hHDn4//frA==
X-Received: by 2002:a17:90b:180d:b0:22b:b375:ec3f with SMTP id lw13-20020a17090b180d00b0022bb375ec3fmr21656005pjb.21.1678334403424;
        Wed, 08 Mar 2023 20:00:03 -0800 (PST)
Received: from debian.me (subs02-180-214-232-92.three.co.id. [180.214.232.92])
        by smtp.gmail.com with ESMTPSA id hg23-20020a17090b301700b002371e290565sm515139pjb.12.2023.03.08.20.00.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Mar 2023 20:00:02 -0800 (PST)
Received: by debian.me (Postfix, from userid 1000)
        id 5DE391065B8; Thu,  9 Mar 2023 10:59:59 +0700 (WIB)
Date:   Thu, 9 Mar 2023 10:59:59 +0700
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.1 000/887] 6.1.16-rc2 review
Message-ID: <ZAlZvzlxbKJogWq7@debian.me>
References: <20230308091853.132772149@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="PSKV5YBeP0Oo/tua"
Content-Disposition: inline
In-Reply-To: <20230308091853.132772149@linuxfoundation.org>
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--PSKV5YBeP0Oo/tua
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 08, 2023 at 10:29:31AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.16 release.
> There are 887 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully cross-compiled for arm64 (bcm2711_defconfig, GCC 10.2.0) and
powerpc (ps3_defconfig, GCC 12.2.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--PSKV5YBeP0Oo/tua
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZAlZuQAKCRD2uYlJVVFO
o4SjAPwP/J9BipfSry1EAT7kRickV5Q2gbtX4F1PSR0mPORC7gEA/eXdjx2yHGPs
3aX1XpNOnb8qcepsW8mGOHXAwfgcnQo=
=eiKx
-----END PGP SIGNATURE-----

--PSKV5YBeP0Oo/tua--
