Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A80668A7BD
	for <lists+stable@lfdr.de>; Sat,  4 Feb 2023 03:04:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231278AbjBDCEE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Feb 2023 21:04:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229694AbjBDCEC (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Feb 2023 21:04:02 -0500
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3081838653;
        Fri,  3 Feb 2023 18:04:01 -0800 (PST)
Received: by mail-pf1-x433.google.com with SMTP id 144so4951299pfv.11;
        Fri, 03 Feb 2023 18:04:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=uePF3eDJemwYV3SuvTrXUS0Nc0Z+OSgE9N4Vx3eaMM8=;
        b=C4RiucKjZPpCAg6YAF4eBUtU6U9GxzZ+KQE285cOOmXecDTMdNZG/Z7dDCwajOZFq5
         6fhggg0AghxpLqm5J6HrpFFeqzc3AIgHFFtTocELrOFpSlWfM16f0lFf3Tio55n/ijbT
         CC2a+so6nwR3dmAh06sZhhTZvojCQ9NMTfNl9bznW1T3TVXH9eWfcxQIhVfiXDJkkvM7
         fCDKnvCzQFcdw5U3BpoM8qpb1o2dUlI8gNAYXpHqH1uL8ao8OS7VX16KnoOfFzBhAm6i
         v2nkRY8PsoD2YqDcCPFqGBDWUfq06PRO6xA2kzd59Hmh7AL1ybcUpE0Vud/fRxbzIwJg
         OQYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uePF3eDJemwYV3SuvTrXUS0Nc0Z+OSgE9N4Vx3eaMM8=;
        b=bLB5qBXFUnwFkxFnW188UbZVjIPabqmrytdbCxPVistAye65Le5/cZkluHsGVFyPWZ
         PxR8bZt7/6J6457jhkHRq7TIBlbrh5eZztjEvGKUHKvKeW3amtf4PotsblsHIiyQADe+
         mTgrukk8K+38Zjjw7m7n93aCkdPTPx9QDvTKHnvLzUzS0XOd5R4Itmqo5EBNvW2riNKQ
         SDnfVAp+hbliiWdq8UQWxUPmU0Eqz7sfS/o9rUk36ABKpnuXfF3GV4GMbSdwYVSWKqWw
         /VTjeboUy0SxYodOWWnYxwYAnjVaWOyiYxp2XbRvkxCBA3qe3htTuvxqyvK9poXcz2Ug
         xgMg==
X-Gm-Message-State: AO0yUKXsPQGzA1H3yIRLTeMQpL9/lBdFwKc/ry6jYSJGwnb6kp+1VN74
        8i4xktSrmu8gDf6QonhauK0=
X-Google-Smtp-Source: AK7set8cRFAs1HA7CysvGz1jSHh+UPjUA8HI6i+unKtdWIXeai5/n/5suMpr8o/8lEDCDNck9eOImQ==
X-Received: by 2002:aa7:915a:0:b0:593:cfbb:3446 with SMTP id 26-20020aa7915a000000b00593cfbb3446mr10195154pfi.11.1675476240673;
        Fri, 03 Feb 2023 18:04:00 -0800 (PST)
Received: from debian.me (subs02-180-214-232-73.three.co.id. [180.214.232.73])
        by smtp.gmail.com with ESMTPSA id y66-20020a626445000000b005821db4fd84sm2507025pfb.131.2023.02.03.18.03.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Feb 2023 18:04:00 -0800 (PST)
Received: by debian.me (Postfix, from userid 1000)
        id 02D1B1052EA; Sat,  4 Feb 2023 09:03:56 +0700 (WIB)
Date:   Sat, 4 Feb 2023 09:03:56 +0700
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.15 00/20] 5.15.92-rc1 review
Message-ID: <Y929DJ7bSaFVc+/I@debian.me>
References: <20230203101007.985835823@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="e/62PjlpUEBrbBLG"
Content-Disposition: inline
In-Reply-To: <20230203101007.985835823@linuxfoundation.org>
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--e/62PjlpUEBrbBLG
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Feb 03, 2023 at 11:13:27AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.92 release.
> There are 20 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully cross-compiled for arm64 (bcm2711_defconfig, GCC 10.2.0) and
powerpc (ps3_defconfig, GCC 12.2.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--e/62PjlpUEBrbBLG
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCY929AwAKCRD2uYlJVVFO
o0pSAP4xikCjYlehto1K/7EG/Q607otvnze80g/FIRqCPSAYwAEA804JcdwogPij
qlQ/MNtoUy6DzGoPWMSSabw4cIbkQgA=
=vUuP
-----END PGP SIGNATURE-----

--e/62PjlpUEBrbBLG--
