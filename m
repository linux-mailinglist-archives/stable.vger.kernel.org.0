Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8E825FBF25
	for <lists+stable@lfdr.de>; Wed, 12 Oct 2022 04:24:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229506AbiJLCYe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Oct 2022 22:24:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229490AbiJLCYd (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Oct 2022 22:24:33 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E24DA487F;
        Tue, 11 Oct 2022 19:24:32 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id d24so14970211pls.4;
        Tue, 11 Oct 2022 19:24:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=iuu19vNPsdKZJ7tUMTlg7a+dW8+2WEUouEX5Ysyg0gY=;
        b=bR83FdKc/UPG4CVWKH0yJvVuh4i+G095sL3+MiYXf7RZ9s/mOfT5SB92K6LBzF5POv
         3fVny9oQ6rgsuBYpP38fdKT66Izo+s4JD/xTn/wjYQr/anyf1v9IOb5WqvW3pM7XQN8o
         05eduyNHfgiOJfhPZpQAOJevQHB6Lnk/kpBWR/umcPb2ZmVrrXi58ZRRbJev89Eryz7n
         qF/LtVjfGLHc0ctMsPXqnc8DpEoyPgmww+NQpDrhBKrpZh3cXhzlKspEfOyHL0Nid4xR
         SBmsH6KIucwenTkMRzukOdczknPbuTw7LJwnIWkOK0Wyp/6cT/pAc+EmRhayHcPMTdAO
         lleg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iuu19vNPsdKZJ7tUMTlg7a+dW8+2WEUouEX5Ysyg0gY=;
        b=CYQ3hRG8zAozJjDyKCOGNZX7/Cq7VSEdISNN7o4OJatAjayi97YRlbSiDx7J+NVHK0
         QZTcplmZud8a9KelEQ5eNQqWT7FDd+Cdk3KzmdRV9CwtXaA77bgI9ni++hGuEmE3JI+r
         vBpWvamhQbDkg5S8rhUtdirXMSGa5GGwUQ9Rr4/CxUvz2z53nYTt6Hg0FEu8B9xtdklZ
         cqswDPEewoyJ8irtppgiCn7cqNCTUi90Wz/SMRiDkhrUHYZeWYhbjOM/Ri1tLthDSsCB
         HXNBfrbQw3WTnqsjdbNjgy1TZei+PEfSBk71/0aFCk1/cD4YFPXpt+WTEEmXGL1ggyZk
         6/Dw==
X-Gm-Message-State: ACrzQf2Om0ZacEtjK5czJFvuArfulv3B3OZBFvMAV9ny7cz3k8qu06kj
        0aN3pN/4R8ihjq1nHg+ieA4=
X-Google-Smtp-Source: AMsMyM57Rs4H8t3P5/pReG3+s9TZJgDlJeDj5OPdsn4ktepgUxsDceG2SA/oR/y3GrIZ8RU9FpXA+A==
X-Received: by 2002:a17:90a:1b0d:b0:20d:69b1:70c3 with SMTP id q13-20020a17090a1b0d00b0020d69b170c3mr2472366pjq.5.1665541471811;
        Tue, 11 Oct 2022 19:24:31 -0700 (PDT)
Received: from debian.me (subs03-180-214-233-91.three.co.id. [180.214.233.91])
        by smtp.gmail.com with ESMTPSA id z18-20020a170903019200b00176c6738d13sm5815859plg.169.2022.10.11.19.24.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Oct 2022 19:24:31 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
        id ECD4D103687; Wed, 12 Oct 2022 09:24:27 +0700 (WIB)
Date:   Wed, 12 Oct 2022 09:24:27 +0700
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net
Subject: Re: [PATCH 5.15 00/37] 5.15.73-rc1 review
Message-ID: <Y0YlW/PZDH4NRzUP@debian.me>
References: <20221010070331.211113813@linuxfoundation.org>
 <Y0Tv0S3zfZlEtii2@debian.me>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="8WqC/1b9AYVVSfgK"
Content-Disposition: inline
In-Reply-To: <Y0Tv0S3zfZlEtii2@debian.me>
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--8WqC/1b9AYVVSfgK
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 11, 2022 at 11:23:45AM +0700, Bagas Sanjaya wrote:
> On Mon, Oct 10, 2022 at 09:05:19AM +0200, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.15.73 release.
> > There are 37 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >=20
>=20
> Successfully cross-compiled for arm64 (bcm2711_defconfig, GCC 10.2.0) and
> powerpc (ps3_defconfig, GCC 12.1.0).
>=20
> Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>
>=20

Oops, replied to wrong -rc; please ignore the trailer above.

--=20
An old man doll... just what I always wanted! - Clara

--8WqC/1b9AYVVSfgK
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCY0YlVwAKCRD2uYlJVVFO
oysPAQD4lH6Xj5RnBuPl7zyyMlNjDOFkAtcB92AJSFQ1cq5yswEA+ZwNHoU6CJZ5
miGTY5pE2Gdfdltd2DeYgs/NUUb7CAI=
=46e3
-----END PGP SIGNATURE-----

--8WqC/1b9AYVVSfgK--
