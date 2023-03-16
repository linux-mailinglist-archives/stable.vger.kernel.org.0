Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6313C6BC745
	for <lists+stable@lfdr.de>; Thu, 16 Mar 2023 08:33:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229513AbjCPHdi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Mar 2023 03:33:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229801AbjCPHdg (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Mar 2023 03:33:36 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CC9E87A0C;
        Thu, 16 Mar 2023 00:32:51 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id e15-20020a17090ac20f00b0023d1b009f52so4443780pjt.2;
        Thu, 16 Mar 2023 00:32:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678951970;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=mcPnUDp2uPpFN6qrWcVm3iA+36dQ0Mwojauq/GYuGW4=;
        b=ZaZ3pYmrfSmhTMW5BBDjL1MqZX7hSqr6gXshR3sAa4llWu6OeqbDC/ByJgP93L7nS1
         uw9j2oJjD6Z4J/DtUEUZEuZ3w2Z8RvAU8qFlhP6ACpNNa/YuSs5B/TMXKhuMY4lnl3HL
         wo+q6GQLL24y6XPzI/qNTHGz17K3C+MSKhmGpRntuSpAygK53xocuOkiqgiP/G/gFg2W
         ObWbAKfWFlgkv9MBHruJ/6z7hWZ4iGbk7rldpk0HgXPiKIkBr0ySD/9IUJtBjwu0+/f9
         vbDbz17GvYhUScSyjyR6kgJp4qfiaw5PIQ6lBldCprmlb7F0q5ofdJbDkMnnuZChYjhx
         O/bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678951970;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mcPnUDp2uPpFN6qrWcVm3iA+36dQ0Mwojauq/GYuGW4=;
        b=YCNLvp0B1eTkq3IUn8kHKOG0IEvA9rz/5RqiQlz70x1brY2ZmEBsQB4L492MzaUr//
         Sff8j/GzCUAG19ERQrXsuKWP3i2SXEMgJpbOI24DnAeEToPX8OPAGXcuT0+4AAnig+jL
         7T3vhubJy1Fn1mFXokSg68zV2SE+eGJvrxlvk3UlbODrPLlvGEnn9wgq7tRVx4+icj0J
         DTA6EeGHdJPWjyIdKXsE+9C1OF3/5tr611WcOMVeZcrbQSS9rGhlMwpDCggKl48+47oq
         bytK/8ynjhlH/zYeo8uj4UslvesEfwFroYSODtYOcu/uo9YuXfJNTScfpAE4kXvGGSAI
         s5lA==
X-Gm-Message-State: AO0yUKVQNtQXvfOhxn7MTcEg/kI6PyfoKW2OBRfjins+AJ9wT7Iqd3fV
        45lQ2pllT+QluuZTrJ4Uan8=
X-Google-Smtp-Source: AK7set865NCA1infzuQT4Lgx3KiWiQEfKzG0o8erq89WRRWzoiYAbpJp60OseRunjgh6Xp05mWY4jg==
X-Received: by 2002:a05:6a20:144a:b0:d0:15c9:4e68 with SMTP id a10-20020a056a20144a00b000d015c94e68mr3272692pzi.62.1678951970418;
        Thu, 16 Mar 2023 00:32:50 -0700 (PDT)
Received: from debian.me (subs02-180-214-232-12.three.co.id. [180.214.232.12])
        by smtp.gmail.com with ESMTPSA id x48-20020a056a000bf000b005a8a4665d3bsm4737711pfu.116.2023.03.16.00.32.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Mar 2023 00:32:49 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
        id 70D4B106628; Thu, 16 Mar 2023 14:32:45 +0700 (WIB)
Date:   Thu, 16 Mar 2023 14:32:45 +0700
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.2 000/141] 6.2.7-rc1 review
Message-ID: <ZBLGHXo4qyKSbwRh@debian.me>
References: <20230315115739.932786806@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="4u63Dz9MIHxlaJJw"
Content-Disposition: inline
In-Reply-To: <20230315115739.932786806@linuxfoundation.org>
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--4u63Dz9MIHxlaJJw
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 15, 2023 at 01:11:43PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.2.7 release.
> There are 141 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully cross-compiled for arm64 (bcm2711_defconfig, GCC 10.2.0) and
powerpc (ps3_defconfig, GCC 12.2.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--4u63Dz9MIHxlaJJw
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZBLGGQAKCRD2uYlJVVFO
o8IAAPwKodi86HHP/TskrBp/C81NuVFDWI/xo8jE01KzRIsHwQD/TQx7O0h028VJ
oLgvOjKwksu4N03a8yN8IRLMDWZjWQg=
=fgnM
-----END PGP SIGNATURE-----

--4u63Dz9MIHxlaJJw--
