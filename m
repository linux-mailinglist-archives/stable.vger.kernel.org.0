Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2DE1F5FE9E4
	for <lists+stable@lfdr.de>; Fri, 14 Oct 2022 09:56:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229698AbiJNH4q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Oct 2022 03:56:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229665AbiJNH4q (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Oct 2022 03:56:46 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43E3512FF9A;
        Fri, 14 Oct 2022 00:56:45 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id bh13so3669958pgb.4;
        Fri, 14 Oct 2022 00:56:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=vQlBcw+mgUkkM7Cx3bvkmPoG5Mo4L5lV/iKjdWvuINA=;
        b=GzL2kJOQFg+KuUHz3Np8FfalV7/8ofjAICt96Omlk5zVAIeTREONelF9RvX4QnOV/U
         Htj9StJy8ty+Q1GKrfaiKXZ0Hciwzc2cgjHITZ+HZozTCF1K301boGrnaOoQk36VLFSo
         yjZ6MldfwNzIMZWmH3K5kNM0co9jAv/zlcgzEUFILktIdGD8128r8XYbpp8EDAAk0jlC
         f/GbJqa/htHwt8E7GXxYKATfj7+Ttomv3oXzC6AUghUcjGiQBKXXd06m71Jq1rxn/BYh
         9gWBXWF09aZ74CpRxoXjcskHGTseXbcyUFHBOyUXsn7AZD09xHUyTLaqmVjAMm+TbU35
         HoZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vQlBcw+mgUkkM7Cx3bvkmPoG5Mo4L5lV/iKjdWvuINA=;
        b=YgNph6d4o6CSLRqETVOhpRrDw7/axNd2BXeBlTylnYLig/gYtqlGRxVkXT+9oH6Abj
         cVTuMit5VKflPHuc013uokig9Ty+XGLRP7gnCGBiSjAo6IBT9ev2pSxfV/w3Ba/ULLRx
         X6+ZD2qn14rsSKx/qmEVkGfYPh9O+y/XvSCNC5FrxO4mvpF6XNVduoZbk/ktKDWxlkNX
         8lwOBM8QamO11SaZ1SfYFooN3zdq4znjlIjqZt3sHU1dF6VDhJ1sTZ7QZGo2SXx5NGmQ
         Hn0C2QlzI2/Q7XJuxwI7AAoNYzheMS3D7nlYeDGyQAbkNC5cD1Y6UqY/aFfXd8mx3nv4
         B1KA==
X-Gm-Message-State: ACrzQf37/8/URbu2x9IfkrUlUqnET1CczXrDNqkOK73DLJra3+QYRKkI
        PujF2iVGNS0dTp6hEVHunjgpFSHWTmQUWA==
X-Google-Smtp-Source: AMsMyM6nLeOhUGHWtGfS0Vqs7M/NxHaMVD9z6DmujwAafkguSwy6FFbrojjKV4qZsL4yENg9BYuBsg==
X-Received: by 2002:a05:6a00:194e:b0:566:5da:ea67 with SMTP id s14-20020a056a00194e00b0056605daea67mr4032054pfk.77.1665734204814;
        Fri, 14 Oct 2022 00:56:44 -0700 (PDT)
Received: from debian.me (subs02-180-214-232-79.three.co.id. [180.214.232.79])
        by smtp.gmail.com with ESMTPSA id c2-20020a17090ad90200b0020b092534fbsm912741pjv.40.2022.10.14.00.56.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Oct 2022 00:56:44 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
        id 35F8B103FEC; Fri, 14 Oct 2022 14:56:41 +0700 (WIB)
Date:   Fri, 14 Oct 2022 14:56:40 +0700
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net
Subject: Re: [PATCH 5.19 00/33] 5.19.16-rc1 review
Message-ID: <Y0kWOD9G+FiIEfmA@debian.me>
References: <20221013175145.236739253@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="4xw+PCQM2wNdCFnP"
Content-Disposition: inline
In-Reply-To: <20221013175145.236739253@linuxfoundation.org>
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--4xw+PCQM2wNdCFnP
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 13, 2022 at 07:52:32PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.19.16 release.
> There are 33 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully cross-compiled for arm64 (bcm2711_defconfig, GCC 10.2.0) and
powerpc (ps3_defconfig, GCC 12.1.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--4xw+PCQM2wNdCFnP
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCY0kWMwAKCRD2uYlJVVFO
o8cKAP4jV8922RjR2IWndnCXCKLinDX5SpN1JkcaZ19A5ULRowD9GTbmR/8kkd1M
laH9Epwe1+2e8+3bG2WPFEoSh/YNegg=
=UnwV
-----END PGP SIGNATURE-----

--4xw+PCQM2wNdCFnP--
