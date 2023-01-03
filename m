Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 852F465BF9F
	for <lists+stable@lfdr.de>; Tue,  3 Jan 2023 13:08:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236950AbjACMHj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Jan 2023 07:07:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237348AbjACMHX (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Jan 2023 07:07:23 -0500
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BCA4DF4E;
        Tue,  3 Jan 2023 04:07:22 -0800 (PST)
Received: by mail-pl1-x62c.google.com with SMTP id jl4so26115452plb.8;
        Tue, 03 Jan 2023 04:07:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=4YTcBq/d5uRH9l2ywJ8UunndbU4kkt0aA/4OyP9/uKU=;
        b=AIybuFvKfbVUmbkQiGcnrCGD74SRbAgrBWTHYTNnLGf9JjO2yzeskkFyuUeaTysVRl
         D6JCtCI8n2Z/IgyOPNcV6ChPu34uWzSggZFeElGa5qjRU42xDI/DXbGw4TGCkFuduOC9
         BiljlTGAhqQZOMfOe2sebwSPQVf4B1QtP70YuSY1vZjeeIP3uvg2JcyvKgYAT9D7cAyg
         3OhaZmYCYNpmx5iccHbn7iQLoW1vicJaT9VhpxilVPTl/8aKGHBmiUhmEZt92FRO14br
         kMF9w/Rjn7IJ2C4z64Q5ZmaXJruZXFnuwsk6Zi/3rnrQHe5jQ4HZJLBjAY/HO2PGsfRU
         8JKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4YTcBq/d5uRH9l2ywJ8UunndbU4kkt0aA/4OyP9/uKU=;
        b=wRGshPItxiH71ukoQacXOzjMat7g4pHr38qKwnbcr8OTkGmpzc5J0ICMJVBUbTEefZ
         zwNSbVBhQetyprBulJ+1lWFBxZmrXwOdHjNsvLHKr1aEIVzrYYtjnG4U66pAKNJGUAH5
         7yEvxpaScRDRR874XPASvRSQPyVQSFvnxMdejxEyE/hcm626CdWzTn9A0uF74bHxys+3
         MuRvdQ4xdIAMjLSswpxBH5FLlN96CDtXHmgdQgm/BAS21+wvAhp+Kx2RL6uyvOov/wur
         w7keYBzgiVZJJ2rC/IptRk95Bp+aCB5nVYIsk8BvJmDMQ9Kv/nvxVaRr11GELEdjAN+a
         KPtA==
X-Gm-Message-State: AFqh2kqAVS52TYY2nJYV1UZAdqdVAYfqh10/cW0c3dIaBRZxQArIW8Xm
        vaLL5mBq10Of/PaFN5kp7Vg=
X-Google-Smtp-Source: AMrXdXtCfhYPKQYgQzigoyMRBT+ufCTEhqmuyXK+M4Q5JHThtVt4HZLhXRtHtAm5KE/fbWgfXnjp1Q==
X-Received: by 2002:a05:6a20:94ca:b0:b2:2719:8f11 with SMTP id ht10-20020a056a2094ca00b000b227198f11mr54171398pzb.55.1672747641896;
        Tue, 03 Jan 2023 04:07:21 -0800 (PST)
Received: from debian.me (subs03-180-214-233-72.three.co.id. [180.214.233.72])
        by smtp.gmail.com with ESMTPSA id y25-20020aa78f39000000b005823b7da05asm5752745pfr.122.2023.01.03.04.07.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Jan 2023 04:07:21 -0800 (PST)
Received: by debian.me (Postfix, from userid 1000)
        id A2C7F10415F; Tue,  3 Jan 2023 19:07:16 +0700 (WIB)
Date:   Tue, 3 Jan 2023 19:07:16 +0700
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.0 00/74] 6.0.17-rc1 review
Message-ID: <Y7QadKdJpOynpf9c@debian.me>
References: <20230102110552.061937047@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="zoa2ik6VUPcuUovB"
Content-Disposition: inline
In-Reply-To: <20230102110552.061937047@linuxfoundation.org>
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--zoa2ik6VUPcuUovB
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 02, 2023 at 12:21:33PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.0.17 release.
> There are 74 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully cross-compiled for arm64 (bcm2711_defconfig, GCC 10.2.0) and
powerpc (ps3_defconfig, GCC 12.2.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--zoa2ik6VUPcuUovB
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEARYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCY7QabwAKCRD2uYlJVVFO
o080AQDUMN3ykJWoLoM07Xhtv3wd4Pk7XHpeezYQXNpqzkS7kwD/euh/tAW+F5DS
rW2FKAg2HWPe75iIocFKTNjVBG7kiwM=
=evB3
-----END PGP SIGNATURE-----

--zoa2ik6VUPcuUovB--
