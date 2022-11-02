Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2AC8C61629F
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 13:22:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230293AbiKBMWM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Nov 2022 08:22:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230045AbiKBMWJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Nov 2022 08:22:09 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE97028E25;
        Wed,  2 Nov 2022 05:22:08 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id gw22so3150396pjb.3;
        Wed, 02 Nov 2022 05:22:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=JEShaRfMku8DHeXNO4LQW1dHyOinHMJ43eNJ9bIDOWM=;
        b=D3tUFE/xE1CysYqaKvGy8yTFXDrH7jS1GsQC5qLa1rDjVTShnIrjVTqghLIpFEKUxc
         qyViwJIRo2fRRomhC9jo/30MvYwTNqWaRIsW36z56F0T3JBFpVRGYPr0hbB+hy1JJsNt
         rC4i8UEmJRmHzqFurseV5jMuVYOBBx0b4nED6bCoOOkRCF/soBSs8hMQeMQ/7AgPZpZ3
         oqnSUK4jYc7XbI4jA4Q+BS4KzALDs44wj78qcUuQqeLvtu9kIiBQmU9qEv3YbPwBo+on
         5EofhJslp/kC0M7e8KOyy6E5ZJIJfPncpDsta/nhd+2qNBWMzGJDZMQ7NjeskN4uNVTF
         KzBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JEShaRfMku8DHeXNO4LQW1dHyOinHMJ43eNJ9bIDOWM=;
        b=yA1nzaZzT1atvgvvKaUTQQBtAlpIO68Y3nT1GwNvOLqpepVXsaEHvlof9LtVQ7uXGV
         zqAe21eHlHg3WdEK5EYZeaSjmbo2ny9k3JIzYqZnc3wK3Amf15ddb02OUcke6fagAjwz
         +QPLDdwnm0AZkztAEQpUHE4LdYd/CpsZiaWwUSAgBKGirtBNjzeSNmrBflmjvB+oV3lt
         UuCBSU60tQEJXICe7K0h5ynOONva7643Zwz6QX3jy6Op2HwflEcpdstORMN2aZcoXJUA
         q+iAWqR2cqw63T5ZB7tVCjv5nFNE+H6iEH/nMao+uM8njKel7Nzj9gT4HvXqVMjHoEuo
         /MuA==
X-Gm-Message-State: ACrzQf2PgU58cn3EcdGUCZlwT/usz7PtXdV5AtagDme2H5c/KV7CH+z6
        5VgfplfTrXGpyowTI4twxcs=
X-Google-Smtp-Source: AMsMyM65RYH6ciM+fZDqrbhmSDXAc+gMN5djcopTDmIYRNzJG06FGRyamDO2FAN8R/pvkMj0p/rZxg==
X-Received: by 2002:a17:902:a611:b0:186:9ba2:148b with SMTP id u17-20020a170902a61100b001869ba2148bmr24573732plq.164.1667391728428;
        Wed, 02 Nov 2022 05:22:08 -0700 (PDT)
Received: from debian.me (subs32-116-206-28-50.three.co.id. [116.206.28.50])
        by smtp.gmail.com with ESMTPSA id e10-20020a170902784a00b00172fad607b3sm8113175pln.207.2022.11.02.05.22.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Nov 2022 05:22:07 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
        id 66F7B103835; Wed,  2 Nov 2022 19:22:03 +0700 (WIB)
Date:   Wed, 2 Nov 2022 19:22:03 +0700
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net
Subject: Re: [PATCH 6.0 000/240] 6.0.7-rc1 review
Message-ID: <Y2Jg69Op79H5kXDQ@debian.me>
References: <20221102022111.398283374@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="FkJ6buWqUvS+9+zA"
Content-Disposition: inline
In-Reply-To: <20221102022111.398283374@linuxfoundation.org>
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--FkJ6buWqUvS+9+zA
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 02, 2022 at 03:29:35AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.0.7 release.
> There are 240 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully cross-compiled for arm64 (bcm2711_defconfig, GCC 10.2.0) and
powerpc (ps3_defconfig, GCC 12.2.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--FkJ6buWqUvS+9+zA
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCY2Jg5AAKCRD2uYlJVVFO
o98WAP9BxmlTA3xmkOPMlfTdW20dno0sHygfqS/V7sF7Yv0nXgD+IJZ7tWActesP
CUbDDlsJT3v5YwYW8R9wvyvxRfsDVQM=
=+6/u
-----END PGP SIGNATURE-----

--FkJ6buWqUvS+9+zA--
