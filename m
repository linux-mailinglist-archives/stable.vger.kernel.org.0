Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C9CE6D56D9
	for <lists+stable@lfdr.de>; Tue,  4 Apr 2023 04:41:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229689AbjDDClV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 22:41:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbjDDClV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 22:41:21 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DC0110DA;
        Mon,  3 Apr 2023 19:41:20 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id z19so29984879plo.2;
        Mon, 03 Apr 2023 19:41:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680576080;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=v1FsOYpJR8KsBcGVyYzp35XtFBS8mpozVZSwh3hhDpI=;
        b=f6P4jqCgm4Jo+h3qCzymQ2y+Eo74HO7F9erlJGQcGkkuVbklUXvMd5IiyUCBEWOSbp
         zvP3dBl+xp+zoQiq0OAEg95+c/G3rt5h+OgyjpkozxbPNcXFkcOMKA4j2pklJ9l7XEBF
         E0TNbu6jmmJAL53K5YtDfrD/T7b5/bQTWZ64pw/OiI/EVCNShOLrrUDHATy1e0XIs0tq
         iCAvW0MT+a1HGiyQpVsLchaaBE3lvChZ0cqeLNDj9MedGjAyg/eIs4Qzofh/t+QQ1Usf
         SZbWYeVVbRv/rnScPdZ/VsdZSsnKPmwsiez+14n6gDUouaP67jEzzwGhK0X72/9WjckN
         jc8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680576080;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=v1FsOYpJR8KsBcGVyYzp35XtFBS8mpozVZSwh3hhDpI=;
        b=fx5inRga5sb9C3GH7keC+hor9Ud6pmQ9bDiCXJtW7oxSgt0c2hnTGNrXrPM+u2s6o5
         tqQGCr2iY5nuRVWYTLt7hGsW/Q2oJaH7rG+Iudvz1FvSJon8J+n282I3big9uxAeD9NX
         JgWUUOtQq6EpnxLI59n9TQEtFYS/db3WKHbx3pSIXf9aqWi9ZEwDOIWAgeM9kft5IdXF
         +tAcFEKJUuQ8+kvQZtancwU9O9LykYl7lG2KNkz8nXIwccy447w0QjrzzojWoEdbxc+F
         2C1kSsJzwShdbZHEl5i0/zCxLCUf40VSLxdoxaVEwAPqBBU+89edxHhdYVKdCNzx4fri
         j6Iw==
X-Gm-Message-State: AAQBX9eg7qL+lgJO6yhC68uReFQaBO/6WcQYseRgvjZj++0BeYZTnL59
        obcjGSguMPkTbetoiXmb9yE=
X-Google-Smtp-Source: AKy350ZL+LoEZJ+XVZRbVNoluCojl4f1E5Daj+5eZfjTtV/+2WtzbOBhlVbgOuNeN5SZDBaUeWL2BQ==
X-Received: by 2002:a17:903:2287:b0:1a1:ee8c:eef5 with SMTP id b7-20020a170903228700b001a1ee8ceef5mr1524461plh.7.1680576079912;
        Mon, 03 Apr 2023 19:41:19 -0700 (PDT)
Received: from debian.me (subs28-116-206-12-40.three.co.id. [116.206.12.40])
        by smtp.gmail.com with ESMTPSA id b11-20020a170902ed0b00b001a22d274045sm7290463pld.144.2023.04.03.19.41.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Apr 2023 19:41:19 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
        id 5ABF7106790; Tue,  4 Apr 2023 09:41:17 +0700 (WIB)
Date:   Tue, 4 Apr 2023 09:41:17 +0700
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.15 00/99] 5.15.106-rc1 review
Message-ID: <ZCuOTZQuc9XpjD4l@debian.me>
References: <20230403140356.079638751@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="TEoeCkE3HNd3pzxJ"
Content-Disposition: inline
In-Reply-To: <20230403140356.079638751@linuxfoundation.org>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--TEoeCkE3HNd3pzxJ
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 03, 2023 at 04:08:23PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.106 release.
> There are 99 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully cross-compiled for arm64 (bcm2711_defconfig, GCC 10.2.0) and
powerpc (ps3_defconfig, GCC 12.2.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--TEoeCkE3HNd3pzxJ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZCuOTAAKCRD2uYlJVVFO
o5MVAP9EzGAEKT/G+NcZej/gIIOJ5+Z9bo6cpYS41N0jbz8CyQEA+b2xbBS7C7rX
/9PUFHIFrh7udDBOFSRvRAySGPB5Pgo=
=PnQW
-----END PGP SIGNATURE-----

--TEoeCkE3HNd3pzxJ--
