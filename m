Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B5736EDAF5
	for <lists+stable@lfdr.de>; Tue, 25 Apr 2023 06:47:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230327AbjDYErn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Apr 2023 00:47:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229637AbjDYErm (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Apr 2023 00:47:42 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EC477D97;
        Mon, 24 Apr 2023 21:47:41 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id d2e1a72fcca58-63d4595d60fso32834320b3a.0;
        Mon, 24 Apr 2023 21:47:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682398061; x=1684990061;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=x7mjglO56uGEvHM/CvZvHdpiKNwZ+e2uyMhpZBFkVkE=;
        b=MpjvQVeZ615veQ0dfUI3iJ5IOrl6uKSOlWytx+XxtudP1sK6WMjBXatV8TIGG3I/fm
         yThgFvFnZhY6ZLunhNy3wluje5OfvaOpU+juESYW/Gxy+Knglu3halQWwh3+Q8xWU7K3
         8AfdpgNdKiPYUfRzMXilRf0OEIWFCUqknuNLVhmILeKbJc+nvWY8K3aV9lP5NjNIOdVr
         JFchFa+J/ZAOuyy00QvCr7wilBp+6nMr1DjLnqQpCSmutPwRs29x0BPiFt2HsilRrUnN
         Vl1OxmEj1KOg+oLu4RDl8D+29oBV6PChAL5pQAAIcmpB80svzuQNLGh4vdiKKpBsE5VU
         GIZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682398061; x=1684990061;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=x7mjglO56uGEvHM/CvZvHdpiKNwZ+e2uyMhpZBFkVkE=;
        b=CnQtnpmPhtNfr5ixCKYvPFSp7aTm3/jCdGz6JBOitMoLP/3PxJZcO0S6OR4LBNbM6/
         8XgEAwYLhi9kqHbrsCmyrt8UALjezROo4vk5Q9YHHPWKaU4WYcCLiHNPbGy/2Xnbh/xu
         9q/xfj+2hbZ819YTAOPyDx30J+jObKeb9q1/4bFW1Tkyiecnt5LrmU2UgoMvpGo3wTt6
         YIR2hbthtPGija3toW+EL2g3YAMMjcNODjvE524dN+4O+1o9RIUJGgRt/x/B1rkfLugK
         IBVfX8CUmmLuyhX3deQD7fYVJYmz6VM9+5ckcWpyqETMbp1vQz+oUJLsPZXOEXbFL8Hu
         u9MA==
X-Gm-Message-State: AAQBX9ci83gKgHZZ9Qm1Azu9NEyXImJ09GriROfNk3Lx8kf7RvaSzkml
        9dtEtn4NiL2dbzUe36ukvWw=
X-Google-Smtp-Source: AKy350bOJYJTKZrlXFCQ2GhNblEqkGfNZrl02hvCz7jUd069I2qflDI/W1W3D87dc8W+v4PbEoucfg==
X-Received: by 2002:a05:6a20:3d01:b0:e4:b52:76c9 with SMTP id y1-20020a056a203d0100b000e40b5276c9mr19136264pzi.23.1682398060985;
        Mon, 24 Apr 2023 21:47:40 -0700 (PDT)
Received: from debian.me (subs03-180-214-233-73.three.co.id. [180.214.233.73])
        by smtp.gmail.com with ESMTPSA id b6-20020a63d806000000b005143d3fa0e0sm7255731pgh.2.2023.04.24.21.47.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Apr 2023 21:47:40 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
        id AF54610692C; Tue, 25 Apr 2023 11:47:37 +0700 (WIB)
Date:   Tue, 25 Apr 2023 11:47:37 +0700
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.2 000/110] 6.2.13-rc1 review
Message-ID: <ZEdbaUGIKPHEXvnA@debian.me>
References: <20230424131136.142490414@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="MH4cRJTFut+TrASo"
Content-Disposition: inline
In-Reply-To: <20230424131136.142490414@linuxfoundation.org>
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--MH4cRJTFut+TrASo
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 24, 2023 at 03:16:22PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.2.13 release.
> There are 110 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully cross-compiled for arm64 (bcm2711_defconfig, GCC 10.2.0) and
powerpc (ps3_defconfig, GCC 12.2.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--MH4cRJTFut+TrASo
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZEdbaQAKCRD2uYlJVVFO
o0y0AP9dlyjXe9nttqfxl7kJvhqc3A8CkAbFLQBjY7sF73NGggEAkI1axTBzxJN1
LgTaekGueQ7GHTTcQRRO25m1DT/L4wg=
=HiEO
-----END PGP SIGNATURE-----

--MH4cRJTFut+TrASo--
