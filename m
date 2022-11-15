Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8856A629431
	for <lists+stable@lfdr.de>; Tue, 15 Nov 2022 10:21:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229798AbiKOJVo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Nov 2022 04:21:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229781AbiKOJVn (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Nov 2022 04:21:43 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BF4A1F4;
        Tue, 15 Nov 2022 01:21:41 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id u8-20020a17090a5e4800b002106dcdd4a0so16361054pji.1;
        Tue, 15 Nov 2022 01:21:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=UvxQFY1j66EF2lwTmE8W9AjKJ4egmazJXV/Ig6P65R8=;
        b=gyivwoA3r0QAw1YgZbz/FtKiVshzUPUCdLjtKS0tf5PRJlLF1CZxRjEktGPQ9AI8tV
         UWkbsMF57nUAh/s+EqvoURlOLIpBFZgOTVW1DggPvS8PhWgpRSrwBwfTuUyP6HuDmQVD
         Ixm+grmKn4hUo+V1eOZnHwZFNN9wdQuC+kz9jH5AKpVeAgtzR++Ok10GqBMOo7FJLYBh
         DKlTG/v2/MHb3MQhm4tJk9/gc+Lxz8NIVHem16kX46lq3vvTSli2554Dx3somThxqBGv
         hD7RS6kZV4oXKgBoR+ACsFOerNN1MCBey2wk0bbCEaB6WFZrpkJXOq7m5gxpYJiUrP/Y
         F/JQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UvxQFY1j66EF2lwTmE8W9AjKJ4egmazJXV/Ig6P65R8=;
        b=amI8MBN8EPiQ2Y2LyE90LVv+4hnUTYhZMI02DbOg4omuU2/YF5ioyRNgkaHfwtDjzw
         1xaY2jtVgkR0FyjFyJft6mNdBPwgMRSOumsQAWkHhNLp2BjLwekdSavGTbMEjl8fGc0I
         JPIB+Y3BdUraoXuIPnhvCSIlwuWxxhJH/fBWPr+mw+0pkFCzsR2oz+fUM/N9u79Ny1z/
         FRfYXF2EGJo56RPimQJj5markFRE/rA4qjBbxwinnTzBf8LTb7nHK+YuLdd7U9zA3VFy
         vY9YgKLrMtLiAjKznRAN/1S3t63UrrsyrGXUesMCgh9sjIU+xAf2uMs8JC46KN6DXy+k
         7VIg==
X-Gm-Message-State: ANoB5pmBChuK9ae+oQcdzdwVqjLC8hqIPTaC3NjRaVOGrUW6folW5XaA
        nWGBgQWKtf/LxN4eU7Wve1Y=
X-Google-Smtp-Source: AA0mqf4KfHcPQJ64kBVHTp8/4HGiTdY3E/fDOuBUnpjFtOjbiIQo+ANRlr8yPX6xPqPymKdfRSCkUw==
X-Received: by 2002:a17:902:b694:b0:17f:7d9a:4952 with SMTP id c20-20020a170902b69400b0017f7d9a4952mr3143749pls.117.1668504101145;
        Tue, 15 Nov 2022 01:21:41 -0800 (PST)
Received: from debian.me (subs03-180-214-233-20.three.co.id. [180.214.233.20])
        by smtp.gmail.com with ESMTPSA id x1-20020a170902a38100b0016c9e5f291bsm9276497pla.111.2022.11.15.01.21.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Nov 2022 01:21:40 -0800 (PST)
Received: by debian.me (Postfix, from userid 1000)
        id 84F3210434C; Tue, 15 Nov 2022 16:21:36 +0700 (WIB)
Date:   Tue, 15 Nov 2022 16:21:36 +0700
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.0 000/190] 6.0.9-rc1 review
Message-ID: <Y3NaIGz8UM12Oxap@debian.me>
References: <20221114124458.806324402@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="vJ94NYY22K9rIk9s"
Content-Disposition: inline
In-Reply-To: <20221114124458.806324402@linuxfoundation.org>
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--vJ94NYY22K9rIk9s
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 14, 2022 at 01:43:44PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.0.9 release.
> There are 190 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully cross-compiled for arm64 (bcm2711_defconfig, GCC 10.2.0) and
powerpc (ps3_defconfig, GCC 12.2.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--vJ94NYY22K9rIk9s
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCY3NaFwAKCRD2uYlJVVFO
ozSHAPwKO1XU3tZq+1v47dJdMqRcmyClqE1LqvZxE4Lbf3syowEAsWPdHBuMhoR0
KzDhon3V/3v3q6cRGG1hDBTBU2LQ3wQ=
=2NQU
-----END PGP SIGNATURE-----

--vJ94NYY22K9rIk9s--
