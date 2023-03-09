Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9DB26B1900
	for <lists+stable@lfdr.de>; Thu,  9 Mar 2023 03:05:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229484AbjCICFk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Mar 2023 21:05:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229651AbjCICFj (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Mar 2023 21:05:39 -0500
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7503B99C2A;
        Wed,  8 Mar 2023 18:05:37 -0800 (PST)
Received: by mail-pl1-x62d.google.com with SMTP id u5so483810plq.7;
        Wed, 08 Mar 2023 18:05:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678327537;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=JSZXkOzWUjU6JkgJilE0EIcfpIeJHdOfJ4nnNvrZU68=;
        b=XJPjoCLTEcQrAL+uS+zWq6HfsAci4uyg+eY8/vBMIG+3sbi+IR6C2eBojMmBIBIV2z
         QlkjM14BmsGqGKS9Zl0AkiNWi+IqCcE+igss0acaKUVQls3IXDNR6pmGAgTu9PSFAzvk
         xFFuKR9a7bMEIn+oiBWo5rJp6Qk6oKWwUWRBaoV1UhXOjwZ2g2PYnuZGlH0UXx+bVlYD
         NSRlUy4OmjpuwVh4Y8mYheShU3YmeIVCmDxJdLIBhbLGnnpL/6UpCweJ0Yshi3y0Mruh
         0HiHXHqINKLQFE1Ddy1uNhKWCvkM6snexuoVhycerpvrvi+KYEebJT9IdIcpNPhyGJiP
         IbcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678327537;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JSZXkOzWUjU6JkgJilE0EIcfpIeJHdOfJ4nnNvrZU68=;
        b=j1XVZ61H7F2qNBkWiij35xWODPb1jNE0A9Kn32fEA2mEF+647i5g+AUTa88v8vMnXZ
         VBZTHiNsSFJmNNZjYDLxBuqRsjjQ3KML4gtuch5uaaTyvdVkPzOnT+uf73FwGMw9U2e5
         QwGkFWb23wzGSHgANuC5nSz5n8F8RBECv1SgfTHZGtlk8+sxUN6I4BDMX6sVL1KQFEMV
         b7Zgt/SzTlEIkd3UH1miR3Wjlf+MRSm029cAhCBDSjqBelVUbd+LJBJx/OZgx2VkuQN3
         Ml11D/SgAVuWLV0cwQ/Ix9z5Y8NOwY+GqqMJMrcL8ayzCzP7AibiKHlGFghDsq35DXn8
         K+1w==
X-Gm-Message-State: AO0yUKUIKesyxdanFiQ1HyCOSbbla0VNp/eRz2r+93SBeb0ulMn8f0jk
        TbsYCG5xytxk7ep661Zg0IE=
X-Google-Smtp-Source: AK7set9KMrycEaQIMCOptQv4UT7+AbalKdsIeTLKSqkyR3TqZxUx1Nbt0u02LxXIQ9uuCkmBCUeTHw==
X-Received: by 2002:a17:902:ea10:b0:19e:f86c:255a with SMTP id s16-20020a170902ea1000b0019ef86c255amr4673190plg.7.1678327536757;
        Wed, 08 Mar 2023 18:05:36 -0800 (PST)
Received: from debian.me (subs02-180-214-232-87.three.co.id. [180.214.232.87])
        by smtp.gmail.com with ESMTPSA id t3-20020a170902d20300b0019adbef6a63sm10402008ply.235.2023.03.08.18.05.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Mar 2023 18:05:36 -0800 (PST)
Received: by debian.me (Postfix, from userid 1000)
        id 061A61065B8; Thu,  9 Mar 2023 09:05:31 +0700 (WIB)
Date:   Thu, 9 Mar 2023 09:05:31 +0700
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.15 000/570] 5.15.99-rc2 review
Message-ID: <ZAk+6wv5eexfOK2y@debian.me>
References: <20230308091759.112425121@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="AK/Nxp/4nin2VaLk"
Content-Disposition: inline
In-Reply-To: <20230308091759.112425121@linuxfoundation.org>
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--AK/Nxp/4nin2VaLk
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 08, 2023 at 10:29:40AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.99 release.
> There are 570 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully cross-compiled for arm64 (bcm2711_defconfig, GCC 10.2.0) and
powerpc (ps3_defconfig, GCC 12.2.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--AK/Nxp/4nin2VaLk
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZAk+5QAKCRD2uYlJVVFO
o/RGAP9plKGEYwy7w+0FDYLJsdZE7lqs3D/R7+/iF52p7Bu9+AEA1rwLzsstnJMd
fwj0jI9QzV9R3VtD9DdVSNIHuFAfRA0=
=rmHJ
-----END PGP SIGNATURE-----

--AK/Nxp/4nin2VaLk--
