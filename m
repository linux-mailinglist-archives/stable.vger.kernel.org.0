Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87166342D75
	for <lists+stable@lfdr.de>; Sat, 20 Mar 2021 15:52:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229606AbhCTOwV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 20 Mar 2021 10:52:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229546AbhCTOwN (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 20 Mar 2021 10:52:13 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 129D7C061574
        for <stable@vger.kernel.org>; Sat, 20 Mar 2021 07:52:13 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id e33so5665249pgm.13
        for <stable@vger.kernel.org>; Sat, 20 Mar 2021 07:52:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=5WL5z3R6a9NlqFdPoHatF5+sxKypThXTLRSFGqoR/TU=;
        b=GlV9weGY1yW/soABgs7p2gZs9PO1IMFwYmy43L3CG4VJ/SMgJqEjXigDrp06R8L86h
         D74KoiARiqrN3d5l3xBCCCmBFE+A7ymfIYhs2YrF2eCHPbH+SatpZBICRt8+To8RflSh
         UAzyQBqO2aGSqF9hk+TWaSBRSDdtIbbmGbNHHyzYq6sz84uSWI9FO3/w6yLEJO4gJ6wx
         jOcK+KYZHPTC7Dbd+QfyWh9Omtn4Q+UFB151AyrTidOD4J5Cy4++5dlL4vY8jFGPKhpM
         5miUfe9qAvIKL8CApPZ7JpyPur0lbCB3KhrysIwyzJIk+p3jj5si6Vvht+5CHvdzQud4
         PLFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=5WL5z3R6a9NlqFdPoHatF5+sxKypThXTLRSFGqoR/TU=;
        b=oZviPmiB5wpEQ67hFwvfjlRZjotxyadPKJiQo94wV20f8KXdTJBKvLDx832y5tfIL/
         iQB+0au6fRDp/l1bJOEOXU5AKy/Tsvu3Mon7Ka0KsraMSH49NP70dy9h8xMpmJsaiMwQ
         XMkNyoj8caUohy0EayAoSRd8LrSLneugte2piYYejrvIIszwPX8Jf2+ruFf1mI6jIUY6
         /yzBE+DtgU9aILvIJImDwPhCDsbOqBhusum/rW1d1qhjqfAt6xOOOoAJOiK/WW60MX31
         JxHKQ3x2Cdz/xqsb0ALilrwnuLpbspU97lywKOFTlzMhhX6guHDb60LYWG05LF7xvylq
         83UQ==
X-Gm-Message-State: AOAM533G4+z075Bo86xjEQUEywm2uxWBkNwtM6kzrD8/BddFg9vA/7mx
        wfCnecujMpIi3q5uTVYkExY0dJJ2nYgwxw==
X-Google-Smtp-Source: ABdhPJywZBOvi0xrJrZ9vn85wFJv2fpCEF0jZA4H4YWaxMghRer/ssEr/bAJjP8oDoO987N3swSlzg==
X-Received: by 2002:aa7:88cb:0:b029:215:6f93:d220 with SMTP id k11-20020aa788cb0000b02902156f93d220mr2358714pff.36.1616251932315;
        Sat, 20 Mar 2021 07:52:12 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id e8sm8220231pgb.35.2021.03.20.07.52.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 20 Mar 2021 07:52:12 -0700 (PDT)
Message-ID: <60560c1c.1c69fb81.58139.3f8b@mx.google.com>
Date:   Sat, 20 Mar 2021 07:52:12 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.182
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-4.19.y
Subject: stable/linux-4.19.y baseline: 144 runs, 4 regressions (v4.19.182)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.19.y baseline: 144 runs, 4 regressions (v4.19.182)

Regressions Summary
-------------------

platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-4.19.y/kernel=
/v4.19.182/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-4.19.y
  Describe: v4.19.182
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      125222814e7b8f84df767d6ab622aff2a6d2f234 =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6055d41f60b3664492addcbc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.182/=
arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.182/=
arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6055d41f60b3664492add=
cbd
        failing since 121 days (last pass: v4.19.157, first fail: v4.19.158=
) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6055d42060b3664492addcbf

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.182/=
arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.182/=
arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6055d42060b3664492add=
cc0
        failing since 121 days (last pass: v4.19.157, first fail: v4.19.158=
) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6055d42660b3664492addcc5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.182/=
arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.182/=
arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6055d42660b3664492add=
cc6
        failing since 121 days (last pass: v4.19.157, first fail: v4.19.158=
) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6055d3b41387e7247caddccc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.182/=
arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilepb.t=
xt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.182/=
arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilepb.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6055d3b41387e7247cadd=
ccd
        failing since 121 days (last pass: v4.19.157, first fail: v4.19.158=
) =

 =20
