Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6359148EBC3
	for <lists+stable@lfdr.de>; Fri, 14 Jan 2022 15:37:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235485AbiANOhX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Jan 2022 09:37:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241666AbiANOhW (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Jan 2022 09:37:22 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0DD9C061574
        for <stable@vger.kernel.org>; Fri, 14 Jan 2022 06:37:22 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id n11so11473672plf.4
        for <stable@vger.kernel.org>; Fri, 14 Jan 2022 06:37:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=GW+d7qbRCihzWegcEgHmchRDGpLXULN52mf3CS1reME=;
        b=OyKud2fS5a2TCGvQuQsAXCvyv6itf7cuB76BeGZOgov5T2xzTIVgcRy+6Yzr0a2PJ/
         808Jb9+FXGYbh4txnEjSku+6nA4UlsVqcwlFNFATHgMyNhWkQzPxyZUz7lShdrHqyvlf
         v9OfJOtiG/U8fvQeHI6AQKbQDLuGyn1Y1W0ExBnzoNKgbpqmXuFhh0CM4yKMpZ77UOhy
         eiPb/DovL+qDaqLNDrj5XJCXRGTfnOYn4f9LbEQKRK07GIfzK70HQ4lpOcTYRqIF9/2m
         lP9KNuULeArJ0i7w3htf91GemmIw10EVqrdF+zr24YsEIUYlo5F43CbyJ2rVGdR5yF5K
         GifQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=GW+d7qbRCihzWegcEgHmchRDGpLXULN52mf3CS1reME=;
        b=5hj7w3asFLsu9aNnUIuPeDO8Kch9NDx5BMg7larTgYbU5JuOKjtWhFTayh2Sdso7E2
         vgrglThx76VFXPr0QTyoFHyPajtcuh8UOm1S06bd6fBWmCNfQmeZ/1AIgUhZCGlThaBT
         ydONxX6oZ3fR6eqDtXSJva/7UoaW3p7hYMPzRQyS+5LbUcqFML6g/V2O1huCjp+ze1Sw
         eZcIKfg3NmbOw8mn63SpMbMe0mf8tTuXY6bYhR4br7101w1VRDi2+/mvyeOyykhsqB0x
         4heE84ccj8CIPRs7OMstIBTYN3WpJ+KCNMswIAr1ZlBPxiBtVZ03+THV7ZtX9EG2tDfo
         40qg==
X-Gm-Message-State: AOAM531hbZl1JOMMf8uO6FyNDQPJuuouV1RYd7qhT0r2MLMadi5bfoBF
        l2umT7Hd6Sy4+AvZ9pU23rwlKfWI/SeDKjd3
X-Google-Smtp-Source: ABdhPJwxKLVqUCVycfvigcgFfnqdOmvJ5DA1QKs7Yb3IgjFJRAFfVevTEUMe2RPMIH9hbjYI5yziSQ==
X-Received: by 2002:a17:902:76c8:b0:14a:4a48:cac0 with SMTP id j8-20020a17090276c800b0014a4a48cac0mr9790831plt.90.1642171042078;
        Fri, 14 Jan 2022 06:37:22 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id em22sm5849334pjb.23.2022.01.14.06.37.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Jan 2022 06:37:21 -0800 (PST)
Message-ID: <61e18aa1.1c69fb81.d8ae.064d@mx.google.com>
Date:   Fri, 14 Jan 2022 06:37:21 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.14.262-11-g98bee0a22bc8
X-Kernelci-Branch: linux-4.14.y
Subject: stable-rc/linux-4.14.y baseline: 121 runs,
 1 regressions (v4.14.262-11-g98bee0a22bc8)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y baseline: 121 runs, 1 regressions (v4.14.262-11-g98b=
ee0a22bc8)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.14.y/ker=
nel/v4.14.262-11-g98bee0a22bc8/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.14.y
  Describe: v4.14.262-11-g98bee0a22bc8
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      98bee0a22bc868f17104046073a8e99169f03c1a =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61e155e4e779a72714ef6747

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
62-11-g98bee0a22bc8/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-p=
anda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
62-11-g98bee0a22bc8/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-p=
anda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61e155e4e779a72=
714ef674a
        failing since 0 day (last pass: v4.14.262, first fail: v4.14.262-9-=
gcd595a3cc321)
        2 lines

    2022-01-14T10:51:59.986080  [   19.973815] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2022-01-14T10:52:00.030783  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/103
    2022-01-14T10:52:00.040466  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
d3c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
