Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A5C56E87C7
	for <lists+stable@lfdr.de>; Thu, 20 Apr 2023 04:03:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231319AbjDTCDT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Apr 2023 22:03:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230244AbjDTCDS (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Apr 2023 22:03:18 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77F1B3A96;
        Wed, 19 Apr 2023 19:03:17 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id d9443c01a7336-1a6670671e3so5957995ad.0;
        Wed, 19 Apr 2023 19:03:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681956197; x=1684548197;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=daoW9QA06zZMAl1RTvG2SlKgRJ+qcs4DTZlqIRplbzw=;
        b=cTiX6WHisRzCQEUNVND5mOIlKKG2n1T0iw4EZ+GdMSU5ag5+KgfD3sCs+xMvT6AJHN
         f5niSNhAZieO42mfSe3rVSDGYhIqVR2ZUCMMpRI12a+O7lVtCCmTGzDD5zOOuYJ4iqW4
         IG4eED8BPN303/nn/2caRpwtXPldp1G1c/D+rMR5nlrGVGLJtlM9aosi/31KwjQUiLHt
         aXivzHe3TTyUJ+GJVUHTcmyr8yVE2FV8+xlTUMKzqBFiRHzkYiGu5JkzmJhlfkZAWn7M
         kadB2Tfu8DqKgELgzP0xXtb4jdVbNMkWt3ZrWTzMXEAYRYWWnvGcl2PBWtx/ke1Tud2h
         lxzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681956197; x=1684548197;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=daoW9QA06zZMAl1RTvG2SlKgRJ+qcs4DTZlqIRplbzw=;
        b=E+iuZvzNYVpUzW7UZjyXhK65vpsjwjWdpPu4TflWaiR+loLlzDK6b+ACM7wlSdCVvW
         zrdYl0QwzT3T0ADbdbGrLXztaw3AEyHb3YtsKnKM+vVhJ9qiBRGybi0AnIotSvbmzkgi
         JqVXLvCYyZQcLaVTLcpOhsbA7hP+RWCML2gRWd+s8tJHi3jgKVPfShyFOm1TR2I/Py7l
         u1wdjBjFtdWEOax5ENgBzMJozIIzgR6Hlpe3/3/628qzBIajAQKRFgFjx2nM4ac0n/WH
         Ujy2IoiRq5zY2AOC0rDc7BeuExHaVh1isf4EjK6GTYzZlvfhNiFCVw+hjIWagLNRqeEF
         hsxg==
X-Gm-Message-State: AAQBX9eUV3+JF++hz2jlpiP0xGoJF9DpPLm70WaZD4cRVSFBSYyuLHcd
        kogCzOJp1bp5JoTbFtoXPHg=
X-Google-Smtp-Source: AKy350b/e82OpwPeFZbkBWEfdyCBrY4Z4wIh2UuFlULKY4B72s+KxWSf8e+jEddpRg0XpgscBNQvrA==
X-Received: by 2002:a17:902:d2c6:b0:1a6:45f7:b332 with SMTP id n6-20020a170902d2c600b001a645f7b332mr8679362plc.63.1681956196714;
        Wed, 19 Apr 2023 19:03:16 -0700 (PDT)
Received: from debian.me (subs03-180-214-233-6.three.co.id. [180.214.233.6])
        by smtp.gmail.com with ESMTPSA id a8-20020a170902900800b001a64475f2b4sm109806plp.111.2023.04.19.19.03.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Apr 2023 19:03:16 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
        id 9DEF510686B; Thu, 20 Apr 2023 09:03:09 +0700 (WIB)
Date:   Thu, 20 Apr 2023 09:03:09 +0700
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.1 000/129] 6.1.25-rc3 review
Message-ID: <ZECdXU31erXYYB6k@debian.me>
References: <20230419132048.193275637@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="IVvWDvxZnxJiyVq1"
Content-Disposition: inline
In-Reply-To: <20230419132048.193275637@linuxfoundation.org>
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--IVvWDvxZnxJiyVq1
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 19, 2023 at 03:21:54PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.25 release.
> There are 129 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully cross-compiled for arm64 (bcm2711_defconfig, GCC 10.2.0) and
powerpc (ps3_defconfig, GCC 12.2.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--IVvWDvxZnxJiyVq1
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZECdWAAKCRD2uYlJVVFO
o+vXAPsHphc1gRa/3dMBQ7hApPrv/C8sqrvwLQIk9fQNlD2GRwEAlNlch7c+77TQ
orHk+LHMkq2pKqhuaWFCXn2978Sv9Ac=
=f5V8
-----END PGP SIGNATURE-----

--IVvWDvxZnxJiyVq1--
