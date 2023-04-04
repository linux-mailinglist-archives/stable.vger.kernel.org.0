Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 667106D56D5
	for <lists+stable@lfdr.de>; Tue,  4 Apr 2023 04:40:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231749AbjDDCkR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 22:40:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbjDDCkQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 22:40:16 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FE0110F6;
        Mon,  3 Apr 2023 19:40:15 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id iw3so29975628plb.6;
        Mon, 03 Apr 2023 19:40:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680576015;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=hsLwm1EHEyYDkMQeHbfyAFU1DHax2tvFD0Ukhfp5Sv0=;
        b=CjX4dSxmTaHcIZNVM+5KTB0uMtfMLjwba1P3tYomisUYidCXZQNo56NPNrDX4pCvkt
         fNR1Kfop8036+6DQEY9aOXz7i+ycHbEgdsSy9zez/gq243TioUCbWSaPkGQlY3eRFast
         ht1uOAVTjXaZG+n9dshKFMroRswPrgqUF1sz1IfP7I2fFM5+6f7TdMX/ECJTE/vznZzn
         EM/v/TMxMMlnKHIeNCtSTX+5WFLr2XvUZs1Gx+TdE/1uMGDgwHlS8sEWtwplkTzzFjWH
         K1bO5zJrT2k7l0xurQPeLRa88t+DMDXsNscooCrnXZOAkXRF6zff2nJQSpsAENH54p6r
         zIBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680576015;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hsLwm1EHEyYDkMQeHbfyAFU1DHax2tvFD0Ukhfp5Sv0=;
        b=Ck+Kd0TOkRWjMczJ4Qe2MCrA5cF1IUH9Tzb6MLjH1sn2w3imDRCnJYfW4aTrv5uD+1
         K8vjva1l1tkgLyRKaNrVHmN8jW+PXc3H71JcPUnLSiu3gm9tWBiajSAJZDIXSS1vcmEm
         gDHc7KYzWaKA/oeV8JwgWmwTZxC5JGmpOomb9qm5TSWxhZTEi1QC9ODigMGJRtybaxQX
         1PQYVGWmdSLvKH14vGdDtBMJfvLETwUWKihtnX4k5A4bJQwBogeiCLt98nJoMZkT++Pq
         Eq6bqZVmHOfB3NJ5bPYsPF0BjlrPecPgclT3kZIwDpaKICDpk6HyiXXWl/riAUx0rgyV
         kK4g==
X-Gm-Message-State: AAQBX9dPa4RrVkQmwmhB6TbGnYAhv1HtUISqtP8+neem8iqWBNUuArmK
        loro4kqIJMGNLKry2t0Mu88=
X-Google-Smtp-Source: AKy350YFNg5wvUZ9P/AmY87H662bqvjMmoajBJYjuohMKZW6W7mUmwO78p/ypMuDupfhL008SKG8CQ==
X-Received: by 2002:a17:902:da8b:b0:1a2:89eb:3d1a with SMTP id j11-20020a170902da8b00b001a289eb3d1amr1069723plx.6.1680576014814;
        Mon, 03 Apr 2023 19:40:14 -0700 (PDT)
Received: from debian.me (subs28-116-206-12-40.three.co.id. [116.206.12.40])
        by smtp.gmail.com with ESMTPSA id k17-20020a170902761100b0019ef86c2574sm7183350pll.270.2023.04.03.19.40.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Apr 2023 19:40:14 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
        id 53C6B106782; Tue,  4 Apr 2023 09:40:12 +0700 (WIB)
Date:   Tue, 4 Apr 2023 09:40:12 +0700
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.1 000/181] 6.1.23-rc1 review
Message-ID: <ZCuODJdxJkCjY3ZX@debian.me>
References: <20230403140415.090615502@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="anJnbe9DFqrdacgl"
Content-Disposition: inline
In-Reply-To: <20230403140415.090615502@linuxfoundation.org>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--anJnbe9DFqrdacgl
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 03, 2023 at 04:07:15PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.23 release.
> There are 181 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully cross-compiled for arm64 (bcm2711_defconfig, GCC 10.2.0) and
powerpc (ps3_defconfig, GCC 12.2.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--anJnbe9DFqrdacgl
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZCuOCwAKCRD2uYlJVVFO
o0gOAQCqAr2QFDL+2lMaXECBwGwFcP8Wd5CN/kUcefb3Su4eoQEAub0jBU60FnWy
NynWfqburQIpfiAofFITDDvnxrmUTw4=
=/QAC
-----END PGP SIGNATURE-----

--anJnbe9DFqrdacgl--
