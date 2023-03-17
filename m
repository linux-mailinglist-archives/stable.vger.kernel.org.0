Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D2FA6BDF0A
	for <lists+stable@lfdr.de>; Fri, 17 Mar 2023 03:49:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229554AbjCQCtt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Mar 2023 22:49:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229680AbjCQCtt (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Mar 2023 22:49:49 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 280A66A42D;
        Thu, 16 Mar 2023 19:49:45 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id u3-20020a17090a450300b00239db6d7d47so3582455pjg.4;
        Thu, 16 Mar 2023 19:49:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679021384;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=TORpu30El7nG8HycJj3Z1wYzuUhx8ncPfuCvLKnEFsM=;
        b=UEcIYDH3mqvEbbIKBY+LFKBvR9zKbKxKi5eGnAzZUGDTIZthZYd1paXqu0mvdTQ3EH
         v1FKz9SJ2Or3x2JQL1/rCZFIGZoov2HhP61WW3TyFPcz4M0yisqx4Nx21RNTA9e/91MM
         FtndcE6s4KFF434ToGNS7k7YgvFwIdIy87Kq0scPrLALrwe0DdeyfFEM8OLz0RI17uXA
         nfUOPl7utXQGtFJ+OgXpgYVHSAcH0pR2MmKTGLfIuoHh5gR49qouxJolv4UocXOA25uu
         VX89iyq2dts8ebPDnNCYXS+2/RR0JaJ/w0T2xSSfa50iKuWh+aoUTK91mpX/ao4SqouP
         5RBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679021384;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TORpu30El7nG8HycJj3Z1wYzuUhx8ncPfuCvLKnEFsM=;
        b=pH1bbWcJDmVbS45NpRgGURboNHTtZRa8ZoNxdiilBI3+ouggSD4YjKfCw1+6ogTIH9
         xVYpMxcTE+9GntXpPxo6kd01sckOkCD/QAQi0CANZYFv1z78AgCmb41qIMfbzftqQTiv
         sXCs5PMfnxdpyyRzcL+JsIULCOFIiw6f/EcPqruMJU4ZHrAnXoxF93tm3YnJz1guUZ8t
         0KrK5PhWV0QSoum+wi2oyGKXCL0dAUjeZ5q17C+voYX53MF2Gxh9SZ6STmvPcatamDuL
         GPKTXQlVHUFfBMJQWFaCWAixzP5VMzTxyN2XiYgndRSnXe9ZjFSMs7PHc1F51K3mvGd1
         tC+Q==
X-Gm-Message-State: AO0yUKVLRwCddsLTIzURMwT18Elw8C3J/JaGuY2xawAiBTTUBe6FEu63
        rziQd4ljAd3aWc3eLKea634=
X-Google-Smtp-Source: AK7set/gHvt+O2L/YfpDu7KOmMKiccaiI5yCRUV/+djUpMR4U6wtb1+4LKfJ5tGnJuA4KDVtOJG/wQ==
X-Received: by 2002:a17:90b:1d87:b0:234:e5c2:b92c with SMTP id pf7-20020a17090b1d8700b00234e5c2b92cmr6338818pjb.15.1679021384611;
        Thu, 16 Mar 2023 19:49:44 -0700 (PDT)
Received: from debian.me (subs32-116-206-28-44.three.co.id. [116.206.28.44])
        by smtp.gmail.com with ESMTPSA id gp5-20020a17090adf0500b0023b3179f0fcsm3929302pjb.6.2023.03.16.19.49.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Mar 2023 19:49:44 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
        id 8758310682D; Fri, 17 Mar 2023 09:49:40 +0700 (WIB)
Date:   Fri, 17 Mar 2023 09:49:40 +0700
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.1 000/140] 6.1.20-rc2 review
Message-ID: <ZBPVRFsMWikYob0x@debian.me>
References: <20230316083444.336870717@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="QmzSyHh2VEIlveiH"
Content-Disposition: inline
In-Reply-To: <20230316083444.336870717@linuxfoundation.org>
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--QmzSyHh2VEIlveiH
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 16, 2023 at 09:50:22AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.20 release.
> There are 140 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully cross-compiled for arm64 (bcm2711_defconfig, GCC 10.2.0) and
powerpc (ps3_defconfig, GCC 12.2.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--QmzSyHh2VEIlveiH
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZBPVNQAKCRD2uYlJVVFO
oxw5AQCie6V8CnFDb6CYnWkTnAjJashI/L57+3RTzE13x9SdJAEAlFMj4rTYx5je
oPz/p0YpA/h7kZK+TZusb23F1N32JwE=
=2Ssr
-----END PGP SIGNATURE-----

--QmzSyHh2VEIlveiH--
