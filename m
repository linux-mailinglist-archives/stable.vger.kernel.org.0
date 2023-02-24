Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 432A76A190A
	for <lists+stable@lfdr.de>; Fri, 24 Feb 2023 10:50:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229445AbjBXJul (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Feb 2023 04:50:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbjBXJuk (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Feb 2023 04:50:40 -0500
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD86863DCC;
        Fri, 24 Feb 2023 01:50:38 -0800 (PST)
Received: by mail-pl1-x62c.google.com with SMTP id c1so16379488plg.4;
        Fri, 24 Feb 2023 01:50:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=NVCCdXBa6nz88M87KyoQqKDz5FQKWkEXCvBtVbehT4E=;
        b=cjEL4yZ7en6kaastuCZfsMHDzYmv/Vd2SJJtJwOadFmDpRbtvMYKVqu6jrOHMl3iKR
         NQybfLjw1kRjVerGVTjHXSCJ+mlMYGOer574w02tCSee3YyvRiVxIjx/UQ8TiJ9V4Fk5
         TgeWA8jIGq5io6C9TZvb55cY4FN8RdQZD7YNj5dZGhq9S+KGYpWvcj8X5/XWHyLqLZUQ
         fTbi/1SXF7cjcT6JweDyF0Jjdf3r/+sEXzgp+Xo2Jhf2SBxuAnsRhZ7JEgLKBVGrIGDo
         NpRyS+3FBzh01i5aAon5IhM77QCUCKmyyV38DUj8DoBwffBdOCzcVYdUikzzIDjeJiv3
         oosA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NVCCdXBa6nz88M87KyoQqKDz5FQKWkEXCvBtVbehT4E=;
        b=edBrLSTnzMo2l1QwjeYHpMTF4qBjeV5pm/yyINQlPiVOVRVFCL9lh1L//Z1xMgiecq
         Q5774UM8KxtSi+Tkr15+Jt1IQUlqzjCP6V6MTYnAu1NtDZP59JPDMHnIuNJCkWWWiL8w
         QhWGho7+m/K1JNuZZB3IqR/w3a3Tsd6pi76y1PxyMwRDSTEUu1SIQmu5h/a7KCQzS/BG
         SyZqEJeCMMPu+RbpNJ8Z9Zrd9eBKoHkyKHk1YVkhFQMa9Xdpp2OKTOPiggK5rH3mBQeI
         VKyt2GSgEQJ9bXrLYvHUtNopcZQEuljGXqlu2bLnrUjsSOOn0cZv/aiMrKlwnGiPNzDM
         jO5g==
X-Gm-Message-State: AO0yUKWX1+3wwcPp1hAf/FCGcbCRqCnOee8crnvIw7X4FHkJcsoOVQbv
        SCK+69QgAXXnBULhDuC9qi8=
X-Google-Smtp-Source: AK7set/rtHLudRm85CWQuBieXpRW8tFRNkR2cAEct9hcL+0lMVkTZgqzZ4hSwV0FiYCejSf9wSz3Sw==
X-Received: by 2002:a17:90b:1b50:b0:234:1676:84f2 with SMTP id nv16-20020a17090b1b5000b00234167684f2mr17823007pjb.11.1677232238175;
        Fri, 24 Feb 2023 01:50:38 -0800 (PST)
Received: from debian.me (subs03-180-214-233-4.three.co.id. [180.214.233.4])
        by smtp.gmail.com with ESMTPSA id a15-20020a17090a70cf00b00233df90227fsm1134486pjm.18.2023.02.24.01.50.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Feb 2023 01:50:37 -0800 (PST)
Received: by debian.me (Postfix, from userid 1000)
        id 9098D106350; Fri, 24 Feb 2023 16:50:34 +0700 (WIB)
Date:   Fri, 24 Feb 2023 16:50:34 +0700
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.15 00/37] 5.15.96-rc2 review
Message-ID: <Y/iIat7/gqFdI2xy@debian.me>
References: <20230223141542.672463796@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="mGA0/6pHTKADJV3O"
Content-Disposition: inline
In-Reply-To: <20230223141542.672463796@linuxfoundation.org>
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--mGA0/6pHTKADJV3O
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 23, 2023 at 03:16:22PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.96 release.
> There are 37 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

As others has pointed out, I have to apply scripts/pahole-version.sh file m=
ode
fix myself. Regardless, successfully cross-compiled for arm64
(bcm2711_defconfig, GCC 10.2.0) and powerpc (ps3_defconfig, GCC 12.2.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--mGA0/6pHTKADJV3O
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCY/iIYgAKCRD2uYlJVVFO
o4VMAQCgBe37PX/IS4NUBzfnKEDLL1b6iL9oOJzFRRzx+refkwEAs+g1MXQtIg97
Rgq1eNefOupru+O909loeM9xQH9erwo=
=VHKN
-----END PGP SIGNATURE-----

--mGA0/6pHTKADJV3O--
