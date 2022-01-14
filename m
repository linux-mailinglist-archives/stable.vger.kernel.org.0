Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BFDF48E4C5
	for <lists+stable@lfdr.de>; Fri, 14 Jan 2022 08:16:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233610AbiANHQ1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Jan 2022 02:16:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230454AbiANHQ1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Jan 2022 02:16:27 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12F18C061574
        for <stable@vger.kernel.org>; Thu, 13 Jan 2022 23:16:27 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id y16-20020a17090a6c9000b001b13ffaa625so21196918pjj.2
        for <stable@vger.kernel.org>; Thu, 13 Jan 2022 23:16:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=BVxT4u6mCp2gqpiHZA3LrA2tLwDk23h38VMGKIb2LLU=;
        b=f8ImesM0gS1In8somfD69V/Sl54bKuGrFK1v3ugZd++EjRcCDXNVdPZjnjE3yhfzT6
         Yu6yGSyR28uIh5Y4AM//NtRvbMi6vh9iT/3pjLQ6exT0GHECO/CbndsswB0QGgbVy8d1
         p1fNg1ykAFAmaOwLVlVpPbSG1DP/fewn0qwG7ShPCytzq+RNtfOdRkXbZiEXAwXKJPgw
         +M6ogxVY2FlISlfULlHePZUzs62sm0MMsx8dADNGQWm2FOUwd9w4rwZgJD+GUOQGUokM
         MqTuSpl3BChWD96h7staTv96HR5BS9NH1stASYIs2fx3RQqnTBbWeI3/d+rZv9SRNbYv
         vaLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=BVxT4u6mCp2gqpiHZA3LrA2tLwDk23h38VMGKIb2LLU=;
        b=QXdjsun9MruIAVP0QcxG6xjKx8aTWCLcdv8CEBK7VZlbAiq/BaiC0AdPVHHU74QSaw
         nN4DFIeRnM6KSoUvrSPTRg+DTly8llXhRrDmurTNRIthYClKseHw/eeBxt8HxaZHjpdg
         6wj5fF9dmeW0tkY/LUe9ygqFH8eT3IOHLbKObwdd/BxHHnnMC9YytPpYoINqH3gsy93S
         ovhEmxrTa3ACb0ZAGJ8d77ZSWbD0oVEhHcgH38Xxunkv7UgnXoYUvdZjUA3oBKHKE2Wt
         T1iuLlLFYwh11hGpVZsEzLt+DLpVywRGecXp3V1lo55t+8mq/jRujHj/y3b/QoCVHr7L
         L55Q==
X-Gm-Message-State: AOAM5331O0btiqkDe4Pm3cuipQngCmk8Qr3jIRnr0aq0jT4UxrObgVlr
        S7JMRVLqDBvt7rWLTSHtY94qhjP2uuaPqTpXCLQ=
X-Google-Smtp-Source: ABdhPJzC5FRxvMz6xqF9Hav6B/lJ+wkXXjLKJPfFd4w/vAjZqHx9a5qq4K9BAGY7sCQ1OX2ts1dZfA==
X-Received: by 2002:a17:902:db08:b0:14a:8983:e3c1 with SMTP id m8-20020a170902db0800b0014a8983e3c1mr4107038plx.100.1642144586365;
        Thu, 13 Jan 2022 23:16:26 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id j2sm4217676pjs.33.2022.01.13.23.16.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Jan 2022 23:16:26 -0800 (PST)
Message-ID: <61e1234a.1c69fb81.47354.d247@mx.google.com>
Date:   Thu, 13 Jan 2022 23:16:26 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.4.171-16-gf92eff28192a
X-Kernelci-Branch: linux-5.4.y
Subject: stable-rc/linux-5.4.y baseline: 158 runs,
 4 regressions (v5.4.171-16-gf92eff28192a)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.4.y baseline: 158 runs, 4 regressions (v5.4.171-16-gf92ef=
f28192a)

Regressions Summary
-------------------

platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv2-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =

qemu_arm-virt-gicv2-uefi | arm  | lab-broonie  | gcc-10   | multi_v7_defcon=
fig | 1          =

qemu_arm-virt-gicv3-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =

qemu_arm-virt-gicv3-uefi | arm  | lab-broonie  | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.4.y/kern=
el/v5.4.171-16-gf92eff28192a/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.4.y
  Describe: v5.4.171-16-gf92eff28192a
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      f92eff28192a2ec61af1498113bad4f7586d1905 =



Test Regressions
---------------- =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv2-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61e0f013e4542361fbef673e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.171=
-16-gf92eff28192a/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_=
arm-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.171=
-16-gf92eff28192a/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_=
arm-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61e0f013e4542361fbef6=
73f
        failing since 29 days (last pass: v5.4.165, first fail: v5.4.165-19=
-gb780ab989d60) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv2-uefi | arm  | lab-broonie  | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61e0f0299fba46bd0cef676e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.171=
-16-gf92eff28192a/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_a=
rm-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.171=
-16-gf92eff28192a/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_a=
rm-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61e0f0299fba46bd0cef6=
76f
        failing since 29 days (last pass: v5.4.165, first fail: v5.4.165-19=
-gb780ab989d60) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv3-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61e0f0129fba46bd0cef6747

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.171=
-16-gf92eff28192a/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_=
arm-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.171=
-16-gf92eff28192a/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_=
arm-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61e0f0129fba46bd0cef6=
748
        failing since 29 days (last pass: v5.4.165, first fail: v5.4.165-19=
-gb780ab989d60) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv3-uefi | arm  | lab-broonie  | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61e0f027e4542361fbef6754

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.171=
-16-gf92eff28192a/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_a=
rm-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.171=
-16-gf92eff28192a/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_a=
rm-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61e0f027e4542361fbef6=
755
        failing since 29 days (last pass: v5.4.165, first fail: v5.4.165-19=
-gb780ab989d60) =

 =20
