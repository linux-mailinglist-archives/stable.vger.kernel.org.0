Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80E57608B46
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 12:08:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229999AbiJVKIt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 06:08:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230036AbiJVKIg (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 06:08:36 -0400
Received: from mail-qv1-xf2b.google.com (mail-qv1-xf2b.google.com [IPv6:2607:f8b0:4864:20::f2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E28FC18709F;
        Sat, 22 Oct 2022 02:25:25 -0700 (PDT)
Received: by mail-qv1-xf2b.google.com with SMTP id i12so3451945qvs.2;
        Sat, 22 Oct 2022 02:25:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=YBywPh8NVLG25pa2iZVL+6YbAYv3SkSxdtxeXc3ICGE=;
        b=HFNIAjQg2u9fd7rjHOSCi52sh4i3pX2zdX59+PNAbpK0DMrPNDxrTE8Wo75ksx5lSa
         k2rv6UKx13HHU4cHZkn+cn3Db9hi3zsGf+jJmT+vG6ge5C1TKP3muOtKFO3JYC40+2Hs
         EI9HOjjtfL16CQdm/NV7EDvQsyDTAdRxuR72gHU77qkbTYHxJjdH8LMyriD6is2ta27y
         VTJi913rCj7nQYOhINGuLDdkwrCyLYPhD8JXy6LarHjnk8VslSL+rGVMzLYq2dDJU49r
         /VwB6Pcp575ap5tCoi48Ot557tMEZr2TN+gOup4K+eqBbnLpm2DYKIsM+mu2JClpWLuQ
         Fasg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YBywPh8NVLG25pa2iZVL+6YbAYv3SkSxdtxeXc3ICGE=;
        b=btwBD6GSBsonovG8vXNDGrUDg0Z3iUDo56BBOo+cpxEI0sfXVRcu/INIVlgAPkhLr9
         0/p6//fkPk0qubMK5vwHfa256/TzC7c+8Mn/HoMY+U7npAhlsaCZHu4XvKaT7gmNxa2o
         ZIjEiMe1NT4wjJnOSDYy5N6J5mfEC7vbj2itLjMDc8fseitTaqorjWedsR0sNNzUszbL
         AhhU4wbF3xAstbcrQNXvctb4+f+03+0MtMR+Pvy2F7H5lM14gEaActCbRTPrcO3L8Qho
         nPIytLpOxKOwYbQWMOb6lSyKFouV+U+fvtntoDO6w3XaDPnX85i6eevvu+76gwzMqRxY
         UK3w==
X-Gm-Message-State: ACrzQf1d0r2aaeYZIJJdLjWcc9AxOkNj/nWOr9oOUniYlQpF4imJ3w+C
        QQmofmyKLItNq0oRzaDiaSZpyNIzjpzE0A==
X-Google-Smtp-Source: AMsMyM5EZucdKobn64AcIzJtSK6MvkG+0ZK7xLozqjrQE0Nbc7Nm4kVlJTwuFbz+4pirMviJw78zAg==
X-Received: by 2002:a62:1a97:0:b0:562:5587:12d6 with SMTP id a145-20020a621a97000000b00562558712d6mr23062930pfa.37.1666428897072;
        Sat, 22 Oct 2022 01:54:57 -0700 (PDT)
Received: from debian.me (subs02-180-214-232-75.three.co.id. [180.214.232.75])
        by smtp.gmail.com with ESMTPSA id o4-20020a634104000000b0046ae818b626sm503468pga.30.2022.10.22.01.54.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 22 Oct 2022 01:54:56 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
        id B3754101140; Sat, 22 Oct 2022 15:54:52 +0700 (WIB)
Date:   Sat, 22 Oct 2022 15:54:52 +0700
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net
Subject: Re: [PATCH 5.19 000/717] 5.19.17-rc1 review
Message-ID: <Y1Ov3KuyKmb9Nizm@debian.me>
References: <20221022072415.034382448@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="da3BH2hT0/m4O+ML"
Content-Disposition: inline
In-Reply-To: <20221022072415.034382448@linuxfoundation.org>
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--da3BH2hT0/m4O+ML
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Oct 22, 2022 at 09:17:59AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.19.17 release.
> There are 717 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20
> Note, this will be the LAST 5.19.y kernel to be released.  Please move
> to the 6.0.y kernel branch at this point in time, as after this is
> released, this branch will be end-of-life.
>=20

Hi Greg, thanks for the patch series, which is out three days after
the -rc1 have been pused. As usual, the template message follows.

Successfully cross-compiled for arm64 (bcm2711_defconfig, GCC 10.2.0) and
powerpc (ps3_defconfig, GCC 12.1.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--da3BH2hT0/m4O+ML
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCY1Ov1AAKCRD2uYlJVVFO
o/QcAQCXaZc/rI6NLvIrCTxPNzb22t+okIGUi1o+Z/b5tfeshQEA82hw2uxHuvUv
PDjOLTGt3cMBXpN2V3J+ajJEB1A88w0=
=oISM
-----END PGP SIGNATURE-----

--da3BH2hT0/m4O+ML--
