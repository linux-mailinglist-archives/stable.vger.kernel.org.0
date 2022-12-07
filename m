Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D0316452D1
	for <lists+stable@lfdr.de>; Wed,  7 Dec 2022 05:03:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229714AbiLGEC6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Dec 2022 23:02:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229739AbiLGEC4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Dec 2022 23:02:56 -0500
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BADA11C19;
        Tue,  6 Dec 2022 20:02:52 -0800 (PST)
Received: by mail-pl1-x634.google.com with SMTP id b21so15913177plc.9;
        Tue, 06 Dec 2022 20:02:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=gIIVDiA6O3R8AWSLOqlskI8v6XgtpOiioOau4DQUd/4=;
        b=i2GYnfuB+2+O1kLixvLlcum8K8NFE3r9kxr23sxCkdsnkR9V2HbbIZs1zvCEVKDSik
         gSn5jPdkXsO/eyNER8+FsWy5vNoYdfe4iO5AB7MqcWcsY2aZBKiKSG57Ryb/bKt64U84
         XplaqU4am4YNyOj/PtqGfs+LX6AhqYi6ph5q+Gy8Df824W4xPO8gJNjfXZ4n0r/KUfDK
         0t2vNa04Sz/+lKN/V8m6hJprK+iiIcbP35n45+eKSkzWd68qhM5Se1XOGpHJSg5v5Rb5
         lg+NilPBWImI47df0bZtf62v36/8H+JdCEQywEZ3H+6kQULdjzUDfZeecrDJIeCNmnBI
         Di6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gIIVDiA6O3R8AWSLOqlskI8v6XgtpOiioOau4DQUd/4=;
        b=p8SeTLCrWF+5ZJzPoJdNB+MgUwevmVLHW0f3AxoEh9voh62unMa5JJzrj7PoRyp9gp
         i1p7Vx5Pblf++cvuodOJ3FOJj5OO9In6NFn0YvtcdkiuxmWiXcFv9d0FMxehCwOtuqSN
         yRLv/7DRvGh3sUQoPMrLZppvYX7KNc48JmxbAXnkzJP2Y4otUdU2IPGO4fWgmzzelcoI
         Bm8E9WuMhWaEIztBvPzbhJKN+DnrjddkphdUDQJvxNE1mIBdXdP9w3MyyKPPu5uVrSxo
         Mr4916KVPpNzG/IUo+DtdlBjn3VIC/WI571Z4o8bX/WotSwN75K0GBXqSduhKViZo8A5
         y2VQ==
X-Gm-Message-State: ANoB5pmzIrifFfQP7cf4MMgmHA8wKd2UlCP9GbIr2E76KJpV8S/IpGd7
        GbBjtxVHjmRg6JmLC5GHoPk=
X-Google-Smtp-Source: AA0mqf4hCWSTp51T31E50oShmQ6K6IRU9l+gOM/nt5Crvt70lzo4yZT5hwf4YKd3BpyVWVqjan/Dlg==
X-Received: by 2002:a17:90a:6c46:b0:21a:401:d2c0 with SMTP id x64-20020a17090a6c4600b0021a0401d2c0mr4968212pjj.34.1670385772133;
        Tue, 06 Dec 2022 20:02:52 -0800 (PST)
Received: from debian.me (subs09a-223-255-225-78.three.co.id. [223.255.225.78])
        by smtp.gmail.com with ESMTPSA id c10-20020a056a00008a00b0057255b82bd1sm12365502pfj.217.2022.12.06.20.02.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Dec 2022 20:02:50 -0800 (PST)
Received: by debian.me (Postfix, from userid 1000)
        id 08D1B1043D3; Wed,  7 Dec 2022 11:02:46 +0700 (WIB)
Date:   Wed, 7 Dec 2022 11:02:46 +0700
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.15 000/121] 5.15.82-rc3 review
Message-ID: <Y5AQZqNP9WI+LKV0@debian.me>
References: <20221206163439.841627689@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="baYlNvgVIsIVFk5h"
Content-Disposition: inline
In-Reply-To: <20221206163439.841627689@linuxfoundation.org>
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--baYlNvgVIsIVFk5h
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 06, 2022 at 05:39:55PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.82 release.
> There are 121 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully cross-compiled for arm64 (bcm2711_defconfig, GCC 10.2.0) and
powerpc (ps3_defconfig, GCC 12.2.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--baYlNvgVIsIVFk5h
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCY5AQYAAKCRD2uYlJVVFO
ozOIAP91FP4DCdI2z2mZOt5hqJqBBLpORz4uwkJTDoUI+YBu1wEAuQlRrhzGS8sM
qE+z4iXWNMc3jK4p2ipEaRwaREc5Lww=
=fZ66
-----END PGP SIGNATURE-----

--baYlNvgVIsIVFk5h--
