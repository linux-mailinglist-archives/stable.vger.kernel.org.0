Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 566526B0244
	for <lists+stable@lfdr.de>; Wed,  8 Mar 2023 10:04:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229653AbjCHJE0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Mar 2023 04:04:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230051AbjCHJEX (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Mar 2023 04:04:23 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B22813585;
        Wed,  8 Mar 2023 01:03:39 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id ce8-20020a17090aff0800b0023a61cff2c6so3400779pjb.0;
        Wed, 08 Mar 2023 01:03:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678266219;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=J7rT0YVbd83CrVSWcRxoFWFor/uPS8qdQdsIn5lctSQ=;
        b=J+n8BcGDjEsRoJ9OUv1LkI2mUe6cYkmz7x/vWhDCbjKHUBvaE7GbKy8l5frTdQxnmp
         7kW0tWbz0UCmB8bDyJXROUa6mnZsNmWjzorLfixDtWwTWeieLKL/r9p1/JnLf1QvHMRn
         AtQr8M+GnBkKSi/KMMdkFTUYpa7XtMQq8Kx8Tskg8gWl4E9Dder5vX51hP8k/O0i+04Q
         wv5aQd7YG61f2sdUuXCja7FHYuNOVB3yKgzSmBAjaSxp8pWY9ue0+S9kvod+Lcx4fR7n
         ckZzh4s/v5sg9v6DITseLQPOryAYFrukiorFpOSqREhoV3Vat/6PV+zrY+G3Ti9C89sy
         T7HQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678266219;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=J7rT0YVbd83CrVSWcRxoFWFor/uPS8qdQdsIn5lctSQ=;
        b=ZOlKVqenV/5fDqni15Dwb3lGITH+PZOtSGquZ2EUIMqjmxOtgoiwSLQPW9DRfUzaXv
         Yc/7Dg9ApwGMVPzWKI8s/KohKMBGMLhDYPzKlYMhwVDJ1c/D5YuY7lZDRs+tleM9FGM1
         g+P5719ULeQscxznUUlJrhzuA3L1+INGo6x6JJcnSLP+Lonb26OewAodrhe779a9bOWv
         Aa5MBw6YA/bhDnNni5ylhmD3TLh/kQ39SecVjioXbOlHjHqMsYnY8+YsPiYhZr8N66tF
         EVIqQDa5QX9LukxxnEogc4bnc3c3NLBZ6jbRTgAOF2d0FvvxiT2w5C1kyH8Lud1tG2iv
         jk7A==
X-Gm-Message-State: AO0yUKUQWidwblIts6GTQJNHbqHiE4PFsS+9ZbG8m03HzTKwQmY0Mx4a
        esYbWb3Q+ag/2AnOGoYE8Mw=
X-Google-Smtp-Source: AK7set8/37WQTisw6yJ/SwIohvmHOjGRZqEZqd6Ya3St2U/DvkCTsRPo+J/kl2UHH6UYBxT0IrzxAQ==
X-Received: by 2002:a05:6a20:69a8:b0:c7:7d45:50fb with SMTP id t40-20020a056a2069a800b000c77d4550fbmr16362644pzk.28.1678266219091;
        Wed, 08 Mar 2023 01:03:39 -0800 (PST)
Received: from debian.me (subs03-180-214-233-16.three.co.id. [180.214.233.16])
        by smtp.gmail.com with ESMTPSA id p21-20020aa78615000000b005a8c16fcb78sm9028264pfn.56.2023.03.08.01.03.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Mar 2023 01:03:38 -0800 (PST)
Received: by debian.me (Postfix, from userid 1000)
        id 58A1A1064E6; Wed,  8 Mar 2023 16:03:34 +0700 (WIB)
Date:   Wed, 8 Mar 2023 16:03:33 +0700
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.2 0000/1001] 6.2.3-rc1 review
Message-ID: <ZAhPZYfb/dZEUEfz@debian.me>
References: <20230307170022.094103862@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="xTpkWPY/u/T2Ll4a"
Content-Disposition: inline
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--xTpkWPY/u/T2Ll4a
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 07, 2023 at 05:46:12PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.2.3 release.
> There are 1001 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully cross-compiled for arm64 (bcm2711_defconfig, GCC 10.2.0) and
powerpc (ps3_defconfig, GCC 12.2.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--xTpkWPY/u/T2Ll4a
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZAhPXQAKCRD2uYlJVVFO
o5ZuAP9pIJnuY4oRsRFM8QzxdCqqbv7vl0il7VLcPHxx5uLFowEAl3OlparCA1Cy
WmT/I1oZmHq7TpMaRPlVQB7zFDZjqwA=
=+mvj
-----END PGP SIGNATURE-----

--xTpkWPY/u/T2Ll4a--
