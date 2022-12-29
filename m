Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 887C8658CCE
	for <lists+stable@lfdr.de>; Thu, 29 Dec 2022 13:47:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233320AbiL2Mqb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Dec 2022 07:46:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233360AbiL2MqV (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Dec 2022 07:46:21 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F01810D4;
        Thu, 29 Dec 2022 04:46:21 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id j8-20020a17090a3e0800b00225fdd5007fso9224601pjc.2;
        Thu, 29 Dec 2022 04:46:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=4+mEh9KjQ/GdcuKLXp+v2G022zDuswizkrwudMFHtK0=;
        b=pomTjC0YvfLxexijq5CJwg2QSh9tfGBfybUi1RCNvc0mrOuYI2ND1w+/6sPOSrlUuq
         eeCwP2Sn2X4yC/TxfJaxcSyoMyM9UQETKdQJEdVec8hpcabdngFKae2oESGdNNOgI5as
         loE8TI2F9IVCLo9NFohOCz1bQGEujBofVZBAC8J5CunzmBA1sOyOJ13V365HDnqFXPWu
         sEqB2gDuWOseVgmImjgCvjvBLFY8kv1XindD8VG15hKbd6stGrEHdEQvqqksiz6YQAL5
         c6SZlO7Ini2L0b1le9sXOFmdWyft0GIqEjKXjY3j0pvZnzydaHpI9rWn5y06e6ZL/C5i
         33LA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4+mEh9KjQ/GdcuKLXp+v2G022zDuswizkrwudMFHtK0=;
        b=D+XBF7jAvSSuDKu0+ZPMhD+W9gzMxod/r+/1tuptlRs7YthtKw7u2fQyuN4HKjO9P4
         LCVphkopg0B0mLN7BLZayXETcBqjwM/aKUGHD9r/aNN07VVw2iOKe/Odx1two7qebFxO
         x6GzOumcO6rQtDrWbFYSbXpUl/yV/ZfBoqja9wCHumHXfUwOT+qbdsgePTCApu6M3swc
         ONHY1kmh40KrV2mtQkgTWtl5OnFsQgiLQVi0PJxysLyuuWUz0RvA/pGhIg1Z2gVGDgJh
         r++u2shL/lTNZ6WQrQU1RusNNrZaPAjKOc1RTQmOkgxx6XOxdbQGphGsRju2mjlaPQhM
         Ryyw==
X-Gm-Message-State: AFqh2kpBLc1KTdowSofxyz/1Bfi22c/G0m6Grr6AV2TXLSR4385aS2ZW
        setTOjd3mrcRUtn6+xEzBUA=
X-Google-Smtp-Source: AMrXdXv888hB/bsG4VHkbFoEIBWCykz1M6bY3r9edWdOcbuAyoKm0Z0IseJepcdSb/FgznOQrVFqiA==
X-Received: by 2002:a17:903:40cd:b0:180:f32c:7501 with SMTP id t13-20020a17090340cd00b00180f32c7501mr33157024pld.0.1672317980849;
        Thu, 29 Dec 2022 04:46:20 -0800 (PST)
Received: from debian.me (subs28-116-206-12-43.three.co.id. [116.206.12.43])
        by smtp.gmail.com with ESMTPSA id x13-20020a170902a38d00b00189a50d2a38sm10016316pla.38.2022.12.29.04.46.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Dec 2022 04:46:20 -0800 (PST)
Received: by debian.me (Postfix, from userid 1000)
        id 3E5031046FB; Thu, 29 Dec 2022 19:46:18 +0700 (WIB)
Date:   Thu, 29 Dec 2022 19:46:18 +0700
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.1 0000/1146] 6.1.2-rc1 review
Message-ID: <Y62MGrp7N0jrdWSS@debian.me>
References: <20221228144330.180012208@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="C2zNzXWLX2WW2EYn"
Content-Disposition: inline
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--C2zNzXWLX2WW2EYn
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 28, 2022 at 03:25:39PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.2 release.
> There are 1146 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully cross-compiled for arm64 (bcm2711_defconfig, GCC 10.2.0) and
powerpc (ps3_defconfig, GCC 12.2.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--C2zNzXWLX2WW2EYn
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEARYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCY62MGgAKCRD2uYlJVVFO
o2rJAP9DD4wmJTSRCUEZ98vogIc/vL+3Lxvkwy+2YCA5hOrNwgD/Yief6eXrfEUy
6YT2w+O8gj2rq7GdY4SIuX6v+TZ51AQ=
=eYBH
-----END PGP SIGNATURE-----

--C2zNzXWLX2WW2EYn--
