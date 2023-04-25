Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 956FE6EDA48
	for <lists+stable@lfdr.de>; Tue, 25 Apr 2023 04:42:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229637AbjDYCme (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Apr 2023 22:42:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233155AbjDYCmc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Apr 2023 22:42:32 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA759A5CF;
        Mon, 24 Apr 2023 19:42:31 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id d9443c01a7336-1a6c5acf6ccso40716255ad.3;
        Mon, 24 Apr 2023 19:42:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682390551; x=1684982551;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=E3sSpTQyJae640NPfdp+kpnpJCBMCY3ZeP3l1VrRYZo=;
        b=h0oXTRaMIBOlAgxpQI2FtydYC5qR1yb1IBDDQ7EvpbImoXXJZRX/6u/1V8Kx1NlhLe
         e3hqy1gdxg8NgXN5fG5ZQHKZR6bmprLO5eWO8UaUjJUCjzCx6JcDnSB6xZra90vFNsxf
         pO96kYXVEaBDDV6pplG5FvkXJCCHQr5zinyqRoR9mxTbh4sakx4EoX3IrViqFAUFYXbP
         pmwDR0/wsOTSMYHL4fAaUMKR+6Dz/25glJVFX1cF1ZmWF19hky47xeFTml4h/rQHSGzP
         FFwfNOLOotr6lzB8L4MiG7svo4Nbp8iJWzmwV7n++3sQvNRRvvxRXdw2KA68kgCdgsm5
         MdLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682390551; x=1684982551;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=E3sSpTQyJae640NPfdp+kpnpJCBMCY3ZeP3l1VrRYZo=;
        b=ijcjCcBy19QuEL1MfjKz1HHjV1Ut16N93l5MPdRTGN3KbVCteD3f/15VrwfaaH6TB9
         WOzkP9Si99ZX8h4UOWBojcP1oU7x3Un3r/OTEawftt0moGiZf1J6SvRZVFCWqA+9AGKD
         N58FCEn2dsH7yWBhHoSwiLjBnVTT6yrZpaX3MZXwT+qN1p4GbcXR1TvAPnewLiepq9YX
         Sd61ypLZTxx3r2eiTly2Bg1QlhTInXD4USe56MWjqXQxgMh4o/FUJJBk98znru+xtDtm
         oDlI2swG9Ob32WJl+r05RY+TusSs1kCHUgReitkd48EndohPc5NvSrxiah4K7ZnB//h2
         gaVw==
X-Gm-Message-State: AAQBX9fgInvlofyi50KYIDCJOh+clS8vLRsnY54hXJOfI/0sI7doOsH2
        kxBbv1HgoTmFRcwuhlsn0kA=
X-Google-Smtp-Source: AKy350bkDsXlhnThiUfY5xtHWu5hMzNUt8LAU6X5/MqXswyEXhHWB/aypyTqdSsDLXvBA5mkaZXgxA==
X-Received: by 2002:a17:903:40cc:b0:1a0:6bd4:ea78 with SMTP id t12-20020a17090340cc00b001a06bd4ea78mr15871117pld.31.1682390550952;
        Mon, 24 Apr 2023 19:42:30 -0700 (PDT)
Received: from debian.me (subs32-116-206-28-29.three.co.id. [116.206.28.29])
        by smtp.gmail.com with ESMTPSA id y18-20020a17090aa41200b00244991b3f7asm11009480pjp.1.2023.04.24.19.42.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Apr 2023 19:42:30 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
        id 27F3C10692C; Tue, 25 Apr 2023 09:42:25 +0700 (WIB)
Date:   Tue, 25 Apr 2023 09:42:25 +0700
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.15 00/73] 5.15.109-rc1 review
Message-ID: <ZEc+ET2ZDSOKobZc@debian.me>
References: <20230424131129.040707961@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="D2HFOL+8vcKbRPmn"
Content-Disposition: inline
In-Reply-To: <20230424131129.040707961@linuxfoundation.org>
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--D2HFOL+8vcKbRPmn
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 24, 2023 at 03:16:14PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.109 release.
> There are 73 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully cross-compiled for arm64 (bcm2711_defconfig, GCC 10.2.0) and
powerpc (ps3_defconfig, GCC 12.2.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--D2HFOL+8vcKbRPmn
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZEc97wAKCRD2uYlJVVFO
oyg2AP9d1m/sOUSzCIzB4Tw2fgdvWE5MqCVgQ5n29CgsSxl5rAEAlsfVavMIS7G7
a3ANvdmm6QjPrFLQ9FVrjHG0X8++Lw8=
=/YEe
-----END PGP SIGNATURE-----

--D2HFOL+8vcKbRPmn--
