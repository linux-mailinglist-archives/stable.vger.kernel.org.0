Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D50DD3E3BB5
	for <lists+stable@lfdr.de>; Sun,  8 Aug 2021 18:53:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231357AbhHHQxg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 8 Aug 2021 12:53:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230201AbhHHQxg (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 8 Aug 2021 12:53:36 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECF64C061760
        for <stable@vger.kernel.org>; Sun,  8 Aug 2021 09:53:16 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id bo18so2141216pjb.0
        for <stable@vger.kernel.org>; Sun, 08 Aug 2021 09:53:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=uiUz1PNXBfPv70t9s5avfSdTfksmE9xyzqjqwj/Tji4=;
        b=Uxbch4Qy0CJH/JLzQQEKDywNYaqxAkMmHs1qnDFIIEdansTPY8z0obHLAJZ7eFgGqw
         XZkfGzSy8737tJ76Kdg7GF2U6fQB4rF0Vst4ZX7lZYQqDSA7n7fidJ76ARekUJZDXFyU
         DarYNpvDc/hLLlvxOXA4yi3NyDDBmLWwMc0TeGaGvEPTOibYrZzmNf/IRcTbmyLofGIV
         POzt8gsQ7hr6DaMK9arYcn30N3C+htWE+RYb4PdyeSmke+g9S/vf4MpUEU35WPyTZ77t
         zsqsDL9zU42OQxbuLW8Q3kL7pptHKmw2GqF4VCSW95QO84Gu17oD+v36vRSDT6r8pDjz
         91LA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=uiUz1PNXBfPv70t9s5avfSdTfksmE9xyzqjqwj/Tji4=;
        b=H0l74YFnapKd87WybPuA8MWVcsfgAZK8wuOPGRnMfsAkqwj4niHEEeVteUwC01ATRX
         Y+mdsUURBcGdIYCZHmGwZEIyGJXfvGF4q6Ef2Xg/kTsLEwiuTEm3epaaCcK2F/d0CdVr
         /pNTYOwFW/7IyE6/tngg9j6tuk2vv6jujBI8hOND//nff8cGbMEbhVNImTnHkCPlbt/d
         WPPam/Acm5CclPBxgBsuybTNf7qRmixpk2VJ/Fbw5YNOLdqN9N0MNkRt+X4bm53UrC/j
         iwvhauocKCM52j6bo/1BTcmtoBBeT4BOAlEqve7Oxymx9CH55KMiwAmTlUG6VTkW3J+a
         Pgqg==
X-Gm-Message-State: AOAM531c8xVTIWVQj7GJSp6MEvtMJEZL0PgUxD6RSjkA3Uobs7ETPIuw
        JctdmIcxMWEUV4QRuQ4bx6yPbkXQnaQQ52Hp
X-Google-Smtp-Source: ABdhPJx8hwzPbA2D/Ca3JCJJXjdsBbf3BJk5le0ZcHx+KOW+VVqxWQbdbYX+PlPEfGPWVjoPWKWrfw==
X-Received: by 2002:a63:5506:: with SMTP id j6mr256729pgb.19.1628441596304;
        Sun, 08 Aug 2021 09:53:16 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id d31sm19999396pgd.33.2021.08.08.09.53.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 Aug 2021 09:53:15 -0700 (PDT)
Message-ID: <61100bfb.1c69fb81.a00e5.a8a0@mx.google.com>
Date:   Sun, 08 Aug 2021 09:53:15 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Tree: stable
X-Kernelci-Kernel: v4.4.279
X-Kernelci-Report-Type: test
Subject: stable/linux-4.4.y baseline: 78 runs, 7 regressions (v4.4.279)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.4.y baseline: 78 runs, 7 regressions (v4.4.279)

Regressions Summary
-------------------

platform            | arch | lab             | compiler | defconfig        =
  | regressions
--------------------+------+-----------------+----------+------------------=
--+------------
dove-cubox          | arm  | lab-pengutronix | gcc-8    | mvebu_v7_defconfi=
g | 1          =

qemu_arm-virt-gicv2 | arm  | lab-baylibre    | gcc-8    | multi_v7_defconfi=
g | 1          =

qemu_arm-virt-gicv2 | arm  | lab-broonie     | gcc-8    | multi_v7_defconfi=
g | 1          =

qemu_arm-virt-gicv2 | arm  | lab-linaro-lkft | gcc-8    | multi_v7_defconfi=
g | 1          =

qemu_arm-virt-gicv3 | arm  | lab-baylibre    | gcc-8    | multi_v7_defconfi=
g | 1          =

qemu_arm-virt-gicv3 | arm  | lab-broonie     | gcc-8    | multi_v7_defconfi=
g | 1          =

qemu_arm-virt-gicv3 | arm  | lab-linaro-lkft | gcc-8    | multi_v7_defconfi=
g | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-4.4.y/kernel/=
v4.4.279/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-4.4.y
  Describe: v4.4.279
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      aff9d4e6115abc1732aef71bea36cf3beb9b2c53 =



Test Regressions
---------------- =



platform            | arch | lab             | compiler | defconfig        =
  | regressions
--------------------+------+-----------------+----------+------------------=
--+------------
dove-cubox          | arm  | lab-pengutronix | gcc-8    | mvebu_v7_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/610fd37820a2445746b1366d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: mvebu_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.4.y/v4.4.279/ar=
m/mvebu_v7_defconfig/gcc-8/lab-pengutronix/baseline-dove-cubox.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.4.y/v4.4.279/ar=
m/mvebu_v7_defconfig/gcc-8/lab-pengutronix/baseline-dove-cubox.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/610fd37820a2445746b13=
66e
        failing since 2 days (last pass: v4.4.276, first fail: v4.4.278) =

 =



platform            | arch | lab             | compiler | defconfig        =
  | regressions
--------------------+------+-----------------+----------+------------------=
--+------------
qemu_arm-virt-gicv2 | arm  | lab-baylibre    | gcc-8    | multi_v7_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/610fd3bca88936287bb1368e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.4.y/v4.4.279/ar=
m/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.4.y/v4.4.279/ar=
m/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/610fd3bca88936287bb13=
68f
        failing since 259 days (last pass: v4.4.243, first fail: v4.4.245) =

 =



platform            | arch | lab             | compiler | defconfig        =
  | regressions
--------------------+------+-----------------+----------+------------------=
--+------------
qemu_arm-virt-gicv2 | arm  | lab-broonie     | gcc-8    | multi_v7_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/611000692dd8df7b6eb1366f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.4.y/v4.4.279/ar=
m/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.4.y/v4.4.279/ar=
m/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/611000692dd8df7b6eb13=
670
        failing since 259 days (last pass: v4.4.243, first fail: v4.4.245) =

 =



platform            | arch | lab             | compiler | defconfig        =
  | regressions
--------------------+------+-----------------+----------+------------------=
--+------------
qemu_arm-virt-gicv2 | arm  | lab-linaro-lkft | gcc-8    | multi_v7_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/610fed915a5ab51238b13667

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.4.y/v4.4.279/ar=
m/multi_v7_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_arm-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.4.y/v4.4.279/ar=
m/multi_v7_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_arm-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/610fed915a5ab51238b13=
668
        failing since 259 days (last pass: v4.4.243, first fail: v4.4.245) =

 =



platform            | arch | lab             | compiler | defconfig        =
  | regressions
--------------------+------+-----------------+----------+------------------=
--+------------
qemu_arm-virt-gicv3 | arm  | lab-baylibre    | gcc-8    | multi_v7_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/610fd4480269a7f923b13676

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.4.y/v4.4.279/ar=
m/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.4.y/v4.4.279/ar=
m/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/610fd4480269a7f923b13=
677
        failing since 259 days (last pass: v4.4.243, first fail: v4.4.245) =

 =



platform            | arch | lab             | compiler | defconfig        =
  | regressions
--------------------+------+-----------------+----------+------------------=
--+------------
qemu_arm-virt-gicv3 | arm  | lab-broonie     | gcc-8    | multi_v7_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6110013240d17b2c79b1366f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.4.y/v4.4.279/ar=
m/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.4.y/v4.4.279/ar=
m/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6110013240d17b2c79b13=
670
        failing since 259 days (last pass: v4.4.243, first fail: v4.4.245) =

 =



platform            | arch | lab             | compiler | defconfig        =
  | regressions
--------------------+------+-----------------+----------+------------------=
--+------------
qemu_arm-virt-gicv3 | arm  | lab-linaro-lkft | gcc-8    | multi_v7_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/610feda40cab5189afb13662

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.4.y/v4.4.279/ar=
m/multi_v7_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_arm-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.4.y/v4.4.279/ar=
m/multi_v7_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_arm-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/610feda40cab5189afb13=
663
        failing since 259 days (last pass: v4.4.243, first fail: v4.4.245) =

 =20
