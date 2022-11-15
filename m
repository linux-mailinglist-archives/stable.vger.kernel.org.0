Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D9F062910F
	for <lists+stable@lfdr.de>; Tue, 15 Nov 2022 05:03:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230251AbiKOEDa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Nov 2022 23:03:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229967AbiKOED2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Nov 2022 23:03:28 -0500
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B22B4D41;
        Mon, 14 Nov 2022 20:03:26 -0800 (PST)
Received: by mail-pg1-x52c.google.com with SMTP id f3so5737829pgc.2;
        Mon, 14 Nov 2022 20:03:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=GoWm2EdL+TQl8bZ+MoYQChqW5ie4nDjRul4QKUbGfwA=;
        b=dM8I1K+wrRsiJrsPXPY4Qie4yb1A/NRgY+eDJuI2Rj9iESmjGSu0rcCWmk39jLR1cH
         onLUVqyQy1DJHRchqeK3BVqizHDdyfqj0g2E+uV86sjZhZ/O7vV0Uwja7Y/A68V0RCmX
         +MqeC69tiJzRVtidovfVkJjLcl0tPlY2eQ1gJgR05n+V00LeRBCMyh3d6LQgFXoKqEaR
         wup8d/mXrI1b/OZV9VAmhZm7mD0sfyI834qjuzw1cFN7JCtaY423aNVaQGllKJeM5WX4
         zbgeIkH9S8DUFSWJTFqaLzf3LgxSikUNqgUzjRB61Ull5RLW7lkGHEliPU045fhBPrhM
         S+Ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GoWm2EdL+TQl8bZ+MoYQChqW5ie4nDjRul4QKUbGfwA=;
        b=AIAmmmFEWV+vLNaRtii1F5Ztss/nUBmLxvv8+F1XSy4XF4f+82kKX2Y+I3G1xZybS1
         WFWMrx68XJv6tNUbzjyJxpSuxEzN4cs4tVMuWGEaXoRBF8RjlKZIrwHhEuNa1MAVXo01
         0icW38eGth2/zuKak9zmrRE2q7qQI/VYAcbU8iKxdjoiK5K2DA/0ndgQNrGLU7YE8nqb
         UaR20wgH7ljOx8TT7xH82p/ZAdR2u2j0ZLV7AS7X4ZOVJvU4VVTfi2Qq7KWj062orBDt
         SqLLPs4Vczy7TpQhFsKidkEWDbSxJ4/M1Q+mSuEgBUImKHRdXhlZFQ/YHNKTa9fl7/4X
         ixsQ==
X-Gm-Message-State: ANoB5plTOOBjleoOiWDUz4i3stfY4Nx57nz/RAiGpUIlRmBw6/TPHVl7
        DaNiQwTRmPJo/jI/Bvi71tI=
X-Google-Smtp-Source: AA0mqf44Glgbhn2WxXWq01Rmje5hs8FjriQ6qANXEQ1/KNd/RuA/XvXdHou43PoMriDGQsAAfF7IxQ==
X-Received: by 2002:aa7:880d:0:b0:56b:676e:1815 with SMTP id c13-20020aa7880d000000b0056b676e1815mr16648342pfo.66.1668485006204;
        Mon, 14 Nov 2022 20:03:26 -0800 (PST)
Received: from debian.me (subs02-180-214-232-1.three.co.id. [180.214.232.1])
        by smtp.gmail.com with ESMTPSA id p129-20020a622987000000b0056bbebbcafbsm7531886pfp.100.2022.11.14.20.03.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Nov 2022 20:03:25 -0800 (PST)
Received: by debian.me (Postfix, from userid 1000)
        id 99128103ED3; Tue, 15 Nov 2022 11:03:21 +0700 (WIB)
Date:   Tue, 15 Nov 2022 11:03:21 +0700
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.15 000/131] 5.15.79-rc1 review
Message-ID: <Y3MPiUq+LsK+ZKeS@debian.me>
References: <20221114124448.729235104@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="4/gGV5htVI8CkM8Q"
Content-Disposition: inline
In-Reply-To: <20221114124448.729235104@linuxfoundation.org>
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--4/gGV5htVI8CkM8Q
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 14, 2022 at 01:44:29PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.79 release.
> There are 131 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully cross-compiled for arm64 (bcm2711_defconfig, GCC 10.2.0) and
powerpc (ps3_defconfig, GCC 12.2.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--4/gGV5htVI8CkM8Q
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCY3MPgQAKCRD2uYlJVVFO
o/86AQCc7Mh4bY/9P9W4Z8Fsjson44fgR6zGH/jHAj6/bBb8AQD+Jh0i5svghviq
NeqxklNBmlOAvOEsdrU1T4I/ABXvhQs=
=5Cfq
-----END PGP SIGNATURE-----

--4/gGV5htVI8CkM8Q--
