Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CCD14885AD
	for <lists+stable@lfdr.de>; Sat,  8 Jan 2022 20:47:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232518AbiAHTr4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 8 Jan 2022 14:47:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232473AbiAHTr4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 8 Jan 2022 14:47:56 -0500
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86404C06173F
        for <stable@vger.kernel.org>; Sat,  8 Jan 2022 11:47:55 -0800 (PST)
Received: by mail-pl1-x632.google.com with SMTP id c3so8562804pls.5
        for <stable@vger.kernel.org>; Sat, 08 Jan 2022 11:47:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=yo63TOKmMfa+pD8grUKwrHOi0PExmMRVO+CV3ahr2po=;
        b=zCAf0X7ayumxy2UpMtV2MTIYeg/XghwmxaxSbpEZvOtQLqFidlZ3ypKIGlLwMAzkxJ
         F4mOI95Kdg52VFyS4uQJk+gv/yix78ZWkT+p4D4kcCvLzneXygs7Vt3nt/fT4+y5gwFH
         OrQe5Xlr8O1Td/6QTHQaBasFine4N6N7Suq8p4x2hbjSLgOIMVL98qB6swTyZ37gQ+Pt
         gQemB0Zzw0Sq4PjZmkM2xpzvfWOmyN/muGygZ+IASXNWkR9kueN6GniekzIJNzHHBpQc
         Rser5xtbYnTskUU/sPw8BIuPGCzeeD/i0Lrvm/J/ThpSJRXDTf1LL1AaUIOqE3hiNlT9
         5J3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=yo63TOKmMfa+pD8grUKwrHOi0PExmMRVO+CV3ahr2po=;
        b=dGVPPDeUxCo3lVqVGRRwWlPwAagmaV/AELBfiC9BQob4oGNRcXvFFbBZBwc7w0hs24
         aVQDE87mxlcGe3tdluVvB2Agbygl/kO5txSqmJFbqfuv/85/Af0TLSFUpBn1WxLXU5L1
         +zg8G7X4UycgqUTQgBOfxPMg8pRoOPPMUeaFfToJIAESWA+dl5YQs9VXLuOXxxW6/H+L
         wVEHe69Xp7RoszdxeSZHoaZkbnico/Ws/O8fumXeqTBzNix5x00AnGTrpCx1pIVw3NCg
         mZkZPUhGrwk1SluAtyd0Iw7BCNeEqPTCEo43TedmqSa+sKUzCaGez9jUIxBGCI5lemNe
         Kixg==
X-Gm-Message-State: AOAM530wB6ucVnvRiRMoee0ep/ZZqoIoeKIIpyBY/TtMrVMlvFiPGyon
        xVmMxH7dKP6Nz+WUIxF9Z24T3HvDqycE9jaB
X-Google-Smtp-Source: ABdhPJxsHc/wvgTS8S17Ze7cR5Q+uLTOBOFpRTXPzJi1p1G9gbtLPtXckBgWhe/nsY9vuyIdVNPviw==
X-Received: by 2002:a17:903:8b:b0:14a:2b58:ad7b with SMTP id o11-20020a170903008b00b0014a2b58ad7bmr83300pld.163.1641671274921;
        Sat, 08 Jan 2022 11:47:54 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id nl10sm2785797pjb.54.2022.01.08.11.47.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 08 Jan 2022 11:47:54 -0800 (PST)
Message-ID: <61d9ea6a.1c69fb81.54087.657c@mx.google.com>
Date:   Sat, 08 Jan 2022 11:47:54 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.4.170-21-g2336f5435a9b
X-Kernelci-Branch: queue/5.4
Subject: stable-rc/queue/5.4 baseline: 163 runs,
 4 regressions (v5.4.170-21-g2336f5435a9b)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 163 runs, 4 regressions (v5.4.170-21-g2336f54=
35a9b)

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.170-21-g2336f5435a9b/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.170-21-g2336f5435a9b
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      2336f5435a9b5c49e2276d7c691af2bc801215cb =



Test Regressions
---------------- =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv2-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61d9b4f3f286314495ef6775

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.170-2=
1-g2336f5435a9b/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.170-2=
1-g2336f5435a9b/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61d9b4f3f286314495ef6=
776
        failing since 23 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv2-uefi | arm  | lab-broonie  | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61d9b51fb644f9908eef673e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.170-2=
1-g2336f5435a9b/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm=
-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.170-2=
1-g2336f5435a9b/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm=
-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61d9b51fb644f9908eef6=
73f
        failing since 23 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv3-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61d9b4c78c1ee5f148ef6776

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.170-2=
1-g2336f5435a9b/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.170-2=
1-g2336f5435a9b/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61d9b4c78c1ee5f148ef6=
777
        failing since 23 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv3-uefi | arm  | lab-broonie  | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61d9b4e3f286314495ef674a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.170-2=
1-g2336f5435a9b/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm=
-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.170-2=
1-g2336f5435a9b/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm=
-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61d9b4e3f286314495ef6=
74b
        failing since 23 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =20
