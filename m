Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 460173E215E
	for <lists+stable@lfdr.de>; Fri,  6 Aug 2021 04:10:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235809AbhHFCLE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Aug 2021 22:11:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235155AbhHFCLE (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Aug 2021 22:11:04 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0EE0C061798
        for <stable@vger.kernel.org>; Thu,  5 Aug 2021 19:10:48 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id mt6so13602166pjb.1
        for <stable@vger.kernel.org>; Thu, 05 Aug 2021 19:10:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=4GN001Wp+Qj0Q6YCEV2kG/yYWBJyyOZ3ktxQPddnlis=;
        b=ZNkxcZvyvevVe1GIK0I/ZAW2P31lyAFgX/yTWZPgJyIDi23FddeS7tD+9vtAoXmTUg
         u4nDRau56D6gs45SHuw7HEa8vThgFxpOYV2S1D0b71OkD0l7A4bWLWOZonNoVdhLJ5Py
         UAqVhRi148sO1LGCmeKTwIZLqdbAWlMSPzo3Sg6y/XRHfaIhG/3JHfBQvXtoH1c6uQwN
         BkRYBlSj0HLDiTeCOnbrBQB+qi8ZHfkS1Aw8PLRSw2fG4agQK0UojvASBv3w2157RXoc
         B1GjHxeUpPdrnO0YUfTDhsfH7MRyoRJsKkSgCRJMM1r70IeB9G0sbBKuLNJshf5oGyxv
         KP+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=4GN001Wp+Qj0Q6YCEV2kG/yYWBJyyOZ3ktxQPddnlis=;
        b=lgKYsmPyeatTncsd1xJ0U0DTxL82u/OX60xTP74YDZQrw9gWfklajqnHobpQkUt8uy
         QmsRs63ZZ3uo58s8kJChB3MKSHX4jMLS7XO7J+ESadbAVjq8lA69XHClH+jhJAOWLxuw
         sCGybvCX5aHXxcnt9UZVD1ArvR+sWF0b6/YPfr4EpaK235/0POSFUuj1tKzgFV/sXR3+
         YkQI/6fmiOtrhYGB65rBVaStXpCScazBpnPVbmAhzuqc2Ud9rski7jcHhVJoUrVvKBih
         a6XUFU//h2Yq9XKYE3jUoksnQTEBaZJQk79LfXFiWoZd/0A1+v1EGBUsiwJ9Iapp7j2d
         H9qQ==
X-Gm-Message-State: AOAM533HNwsNP7qh8oU8x/zZAM0h+Yd0vAhgX724cJnSmJrq0qGJni5P
        +1Hru98XZAdBOqbzpzf3VTN+m74JVYQpUM0r
X-Google-Smtp-Source: ABdhPJwwykBpgR43m6bK0SYeqKQcZMxCEL6kBiff5TUo2Cqx6FQh2edvzm74p9QbeLV8l3T9S/KkSA==
X-Received: by 2002:a17:90a:af88:: with SMTP id w8mr7768786pjq.104.1628215847874;
        Thu, 05 Aug 2021 19:10:47 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id i8sm8215424pfo.117.2021.08.05.19.10.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Aug 2021 19:10:47 -0700 (PDT)
Message-ID: <610c9a27.1c69fb81.323da.946c@mx.google.com>
Date:   Thu, 05 Aug 2021 19:10:47 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.4
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.4.278-4-g5d1652b6a891
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.4 baseline: 78 runs,
 6 regressions (v4.4.278-4-g5d1652b6a891)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 baseline: 78 runs, 6 regressions (v4.4.278-4-g5d1652b6a=
891)

Regressions Summary
-------------------

platform            | arch | lab             | compiler | defconfig        =
  | regressions
--------------------+------+-----------------+----------+------------------=
--+------------
qemu_arm-virt-gicv2 | arm  | lab-baylibre    | gcc-8    | multi_v7_defconfi=
g | 1          =

qemu_arm-virt-gicv2 | arm  | lab-cip         | gcc-8    | multi_v7_defconfi=
g | 1          =

qemu_arm-virt-gicv2 | arm  | lab-linaro-lkft | gcc-8    | multi_v7_defconfi=
g | 1          =

qemu_arm-virt-gicv3 | arm  | lab-baylibre    | gcc-8    | multi_v7_defconfi=
g | 1          =

qemu_arm-virt-gicv3 | arm  | lab-cip         | gcc-8    | multi_v7_defconfi=
g | 1          =

qemu_arm-virt-gicv3 | arm  | lab-linaro-lkft | gcc-8    | multi_v7_defconfi=
g | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.4/kern=
el/v4.4.278-4-g5d1652b6a891/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.4
  Describe: v4.4.278-4-g5d1652b6a891
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      5d1652b6a891cae4835a89d1d7abb75dbb19306c =



Test Regressions
---------------- =



platform            | arch | lab             | compiler | defconfig        =
  | regressions
--------------------+------+-----------------+----------+------------------=
--+------------
qemu_arm-virt-gicv2 | arm  | lab-baylibre    | gcc-8    | multi_v7_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/610c619c86f51d3149b13690

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.278-4=
-g5d1652b6a891/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-=
virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.278-4=
-g5d1652b6a891/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-=
virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/610c619c86f51d3149b13=
691
        failing since 265 days (last pass: v4.4.243-18-gfc7e8c68369a, first=
 fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch | lab             | compiler | defconfig        =
  | regressions
--------------------+------+-----------------+----------+------------------=
--+------------
qemu_arm-virt-gicv2 | arm  | lab-cip         | gcc-8    | multi_v7_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/610c61bde7b510f2abb13661

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.278-4=
-g5d1652b6a891/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-virt-=
gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.278-4=
-g5d1652b6a891/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-virt-=
gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/610c61bde7b510f2abb13=
662
        failing since 265 days (last pass: v4.4.243-18-gfc7e8c68369a, first=
 fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch | lab             | compiler | defconfig        =
  | regressions
--------------------+------+-----------------+----------+------------------=
--+------------
qemu_arm-virt-gicv2 | arm  | lab-linaro-lkft | gcc-8    | multi_v7_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/610c6194a437d3a5bab13668

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.278-4=
-g5d1652b6a891/arm/multi_v7_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_a=
rm-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.278-4=
-g5d1652b6a891/arm/multi_v7_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_a=
rm-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/610c6194a437d3a5bab13=
669
        failing since 265 days (last pass: v4.4.243-18-gfc7e8c68369a, first=
 fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch | lab             | compiler | defconfig        =
  | regressions
--------------------+------+-----------------+----------+------------------=
--+------------
qemu_arm-virt-gicv3 | arm  | lab-baylibre    | gcc-8    | multi_v7_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/610c619e86f51d3149b1369c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.278-4=
-g5d1652b6a891/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-=
virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.278-4=
-g5d1652b6a891/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-=
virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/610c619e86f51d3149b13=
69d
        failing since 265 days (last pass: v4.4.243-18-gfc7e8c68369a, first=
 fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch | lab             | compiler | defconfig        =
  | regressions
--------------------+------+-----------------+----------+------------------=
--+------------
qemu_arm-virt-gicv3 | arm  | lab-cip         | gcc-8    | multi_v7_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/610c61c4e7b510f2abb1367b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.278-4=
-g5d1652b6a891/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-virt-=
gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.278-4=
-g5d1652b6a891/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-virt-=
gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/610c61c4e7b510f2abb13=
67c
        failing since 265 days (last pass: v4.4.243-18-gfc7e8c68369a, first=
 fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch | lab             | compiler | defconfig        =
  | regressions
--------------------+------+-----------------+----------+------------------=
--+------------
qemu_arm-virt-gicv3 | arm  | lab-linaro-lkft | gcc-8    | multi_v7_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/610c619686f51d3149b13680

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.278-4=
-g5d1652b6a891/arm/multi_v7_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_a=
rm-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.278-4=
-g5d1652b6a891/arm/multi_v7_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_a=
rm-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/610c619686f51d3149b13=
681
        failing since 265 days (last pass: v4.4.243-18-gfc7e8c68369a, first=
 fail: v4.4.243-19-g71b6c961c7fe) =

 =20
