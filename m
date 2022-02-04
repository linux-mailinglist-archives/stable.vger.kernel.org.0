Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 700EC4A9E6C
	for <lists+stable@lfdr.de>; Fri,  4 Feb 2022 18:57:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377213AbiBDR5o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Feb 2022 12:57:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377200AbiBDR5n (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Feb 2022 12:57:43 -0500
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AC9DC061714
        for <stable@vger.kernel.org>; Fri,  4 Feb 2022 09:57:43 -0800 (PST)
Received: by mail-pf1-x42c.google.com with SMTP id e6so5727768pfc.7
        for <stable@vger.kernel.org>; Fri, 04 Feb 2022 09:57:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=JsA9OHqdvtsFs1G/qs0nz2mtx/MOMmhPHjgMqkKSQKQ=;
        b=37BG9ng/oTf6kyyiUVjT1zil8pA+6mnuDfn+rHXz/p/c1l8bSrSzMy8fd8PtDSke1a
         OxjD/FWMv4bqEEqO2D68XWhVMdANd7eCgTmmHmQUcne+ms35PQhIsAK8FpXvBIJJ5xpD
         D61Q8qfAQsKgRg78MVLw1CgOC2m8i41UlBkNpaBihuSAz7+o17vGNGfv6Uh/B61n4LZC
         k+q5/T88NYmVhS/2op3WEdQGXf35WyBPlv8T40tQFKXXaMW3sqg12zAzrr1gO58dzDsk
         8EbDkkZoQs92re+ygOcirDM4pK8fxTWhHPHP2gcdjFSQKXlWUhNmS10b+Dt7HKImmmjy
         brdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=JsA9OHqdvtsFs1G/qs0nz2mtx/MOMmhPHjgMqkKSQKQ=;
        b=Jfbyz9G63n+gRnLjBZmLAxcJ537b+ttIJsClFSmdCZThmlYAj53R6Yjnab7/a6RM6d
         5G0tOhg+R7Z5t/LVB3J4AGCHiO5A/Q327JsSxCDLTrhBTbmKMaa7HfADQVQubE5ygV9I
         VLhXj0FpBLYtQ1tEuplslw/+Ss/1Kb+ASq9ONuFDrWk5V0od+UFwI1BalnwWYEUvNEqm
         Y3S8vgXnymJFx131bn00uirc/tTLM11emS59Q21ycKeysgMKH5hmgUvPu3JcGyyocltR
         CpaPXLOzPa/oi0G51Pj8C7J2nIDBPtWzVg6rDAgjRk12uCc8Fz+H8AeogACcPGJdd01Y
         OH+Q==
X-Gm-Message-State: AOAM533xBDPiwLENSXoNvxKhnitNGKVzhEEpShgfLto5UpAvk8q5LJVF
        5xC+Mol4Zg62fHxZTByLRLskaBuEyKEDxmey
X-Google-Smtp-Source: ABdhPJz4cgmk4W1Gdg+t5twS5/ZzPVcwqTLRx6hGrgWMxRcFWFgCjL2Qitufq6n57WYZtk5Sf1sANA==
X-Received: by 2002:a63:2a46:: with SMTP id q67mr103674pgq.595.1643997462742;
        Fri, 04 Feb 2022 09:57:42 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id x23sm3491079pfh.216.2022.02.04.09.57.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Feb 2022 09:57:42 -0800 (PST)
Message-ID: <61fd6916.1c69fb81.bc073.8ec6@mx.google.com>
Date:   Fri, 04 Feb 2022 09:57:42 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.4.176-11-gdb9bfa6e8ef5
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Branch: linux-5.4.y
Subject: stable-rc/linux-5.4.y baseline: 125 runs,
 5 regressions (v5.4.176-11-gdb9bfa6e8ef5)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.4.y baseline: 125 runs, 5 regressions (v5.4.176-11-gdb9bf=
a6e8ef5)

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
el/v5.4.176-11-gdb9bfa6e8ef5/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.4.y
  Describe: v5.4.176-11-gdb9bfa6e8ef5
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      db9bfa6e8ef56c7c343bcb51031ea93db5f8d157 =



Test Regressions
---------------- =



platform                 | arch  | lab          | compiler | defconfig     =
     | regressions
-------------------------+-------+--------------+----------+---------------=
-----+------------
hifive-unleashed-a00     | riscv | lab-baylibre | gcc-10   | defconfig     =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/61fd2d0f49181929225d6f0d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (riscv64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.176=
-11-gdb9bfa6e8ef5/riscv/defconfig/gcc-10/lab-baylibre/baseline-hifive-unlea=
shed-a00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.176=
-11-gdb9bfa6e8ef5/riscv/defconfig/gcc-10/lab-baylibre/baseline-hifive-unlea=
shed-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/riscv/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61fd2d0f49181929225d6=
f0e
        failing since 14 days (last pass: v5.4.171-35-g6a507169a5ff, first =
fail: v5.4.173) =

 =



platform                 | arch  | lab          | compiler | defconfig     =
     | regressions
-------------------------+-------+--------------+----------+---------------=
-----+------------
qemu_arm-virt-gicv2-uefi | arm   | lab-baylibre | gcc-10   | multi_v7_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/61fd2eadb378afff995d6f81

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.176=
-11-gdb9bfa6e8ef5/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_=
arm-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.176=
-11-gdb9bfa6e8ef5/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_=
arm-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61fd2eadb378afff995d6=
f82
        failing since 50 days (last pass: v5.4.165, first fail: v5.4.165-19=
-gb780ab989d60) =

 =



platform                 | arch  | lab          | compiler | defconfig     =
     | regressions
-------------------------+-------+--------------+----------+---------------=
-----+------------
qemu_arm-virt-gicv2-uefi | arm   | lab-broonie  | gcc-10   | multi_v7_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/61fd2e8122eb43ba875d6f57

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.176=
-11-gdb9bfa6e8ef5/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_a=
rm-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.176=
-11-gdb9bfa6e8ef5/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_a=
rm-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61fd2e8122eb43ba875d6=
f58
        failing since 50 days (last pass: v5.4.165, first fail: v5.4.165-19=
-gb780ab989d60) =

 =



platform                 | arch  | lab          | compiler | defconfig     =
     | regressions
-------------------------+-------+--------------+----------+---------------=
-----+------------
qemu_arm-virt-gicv3-uefi | arm   | lab-baylibre | gcc-10   | multi_v7_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/61fd2e8859662ff85e5d6f0a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.176=
-11-gdb9bfa6e8ef5/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_=
arm-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.176=
-11-gdb9bfa6e8ef5/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_=
arm-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61fd2e8859662ff85e5d6=
f0b
        failing since 50 days (last pass: v5.4.165, first fail: v5.4.165-19=
-gb780ab989d60) =

 =



platform                 | arch  | lab          | compiler | defconfig     =
     | regressions
-------------------------+-------+--------------+----------+---------------=
-----+------------
qemu_arm-virt-gicv3-uefi | arm   | lab-broonie  | gcc-10   | multi_v7_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/61fd2e8022eb43ba875d6f54

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.176=
-11-gdb9bfa6e8ef5/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_a=
rm-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.176=
-11-gdb9bfa6e8ef5/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_a=
rm-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61fd2e8022eb43ba875d6=
f55
        failing since 50 days (last pass: v5.4.165, first fail: v5.4.165-19=
-gb780ab989d60) =

 =20
