Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 803735EBBE1
	for <lists+stable@lfdr.de>; Tue, 27 Sep 2022 09:48:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230376AbiI0Hs0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Sep 2022 03:48:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229687AbiI0HsZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Sep 2022 03:48:25 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09B957B28C;
        Tue, 27 Sep 2022 00:48:24 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id 78so8663244pgb.13;
        Tue, 27 Sep 2022 00:48:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=zi1Y8jSaMyM1hXTYB71esr2odkqj9tfK/vSz550IFdI=;
        b=DTkOPXoWCgNZARijQYixdNfLvEfl8XBhwtEdWCDIB25wfX/3EUoOf9l8IukW8POB6U
         kW4AIVXclTr3fdyEJDbwLYr8LBt1Up0h2a3tFybX+z4MjPs4n8nSnq6YT8ADCEtyDg2K
         Suk/GdH3WCu19HOcx/j+q5N6+x5OG13M04AZNMHfbtZ1mkeA70LFV0uggSQLte3cnp4A
         Il004X6f5cy4++w8VX9x2C1NTVr2JNy9GsnZOcDlsHm2VpAZA0OsbbUk2eVFcexhEWNq
         D9Kcm/cetMSmsHmF6h95HWsLG/TU5tb04RXfK017qugk6W9LpdDgClO2m59aD/3Ws1LA
         tQWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=zi1Y8jSaMyM1hXTYB71esr2odkqj9tfK/vSz550IFdI=;
        b=4RC6Cae9u82++bIKZ/K/BC6SrLICvsv6Wk1R/zgYBx/bgob5AZgL1xLqdjAZpFdFo+
         aENgrdEwfV3vD1M7pJWbxzdsgB0GhrGnA1P+PeCmSPF+VDvUuNmvb+pnZ6BkjFLBlfK0
         DwdyqaKtl3JMhKOAmUi0wWdoODGNhqFt+EZe2oY1EbHnKrjXA4HydHOVMwEELIp0G2Zh
         ooofnAcFQ8lbkyFUDlBAZ+u+DtqYjxPEZrjrG8C5VjkAiUE0aW0QuxLO9dfWuoaGtVnH
         6b3EXIUU+09dA/fBDxJcTvusZjm0/Qfm0HNNfdqylsIY8M0WmgDTQDiwcGwgSj2ENZXX
         SUOA==
X-Gm-Message-State: ACrzQf3GubHuRjE4yQTShrzr+K2XXZJuvAZif1K/4jaoROgJP9ISs062
        UkcL/UhDB9MrSAmgNr+GT/S5bPc6lyY=
X-Google-Smtp-Source: AMsMyM545x9gn1r5MfJu04xCCdCypw0uxJLuS6vVcN3LHH6OdfsdjcucZ3m6jP/qG0rDiuH4MYMXAg==
X-Received: by 2002:a63:6206:0:b0:439:54e1:c220 with SMTP id w6-20020a636206000000b0043954e1c220mr23109702pgb.445.1664264903508;
        Tue, 27 Sep 2022 00:48:23 -0700 (PDT)
Received: from debian.me (subs28-116-206-12-32.three.co.id. [116.206.12.32])
        by smtp.gmail.com with ESMTPSA id w22-20020a1709026f1600b0016c5306917fsm802263plk.53.2022.09.27.00.48.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Sep 2022 00:48:22 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
        id 9EF791037F7; Tue, 27 Sep 2022 14:48:15 +0700 (WIB)
Date:   Tue, 27 Sep 2022 14:48:15 +0700
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.19 000/207] 5.19.12-rc1 review
Message-ID: <YzKqv29Z+6/LsJ9x@debian.me>
References: <20220926100806.522017616@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="P65GX/BAqZEjdHOC"
Content-Disposition: inline
In-Reply-To: <20220926100806.522017616@linuxfoundation.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--P65GX/BAqZEjdHOC
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 26, 2022 at 12:09:49PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.19.12 release.
> There are 207 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20
=20
Successfully cross-compiled for arm64 (bcm2711_defconfig, GCC 10.2.0) and
powerpc (ps3_defconfig, GCC 12.1.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--P65GX/BAqZEjdHOC
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCYzKqugAKCRD2uYlJVVFO
o9ViAP9ChpOBeXQV1hOCHANj9896r8IN4zT2Z7q14Ec4VosnNwEAl0HLiy7zVfGe
iUgOyaJj5R66MCc9PgjUtUTwqaI70gs=
=QSRu
-----END PGP SIGNATURE-----

--P65GX/BAqZEjdHOC--
