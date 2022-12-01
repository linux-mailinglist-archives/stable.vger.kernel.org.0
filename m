Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4E9563EA97
	for <lists+stable@lfdr.de>; Thu,  1 Dec 2022 08:56:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229694AbiLAH4X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Dec 2022 02:56:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229626AbiLAH4X (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Dec 2022 02:56:23 -0500
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 531C951316;
        Wed, 30 Nov 2022 23:56:22 -0800 (PST)
Received: by mail-pg1-x535.google.com with SMTP id h33so972290pgm.9;
        Wed, 30 Nov 2022 23:56:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=D2ttyoUGNfYuPD9Y7UeScn0v9Wc1/HDJhF/MHUfkAG0=;
        b=Ajc6HGtyTqDfuTDVMzx4DgN3XK3JkJs/Aj8GtOofFdlaEo4L48G4Mr9JYX5uOsYtm+
         UHRb7VpXyUCff6SCwyvDAFgaUjRFA2681d/D0SSjKco+fSCOy/Ux9LJrQ7KOg1+1O0Q8
         NgyQlFztC2qnkYpiZta7sJvHzVHBcjMsJ2LqBbhn8sB+cJ2mCbYrk3gA8Qau50KO8pDJ
         S0MzOpuToyNY5GG6de6zvk5YRWvXWEXCsFOAuZwU81t+NYOX7no21a3qirG4rSTfCBxC
         to+um08f7b61lDBtLiVlfX1cixRZsx33AtfY7X6Q7IRE9Vs0bbplxlIzxZrTY+ugAQBL
         9x0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=D2ttyoUGNfYuPD9Y7UeScn0v9Wc1/HDJhF/MHUfkAG0=;
        b=YHNK3b4KbXB+rHSz42IFPcODvk2HLgj9gK2zwIRLmh4oqXtMP45R1axsjbwEBz0JXu
         gxuI0jPZuHSLTyT4EcW9WMd3krZY2xfe9eKPiF8MT8fg0jCgg5iZzL4Il2uSgebkCJtp
         scRpsvGsfQ9EXnqeN8umcMuLQx0HrfELk8HSWnzfsIHlVxiM5aZnE/T1MKq0Nd62SbNQ
         nE4rgfnW6goQb5TkdhuUuNAEM6ne07GPN3WwCXUfis0s5+/VD42N3Ymg9+nMiozNiyiI
         p63pMdlkA5yunrAi4q55uoG/EZuG+dslST1wOKggHYXwJgs1Y1gN6IJDf5ebO1WU0Tbh
         rGAw==
X-Gm-Message-State: ANoB5pkWkKjmPUbwIf9V5E8tiRL+ZgsdBQd1Shl/u4Mm+puvvJ/OeX9/
        Svo9DvvONhCakq5xjKgnwRg=
X-Google-Smtp-Source: AA0mqf4u+VjSI2oWSNzFgED+MHjqCKfP6Wh+vZdqlGgGKkIZUr1zDY4jPr3O3ow0kaxJR/0q7vWU0g==
X-Received: by 2002:aa7:8b56:0:b0:56c:6f8:fe14 with SMTP id i22-20020aa78b56000000b0056c06f8fe14mr67076789pfd.75.1669881381873;
        Wed, 30 Nov 2022 23:56:21 -0800 (PST)
Received: from debian.me (subs03-180-214-233-74.three.co.id. [180.214.233.74])
        by smtp.gmail.com with ESMTPSA id e2-20020a170902d38200b00189502c8c8bsm2864308pld.87.2022.11.30.23.56.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Nov 2022 23:56:21 -0800 (PST)
Received: by debian.me (Postfix, from userid 1000)
        id A4A361042B7; Thu,  1 Dec 2022 14:56:17 +0700 (WIB)
Date:   Thu, 1 Dec 2022 14:56:17 +0700
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.15 000/206] 5.15.81-rc1 review
Message-ID: <Y4heIdzK0Dn32Lm/@debian.me>
References: <20221130180532.974348590@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="kd6H+Tg8rY65JvnO"
Content-Disposition: inline
In-Reply-To: <20221130180532.974348590@linuxfoundation.org>
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--kd6H+Tg8rY65JvnO
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 30, 2022 at 07:20:52PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.81 release.
> There are 206 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully cross-compiled for arm64 (bcm2711_defconfig, GCC 10.2.0) and
powerpc (ps3_defconfig, GCC 12.2.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--kd6H+Tg8rY65JvnO
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCY4heGgAKCRD2uYlJVVFO
o/EKAP90UD5u+Uj/lKRg0v0CbdeQsl+JeEhZaOXRz1XeNj9yhwEAvz3v75uLMYAg
G8zJiA0QaV4K1RnZcVIVsJkEs+z6hwY=
=k/I7
-----END PGP SIGNATURE-----

--kd6H+Tg8rY65JvnO--
