Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A5F6605625
	for <lists+stable@lfdr.de>; Thu, 20 Oct 2022 05:56:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229736AbiJTD4Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 23:56:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229705AbiJTD4M (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 23:56:12 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEA9B18F0E9;
        Wed, 19 Oct 2022 20:56:10 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id 128so18115552pga.1;
        Wed, 19 Oct 2022 20:56:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=AV9TkL64f8EryzYSWR+XKMRafaeWR3q9mnusUL28onA=;
        b=qFkD9UoQQelTumN4QL6xP3gSR7E/uVxIxg2E8nRGK+E5+UdNVajNiQIc/DPlU4bJ6A
         VV3UN93YE5+rK1OOYMnwf3QuP3VtwTlmXRV7ukaR7H2LZPMYbFhRWKDuGySzS6Gm9EUV
         lQATsGaN623adi94t8DTFWHHqdK5Ag6tE0eWHKapztopoeDBSXanyssts/6Xj7VYD762
         JIOVVMuD4CBMzY5kHsQqnuX6vjJi/GH53vhj22O0QtCtS3b9avYG7GlfD576maGZypWX
         uWrPW9VoaieV3xyjG13P5g+hN604U0wXNa0Yn6n5yV0dCdITF7dqegINAI/q86Fng0R4
         FzPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AV9TkL64f8EryzYSWR+XKMRafaeWR3q9mnusUL28onA=;
        b=kO+VKOPFenP2P/cpWCwd+E8O+DXPU/EPKKIIs+Pd39UD8NEuB485SZjLHP//ZNmtw4
         efvrCs2PIyCbNHgT33xxdChtSJIJ63V0v5FVmMY4oO9KwkrXuQgplOOgIU/3YrXWNoyR
         5jNztq/HgF5CM94M11QkACdTSW0o5lO3bHXOF4TS9pFNjXfdEWhRIev5WdBv5zRMw/ZZ
         9pg+RpDyZ5IwpZktC303e/UzL/yeN617HeO23dH7syJ+BKJ2ljkI+cjRd1pjOeh1OjJa
         RoFewPTAyPjqMqNGmZ+M2zC590V9lb7x0MVJ9YqkrPzecwhUvA7dSMc9VG/cnOcJVBxN
         whww==
X-Gm-Message-State: ACrzQf0KQFilvTfvTl7Icmp0WgSJ4L2rjlRjfanm55Nc8MgxprlMXeRz
        vvcHdiueRJ2Ou1dMUIitiJ4=
X-Google-Smtp-Source: AMsMyM6NFpoW0vVh7ctCoRMLGFB8G5hxPu4ELdM1Sgn80+S35orjkyRnj5jSa7ADCHnBl1GidI1ZZQ==
X-Received: by 2002:a62:a512:0:b0:536:e2bd:e15e with SMTP id v18-20020a62a512000000b00536e2bde15emr12017967pfm.1.1666238169878;
        Wed, 19 Oct 2022 20:56:09 -0700 (PDT)
Received: from debian.me (subs03-180-214-233-92.three.co.id. [180.214.233.92])
        by smtp.gmail.com with ESMTPSA id x22-20020a170902821600b00178b77b7e71sm11372081pln.188.2022.10.19.20.56.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Oct 2022 20:56:09 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
        id B044E104199; Thu, 20 Oct 2022 10:56:06 +0700 (WIB)
Date:   Thu, 20 Oct 2022 10:56:06 +0700
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net
Subject: Re: [PATCH 6.0 000/862] 6.0.3-rc1 review
Message-ID: <Y1DG1ksysoftm/0p@debian.me>
References: <20221019083249.951566199@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="WZ8734L5XWBrSw5m"
Content-Disposition: inline
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--WZ8734L5XWBrSw5m
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 19, 2022 at 10:21:27AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.0.3 release.
> There are 862 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully cross-compiled for arm64 (bcm2711_defconfig, GCC 10.2.0) and
powerpc (ps3_defconfig, GCC 12.1.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--WZ8734L5XWBrSw5m
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCY1DG1gAKCRD2uYlJVVFO
o2UqAQDcTRPaWijtQH6myMU2loohCmaj4Z+oyITVACcSwkWIqAD/WQAGNpn/bECU
4mhFooqe9oWLvpN8HqmgtKSdrCZLqw4=
=U236
-----END PGP SIGNATURE-----

--WZ8734L5XWBrSw5m--
