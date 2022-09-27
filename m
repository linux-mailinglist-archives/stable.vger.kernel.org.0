Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 317385EB91C
	for <lists+stable@lfdr.de>; Tue, 27 Sep 2022 06:05:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229738AbiI0EFd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Sep 2022 00:05:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229552AbiI0EFb (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Sep 2022 00:05:31 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69B3C27B04;
        Mon, 26 Sep 2022 21:05:29 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id x1so8007765plv.5;
        Mon, 26 Sep 2022 21:05:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=XA/GJ6scUaTXK4vGu3fQyPrcwKP4tYCrNALjjLknjGc=;
        b=OqnXRcwGDcLqY+ni36czrlZlUiaEGliwHq/qtIAW+6D3Ewpx0n8uFdWm/zLYYrwwlx
         FTENLgQdC3eXYuLm7jf/sfHPndmiHixtCzg/w4AAP4nntA4luyHz+G0KBb4zyEh08O/h
         3XZYBG5fXpXmp9XQTmskiC3UxJD0WJzQ3mgraMPPdwLhw9Hi6tg3zPrs2+w1kfnlIHKh
         JUm11u9ZjdqrldGYOr1ffzyba6+ltkoLbcS1S6jYrYIBcz4GmgoAAFn9IDpqZXLXK0/Z
         mMVFLX+v135xKNUPX6uPtS/yzMUdqtP24q8VTrQSvzBy0P8Q4iRs0GUAGrqyckL3vUnG
         V48g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=XA/GJ6scUaTXK4vGu3fQyPrcwKP4tYCrNALjjLknjGc=;
        b=cPU0ziskww9oD7JUjqCkf58joX8GghD5t8FxyKIIYzLNE2FtYEXkJ3l5zIewI3YPXP
         pHvnvfoPYICeXn8/rZr0UISsgZ1/OdxNZ/1FHrGMA2xNvRB8at0w1drbruufeSbq9ykP
         dlE/5yxOcIDDFenJhhVEgtxgSFeHgscTDYsaTpMnnYnGIdyyTTrHhNTA6GxfjGYf8PmD
         T78zVVYITzQFCFgIsp+JaGwg2/NQDFeULOPe9H6iUNEcez9czd0p9CDHviyvUao7Qz0f
         2IzBFWGPjJkD9mRRN6m6aQE45IlxknvqpMy5K2mwyI/TgVK1/gaRs4eqoRrWLl8br4rT
         HhGA==
X-Gm-Message-State: ACrzQf2nCJjjdR23u7dzq/p/eA6Jw/WVQbnZp+ApaCNMPivS6qQvt44O
        B3y7KHj3HJwyj4YQrBugRPQ=
X-Google-Smtp-Source: AMsMyM5aYZMgaYDI1Zp2IrUE1tts8Scl8A1/m45eAoCU4qUJjntsrGpskYsEAg+BuqF9BgA02NCdQg==
X-Received: by 2002:a17:90b:2242:b0:200:1c81:c108 with SMTP id hk2-20020a17090b224200b002001c81c108mr2241164pjb.89.1664251528903;
        Mon, 26 Sep 2022 21:05:28 -0700 (PDT)
Received: from debian.me (subs09a-223-255-225-74.three.co.id. [223.255.225.74])
        by smtp.gmail.com with ESMTPSA id e4-20020aa79804000000b0053e6eae9668sm370388pfl.2.2022.09.26.21.05.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Sep 2022 21:05:28 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
        id 27FDF1037F7; Tue, 27 Sep 2022 11:05:24 +0700 (WIB)
Date:   Tue, 27 Sep 2022 11:05:23 +0700
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.15 000/143] 5.15.71-rc2 review
Message-ID: <YzJ2g0EoR4S8FjEs@debian.me>
References: <20220926163551.791017156@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="PWHdWmvR7VHz54AW"
Content-Disposition: inline
In-Reply-To: <20220926163551.791017156@linuxfoundation.org>
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--PWHdWmvR7VHz54AW
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 26, 2022 at 06:37:05PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.71 release.
> There are 143 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully cross-compiled for arm64 (bcm2711_defconfig, GCC 10.2.0) and
powerpc (ps3_defconfig, GCC 12.1.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--PWHdWmvR7VHz54AW
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCYzJ2fgAKCRD2uYlJVVFO
o2IRAQCBbmT4zfk0YtX3YHkSQBCFDrHPA9b961vKrOFe+G+eowD8CeHb7b+ALtM/
QyudFnVbWLPcn3juWlSZMcx1bK3cQAE=
=9tCO
-----END PGP SIGNATURE-----

--PWHdWmvR7VHz54AW--
