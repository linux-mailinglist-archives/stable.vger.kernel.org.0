Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 835CA362F72
	for <lists+stable@lfdr.de>; Sat, 17 Apr 2021 13:09:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230510AbhDQLIn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 17 Apr 2021 07:08:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231387AbhDQLIh (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 17 Apr 2021 07:08:37 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3101C061574
        for <stable@vger.kernel.org>; Sat, 17 Apr 2021 04:08:10 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id i190so20020900pfc.12
        for <stable@vger.kernel.org>; Sat, 17 Apr 2021 04:08:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=RQAgr53mMEe86loT8HpcqnoND36NPHUfCudVze74+QM=;
        b=MOqsF32IF5jCDvz/BfCKJ0wOaF5Wcbyruiw3chANsyM5X1KArsKx4OhoSxCblVtMH1
         sVEkbuo5A2eMdZ4CJBsrefM7zHAqA1pHmKa+8Ldvjd6Ng7wApyzRSoFPMyh2RpzcQcDK
         ZNgQB/c3oh8MFwj7GiEy2aNDYxMhv7qB9CD8ZYSOclAeZGC+1tTAu1po0kvU7rWwjSYL
         kNP3oKcOPhwVkLfvqqgHlPd7ugajT4tPFDvCKUXAQ8PQyRvE91qE/bBWZpQip+6hdrNC
         H6KwSPAGnWlyB8mstZbrcsUom/aT3BPZkBMBLrH8geLO9EeTA7OORE4diP9a0lhFTDOW
         OjUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=RQAgr53mMEe86loT8HpcqnoND36NPHUfCudVze74+QM=;
        b=cybfzX+Ms8ItrCn4MuXQyj4i0U0BRko/X+Wa4ICDA0ynyVFuMf2nAXZp7E0+ehJ5hL
         szcshuKSzRdEbss2iN7jaY0b9lz9NpXrKHDOnLtcpJsK/YCegQmknFJoqu1qHDJdAc/R
         0Qz31N3i1QupKsadNk4iki0XvC661VPc1clT7gT13/9jcpN8hMubMIKFe9xl9O6v+vd2
         iykM73zvKGfT58ZTYYjDcYXed0KZW24ehz0jgWC2x9jqIPAXI318Ghps4x2V6q3JYfWK
         hfr6UIqxgNj4YNZM+8nNCSRnR45ipq+3MNe10Ozbm6VrvY2hlN6vl4z6F+EGBnO/qvUi
         p80w==
X-Gm-Message-State: AOAM530YdGlwtJYbsiW8ZwpT9P/fAXzQBySjVcMIezbDsphgAQI9zop7
        JeoZ0IMRHiLHnu9WhS8bbNx0IbABaSNLxeIR
X-Google-Smtp-Source: ABdhPJwSY20NHpGObLT8owY0DWIi6Vs0JezTegyBrj2Qxg53a0LZjTH9KGr+eh2W2nq5fpyBt630qw==
X-Received: by 2002:a63:4ca:: with SMTP id 193mr3239492pge.86.1618657690376;
        Sat, 17 Apr 2021 04:08:10 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 63sm398375pfx.202.2021.04.17.04.08.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 17 Apr 2021 04:08:10 -0700 (PDT)
Message-ID: <607ac19a.1c69fb81.36aa2.09ef@mx.google.com>
Date:   Sat, 17 Apr 2021 04:08:10 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.4.113
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-5.4.y baseline: 149 runs, 4 regressions (v5.4.113)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.4.y baseline: 149 runs, 4 regressions (v5.4.113)

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.4.y/kern=
el/v5.4.113/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.4.y
  Describe: v5.4.113
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      ab3bed80f9d34641966eaa329fc7b296a21dab07 =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/607a8d1fbfb13906b6dac6b2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.113=
/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb.t=
xt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.113=
/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/607a8d1fbfb13906b6dac=
6b3
        failing since 153 days (last pass: v5.4.77-44-g28fe0e171c204, first=
 fail: v5.4.77-46-ga3e34830d912) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/607a8cf6ab6b3e61b4dac6ce

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.113=
/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.113=
/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/607a8cf6ab6b3e61b4dac=
6cf
        failing since 153 days (last pass: v5.4.77-44-g28fe0e171c204, first=
 fail: v5.4.77-46-ga3e34830d912) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/607a8ce4ab6b3e61b4dac6b1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.113=
/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.113=
/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/607a8ce4ab6b3e61b4dac=
6b2
        failing since 153 days (last pass: v5.4.77-44-g28fe0e171c204, first=
 fail: v5.4.77-46-ga3e34830d912) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/607a8c934560b276f1dac6d6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.113=
/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilepb.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.113=
/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilepb.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/607a8c934560b276f1dac=
6d7
        failing since 153 days (last pass: v5.4.77-44-g28fe0e171c204, first=
 fail: v5.4.77-46-ga3e34830d912) =

 =20
