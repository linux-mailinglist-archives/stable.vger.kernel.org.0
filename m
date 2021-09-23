Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEFA6416713
	for <lists+stable@lfdr.de>; Thu, 23 Sep 2021 23:08:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243189AbhIWVKR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Sep 2021 17:10:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243176AbhIWVKR (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Sep 2021 17:10:17 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D8DEC061574
        for <stable@vger.kernel.org>; Thu, 23 Sep 2021 14:08:45 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id lb1-20020a17090b4a4100b001993f863df2so5780940pjb.5
        for <stable@vger.kernel.org>; Thu, 23 Sep 2021 14:08:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ONYC3nibSDN0AmZyzzWrk/gLkc6WYfkPQp+jN+8EJjs=;
        b=w6gh9tNC3pRRZbSPIy51RtWXXFZU7D7U4ZnsqQMAGg1vM0OMI+mOPs0b3qvKd03FJ7
         XZW6tn06GqC5IIG/+PeNDfQ2AO+utR/iU8UHFYuRFLxUHnuO8iFcYuu2ENPWUbdX3hpA
         6PaKNnyhGzv3TtblzTu/iMud5Qj3p1zZGERx+3GVYdhOWzdrz1vvNM/S/dwrRiwJBWLs
         mVoPFUNAUP8pbo7EpN1ML6Shz/yPqFcx8YSg2Xj9+fxuuY/FxDyHZEntsW9zuyNR09j+
         e0wAeoT6xv3J8eQxGTM4xS58X9fK5wreNM+EZGZi/p3a3pLmXthaA3f/j2BB3x4ixKbd
         ItDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ONYC3nibSDN0AmZyzzWrk/gLkc6WYfkPQp+jN+8EJjs=;
        b=Uqe9JXjeI8OdDVpsAlvYtgH+ujPUZhDThHR8WXWPFMqHacXCSldLXvkvFrgp0n0a/L
         73/0D+wj2+b9XhdbkzIDEsQPE/NrSzz0MfAuoNkOmUpMY692Pq6/IoHi2/5KC7t7+X0t
         jcgt9Qd8SzfCJE2AI7tnshsPHM/29QMJuZnWJ5aZgePtLqVmA/3GVRcZmB65K4yICwp3
         34li1Wzyl4Xhu8lJ6MYJEsLshbfL2WmANVaOFgT8+SzieDgHLX2JYfywEJ0sPCEzxO9H
         UmfEhJX7TbXRqxWYnayFsWuONo3ml3oVQdGes5Ng5CSQGFkEnPZPD7B3KXG8yKOMQCkG
         i/Zw==
X-Gm-Message-State: AOAM531wFiqs5eRWtlSMKLRMzRhxwUq1RNSFa0jhuZB/bIDC76EYO2ZQ
        4Y2fbQvJs85Vr2Hz7LvpWeGvS2ry+ONp54FZ
X-Google-Smtp-Source: ABdhPJxun60gEqWPyb0/kliA+5Am2K/xwOqZz06qN37awNWbjtZlNTkpoHLtHaEVEFiOb/sp41trYQ==
X-Received: by 2002:a17:90a:bd08:: with SMTP id y8mr7644445pjr.123.1632431324796;
        Thu, 23 Sep 2021 14:08:44 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y26sm6465032pfe.69.2021.09.23.14.08.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Sep 2021 14:08:44 -0700 (PDT)
Message-ID: <614cecdc.1c69fb81.8aa9.3fce@mx.google.com>
Date:   Thu, 23 Sep 2021 14:08:44 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.4.284-2-g686162064cb8
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.4
Subject: stable-rc/queue/4.4 baseline: 59 runs,
 6 regressions (v4.4.284-2-g686162064cb8)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 baseline: 59 runs, 6 regressions (v4.4.284-2-g686162064=
cb8)

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
el/v4.4.284-2-g686162064cb8/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.4
  Describe: v4.4.284-2-g686162064cb8
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      686162064cb8543ed9abaed74b99008bc970a834 =



Test Regressions
---------------- =



platform            | arch | lab          | compiler | defconfig          |=
 regressions
--------------------+------+--------------+----------+--------------------+=
------------
qemu_arm-virt-gicv2 | arm  | lab-baylibre | gcc-8    | multi_v7_defconfig |=
 1          =


  Details:     https://kernelci.org/test/plan/id/614cb5f136893909bc99a327

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.284-2=
-g686162064cb8/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-=
virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.284-2=
-g686162064cb8/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-=
virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/614cb5f136893909bc99a=
328
        failing since 313 days (last pass: v4.4.243-18-gfc7e8c68369a, first=
 fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch | lab          | compiler | defconfig          |=
 regressions
--------------------+------+--------------+----------+--------------------+=
------------
qemu_arm-virt-gicv2 | arm  | lab-broonie  | gcc-8    | multi_v7_defconfig |=
 1          =


  Details:     https://kernelci.org/test/plan/id/614ceb9f889ad048df99a2f3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.284-2=
-g686162064cb8/arm/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-v=
irt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.284-2=
-g686162064cb8/arm/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-v=
irt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/614ceb9f889ad048df99a=
2f4
        failing since 313 days (last pass: v4.4.243-18-gfc7e8c68369a, first=
 fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch | lab          | compiler | defconfig          |=
 regressions
--------------------+------+--------------+----------+--------------------+=
------------
qemu_arm-virt-gicv2 | arm  | lab-cip      | gcc-8    | multi_v7_defconfig |=
 1          =


  Details:     https://kernelci.org/test/plan/id/614cb474d9c56f489099a2f6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.284-2=
-g686162064cb8/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-virt-=
gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.284-2=
-g686162064cb8/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-virt-=
gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/614cb474d9c56f489099a=
2f7
        failing since 313 days (last pass: v4.4.243-18-gfc7e8c68369a, first=
 fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch | lab          | compiler | defconfig          |=
 regressions
--------------------+------+--------------+----------+--------------------+=
------------
qemu_arm-virt-gicv3 | arm  | lab-baylibre | gcc-8    | multi_v7_defconfig |=
 1          =


  Details:     https://kernelci.org/test/plan/id/614cb5a1818ee3fbd199a2e2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.284-2=
-g686162064cb8/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-=
virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.284-2=
-g686162064cb8/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-=
virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/614cb5a1818ee3fbd199a=
2e3
        failing since 313 days (last pass: v4.4.243-18-gfc7e8c68369a, first=
 fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch | lab          | compiler | defconfig          |=
 regressions
--------------------+------+--------------+----------+--------------------+=
------------
qemu_arm-virt-gicv3 | arm  | lab-broonie  | gcc-8    | multi_v7_defconfig |=
 1          =


  Details:     https://kernelci.org/test/plan/id/614ceb8b3e64d6c38d99a331

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.284-2=
-g686162064cb8/arm/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-v=
irt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.284-2=
-g686162064cb8/arm/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-v=
irt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/614ceb8b3e64d6c38d99a=
332
        failing since 313 days (last pass: v4.4.243-18-gfc7e8c68369a, first=
 fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch | lab          | compiler | defconfig          |=
 regressions
--------------------+------+--------------+----------+--------------------+=
------------
qemu_arm-virt-gicv3 | arm  | lab-cip      | gcc-8    | multi_v7_defconfig |=
 1          =


  Details:     https://kernelci.org/test/plan/id/614cb4756b5371cbaf99a2e2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.284-2=
-g686162064cb8/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-virt-=
gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.284-2=
-g686162064cb8/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-virt-=
gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/614cb4756b5371cbaf99a=
2e3
        failing since 313 days (last pass: v4.4.243-18-gfc7e8c68369a, first=
 fail: v4.4.243-19-g71b6c961c7fe) =

 =20
