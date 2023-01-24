Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3210A678EAB
	for <lists+stable@lfdr.de>; Tue, 24 Jan 2023 04:01:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229717AbjAXDBJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Jan 2023 22:01:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230149AbjAXDBH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 Jan 2023 22:01:07 -0500
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E12112074;
        Mon, 23 Jan 2023 19:00:40 -0800 (PST)
Received: by mail-pg1-x531.google.com with SMTP id 141so10490721pgc.0;
        Mon, 23 Jan 2023 19:00:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ps8P+XN+oxQi8oHNpfWLccmysd9PKrw80go/ffUgGeA=;
        b=H6jLd68ft6RqwkVwL02BVT1WOF7rU+suIdYL5oYRc1KfctSQ/mitQ4Z6+0GIprcfcD
         l3GoDx6RX//yWvInQWx3VSLROYE04uGFBEWo0GnEUJVYDIntuCVCDniQmzqkV9JFGpiV
         tGGbb/dWI8OZEHdsJ8vbdAsIjFjUkKS0G/xlTU8vjQvIROv+FzJtHQEIcv939oUOphyW
         U1zLZXxOvliDzP/GvY7zZCJFvvgaKMOdbYe8LQEcPgqs4Vhy64bwcFI39T44H7JPQXzK
         ahfTB8OmmnJFqqgvIby848MPAc7GBqic7aGY0852R4EPR+xrum86aKrQ4/F00FneEmF9
         BDsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ps8P+XN+oxQi8oHNpfWLccmysd9PKrw80go/ffUgGeA=;
        b=k6we654kCRCVb19I9hG6ikv0X+ryVP00YxQHkDQblDq9l3F1n75uX55bVeefB7mZIz
         +MEUBPtcbpOTXWXYM1W5jdvHcMs0RrPwDLoH6hRkQgfT1rYTpa6b2Ol24Ouo3Ub9DbP2
         PoLNAQHUD6WHQpusgjztzPWKcWu//L5URIzINZNQabhOmAQ4nTa61OTsUOmajQprBEty
         RIWekz21Z65kDPEeuwabch3R5EHy8WqBUhlMt55QVIBN63+v66KHoQrrGU1vFvYAvLGf
         Zrv+lGavtZw8+Gm2qqisr5eQBCS/74F9YFzmPBmFdq6JLFlA5iIzoELrTiAwdFCGP55a
         /7Ug==
X-Gm-Message-State: AFqh2kriSGdV1DiADnRcxaTTvU9hWZec6K2Ec0FpRjW/JltrjJKe+WB8
        LZp9qKnZBdQt2XA2mZMNixU=
X-Google-Smtp-Source: AMrXdXvjW7goOcrvw5zdkHTxXC2mq9cCUz2U47tuIhFiTb7N0lfMp9jpvx4UoBuX6lXDpW1FGhUJHQ==
X-Received: by 2002:a05:6a00:bef:b0:58b:ca6e:af26 with SMTP id x47-20020a056a000bef00b0058bca6eaf26mr25774324pfu.23.1674529240103;
        Mon, 23 Jan 2023 19:00:40 -0800 (PST)
Received: from debian.me (subs02-180-214-232-19.three.co.id. [180.214.232.19])
        by smtp.gmail.com with ESMTPSA id 127-20020a621785000000b0058e12371d96sm308527pfx.164.2023.01.23.19.00.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Jan 2023 19:00:39 -0800 (PST)
Received: by debian.me (Postfix, from userid 1000)
        id 4ECEC105170; Tue, 24 Jan 2023 10:00:37 +0700 (WIB)
Date:   Tue, 24 Jan 2023 10:00:37 +0700
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.1 000/188] 6.1.8-rc2 review
Message-ID: <Y89J1Tt6AtEgHSib@debian.me>
References: <20230123094931.568794202@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="rRnKlST7qnwbnDsG"
Content-Disposition: inline
In-Reply-To: <20230123094931.568794202@linuxfoundation.org>
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--rRnKlST7qnwbnDsG
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 23, 2023 at 10:52:24AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.8 release.
> There are 188 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully cross-compiled for arm64 (bcm2711_defconfig, GCC 10.2.0) and
powerpc (ps3_defconfig, GCC 12.2.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--rRnKlST7qnwbnDsG
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEARYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCY89J1QAKCRD2uYlJVVFO
o97UAP9lxcmdiC8bMBcM7Ywem6zppD6fgnLyYoZH7gLaubymEQD/e4i35EBbO3p3
A18+P9AKheIvcWKpF6YImMjqKH95kQI=
=iLIx
-----END PGP SIGNATURE-----

--rRnKlST7qnwbnDsG--
