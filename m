Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DE5B59AD21
	for <lists+stable@lfdr.de>; Sat, 20 Aug 2022 12:08:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231132AbiHTKFU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 20 Aug 2022 06:05:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244085AbiHTKFT (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 20 Aug 2022 06:05:19 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECDB95C9DD;
        Sat, 20 Aug 2022 03:05:18 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id s206so5512545pgs.3;
        Sat, 20 Aug 2022 03:05:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=tKANqQNee213Fd/MH26P1ahBy0H/vTClvInzOpycDPQ=;
        b=EAkpKzxMJkOPTWnUlmb2CUsHw9u47BKWVGzqphvLp3Dt6WFNbCydqG8IAzVdncr5+d
         QYvykDEAhe3VketIPcgGx8EbVZDzcu3KqGkx7MYFaD2jMqaqZcvcUaEAFXYzFimsYJ0f
         wbHxQig6pgxeTI0/mjBlMzbB5MkcR2ktcM62KF/texEBEKpbvUjCFhsHxEkZUilGlwK1
         +kYrAzRYR51KGQN9DDIktb5b3BcYY8raTe8Fj9p3nrmwXj9/P45yon9CZgfmZsoRL25X
         0QBJZLpaema1P9CltWARkIyKmFbYQPHjU3hKJSAd5xn6RsS32CBohR3t/HD8O9K2LOMJ
         QZYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=tKANqQNee213Fd/MH26P1ahBy0H/vTClvInzOpycDPQ=;
        b=sk8cvvL+rAnKYA6RgCuYttW/G2OzKD125OpQ8gR7cPNNaXPYuDCddrOrlGRqa1UTvw
         M/eI/UkfEg/mmK5DJwxYE+Flfh9QE9EPhBm7tUYXSt1Py/C8NZ2Zq2GZM0L/JkxS2zXO
         y8o1wXfrd8JB2EG4jHARTK16ifUaFoLHsVQGVhEqEDxk4bPAnhO/tGxpjElbgKK+2/25
         YXiLvi+U8menh6AVeFIy17f0eEJu5xDiqwdRE5un+IUPnnELCpGSksP0DFcTQKKLK5fl
         2rO+hC1eoxrlhRyob8t8ovagqrVHXd+6CCeXXp0qgPAN2hc/MdtoyUIBLFRRdj4jwIbq
         Y9Iw==
X-Gm-Message-State: ACgBeo290Q0/67w5bsx8R0wkJj80R8yfhu/8b8dh+frx8td+eTgeRnQj
        v3XHpJR+6GnLQWr+Ve+RWEejpsGs98k=
X-Google-Smtp-Source: AA6agR5huIMoODVzf0guzrRUeEu0JIDZ5FWRD6Cl2qMKPZSarnM0VycodFaKlF5GqBGvImfh0xsqjw==
X-Received: by 2002:a63:e011:0:b0:42a:1c12:17a9 with SMTP id e17-20020a63e011000000b0042a1c1217a9mr7947156pgh.557.1660989918453;
        Sat, 20 Aug 2022 03:05:18 -0700 (PDT)
Received: from debian.me (subs03-180-214-233-14.three.co.id. [180.214.233.14])
        by smtp.gmail.com with ESMTPSA id n8-20020a634d48000000b0040dd052ab11sm4032801pgl.58.2022.08.20.03.05.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 20 Aug 2022 03:05:17 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
        id 3F0D7103C69; Sat, 20 Aug 2022 17:05:13 +0700 (WIB)
Date:   Sat, 20 Aug 2022 17:05:13 +0700
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.15 00/14] 5.15.62-rc1 review
Message-ID: <YwCx2fX6phAM7UQC@debian.me>
References: <20220819153711.658766010@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="aqquMfmXNv50FzKY"
Content-Disposition: inline
In-Reply-To: <20220819153711.658766010@linuxfoundation.org>
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--aqquMfmXNv50FzKY
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 19, 2022 at 05:40:16PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.62 release.
> There are 14 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully cross-compiled for arm64 (bcm2711_defconfig, GCC 10.2.0) and
powerpc (ps3_defconfig, GCC 12.1.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--aqquMfmXNv50FzKY
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCYwCxzwAKCRD2uYlJVVFO
ox7XAP9Zwh23hgxZ1XCQ06JRl1rpeD5XEjxF3Gz8WE/oC4hwzgD+PkaSoz3ckdSO
u2V67Oq8OOAIRZcELqWpTFT1xeEWNQ0=
=cwS8
-----END PGP SIGNATURE-----

--aqquMfmXNv50FzKY--
