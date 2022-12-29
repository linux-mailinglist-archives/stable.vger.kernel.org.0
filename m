Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1DD28658CCC
	for <lists+stable@lfdr.de>; Thu, 29 Dec 2022 13:46:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233183AbiL2Mp7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Dec 2022 07:45:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233381AbiL2Mpr (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Dec 2022 07:45:47 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07F6BD53;
        Thu, 29 Dec 2022 04:45:46 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id fy4so19123270pjb.0;
        Thu, 29 Dec 2022 04:45:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=osTWRMV06dYUlqi8lMnhwHGtInuNPi5JVRNtYA4jG3A=;
        b=Y33pPvEoRu39Nu6og2szplWFB6om0hcXEabNwhK/sG82J3Uj/fzxcXZJagr87wNsHM
         KxBPCFIXif2R0NKDI+2h7OuPp5c2acoN8KGj9dQ5qwrFcyRlSg7CSYNIs4+BA+EaLfJ5
         x6ujfnh0Mw+HDTIJODJc6gGs5n/Mt6p2mn1YNLdVC7pAHVZ6qfVla573DnCC7+/OBeYo
         buPrIr+V0GwYBo4GvWMrDpkSUkYPqMdr9rohB/oeSo2F+Jjcs8nD0M+4hpBcVR1aTNel
         dGXaT1/ORd+NMVK4Kks09Ql3fWbAIbN4HW3VO2lzomH/EnAq0L5iw1FPY/Cx1Kk8M1BP
         +7Hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=osTWRMV06dYUlqi8lMnhwHGtInuNPi5JVRNtYA4jG3A=;
        b=LeHJNTzRpl/dTjqlyDHeGV88IxwfKduNaieZJ0oExYAl4lXqBSKKmEWhoh4J8XE9HP
         9atSdX6Ge3EOB6JqJudqGK0vCkL+elqhEJrHuWKBLd8aXSWpylo6l1AOSqzXCOspJWNB
         W2OI7PCHG5t0EX21H0VVkXltm5AohltRFiyMWUwkp4aGS1hyVTLuOnjE45cGo+dgwZaj
         LQOvvu9FTC0kKhvoaQh04R7JhL3D0I2r3cIViRjWSR6EN/ePczgYqHN7V9PfbHWB2hNN
         5BsmqZRhgG2iCozTcNPRwWxQ+jeSPdGt1yVHtDdfUvWZMeyUqjtAdR/4O6WBCllPlJfd
         m2ow==
X-Gm-Message-State: AFqh2krBNC6967YiOLST96XcK+lt0EmcgGgPQntmbptG4AmfKiroU3mD
        SxBLSpUubORPRo8ih7NaokM=
X-Google-Smtp-Source: AMrXdXsGUQ5il9s3zSuBHye2DBa6vpY7SR6jChnevwXLYGi11JK5wW7jBQ2wVmHp/HMkrIXd8nkNbw==
X-Received: by 2002:a17:902:f254:b0:190:f5be:89cb with SMTP id j20-20020a170902f25400b00190f5be89cbmr24544246plc.20.1672317946311;
        Thu, 29 Dec 2022 04:45:46 -0800 (PST)
Received: from debian.me (subs28-116-206-12-43.three.co.id. [116.206.12.43])
        by smtp.gmail.com with ESMTPSA id t5-20020a170902e84500b001871acf245csm12883306plg.37.2022.12.29.04.45.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Dec 2022 04:45:45 -0800 (PST)
Received: by debian.me (Postfix, from userid 1000)
        id 5D030103CFF; Thu, 29 Dec 2022 19:45:41 +0700 (WIB)
Date:   Thu, 29 Dec 2022 19:45:41 +0700
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.0 0000/1073] 6.0.16-rc1 review
Message-ID: <Y62L9QBnFjRYlNi3@debian.me>
References: <20221228144328.162723588@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="Nz1zGoh/fMbsDTqc"
Content-Disposition: inline
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--Nz1zGoh/fMbsDTqc
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 28, 2022 at 03:26:28PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.0.16 release.
> There are 1073 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully cross-compiled for arm64 (bcm2711_defconfig, GCC 10.2.0) and
powerpc (ps3_defconfig, GCC 12.2.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--Nz1zGoh/fMbsDTqc
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEARYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCY62L7wAKCRD2uYlJVVFO
o7uLAP40YFLsb4h4xYB12590Gu0tj4QzarUnNBQ3kte3rLyI9wEA/qAnONkvAdpd
Eo6yj6skKVE3RiAwpwsK3XhfGM+Mngw=
=G1p5
-----END PGP SIGNATURE-----

--Nz1zGoh/fMbsDTqc--
