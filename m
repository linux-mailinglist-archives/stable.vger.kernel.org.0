Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9038460C7BE
	for <lists+stable@lfdr.de>; Tue, 25 Oct 2022 11:16:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231356AbiJYJQu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Oct 2022 05:16:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231341AbiJYJQK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Oct 2022 05:16:10 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E4B417FD75;
        Tue, 25 Oct 2022 02:08:52 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id c24so10631401pls.9;
        Tue, 25 Oct 2022 02:08:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=b2vjxvwiD/Iws++QDV805IwGePJN8KQS4m3b8uVw7rM=;
        b=Z/WKk4KCX2xaPsiobUot08DIBwA++fxiD6Yue+7+oKy2Q3W7mV5cfch0V+3tfUb8nt
         D5WtXZ2FlizSqUCmWbyqJLzavcYoLFiIvWVX8XWqtebgSeWx2ZFgeDCxY+LXZh//P7zN
         hiCzEoorBp9ExTh4pBTgvqbjVKyH5ctt5iSrYY7jXWF0lhYILv/z6MXuAIpxj2pMofgS
         bE0XAoytsNzBh98AawBhF+8ss1RezHH+BO8UosDtSHyeUTroTK5QBXObwfgQfPpAc65l
         3makTgGVpSkKcUZenvye6hC374MtR8TwCsFw+NbuUx9m+kA0ZtMUUDmnbPL88TQQb2hj
         Cjlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=b2vjxvwiD/Iws++QDV805IwGePJN8KQS4m3b8uVw7rM=;
        b=uEDNpG1XAhUvCPBZucmWHZ1O0wH/rPwqSkMTKlOHH/tpvzJOfTRC0Ph3iV4QXAIbds
         dZmdV89FKNY4nGGCau1seXeZBC12weMtRVh3+nJOuYgCb2SLp5g3TANwkSFyhVodxwTP
         n6cmRIT6ouKl9HU6T00GgRT+9J147czjY3pLT3R+hHIQF3/Zf855PMDmIUuHudAd3mq4
         zSSSZyGoCFUVwETS7Ec3Du7h02DEMEqAJwS2rQcWFO7Lm8/DpGUGK7SMevDrmWZ7oat1
         ozbcthE1F9hCWj31kjJDhvFQg+w4CJ+j9swXGSjun/9wU9K04BeY/gSY84MKr6kuUYC2
         9azw==
X-Gm-Message-State: ACrzQf1lbxCFOajf3SffSd1Xw1M4UpJWmNWdNxEKT9uYHVrgMsaeJGl4
        rijjjq2TtNAeRopVEpAtG4c=
X-Google-Smtp-Source: AMsMyM5HzOecSmrHiTg46ivvnSOp/uz0h7kap3HRhFiUd9cB2zjtlf7/wtBz653JeCrloo+vWoscVw==
X-Received: by 2002:a17:90a:e606:b0:212:f100:22e3 with SMTP id j6-20020a17090ae60600b00212f10022e3mr16182760pjy.83.1666688931961;
        Tue, 25 Oct 2022 02:08:51 -0700 (PDT)
Received: from debian.me (subs32-116-206-28-58.three.co.id. [116.206.28.58])
        by smtp.gmail.com with ESMTPSA id r10-20020a170902be0a00b00178b6ccc8a0sm880844pls.51.2022.10.25.02.08.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Oct 2022 02:08:51 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
        id 71EAA10402C; Tue, 25 Oct 2022 16:08:46 +0700 (WIB)
Date:   Tue, 25 Oct 2022 16:08:46 +0700
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net
Subject: Re: [PATCH 6.0 00/20] 6.0.4-rc1 review
Message-ID: <Y1ennr3YiO5UuHH9@debian.me>
References: <20221024112934.415391158@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="BJ+W+aGm3rvj59Xp"
Content-Disposition: inline
In-Reply-To: <20221024112934.415391158@linuxfoundation.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--BJ+W+aGm3rvj59Xp
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 24, 2022 at 01:31:02PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.0.4 release.
> There are 20 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully cross-compiled for arm64 (bcm2711_defconfig, GCC 10.2.0) and
powerpc (ps3_defconfig, GCC 12.1.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--BJ+W+aGm3rvj59Xp
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCY1enlgAKCRD2uYlJVVFO
o8HcAQDiUfsJ/H8PP62FdzVDvjSPUf2Y2xTgOTLG+Fh4M3nb3gD/c5NKffGP4iu0
Nl6MDm6tg7ChnIN6gNhG1qxTuXsG9AI=
=z4fO
-----END PGP SIGNATURE-----

--BJ+W+aGm3rvj59Xp--
