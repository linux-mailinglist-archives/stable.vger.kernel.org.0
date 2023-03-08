Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 059D86AFDCD
	for <lists+stable@lfdr.de>; Wed,  8 Mar 2023 05:20:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229789AbjCHEUZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 23:20:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229544AbjCHEUW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 23:20:22 -0500
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17FCB9E645;
        Tue,  7 Mar 2023 20:20:22 -0800 (PST)
Received: by mail-pg1-x530.google.com with SMTP id bn17so8906720pgb.10;
        Tue, 07 Mar 2023 20:20:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678249221;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Rnkjn4DRhnRW1sqD+uqYuOcNZEzPfc0ZfZT3Ap1tve8=;
        b=JTUKI9GzKGdU2vqgieL04tyhdzhJpItt1SnEO5D0vB476SThNsAX1UfcBtyb1gY3bK
         UaUORef+lozKR6JtHvbLwElN+TGTHIPxvjIW11qTIFoz8Q7JxoAG6gERXKpI8JbStz3C
         volQKrrQyeMK8b5Ehmnx/wuh/wtcNQY/fvzQPt4s/N/ZBHEDafuUGd3e7Bx0n1QsQp03
         8ZipfFcpEDIl29ncU5u3xdC5xV/VO1Z7sBBVls1AH62TM0fljXN9ktzIFr83pPR6bcGI
         UytZ/E2L6JGZ4X/K2mSo/AVVeCQO+VeMrdPLONROPKDpoJ2zIiihEadmu7HU2jX5aMmh
         Q14g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678249221;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Rnkjn4DRhnRW1sqD+uqYuOcNZEzPfc0ZfZT3Ap1tve8=;
        b=zylOWstckC7CgLCciTCNq6HmVqvHorfYMhTI/60SZjWxgvvUPdgDI+8nWIgRq4fmiF
         2xroHnqDa+UGOcbNqYl0QIUwLLhRkk8HdmS2EeJi/dfQLbhB8v0hjrxu2ZYC57wrCVju
         v0VL+VVQE2X6fGDVIMYGwJFY8BJS9IhXxEKHg2eqtP75nNWJYrL03H1/ox9UQ3s+oTas
         C7MKZ4qENGKx5dvShyyUDNVtbuIIOLFY188OW3jvgngnmTpgefnnAj47+hMYSdqbgfbm
         fRPIcqil98DORqOUq1uIWkN7ao34FhoHASooEYTQ3dg68PN+nV3wdEiIFS3U3cG09pyd
         9jqQ==
X-Gm-Message-State: AO0yUKUiqcl/wPhiH9gWw6YEn27Bhp5shaSDT4k7lXDLUGD7gmbswffb
        Q+VpQTI2YY6SlUro6H9ExGA=
X-Google-Smtp-Source: AK7set/xQnzesADq/Y3cuIKCqmm2rBd9Sol2Rl1vb3XaTJEh+0t3JSzqhoiCfDNX8cbQkZwFt4y3gg==
X-Received: by 2002:a05:6a00:796:b0:5a8:e3d5:d7d4 with SMTP id g22-20020a056a00079600b005a8e3d5d7d4mr18761104pfu.7.1678249221505;
        Tue, 07 Mar 2023 20:20:21 -0800 (PST)
Received: from debian.me (subs02-180-214-232-18.three.co.id. [180.214.232.18])
        by smtp.gmail.com with ESMTPSA id j7-20020a62e907000000b005aa60d8545esm8669245pfh.61.2023.03.07.20.20.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Mar 2023 20:20:20 -0800 (PST)
Received: by debian.me (Postfix, from userid 1000)
        id 7482F1065C4; Wed,  8 Mar 2023 11:20:18 +0700 (WIB)
Date:   Wed, 8 Mar 2023 11:20:18 +0700
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.1 000/885] 6.1.16-rc1 review
Message-ID: <ZAgNArfjHFbigSZR@debian.me>
References: <20230307170001.594919529@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="PVn/FJYx3o++izsw"
Content-Disposition: inline
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--PVn/FJYx3o++izsw
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 07, 2023 at 05:48:54PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.16 release.
> There are 885 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully cross-compiled for arm64 (bcm2711_defconfig, GCC 10.2.0) and
powerpc (ps3_defconfig, GCC 12.2.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--PVn/FJYx3o++izsw
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZAgNAgAKCRD2uYlJVVFO
ozJeAQCQ8qnWnsmEVPqgV/Pe4uCnAAGVaiZu/N1T1uM4L43MSwD6Aimb7LLSdFLs
wkF2xJW9XPwPpB9gW7R6nafVWfpskQw=
=fXZE
-----END PGP SIGNATURE-----

--PVn/FJYx3o++izsw--
