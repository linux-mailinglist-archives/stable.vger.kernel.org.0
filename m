Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9F28665C2A
	for <lists+stable@lfdr.de>; Wed, 11 Jan 2023 14:10:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229776AbjAKNJ6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Jan 2023 08:09:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229928AbjAKNJ5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Jan 2023 08:09:57 -0500
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B6E721A;
        Wed, 11 Jan 2023 05:09:56 -0800 (PST)
Received: by mail-pl1-x62c.google.com with SMTP id v23so11817624plo.1;
        Wed, 11 Jan 2023 05:09:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=f5DOehqdP3l1+LWA8SeET95uNDOWI0vbHwlUXdSlubc=;
        b=A65qp0YBogZFd3pI1JDC1BkSUt/qWsLJxQAVM3OhY+W9MhKg/ETNw8NKUXdpuwwO0a
         lxdB6TfiWoyR1eGlIx6bHeWdILpLZAEKgIxyHCJBgXom1pQQz5Gf11KQrfEwgLBwDnbG
         aLuGSRkB3DW0D9bzNs3/+LAu6YzZoahSe8X7mw1TWO5penar0J/yTWqiIgwnsS6VcXcp
         +UuFMuO6z+pMOeL23AV+ofMyBtSe2YWrq6fv4ZfSKZ4+nCb9CHpQjj89QhmVS/C7eUu9
         kTPYX4qZKfil9/ji2DLopwpnU08eDfE7GQm7xTrVflNT9hiYfGkUZXjJSLxExQVMy9/P
         mpoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=f5DOehqdP3l1+LWA8SeET95uNDOWI0vbHwlUXdSlubc=;
        b=EbMt8JWe4eyShW4qHXhDg/8tqYEo+Tv2TpIsQUKPkpgYhnZ9p1933HnlTYRKM/FQAZ
         iE8MGI/A6OVVm0u7+le7kmtjavJiV0XPmonBFP9byaUFXxMtwfcc9KV0d8ksDEJJMO/t
         OyzHekZVYHZZWyKgdaJDUoc1AxmWyS/21PAaU+p2euFw06aBQlB5fNtN3FKtsg95mqD0
         iy0JGljLLjyXE1nZeKhYHCDeasrw3yD4UhBQ85r6ygDKk61nxK0sc/CYirVZjfZGK5Yz
         4rpqS8o7kfYxlwwYAoAl4oVmCu8w+sjxxYmLm2flY8LAYbEC3jPTY5UcAfxaTVITAsnq
         nTYA==
X-Gm-Message-State: AFqh2koDwL2Ii3COh0StMZNPxl6gqaNa9R//u5XALzr7ihoijd0FhgYy
        gPD2u7wJQbmtwveHMYusMUo=
X-Google-Smtp-Source: AMrXdXvEHF2ENqXJEuIA0B8Lipxh1EJK2BFDUMyPeBRamWJnlPAUpni1GZLeu5HBIoE6ZPsu0Ti7yg==
X-Received: by 2002:a17:902:d50a:b0:192:d5cf:ab7e with SMTP id b10-20020a170902d50a00b00192d5cfab7emr43956760plg.32.1673442595745;
        Wed, 11 Jan 2023 05:09:55 -0800 (PST)
Received: from debian.me (subs02-180-214-232-16.three.co.id. [180.214.232.16])
        by smtp.gmail.com with ESMTPSA id 6-20020a170902c20600b00192fc9e8552sm10233394pll.0.2023.01.11.05.09.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Jan 2023 05:09:55 -0800 (PST)
Received: by debian.me (Postfix, from userid 1000)
        id 9B9DD100074; Wed, 11 Jan 2023 20:09:51 +0700 (WIB)
Date:   Wed, 11 Jan 2023 20:09:50 +0700
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.0 000/148] 6.0.19-rc1 review
Message-ID: <Y761HnGVAuXrWsQ/@debian.me>
References: <20230110180017.145591678@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="q1pl3LCTnzLm6bHc"
Content-Disposition: inline
In-Reply-To: <20230110180017.145591678@linuxfoundation.org>
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--q1pl3LCTnzLm6bHc
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 10, 2023 at 07:01:44PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.0.19 release.
> There are 148 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully cross-compiled for arm64 (bcm2711_defconfig, GCC 10.2.0) and
powerpc (ps3_defconfig, GCC 12.2.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--q1pl3LCTnzLm6bHc
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEARYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCY761FgAKCRD2uYlJVVFO
o4BaAP9nGSFamz/NklVmNV2uCJIz037RgniS1Q52JiYAF6DeeAD+PfHYwR59aMM4
hbYw50kQxuTrp5rJJFI4HXEs4+pH3w0=
=3ywp
-----END PGP SIGNATURE-----

--q1pl3LCTnzLm6bHc--
