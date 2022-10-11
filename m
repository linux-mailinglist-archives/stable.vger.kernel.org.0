Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F28E5FAB9B
	for <lists+stable@lfdr.de>; Tue, 11 Oct 2022 06:23:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229477AbiJKEXw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Oct 2022 00:23:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229490AbiJKEXv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Oct 2022 00:23:51 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D50C883234;
        Mon, 10 Oct 2022 21:23:50 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id c24so12135259plo.3;
        Mon, 10 Oct 2022 21:23:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=6Eyr8e/bNMyuqL3yqFtqkos4M3HzoUVoIvBsWgwqsAc=;
        b=YXgpgFUww7vIPWHeJH86CukufIg9n8YvneTe1X3Ge5HJaxpo4keCvFAlb+QO82gmA6
         mE1oXZqTIzNjXK9mpYmjoWMRtqqHnEz0PD2zT50M4q3Q95sY59B3VmY3Jp+n4f9JoDXH
         HT1QZOiZNXqNM68hVjX1bsStHrAGvkb2vrsHuOM4gs3jJ+oZ9i8NzyuhZnFac0ZiiN6b
         CE5g6bLSRbVotATSrmGKTSuHm5Y7bqnEDVSc0wmNWNTW0mDUs639SZtATAacyWdCtnxG
         EFa46C6wpXeAb3NIG08Rha0827y22SRwzbOegnEtNRLMlDc4qIeSEHOO+oBHNbVAdlPx
         kN9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6Eyr8e/bNMyuqL3yqFtqkos4M3HzoUVoIvBsWgwqsAc=;
        b=W0+YOEo7/rRo9w86w610V5xE0uWZVDEBTpqcKMoY8eLyDdSzTMwp+Q6i+x9URH5dyz
         sieg/kdyBjAxJaUAqdyim1wGHhhTPWUx5d3IcBfrj15E78sgjCJezrlVFu8AC1z+ztWU
         dCJggaL3E3GTQeYK4EDhC5eMLp4HCh1KWhky2bsmTUcwr3vCKSkqpBhcKJWZwogADx3a
         c+RjMpU1itMBUX3/zhA0pGms8mae1ud/b6Nb4aErW/phfexxIezt2wugQySdrJbYLw7R
         9rl6DOsFybzuzVxBo1vnW7w/mjVH2jzPBYLgLHswqRNvWaEKpCE5ci5pyi81W2rNouXY
         ENzA==
X-Gm-Message-State: ACrzQf3PpitzWBgvvTa2HGF3ydVwFv4K4cZEsEuoGYBB1xfSJa+n9b6I
        0Nur6ugwE73DSnMW/opHBiA=
X-Google-Smtp-Source: AMsMyM5BwKTQ86DAJajJhFVB4ry+GjmWdGEUx832Opx9iANGN1zvht/raQOSv1Rvv/kjxQanYMzqIw==
X-Received: by 2002:a17:902:7c8c:b0:17f:7565:4a2d with SMTP id y12-20020a1709027c8c00b0017f75654a2dmr22830636pll.65.1665462230114;
        Mon, 10 Oct 2022 21:23:50 -0700 (PDT)
Received: from debian.me (subs03-180-214-233-65.three.co.id. [180.214.233.65])
        by smtp.gmail.com with ESMTPSA id h3-20020a170902f7c300b0017691eb7e17sm7444027plw.239.2022.10.10.21.23.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Oct 2022 21:23:49 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
        id 876F41039C3; Tue, 11 Oct 2022 11:23:45 +0700 (WIB)
Date:   Tue, 11 Oct 2022 11:23:45 +0700
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net
Subject: Re: [PATCH 5.15 00/37] 5.15.73-rc1 review
Message-ID: <Y0Tv0S3zfZlEtii2@debian.me>
References: <20221010070331.211113813@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="C+/FlmvC08YWdift"
Content-Disposition: inline
In-Reply-To: <20221010070331.211113813@linuxfoundation.org>
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--C+/FlmvC08YWdift
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 10, 2022 at 09:05:19AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.73 release.
> There are 37 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully cross-compiled for arm64 (bcm2711_defconfig, GCC 10.2.0) and
powerpc (ps3_defconfig, GCC 12.1.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--C+/FlmvC08YWdift
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCY0TvygAKCRD2uYlJVVFO
owyOAQCakgrPYkzs6vatPpW3s6nvPuKiWhhePgOhHayr1YnDFgD/eqFllqCzt6Nh
gUn2MSGT48x5lr09q8J+dAu64TWccwM=
=dAvE
-----END PGP SIGNATURE-----

--C+/FlmvC08YWdift--
