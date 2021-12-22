Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13C5947D5A3
	for <lists+stable@lfdr.de>; Wed, 22 Dec 2021 18:17:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239438AbhLVRRP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Dec 2021 12:17:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235936AbhLVRRN (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Dec 2021 12:17:13 -0500
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48DB7C061574
        for <stable@vger.kernel.org>; Wed, 22 Dec 2021 09:17:13 -0800 (PST)
Received: by mail-pf1-x435.google.com with SMTP id v11so2977287pfu.2
        for <stable@vger.kernel.org>; Wed, 22 Dec 2021 09:17:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=XsiFqwFtQnfAhJdhaHO4u59jNoR4V9+pfkSae0fo3fY=;
        b=rsrLBClJb49wtlnRPF/lAatUHaOmYoUDC5FiSpLdxn5uBII8UDmBwtM5vwCjxKiU67
         X9jiHpByNaqZfsh5XyJiB65JkjUOViftMKo76qyKQGoAlmzOW8IeWysbkUewt3/8gPtg
         JgnYbue3H+f4JNXL3qf8z+TszoHqFO7fO38FwqupWmYj0h+qU4bnlYacKD/xbKqHLaBs
         1/bRqnCbK31EnBuRbSqGo28hgxIG5clUBO7a0qIs/VZ3L5q+N2hGDuLmGYm+tqY3N58N
         BSHikwfvMAartzTPSHy1TXcL5FunlUuLusaK2678Yr2ahaDH8AHLy8nVDEqL4Wf8RLnc
         oyVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=XsiFqwFtQnfAhJdhaHO4u59jNoR4V9+pfkSae0fo3fY=;
        b=Sm9C9OoKfy+9aRyiYmfO3njCXoA2u7uvYYk0tDWl3RzH1VXeq4jVftt4juzFv7HgwV
         lrOwgaLpO0vKV6jb24XPcVX5RAdco3H3i5eesFm3kMLCSRl2BPrbFGJduHgXfDcBYMVA
         JB7omt3j8b/UkVwWIvqll1zY+12CUroIXpmefGGSt2AmzvHwO2j4ItHMOXa9ckPkZMBA
         pJ3rVkK/jJaqV04PubbYUTZ3ewUzQJbiHjS9xLdMYLVK6SPxaVXh+48+cU5ovWz+lxt9
         5tuqUeeE8PrE/n+rHJFVU2oOcsfN8c0UA8nMqL1RlXpu8qIAzuOhAB8QKsbs5SsLj43N
         iLIA==
X-Gm-Message-State: AOAM5328y4fi15oKr0ZkZnYPsEvhGQKZlXCpAlfJHzL9RaAEz1rLexDg
        TAzJCG0hrhoisA95CX8755qZY9t7M9DyVIlqi1c=
X-Google-Smtp-Source: ABdhPJymoB3Irx2yFwbBPAt72NuEGCfqvubfGo20SymOHMdBI4fB65X//6q+oqUm9x1xuUlnCZq2yQ==
X-Received: by 2002:a63:824a:: with SMTP id w71mr3625200pgd.74.1640193432642;
        Wed, 22 Dec 2021 09:17:12 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id cu18sm6216382pjb.53.2021.12.22.09.17.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Dec 2021 09:17:12 -0800 (PST)
Message-ID: <61c35d98.1c69fb81.23f50.0eb6@mx.google.com>
Date:   Wed, 22 Dec 2021 09:17:12 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.4.168-2-gc8f74f54fa07
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/5.4
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.4 baseline: 189 runs,
 5 regressions (v5.4.168-2-gc8f74f54fa07)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 189 runs, 5 regressions (v5.4.168-2-gc8f74f54=
fa07)

Regressions Summary
-------------------

platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
n...6-chromebook | 1          =

qemu_arm-virt-gicv2-uefi | arm    | lab-baylibre  | gcc-10   | multi_v7_def=
config           | 1          =

qemu_arm-virt-gicv2-uefi | arm    | lab-broonie   | gcc-10   | multi_v7_def=
config           | 1          =

qemu_arm-virt-gicv3-uefi | arm    | lab-baylibre  | gcc-10   | multi_v7_def=
config           | 1          =

qemu_arm-virt-gicv3-uefi | arm    | lab-broonie   | gcc-10   | multi_v7_def=
config           | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.168-2-gc8f74f54fa07/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.168-2-gc8f74f54fa07
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      c8f74f54fa07abf831daf8003680cf6d21ed89a4 =



Test Regressions
---------------- =



platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
n...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/61c3231685eeef117d397171

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.168-2=
-gc8f74f54fa07/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/=
baseline-minnowboard-turbot-E3826.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.168-2=
-gc8f74f54fa07/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/=
baseline-minnowboard-turbot-E3826.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61c3231685eeef117d397=
172
        new failure (last pass: v5.4.167-71-g2668f7ae1c9f) =

 =



platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
qemu_arm-virt-gicv2-uefi | arm    | lab-baylibre  | gcc-10   | multi_v7_def=
config           | 1          =


  Details:     https://kernelci.org/test/plan/id/61c3267e9cd1368d3839713f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.168-2=
-gc8f74f54fa07/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_arm=
-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.168-2=
-gc8f74f54fa07/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_arm=
-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61c3267e9cd1368d38397=
140
        failing since 6 days (last pass: v5.4.165-9-g27d736c7bdee, first fa=
il: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
qemu_arm-virt-gicv2-uefi | arm    | lab-broonie   | gcc-10   | multi_v7_def=
config           | 1          =


  Details:     https://kernelci.org/test/plan/id/61c3268f8d067c91bf39714f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.168-2=
-gc8f74f54fa07/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm-=
virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.168-2=
-gc8f74f54fa07/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm-=
virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61c3268f8d067c91bf397=
150
        failing since 6 days (last pass: v5.4.165-9-g27d736c7bdee, first fa=
il: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
qemu_arm-virt-gicv3-uefi | arm    | lab-baylibre  | gcc-10   | multi_v7_def=
config           | 1          =


  Details:     https://kernelci.org/test/plan/id/61c326b97fcff13dc1397124

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.168-2=
-gc8f74f54fa07/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_arm=
-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.168-2=
-gc8f74f54fa07/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_arm=
-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61c326b97fcff13dc1397=
125
        failing since 6 days (last pass: v5.4.165-9-g27d736c7bdee, first fa=
il: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
qemu_arm-virt-gicv3-uefi | arm    | lab-broonie   | gcc-10   | multi_v7_def=
config           | 1          =


  Details:     https://kernelci.org/test/plan/id/61c326b4525d9fa3eb397157

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.168-2=
-gc8f74f54fa07/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm-=
virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.168-2=
-gc8f74f54fa07/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm-=
virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61c326b4525d9fa3eb397=
158
        failing since 6 days (last pass: v5.4.165-9-g27d736c7bdee, first fa=
il: v5.4.165-18-ge938927511cb) =

 =20
