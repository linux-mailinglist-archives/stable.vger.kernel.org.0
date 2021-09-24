Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83CEC417921
	for <lists+stable@lfdr.de>; Fri, 24 Sep 2021 18:55:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235474AbhIXQ5R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Sep 2021 12:57:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230319AbhIXQ5P (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Sep 2021 12:57:15 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB9C8C061571
        for <stable@vger.kernel.org>; Fri, 24 Sep 2021 09:55:42 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id k26so4804106pfi.5
        for <stable@vger.kernel.org>; Fri, 24 Sep 2021 09:55:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=St6bqd+AHdxQX0Q3aTY4pYou3d7LJHiJQ6KLJhZ9JSs=;
        b=1EGpMx/gto1b2s4SGA8Yf/SqfD7Prwm0WZqbXf9TXSD0mpyg+/N0MRHNdEbtnrmwZd
         5Cfs6QANAykAwhpofzwy6LGcIvfVxvk968i20INcVv8J8f9LH/gYUj+sYZWeAzcwxkkz
         O8nAWcXQdc5GQ0/PUZZ1ScwesJr3zxFPM5PDvaNo/r3FtM+A0QUAVAZiqqqgWig5sJx0
         EzCQtM6FqJAbAr4qZlkhRQ1gocfR18iM2g8WqgZZ8Czov64HSFbtFwzCdMLryGh1ZuRs
         ep2psE9DPvP87CtsjOCoIbGuMbH4bsIEqA5CvLU5Z+HLtO4T1AsXxUpm+3Y299i5LjWJ
         kDtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=St6bqd+AHdxQX0Q3aTY4pYou3d7LJHiJQ6KLJhZ9JSs=;
        b=OzzWSbrh6thiDebZzn5YK9kpybdww7IUOcmZAyJBNwqweJbyAaql4nELL8bQ/SLi/n
         STEdjEyKDqt6lH+UD0asXDUgl6zf45PKIsUXsUCKhfOElT+GW4kEfO0lHOmFatgLKpCg
         QqhA9c+d5OAdto7dKUm9YWNzCGksRCA4Z/6INiEUlLcs+jm6GcZ4qJddJc3VUmOMOm1f
         fUEc3Dr2x5SbGfA5uk3UkdSNRPahlHQT1qEHSoRYPYoqNLsb48MYYAEgzasukPFA+kwy
         ajeXSCazFP3yxNBDC63jTp3Qta3p+QN+Quj6leKHWPQrvJbn0de5cSLTLThplIU/NwVx
         Qblg==
X-Gm-Message-State: AOAM531oyQmDA7JafEIMTltQFFtMDsd5bHRqbwM2q+z9bzpdnI9/qqV3
        uN5oxuCPE58QFhKJEflPY0Vz3oCP2E6q/MvZ
X-Google-Smtp-Source: ABdhPJxbH/fvbYVDunhk4sTbn01WNOnHeGmFRu0vFEA9+dQYHaYPIEefaHvOkm1iFSmxsxef803koQ==
X-Received: by 2002:a62:cf02:0:b0:447:d4d5:db39 with SMTP id b2-20020a62cf02000000b00447d4d5db39mr10627775pfg.67.1632502541960;
        Fri, 24 Sep 2021 09:55:41 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id l11sm12139846pjg.22.2021.09.24.09.55.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Sep 2021 09:55:41 -0700 (PDT)
Message-ID: <614e030d.1c69fb81.c58e1.8087@mx.google.com>
Date:   Fri, 24 Sep 2021 09:55:41 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.4.284-9-g002a7b8e43b1
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.4
Subject: stable-rc/queue/4.4 baseline: 61 runs,
 6 regressions (v4.4.284-9-g002a7b8e43b1)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 baseline: 61 runs, 6 regressions (v4.4.284-9-g002a7b8e4=
3b1)

Regressions Summary
-------------------

platform            | arch | lab          | compiler | defconfig          |=
 regressions
--------------------+------+--------------+----------+--------------------+=
------------
qemu_arm-virt-gicv2 | arm  | lab-baylibre | gcc-8    | multi_v7_defconfig |=
 1          =

qemu_arm-virt-gicv2 | arm  | lab-broonie  | gcc-8    | multi_v7_defconfig |=
 1          =

qemu_arm-virt-gicv2 | arm  | lab-cip      | gcc-8    | multi_v7_defconfig |=
 1          =

qemu_arm-virt-gicv3 | arm  | lab-baylibre | gcc-8    | multi_v7_defconfig |=
 1          =

qemu_arm-virt-gicv3 | arm  | lab-broonie  | gcc-8    | multi_v7_defconfig |=
 1          =

qemu_arm-virt-gicv3 | arm  | lab-cip      | gcc-8    | multi_v7_defconfig |=
 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.4/kern=
el/v4.4.284-9-g002a7b8e43b1/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.4
  Describe: v4.4.284-9-g002a7b8e43b1
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      002a7b8e43b170c395b94a1a8725bdfbeca5b4f2 =



Test Regressions
---------------- =



platform            | arch | lab          | compiler | defconfig          |=
 regressions
--------------------+------+--------------+----------+--------------------+=
------------
qemu_arm-virt-gicv2 | arm  | lab-baylibre | gcc-8    | multi_v7_defconfig |=
 1          =


  Details:     https://kernelci.org/test/plan/id/614dce14b3e6577e5099a2e5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.284-9=
-g002a7b8e43b1/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-=
virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.284-9=
-g002a7b8e43b1/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-=
virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/614dce14b3e6577e5099a=
2e6
        failing since 314 days (last pass: v4.4.243-18-gfc7e8c68369a, first=
 fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch | lab          | compiler | defconfig          |=
 regressions
--------------------+------+--------------+----------+--------------------+=
------------
qemu_arm-virt-gicv2 | arm  | lab-broonie  | gcc-8    | multi_v7_defconfig |=
 1          =


  Details:     https://kernelci.org/test/plan/id/614dcf16b95d93a19899a2f5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.284-9=
-g002a7b8e43b1/arm/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-v=
irt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.284-9=
-g002a7b8e43b1/arm/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-v=
irt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/614dcf16b95d93a19899a=
2f6
        failing since 314 days (last pass: v4.4.243-18-gfc7e8c68369a, first=
 fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch | lab          | compiler | defconfig          |=
 regressions
--------------------+------+--------------+----------+--------------------+=
------------
qemu_arm-virt-gicv2 | arm  | lab-cip      | gcc-8    | multi_v7_defconfig |=
 1          =


  Details:     https://kernelci.org/test/plan/id/614dce59b3f0c66e4799a30a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.284-9=
-g002a7b8e43b1/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-virt-=
gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.284-9=
-g002a7b8e43b1/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-virt-=
gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/614dce59b3f0c66e4799a=
30b
        failing since 314 days (last pass: v4.4.243-18-gfc7e8c68369a, first=
 fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch | lab          | compiler | defconfig          |=
 regressions
--------------------+------+--------------+----------+--------------------+=
------------
qemu_arm-virt-gicv3 | arm  | lab-baylibre | gcc-8    | multi_v7_defconfig |=
 1          =


  Details:     https://kernelci.org/test/plan/id/614dcd860043c0dbf099a2ee

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.284-9=
-g002a7b8e43b1/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-=
virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.284-9=
-g002a7b8e43b1/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-=
virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/614dcd860043c0dbf099a=
2ef
        failing since 314 days (last pass: v4.4.243-18-gfc7e8c68369a, first=
 fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch | lab          | compiler | defconfig          |=
 regressions
--------------------+------+--------------+----------+--------------------+=
------------
qemu_arm-virt-gicv3 | arm  | lab-broonie  | gcc-8    | multi_v7_defconfig |=
 1          =


  Details:     https://kernelci.org/test/plan/id/614dce62e3d203335599a2dd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.284-9=
-g002a7b8e43b1/arm/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-v=
irt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.284-9=
-g002a7b8e43b1/arm/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-v=
irt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/614dce62e3d203335599a=
2de
        failing since 314 days (last pass: v4.4.243-18-gfc7e8c68369a, first=
 fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch | lab          | compiler | defconfig          |=
 regressions
--------------------+------+--------------+----------+--------------------+=
------------
qemu_arm-virt-gicv3 | arm  | lab-cip      | gcc-8    | multi_v7_defconfig |=
 1          =


  Details:     https://kernelci.org/test/plan/id/614dcdb90043c0dbf099a32d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.284-9=
-g002a7b8e43b1/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-virt-=
gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.284-9=
-g002a7b8e43b1/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-virt-=
gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/614dcdb90043c0dbf099a=
32e
        failing since 314 days (last pass: v4.4.243-18-gfc7e8c68369a, first=
 fail: v4.4.243-19-g71b6c961c7fe) =

 =20
