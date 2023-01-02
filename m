Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3EC365ACFB
	for <lists+stable@lfdr.de>; Mon,  2 Jan 2023 04:36:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229830AbjABDf4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 1 Jan 2023 22:35:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbjABDfz (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 1 Jan 2023 22:35:55 -0500
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACDE21CB
        for <stable@vger.kernel.org>; Sun,  1 Jan 2023 19:35:53 -0800 (PST)
Received: by mail-pl1-x629.google.com with SMTP id jn22so28356588plb.13
        for <stable@vger.kernel.org>; Sun, 01 Jan 2023 19:35:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=e2Pv+OIm9JtqqgUxb9G45aGd0O0p1HZYI27332d+heM=;
        b=fSFis/WZU6FCSfizsfWoQwMrxzNxDXLfbCxJqStd/5Wipbx29OTITrKmhjH2ojlF4A
         UpRgEo3YNeNfpKGxFnBGCYMI7ue30PxFSR9A5C1Vw4YIbqwwgEmjeJh4gYc+zx2bB3so
         EhyEnfiv3omKpMflaI8ToocNLo06QNpMQB2Rf7hX4YXDf2z+Jz94m+Tal/OGV/1qXEVg
         HpWIuMWz7QqRiwScNld20BAfHuoengWbeldIWAOVWGgAoy+JOSe3y+0VDh5zs79wlXU9
         rXwnaYbeLq9nPni1/8jbE7vKq3QuZU9nZULmu4nszzxjNTAOVpLT8sEm49+TZpPHr7KF
         l18w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=e2Pv+OIm9JtqqgUxb9G45aGd0O0p1HZYI27332d+heM=;
        b=luj3IA/3zGeF+mUHF44Yj11XC7mf7u2Si2pGRm+X09OL5gRHZVnLvv8xVIwsFWPJSz
         0mv7N36ph38gPCGvEWv29co51myOQWfN6CAjm3u0QrOkfPPhp7AUsGMtdJkwdt7UCb00
         qe2hDKiUukmNIdnk9dGgwznBTDUqWHoFxesey70CP/bfgN8FJ6Ru66O06M85Z4+pAvDr
         BODsdRId4bn2vIRK2WnKWcwmYaEKVQTXJ6WlkQmJ3ProNcuIJD5sfjEF6xPRURLjfmW6
         oRz81TZoa6MbWdxtaIAkDzsF5eH3rou25cKjemq/I8bchDwNbVqjA/CBhVnUWDz+GsZ9
         OQEA==
X-Gm-Message-State: AFqh2kpaaPZvZXNskRKEImOIWGl+sFd22AO1iZJMfB1M6MfpSIj2Z9vQ
        2vVScSt98TxHxFG1NYFIVQv/XtyBvfI=
X-Google-Smtp-Source: AMrXdXvOhDRrKDTS5PsnZZUqPLSBnU9X47V9wkuR2qi3fClZdCufb//pkxJOz1IvOulTA8+mEpYZFQ==
X-Received: by 2002:a05:6a20:3ca5:b0:af:ae01:54df with SMTP id b37-20020a056a203ca500b000afae0154dfmr67962586pzj.11.1672630553120;
        Sun, 01 Jan 2023 19:35:53 -0800 (PST)
Received: from debian.me (subs02-180-214-232-21.three.co.id. [180.214.232.21])
        by smtp.gmail.com with ESMTPSA id o28-20020aa7979c000000b005809a3c1b6asm16006009pfp.201.2023.01.01.19.35.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Jan 2023 19:35:52 -0800 (PST)
Received: by debian.me (Postfix, from userid 1000)
        id 0DEAA100151; Mon,  2 Jan 2023 10:35:47 +0700 (WIB)
Date:   Mon, 2 Jan 2023 10:35:47 +0700
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     Willy Tarreau <w@1wt.eu>,
        Lukasz Kalamlacki <lukasz@pm.kalamlacki.eu>
Cc:     Greg KH <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Subject: Re: Cannot compile 6.1.2 kernel release
Message-ID: <Y7JRE4yO6ZOj0HyH@debian.me>
References: <b0ef1e48-ca8d-9a5e-6e21-688711dab650@pm.kalamlacki.eu>
 <20230101065337.GA20539@1wt.eu>
 <d3f0d0a5-a15f-9735-5f12-b1c00a474531@pm.kalamlacki.eu>
 <Y7FIo0Eup6TKswTA@kroah.com>
 <187e8f10-2b73-3a18-d9ad-48b2d84bd6b9@pm.kalamlacki.eu>
 <20230101100518.GA21587@1wt.eu>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="hW1EhVx4zigraI6f"
Content-Disposition: inline
In-Reply-To: <20230101100518.GA21587@1wt.eu>
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--hW1EhVx4zigraI6f
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Jan 01, 2023 at 11:05:18AM +0100, Willy Tarreau wrote:
> >=20
> > To be precise I have this on gcc 10 in Debian:
> >=20
> >=20
> > during GIMPLE pass: fre
> > drivers/media/pci/cx18/cx18-i2c.c: In function 'init_cx18_i2c':
> > drivers/media/pci/cx18/cx18-i2c.c:300:1: internal compiler error:
> > Segmentation fault
> >  =C2=A0 300 | }
>=20
> As Greg said it's definitely a compiler bug, so it will interest Gcc
> developers, or your distro's gcc package maintainers in case it's not
> up to date. There are toolchains available on kernel.org here:
>=20
>    https://mirrors.edge.kernel.org/pub/tools/crosstool/
>=20
> The laest 10.x available is 10.4. If it works with this one it may indica=
te
> that your package is lacking some recent fixes, so it might be a question
> for your distro's gcc package maintainers. If it fails it indicates a bug
> not yet fixed in gcc and your distro maintainers won't be of any help her=
e,
> you'll have to report it to the gcc devs instead.
>=20
> Note that they'll very likely ask about a reproducer (and most likely your
> config). But a quick test for me with this driver built as a module on
> x86_64 with gcc-10.4 from kernel.org doesn't show any problem:
>=20
>   $ make CROSS_COMPILE=3D/f/tc/nolibc/gcc-10.4.0-nolibc/x86_64-linux/bin/=
x86_64-linux- drivers/media/pci/cx18/cx18-i2c.o
>   (...)
>     CC [M]  drivers/media/pci/cx18/cx18-i2c.o
>   $ ll drivers/media/pci/cx18/cx18-i2c.o=20
>   -rw-rw-r-- 1 willy users 33920 Jan  1 11:00 drivers/media/pci/cx18/cx18=
-i2c.o
>=20

Hi Willy,

I can confirmed that no segfault reported when compiling
x86_64-defconfig + CONFIG_VIDEO_CX18 using default gcc from Debian 11,
so this can be hardware issues.

Thanks.

--=20
An old man doll... just what I always wanted! - Clara

--hW1EhVx4zigraI6f
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEARYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCY7JRCQAKCRD2uYlJVVFO
o/gPAQC++Ygs6IQbnwWhft6u2jVbK5uQRicqh/Zhl7bcGRdhiAD+Lna30fX323Fc
f7SmAKVHiki4lejFt9vBMoZShafqlQs=
=Odwx
-----END PGP SIGNATURE-----

--hW1EhVx4zigraI6f--
