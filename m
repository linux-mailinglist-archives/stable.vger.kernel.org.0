Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F41D96C411D
	for <lists+stable@lfdr.de>; Wed, 22 Mar 2023 04:36:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229871AbjCVDgR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Mar 2023 23:36:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229672AbjCVDgQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Mar 2023 23:36:16 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEEC657D03;
        Tue, 21 Mar 2023 20:36:14 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id le6so18098447plb.12;
        Tue, 21 Mar 2023 20:36:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679456174;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=dE6cUqLkWexq10WcTc729+dY2UIxjJT8AIzlQ9w+OHY=;
        b=aPPB9nEKTvQGYSm3aRvSCyFHLIP5wCvBZYftrgGaFz46U7e72jodASvVx1Zr5Tkph4
         Asv+m1Myg4jzNZ42PB5UQZ/XCBUPOwkgbNxZRes034U1Kt19dxj7vMu6friN9B+nwawO
         BcsSQ2P4oPx5wg7i41Wez3oEHgSRsEaxV5MZHdh0aW5XXlsUPNV6g4siQHlKDXAOyIrI
         i9l9cOJTfORRo++9zK4jfXIEEpWJQLFtKtj3oCEwl+wCs/cwMt3gDaoWSqjUOpwjZNgL
         k0bGSyyUHHLl0zRspxQNHwKDDFyfmzKdqd7hgRk6av5cy8LecB1NIlxm+AlUQc53GEfk
         ADBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679456174;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dE6cUqLkWexq10WcTc729+dY2UIxjJT8AIzlQ9w+OHY=;
        b=2vrJuR2+ak4jFHdCrKoZzXMyDlTR0dVAUuuGjn6wbN+dHj2zvZ4JX9Ol828MSd4zEd
         6iW21IXLett3mW1lmSld1p/N1W/SiQ67IO4XEpDlHge/k5cNZYxjEnmrcxUhH5eonf5P
         Cr42qwj3l9lG6DpHgfjq43uSxTSwmmf20PBnPDlh0hTtcGlK6SSSe2WghdywnD82z5zL
         EXx9XOz7OBE/rg9jHu1w9Sj/JjeC8hDtiqPcvqzlqZ3MGCm/yzyhxkgzKQW6afx1XdY0
         s/0Eus3zMIMimcExTlsnopZoitM/qM5wYxwBQZgBMF04kpHLdzF9YhS5VzhG6iffRhDw
         cRBg==
X-Gm-Message-State: AO0yUKXRM7s9aPnudttiMHpb609DwTVS75J+rP5jAPsCc50PocBQ3kvo
        S6auX78mgyvukH2i7UCf2wI=
X-Google-Smtp-Source: AK7set/kbWEwOcYxi4SQnjfsHzpzCQ78++mlhj+bdhi3XyBOX4Q47mqN02lmBv79T5Mxlc9U3DlD9Q==
X-Received: by 2002:a17:90b:1b41:b0:23f:7666:c8a5 with SMTP id nv1-20020a17090b1b4100b0023f7666c8a5mr2015596pjb.29.1679456174411;
        Tue, 21 Mar 2023 20:36:14 -0700 (PDT)
Received: from debian.me (subs02-180-214-232-30.three.co.id. [180.214.232.30])
        by smtp.gmail.com with ESMTPSA id kx15-20020a17090b228f00b00231224439c1sm11589001pjb.27.2023.03.21.20.36.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Mar 2023 20:36:13 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
        id 8376E10676A; Wed, 22 Mar 2023 10:26:27 +0700 (WIB)
Date:   Wed, 22 Mar 2023 10:26:27 +0700
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.1 000/199] 6.1.21-rc3 review
Message-ID: <ZBp1Y+oq7XhSatq9@debian.me>
References: <20230321180747.474321236@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="9GigIbS1uzcWMeqb"
Content-Disposition: inline
In-Reply-To: <20230321180747.474321236@linuxfoundation.org>
X-Spam-Status: No, score=1.3 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--9GigIbS1uzcWMeqb
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 21, 2023 at 07:08:16PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.21 release.
> There are 199 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully cross-compiled for arm64 (bcm2711_defconfig, GCC 10.2.0) and
powerpc (ps3_defconfig, GCC 12.2.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--9GigIbS1uzcWMeqb
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZBp1WwAKCRD2uYlJVVFO
o1q8AP9Vsj2VJu/ZVALbbhIOwHPd34wj/3bVs1XbEv0lSYC6qQD/Qr5f1hMs3ilS
21KiRZ7u89iq+uLWJZjP2brra4quaQM=
=p3oV
-----END PGP SIGNATURE-----

--9GigIbS1uzcWMeqb--
