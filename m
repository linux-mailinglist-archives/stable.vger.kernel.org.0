Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA5425ABDF9
	for <lists+stable@lfdr.de>; Sat,  3 Sep 2022 11:27:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231753AbiICJZ3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 3 Sep 2022 05:25:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229667AbiICJZ1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 3 Sep 2022 05:25:27 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E30845A894;
        Sat,  3 Sep 2022 02:25:26 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id w139so4101084pfc.13;
        Sat, 03 Sep 2022 02:25:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=Ewk0nk4wTlKkKkfzvpkFb8Ugz6vHAQN9pFS8k+GvnaI=;
        b=Gi6HhJVBmbpDteA23N20m0rt8DHPMcdvoAT5rmDz/ZXJccYRb6hnzpGgrXH+zfW1FZ
         ojSYfnBItJAhDLc9qZlxLlCHyeM1C4b6hvJFY8gQ2BAYGajy4iB3wCRs9IBhNJyOr6V3
         CYLpo34p+7gesyhM7fwL9s9dX3Z/mtdYTzS2Z/GFmoDV4B6YyAsPy0XxWOZ6n/fUT6sE
         RhPIGFRlRkIBAldKnfNNpAS9CYDMnZKQsRn0XBnDU6JtJ/nPDeQiY8cKE0f/GuSvnRIA
         u6EivcHfo32wNBc4S6IQ0fAA9+iloMwvmemnZgs+v4YrliCHGoy0L0JyB7aNdQdxbPeC
         FCsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=Ewk0nk4wTlKkKkfzvpkFb8Ugz6vHAQN9pFS8k+GvnaI=;
        b=knQqBKVmA+Vh8b18VIQPTn/gnwqNWp+tDYfbgNA/zNIfKI+5h9UIZwcWDDaLupqskY
         BbdKO01j8/nQQjt3dHuWBoqbrmXyLTreIVVCfB81HYlmMKm6+LSaZg/di0LFiGGNC8Ft
         FvVzpS2qO19sTchHf1aL1l/d85+AJnBVftIhBQdLlg9cBsI9BtOW3spOXFEAiLmS0mkz
         2vu7k99QIPW2Xr8ITYFreJ1LDbruzAVT0r8gS4NcLH1C5xssBQC5//4dLCY+0nYRBUYf
         AdB1tjLUhEoJb9E522Ai6jJTXtxPsRxm0PTfL3rsTXGN4FqSXNptwAzSi635Dnpi47gZ
         EZwg==
X-Gm-Message-State: ACgBeo03WSO2ouM5AEHrysuVAbdUYuehsYQU3li6bm8vJXtXmr2UE3z8
        +9N4FPqbMOxa2EwvTljPvzY=
X-Google-Smtp-Source: AA6agR6hnmHf/DO+TBqjgJ297vGta83KydhpwZLAzZJxdyrN/fwJY81CY0jj0KQtMl0MGWTdbXA9+Q==
X-Received: by 2002:a05:6a00:2185:b0:520:7276:6570 with SMTP id h5-20020a056a00218500b0052072766570mr40458030pfi.84.1662197126346;
        Sat, 03 Sep 2022 02:25:26 -0700 (PDT)
Received: from debian.me (subs02-180-214-232-86.three.co.id. [180.214.232.86])
        by smtp.gmail.com with ESMTPSA id o11-20020a62cd0b000000b0052cc561f320sm3358539pfg.54.2022.09.03.02.25.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 03 Sep 2022 02:25:25 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
        id EF0DB103D36; Sat,  3 Sep 2022 16:25:21 +0700 (WIB)
Date:   Sat, 3 Sep 2022 16:25:21 +0700
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.19 00/72] 5.19.7-rc1 review
Message-ID: <YxMdgcPPy9hJx34J@debian.me>
References: <20220902121404.772492078@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="dEcUBkpNWOxk8+Ch"
Content-Disposition: inline
In-Reply-To: <20220902121404.772492078@linuxfoundation.org>
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--dEcUBkpNWOxk8+Ch
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 02, 2022 at 02:18:36PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.19.7 release.
> There are 72 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Successfully cross-compiled for arm64 (bcm2711_defconfig, GCC 10.2.0) and
powerpc (ps3_defconfig, GCC 12.1.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--dEcUBkpNWOxk8+Ch
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCYxMdfAAKCRD2uYlJVVFO
o6eyAP42Lix2mH4GH++lD3n3Qy4T3Nsxa0PK0vKKw9UEn6MToAEA4qK+S0pDh8R0
h19beqm4AeNCNUBhymNGDsNwcGkqTQY=
=AtO9
-----END PGP SIGNATURE-----

--dEcUBkpNWOxk8+Ch--
