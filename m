Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9F076A7D85
	for <lists+stable@lfdr.de>; Thu,  2 Mar 2023 10:21:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229695AbjCBJV3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Mar 2023 04:21:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229708AbjCBJU5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Mar 2023 04:20:57 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A62130E81;
        Thu,  2 Mar 2023 01:20:19 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id y15-20020a17090aa40f00b00237ad8ee3a0so2086016pjp.2;
        Thu, 02 Mar 2023 01:20:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1677748819;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=SpjbL0+tw0OXVT5Ll6YWgAqfA/dRw9VkkcHAS6chO0U=;
        b=hPKSs0z3YSeSHFQpz6+z0j9+1VULH7/s0dtcFUMqao5zn3thKxAg9JFflOgmoOw+RM
         XVOEw/bwOGLQa6RATBJNBV306BRHj/p5vLgMbkJqUMQquL9xHnuOSDEkdzomk+fdTPL4
         4cwMLYuMihpOqE5DtnYZX9VHpnu8DWRihSpIfn/N11XNVR8GXYa5mhNBDf71NP27XMaz
         7OYfGIfDOoit7sswLMogqVOa1385DjdO9fIfGBiS5OgZWfMOm2oxDcFhQOkKF1IX6NQ8
         HbSFUNu04/5tgqqrmr304NKU/WNcVh4QnpAqD0jsOP5rLnxlIU8XokyO62QgK6XMSaI6
         ectQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677748819;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SpjbL0+tw0OXVT5Ll6YWgAqfA/dRw9VkkcHAS6chO0U=;
        b=C9aJmKFeazSLPVDlGAxeb+ZMCKHAaFQNFjCvjgAx1S3qAM2JGTpnGwbYxrgwYwKp29
         2WfR2HKoYGGv3zLcQHZ+fXz/IHgRntX9QRBRVMpjSpGvJe3jvdJZKZawq8l2tg3KvhY7
         PSyBV2ku1+ZfBwkOgO0bCTtulRCN20xnEBz9F9voltYwoO2/0JQXjQ4ejoga6iq1EHjj
         1YBSMtYAncdOthfIr0zhjSNzpNWFOWSSten3N+6nkakfR9tP5xR1faedy2z60YLOaDKi
         sUX/EJzxJllK+LOBtPLEuo9fJTowVuqQd29yG+9IoRsCyA5vCLwUGxoUFqpqVtOSwCjw
         yRCg==
X-Gm-Message-State: AO0yUKW4zLxnTBwueKSGmI5KuGLz+BEqYwrhBktK2/OBqcoCOiPL/P/l
        ELPCzCOu6Jh1uhUJrSwVI+0=
X-Google-Smtp-Source: AK7set9QsFevYUQW2fyMF+c6lKXWoncb6uV6ik8S+7NwOyKqENuxfjUcUQ7zwvVpKkVk3AjyWC++WA==
X-Received: by 2002:a05:6a21:6d87:b0:cc:39c5:1241 with SMTP id wl7-20020a056a216d8700b000cc39c51241mr14207793pzb.16.1677748818666;
        Thu, 02 Mar 2023 01:20:18 -0800 (PST)
Received: from debian.me (subs02-180-214-232-3.three.co.id. [180.214.232.3])
        by smtp.gmail.com with ESMTPSA id g6-20020a62e306000000b005ded5d2d571sm9346972pfh.185.2023.03.02.01.20.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Mar 2023 01:20:18 -0800 (PST)
Received: by debian.me (Postfix, from userid 1000)
        id DE979106674; Thu,  2 Mar 2023 16:20:13 +0700 (WIB)
Date:   Thu, 2 Mar 2023 16:20:13 +0700
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.15 00/22] 5.15.97-rc1 review
Message-ID: <ZABqTfAa/aHtJQQL@debian.me>
References: <20230301180652.658125575@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="0sGyj5cQz5+LDbLw"
Content-Disposition: inline
In-Reply-To: <20230301180652.658125575@linuxfoundation.org>
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--0sGyj5cQz5+LDbLw
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 01, 2023 at 07:08:33PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.97 release.
> There are 22 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully cross-compiled for arm64 (bcm2711_defconfig, GCC 10.2.0) and
powerpc (ps3_defconfig, GCC 12.2.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--0sGyj5cQz5+LDbLw
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZABqRwAKCRD2uYlJVVFO
owQHAQCHMKQacALiPmNDxiV58N6vcreRm1WH6Bc7B5ZgW2QqtQD/Vs2d9/zfD0DH
etfb0hVHhPTtCVTI3I9t2HjJX1uNUgk=
=CYtw
-----END PGP SIGNATURE-----

--0sGyj5cQz5+LDbLw--
