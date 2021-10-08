Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B1384263A3
	for <lists+stable@lfdr.de>; Fri,  8 Oct 2021 06:24:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229723AbhJHE03 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Oct 2021 00:26:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229628AbhJHE0Y (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 8 Oct 2021 00:26:24 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 827DCC061570
        for <stable@vger.kernel.org>; Thu,  7 Oct 2021 21:24:29 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id m26so7124626pff.3
        for <stable@vger.kernel.org>; Thu, 07 Oct 2021 21:24:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=DEn4p/hGN1nC/Oq0EpdoTPT1p48gyDXG7gL0J100mwE=;
        b=2F8ke1Et2kHeeQdPFQRkNx4jYy+Ui803dtwroTLVL2UWguvZ2oDp9yO/dc1FZ1rMDP
         00HVUpJhaBF78wOgkQUExNGA9faeb4Y5TUDVGhNqR+IKzqLwRMLiBh8avImNANt2jqui
         8KeEgUxLFaLFAfE6KmH+oSyJoHyE1ls1DzhEXY8Y0k2GleHA81ciw57V6P7+mDCzTj7z
         p0uroxzH29u+SiXI4cTP9WnhU8EyhLnEZfeBDAmSvyog5hQhXcHNvLf5k8j9nYIP8nup
         eEUL44fm70kLIe1PVkbr+7LS/g1o/JmWvb1tdavZuVZ/hSRZOu+6APIbSntAR+4hw3Y1
         ENCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=DEn4p/hGN1nC/Oq0EpdoTPT1p48gyDXG7gL0J100mwE=;
        b=DwlMTUVGEu8GaODiWp8OEplRpvNiMkCR/jJNjqjKut0i6LagaxVka8Ys1W/syP5c1H
         yggXgKskolM2fCX21B+kzabWFwOwpfu65hXC8jsfJhy11kz093Zuhr+EEketyoil4L0/
         0Hqx0rRntiGnmoKMzkA55Wh2jd9ONhTObqsdu6QKtnUkm2aQQe7rZz4Jy5E9crA2YAxH
         AxZT+K8Y/zafMLiWwA78cbc2ogYbWHlny2UJ7yyhLl38OsjWsmmbiw3wHLRoUuYnLDMo
         Ph784Cp7pSJ875Dze4zMqfQ9agb2SHMSobWK5iryTAD6bu0+87106tQsAtVuRPMPHjyd
         fHcQ==
X-Gm-Message-State: AOAM530oVR+jQj/vrTfV1dgjTML0a+bsbh22WhIU2jY0EBoz27nK9/zF
        zoU8MoJlNqO4d0jQdm2VhjPpwfe2/kcaa4lc
X-Google-Smtp-Source: ABdhPJy/DOG2Y7lEYa8iiGBPiuTGjcUVamoGqYTaATm7fUhkM6gy2ixv5rhpaXFWFQCc+n2os6FwAw==
X-Received: by 2002:a63:454e:: with SMTP id u14mr2840365pgk.314.1633667068637;
        Thu, 07 Oct 2021 21:24:28 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id q35sm9621005pjk.41.2021.10.07.21.24.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 21:24:28 -0700 (PDT)
Message-ID: <615fc7fc.1c69fb81.19cee.ddbc@mx.google.com>
Date:   Thu, 07 Oct 2021 21:24:28 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.4.286-8-g901e535adf32
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.4
Subject: stable-rc/queue/4.4 baseline: 65 runs,
 5 regressions (v4.4.286-8-g901e535adf32)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 baseline: 65 runs, 5 regressions (v4.4.286-8-g901e535ad=
f32)

Regressions Summary
-------------------

platform            | arch | lab           | compiler | defconfig          =
 | regressions
--------------------+------+---------------+----------+--------------------=
-+------------
panda               | arm  | lab-collabora | gcc-8    | omap2plus_defconfig=
 | 1          =

qemu_arm-virt-gicv2 | arm  | lab-baylibre  | gcc-8    | multi_v7_defconfig =
 | 1          =

qemu_arm-virt-gicv2 | arm  | lab-cip       | gcc-8    | multi_v7_defconfig =
 | 1          =

qemu_arm-virt-gicv3 | arm  | lab-baylibre  | gcc-8    | multi_v7_defconfig =
 | 1          =

qemu_arm-virt-gicv3 | arm  | lab-cip       | gcc-8    | multi_v7_defconfig =
 | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.4/kern=
el/v4.4.286-8-g901e535adf32/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.4
  Describe: v4.4.286-8-g901e535adf32
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      901e535adf32c43cb53ca023b92dde6afecefe25 =



Test Regressions
---------------- =



platform            | arch | lab           | compiler | defconfig          =
 | regressions
--------------------+------+---------------+----------+--------------------=
-+------------
panda               | arm  | lab-collabora | gcc-8    | omap2plus_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/615f9115968e6ecc6c99a34a

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.286-8=
-g901e535adf32/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.t=
xt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.286-8=
-g901e535adf32/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/615f9115968e6ec=
c6c99a350
        new failure (last pass: v4.4.286-8-g1da3f70f914f)
        2 lines

    2021-10-08T00:30:05.267409  [   19.646881] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-10-08T00:30:05.310930  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/118
    2021-10-08T00:30:05.320127  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
26c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =



platform            | arch | lab           | compiler | defconfig          =
 | regressions
--------------------+------+---------------+----------+--------------------=
-+------------
qemu_arm-virt-gicv2 | arm  | lab-baylibre  | gcc-8    | multi_v7_defconfig =
 | 1          =


  Details:     https://kernelci.org/test/plan/id/615f9188a40a32cd9f99a300

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.286-8=
-g901e535adf32/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-=
virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.286-8=
-g901e535adf32/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-=
virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615f9188a40a32cd9f99a=
301
        failing since 328 days (last pass: v4.4.243-18-gfc7e8c68369a, first=
 fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch | lab           | compiler | defconfig          =
 | regressions
--------------------+------+---------------+----------+--------------------=
-+------------
qemu_arm-virt-gicv2 | arm  | lab-cip       | gcc-8    | multi_v7_defconfig =
 | 1          =


  Details:     https://kernelci.org/test/plan/id/615f97d742400e455a99a2fd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.286-8=
-g901e535adf32/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-virt-=
gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.286-8=
-g901e535adf32/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-virt-=
gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615f97d742400e455a99a=
2fe
        failing since 328 days (last pass: v4.4.243-18-gfc7e8c68369a, first=
 fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch | lab           | compiler | defconfig          =
 | regressions
--------------------+------+---------------+----------+--------------------=
-+------------
qemu_arm-virt-gicv3 | arm  | lab-baylibre  | gcc-8    | multi_v7_defconfig =
 | 1          =


  Details:     https://kernelci.org/test/plan/id/615f910ff18f390f7e99a30a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.286-8=
-g901e535adf32/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-=
virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.286-8=
-g901e535adf32/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-=
virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615f910ff18f390f7e99a=
30b
        failing since 328 days (last pass: v4.4.243-18-gfc7e8c68369a, first=
 fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch | lab           | compiler | defconfig          =
 | regressions
--------------------+------+---------------+----------+--------------------=
-+------------
qemu_arm-virt-gicv3 | arm  | lab-cip       | gcc-8    | multi_v7_defconfig =
 | 1          =


  Details:     https://kernelci.org/test/plan/id/615f95777e5f25532b99a2ec

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.286-8=
-g901e535adf32/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-virt-=
gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.286-8=
-g901e535adf32/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-virt-=
gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615f95777e5f25532b99a=
2ed
        failing since 328 days (last pass: v4.4.243-18-gfc7e8c68369a, first=
 fail: v4.4.243-19-g71b6c961c7fe) =

 =20
