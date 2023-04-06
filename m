Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61BBB6D8D9A
	for <lists+stable@lfdr.de>; Thu,  6 Apr 2023 04:45:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230296AbjDFCpD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Apr 2023 22:45:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234501AbjDFCom (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Apr 2023 22:44:42 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 142D7903B;
        Wed,  5 Apr 2023 19:44:37 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id f22so32145136plr.0;
        Wed, 05 Apr 2023 19:44:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680749076;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=oZDEZxZL7BBW3xh9tIxL6hZNJCCHQuMtGQKbxKWBlwE=;
        b=gXeD6Y1fAewNZTZqhuvjTPf8M7+annlEk5SyhKG4YzNg6IerDS5oW0dwxx1Vfl6EwD
         LjoMS9paiU6K4Pjh1zdlZ+VN+Cbi8gF9w1ez1S2a7z/HaVvrTJL47B+s5PvXujiXEWz5
         sxA4KUrRfB/ZyXrDBXf/Gt9ARI4D544xNN1gy223K60kIOX0Ej0/RD13ollF8bnnKTay
         B3qaF19uqKiBdIv+m3Yk9uY1G+v/geK1VexXfqieQuAdptOXj3AoU2pRMVW5p7St/rhq
         VwYYHvnUFuAgdLT0igNdnAxaY3HikbRzn7uIwgu2XOJtTmLCqbF3edPOL/QA5Cxwj+f9
         4Rzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680749076;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oZDEZxZL7BBW3xh9tIxL6hZNJCCHQuMtGQKbxKWBlwE=;
        b=DS5a0bYZ0OG3t320hlrmgVps5Tz/Uz83F5PiZBsHtD6BG4Y3fzvJ+Mr5z8tEXxlFo7
         IhjD44dBqMRXeVaV1wKWEpAYuHxqENIb5fFmiO5DNthVsYZEa7H+G91gDxnlArFK0tsC
         dFbDtxbla9TNvhDjxIm9VtP3FOdq0dNl7dapRqkTrXKPkNs1DHT7lIB50JotrLgXVQuh
         a7rhZzyB2YKC+8QhujUqFFCwKdNQ/VJp7pyC9JLCCdBgQ84CEDWgQ/H5x7YNnTvBECvC
         Cy92NyecJe6j6n+bVpXxWo1FqpYLPkAQ1aASJsH1uT0dEGyonLRewGBxYPQwFoWzUVJJ
         CBpw==
X-Gm-Message-State: AAQBX9eyQP5buhUE5ij5rIx0tHPuGOaLm1BFCx/Ou4x/107uAOqpnWXn
        3jwz3mcgruEQwWyl57WMkRM=
X-Google-Smtp-Source: AKy350aaHoTNYvn3xjIDtrcygA6BrWrs2uocaFRjy5+25cEqn3vExzxr1gA8HlF6UBePIz15UaJLYw==
X-Received: by 2002:a17:90a:8281:b0:23e:fa90:ba37 with SMTP id g1-20020a17090a828100b0023efa90ba37mr8394686pjn.49.1680749076239;
        Wed, 05 Apr 2023 19:44:36 -0700 (PDT)
Received: from debian.me (subs02-180-214-232-14.three.co.id. [180.214.232.14])
        by smtp.gmail.com with ESMTPSA id d14-20020a17090a498e00b00234afca2498sm1988964pjh.28.2023.04.05.19.44.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Apr 2023 19:44:35 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
        id 312F31067E2; Thu,  6 Apr 2023 09:44:31 +0700 (WIB)
Date:   Thu, 6 Apr 2023 09:44:31 +0700
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.1 000/177] 6.1.23-rc3 review
Message-ID: <ZC4yD2ts7JRPjsSJ@debian.me>
References: <20230405100302.540890806@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="UjSs2hH9lS8IKAD5"
Content-Disposition: inline
In-Reply-To: <20230405100302.540890806@linuxfoundation.org>
X-Spam-Status: No, score=1.3 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--UjSs2hH9lS8IKAD5
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 05, 2023 at 12:03:38PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.23 release.
> There are 177 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully cross-compiled for arm64 (bcm2711_defconfig, GCC 10.2.0) and
powerpc (ps3_defconfig, GCC 12.2.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--UjSs2hH9lS8IKAD5
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZC4yCgAKCRD2uYlJVVFO
o98AAP0bADVBrvSx7OjHQkW//t9JqaO/Q/GOFj/F4ZojjtT6ZQD+KWtCVzNpUtnX
wc71snwNTeR2wNMk3DQzt0zw9S46rQ4=
=SAoo
-----END PGP SIGNATURE-----

--UjSs2hH9lS8IKAD5--
