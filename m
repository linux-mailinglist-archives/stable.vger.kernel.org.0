Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3170764AE22
	for <lists+stable@lfdr.de>; Tue, 13 Dec 2022 04:20:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233820AbiLMDUw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Dec 2022 22:20:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbiLMDUv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Dec 2022 22:20:51 -0500
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A1201B9D2;
        Mon, 12 Dec 2022 19:20:51 -0800 (PST)
Received: by mail-pf1-x42e.google.com with SMTP id 130so1299199pfu.8;
        Mon, 12 Dec 2022 19:20:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=MKJurbxyohFsssUhoc+Q8kL3WN/Z5/vkHCwhZ/5bbzU=;
        b=Dc7PjCZfYeOabX3l0PiGWRItYbl1HI2ws6OBXdFdwSHtTLK1W4g8Mu9dSnmbT3QRjt
         H+tALhrD14MxgJfnocZLmi3mlDLSZpFwqXjSS+k0wlwF+hEPpjUPsSuWGy11k834ae+W
         vPlKndhUAKq00TqVIzrrYzHr4HV1/qIEOOOMKLE/tsR0CHfl37sfBdo6EKd7zct2fKEU
         TRFnFF7liKOGNPdEGc+Tc336YvKk8IZOCt7l8gyIo/rQatXBZ+YC8H5IvkQUxY322YQd
         CH/BqkFrfz5WHjUh/p4UyBjzgGVTqliJ6bNE7gt28d/2HiSSgcMzzB1yYteLvXdWQiAD
         uMDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MKJurbxyohFsssUhoc+Q8kL3WN/Z5/vkHCwhZ/5bbzU=;
        b=CEmXh84Rm2Kxvn+7blsk+1wKXXu6wFwxHQMxAkNJ1nDkZLQnTnWtBktbbzV1T5Io+m
         87+WscZA8ObttIN5X3KBk2fm6SgHZgiAw8qu8CAyDfJ/zfHQxvQbuRcq2ui3bn36XYCx
         XHZzbAX3xfd7Hkkwb//7N9rf/ylutfJLgIuaFL1L2Q7vyqel9UTrALi4rJCEAo52E7Pb
         4AkffQaX2syinR28rKz0IFIwi97QvjbYNbTgWkNCKk2E3Q4+Z07HeLkUSDvUxIUD7R7n
         qZ3pmDjw0RUB6MnlbHf2xp8yIPsFHL/C1KlTvLpHTycp2WbXqSu6Fg6bJutvrUoPex7r
         lCYA==
X-Gm-Message-State: ANoB5plQ1p028k7TWvkHslxjUV9ptOmKYdnwj4gJBvUyQswov7cNrJRT
        +xnHGZ0ypYuMn/unp67ba1A=
X-Google-Smtp-Source: AA0mqf4eAtkxGK4giED+IubXv3phvplhizX/bcyYERqDdNP95dh5cqiE1juG+PvoNCabPwElyjzpSw==
X-Received: by 2002:aa7:8589:0:b0:56d:74bf:3265 with SMTP id w9-20020aa78589000000b0056d74bf3265mr16220608pfn.19.1670901650568;
        Mon, 12 Dec 2022 19:20:50 -0800 (PST)
Received: from debian.me (subs03-180-214-233-6.three.co.id. [180.214.233.6])
        by smtp.gmail.com with ESMTPSA id 69-20020a621548000000b005741cb643bdsm6460662pfv.215.2022.12.12.19.20.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Dec 2022 19:20:49 -0800 (PST)
Received: by debian.me (Postfix, from userid 1000)
        id 4172A103A81; Tue, 13 Dec 2022 10:20:47 +0700 (WIB)
Date:   Tue, 13 Dec 2022 10:20:47 +0700
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.0 000/157] 6.0.13-rc1 review
Message-ID: <Y5fvjw1lO/8y6SII@debian.me>
References: <20221212130934.337225088@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="cIS6zQjnKhbOgl8k"
Content-Disposition: inline
In-Reply-To: <20221212130934.337225088@linuxfoundation.org>
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--cIS6zQjnKhbOgl8k
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 12, 2022 at 02:15:48PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.0.13 release.
> There are 157 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully cross-compiled for arm64 (bcm2711_defconfig, GCC 10.2.0) and
powerpc (ps3_defconfig, GCC 12.2.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--cIS6zQjnKhbOgl8k
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCY5fvjgAKCRD2uYlJVVFO
o3TeAP998nNaf5M9PsuGbu3+SqZ5Eeo/rWvlICb0fMj87o2qdgEAvPtdNOHcNsdf
NaT2RlmgPBQR9921z75N3WfZA+Hzrgw=
=kP/L
-----END PGP SIGNATURE-----

--cIS6zQjnKhbOgl8k--
