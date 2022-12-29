Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DB53658930
	for <lists+stable@lfdr.de>; Thu, 29 Dec 2022 04:42:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230254AbiL2DmK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 22:42:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230078AbiL2DmJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 22:42:09 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 416A713D10;
        Wed, 28 Dec 2022 19:42:07 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id v13-20020a17090a6b0d00b00219c3be9830so17796971pjj.4;
        Wed, 28 Dec 2022 19:42:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Dc0DuU1O9eY3YHChsMW27jwVrWlDkDg7wgtC9pCKkng=;
        b=CTW90m8ookmgVbN8JMlAeqhaXEU435OhE/1KEl/BoV4uGNO5P8bjeviexwlm5cVk/X
         OsW9kElZhbSXAvb8vyOJerVRWDXC89AYna8oigszgeyPVJxLS9PXoa6FXqz0MtbAFi6f
         c8FpQlNfCIgMz+Lr/8XOUwyWlEjvzr51j2WVeL1MXNkAk15bRUT5J3c3xW4AwKExYAbm
         ls+LsMHF4J50qm1w0QXJ4qIJg7OJoMj0m6yrekLLrMGnmdRLKpOlp6Xw5gjgA7cLZB/6
         /9WJM980pPoChLsbZj4tCte5jsGEug4hwG+d/2Gqg1GynSCktPO6ubAnmFtrQUFJQz+k
         XyTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Dc0DuU1O9eY3YHChsMW27jwVrWlDkDg7wgtC9pCKkng=;
        b=eaormJpM2Q7e6Di9W6dgVpDe2YH8AdsrvrmOiNTXpw2o49iQiFJffrpTAeIOX70e3/
         4rwxW73nLO+odLkBL+kmobHKKxxgS/Iab1JRHWkIEGG4eduIENPd+osHbvhPEj/XHCts
         2ALOyNsgXkBLs9pw09T4yPxOWBrmFiHYsgiFr1A7C9L+xH7Jhn9BoscAxvRKJjaaDWzP
         1sy/ynRvpR3NVKVvk8eNgUTpx1NoGkE4FX2rj0I0690VRDeTOsau+JiFVqvruoSuE7ph
         xRWePbMxV0VPi0Ar0RVFwh6eLaUNDbORCm5HuW6Mnz9QPJzzrlZ9pkwh7aWz0oTcDFGf
         g4ZA==
X-Gm-Message-State: AFqh2koVO/Xv1J7SB4UMAwv5GTbuT1fM9rRvoiFuyk5qdxMZ56jusHua
        jy7+1lc/Fmbo26aC8ajslYc=
X-Google-Smtp-Source: AMrXdXtiyWJ5Cr7Un3Vovkoxmt4cIPtCGX4RjLXIDFR46yC2jvX6/fFlcEK66r4aCOkui+YEQisq/Q==
X-Received: by 2002:a05:6a20:7b28:b0:ac:184:d297 with SMTP id s40-20020a056a207b2800b000ac0184d297mr29035719pzh.38.1672285326711;
        Wed, 28 Dec 2022 19:42:06 -0800 (PST)
Received: from debian.me (subs02-180-214-232-94.three.co.id. [180.214.232.94])
        by smtp.gmail.com with ESMTPSA id a11-20020a63e40b000000b00478ca052819sm10074960pgi.47.2022.12.28.19.42.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Dec 2022 19:42:06 -0800 (PST)
Received: by debian.me (Postfix, from userid 1000)
        id 61442103AA8; Thu, 29 Dec 2022 10:42:02 +0700 (WIB)
Date:   Thu, 29 Dec 2022 10:42:01 +0700
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.15 000/731] 5.15.86-rc1 review
Message-ID: <Y60MiWGDnPIH8Xrf@debian.me>
References: <20221228144256.536395940@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="3ddO/rcqvwCyeG/o"
Content-Disposition: inline
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--3ddO/rcqvwCyeG/o
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 28, 2022 at 03:31:47PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.86 release.
> There are 731 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully cross-compiled for arm64 (bcm2711_defconfig, GCC 10.2.0) and
powerpc (ps3_defconfig, GCC 12.2.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--3ddO/rcqvwCyeG/o
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEARYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCY60MgQAKCRD2uYlJVVFO
o2vHAQCIFNWPgIZdRpUl9FNBuKw24/tlOtehnd/RDdmGNs6COgEA/DHKoy2Wd5oI
hn+mogOECjYoSBQcTBZhfMIhMYRU2wM=
=scV8
-----END PGP SIGNATURE-----

--3ddO/rcqvwCyeG/o--
