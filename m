Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5F0A6394B3
	for <lists+stable@lfdr.de>; Sat, 26 Nov 2022 09:55:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229464AbiKZIz6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 26 Nov 2022 03:55:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbiKZIz5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 26 Nov 2022 03:55:57 -0500
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36FCB1F62C;
        Sat, 26 Nov 2022 00:55:57 -0800 (PST)
Received: by mail-pg1-x52e.google.com with SMTP id r18so5662041pgr.12;
        Sat, 26 Nov 2022 00:55:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=mjCyoWb61wdL81qcmSTAoCdIWg/CnPBXU24aGBaxwOM=;
        b=GKxrnlQLxkL9Zl+l/xPdpODXepbcFe04+9KhbZqPCrUdhirdjzECqRG7Bho21ovFaz
         I3YdMsdsZ0fbxpGtE1dKZEo6AjHoQ7zitma0vg5XFFnDExCg46EmBf0bRbi3EL8NMZ0V
         xXCMos5IWLsaEHb0C4fGPnJBSE1smSkBJSFZwclaL6iMbo4nxn+i1Q56kXkPAJ27iH0I
         YJ0uzsFlP+jOpDIbuiYNAhozku4OuzTGBZXerfPyPFesLfuaQecUDwGpyyZ/cuIKPyMd
         sfxV78V5uXlyjsd7gBEwWgODn6zHnUHDZemDrk+QU3FdTE4u6jlE6f2YELumG+BvZJET
         yhaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mjCyoWb61wdL81qcmSTAoCdIWg/CnPBXU24aGBaxwOM=;
        b=i6/KBuaEop75RO0eTEIacEnowsUqU35bUVsxuUriuaoVsqMDC1GQHODYYvEKVx7QAq
         SQYYyZhUG/4DhVaA0USJwFXESI/+5pjlVGxygj2GWQEJf7HRptcRYQjrJqMU2ZCcfvB6
         R4RyWTRwibDmD2Nnn7qlHgS+Ot7US3lJiKp6NqXwIOdoN9C+eqTagTXQ8B21CFp6UiRL
         HbIr6eEtP+gjDWypt68JkR6qE7/8zXwHm5wWXRyYBjdduWP8cTW+Dts2rmaor1BlDCK3
         ZIJbJa2udUuAELu8bUofoeU9ZXOnA4r4JYVLi8kJhdZiDGWYdKSWHwn8E69eXCzkfnXD
         pXhQ==
X-Gm-Message-State: ANoB5pmuIOEsQIN6s9n+F4z9PEHSsD7taB38f7tIdlQoog556Z4+eRLK
        cyGczVOn6vrxkLr1DQsUisg=
X-Google-Smtp-Source: AA0mqf46aOZen8tAGbErQ9j6rmqHuNqXcVcwUnho3E5t1ejjZqVcNErb8tzEMFzSlpfLszqPUVgv3A==
X-Received: by 2002:a05:6a00:1d21:b0:574:a486:cb with SMTP id a33-20020a056a001d2100b00574a48600cbmr9339894pfx.11.1669452956727;
        Sat, 26 Nov 2022 00:55:56 -0800 (PST)
Received: from debian.me (subs02-180-214-232-11.three.co.id. [180.214.232.11])
        by smtp.gmail.com with ESMTPSA id l7-20020a170902f68700b0017f756563bcsm4892392plg.47.2022.11.26.00.55.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 26 Nov 2022 00:55:56 -0800 (PST)
Received: by debian.me (Postfix, from userid 1000)
        id 7B41210436D; Sat, 26 Nov 2022 15:55:52 +0700 (WIB)
Date:   Sat, 26 Nov 2022 15:55:51 +0700
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.0 000/313] 6.0.10-rc2 review
Message-ID: <Y4HUl6gMvkDJxgA+@debian.me>
References: <20221125075804.064161337@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="1CcNYwqhgGfkxMEO"
Content-Disposition: inline
In-Reply-To: <20221125075804.064161337@linuxfoundation.org>
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--1CcNYwqhgGfkxMEO
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 25, 2022 at 08:58:38AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.0.10 release.
> There are 313 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully cross-compiled for arm64 (bcm2711_defconfig, GCC 10.2.0) and
powerpc (ps3_defconfig, GCC 12.2.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--1CcNYwqhgGfkxMEO
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCY4HUiwAKCRD2uYlJVVFO
o6ybAP9NqLaB6L+lF2RF9TI+GtnoTjgX2+5JnN/BjIgquv4TbgD/UsPqydFI5nTo
KP2Rnp0N4UkMCI2XWBSRcazJebcmnwk=
=xTG3
-----END PGP SIGNATURE-----

--1CcNYwqhgGfkxMEO--
