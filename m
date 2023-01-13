Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2FD16691F4
	for <lists+stable@lfdr.de>; Fri, 13 Jan 2023 09:58:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231139AbjAMI6h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Jan 2023 03:58:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231594AbjAMI6a (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 Jan 2023 03:58:30 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4D575E674;
        Fri, 13 Jan 2023 00:58:29 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id z1-20020a17090a66c100b00226f05b9595so8651017pjl.0;
        Fri, 13 Jan 2023 00:58:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=FOXPJ4ctD/k2tBI58EgwSpUTlf5yt8enn1GdO0RLBD0=;
        b=WepC8TjvkfEvn2+hH+Z9pCWF0UhvJkafe0KSBJ71K2YEizMOPCV7SXZfh/ziw07ThH
         CHRY+4mmFo8uk66L+y7eGGfpTxHamxpsQHfl2SalOt5DWCu8KJE5IrUtSYDyup8GH6SJ
         aHC61XuOoagU+UkBu/mAhD0UeLZqVDeM9ZsmuHebZ5YKsbLBYwlP8qA4Vmf5q63Bi84d
         YCzyyplOSRx+4Mn0JKEiSOwSIeoHD4ZJO8Ynrc0hMjvFC5MAauSB6L1a3U9KwAcQJQrY
         WxV+2gMqFbIcwee5y24U2BJ5XxrpWQQjXuDRT4GfoqtVN1X7jigcUEVivS79VS81Rj3j
         PKMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FOXPJ4ctD/k2tBI58EgwSpUTlf5yt8enn1GdO0RLBD0=;
        b=SfqDUdJrFwQ8z0aeqIP7uaK5DycvgUPPVxVEebaGdYWOusspVGxNz5GG+w/FRyy/9X
         c+cKkpEqDJ4dmGM0aH1QwFHIEtrI9ljVw8sdkQKikzmUIF+3k/NRdQc5Aqg1iMI3VIus
         A7dB7RK6QZmejaZpHro60/rIHHUMORXr5cpUgRz6aSETo868gw+Folbmw/CqH3KzJO65
         Kqi9pAZ3Sr50GlDHalrzEv6nsr2gnT23l0JyQKJ+PFRGjygwCKdj1nBIn0nhiQmbO7I+
         0KCtfdEFyF4GPpMW92gyZaRkW3n9cIts6sQyA4AY+ZXODDLQaYsJgg5JF1X/zdFnAZbn
         wu1g==
X-Gm-Message-State: AFqh2kob+ZYVaKOcJf7aWirQD/6ci2Klh+FVW+A5mymTlWXeo0cz0bRO
        ef9k7f09Jt9DBy6SIUbU7os=
X-Google-Smtp-Source: AMrXdXuQw68i6p+qo+YvoqAdx2+WtXc7vRnMg9DA0n+kdseNoAgF7zhqsYbHAx61beHGy0jivV0+dQ==
X-Received: by 2002:a17:903:2781:b0:194:62d9:9a86 with SMTP id jw1-20020a170903278100b0019462d99a86mr4518331plb.59.1673600309306;
        Fri, 13 Jan 2023 00:58:29 -0800 (PST)
Received: from debian.me (subs02-180-214-232-12.three.co.id. [180.214.232.12])
        by smtp.gmail.com with ESMTPSA id l17-20020a170903245100b001890cbd1ff1sm13660500pls.149.2023.01.13.00.58.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Jan 2023 00:58:28 -0800 (PST)
Received: by debian.me (Postfix, from userid 1000)
        id 52ADC104D0B; Fri, 13 Jan 2023 15:58:25 +0700 (WIB)
Date:   Fri, 13 Jan 2023 15:58:24 +0700
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.1 00/10] 6.1.6-rc1 review
Message-ID: <Y8EdMJ2eLJUS89MS@debian.me>
References: <20230112135326.981869724@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="zQWMkMI+vsN3CxJf"
Content-Disposition: inline
In-Reply-To: <20230112135326.981869724@linuxfoundation.org>
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--zQWMkMI+vsN3CxJf
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 12, 2023 at 02:56:21PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.6 release.
> There are 10 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully cross-compiled for arm64 (bcm2711_defconfig, GCC 10.2.0) and
powerpc (ps3_defconfig, GCC 12.2.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--zQWMkMI+vsN3CxJf
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEARYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCY8EdKwAKCRD2uYlJVVFO
o8TtAP9eso2fiajGisTlUTcDipiG1cn3y8pnv8zXeHj+GFa6+wD/V9SD7pAdnmgs
WuXlu5MexNtRwUPOvPmfy64uD14rQA4=
=O5XG
-----END PGP SIGNATURE-----

--zQWMkMI+vsN3CxJf--
