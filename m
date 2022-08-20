Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7420559AD15
	for <lists+stable@lfdr.de>; Sat, 20 Aug 2022 12:08:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344890AbiHTKGU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 20 Aug 2022 06:06:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244208AbiHTKGT (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 20 Aug 2022 06:06:19 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8DE75E673;
        Sat, 20 Aug 2022 03:06:16 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id s36-20020a17090a69a700b001faad0a7a34so9631418pjj.4;
        Sat, 20 Aug 2022 03:06:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=e3yg8KzGs/3OJxaTVcYvULiZqNERMkkT6NhqeltbO4s=;
        b=Q3wGzJV/kmnlKxTqU2NVXTDJN2hq5O2zwnwygZ9mD6d1w3nAKLrdGt0OIVBdr5PTW9
         XkskHS3AVxbfF39gvJxL964jLwjkay4CTeaoptX8KsdLqrRsm6v1FS7EAL7EBgibu7bZ
         gj+C44ik1she+bzI5vYreBxL+HX7T09up1T7GmKl+GAZOqJHrub5P950g/TS+dcXuvk2
         nkVUbhXUjTNqQdw8RfgADKtiMhsL8cE42kJBLtLzX7XLPFDKp5iYexA4VcZUjMYqIhfj
         5e8f8Zv9491CIGTYkWoEAIY30TrtwVnjFfVcb3iB53G2XpEy5Kob0oXSIP0aTfm3Cb0B
         Aixg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=e3yg8KzGs/3OJxaTVcYvULiZqNERMkkT6NhqeltbO4s=;
        b=YwYJvqiV1swYWF11FmtVxYb33/eovhrunyc1wpyNcUQaB5NeGB7U1ho2XTenxtl4mF
         bTOps4wjSsMNaHsPJg0NlCdOMbV+oMeqZ5tf7ztfzqDbke6CJVAxULbsbfR5R5ImP0Dl
         vUXOG2Olr1PNqH+vqt/MjNZxcvvmhL3PSe7DByiTuEJ7GQR4b5ECs77RihJ6YhUsM5sd
         t52yqsllIdDYZ7eHaHZcCj9iYmXUZXP0m+ZReHWmUfMnIPYO3zEejmOWzXoxLlcpPM+m
         nKkH5pIJvW+dSMfxtIIP+QqHxExtNBYhc+iDNVzAmMXf9Du6BB3bSNkQ6OupbDELJaug
         vIRw==
X-Gm-Message-State: ACgBeo27qwOFuMqQMxbzFKzoGwLRaKIz+Yi+5vMcbG8kf7BgMm/e82w5
        UPKMsTp1lO57m3oHEqxHiT8=
X-Google-Smtp-Source: AA6agR4cpRCJDLBFP5jgUjo2II4KKvQ2O4CS4HtRKxZ0kEW3gTS1hi/wVrCPa4w48kiTaQgOvpT1Ww==
X-Received: by 2002:a17:90b:1c0b:b0:1f5:7bda:143a with SMTP id oc11-20020a17090b1c0b00b001f57bda143amr18980666pjb.139.1660989976446;
        Sat, 20 Aug 2022 03:06:16 -0700 (PDT)
Received: from debian.me (subs03-180-214-233-14.three.co.id. [180.214.233.14])
        by smtp.gmail.com with ESMTPSA id u10-20020a17090a4bca00b001fa79c1de15sm6525869pjl.24.2022.08.20.03.06.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 20 Aug 2022 03:06:16 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
        id 40C8A103CF8; Sat, 20 Aug 2022 17:06:13 +0700 (WIB)
Date:   Sat, 20 Aug 2022 17:06:13 +0700
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.19 0/7] 5.19.3-rc1 review
Message-ID: <YwCyFakvrtmnDIu6@debian.me>
References: <20220819153711.552247994@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="mD6TucQBK8eFx8nm"
Content-Disposition: inline
In-Reply-To: <20220819153711.552247994@linuxfoundation.org>
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--mD6TucQBK8eFx8nm
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 19, 2022 at 05:39:16PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.19.3 release.
> There are 7 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully cross-compiled for arm64 (bcm2711_defconfig, GCC 10.2.0) and
powerpc (ps3_defconfig, GCC 12.1.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--mD6TucQBK8eFx8nm
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCYwCyFAAKCRD2uYlJVVFO
o4XrAQD/K+PMVFdHGM1iO7uFdX9ORpl+kip5HFdhlt5GIqaGWgD/VOKdVTmQvqIJ
GKomU2yU+itaIvzNSZiy5oqRpHxxjwM=
=3Qax
-----END PGP SIGNATURE-----

--mD6TucQBK8eFx8nm--
