Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D999622794
	for <lists+stable@lfdr.de>; Wed,  9 Nov 2022 10:52:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229550AbiKIJwW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Nov 2022 04:52:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230281AbiKIJwV (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Nov 2022 04:52:21 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12D1115FEF;
        Wed,  9 Nov 2022 01:52:21 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id v4-20020a17090a088400b00212cb0ed97eso1403116pjc.5;
        Wed, 09 Nov 2022 01:52:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=oNDweh28klnbWATkMWxRiD5blmbq8Y+Z/5E7YfYr16A=;
        b=R9jBH0SkSahkErpJVPn2Ex5lF0xUoh5Ij3drzCGUse1CHF4NzcYeFpve8WlAoQS50Z
         Lv0KeIIaREx2GMZIU6N9UM0TXeGT4M9zNK4bIENhQc5cxxLvIPMR/YzBFlmxBVGyYkEw
         NYSAKzbTwLKkHJ7KiB18d+odB0c3e8QuZUYYGXYeVYSBUN9y+H+iSqOgfzQW9xU3aqZZ
         B7fsDYKzwIqgpDx92/wmvStlpydci0a+nGPpzzCx2gNHroE10cKKByDkO4TDTtGcOp8i
         W4ppuez0iJWb3jFd9ZBKFegy/wnzprfyVN8AUgB4HsuCdy/CXONDVH9xutyLsyXdzJSW
         GVjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oNDweh28klnbWATkMWxRiD5blmbq8Y+Z/5E7YfYr16A=;
        b=BmU0M4xO8+XJzWZ7f5mJIprjJl2ItWixnSdp6NCNEGoaNTWv8OcRjrxffuHoCWSyDL
         IgIwejkiigqdLbto1oc9o7bgkOS9VVzvW7Yo1F3W3aZqH/18job8a5qyYbChSouCZDyw
         XbbwDzWI0jwBb4OfBRtoBJv2DrkppA2jREjg14aY4RCKEPiKg/4nuj3Wrk93dxIMagjc
         tPImZpaa34oo1KQVBVs8w3SXgX+24k27uS1vTypLiV+3kMtFIJ6mVOmkrMjvTkR9DC6W
         aXeKnZoxuybR+xo/jV9WZA5oonOkrKDSIyaSfVMDYsRPKaKgyt7eYgUh9mLMA5UUQ9z2
         Ae4A==
X-Gm-Message-State: ACrzQf0+cGzUjb4NqJ8sShEg1hG5p4orhLMFBe94Wf997zT/3a+Th6DC
        kqFXLmGr/RbBz+eVNJj/VHM=
X-Google-Smtp-Source: AMsMyM5NvopHQkEDQ7ic7Kcq3UquQbXnZisyIUFiH82w8IdTtMQAzWmTaD+Ef4IQ1rw+wAJu0PZN2w==
X-Received: by 2002:a17:903:1303:b0:186:969d:97cf with SMTP id iy3-20020a170903130300b00186969d97cfmr59044586plb.17.1667987540468;
        Wed, 09 Nov 2022 01:52:20 -0800 (PST)
Received: from debian.me (subs32-116-206-28-40.three.co.id. [116.206.28.40])
        by smtp.gmail.com with ESMTPSA id b5-20020a170902650500b00180cf894b67sm8595499plk.130.2022.11.09.01.52.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Nov 2022 01:52:19 -0800 (PST)
Received: by debian.me (Postfix, from userid 1000)
        id B4307102BD3; Wed,  9 Nov 2022 16:52:15 +0700 (WIB)
Date:   Wed, 9 Nov 2022 16:52:15 +0700
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net
Subject: Re: [PATCH 6.0 000/197] 6.0.8-rc1 review
Message-ID: <Y2t4T8ytz6YRsjdy@debian.me>
References: <20221108133354.787209461@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="U/u9ZVe03qhNmx+7"
Content-Disposition: inline
In-Reply-To: <20221108133354.787209461@linuxfoundation.org>
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--U/u9ZVe03qhNmx+7
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 08, 2022 at 02:37:18PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.0.8 release.
> There are 197 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully cross-compiled for arm64 (bcm2711_defconfig, GCC 10.2.0) and
powerpc (ps3_defconfig, GCC 12.2.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--U/u9ZVe03qhNmx+7
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCY2t4TAAKCRD2uYlJVVFO
o8moAQC/UilXsIsTyQVPEJGsVcgzTIEZtXxT4UZmyHgq7s4vIwEA2nvtltoFT4co
tTzwdwIX2gCv8ndbn+gDpqgu9DAdwg4=
=UWC0
-----END PGP SIGNATURE-----

--U/u9ZVe03qhNmx+7--
