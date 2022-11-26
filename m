Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B0566393CF
	for <lists+stable@lfdr.de>; Sat, 26 Nov 2022 05:04:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229841AbiKZEEx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Nov 2022 23:04:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229748AbiKZEEw (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Nov 2022 23:04:52 -0500
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0BE810B6A;
        Fri, 25 Nov 2022 20:04:51 -0800 (PST)
Received: by mail-pf1-x42b.google.com with SMTP id w129so5660964pfb.5;
        Fri, 25 Nov 2022 20:04:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=95OizHEzM2jvpWCl45WD9PQzeRhdcr/x5Yld8IlNbDc=;
        b=b01ulhBpJKqNaGt6lYxcNqq42VKIN+GAulpM64tj+oJp4fZZDRcUIclJRMaER/TLJo
         G28+zivhc2C/Wu8dMhiHgI5hn+98vYyvqwwWSwuGs0YCVvnURI5luz298T7DfsE1Ow6/
         xtGutVxWfUvHT+/9FuclMZ7wzUURDA8IiUNYoUOjrA0hHwCmwSGIsuPS1XpGO9hMbbHU
         FuQw8s6fbTZZmaSG8/82oKzekWbsWRv/X28zfI3CnK7//oxwRjDFcpkeioBuH6lejgE7
         dRVdbT2W7lAHW1xt7BA4vtF95LYPMyeD/iHLlqE6Y2TPrIt5TxALuy6ANCwarBewx4gW
         N+HA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=95OizHEzM2jvpWCl45WD9PQzeRhdcr/x5Yld8IlNbDc=;
        b=nCBtWyrp2cBd2vK+poUJ487PfdOgz6trfuCt1KmhKbzFX+FHwQD46nRsYBub//1y1Q
         Yd9BXg1ohJRE030h0YafHX8TWq3U18MYsFyUpGCDJxooOE4YhgXepMwliLnO1Ortsdpi
         gDqZbGiD9dBCEvRrPoqL8A2UWTDUK9tsoTRJihHz13Gw4e1CurUQyRdyGOkAGVokirkn
         k6fx6z92UyDHLTwZ7kQLpIkaUjl2tJx31SHDeTGW1k8KnwySfHaZUFQ7sJWm4IQXPLc+
         U/LuBG4lg/61fZQn6fBL1itFzJRsnMxYPkRaxp+bukLQDa/TWKSSYog4n4TS+ddGtsi6
         QLbg==
X-Gm-Message-State: ANoB5plhvSbMaP4vZzuHU4276PyjN/1FJmyZvpORsKRP+sPGwBq8r2Ln
        cCLVciJl4quZNqDXOsdSTUw=
X-Google-Smtp-Source: AA0mqf4h5cDCMT0ybHUhsTP6F4XGrrFUUo7V7iE4n7eZmvE1++RI26c/5Bq83SsGT95uRpxMeCvGjA==
X-Received: by 2002:a63:1e5b:0:b0:477:3c62:49ba with SMTP id p27-20020a631e5b000000b004773c6249bamr18528520pgm.446.1669435491087;
        Fri, 25 Nov 2022 20:04:51 -0800 (PST)
Received: from debian.me (subs02-180-214-232-12.three.co.id. [180.214.232.12])
        by smtp.gmail.com with ESMTPSA id y16-20020a17090ad71000b0020bfd6586c6sm3693326pju.7.2022.11.25.20.04.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Nov 2022 20:04:50 -0800 (PST)
Received: by debian.me (Postfix, from userid 1000)
        id BCCE1104330; Sat, 26 Nov 2022 11:04:46 +0700 (WIB)
Date:   Sat, 26 Nov 2022 11:04:46 +0700
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.15 000/180] 5.15.80-rc2 review
Message-ID: <Y4GQXrB4RGY7IHbE@debian.me>
References: <20221125075750.019489581@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="HVPc8jQf3GLmHf8m"
Content-Disposition: inline
In-Reply-To: <20221125075750.019489581@linuxfoundation.org>
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--HVPc8jQf3GLmHf8m
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 25, 2022 at 08:58:52AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.80 release.
> There are 180 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully cross-compiled for arm64 (bcm2711_defconfig, GCC 10.2.0) and
powerpc (ps3_defconfig, GCC 12.2.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--HVPc8jQf3GLmHf8m
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCY4GQVQAKCRD2uYlJVVFO
o/tiAQDOF8n1CaBFVPf7Rk1vADecFV3tdxh5BxzH6hFW++N3RAD9FoRDBtDki1hG
f3csZW56CzZpnRz5jHdi2a9OcUMt4w4=
=6tJR
-----END PGP SIGNATURE-----

--HVPc8jQf3GLmHf8m--
