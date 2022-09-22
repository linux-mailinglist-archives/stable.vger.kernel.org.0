Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DA045E5C17
	for <lists+stable@lfdr.de>; Thu, 22 Sep 2022 09:15:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229980AbiIVHP3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Sep 2022 03:15:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230378AbiIVHPR (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 22 Sep 2022 03:15:17 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBC769DB79;
        Thu, 22 Sep 2022 00:15:15 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id 9so8369918pfz.12;
        Thu, 22 Sep 2022 00:15:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=EeoWV8SkheEGKl37bclq0nEctq1TnH6Rrcdz17Iv9+U=;
        b=EF0luu+0YqTsXOgCzLucLonnLiAQ/bwubj8BVV0GQ4IA298Y/UeqUk6k1Binc0r3Xe
         LUo7MM4QZUCKUx/FL8Eg4tIYGZhS5iD6f4YsK0Zv3uNUiOhOih5iA8ZfTrtDpZOLmm8p
         MwNU6YK+4CNKAKHmaBZLnVxVtDCis6kVR4gWMxm8UDgFwiLHC4ujIiNlBvtK7SpCKaAd
         zHwaS1KKNIpGD75MHdzpmYUfydUG47wWAvD0w73upTJQdMbQwWD8r4FMpkGRaeAKuGl0
         w+c10CUqWXm06LtNPGrifnJVh6GmZz8aXRZBomdiupQMlap8nj2pYhAgV3g5o6k6j+F8
         I2TA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=EeoWV8SkheEGKl37bclq0nEctq1TnH6Rrcdz17Iv9+U=;
        b=NoIVJspj7s59sf/AiItpgCTCERO2+aVnBmfFEmSsCndV86Xo2V887OajTKdcOMAu1C
         9BvvwzrrKh8OxTZ/1EWSZ0OJKMVQ1Od6mbKN64FYOtlUJv+hNKhy7PkL/uaBf8XP+Wjn
         2TUHAYymS6n7g/hCt2lK3/jjiDJ4b9H+lcMuqTCWl20a3lABqsftbi6jVM/9brHWrG7/
         zfYVr3pG9zvlU5i5ZGaPCFtdc+UWOsSMxd/HEZmc0kXrP3BmfHO3EiF3oq+bGv/SKgBc
         Re9O63A/iKYyOdB/3RvVf40e947bCrvTYsU0KiaXa/OrbClM+GeHYQ6kyEClweVKjFjA
         sNdQ==
X-Gm-Message-State: ACrzQf0thoM5M3YaPwbPaf6GPiHPCtBgimIvRdownlEdmqBKarifPjhG
        nQiL6Ztac2e65vA7mzlg6Bc=
X-Google-Smtp-Source: AMsMyM4ibX0H7IwPnu7Jf9xZh4GvMRQvdlWV/1IlcYpzMuSAlDb9vmNF1dKOBezNuj5mUHeJ28lWCg==
X-Received: by 2002:a62:b504:0:b0:538:20ae:bbf2 with SMTP id y4-20020a62b504000000b0053820aebbf2mr2067124pfe.79.1663830915439;
        Thu, 22 Sep 2022 00:15:15 -0700 (PDT)
Received: from debian.me (subs03-180-214-233-90.three.co.id. [180.214.233.90])
        by smtp.gmail.com with ESMTPSA id x24-20020aa79ad8000000b00540ad46bc1dsm3552240pfp.157.2022.09.22.00.15.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Sep 2022 00:15:14 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
        id 0D5BD1038F1; Thu, 22 Sep 2022 14:15:09 +0700 (WIB)
Date:   Thu, 22 Sep 2022 14:15:09 +0700
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.19 00/39] 5.19.11-rc2 review
Message-ID: <YywLff88uc6G+AZ0@debian.me>
References: <20220921164741.757857192@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="YoPR4LtDPsbs3O++"
Content-Disposition: inline
In-Reply-To: <20220921164741.757857192@linuxfoundation.org>
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--YoPR4LtDPsbs3O++
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 21, 2022 at 06:47:57PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.19.11 release.
> There are 39 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully cross-compiled for arm64 (bcm2711_defconfig, GCC 10.2.0) and
powerpc (ps3_defconfig, GCC 12.1.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--YoPR4LtDPsbs3O++
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCYywLfQAKCRD2uYlJVVFO
o6JmAP4hFOLjArzX3VY/9rmXLp8+P/bK1J58gCHiM6/QvbGExAEA1DTBYo8sPMR8
oJaMnpL8G3BWC7lKRP/a5+y4KwwPVAM=
=Z9hT
-----END PGP SIGNATURE-----

--YoPR4LtDPsbs3O++--
