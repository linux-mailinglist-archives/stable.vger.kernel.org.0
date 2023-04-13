Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8AB56E03F4
	for <lists+stable@lfdr.de>; Thu, 13 Apr 2023 04:04:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229508AbjDMCEg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 22:04:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229506AbjDMCEg (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 22:04:36 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80EC42708;
        Wed, 12 Apr 2023 19:04:35 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id la3so13313324plb.11;
        Wed, 12 Apr 2023 19:04:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681351475;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ajXeZFI8jDvtkOHsMQMABautHIWSEDNr2zJAikW9Y5I=;
        b=nGhWlGViKx7JsP8m+E64vXcsXVwRQXtDGsqbNUW/2A+5nilH7de59kUQkbvASq0w+H
         FuOeyrt+i8F/X4f5h8RX8WnzRPZWXm3SgeXe/Lo+n+rpkLCHZAyYyCkpWDEyYadufCc+
         snlxhl8RmsBXmKVF5hj92SoBTlRnZb0pRLdA6j1p0JPe8OY4RZb3ZZrXDB47gb0toyGI
         LJ7GuCWLKJmL5ggkw18LyE7PxBzb2siDBnShGIoJ6aHv/28wHRCzuR7351aazjCuuyFS
         eFbBTMVumbtAa3AurbrWXcbqj9BdBN0/LapM2EMYrRiKUpcEo//mRMAQFs6ztcWXeZ+h
         +pbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681351475;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ajXeZFI8jDvtkOHsMQMABautHIWSEDNr2zJAikW9Y5I=;
        b=Wu2LaxgyhfQOoDOaajLq/uOn1zfjE/a2bjIFa90XegLOo/Ok8Z9NbX8khXxJMYJm4e
         A/QwAdwzGteKbYRfKWaZQyVq0uc9Dui5dolMEusCoNSYsdukaw1IoQmMQxBf8FOQx7Kn
         64ITyWvRethr5sxsIy1KGadsYTuTSHEj+E5uw7U58hI3ePBS5PJjUTyutq/Jm5n93BEd
         x0EUwjg+8WVD+NowpROD2BHPgkngt7hNTj+KRqp54QEqwKHnyRoDuwHjLJn9uympiyV5
         zwun6kCL7BYTI7a42nQTxkjNrBze2kDbpabaqRHwpwxRoUju1nddEUyx2vJD4rCimKx0
         RftQ==
X-Gm-Message-State: AAQBX9dFWzO0pnXtj38n5PvophlOLXEX/tkdKvHZZlFJ0DA9k2fyH7XN
        gBTOpPCuNmS21vJzfUbwrq+jDp59kad22Q==
X-Google-Smtp-Source: AKy350YG1Xw5IfPU4j8wcGusQdvHQ5APfvIMoCfGXApM6E1B3+zb9oh16odZhkilqeKNTJMcB63p4A==
X-Received: by 2002:a17:90b:3005:b0:247:ea8:1ac1 with SMTP id hg5-20020a17090b300500b002470ea81ac1mr199984pjb.11.1681351474926;
        Wed, 12 Apr 2023 19:04:34 -0700 (PDT)
Received: from debian.me (subs02-180-214-232-2.three.co.id. [180.214.232.2])
        by smtp.gmail.com with ESMTPSA id m2-20020a17090a858200b002448f08b177sm2102636pjn.22.2023.04.12.19.04.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Apr 2023 19:04:34 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
        id 565B51068D3; Thu, 13 Apr 2023 09:04:27 +0700 (WIB)
Date:   Thu, 13 Apr 2023 09:04:27 +0700
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.15 00/93] 5.15.107-rc1 review
Message-ID: <ZDdjKy+gIuXRB7IY@debian.me>
References: <20230412082823.045155996@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="6wlRiPRhQb7nvgTG"
Content-Disposition: inline
In-Reply-To: <20230412082823.045155996@linuxfoundation.org>
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--6wlRiPRhQb7nvgTG
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 12, 2023 at 10:33:01AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.107 release.
> There are 93 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully cross-compiled for arm64 (bcm2711_defconfig, GCC 10.2.0) and
powerpc (ps3_defconfig, GCC 12.2.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--6wlRiPRhQb7nvgTG
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZDdjKgAKCRD2uYlJVVFO
o/XOAQD6VtxrfW07Yh/9GLGU4xmpF5WJ673N3oT0/7F2PSy1bAD/RA9KaDOaYBOJ
a5VSzD0+ecaol5Vi283zC9ejO6G32gY=
=Y6eA
-----END PGP SIGNATURE-----

--6wlRiPRhQb7nvgTG--
