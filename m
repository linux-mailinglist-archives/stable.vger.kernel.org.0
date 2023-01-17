Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07C3866D946
	for <lists+stable@lfdr.de>; Tue, 17 Jan 2023 10:06:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236417AbjAQJGQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Jan 2023 04:06:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236428AbjAQJFr (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 Jan 2023 04:05:47 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49C4030B22;
        Tue, 17 Jan 2023 01:01:15 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id cx21-20020a17090afd9500b00228f2ecc6dbso8509776pjb.0;
        Tue, 17 Jan 2023 01:01:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Sysl900IrcFFi2TfHQ/z8o1gLJYPUzPi/XTOajMFP5s=;
        b=VC+BeuxFB4UP6hq2dtPPySdo9s8b6MfVvuTe5T66eeoWQAufPzSPGav4Id7ILnxRPv
         KfEYJc4mitHJzbPGt0CXLI9/JEIezgzttg2eLQ7jG5ELjlpgtbNwStOnbfWr7RDceuXy
         KbabKKGa3xdFgEuMdZuW3JBzxp1SHBVzqB1AbAql2/EICTcUeOP4IRJlO75D7KPYI+qU
         ByPqJMJ3G3geATRvnSsWmkq1/YE1J8TP2SFAJFzHS3xXy9fFOAqu77cUqo95euaFn3Ic
         c5SSwCVgC6i13tGolq9OmT5wUzngBVjxKOrfUzjwRsXwjarf+bdSQGdPwVIKI5lX8z1E
         NnBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Sysl900IrcFFi2TfHQ/z8o1gLJYPUzPi/XTOajMFP5s=;
        b=fldfT2T1vPPUfML+MYFE6ljsiUVZ8rzUaqvVAiBi23rcASu4qy5tmEwbikk/cGP3A8
         NT284R2ZfM/jskjugnLYVp+wlQGOM+AC/fMHpb0mk1pF3V9sM1VJmTP8TRLsXTO7vogT
         WGPGlV5NaaM9kRlWH1SLzNHEG03cY0MJnnQ1jDgjHJ64TivNMjiXu+/n5p01sv3SM5Fn
         HQJcSsDqLi8q9iXrPc3KwRNlp+37usbv5r+mueqJrfuTr8OT85zl0EfsVffDHHz+2lLt
         66u4Kag1z9EPnnIPSH2LP9ierRYE6UyMnnZGNzM1FbI70hxuvdH4T+7HgN5LI4LQJ5HU
         6Zfg==
X-Gm-Message-State: AFqh2kp7fp1zcBe1gl4TEY1Qhp2KbYF4AoOnBz8UsYoV3amz5idmb/6Z
        Zs9NzGBaLZi9dJ+HxugVsn8=
X-Google-Smtp-Source: AMrXdXvD7Q9KHQmbhNc92/yKRfnw3jtsMfMoYpOwomWGEtMqWH2p/kSispHYpfqkki+y6DioDEMuSQ==
X-Received: by 2002:a17:902:f70e:b0:194:6c1b:60b9 with SMTP id h14-20020a170902f70e00b001946c1b60b9mr3143394plo.25.1673946074705;
        Tue, 17 Jan 2023 01:01:14 -0800 (PST)
Received: from debian.me (subs03-180-214-233-28.three.co.id. [180.214.233.28])
        by smtp.gmail.com with ESMTPSA id n13-20020a170903110d00b001925ec4664esm20616309plh.172.2023.01.17.01.01.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Jan 2023 01:01:13 -0800 (PST)
Received: by debian.me (Postfix, from userid 1000)
        id B3210104432; Tue, 17 Jan 2023 16:01:10 +0700 (WIB)
Date:   Tue, 17 Jan 2023 16:01:10 +0700
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.1 000/183] 6.1.7-rc1 review
Message-ID: <Y8Zj1kVH1ZsTT9VE@debian.me>
References: <20230116154803.321528435@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="AB3Wrsy8pv5BIByR"
Content-Disposition: inline
In-Reply-To: <20230116154803.321528435@linuxfoundation.org>
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--AB3Wrsy8pv5BIByR
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 16, 2023 at 04:48:43PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.7 release.
> There are 183 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20
=20
Successfully cross-compiled for arm64 (bcm2711_defconfig, GCC 10.2.0) and
powerpc (ps3_defconfig, GCC 12.2.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--AB3Wrsy8pv5BIByR
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEARYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCY8Zj0QAKCRD2uYlJVVFO
o44ZAP4wptgSFff335a9du3tsByRgSiFcdRi9hNkV8FnjsdHmAD/SnmDT8narLfp
8BlLd7gsVD1+dEtnuqhlLW8gR3D74gc=
=pgAb
-----END PGP SIGNATURE-----

--AB3Wrsy8pv5BIByR--
