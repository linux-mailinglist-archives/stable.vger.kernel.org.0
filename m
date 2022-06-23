Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35FA955887D
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 21:16:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229840AbiFWTQv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 15:16:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229643AbiFWTQg (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 15:16:36 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 126046272C
        for <stable@vger.kernel.org>; Thu, 23 Jun 2022 11:20:53 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id l6so10692269plg.11
        for <stable@vger.kernel.org>; Thu, 23 Jun 2022 11:20:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=kYeK9XTCSR1VuJnfc/Ib0M544/tS1iryCN9cOc/k/L8=;
        b=VkH4Lczwg2yDk6o0mwe4Xyp7j74JXlIyKQod8buOdq6fHls0bvBYdbgPRhCn50Blnz
         MuJEJraCCWF6hnxyDAybQ+nLsYQ3VJjofeS1GqLGpD5eEMCB0do+rYlYc2JZbJlKUXia
         zKEoKJ3DpSNr0MgWaeBcWHkiUOQqtpmesEnNyM+JtbYqQaM+FnDVC4Wn+cJPugQtnl2f
         hN4u9CpX0MDLf8rKREWF11RUKRM9Kbi6QMBxXJLaGv0O3qqXdWUMGFqrJla/SLWKWtni
         6bxyeVcswAXXJo6rf17xZkWSA4exQ4kts0G+ZBz8Bp8FH56dIsy3Cbr6arH8AP5FlpAz
         1Fmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=kYeK9XTCSR1VuJnfc/Ib0M544/tS1iryCN9cOc/k/L8=;
        b=LXAsTRIQGIiqFRy5nAQY0wteTjS84siyRDUyXw8bcEiYOHUEnu7kC4XR5lMi+ei7WN
         7CNTUqIWdPSEuTRYI9RGHInABXeyTwTLaWIVH+t4hWWX3VRYbgBrZHrODr0isub8JPyI
         FP2Ts5wJjZWuYpQuGmHFhfm0pp0Upe1L5/Xf4T2ezOoSC9z4uVd5xoLr1jMtOowo14lu
         yTJkyLFWiAasNoG/2MOXCMtvftxoy8BOkcPjPjfGIHhWD4FuyN2oI0VIG55zIKPWSe+4
         +8f9jsnEBQPu+9dxK88btb0lBLrJqHgK8biGLniXaVmuDRSQhMX5mXJeSVkNSxEvTIWa
         pDnw==
X-Gm-Message-State: AJIora+NA8i3oTn9SABHI4Fksb2vGvNVY+1rD8R+X5aDr4uU0MBGsR+p
        Z++ugcyIED0kmfev5BbNNNq+yYc9kehnO4eCJnc=
X-Google-Smtp-Source: AGRyM1smmfRmV0mqiOOCGBue/lXBShZbuTG2EFQkmrGNLqArLleufa8Est/cdPXPdM+Pc20aiFhLZQ==
X-Received: by 2002:a17:903:11c6:b0:167:90e5:59c2 with SMTP id q6-20020a17090311c600b0016790e559c2mr39618070plh.50.1656008452820;
        Thu, 23 Jun 2022 11:20:52 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b14-20020aa7810e000000b0052527ca27b2sm8815515pfi.143.2022.06.23.11.20.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jun 2022 11:20:51 -0700 (PDT)
Message-ID: <62b4af03.1c69fb81.e1b15.d5aa@mx.google.com>
Date:   Thu, 23 Jun 2022 11:20:51 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.19.248-225-gee5f4486fd9e0
X-Kernelci-Branch: queue/4.19
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.19 baseline: 89 runs,
 10 regressions (v4.19.248-225-gee5f4486fd9e0)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 89 runs, 10 regressions (v4.19.248-225-gee5f=
4486fd9e0)

Regressions Summary
-------------------

platform                     | arch  | lab          | compiler | defconfig =
      | regressions
-----------------------------+-------+--------------+----------+-----------=
------+------------
jetson-tk1                   | arm   | lab-baylibre | gcc-10   | tegra_defc=
onfig | 1          =

meson-gxl-s905x-libretech-cc | arm64 | lab-broonie  | gcc-10   | defconfig =
      | 1          =

qemu_arm64-virt-gicv2        | arm64 | lab-baylibre | gcc-10   | defconfig =
      | 1          =

qemu_arm64-virt-gicv2        | arm64 | lab-broonie  | gcc-10   | defconfig =
      | 1          =

qemu_arm64-virt-gicv2-uefi   | arm64 | lab-baylibre | gcc-10   | defconfig =
      | 1          =

qemu_arm64-virt-gicv2-uefi   | arm64 | lab-broonie  | gcc-10   | defconfig =
      | 1          =

qemu_arm64-virt-gicv3        | arm64 | lab-baylibre | gcc-10   | defconfig =
      | 1          =

qemu_arm64-virt-gicv3        | arm64 | lab-broonie  | gcc-10   | defconfig =
      | 1          =

qemu_arm64-virt-gicv3-uefi   | arm64 | lab-baylibre | gcc-10   | defconfig =
      | 1          =

qemu_arm64-virt-gicv3-uefi   | arm64 | lab-broonie  | gcc-10   | defconfig =
      | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.248-225-gee5f4486fd9e0/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.248-225-gee5f4486fd9e0
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      ee5f4486fd9e012cb983bff05d2e0a3aca1d92c8 =



Test Regressions
---------------- =



platform                     | arch  | lab          | compiler | defconfig =
      | regressions
-----------------------------+-------+--------------+----------+-----------=
------+------------
jetson-tk1                   | arm   | lab-baylibre | gcc-10   | tegra_defc=
onfig | 1          =


  Details:     https://kernelci.org/test/plan/id/62b379698f798ba321a39bd4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: tegra_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.248=
-225-gee5f4486fd9e0/arm/tegra_defconfig/gcc-10/lab-baylibre/baseline-jetson=
-tk1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.248=
-225-gee5f4486fd9e0/arm/tegra_defconfig/gcc-10/lab-baylibre/baseline-jetson=
-tk1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220610.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62b379698f798ba321a39=
bd5
        failing since 6 days (last pass: v4.19.246-288-g495edb43ebcc4, firs=
t fail: v4.19.247-16-g570bbfee860d2) =

 =



platform                     | arch  | lab          | compiler | defconfig =
      | regressions
-----------------------------+-------+--------------+----------+-----------=
------+------------
meson-gxl-s905x-libretech-cc | arm64 | lab-broonie  | gcc-10   | defconfig =
      | 1          =


  Details:     https://kernelci.org/test/plan/id/62b335d705e6d367c3a39bd0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.248=
-225-gee5f4486fd9e0/arm64/defconfig/gcc-10/lab-broonie/baseline-meson-gxl-s=
905x-libretech-cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.248=
-225-gee5f4486fd9e0/arm64/defconfig/gcc-10/lab-broonie/baseline-meson-gxl-s=
905x-libretech-cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220610.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62b335d705e6d367c3a39=
bd1
        failing since 64 days (last pass: v4.19.238-22-gb215381f8cf05, firs=
t fail: v4.19.238-32-g4d86c9395c31a) =

 =



platform                     | arch  | lab          | compiler | defconfig =
      | regressions
-----------------------------+-------+--------------+----------+-----------=
------+------------
qemu_arm64-virt-gicv2        | arm64 | lab-baylibre | gcc-10   | defconfig =
      | 1          =


  Details:     https://kernelci.org/test/plan/id/62b335811c770a38b7a39bdc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.248=
-225-gee5f4486fd9e0/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64=
-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.248=
-225-gee5f4486fd9e0/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64=
-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220610.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62b335811c770a38b7a39=
bdd
        failing since 43 days (last pass: v4.19.241-58-g5e77acf6dbb6, first=
 fail: v4.19.241-83-g0ec5709aa1da) =

 =



platform                     | arch  | lab          | compiler | defconfig =
      | regressions
-----------------------------+-------+--------------+----------+-----------=
------+------------
qemu_arm64-virt-gicv2        | arm64 | lab-broonie  | gcc-10   | defconfig =
      | 1          =


  Details:     https://kernelci.org/test/plan/id/62b335adfb85478d4da39be8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.248=
-225-gee5f4486fd9e0/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-=
virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.248=
-225-gee5f4486fd9e0/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-=
virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220610.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62b335adfb85478d4da39=
be9
        failing since 43 days (last pass: v4.19.241-58-g5e77acf6dbb6, first=
 fail: v4.19.241-83-g0ec5709aa1da) =

 =



platform                     | arch  | lab          | compiler | defconfig =
      | regressions
-----------------------------+-------+--------------+----------+-----------=
------+------------
qemu_arm64-virt-gicv2-uefi   | arm64 | lab-baylibre | gcc-10   | defconfig =
      | 1          =


  Details:     https://kernelci.org/test/plan/id/62b3357ffb85478d4da39bd7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.248=
-225-gee5f4486fd9e0/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64=
-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.248=
-225-gee5f4486fd9e0/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64=
-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220610.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62b3357ffb85478d4da39=
bd8
        failing since 43 days (last pass: v4.19.241-58-g5e77acf6dbb6, first=
 fail: v4.19.241-83-g0ec5709aa1da) =

 =



platform                     | arch  | lab          | compiler | defconfig =
      | regressions
-----------------------------+-------+--------------+----------+-----------=
------+------------
qemu_arm64-virt-gicv2-uefi   | arm64 | lab-broonie  | gcc-10   | defconfig =
      | 1          =


  Details:     https://kernelci.org/test/plan/id/62b335711c770a38b7a39bcd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.248=
-225-gee5f4486fd9e0/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-=
virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.248=
-225-gee5f4486fd9e0/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-=
virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220610.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62b335711c770a38b7a39=
bce
        failing since 43 days (last pass: v4.19.241-58-g5e77acf6dbb6, first=
 fail: v4.19.241-83-g0ec5709aa1da) =

 =



platform                     | arch  | lab          | compiler | defconfig =
      | regressions
-----------------------------+-------+--------------+----------+-----------=
------+------------
qemu_arm64-virt-gicv3        | arm64 | lab-baylibre | gcc-10   | defconfig =
      | 1          =


  Details:     https://kernelci.org/test/plan/id/62b335821c770a38b7a39bdf

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.248=
-225-gee5f4486fd9e0/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64=
-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.248=
-225-gee5f4486fd9e0/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64=
-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220610.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62b335821c770a38b7a39=
be0
        failing since 43 days (last pass: v4.19.241-58-g5e77acf6dbb6, first=
 fail: v4.19.241-83-g0ec5709aa1da) =

 =



platform                     | arch  | lab          | compiler | defconfig =
      | regressions
-----------------------------+-------+--------------+----------+-----------=
------+------------
qemu_arm64-virt-gicv3        | arm64 | lab-broonie  | gcc-10   | defconfig =
      | 1          =


  Details:     https://kernelci.org/test/plan/id/62b335ae16c051deaca39be8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.248=
-225-gee5f4486fd9e0/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-=
virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.248=
-225-gee5f4486fd9e0/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-=
virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220610.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62b335ae16c051deaca39=
be9
        failing since 43 days (last pass: v4.19.241-58-g5e77acf6dbb6, first=
 fail: v4.19.241-83-g0ec5709aa1da) =

 =



platform                     | arch  | lab          | compiler | defconfig =
      | regressions
-----------------------------+-------+--------------+----------+-----------=
------+------------
qemu_arm64-virt-gicv3-uefi   | arm64 | lab-baylibre | gcc-10   | defconfig =
      | 1          =


  Details:     https://kernelci.org/test/plan/id/62b335801c770a38b7a39bd9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.248=
-225-gee5f4486fd9e0/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64=
-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.248=
-225-gee5f4486fd9e0/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64=
-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220610.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62b335801c770a38b7a39=
bda
        failing since 43 days (last pass: v4.19.241-58-g5e77acf6dbb6, first=
 fail: v4.19.241-83-g0ec5709aa1da) =

 =



platform                     | arch  | lab          | compiler | defconfig =
      | regressions
-----------------------------+-------+--------------+----------+-----------=
------+------------
qemu_arm64-virt-gicv3-uefi   | arm64 | lab-broonie  | gcc-10   | defconfig =
      | 1          =


  Details:     https://kernelci.org/test/plan/id/62b335851c770a38b7a39be2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.248=
-225-gee5f4486fd9e0/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-=
virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.248=
-225-gee5f4486fd9e0/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-=
virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220610.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62b335851c770a38b7a39=
be3
        failing since 43 days (last pass: v4.19.241-58-g5e77acf6dbb6, first=
 fail: v4.19.241-83-g0ec5709aa1da) =

 =20
