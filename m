Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB2CB5B84E4
	for <lists+stable@lfdr.de>; Wed, 14 Sep 2022 11:24:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230239AbiINJYr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Sep 2022 05:24:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230301AbiINJY2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Sep 2022 05:24:28 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CB9412AA9;
        Wed, 14 Sep 2022 02:14:40 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id v4so13739522pgi.10;
        Wed, 14 Sep 2022 02:14:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=9Sm8BuJCKOw/7ve49E73E8dLVl2QHG7RIkyTESNWTnI=;
        b=Ud/6nYUmRE1Lbjm0KHwipbsDjWMrMlKdfuFpt7j1aKXUcC7e5viQI3VFd3Oi7wvEMR
         e8dpCW4qSl7YOqF3M5/zt6nJwZ2njGtBYeRWAQ/uItecQfLuJZjvrtwOi24Gc+gNCa3x
         YmwEQLFiCaq4x42GOMmvUNVnZD9g3eumMglYvl+edquIAv5S/Ozk4F4KU2EzqVDfqk6D
         f2c+DFgIzzN2c4VNFgiugSUeLs1JjaB0G0YHY3DUHjSjwqrj6Nec70Cbp3hF4HJQaiki
         95O9ZhhNf3Gic1q8fnOrSrl61VKI0bV0qTHwzf36mFdPTo5Qpl/vvSb+BWaY+zhp3bP7
         vgqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=9Sm8BuJCKOw/7ve49E73E8dLVl2QHG7RIkyTESNWTnI=;
        b=xe4KBqRNDXrz+0jflZ58QpdVhLZw2hbnkTcD5881l4wSFcifv1qq4niOzx9SPH2OUy
         JDwl0JSDe3DQ4nAgDNROMQssredWmOJDvP+R5noQ8b8tftFl2npZ4Vn8AJolDPr9av8w
         5DiOWFQPpY7r8dyiT61IXxs3x60nZx7KWM2lKeJAd3EHYp+NeAF3MpG+MLomVsd9EBZI
         uMKbaT/psmtj4/HojMjnafQxws9RRIOaLkLZtvK3LGtxcHp8rR39mhLmJXBvhfPi3/Ee
         F3znQZR8CPeDbwMk30z4WAPP7bbyWKTQL2V1xUk92GMJ/1dD1ksxkZsNSaBk8LhwnqfJ
         mnEA==
X-Gm-Message-State: ACgBeo3jkHR/SKBVzsOxsjlpk1EJxNIFGmteORTaNvXVAPeWhUpulYS9
        hxD44OXC1Jc/wdZMGFHt+bU=
X-Google-Smtp-Source: AA6agR5WqJ1pUd0eLbs6/YEGNGoFtZKCXl+eBH+TKmHIJPZYUEBGfW77IKWs7h9h1vaanjpvpJM9Lw==
X-Received: by 2002:a63:3247:0:b0:434:6959:ba0e with SMTP id y68-20020a633247000000b004346959ba0emr30774397pgy.22.1663146839291;
        Wed, 14 Sep 2022 02:13:59 -0700 (PDT)
Received: from debian.me (subs02-180-214-232-18.three.co.id. [180.214.232.18])
        by smtp.gmail.com with ESMTPSA id d7-20020a170902cec700b00176ea6ce0efsm10110197plg.109.2022.09.14.02.13.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Sep 2022 02:13:58 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
        id 1CEC7101AB4; Wed, 14 Sep 2022 16:13:54 +0700 (WIB)
Date:   Wed, 14 Sep 2022 16:13:54 +0700
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.15 000/121] 5.15.68-rc1 review
Message-ID: <YyGbUoXVo9jCr0Tc@debian.me>
References: <20220913140357.323297659@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="4jla4i78/Btsokmp"
Content-Disposition: inline
In-Reply-To: <20220913140357.323297659@linuxfoundation.org>
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--4jla4i78/Btsokmp
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 13, 2022 at 04:03:11PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.68 release.
> There are 121 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully cross-compiled for arm64 (bcm2711_defconfig, GCC 10.2.0) and
powerpc (ps3_defconfig, GCC 12.1.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>=20

--=20
An old man doll... just what I always wanted! - Clara

--4jla4i78/Btsokmp
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCYyGbTgAKCRD2uYlJVVFO
oxxCAQCWeHdlBoxK4UF6gYhDalIKQu21mp1l7+qTQqHL8Xh9HAEA0QbmWQ6GcdGe
Pm85tdYK4/lV7KbTfzx3hrpXLUkvEQk=
=Rcrh
-----END PGP SIGNATURE-----

--4jla4i78/Btsokmp--
