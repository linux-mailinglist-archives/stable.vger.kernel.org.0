Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECC876D8D9C
	for <lists+stable@lfdr.de>; Thu,  6 Apr 2023 04:45:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234951AbjDFCpQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Apr 2023 22:45:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234487AbjDFCpD (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Apr 2023 22:45:03 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 613776187;
        Wed,  5 Apr 2023 19:45:02 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id o6-20020a17090a9f8600b0023f32869993so41534575pjp.1;
        Wed, 05 Apr 2023 19:45:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680749102;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=FP6qMRZnufmIVukqRAxAvxpbHirbfFAZ79709yINii4=;
        b=YYdY5i2MmC05Jqq6gkro5Q2vQdryROCdKKpYi4iuZnFz8lalWYbms90KjtE57Rowbz
         BFlo5WTqQhDaZ3sOTPgWsmnYkidYAEgkQAKiik2jrcE7mZ8h1IrLnm8W1teSemB9FRHn
         q07XZu4Cq1DsR70RJUTBf4Hz3VaaJB1HHPWFOtnGdUU4E/6JAhbepGu72q0C9WUGRNLN
         4Lgex3zeqpoqEF5uyW9prY1qKt8EOJAldqGzdvAgn6aSBlELsuPEUWqqSNhPxHv9e1bF
         CCnrk0U26r/+YJvK7plO5lDBqpI2uNgLw2076O0Lay7bL/9ebO0SmwbIgY97LVIpfKes
         G0Og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680749102;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FP6qMRZnufmIVukqRAxAvxpbHirbfFAZ79709yINii4=;
        b=Z1FrX2SXyIkDoBDs2bUaqFANCYLKVW3fIbqxRfxx6PDi9BQ2B394PNFbkLU5Qe78eQ
         0elEztWRE7ZhoVYcYrsceLh9tG67gWSfUCL7YV108J0M+1E0PZSeQ6G2w7pRTWCPMDEH
         9RE14xAjBalQwTy1/7sAzP/QLhag99laHgPAGYHN4DDKMddQVVziRfwdgwQLm52+KYS3
         uzJoM6cHijvMc7iXA8vhZ6wVRGwtVh7IsP11VLTT48oTp4/vDTmBuKxP/bhRn+QDsaWx
         Br/b2dMjRoh3qwDW4+ed6PMkw37DoIEhhx6ZE9yGTkwCYgdDPyMAQFLh+sBaSrBbchDn
         VYnw==
X-Gm-Message-State: AAQBX9eLSrYsawW4ePRPhfv/TZPMuSis4ShHvYz0QFr+j7QM6gYjjLgB
        EiS2l/zAE/AGkF4UackudVY=
X-Google-Smtp-Source: AKy350b6pegyGsn/DaQIkwBz0qaEliqFkuQOAVOTtdC3LWZNIs+12N0ZtIFdAKcz+SZrub+qT5J4Mg==
X-Received: by 2002:a17:902:f68f:b0:19c:be0c:738 with SMTP id l15-20020a170902f68f00b0019cbe0c0738mr9820147plg.59.1680749101537;
        Wed, 05 Apr 2023 19:45:01 -0700 (PDT)
Received: from debian.me (subs02-180-214-232-14.three.co.id. [180.214.232.14])
        by smtp.gmail.com with ESMTPSA id jh19-20020a170903329300b00199193e5ea1sm229271plb.61.2023.04.05.19.45.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Apr 2023 19:45:01 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
        id C1EA91067E5; Thu,  6 Apr 2023 09:44:58 +0700 (WIB)
Date:   Thu, 6 Apr 2023 09:44:58 +0700
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.2 000/185] 6.2.10-rc2 review
Message-ID: <ZC4yKlxhiQusPE6d@debian.me>
References: <20230405100309.298748790@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="TEy8fNr0EH5xbQEl"
Content-Disposition: inline
In-Reply-To: <20230405100309.298748790@linuxfoundation.org>
X-Spam-Status: No, score=1.3 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--TEy8fNr0EH5xbQEl
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 05, 2023 at 12:03:46PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.2.10 release.
> There are 185 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully cross-compiled for arm64 (bcm2711_defconfig, GCC 10.2.0) and
powerpc (ps3_defconfig, GCC 12.2.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--TEy8fNr0EH5xbQEl
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZC4yKgAKCRD2uYlJVVFO
o4ILAQCkZjtkzLEse2RoKR1YejTtFx5mdZZd7gSXUhDyjXPFDgD+LyfT7K5ZYkLV
s0PZkX+FpBiGO8YayWwMprZTUOGr5AI=
=VwPF
-----END PGP SIGNATURE-----

--TEy8fNr0EH5xbQEl--
