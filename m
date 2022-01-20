Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 171BF495429
	for <lists+stable@lfdr.de>; Thu, 20 Jan 2022 19:27:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347037AbiATS0s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Jan 2022 13:26:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346666AbiATS0k (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Jan 2022 13:26:40 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69C1FC06161C
        for <stable@vger.kernel.org>; Thu, 20 Jan 2022 10:26:40 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id q63so2063710pja.1
        for <stable@vger.kernel.org>; Thu, 20 Jan 2022 10:26:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=xRD87nJc9/P8x0VaUOO5c+anxiRgcVUNvhYBb1xKfFs=;
        b=llZMhz6WbX6ZYSfJMeicRVztuv9029pVK1zF7HiaO/cnZ2SCwYo/nD0L4RXNSK2fR2
         jzZ9RQKMYpv5B6+df2xwB2Gty/TDSQf0eMMcoTqB3TIhTR5yWOZdL7mbkfNvFQln+Azb
         nN/uIPebnpfqBQ4fq+ibwNiuSZL3brHYM1Pner+wscH5hLQwkbb+PJhcbFoSBYtDuuqp
         EXvawVutkUUwNHGGtDeW4VFeNihOHdgj0aprXMBRh1bC/v9+8h77rtaJ54s+oih7U4Bl
         5t/FF5/tHrOdrdfgCHOSt8myak8OGZz0p3GTftkQPmuoakfq/NaPnxh1PV6AVbYv6Lo7
         9hDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=xRD87nJc9/P8x0VaUOO5c+anxiRgcVUNvhYBb1xKfFs=;
        b=EZv55Nfrk/94/ODTjoWtD7iP0NVkx99ULMKhb6jFAZVbqJp2H6pG2VWf0Rj7ZOlYQj
         Dna5qYShNiJheZpMevkQ/iPZE9xZO/o08ZaJH6Dj5Eo6r3qUMN9jLpPDFFh4y6dEptxi
         XxVyL0fgxnteK7oXwj7lSLCBnTiWr+Rrxjz3UyLwrU8I3Ce8eQ7U94skHYfBqqii80p+
         rKwdmcgExZ2d7gtKCuOKHVKcJCD+9Jj0EAQnd2L/xinub64ISriISAAmK1egR2XRuy3I
         odpuHLcbjKiOFFOw7nueZlo6VfHUxAfHM7jCBsgCKR1VENYJaU7IEAhULnHm1AxmDroK
         0oEg==
X-Gm-Message-State: AOAM531qKf+BNJau17zcJ5mpAXjF8eNJmbCCViIjIsz7LCrj6A8fPwgG
        Ufj2gbgpzpc13a4xEVTi+xkBZkD/JRxPqy0c
X-Google-Smtp-Source: ABdhPJzQJHeY8zkTituUnW27yxIx7unnfS1kOlh8/xZG8OYP1pulGX8u5JKQ2q/a+6iW/XQBbkmNHg==
X-Received: by 2002:a17:902:7605:b0:14b:1c9:1c1e with SMTP id k5-20020a170902760500b0014b01c91c1emr270736pll.163.1642703199749;
        Thu, 20 Jan 2022 10:26:39 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id g9sm4237608pfc.110.2022.01.20.10.26.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Jan 2022 10:26:39 -0800 (PST)
Message-ID: <61e9a95f.1c69fb81.b7802.b7ef@mx.google.com>
Date:   Thu, 20 Jan 2022 10:26:39 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.4.173
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.4.y
Subject: stable-rc/linux-5.4.y baseline: 165 runs, 5 regressions (v5.4.173)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.4.y baseline: 165 runs, 5 regressions (v5.4.173)

Regressions Summary
-------------------

platform                 | arch  | lab          | compiler | defconfig     =
     | regressions
-------------------------+-------+--------------+----------+---------------=
-----+------------
hifive-unleashed-a00     | riscv | lab-baylibre | gcc-10   | defconfig     =
     | 1          =

qemu_arm-virt-gicv2-uefi | arm   | lab-baylibre | gcc-10   | multi_v7_defco=
nfig | 1          =

qemu_arm-virt-gicv2-uefi | arm   | lab-broonie  | gcc-10   | multi_v7_defco=
nfig | 1          =

qemu_arm-virt-gicv3-uefi | arm   | lab-baylibre | gcc-10   | multi_v7_defco=
nfig | 1          =

qemu_arm-virt-gicv3-uefi | arm   | lab-broonie  | gcc-10   | multi_v7_defco=
nfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.4.y/kern=
el/v5.4.173/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.4.y
  Describe: v5.4.173
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      4aa2e7393e140f434c469bffe478e11cb9c55ed8 =



Test Regressions
---------------- =



platform                 | arch  | lab          | compiler | defconfig     =
     | regressions
-------------------------+-------+--------------+----------+---------------=
-----+------------
hifive-unleashed-a00     | riscv | lab-baylibre | gcc-10   | defconfig     =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/61e97020bb327a11a4abbd2b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (riscv64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.173=
/riscv/defconfig/gcc-10/lab-baylibre/baseline-hifive-unleashed-a00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.173=
/riscv/defconfig/gcc-10/lab-baylibre/baseline-hifive-unleashed-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220115.0/riscv/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61e97020bb327a11a4abb=
d2c
        new failure (last pass: v5.4.171-35-g6a507169a5ff) =

 =



platform                 | arch  | lab          | compiler | defconfig     =
     | regressions
-------------------------+-------+--------------+----------+---------------=
-----+------------
qemu_arm-virt-gicv2-uefi | arm   | lab-baylibre | gcc-10   | multi_v7_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/61e972730ba422ce5cabbd31

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.173=
/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_arm-virt-gicv2-ue=
fi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.173=
/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_arm-virt-gicv2-ue=
fi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220115.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61e972730ba422ce5cabb=
d32
        failing since 35 days (last pass: v5.4.165, first fail: v5.4.165-19=
-gb780ab989d60) =

 =



platform                 | arch  | lab          | compiler | defconfig     =
     | regressions
-------------------------+-------+--------------+----------+---------------=
-----+------------
qemu_arm-virt-gicv2-uefi | arm   | lab-broonie  | gcc-10   | multi_v7_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/61e972579a631b3d3eabbd43

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.173=
/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm-virt-gicv2-uef=
i.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.173=
/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm-virt-gicv2-uef=
i.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220115.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61e972579a631b3d3eabb=
d44
        failing since 35 days (last pass: v5.4.165, first fail: v5.4.165-19=
-gb780ab989d60) =

 =



platform                 | arch  | lab          | compiler | defconfig     =
     | regressions
-------------------------+-------+--------------+----------+---------------=
-----+------------
qemu_arm-virt-gicv3-uefi | arm   | lab-baylibre | gcc-10   | multi_v7_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/61e972740ba422ce5cabbd37

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.173=
/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_arm-virt-gicv3-ue=
fi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.173=
/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_arm-virt-gicv3-ue=
fi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220115.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61e972740ba422ce5cabb=
d38
        failing since 35 days (last pass: v5.4.165, first fail: v5.4.165-19=
-gb780ab989d60) =

 =



platform                 | arch  | lab          | compiler | defconfig     =
     | regressions
-------------------------+-------+--------------+----------+---------------=
-----+------------
qemu_arm-virt-gicv3-uefi | arm   | lab-broonie  | gcc-10   | multi_v7_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/61e9727d93da1a8c73abbd28

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.173=
/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm-virt-gicv3-uef=
i.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.173=
/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm-virt-gicv3-uef=
i.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220115.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61e9727d93da1a8c73abb=
d29
        failing since 35 days (last pass: v5.4.165, first fail: v5.4.165-19=
-gb780ab989d60) =

 =20
