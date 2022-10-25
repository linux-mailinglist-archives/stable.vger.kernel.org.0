Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0EEEC60C277
	for <lists+stable@lfdr.de>; Tue, 25 Oct 2022 06:05:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229528AbiJYEFg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Oct 2022 00:05:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230194AbiJYEFf (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Oct 2022 00:05:35 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99084DFF7;
        Mon, 24 Oct 2022 21:05:32 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id 78so10405768pgb.13;
        Mon, 24 Oct 2022 21:05:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ZQa6ftKOheF7CVATYu6FGbp0ocnWZwF8PVY64lyLhoM=;
        b=hnMBzTT/cC+QpgngwxCnviZIQzjKtd72bF1nCGbpL4eaVNjJWPfojj18zD4tT3jko2
         nMN558xxJQwpU/Wx2G+QBMijIE7n28uWV15+9SuXz8V8qcmTrZ0fDcF+0RZrb4DVoPPu
         PwGgIxn+UrrKfpEVhNVGu4ToOw0chE6cCsur7vgskqfWIDL5+sLpFINkhfe2TeaYyAkg
         PdY82lCWAuSQo0udCArLMVBOo3mivsMlnItfR2fAddePHWCIy60/RMeRc1eAztnFZ2s/
         6oKDX8dKnZa5KjYNGqFyQX+m4CTpDLRt0hfES+KoCHsrIRT7z9QiMpxSOeJ8aybUC9q4
         stEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZQa6ftKOheF7CVATYu6FGbp0ocnWZwF8PVY64lyLhoM=;
        b=JZdvTtqZozl8U7VbfiqOPikwgyF3u+NOq5OxGRqbxzojc86H9TPr4cfAb6PxaDYEQo
         cQVlkGkZXxvuXN/JHgZtH0oSwQ75jhO80GvbBnLaxHkwpYFEp7p9Wbnn6IrzLJPnlJQx
         MRBJznyW0l28ugH5PPwAmaXrmXZbfw5sHglfNEHhXXHnKr4BDP7d5jU1hsowj531oBr0
         mLtIFast1+QEdDz4BZSdH/4Ptu/r4/U0sVvMWn7dJmW+bZEJhnX6nOrFKmsTQp9BiUqI
         aJ/w4MScdgMdKdZxbx4P/XEQ8nZt7bTdlEYMRRowqy+hDAAuORUQJgePj701V0bQh7mg
         BH1Q==
X-Gm-Message-State: ACrzQf2643y77N6FN/0n9GBctdnaXkUGwPvFmmSZEx1v8MUb2PigdfId
        YiamAu9mU/ZVGSAub2VSz43VGWWktWRvMw==
X-Google-Smtp-Source: AMsMyM5aLirzYvsaFJweXIINNc5ABMyu6YOfTm73ZNmGEVGPvNk11aavIDjtVqLOyv17TwASEHRaSA==
X-Received: by 2002:a63:4384:0:b0:43a:18ce:f98a with SMTP id q126-20020a634384000000b0043a18cef98amr30641470pga.273.1666670732126;
        Mon, 24 Oct 2022 21:05:32 -0700 (PDT)
Received: from debian.me (subs02-180-214-232-7.three.co.id. [180.214.232.7])
        by smtp.gmail.com with ESMTPSA id d197-20020a621dce000000b0056c231d80bdsm243778pfd.157.2022.10.24.21.05.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Oct 2022 21:05:31 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
        id E3E53103F53; Tue, 25 Oct 2022 11:05:28 +0700 (WIB)
Date:   Tue, 25 Oct 2022 11:05:28 +0700
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net
Subject: Re: [PATCH 5.15 000/530] 5.15.75-rc1 review
Message-ID: <Y1dgiM1at60Wcm6a@debian.me>
References: <20221024113044.976326639@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="CPDhycYeX2u+Ftac"
Content-Disposition: inline
In-Reply-To: <20221024113044.976326639@linuxfoundation.org>
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--CPDhycYeX2u+Ftac
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 24, 2022 at 01:25:44PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.75 release.
> There are 530 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully cross-compiled for arm64 (bcm2711_defconfig, GCC 10.2.0) and
powerpc (ps3_defconfig, GCC 12.1.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--CPDhycYeX2u+Ftac
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCY1dghAAKCRD2uYlJVVFO
o28sAQCIDUU53Pc0rdKeJy2JyG9rwTLfnnnVxWqlB/OdqTal5gEAp1TyJRpB61yL
Jx8ayi8DSfTgWlePXWc32DGZD+Wl9w8=
=mgsc
-----END PGP SIGNATURE-----

--CPDhycYeX2u+Ftac--
