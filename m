Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0521E665C2C
	for <lists+stable@lfdr.de>; Wed, 11 Jan 2023 14:11:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230090AbjAKNLN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Jan 2023 08:11:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229837AbjAKNLL (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Jan 2023 08:11:11 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4BD5E39;
        Wed, 11 Jan 2023 05:11:06 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id z1-20020a17090a66c100b00226f05b9595so1992114pjl.0;
        Wed, 11 Jan 2023 05:11:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=3dLTU612GzzdYO0SBcn0mWHahDid/oJBo4lw/MtY7L4=;
        b=qy/BVm1tf8FZ63SJY/b2pakV6rmGnC461YGXlrlrpLu5lpjxURmUGpLrgCuxTWurZA
         Kj+2wrIsUb4z+hY7xfqK2iHkKFhqeRazwUpJbDaXOXy0cDzrsUXFUQrMfOAVBHhztGDG
         sEezuM5DMKR7ACDuLtmVjFnaT6znD68dXG0W2plmd1YzcbD2oc240APFE2TSTxtXI086
         iJ3uMvKMdnyLT86GxLycjTpePCiInoZBPIT8rIyhtDY40lJlpZiuY53FZYxcppSpkACj
         99acRmgyHgh6vBW5oiblkoQPJSsfznr0cwwIa8KHfQwJRqRUAf73T05mnoCYniedYwBH
         BmmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3dLTU612GzzdYO0SBcn0mWHahDid/oJBo4lw/MtY7L4=;
        b=5psE8ojPt00FBlYSFwX3JkK97eSc03S278i2QGuRTWeIFtCOyYREysCbmMiPC7M3vS
         PfBVQvZSBjk4C4pooqv+1ryj/Di/yuvWVTR40+aY8+S7nKNDMhfTzPWtLpAuDRjtMJuu
         XMiWn90GxYppi/O4hHFx+/W/3VejkEApJx0DgW4xZVZ8PXir6Hq5U+TJUVCGBTZSZVqA
         BSsqLgV77GAbpZIlH7pLm91LTaQ9hu3T4BKRulQ+VUiRKQ917SWUZBO1vJbAvhrYfs1p
         +GAQETOJRVYVfJ42rsbxM8DlUzBiV95/KfGR9wkBrxpVPO0HBAU1XOhNWsEpwmmhsGM3
         VSTw==
X-Gm-Message-State: AFqh2kozGT8hrhXPM+emDjFGe0ay8jqj15Jb3EFWadH+64XEgWmHEXUj
        V2yZrN+u2vNIqZbR1OoR6YM=
X-Google-Smtp-Source: AMrXdXsGt9UXnWwjfiM8jnODNUc64br6bVcMhKS3CHQj0aqozwPvvV3TwOUN+irM+vUVRCpvTz5kDQ==
X-Received: by 2002:a17:902:a70c:b0:189:dcc3:e4a1 with SMTP id w12-20020a170902a70c00b00189dcc3e4a1mr72046537plq.9.1673442666181;
        Wed, 11 Jan 2023 05:11:06 -0800 (PST)
Received: from debian.me (subs02-180-214-232-16.three.co.id. [180.214.232.16])
        by smtp.gmail.com with ESMTPSA id 3-20020a170902c10300b001930b189b32sm3339407pli.189.2023.01.11.05.11.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Jan 2023 05:11:05 -0800 (PST)
Received: by debian.me (Postfix, from userid 1000)
        id 23AEC105167; Wed, 11 Jan 2023 20:11:03 +0700 (WIB)
Date:   Wed, 11 Jan 2023 20:11:03 +0700
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.15 000/290] 5.15.87-rc1 review
Message-ID: <Y761ZzJz2J1rsDJ8@debian.me>
References: <20230110180031.620810905@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="9GWqeI4YfsIBwabG"
Content-Disposition: inline
In-Reply-To: <20230110180031.620810905@linuxfoundation.org>
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--9GWqeI4YfsIBwabG
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 10, 2023 at 07:01:32PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.87 release.
> There are 290 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully cross-compiled for arm64 (bcm2711_defconfig, GCC 10.2.0) and
powerpc (ps3_defconfig, GCC 12.2.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--9GWqeI4YfsIBwabG
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEARYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCY761ZgAKCRD2uYlJVVFO
o1ksAQD/CYn3eL/BO0YQtBlBXan/BawrgZjptbsHMBJ1HdXMwQEAsw6CNBKPzld7
yNucgutMlfOpKl+2P4Wdyr8k1SgGEQU=
=1/97
-----END PGP SIGNATURE-----

--9GWqeI4YfsIBwabG--
