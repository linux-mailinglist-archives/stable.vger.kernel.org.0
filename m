Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A9D12BB114
	for <lists+stable@lfdr.de>; Fri, 20 Nov 2020 17:58:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730258AbgKTQ5h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Nov 2020 11:57:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728748AbgKTQ5g (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 Nov 2020 11:57:36 -0500
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 721DEC0613CF
        for <stable@vger.kernel.org>; Fri, 20 Nov 2020 08:57:36 -0800 (PST)
Received: by mail-pf1-x42e.google.com with SMTP id 10so8426467pfp.5
        for <stable@vger.kernel.org>; Fri, 20 Nov 2020 08:57:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=tIaFoVwb99tq4zze37VUfG1T6L2x+zamyYZHA7qLhpU=;
        b=iOp6ytby80fy+unK42DuJYcuMdoV7xjkKQi0xqv4vzn4EKiUzKH5r9It5ArH+W7IYI
         7RuFZbcfCbAsLwh1Kz7y9eIfn9OZ6waOm1s/VbL7x19xcj3uiYUr1T7ovquyWXH8QZdQ
         notJH7Yk2H24XHjR++szrSlH71aTQ8AGM25mpMdnXptpGygsoNKxOhl5oxtT+Csb2RDx
         JAOLr2Yr0M1UgeX/ESf9UcuhmaErGszSnOxxFmbeLu7KL8Rjh5AkCsG8bjgDFpVWzoFs
         A27nLbrkaOBRZKuEXlOmeSMKGRY4dWn3vqls32L45s51TA3grHuNkfqGXD/y2VGMZqjn
         L3Jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=tIaFoVwb99tq4zze37VUfG1T6L2x+zamyYZHA7qLhpU=;
        b=lbSvnFNgFdS6HOdHoP+h8ZfDgrUY3SdNPJVJoFtU7tvVCcTB3ho3hIx/zrDxOKLcoZ
         lKzko8yOLpgaMwFvZcYLTUY0FcAUOdFpwniKOdkwxMnt+Gy2ewUE/0kWKhf2OZnyEvc/
         IHkvFcuH1AoQpUE0RrM/pTaCWnfktXypD4kJwEcfPEwZA+nLX79R39faNAhhqTv6N/0+
         rc6xkMv63S/eUN/9WUkewBMXMasjgy7dP+J4kqDelU/XO1yHKGDOECPc8pvFjZzcUgJk
         baoJijpLzT54SuAmgT+tziVofrhxvTCDMOqei/Bczwemo6o6FhMjfk7PPibMxT1yziP0
         FfKg==
X-Gm-Message-State: AOAM530KdlIC94NLZywvVwgjBSDosCAI4q0NqzhozsurAz0htCHOD7x1
        TiCn3lkdbkc54rprxgKfVKd2p4fyRldGVA==
X-Google-Smtp-Source: ABdhPJzJUlrsDmsXTkfZr5BlK+hBDAT9w0niFaOwWbxrMpJUuWbVXIiDyosL/n8r0KEEi7reOyICgA==
X-Received: by 2002:aa7:8552:0:b029:18e:f030:e514 with SMTP id y18-20020aa785520000b029018ef030e514mr14093602pfn.2.1605891455583;
        Fri, 20 Nov 2020 08:57:35 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id t10sm4151169pfq.110.2020.11.20.08.57.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Nov 2020 08:57:34 -0800 (PST)
Message-ID: <5fb7f57e.1c69fb81.187f.7912@mx.google.com>
Date:   Fri, 20 Nov 2020 08:57:34 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.4.244-15-g944231f27c48
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.4
Subject: stable-rc/queue/4.4 baseline: 84 runs,
 7 regressions (v4.4.244-15-g944231f27c48)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 baseline: 84 runs, 7 regressions (v4.4.244-15-g944231f2=
7c48)

Regressions Summary
-------------------

platform            | arch   | lab           | compiler | defconfig        =
  | regressions
--------------------+--------+---------------+----------+------------------=
--+------------
qemu_arm-virt-gicv2 | arm    | lab-baylibre  | gcc-8    | multi_v7_defconfi=
g | 1          =

qemu_arm-virt-gicv2 | arm    | lab-cip       | gcc-8    | multi_v7_defconfi=
g | 1          =

qemu_arm-virt-gicv2 | arm    | lab-collabora | gcc-8    | multi_v7_defconfi=
g | 1          =

qemu_arm-virt-gicv3 | arm    | lab-baylibre  | gcc-8    | multi_v7_defconfi=
g | 1          =

qemu_arm-virt-gicv3 | arm    | lab-cip       | gcc-8    | multi_v7_defconfi=
g | 1          =

qemu_arm-virt-gicv3 | arm    | lab-collabora | gcc-8    | multi_v7_defconfi=
g | 1          =

qemu_x86_64-uefi    | x86_64 | lab-baylibre  | gcc-8    | x86_64_defconfig =
  | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.4/kern=
el/v4.4.244-15-g944231f27c48/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.4
  Describe: v4.4.244-15-g944231f27c48
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      944231f27c48e32b6fb146cebb59bb27a8a89d2b =



Test Regressions
---------------- =



platform            | arch   | lab           | compiler | defconfig        =
  | regressions
--------------------+--------+---------------+----------+------------------=
--+------------
qemu_arm-virt-gicv2 | arm    | lab-baylibre  | gcc-8    | multi_v7_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/5fb7c4162464c3288cd8d91d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.244-1=
5-g944231f27c48/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm=
-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.244-1=
5-g944231f27c48/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm=
-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fb7c4162464c3288cd8d=
91e
        failing since 6 days (last pass: v4.4.243-18-gfc7e8c68369a, first f=
ail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch   | lab           | compiler | defconfig        =
  | regressions
--------------------+--------+---------------+----------+------------------=
--+------------
qemu_arm-virt-gicv2 | arm    | lab-cip       | gcc-8    | multi_v7_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/5fb7c458081a31f67fd8d8ff

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.244-1=
5-g944231f27c48/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-virt=
-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.244-1=
5-g944231f27c48/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-virt=
-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fb7c458081a31f67fd8d=
900
        failing since 6 days (last pass: v4.4.243-18-gfc7e8c68369a, first f=
ail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch   | lab           | compiler | defconfig        =
  | regressions
--------------------+--------+---------------+----------+------------------=
--+------------
qemu_arm-virt-gicv2 | arm    | lab-collabora | gcc-8    | multi_v7_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/5fb7c4288153f2a41dd8d933

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.244-1=
5-g944231f27c48/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-qemu_ar=
m-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.244-1=
5-g944231f27c48/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-qemu_ar=
m-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fb7c4288153f2a41dd8d=
934
        failing since 6 days (last pass: v4.4.243-18-gfc7e8c68369a, first f=
ail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch   | lab           | compiler | defconfig        =
  | regressions
--------------------+--------+---------------+----------+------------------=
--+------------
qemu_arm-virt-gicv3 | arm    | lab-baylibre  | gcc-8    | multi_v7_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/5fb7c4308153f2a41dd8d954

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.244-1=
5-g944231f27c48/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm=
-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.244-1=
5-g944231f27c48/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm=
-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fb7c4308153f2a41dd8d=
955
        failing since 6 days (last pass: v4.4.243-18-gfc7e8c68369a, first f=
ail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch   | lab           | compiler | defconfig        =
  | regressions
--------------------+--------+---------------+----------+------------------=
--+------------
qemu_arm-virt-gicv3 | arm    | lab-cip       | gcc-8    | multi_v7_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/5fb7c45176b9dcf87bd8d929

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.244-1=
5-g944231f27c48/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-virt=
-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.244-1=
5-g944231f27c48/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-virt=
-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fb7c45176b9dcf87bd8d=
92a
        failing since 6 days (last pass: v4.4.243-18-gfc7e8c68369a, first f=
ail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch   | lab           | compiler | defconfig        =
  | regressions
--------------------+--------+---------------+----------+------------------=
--+------------
qemu_arm-virt-gicv3 | arm    | lab-collabora | gcc-8    | multi_v7_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/5fb7c4318153f2a41dd8d957

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.244-1=
5-g944231f27c48/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-qemu_ar=
m-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.244-1=
5-g944231f27c48/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-qemu_ar=
m-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fb7c4318153f2a41dd8d=
958
        failing since 6 days (last pass: v4.4.243-18-gfc7e8c68369a, first f=
ail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch   | lab           | compiler | defconfig        =
  | regressions
--------------------+--------+---------------+----------+------------------=
--+------------
qemu_x86_64-uefi    | x86_64 | lab-baylibre  | gcc-8    | x86_64_defconfig =
  | 1          =


  Details:     https://kernelci.org/test/plan/id/5fb7c2d738822c5bfed8d8fd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.244-1=
5-g944231f27c48/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu_x8=
6_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.244-1=
5-g944231f27c48/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu_x8=
6_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fb7c2d738822c5bfed8d=
8fe
        new failure (last pass: v4.4.244-13-gd19a0e464e02) =

 =20
