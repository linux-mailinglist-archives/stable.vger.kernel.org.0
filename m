Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 268EB5E5C00
	for <lists+stable@lfdr.de>; Thu, 22 Sep 2022 09:13:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230357AbiIVHMZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Sep 2022 03:12:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230364AbiIVHMM (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 22 Sep 2022 03:12:12 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31261C88A9;
        Thu, 22 Sep 2022 00:11:52 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id fv3so8917405pjb.0;
        Thu, 22 Sep 2022 00:11:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=7P4/MoUd89O1+A8bGYH6BhOc7UW55SCbrR2sakyuDZs=;
        b=cDPR71YiCfI/nr6sTEi7NepjawVwGuNAy+dEFtsTyaNTl93iWIRvruUoqcdCXphb2t
         OQfISlrtInzsol4LOPkdNT4gLwcvA10hhStRFj0ZT1/6JO5a9uPFxQDMMnQ2DQyu80WX
         7zq1HT0DhRmBCaAdp+lG7eQfdt6cbuevQ+ymt/jppc2DxUm2kyO6ICgQ51VFRyJRnVJW
         rE9ZApi7AvQfL/9FgsemGxItnowiFUxbayoTSNllV5S4/ltikYg9nxS2NzuFFy22nqXd
         ICEzE+S1OtfNJZjgxm7mgcKQYkNi60RoXd7jIwjlZ0GD1qMyRvI5C7QexD99TBaTL0dg
         lJeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=7P4/MoUd89O1+A8bGYH6BhOc7UW55SCbrR2sakyuDZs=;
        b=NcLbJ0Y95ZP7/JwJEj3H7w6lY7mfEsCi21smxcwf5l6/5PbE3jQHT+9IuOtrdCzZW2
         DCoz4LCJfjhJ7IIk9KjHyHF6813uvg4o0QyZ4JVSOJS5loFJ0j/Stnhes/f14DTOcB7k
         yKh4evvqiqGoiehUt/Omk01CBBamdn8T+A+G/KzcztLK0vGSlW1tvaEnauodD6fOe8jP
         A4DqhKg67c9h1U6+yL57kVPQ1/r+748l+IrjKqOIrppbkemOQ1qlz59K2XpPAipS3cXa
         P6vDz+VexmkiQcRN2/eS970k7TPEWRUcVXyLp6ZGoE64ygXr+FdIuYXYePghadlvth0C
         LCKw==
X-Gm-Message-State: ACrzQf1UCSmCcGmO9UzJCoS5/NbVhDLRARjT+XO2lBi8wB0CDekS/B71
        ixWbR50qY2Ho7kBKosk3NP4=
X-Google-Smtp-Source: AMsMyM44m8nPBgTU9GsK/fBLG7EG7voI+gWqkrcw+vUsn+mG/tB9/JXLSkLXgc8evn0Ta+BAngTujA==
X-Received: by 2002:a17:902:d502:b0:177:f287:269d with SMTP id b2-20020a170902d50200b00177f287269dmr1905914plg.140.1663830708961;
        Thu, 22 Sep 2022 00:11:48 -0700 (PDT)
Received: from debian.me (subs03-180-214-233-90.three.co.id. [180.214.233.90])
        by smtp.gmail.com with ESMTPSA id x20-20020a17090300d400b0017693722e7dsm3250581plc.6.2022.09.22.00.11.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Sep 2022 00:11:47 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
        id 4C5F81002A8; Thu, 22 Sep 2022 14:11:43 +0700 (WIB)
Date:   Thu, 22 Sep 2022 14:11:43 +0700
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.19 00/38] 5.19.11-rc1 review
Message-ID: <YywKrx5hyO8pEZNR@debian.me>
References: <20220921153646.298361220@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="3okefcpLheQNPjjI"
Content-Disposition: inline
In-Reply-To: <20220921153646.298361220@linuxfoundation.org>
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--3okefcpLheQNPjjI
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 21, 2022 at 05:45:44PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.19.11 release.
> There are 38 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully cross-compiled for arm64 (bcm2711_defconfig, GCC 10.2.0) and
powerpc (ps3_defconfig, GCC 12.1.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--3okefcpLheQNPjjI
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCYywKkgAKCRD2uYlJVVFO
ox2sAQD9fAi9DYE3iQ31NlP7K5xWx421JILzY5doQwTjhoaksgD9ErFmX6f1PePL
gT61pRSAEMaQOSSYlyR80ewxlSTH1wQ=
=WclU
-----END PGP SIGNATURE-----

--3okefcpLheQNPjjI--
