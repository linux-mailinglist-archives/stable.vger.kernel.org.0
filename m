Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1DE285FBF27
	for <lists+stable@lfdr.de>; Wed, 12 Oct 2022 04:25:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229490AbiJLCZU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Oct 2022 22:25:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229489AbiJLCZT (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Oct 2022 22:25:19 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAC981F637;
        Tue, 11 Oct 2022 19:25:18 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id l6so4827830pgu.7;
        Tue, 11 Oct 2022 19:25:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=uzXUr86xE4km0BgRR+3voMnd4q8DTkC3L+0/mG0XWQ4=;
        b=f19i4vu6Sol7+UI8lcg0oesSRnfJYREiHFScmYRgIQkm4IkHeiWwSCcOgUJ00crtlf
         qaEaPnH+4vWXbu7GFPnhc6ZvsUQcpLRcr05cOFrKUDQXYHLmzUrIeaOgh0zFD6xgi2Rs
         nR/7Zsbzoq7OtRw8X+tisQf3vvkENw49w7Bl8moCcocJgk30S0beqdUKai/mgmjL54UW
         roZB5Dbyym3A+T143NvyTXg1p5gGYiqL2C/mDcZlyCgRUIVu82aM1nGV9uSUfIMbSmK1
         4yed3p3ovUo1Kim0w8VkfPiJSh+NcYjsbZnYjYPZvMYTmXNQEPE9Ndnc4s5j0zZZW4g+
         DERA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uzXUr86xE4km0BgRR+3voMnd4q8DTkC3L+0/mG0XWQ4=;
        b=yhJowUKKrxlR7Ab00fm7fO9g3iktf1m7ATOxv/X9Cs3ndSlDk7TluRjId6MQroWk8K
         W8NKApVhQcoOXYzEFUGtvw+N0oNEOZVbSfP/3RSgd2Rxr2MJ6Kc7opC2zYz3wK0/ekxT
         bMCkyRXVUIi/AKjvbvQE7TlgKsCjaogooc73hMfQ3zRGonLDBpPfq40co31Ugeuej3Sb
         yPnLODIPfDGQWEG4+rZOH77zUC+rzXL9c4i1OF6cd+HtCQ1TjxSo7WZgisrRKalMXjld
         WfgJl9oY1SJ4GsK1qkGWg8JE8nKiCd74Yusl7FPLeXzQwWAFxO5qzlhA8bLAYKvMZW/2
         LoGQ==
X-Gm-Message-State: ACrzQf1YhWq4Nv3k/mVVBTrXQjP1MKH3+iln/PoYJDyUY1TuNVV6isyX
        NhFJi6FD5veoiyUqhP2MLhM=
X-Google-Smtp-Source: AMsMyM7POCaooIVpCJwJZ6FrJ8ci7PSXnWl+0ZCvrlrMT2d6gCYV4RS0+AI0kkvfcRm+hi43aRrLrg==
X-Received: by 2002:a63:6d45:0:b0:461:25fe:e7c5 with SMTP id i66-20020a636d45000000b0046125fee7c5mr15011289pgc.395.1665541518341;
        Tue, 11 Oct 2022 19:25:18 -0700 (PDT)
Received: from debian.me (subs03-180-214-233-91.three.co.id. [180.214.233.91])
        by smtp.gmail.com with ESMTPSA id n7-20020a170902d2c700b0017f36638010sm4852342plc.276.2022.10.11.19.25.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Oct 2022 19:25:17 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
        id E92EA104118; Wed, 12 Oct 2022 09:25:14 +0700 (WIB)
Date:   Wed, 12 Oct 2022 09:25:14 +0700
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net
Subject: Re: [PATCH 5.15 00/35] 5.15.73-rc2 review
Message-ID: <Y0YlihCqe+mfSKPR@debian.me>
References: <20221010191226.167997210@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="v3msG2W5Qcgx8eLw"
Content-Disposition: inline
In-Reply-To: <20221010191226.167997210@linuxfoundation.org>
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--v3msG2W5Qcgx8eLw
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 10, 2022 at 09:12:52PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.73 release.
> There are 35 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully cross-compiled for arm64 (bcm2711_defconfig, GCC 10.2.0) and
powerpc (ps3_defconfig, GCC 12.1.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--v3msG2W5Qcgx8eLw
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCY0YligAKCRD2uYlJVVFO
oxzqAQD8sABgWBzCmvWCdOJ+ua7P4hwWmnkuNQeezIb+bA9jcQD+KnIaCBanAGQi
M7BY9M8fllEz31TnHR+0Zyct29XrRQc=
=76wp
-----END PGP SIGNATURE-----

--v3msG2W5Qcgx8eLw--
