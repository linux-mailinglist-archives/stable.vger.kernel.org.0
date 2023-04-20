Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ADBF86E8901
	for <lists+stable@lfdr.de>; Thu, 20 Apr 2023 06:12:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232470AbjDTEMm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Apr 2023 00:12:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232403AbjDTEMl (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Apr 2023 00:12:41 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D64101FCD;
        Wed, 19 Apr 2023 21:12:39 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id d2e1a72fcca58-63b60366047so523403b3a.1;
        Wed, 19 Apr 2023 21:12:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681963959; x=1684555959;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=kCOQnQggN0JOswFzdNPgIIbMyyc4QibhYHQ91Y21has=;
        b=Lp7y+Skr6D3DxztdWnM/dDFZYun5ivSMHFcfpeWAZht3ov15BMhC4H4fwJcLmeBXxD
         peeMpYeMLs+3u9PqZV5o3QhNt1jvKr2rJLWq7igUf8bu6uC8UAhagj5CluiPtQprcS84
         znAKEw5JnXQ1FLSQGRdHtk2QMc/3vMWC66OPUJFlCFcHwCXnd62UOA8c1WC9GH9N8cFR
         Sej1wIGUQyQg8zNoYwq6FaiZTI6Kjnc7209aaptcSqk4qlYPJhboGj2KhDA99gMwZUWT
         SLtQ9W8tIxvcPWYRKwJSXz0un4Xc0+DtnaUTsF+Kg2wXDfiwsc5W1N4gg0+DFhJJzLlw
         aYEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681963959; x=1684555959;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kCOQnQggN0JOswFzdNPgIIbMyyc4QibhYHQ91Y21has=;
        b=c3p8rf3wBCl7EJNpDOfWmLSigZ3wnB+dlVbjBT219DPolcvyitAPKS1pUfpvxnDvzm
         BVwKYLpqq+tCy6xmzqnYVLZutaONvZ5Rl8UEJ0gcKBZss6JAi6k2gCuHZEeEDJJ2Wqmp
         RPZF8ods0k3qoErIzsZQbzPh0LKFK0gnxOo5o63+VTXaU+sey9dRruxpdaPiGPK5NymV
         CitFLREDAsc6j82rbW/DaZO+rAmnVc97aK0KrR1lG5akr38rgTMfM/Qfrjt4C0N4NXnc
         11F5Bj+Edcb/ngGcIoPB88nL1NWJbT+71JnoGWGUyiADG266miBAr+qrObQGFEPx2W8B
         xycA==
X-Gm-Message-State: AAQBX9dj2gHDbplAUw/qIRm21eHwdzHTvilmTsDJw9coDznI/5wI7tu3
        RhkzlmnD8VM7C+1lKeEoTjc=
X-Google-Smtp-Source: AKy350aPwhS7nuGapUUqTFmjGK1V7DZIhYWqCr6e+hPvjCq9TyEzamNgOaCSMkcsxgtbHedE2p4itw==
X-Received: by 2002:a05:6a00:1409:b0:626:2ce1:263c with SMTP id l9-20020a056a00140900b006262ce1263cmr6849744pfu.5.1681963959349;
        Wed, 19 Apr 2023 21:12:39 -0700 (PDT)
Received: from debian.me (subs03-180-214-233-9.three.co.id. [180.214.233.9])
        by smtp.gmail.com with ESMTPSA id w35-20020a631623000000b0051f15c575fesm166684pgl.87.2023.04.19.21.12.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Apr 2023 21:12:38 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
        id 849A310685E; Thu, 20 Apr 2023 11:12:35 +0700 (WIB)
Date:   Thu, 20 Apr 2023 11:12:35 +0700
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.15 00/84] 5.15.108-rc4 review
Message-ID: <ZEC7s9nStY5nwAKr@debian.me>
References: <20230419132034.475843587@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="RmCqRgRkBpcHdJPQ"
Content-Disposition: inline
In-Reply-To: <20230419132034.475843587@linuxfoundation.org>
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--RmCqRgRkBpcHdJPQ
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 19, 2023 at 03:22:09PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.108 release.
> There are 84 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully cross-compiled for arm64 (bcm2711_defconfig, GCC 10.2.0) and
powerpc (ps3_defconfig, GCC 12.2.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--RmCqRgRkBpcHdJPQ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZEC7rgAKCRD2uYlJVVFO
o2zQAQCSz+DUgH0E/Wtcs9PCN9esaY0dxEghl/v1Q+mVbXriBAD/e1Wc3H1iKMO6
oaFh6wYRSpEyjzZX/wpnOcOK3D7JIAk=
=NG0U
-----END PGP SIGNATURE-----

--RmCqRgRkBpcHdJPQ--
