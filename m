Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3303766D536
	for <lists+stable@lfdr.de>; Tue, 17 Jan 2023 04:59:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235539AbjAQD7I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 22:59:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235525AbjAQD7H (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 22:59:07 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A3B923671;
        Mon, 16 Jan 2023 19:59:07 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id o7-20020a17090a0a0700b00226c9b82c3aso32904178pjo.3;
        Mon, 16 Jan 2023 19:59:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=WLeCTKLOjsvJHGKffA44iOpzJOsW8nOqwiD1dGMipgc=;
        b=i5ewKIi6NmayJpWmf1uhY2f9ADFWtqN8MjCV1G9YcYOzB1aC6pvH4k0za0mVE2KXoc
         fKgrxF8nEua2tMY4yevTFGJ5/Dw8h5kzNkn8P7/HU9xDoIaT8X4dN4ubqQUSciTPrP6N
         ySOUwE3wYWWANlD+AWKMtUYyiCU7BC/YR33IGDo+M+sbIuRM2iw4RfTfK0181CkEZYJl
         mg2lbH1GGaHz83cBxByUxXsiKby4t3aaKYfIBJHiYSqXtV+NK3eznVQz17K/8hnaqOcZ
         DjifQ0A9NPkO2b5HsCxGzgzn3i/yvxkSK0YnzOPnwpTppOS0dUB4qv6O8/zhJ5R2Fdad
         IyTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WLeCTKLOjsvJHGKffA44iOpzJOsW8nOqwiD1dGMipgc=;
        b=KgUJ47ogixmYyiKhpbhJLoCLD3JVmR91DqZ7381K0897xuEvTWqFESHCZTmBobFcVg
         QmQLqQCFohukzjJZ19fNbLHu9/O4EhYIi8jRrdNzcD1PgP5MM6Ly86FXadrWimKEtJgG
         qTW3/mQ1KjCldQzTp8ezToKM+RlrLpYRmZCn+RCuTtljHjcWLqZobVO3rPAABzjXCZbE
         kg2ZgykB1kof23L7r3ilIHdjx4v5HB5a+lVswZmUP6C1/WN2ISr1NXt7JmsXomScGPUc
         PPhaXexcKFBYojcOveEx7n19q/mcHuE4vQntD1/7+fS1udgUgLZaLXLCcFW9EzUaS23l
         7skw==
X-Gm-Message-State: AFqh2kq9ufG9HVkNQSaolAUcC5E3AyBHb4a0It+JLVCmH3pFbtYxakjG
        xeG2CacOSZkYjJZMG5IZgFs=
X-Google-Smtp-Source: AMrXdXtAdF94FlVNkhaTxEB6Edd39GQT/6YNBQtDvnkZJj9WIYyVV4ZBTiiz2e1r9Audfm89OUNsTg==
X-Received: by 2002:a17:903:2014:b0:194:a7b2:4329 with SMTP id s20-20020a170903201400b00194a7b24329mr1140920pla.28.1673927946592;
        Mon, 16 Jan 2023 19:59:06 -0800 (PST)
Received: from debian.me (subs03-180-214-233-20.three.co.id. [180.214.233.20])
        by smtp.gmail.com with ESMTPSA id h2-20020a170902f7c200b0019327f40bfasm17265428plw.119.2023.01.16.19.59.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Jan 2023 19:59:05 -0800 (PST)
Received: by debian.me (Postfix, from userid 1000)
        id 061E1103EEA; Tue, 17 Jan 2023 10:59:02 +0700 (WIB)
Date:   Tue, 17 Jan 2023 10:59:02 +0700
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.15 00/86] 5.15.89-rc1 review
Message-ID: <Y8YdBuxEbU4G0PQe@debian.me>
References: <20230116154747.036911298@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="DvcbpAMx1RoohX50"
Content-Disposition: inline
In-Reply-To: <20230116154747.036911298@linuxfoundation.org>
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--DvcbpAMx1RoohX50
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 16, 2023 at 04:50:34PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.89 release.
> There are 86 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20
=20
Successfully cross-compiled for arm64 (bcm2711_defconfig, GCC 10.2.0) and
powerpc (ps3_defconfig, GCC 12.2.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--DvcbpAMx1RoohX50
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEARYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCY8Yc/gAKCRD2uYlJVVFO
o+wIAQCm6LCIEDiRLBDdPRnkc4ubppdvhaGdUdIDnut/0mco1wEA6vE1WnwkqqT4
AGkzFsk1A6a3ZGzpxUn6jHVTMw+hZwc=
=OLbD
-----END PGP SIGNATURE-----

--DvcbpAMx1RoohX50--
