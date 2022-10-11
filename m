Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0B0E5FAECB
	for <lists+stable@lfdr.de>; Tue, 11 Oct 2022 10:58:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229557AbiJKI66 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Oct 2022 04:58:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbiJKI65 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Oct 2022 04:58:57 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DABF6D9DB;
        Tue, 11 Oct 2022 01:58:57 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id x6so12600009pll.11;
        Tue, 11 Oct 2022 01:58:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=OjYV+PrYo8LJJEiYwJWJq3mQSw4KgyJjKDtp0/rveP0=;
        b=COjZXJwfy9YvjSkuGjb7HfnBRgZXDUEn+Z8h9VC/15b/Pd7r/84NhzygnF9K1zAaKA
         9Mv3VZMlpDEfIG6nqqvUF6ugsKGVyP0+9aXrsDByCU3LyeaohKzFQRmyrwAsMuIg6N47
         /e9vcUhKf+h3RwtPf3KOzygCOurXmLQtYPY/a2Jp6tn7putul1rWe1p4Z+FJ247rMuVt
         t2sb8CYHj5XeFsBsSWL8qCj6JkSkaWkRXhCU8YN59yDRvjEuU/YF88mV4Hq3drQMZ24p
         52r1EtQ9nU8ykjGHsXUfMlT97Hii8eDYmLH+mVqWOpv+nKan3SaIE3RMKBnFw8QVK5KJ
         nyMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OjYV+PrYo8LJJEiYwJWJq3mQSw4KgyJjKDtp0/rveP0=;
        b=oo5nskpn6xHpM4lUxvECOFyL5eKriV2bCfSo0auKSuxgnJT4lgI/XOukD7nbqD+0xE
         wkIN4AvKGOI0qFvCjPFkvfAWHk5fMDdxEWmg+4IrJiswFizkkhcGQy6XyIhXF41Bw10x
         HKESOXffvUTVChOhwm8VpveQr52bWQp0BUpsFuLYX8pnXa7gSara2RlclhHmN9j4btUL
         +uGDKdnp8hBd1PcAxhLG1fq8h1R7KDDTOh5mClQLTg8hGtuWVZY8mzCnBNd5innC0KVz
         1H/PaalpT5DAWQYHR4ArkA9rhRwUECbs4q4zQN4WSqbN3e+GR5BAn/o37kf1T2Rc8ieG
         KL9Q==
X-Gm-Message-State: ACrzQf14riLRnnnPWLR0+I0ehuJj0K4cCFDrE4SsPc7KJ0cJ8ejVfSS/
        zD/JpZYrMK3vzeOQLGthbx8=
X-Google-Smtp-Source: AMsMyM5r/Nk7LLGoiDXUAakqD4KVRpe1Lw4UY9XDSlvogAssyviQn84p+X56kSrtvxclfQOflHiHbw==
X-Received: by 2002:a17:90b:3c84:b0:20b:8bc5:76c9 with SMTP id pv4-20020a17090b3c8400b0020b8bc576c9mr23453734pjb.171.1665478736617;
        Tue, 11 Oct 2022 01:58:56 -0700 (PDT)
Received: from debian.me (subs03-180-214-233-84.three.co.id. [180.214.233.84])
        by smtp.gmail.com with ESMTPSA id h16-20020aa79f50000000b005544229b992sm8385587pfr.22.2022.10.11.01.58.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Oct 2022 01:58:56 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
        id 9D9DB10381D; Tue, 11 Oct 2022 15:58:52 +0700 (WIB)
Date:   Tue, 11 Oct 2022 15:58:51 +0700
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net
Subject: Re: [PATCH 6.0 00/17] 6.0.1-rc1 review
Message-ID: <Y0UwSyHLoWZiXIpc@debian.me>
References: <20221010070330.159911806@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="eOkI0fukM6mb1Flo"
Content-Disposition: inline
In-Reply-To: <20221010070330.159911806@linuxfoundation.org>
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--eOkI0fukM6mb1Flo
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 10, 2022 at 09:04:23AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.0.1 release.
> There are 17 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully cross-compiled for arm64 (bcm2711_defconfig, GCC 10.2.0) and
powerpc (ps3_defconfig, GCC 12.1.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--eOkI0fukM6mb1Flo
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCY0UwQgAKCRD2uYlJVVFO
o8tXAQDsxJe5H07q8u+FaLLXi0bhjYRL5vVpgdpf/GyO/Y/IaAEApGL3byuf6pnD
UF2w8oOnXjZx4bE6dKDcp/RvU27C8As=
=+nKW
-----END PGP SIGNATURE-----

--eOkI0fukM6mb1Flo--
