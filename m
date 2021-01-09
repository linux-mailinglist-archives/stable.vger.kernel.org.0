Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C50322F0341
	for <lists+stable@lfdr.de>; Sat,  9 Jan 2021 20:52:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726281AbhAITwX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 9 Jan 2021 14:52:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726058AbhAITwW (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 9 Jan 2021 14:52:22 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE180C061786
        for <stable@vger.kernel.org>; Sat,  9 Jan 2021 11:51:42 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id m5so8095027pjv.5
        for <stable@vger.kernel.org>; Sat, 09 Jan 2021 11:51:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=S5IKQDA6YQjHSR3Y2gLu7VyKKn6vR3kqkDz7mkFKYTU=;
        b=msTC3755/uXxl85nshhUWIzkIfNHHvzcpPIwi8a6sZbT3YSn1hjFJgBAueWITEinwZ
         9LcErowLRrabDEH7GD1GTEQ+daadMihXksdQ01RhwhOFxf+FTNiEtR/Iz/HcdmuEvAve
         rp2VZndEw/UVhEct5tuKkp0nFRpidpXXB8jqFPp8rmjWkODEeR87rVbSx9EbcNckLRmH
         yNX5CUuA7NCWBshaxOlca9vdhphQWvmhEQPU4p2mqKbdzDfO1RCj8tmtEZkxD9dAwhKT
         jxOIwrtbYYlay7wtnZ2ZZjcaVzgybOZJ9PzwVZvHBIVPFtaZm6mYWOGYsO7alCVDjnHp
         U6NQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=S5IKQDA6YQjHSR3Y2gLu7VyKKn6vR3kqkDz7mkFKYTU=;
        b=JskYwMxg3MtxRRfA2eHvGH/UGWGn43bks5tMmAnF2wGrbalYgQYBRiddykwtgH21uq
         OJJy+cvOayIkNEH/uuHWXrDd6bP3WJ7R7PJ/WMnT4R4qPimUPsG7js/MHtnAf4A5Aebb
         49p7lXiY5BOz/NWRrMMr3w2B1tINygY5DVOhViSx5M6/2b6eX35+mHjeKTBYyPlpc8aI
         tpZFW3cqfQdQCgj2vFtnU3+Zih71mD1KhsV8d45hAVi02Vrurz5KANd35RmiryUFjphz
         u3X+7OL48IJE4r0qBUFs6aY+JoARX9mbZ9zIlWFWV7K3pKAWBAukIKWQOBvTVeVg88eH
         KGoA==
X-Gm-Message-State: AOAM530AGhYKOxuP1UW2n1gjsMhLgm0/dV9biWK8x8CuUtIdISlC+WU9
        NRyPjN4O8OE0ZKM+Udmi7BWZMSL7kHl/iA==
X-Google-Smtp-Source: ABdhPJzEabYku+E2UhKPXW0u+dOYL9dfTcPnYlJiHThJP1IiQAGXChiXZNktyjHTDx0fUb6ieNBmZA==
X-Received: by 2002:a17:90a:2e83:: with SMTP id r3mr9621219pjd.112.1610221901967;
        Sat, 09 Jan 2021 11:51:41 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id a8sm13265840pfo.209.2021.01.09.11.51.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 09 Jan 2021 11:51:41 -0800 (PST)
Message-ID: <5ffa094d.1c69fb81.6d62f.e1bc@mx.google.com>
Date:   Sat, 09 Jan 2021 11:51:41 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.4
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.4.88-7-g95c496c789e3
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.4 baseline: 175 runs,
 5 regressions (v5.4.88-7-g95c496c789e3)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 175 runs, 5 regressions (v5.4.88-7-g95c496c78=
9e3)

Regressions Summary
-------------------

platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
hifive-unleashed-a00 | riscv | lab-baylibre  | gcc-8    | defconfig        =
   | 1          =

qemu_arm-versatilepb | arm   | lab-baylibre  | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-broonie   | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-cip       | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-collabora | gcc-8    | versatile_defconf=
ig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.88-7-g95c496c789e3/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.88-7-g95c496c789e3
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      95c496c789e3953b10cd915b08a27862cc38898c =



Test Regressions
---------------- =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
hifive-unleashed-a00 | riscv | lab-baylibre  | gcc-8    | defconfig        =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/5ff9d72e547d308bd9c94cf1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (riscv64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.88-7-=
g95c496c789e3/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleashed-=
a00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.88-7-=
g95c496c789e3/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleashed-=
a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/riscv/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5ff9d72e547d308bd9c94=
cf2
        failing since 50 days (last pass: v5.4.78-5-g843222460ebea, first f=
ail: v5.4.78-13-g81acf0f7c6ec) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-baylibre  | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/5ff9d49629bf883acbc94cc6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.88-7-=
g95c496c789e3/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-=
versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.88-7-=
g95c496c789e3/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-=
versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5ff9d49629bf883acbc94=
cc7
        failing since 56 days (last pass: v5.4.77-44-gce6b18c3a8969, first =
fail: v5.4.77-45-gfd610189f77e1) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-broonie   | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/5ff9d49182650be20cc94ce4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.88-7-=
g95c496c789e3/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-v=
ersatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.88-7-=
g95c496c789e3/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-v=
ersatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5ff9d49182650be20cc94=
ce5
        failing since 56 days (last pass: v5.4.77-44-gce6b18c3a8969, first =
fail: v5.4.77-45-gfd610189f77e1) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-cip       | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/5ff9d49029bf883acbc94cb9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.88-7-=
g95c496c789e3/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versa=
tilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.88-7-=
g95c496c789e3/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versa=
tilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5ff9d49029bf883acbc94=
cba
        failing since 56 days (last pass: v5.4.77-44-gce6b18c3a8969, first =
fail: v5.4.77-45-gfd610189f77e1) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-collabora | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/5ff9d44c450c09487bc94cc2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.88-7-=
g95c496c789e3/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.88-7-=
g95c496c789e3/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5ff9d44c450c09487bc94=
cc3
        failing since 56 days (last pass: v5.4.77-44-gce6b18c3a8969, first =
fail: v5.4.77-45-gfd610189f77e1) =

 =20
