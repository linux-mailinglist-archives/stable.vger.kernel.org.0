Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB2972F041B
	for <lists+stable@lfdr.de>; Sat,  9 Jan 2021 23:27:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726215AbhAIW1f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 9 Jan 2021 17:27:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726210AbhAIW1e (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 9 Jan 2021 17:27:34 -0500
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F0ECC061786
        for <stable@vger.kernel.org>; Sat,  9 Jan 2021 14:26:54 -0800 (PST)
Received: by mail-pl1-x62b.google.com with SMTP id g3so7556114plp.2
        for <stable@vger.kernel.org>; Sat, 09 Jan 2021 14:26:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=maUi3rW0bNdKwZ9lrg2EQDZ/kVyPoO1Rzfh4gqHrbfI=;
        b=hF7WkcHy3K+WCRux1S7jWu3ETiCbLN0KTr/sANoUNftq9BFmxkPFcyYP5WiswcN1yL
         haLkS+Wt/tGy/pcPhFV0E1abW3QEv1zBTofBLLXAD3xOQ9YKoSnuzfwsWaOeASoCxSnE
         Q6KWa5xYOQWZ5E/kAWFXQh7tWsqRMGMD1MvoLZN65c3PLHKNDPB9B5zmvPymYsrF/Sfh
         GU2mvSA2I6q+WlRiGjTH+VTemr5yqGrAHBeNS/umYsaWORHz118o5+JfRfpuhkiqXTIE
         Sb0t8BazN2pZvYCDAxAGjeEKYPacM8ogwyHBT7Q3Qf1UnuhjAPu64+AvEnxxJuiRIfPk
         9x5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=maUi3rW0bNdKwZ9lrg2EQDZ/kVyPoO1Rzfh4gqHrbfI=;
        b=g4A65fbhde/onq9qCX5thfuBB0oVW49WtzG/KqE1R3e6Jkq76mnyrxaMSdgGhewd0/
         2XP5/WKPajfCrxomXF7RRx+mDTP8sav1jfRWGItOt0bLljQtb9+oxc/sjrmtttFUcoFB
         zGO7eHOACiqkn6Vn00QSCytpUwuTTE6v0Kdma+CjommoWwSedIGMbbOfVMdqK+KE9xpr
         +5b2FNE63ePvFxBgOg0hX0vo3XMOMHJDWyppKLvuucfee4up6lbjPPhc+mqw2EX+N+u4
         9ObLFc9fdJOVYBW+ulyy9PEk+kDQg2TGVAjgS/0wq5PP1QrJuvMZtCvBajBwQVYXOXyL
         TaNA==
X-Gm-Message-State: AOAM531tKgJOWRZJ0H7jAduQwdB3Di1VSVkSq3ro2GW4EiRXkMX23e5X
        ddUAW5nfLA7z4YVfi9C+qn6GqS7on58tPA==
X-Google-Smtp-Source: ABdhPJw8DnsJzPjh0/ZNbHOKobGxBVlYOzd2Ct2gt8oyxmtc0qJmodZkwPmydU62D4hyFScVtkHL1w==
X-Received: by 2002:a17:902:eac1:b029:da:88ce:f38f with SMTP id p1-20020a170902eac1b02900da88cef38fmr10082822pld.42.1610231213691;
        Sat, 09 Jan 2021 14:26:53 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id d6sm13052484pfd.69.2021.01.09.14.26.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 09 Jan 2021 14:26:53 -0800 (PST)
Message-ID: <5ffa2dad.1c69fb81.999fd.cdb3@mx.google.com>
Date:   Sat, 09 Jan 2021 14:26:53 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.4
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.4.88-9-gc0d3cc027f90
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.4 baseline: 166 runs,
 6 regressions (v5.4.88-9-gc0d3cc027f90)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 166 runs, 6 regressions (v5.4.88-9-gc0d3cc027=
f90)

Regressions Summary
-------------------

platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
hifive-unleashed-a00 | riscv | lab-baylibre  | gcc-8    | defconfig        =
   | 1          =

meson-gxm-q200       | arm64 | lab-baylibre  | gcc-8    | defconfig        =
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
el/v5.4.88-9-gc0d3cc027f90/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.88-9-gc0d3cc027f90
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      c0d3cc027f9045b9a84e046b5fefc35f83db0de4 =



Test Regressions
---------------- =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
hifive-unleashed-a00 | riscv | lab-baylibre  | gcc-8    | defconfig        =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/5ff9f1a108e4244258c94cde

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (riscv64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.88-9-=
gc0d3cc027f90/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleashed-=
a00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.88-9-=
gc0d3cc027f90/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleashed-=
a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/riscv/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5ff9f1a108e4244258c94=
cdf
        failing since 50 days (last pass: v5.4.78-5-g843222460ebea, first f=
ail: v5.4.78-13-g81acf0f7c6ec) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
meson-gxm-q200       | arm64 | lab-baylibre  | gcc-8    | defconfig        =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/5ffa0ae3e34648c335c94cb9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.88-9-=
gc0d3cc027f90/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.88-9-=
gc0d3cc027f90/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q200.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5ffa0ae3e34648c335c94=
cba
        new failure (last pass: v5.4.88-7-g95c496c789e3) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-baylibre  | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/5ff9f20bc2875f42d9c94ceb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.88-9-=
gc0d3cc027f90/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-=
versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.88-9-=
gc0d3cc027f90/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-=
versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5ff9f20bc2875f42d9c94=
cec
        failing since 56 days (last pass: v5.4.77-44-gce6b18c3a8969, first =
fail: v5.4.77-45-gfd610189f77e1) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-broonie   | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/5ff9f21a65b47c441bc94cdd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.88-9-=
gc0d3cc027f90/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-v=
ersatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.88-9-=
gc0d3cc027f90/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-v=
ersatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5ff9f21a65b47c441bc94=
cde
        failing since 56 days (last pass: v5.4.77-44-gce6b18c3a8969, first =
fail: v5.4.77-45-gfd610189f77e1) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-cip       | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/5ff9f210c2875f42d9c94d0b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.88-9-=
gc0d3cc027f90/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versa=
tilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.88-9-=
gc0d3cc027f90/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versa=
tilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5ff9f210c2875f42d9c94=
d0c
        failing since 56 days (last pass: v5.4.77-44-gce6b18c3a8969, first =
fail: v5.4.77-45-gfd610189f77e1) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-collabora | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/5ff9f1e54024b8ac78c94ce4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.88-9-=
gc0d3cc027f90/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.88-9-=
gc0d3cc027f90/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5ff9f1e54024b8ac78c94=
ce5
        failing since 56 days (last pass: v5.4.77-44-gce6b18c3a8969, first =
fail: v5.4.77-45-gfd610189f77e1) =

 =20
