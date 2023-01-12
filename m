Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 801686668A5
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 03:05:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235778AbjALCFC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Jan 2023 21:05:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235511AbjALCFB (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Jan 2023 21:05:01 -0500
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EA1D1A832;
        Wed, 11 Jan 2023 18:05:01 -0800 (PST)
Received: by mail-pf1-x430.google.com with SMTP id x4so8641913pfj.1;
        Wed, 11 Jan 2023 18:05:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=5g2uMGvAQ9S4h07gXUEIs/07hwwQtHkE2RiRVVv/MIU=;
        b=hUwowIH50OyZvlhdjvmD2v5h9jayW2UkKoNo8+AWuMgNr9n0VKk3TAeml/7ofi1ncE
         Ii8lo89oFy9DuHY8KXwXXyBjniKz1/rzzIV6zPVG+1bl5tQn8PBvKHfIzoNQKCvEC3xg
         BSCi0jSVn290Kyzje3V6CAbsL+zLqjPMU1AfWrlO5Kg81V1tHfYc2WGTlGYGmod75C5C
         CuzV2WL02Tv7JEja0RKZz5SAnI43cMkX7DdKvf3CmF+1q1o02to5tAVL/a3XEGy3sBzb
         GYd4/XYwsM3LaDejrlsQe0tp0pHRawLt1ONQsoprKbt8FRS9eXgCP82vCgAR5jXmXWi1
         8S5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5g2uMGvAQ9S4h07gXUEIs/07hwwQtHkE2RiRVVv/MIU=;
        b=7lS0rs8p0DFW/yCeBmfo6At+6cBVjb0G9GD7tcZiwsAWAz58EWY/UsI9GQzwIuh7xb
         qhe0PFu6M4RLTkYNOj8G04opNama/TFlrpYp6Yn+Vc+VxiBJc7eAZ+qMD+8FSYdttqLu
         PWJYfIWKk+Sm5s/7u+ZGH9u49Byxgu/ysLiH2kuWBFOIMRJ3yXBUlAPpvGnw2jtd2jCd
         pnF3wVdhmArQ7zcU4Hqt23WNHoCjFWSYpP8QNCFAWtgIsYn67ueU9pLt4SziPTKPLj9E
         aHrK0x5P5MgHLhLNSxzlF7slkJvlQIVQeD8D6heA42w7EYjZxFVxWu4ca46apEqjhzMa
         r83w==
X-Gm-Message-State: AFqh2kqY/3Hh52gqj58hUlFhVm7Nel1Nt9iy172992vgXrPU+pUDMTBJ
        YfRj5L1EELzzWmC26SQpR9+usOw5yc0=
X-Google-Smtp-Source: AMrXdXujpyNgYfIuvMR1sPABQ4iHiN8Op4JoJf11GjEals2lMk8qhFHs1aqkVY3Tr46Qmj0ONhne+Q==
X-Received: by 2002:aa7:8701:0:b0:583:319a:440b with SMTP id b1-20020aa78701000000b00583319a440bmr24517279pfo.24.1673489100730;
        Wed, 11 Jan 2023 18:05:00 -0800 (PST)
Received: from debian.me (subs03-180-214-233-89.three.co.id. [180.214.233.89])
        by smtp.gmail.com with ESMTPSA id y12-20020aa78f2c000000b00581dd94be3asm10664666pfr.61.2023.01.11.18.04.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Jan 2023 18:04:59 -0800 (PST)
Received: by debian.me (Postfix, from userid 1000)
        id C868F101401; Thu, 12 Jan 2023 09:04:56 +0700 (WIB)
Date:   Thu, 12 Jan 2023 09:04:56 +0700
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.1 000/159] 6.1.5-rc1 review
Message-ID: <Y79qyJNeeOp1WFEI@debian.me>
References: <20230110180018.288460217@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="Ze+BUts3BFtX4u8t"
Content-Disposition: inline
In-Reply-To: <20230110180018.288460217@linuxfoundation.org>
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--Ze+BUts3BFtX4u8t
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 10, 2023 at 07:02:28PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.5 release.
> There are 159 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20
=20
Successfully cross-compiled for arm64 (bcm2711_defconfig, GCC 10.2.0) and
powerpc (ps3_defconfig, GCC 12.2.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--Ze+BUts3BFtX4u8t
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEARYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCY79qwgAKCRD2uYlJVVFO
o9gHAP91ceB+gU4YWNrniP4fjm2zh10jwDsaj1smTHxHDDOrIwEA+nz/+TCP3TrD
SkMY/WSoV5tbZlWgLRHj/hjhyzVtSgY=
=ftxh
-----END PGP SIGNATURE-----

--Ze+BUts3BFtX4u8t--
