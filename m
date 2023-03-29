Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D61A6CD10F
	for <lists+stable@lfdr.de>; Wed, 29 Mar 2023 06:11:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229510AbjC2ELw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Mar 2023 00:11:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbjC2ELv (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 Mar 2023 00:11:51 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B07FC4;
        Tue, 28 Mar 2023 21:11:50 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id f22so9615923plr.0;
        Tue, 28 Mar 2023 21:11:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680063109;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=L7ZNbdRmLBVQTUyoFW+BtEddrBJyh3gW/MajDq9ikHM=;
        b=qQlxkV3hMPXscS6z7rJW7Pm0dZHaGpjozG5zVgPQ6OXYjeJ1fVgQiXQGz10BflIwmN
         Gf3X/Qe6MOftjTMZZBj4ybDisdtVRHOV9o9yi1D1mD9ff/ihNPxfNUKD/AOVrjX4akjp
         QtfS+Ud6cbB8HVmS66esPN6sCzuy3wik46GeI8gzKsdTCjwt7lF21zyOcIxl7uZsraHa
         Go2CXa8+ij7GMi427EI45eZiQRgvVDNMqfhOGirGEIHCP/p9yJ3oMsTwI4uq+oVYvPmy
         vu0Aj9w589xovesMwShrpUAa84IebDk8kR7yxlMsDw/3HQKggEoXDjGPKLBYKOLbvY7l
         K5mA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680063109;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=L7ZNbdRmLBVQTUyoFW+BtEddrBJyh3gW/MajDq9ikHM=;
        b=2y6VGy8PXiyE0+fED/DfIK1RaZhKYIMOewxbynHjJ1kiJ7W0eydt8irSBVyij8+xRK
         kRozbCWsIJxEIgY5rR/E/B5yc8dlbnYYBjiF+ccROYn7LOObr5K46NB+TYQfza9hdPlC
         YuqXKIqaBZjl6wBqVqKJwdISmm8WQope/4ztX/h7vxPa0toJfuKK3Rn68bPrH3oUqL2j
         ncTdSSLuT+8aKZEYs/YVBxzwyML3jjYBHSNHZFFUXZ91Zw+61cj8YnFQX5VatiM0/ykf
         1xABKoZEiCp+8cqkA2cNJ14Y13VJn1ZPA3zIhEGjZ4PE5Cx9dxMvXhQitqvLC9QGHCo1
         N9eA==
X-Gm-Message-State: AO0yUKUn84Qe1kM84+paUHYiqBWuNiE9YZKMgeJoI+cSka6ByDzeSrN+
        IDEWcnZS9zOpKrnSH+C+qpQ=
X-Google-Smtp-Source: AK7set9k90dFBO7hBEhIQiDpNaTi3InRtsFJDliavAy940FUyFVjqPo/TNO1TYOrg46Cnk75+A/tKQ==
X-Received: by 2002:a05:6a20:c10f:b0:d9:84d2:7a9f with SMTP id bh15-20020a056a20c10f00b000d984d27a9fmr16315514pzb.24.1680063109559;
        Tue, 28 Mar 2023 21:11:49 -0700 (PDT)
Received: from debian.me (subs02-180-214-232-7.three.co.id. [180.214.232.7])
        by smtp.gmail.com with ESMTPSA id i22-20020aa78b56000000b005aa60d8545esm21830967pfd.61.2023.03.28.21.11.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Mar 2023 21:11:49 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
        id A376A1066F7; Wed, 29 Mar 2023 11:11:45 +0700 (WIB)
Date:   Wed, 29 Mar 2023 11:11:45 +0700
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.2 000/240] 6.2.9-rc1 review
Message-ID: <ZCO6gRM7ozbbXwua@debian.me>
References: <20230328142619.643313678@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="+g+mtS8KVUMZPKw0"
Content-Disposition: inline
In-Reply-To: <20230328142619.643313678@linuxfoundation.org>
X-Spam-Status: No, score=1.3 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--+g+mtS8KVUMZPKw0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 28, 2023 at 04:39:23PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.2.9 release.
> There are 240 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully cross-compiled for arm64 (bcm2711_defconfig, GCC 10.2.0) and
powerpc (ps3_defconfig, GCC 12.2.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--+g+mtS8KVUMZPKw0
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZCO6gQAKCRD2uYlJVVFO
o5HoAP9FWcqsjccJRMe659wLDmyDQH9bTYwZGRV5k1DHgtG/gwD+OLt2wWXOH329
5wYVCQNC5ky9zqG7xsBu/4C2DVnWqAo=
=5Xix
-----END PGP SIGNATURE-----

--+g+mtS8KVUMZPKw0--
