Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6BBD2BFD5C
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 01:28:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726448AbgKWA2b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Nov 2020 19:28:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726287AbgKWA2b (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Nov 2020 19:28:31 -0500
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57B1FC0613CF
        for <stable@vger.kernel.org>; Sun, 22 Nov 2020 16:28:31 -0800 (PST)
Received: by mail-pl1-x62b.google.com with SMTP id d17so7986923plr.5
        for <stable@vger.kernel.org>; Sun, 22 Nov 2020 16:28:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=UpGUdSWTY70K8r6JFVsElW1CeMS1E/Y/iS62w9QQYyM=;
        b=B9pIf6tZEwXJqRhfPw2RPfgSmVtZs983FgZ+BgepBOHlzEGEdJIz5O8JdyxTPKxDe/
         FBI6HuzxJKeU8FNtbA5rE2LlrvZQfMyXRbx6GgeR5bSnmEJFe8IeJ6Mh4AMrcUQ4gPR1
         4jS/2DPmYnYSQLGY9Awa6LcAydejdAN9UAEchCrGvcrfh7ik3NjRlQs5xaGnEoDaEIrb
         T0qc/FWu6t3XU7ajEyVPkJEHeObgjgb6PPMQJ/QNsy1MZ8zcKIHVr9u57kJHvQ3UcyyT
         QQpdxRCOF3KaJajd4wjQENBQxL4M+82gXsXpW8EvSiT6fVT+u1l3VACaBIjMYgihiiLG
         ZbAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=UpGUdSWTY70K8r6JFVsElW1CeMS1E/Y/iS62w9QQYyM=;
        b=kKK77NQJ3xNEbDGrA4q+OZUqc7H1fk3k1nG9+4Z6I9Ga+PFawroHUQPjyN1AYPpH2W
         CLVmdi35pQUxRC8i/gtWlirP7M9zFjoY1vB6G2sztUO+XxU7pip56hachPW87fJe8ipW
         Vj3VeCXO651NwmdL5KT+tQEY0iT+1GQMemqjkcMZM7xBaau2jRBr5+Yj9fIh3N26aWxD
         JVCvdmr/5fZZJp2XAxir0X9ZcdrfCk14V32jw67B5Ytpa9PTPFQTm6DVnUK+yhHtvvP6
         j9G2XPG5luefC+HgQwwZvxV5mQxaKCyp6TKxrmFUN0EV9OkY8nOYiJmf4a3rI8KNOX24
         waRQ==
X-Gm-Message-State: AOAM531KmZX31G3RVd3p/otuCbavo0kMgp+l8OARnEXQmVSe1hRbsV7F
        GyU1NyD/PDL1G2QMkTXRz4qWqMj8N5wgZQ==
X-Google-Smtp-Source: ABdhPJxxXXsE+h6bqtl85HvS9UDvSEmF1AQHg8+8kyF7GqoMTIr3PRcOPX1uB9GyBJKjXQOhCEEnOw==
X-Received: by 2002:a17:902:b095:b029:d8:ffbb:6188 with SMTP id p21-20020a170902b095b02900d8ffbb6188mr21822890plr.43.1606091309427;
        Sun, 22 Nov 2020 16:28:29 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 16sm11380605pjf.36.2020.11.22.16.28.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Nov 2020 16:28:28 -0800 (PST)
Message-ID: <5fbb022c.1c69fb81.eddb9.8ff0@mx.google.com>
Date:   Sun, 22 Nov 2020 16:28:28 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.4.245-15-g0aeeacb1b87e
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.4
Subject: stable-rc/queue/4.4 baseline: 92 runs,
 14 regressions (v4.4.245-15-g0aeeacb1b87e)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 baseline: 92 runs, 14 regressions (v4.4.245-15-g0aeeacb=
1b87e)

Regressions Summary
-------------------

platform            | arch   | lab             | compiler | defconfig      =
    | regressions
--------------------+--------+-----------------+----------+----------------=
----+------------
qemu_arm-virt-gicv2 | arm    | lab-baylibre    | gcc-8    | multi_v7_defcon=
fig | 1          =

qemu_arm-virt-gicv2 | arm    | lab-broonie     | gcc-8    | multi_v7_defcon=
fig | 1          =

qemu_arm-virt-gicv2 | arm    | lab-cip         | gcc-8    | multi_v7_defcon=
fig | 1          =

qemu_arm-virt-gicv2 | arm    | lab-linaro-lkft | gcc-8    | multi_v7_defcon=
fig | 1          =

qemu_arm-virt-gicv3 | arm    | lab-baylibre    | gcc-8    | multi_v7_defcon=
fig | 1          =

qemu_arm-virt-gicv3 | arm    | lab-broonie     | gcc-8    | multi_v7_defcon=
fig | 1          =

qemu_arm-virt-gicv3 | arm    | lab-cip         | gcc-8    | multi_v7_defcon=
fig | 1          =

qemu_arm-virt-gicv3 | arm    | lab-linaro-lkft | gcc-8    | multi_v7_defcon=
fig | 1          =

qemu_i386           | i386   | lab-baylibre    | gcc-8    | i386_defconfig =
    | 1          =

qemu_i386           | i386   | lab-cip         | gcc-8    | i386_defconfig =
    | 1          =

qemu_i386-uefi      | i386   | lab-baylibre    | gcc-8    | i386_defconfig =
    | 1          =

qemu_x86_64         | x86_64 | lab-baylibre    | gcc-8    | x86_64_defconfi=
g   | 1          =

qemu_x86_64-uefi    | x86_64 | lab-baylibre    | gcc-8    | x86_64_defconfi=
g   | 1          =

qemu_x86_64-uefi    | x86_64 | lab-cip         | gcc-8    | x86_64_defconfi=
g   | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.4/kern=
el/v4.4.245-15-g0aeeacb1b87e/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.4
  Describe: v4.4.245-15-g0aeeacb1b87e
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      0aeeacb1b87e9dbdf6a72e4c1e347cd600b2e6f0 =



Test Regressions
---------------- =



platform            | arch   | lab             | compiler | defconfig      =
    | regressions
--------------------+--------+-----------------+----------+----------------=
----+------------
qemu_arm-virt-gicv2 | arm    | lab-baylibre    | gcc-8    | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fbad0d92d7bce5128d8d930

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.245-1=
5-g0aeeacb1b87e/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm=
-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.245-1=
5-g0aeeacb1b87e/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm=
-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fbad0d92d7bce5128d8d=
931
        failing since 9 days (last pass: v4.4.243-18-gfc7e8c68369a, first f=
ail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch   | lab             | compiler | defconfig      =
    | regressions
--------------------+--------+-----------------+----------+----------------=
----+------------
qemu_arm-virt-gicv2 | arm    | lab-broonie     | gcc-8    | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fbad0c834c677062bd8d918

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.245-1=
5-g0aeeacb1b87e/arm/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-=
virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.245-1=
5-g0aeeacb1b87e/arm/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-=
virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fbad0c834c677062bd8d=
919
        failing since 9 days (last pass: v4.4.243-18-gfc7e8c68369a, first f=
ail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch   | lab             | compiler | defconfig      =
    | regressions
--------------------+--------+-----------------+----------+----------------=
----+------------
qemu_arm-virt-gicv2 | arm    | lab-cip         | gcc-8    | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fbad148ee19494fcfd8d913

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.245-1=
5-g0aeeacb1b87e/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-virt=
-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.245-1=
5-g0aeeacb1b87e/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-virt=
-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fbad148ee19494fcfd8d=
914
        failing since 9 days (last pass: v4.4.243-18-gfc7e8c68369a, first f=
ail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch   | lab             | compiler | defconfig      =
    | regressions
--------------------+--------+-----------------+----------+----------------=
----+------------
qemu_arm-virt-gicv2 | arm    | lab-linaro-lkft | gcc-8    | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fbad0c62d7bce5128d8d90c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.245-1=
5-g0aeeacb1b87e/arm/multi_v7_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_=
arm-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.245-1=
5-g0aeeacb1b87e/arm/multi_v7_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_=
arm-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fbad0c62d7bce5128d8d=
90d
        failing since 9 days (last pass: v4.4.243-18-gfc7e8c68369a, first f=
ail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch   | lab             | compiler | defconfig      =
    | regressions
--------------------+--------+-----------------+----------+----------------=
----+------------
qemu_arm-virt-gicv3 | arm    | lab-baylibre    | gcc-8    | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fbad121ab7c18a352d8d8fd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.245-1=
5-g0aeeacb1b87e/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm=
-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.245-1=
5-g0aeeacb1b87e/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm=
-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fbad121ab7c18a352d8d=
8fe
        failing since 9 days (last pass: v4.4.243-18-gfc7e8c68369a, first f=
ail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch   | lab             | compiler | defconfig      =
    | regressions
--------------------+--------+-----------------+----------+----------------=
----+------------
qemu_arm-virt-gicv3 | arm    | lab-broonie     | gcc-8    | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fbad0c434c677062bd8d913

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.245-1=
5-g0aeeacb1b87e/arm/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-=
virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.245-1=
5-g0aeeacb1b87e/arm/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-=
virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fbad0c434c677062bd8d=
914
        failing since 9 days (last pass: v4.4.243-18-gfc7e8c68369a, first f=
ail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch   | lab             | compiler | defconfig      =
    | regressions
--------------------+--------+-----------------+----------+----------------=
----+------------
qemu_arm-virt-gicv3 | arm    | lab-cip         | gcc-8    | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fbad1b43a65e9f490d8d903

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.245-1=
5-g0aeeacb1b87e/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-virt=
-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.245-1=
5-g0aeeacb1b87e/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-virt=
-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fbad1b43a65e9f490d8d=
904
        failing since 9 days (last pass: v4.4.243-18-gfc7e8c68369a, first f=
ail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch   | lab             | compiler | defconfig      =
    | regressions
--------------------+--------+-----------------+----------+----------------=
----+------------
qemu_arm-virt-gicv3 | arm    | lab-linaro-lkft | gcc-8    | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fbad0c7f8cd4ab1e8d8d91c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.245-1=
5-g0aeeacb1b87e/arm/multi_v7_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_=
arm-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.245-1=
5-g0aeeacb1b87e/arm/multi_v7_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_=
arm-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fbad0c7f8cd4ab1e8d8d=
91d
        failing since 9 days (last pass: v4.4.243-18-gfc7e8c68369a, first f=
ail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch   | lab             | compiler | defconfig      =
    | regressions
--------------------+--------+-----------------+----------+----------------=
----+------------
qemu_i386           | i386   | lab-baylibre    | gcc-8    | i386_defconfig =
    | 1          =


  Details:     https://kernelci.org/test/plan/id/5fbacf840ace5741acd8d91b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.245-1=
5-g0aeeacb1b87e/i386/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i386.t=
xt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.245-1=
5-g0aeeacb1b87e/i386/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i386.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fbacf840ace5741acd8d=
91c
        failing since 0 day (last pass: v4.4.244-15-g83f2d7d5a61c, first fa=
il: v4.4.245-12-g8a61cf9912489) =

 =



platform            | arch   | lab             | compiler | defconfig      =
    | regressions
--------------------+--------+-----------------+----------+----------------=
----+------------
qemu_i386           | i386   | lab-cip         | gcc-8    | i386_defconfig =
    | 1          =


  Details:     https://kernelci.org/test/plan/id/5fbacfc279540ff70ed8d905

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.245-1=
5-g0aeeacb1b87e/i386/i386_defconfig/gcc-8/lab-cip/baseline-qemu_i386.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.245-1=
5-g0aeeacb1b87e/i386/i386_defconfig/gcc-8/lab-cip/baseline-qemu_i386.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fbacfc279540ff70ed8d=
906
        failing since 0 day (last pass: v4.4.244-15-g83f2d7d5a61c, first fa=
il: v4.4.245-12-g8a61cf9912489) =

 =



platform            | arch   | lab             | compiler | defconfig      =
    | regressions
--------------------+--------+-----------------+----------+----------------=
----+------------
qemu_i386-uefi      | i386   | lab-baylibre    | gcc-8    | i386_defconfig =
    | 1          =


  Details:     https://kernelci.org/test/plan/id/5fbacf75fd6e9b831dd8d900

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.245-1=
5-g0aeeacb1b87e/i386/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i386-u=
efi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.245-1=
5-g0aeeacb1b87e/i386/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i386-u=
efi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fbacf75fd6e9b831dd8d=
901
        failing since 0 day (last pass: v4.4.244-15-g944231f27c48, first fa=
il: v4.4.244-15-g83f2d7d5a61c) =

 =



platform            | arch   | lab             | compiler | defconfig      =
    | regressions
--------------------+--------+-----------------+----------+----------------=
----+------------
qemu_x86_64         | x86_64 | lab-baylibre    | gcc-8    | x86_64_defconfi=
g   | 1          =


  Details:     https://kernelci.org/test/plan/id/5fbacfe6173207d0efd8d92d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.245-1=
5-g0aeeacb1b87e/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu_x8=
6_64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.245-1=
5-g0aeeacb1b87e/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu_x8=
6_64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fbacfe6173207d0efd8d=
92e
        new failure (last pass: v4.4.245-12-g8a61cf9912489) =

 =



platform            | arch   | lab             | compiler | defconfig      =
    | regressions
--------------------+--------+-----------------+----------+----------------=
----+------------
qemu_x86_64-uefi    | x86_64 | lab-baylibre    | gcc-8    | x86_64_defconfi=
g   | 1          =


  Details:     https://kernelci.org/test/plan/id/5fbacff27d79d9bdcbd8d902

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.245-1=
5-g0aeeacb1b87e/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu_x8=
6_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.245-1=
5-g0aeeacb1b87e/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu_x8=
6_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fbacff27d79d9bdcbd8d=
903
        failing since 0 day (last pass: v4.4.244-15-g83f2d7d5a61c, first fa=
il: v4.4.245-12-g8a61cf9912489) =

 =



platform            | arch   | lab             | compiler | defconfig      =
    | regressions
--------------------+--------+-----------------+----------+----------------=
----+------------
qemu_x86_64-uefi    | x86_64 | lab-cip         | gcc-8    | x86_64_defconfi=
g   | 1          =


  Details:     https://kernelci.org/test/plan/id/5fbad0327227d20cc8d8d921

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.245-1=
5-g0aeeacb1b87e/x86_64/x86_64_defconfig/gcc-8/lab-cip/baseline-qemu_x86_64-=
uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.245-1=
5-g0aeeacb1b87e/x86_64/x86_64_defconfig/gcc-8/lab-cip/baseline-qemu_x86_64-=
uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fbad0327227d20cc8d8d=
922
        failing since 0 day (last pass: v4.4.244-15-g83f2d7d5a61c, first fa=
il: v4.4.245-12-g8a61cf9912489) =

 =20
