Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96EF35B0421
	for <lists+stable@lfdr.de>; Wed,  7 Sep 2022 14:43:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229747AbiIGMnZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Sep 2022 08:43:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbiIGMnY (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 7 Sep 2022 08:43:24 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A2F7B602E;
        Wed,  7 Sep 2022 05:43:24 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id d12so14405809plr.6;
        Wed, 07 Sep 2022 05:43:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=OxouQ5WxLpijwv6+yghkWHdrcMoOwxdw8NO7YqYNjyY=;
        b=SX6UqCQLtoKG2CC3reO2d9Myf5PacChWgHFvZAIDQjifSOk3nrK10lWB4+B312mOD5
         UQF8S6NuClZcNvcayy9ZVEB8+hW48A0c1ZIx7ZA+aQ1ZOcFW0aHCJIHEVAFKI7tSHCcM
         iFmkwfYn9rggvF6V8BQJZT3lGRamSP9y1TcAueh7DK1la8BIjWZtY5Q4P178wrgW4FbR
         RHnK1ti8goUXju6QUyixEGhDDYutYfEf6gawRR7rC3Xj06WbFX4gNxOndGcvmHtwqnza
         0JDRlT5QrBGuCJZ7IuGbK3GDcZ8m/phF+7IoQ4oo963vBRPeVQXK7vcMl6UO8biu6rZo
         nokA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=OxouQ5WxLpijwv6+yghkWHdrcMoOwxdw8NO7YqYNjyY=;
        b=uqBah+MFAHvl2U8/hPevfJTfI449hb5g7ge7cBs18q+2JgfJURfw/WJ81y2FfjJJ8I
         ujAstA9ARwqym/tbX7QUlMKifFWaueMXd/3HHovC8sLXz+ux5HFDUF7la/01P/bvIOi5
         CErr9MdtMqZ5e3Rr5hLQXw3b1bhSuMFvyE8/F9E026hfyDxmOPq3DqjjJy7oSzZYpfHa
         lKWR+lqzob5nybNkJATf4Mb4eiVa5fzC/9mjAmC/M55FGB70Hq1htoX5Xmc/hrjdx97P
         EhzjfKI+oOW1grwr19xJQYqkLN4xVkKU/LgFktlBYVUjf0kTJEzjWhgnm8e+j6tIh8G9
         2J/Q==
X-Gm-Message-State: ACgBeo1RS8DI9+OE3AleOiEcdmDxbcncMVtsuyyf0GTZQdScTRKKshLu
        RKsnODbdW8ShIRn70wMOOvc=
X-Google-Smtp-Source: AA6agR6uE1c1EGxGfC6KSrOBWSEMrLUKA3oWheaqXMwdlvYTdK6x9Qjjg/P3rXJKEQb7RaeZW0HiMQ==
X-Received: by 2002:a17:902:ce8f:b0:176:d5af:a175 with SMTP id f15-20020a170902ce8f00b00176d5afa175mr3756453plg.123.1662554603657;
        Wed, 07 Sep 2022 05:43:23 -0700 (PDT)
Received: from debian.me (subs03-180-214-233-9.three.co.id. [180.214.233.9])
        by smtp.gmail.com with ESMTPSA id jb1-20020a170903258100b00176953f7997sm8823420plb.158.2022.09.07.05.43.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Sep 2022 05:43:23 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
        id 6F1DE103154; Wed,  7 Sep 2022 19:43:19 +0700 (WIB)
Date:   Wed, 7 Sep 2022 19:43:19 +0700
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.19 000/155] 5.19.8-rc1 review
Message-ID: <YxiR5/TLJz8gF4/i@debian.me>
References: <20220906132829.417117002@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="dqXNDUcoD0oOGUsv"
Content-Disposition: inline
In-Reply-To: <20220906132829.417117002@linuxfoundation.org>
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--dqXNDUcoD0oOGUsv
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 06, 2022 at 03:29:08PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.19.8 release.
> There are 155 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully cross-compiled for arm64 (bcm2711_defconfig, GCC 10.2.0) and
powerpc (ps3_defconfig, GCC 12.1.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>=20

--=20
An old man doll... just what I always wanted! - Clara

--dqXNDUcoD0oOGUsv
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCYxiR4QAKCRD2uYlJVVFO
o3N3AQCQ7ovJeAmsdf4F/zQCExVGmluCMm4OS9MtQ80FO3EbTgEA4cGk2ZeOJfYX
IHaU7W5LTKNHEA4hgwAj+AgmoyM+Dgo=
=d62W
-----END PGP SIGNATURE-----

--dqXNDUcoD0oOGUsv--
