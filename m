Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F06706E88E4
	for <lists+stable@lfdr.de>; Thu, 20 Apr 2023 05:52:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230081AbjDTDwL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Apr 2023 23:52:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229520AbjDTDwK (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Apr 2023 23:52:10 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E121110F;
        Wed, 19 Apr 2023 20:52:07 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id d2e1a72fcca58-63b5c48ea09so537700b3a.1;
        Wed, 19 Apr 2023 20:52:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681962727; x=1684554727;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=w1FVwpm//7EWGjghRNYvD8w7GqajWducsGw/6kvzTVA=;
        b=BzQ1UtsxhBck6ucDpFGCJgIgDed9yrUMGTI9yMsZiIKN7Vy22W/aKPhYjdhXuYs9ZV
         ERDP3B8Spk55sx6apOu3z9zfoFeEoSxZ/K87wGy7amdIRGQy9UMt3gYo6ugOVc7PR87n
         HZx8QSTKCO5phk/nTCvf5ICcffV8es5BhHMA/Ay4Pz5d/ME4LI+CMTdjPPXmNLVmczwl
         rvAobjeoZOXlZKy10tWcXG9XmEdoO6ClEA6o1JWnoVJB8SIU/NGOwydiymVMfrA/3xCb
         9aM1WHabVGQ2Vm7HNbDRSE/Jya7zvJfydwg0865KjrIMIyKP5L/TR/K1kwd7K+tszXvz
         woIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681962727; x=1684554727;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=w1FVwpm//7EWGjghRNYvD8w7GqajWducsGw/6kvzTVA=;
        b=G6r+FlidmvH9W9kupnV7Ih3e2YvCM8PeVOf9azEDHlPMSHM2Ld9RPQQKW5dbPGQsjl
         TsqyAcZbWl2jqc0hW4hOqDEh6Eapqk8hnw6ByH631XlWDrPa2rvmbtqIIeOlEJjeIck+
         r9DlWl6kNPHo7J6f4EvUYYcXgm2M2FJOdRQJpn0zoQ6q45v1XoIwpfSGXjxv+6Jamjcq
         t9/v41qLRwOH4Aon+4MRlgmm7ZTly5ESsZvaquXHhwNSYuSmWvgPT0XttRl/ZfVzaUHt
         Ir4ZEwDJQOJzqy39LurdH1M+8U9zQV23wnGtC5/L5PTFhLrIcKJeWvJTXKysCd9Dukgk
         NgUg==
X-Gm-Message-State: AAQBX9eycItMJd7aiP/sBWKyDNR4IJHuJwND+jV/4cT85F2L8GwIpSox
        WxsRHyxjLakj7mqJgFeOC2o=
X-Google-Smtp-Source: AKy350ZSZhLNPS4nORKG8s7eLG/Lj92AeETj3ZRbNRnBnge97bQWaxx+5yNBqgizAaNq9zC2vlzJ2w==
X-Received: by 2002:a05:6a00:1356:b0:63b:594f:bd1b with SMTP id k22-20020a056a00135600b0063b594fbd1bmr7594108pfu.3.1681962727289;
        Wed, 19 Apr 2023 20:52:07 -0700 (PDT)
Received: from debian.me (subs03-180-214-233-6.three.co.id. [180.214.233.6])
        by smtp.gmail.com with ESMTPSA id x35-20020a056a0018a300b0063b6cccd5dfsm136556pfh.195.2023.04.19.20.52.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Apr 2023 20:52:06 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
        id 6905C106852; Thu, 20 Apr 2023 10:52:03 +0700 (WIB)
Date:   Thu, 20 Apr 2023 10:52:02 +0700
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.2 000/135] 6.2.12-rc3 review
Message-ID: <ZEC24ukqNNbLaywF@debian.me>
References: <20230419132054.228391649@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="wwtHWNsJSpGMTGlt"
Content-Disposition: inline
In-Reply-To: <20230419132054.228391649@linuxfoundation.org>
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--wwtHWNsJSpGMTGlt
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 19, 2023 at 03:22:02PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.2.12 release.
> There are 135 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Successfully cross-compiled for arm64 (bcm2711_defconfig, GCC 10.2.0) and
powerpc (ps3_defconfig, GCC 12.2.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--wwtHWNsJSpGMTGlt
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZEC23QAKCRD2uYlJVVFO
o7FNAPsFeZ9Tzof2z+T5F2RsXY77z631QwX1ummWyk4TIGqutwD8DmzwgJHqST1I
MKKVpx1LRKdaDp5bi3nZrfn8YdVdFQo=
=l0Q5
-----END PGP SIGNATURE-----

--wwtHWNsJSpGMTGlt--
