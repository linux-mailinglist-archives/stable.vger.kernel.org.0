Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CB6767748E
	for <lists+stable@lfdr.de>; Mon, 23 Jan 2023 05:07:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230137AbjAWEHU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Jan 2023 23:07:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229455AbjAWEHT (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Jan 2023 23:07:19 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C573918B16;
        Sun, 22 Jan 2023 20:07:18 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id lp10so7099245pjb.4;
        Sun, 22 Jan 2023 20:07:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=k8xywsS+eg2CC8w8NCTeeilE0iYUibYUDt/SRX3plv8=;
        b=CqZ5PcNsFYfskx+qh+UHmYSxgv+V9rc4FNXeaGDkSbwFEgLHpyk3Oj8dYnQhZSLcmg
         aICPnawfa0rB8DR47WtZdq+1xWlc4EifO1aowr6S+vBQL1WiTCj0P5h/S0zCRWrtn47m
         p/SX13SM6MPKtZdCboX9RwwXLE/LDWJBzDYBhj/2o+dwJBkLSS2Kz/LJiAGn1yFPSAhU
         A+Ycm3HTTWv52kS30z8luf7U/P3xevPcWHCoqHFjVtp+ZXirH4Rl/zVHnVaIAIzKnypM
         470Zd9ZUsx1BPknxNP86CIspLAm/uHCXNAdEBCwNJSNwGp0rhTeVRN7SGjNwLT/nPbnu
         PuOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=k8xywsS+eg2CC8w8NCTeeilE0iYUibYUDt/SRX3plv8=;
        b=3PNXHAKM0oJt8hByY23hfKI+VfMTCjY/WQuzkotfvzNSnwmd0f3D6CvMhpZPkGUuYa
         MM6PTH6GwrVqNYZMWAccchBToHD5Ct1GCr+iIW4DfolDYQ0MeQiTI3EeSAP3UyNloyDn
         N59KVnF/YReR3FkKXqklvBwqrX8dohjAIKzycIF5cTK0d8WXDTE9BnlPXloyl9tviacO
         rMIRZktFE6jXQrL737SzXmv6rYJ6BuX7+0olZ+4LPaZ9sXaBYkU7+3vJXPeBrQphzBzO
         i/pkXLJIFbZ2HAL5L0KWrR+R+2YRXUG/pjD9FNiQLLTbbaKf+OyMiMFli6HMIzQWtfdT
         N1oQ==
X-Gm-Message-State: AFqh2kolC24mKpDGZupXai104Lr+a9GZJyezlTTvXuW+2cZwPRFSvck6
        lj9EY7bFFn4P1CZuZDWBG8d8VwLUgjpv0FSf
X-Google-Smtp-Source: AMrXdXsMa3OpdkJGGDGBrvwjgpwVsNwtYXcXI9FV343NkCx7shiCd//ZicGYZC293i00jL5mMB7Wzw==
X-Received: by 2002:a05:6a21:170f:b0:af:9dda:b033 with SMTP id nv15-20020a056a21170f00b000af9ddab033mr24229003pzb.37.1674446838266;
        Sun, 22 Jan 2023 20:07:18 -0800 (PST)
Received: from debian.me (subs03-180-214-233-76.three.co.id. [180.214.233.76])
        by smtp.gmail.com with ESMTPSA id s1-20020a63f041000000b004784cdc196dsm26175346pgj.24.2023.01.22.20.07.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Jan 2023 20:07:17 -0800 (PST)
Received: by debian.me (Postfix, from userid 1000)
        id B02AB104299; Mon, 23 Jan 2023 11:07:13 +0700 (WIB)
Date:   Mon, 23 Jan 2023 11:07:13 +0700
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.15 000/117] 5.15.90-rc1 review
Message-ID: <Y84H8WbMg8gg02U8@debian.me>
References: <20230122150232.736358800@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="L4E1Xd5t6VzTwN26"
Content-Disposition: inline
In-Reply-To: <20230122150232.736358800@linuxfoundation.org>
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--L4E1Xd5t6VzTwN26
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Jan 22, 2023 at 04:03:10PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.90 release.
> There are 117 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully cross-compiled for arm64 (bcm2711_defconfig, GCC 10.2.0) and
powerpc (ps3_defconfig, GCC 12.2.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>
=20

--=20
An old man doll... just what I always wanted! - Clara

--L4E1Xd5t6VzTwN26
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEARYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCY84H7QAKCRD2uYlJVVFO
o75EAQD+9vyYbqVa5gboq5KZOI04RVCWaLprw6Xs6gMhwUFGiAEArLBgQHYJDmn3
WbZX78uhMAhO6NaT/TrvPSWiu17kUQk=
=Wo+s
-----END PGP SIGNATURE-----

--L4E1Xd5t6VzTwN26--
