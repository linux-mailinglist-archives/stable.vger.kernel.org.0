Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 468C05F3BEF
	for <lists+stable@lfdr.de>; Tue,  4 Oct 2022 06:03:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229507AbiJDEDF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Oct 2022 00:03:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229508AbiJDEDE (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Oct 2022 00:03:04 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C00D1B9FA;
        Mon,  3 Oct 2022 21:03:02 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id 83so5123380pfw.10;
        Mon, 03 Oct 2022 21:03:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=6IBUCmIrofhg+K/SA4flUI5d3XejH0Spk4DKsFVxSPw=;
        b=deYHb7IbNet3141nffqPO0lT77Y2untGmXQMB80i1hzTRwiAsbJKZo/fpP/Fw3mwma
         yavJCNxYVnewdwP7PY2fLqg/BlFNrtZ25n6MtKV+wRdDHEthvXHs3A0zpaioEj8hhEM4
         G3Nq+7KAKlp+Xqmnx1ngXbpoSlPR3ewDDyx5F1TMVn7UxVLBd+cmoSaqWcEzjuWoSmnY
         rF/BIAUAuNJ3QrAwVOt8q10up9RTVHbc38f1d0AnKoKr7ry0c4ymvsclp3vOHz6VD2OU
         KpNSmSmaUs/kIupG/AO+CHvGBtvDC/PlCGrKvoPsrzinEoH8Q7J3J6IsoZ6ayFOuSGC9
         NW2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6IBUCmIrofhg+K/SA4flUI5d3XejH0Spk4DKsFVxSPw=;
        b=TVPhkYEkIV+N1C8U1fM+x1whmRZDddaceqwQ94dIxeIDrZcV5KzGntyRMaN1FdOkSR
         c9yMm3GFmKZPqi2+svpfXkUv4x8bFOqcHNwP+nySGif8mMBA8mRMiddUxRYwK3AKLrr4
         ebGtUvxsqKxprThJoLdgLzXDbmx2t7abprQkq2ab7wEg3+dYeJ7+kXQdd9RKL8gekgiG
         w4z3hhcLLjCjxtZ7B6G+o/sg9sPkubKb/XNL9w+zdGkTy4w7migMW9fzk7hdFO7bsOL8
         gUpt0c7AMpBl1CgXcOA1s9ifZNbbHl1CeoZYq4bwTZsVSAoT6G+F+Gjf40i9AM1Sc9tp
         dqoA==
X-Gm-Message-State: ACrzQf3YUbaoYnSTw+mXmiduRXQ2+XfOdPTJ9n/F7zMSFnvV18fD2CLb
        XD6b+K1KoADfvrR40DuuAxQ=
X-Google-Smtp-Source: AMsMyM50al0KysAVRXBP4ptSimB025HjZuIg7Kz2zsndFUSymkPJCG9ppAl7osgN+EZaRwhKlIpOVQ==
X-Received: by 2002:a62:1482:0:b0:55f:eb9a:38b2 with SMTP id 124-20020a621482000000b0055feb9a38b2mr13353013pfu.29.1664856181971;
        Mon, 03 Oct 2022 21:03:01 -0700 (PDT)
Received: from debian.me (subs03-180-214-233-68.three.co.id. [180.214.233.68])
        by smtp.gmail.com with ESMTPSA id e5-20020a17090a804500b00205e1f77472sm7148380pjw.28.2022.10.03.21.02.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Oct 2022 21:03:00 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
        id 57042103CF8; Tue,  4 Oct 2022 11:02:56 +0700 (WIB)
Date:   Tue, 4 Oct 2022 11:02:55 +0700
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net
Subject: Re: [PATCH 5.15 00/83] 5.15.72-rc1 review
Message-ID: <Yzuwb/DKz64yvwAO@debian.me>
References: <20221003070721.971297651@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="braXFm0ONuiHxzmd"
Content-Disposition: inline
In-Reply-To: <20221003070721.971297651@linuxfoundation.org>
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--braXFm0ONuiHxzmd
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 03, 2022 at 09:10:25AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.72 release.
> There are 83 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully cross-compiled for arm64 (bcm2711_defconfig, GCC 10.2.0) and
powerpc (ps3_defconfig, GCC 12.1.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--braXFm0ONuiHxzmd
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCYzuwZwAKCRD2uYlJVVFO
o5qaAQDt+05sB2WzIlLxTSkUNI8tFTAdAy7N5vOzyJD7UjHhuwD/V2HuY7SA+IZj
SL4BLuXOd5Upb31kxym67LlA9kGbqA0=
=+lkQ
-----END PGP SIGNATURE-----

--braXFm0ONuiHxzmd--
