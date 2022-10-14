Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C8115FE7E4
	for <lists+stable@lfdr.de>; Fri, 14 Oct 2022 06:14:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229820AbiJNEOr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Oct 2022 00:14:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229748AbiJNEOq (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Oct 2022 00:14:46 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE924B850;
        Thu, 13 Oct 2022 21:14:43 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id d7-20020a17090a2a4700b0020d268b1f02so6787005pjg.1;
        Thu, 13 Oct 2022 21:14:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=cv/7XzR9omBEXNn+tqEddtqBvNt7j9qjSpWwWm5+1DQ=;
        b=c/0aG5w1PIEFnk5Ke+ScmcsJySK/PBw6ZqjFS8OedzAVtpe/UQ4YLwbC//Mu1kFrze
         P5i47pcY8MY1NU5k3cATd3EMIJkM7P1gFJqslma9GrNSnBOSoW19Z8VNe3BFG3vH4tQI
         r6JiZKc4iRAq/RAPO/9pMZTNwsbJGE34fqOAKn8092/H0lBskCuOBZzJ4h1uezmRQLQ7
         qyq+M7ogv1tFsbiX/Gs8kaJ3PiEqVcsg3PnaniGjb97E642JyIe/WiKtDk6MzVi081M8
         WxQtQRRw3+AYrjIhs06qmSE9vdhZxxShWGazntU9ehRHQX55pLzfH/WDB0cv50mAv2UI
         rkTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cv/7XzR9omBEXNn+tqEddtqBvNt7j9qjSpWwWm5+1DQ=;
        b=GpjXu98cSCdWeuDno9ULjkVUqwhu5Qadn/1TGCFhhMieeoMUrzKqnkequhA484qw6i
         8c+KQQGbhjfyCCpvaPOW7duWCoKaB54i4tmKMZTT7fUxmWnpHtDM5xGybb70k2e4N8OM
         NItKjK9tkiclTE/7xunKBzT0QZ2jXrFsqWu27EW/k6t6g2rJuqwfMvz0+g9kDuwc2u6D
         gJ9iW6nSPP0AqFWPXPqragT13Yi493Wo0yTthyf/3PvP/fi7czFIiQRxVcs3KWpXpONA
         +xhFK75J31o/QvG5JAxntSMDDMhXai7noQVoo7JcQOvQWwPHPC3pqhhOubcLwkYVGwo8
         0eDw==
X-Gm-Message-State: ACrzQf3WvF56NwvWmh1Pdd3GFfnR6o9LJSeo5zy1lra2cD+n/AE8Fldf
        W81fQ9eus6ik05AN0wwGzj8=
X-Google-Smtp-Source: AMsMyM6hX3cH6HzMk40SPHVvXChzqtlxm6oJt67cheTqR3e0plFNnRDCktLeFDpKg0/mbnNHpohtHA==
X-Received: by 2002:a17:90b:4c86:b0:20d:402d:6155 with SMTP id my6-20020a17090b4c8600b0020d402d6155mr14585106pjb.229.1665720883443;
        Thu, 13 Oct 2022 21:14:43 -0700 (PDT)
Received: from debian.me (subs03-180-214-233-74.three.co.id. [180.214.233.74])
        by smtp.gmail.com with ESMTPSA id l11-20020a170903120b00b0017f74cab9eesm614938plh.128.2022.10.13.21.14.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Oct 2022 21:14:42 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
        id 219F3103744; Fri, 14 Oct 2022 11:14:38 +0700 (WIB)
Date:   Fri, 14 Oct 2022 11:14:38 +0700
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net
Subject: Re: [PATCH 5.15 00/27] 5.15.74-rc1 review
Message-ID: <Y0jiLqf+cOx6FmVR@debian.me>
References: <20221013175143.518476113@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="Geluv9GX/vn4iM9o"
Content-Disposition: inline
In-Reply-To: <20221013175143.518476113@linuxfoundation.org>
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--Geluv9GX/vn4iM9o
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 13, 2022 at 07:52:29PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.74 release.
> There are 27 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully cross-compiled for arm64 (bcm2711_defconfig, GCC 10.2.0) and
powerpc (ps3_defconfig, GCC 12.1.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--Geluv9GX/vn4iM9o
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCY0jiJwAKCRD2uYlJVVFO
o8u5AQDWTq3a29qgr0JTYTDU1iCMqYNtbR6RstB3x/R5+sP/4AEAhuctUd6tqo+n
r70kYvhT7wTudiQ1GR3IY3IuN3eGBg0=
=AcRp
-----END PGP SIGNATURE-----

--Geluv9GX/vn4iM9o--
