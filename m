Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11023422A15
	for <lists+stable@lfdr.de>; Tue,  5 Oct 2021 16:06:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235269AbhJEOIA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Oct 2021 10:08:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235347AbhJEOH5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Oct 2021 10:07:57 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CF66C061749
        for <stable@vger.kernel.org>; Tue,  5 Oct 2021 07:02:31 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id oa12-20020a17090b1bcc00b0019f715462a8so2559066pjb.3
        for <stable@vger.kernel.org>; Tue, 05 Oct 2021 07:02:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=9Z7D2UZlvYjI476tM/eb1EXELVl0Rvhs6Ds8VImMr1A=;
        b=asN9QvULxEaxtbkBXfRpvSj6Yi/7Ide41LKZuzLwmrsPDsSyRs+Pjp8lYC2NjhOo/J
         +Ak/k0/Ql7lnu4+qeFZZwrics5Hn3eNeI+zW9jEsBGafFAHNe6Qi9eIgLGxSVhloPDiB
         5Po4MMvt0he03XRlSWgrFL+iUGHOjw7p/AzQpENy/qM/nc26xxYU2Y7fzsITn8c0T8+l
         JQmDzjyBbxYUXVLrxy+9P8v6Ir/13Xnz4oWoXxYqi/mdWXb4nBqI/428BqO0iUN28stR
         X4YX7daf+aJu41X1j0NX0f2k97GXBdPUOdpawOrxG+my283ThfRnN/GdVGefeHRgCOsD
         h+ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=9Z7D2UZlvYjI476tM/eb1EXELVl0Rvhs6Ds8VImMr1A=;
        b=cUDpERu7peWQbiPdsCbh1yiqpccdWhe7ANRJfhsxZqZ3zZwufsmT39I4XYyUkF7Qzc
         Gw+1pWqZV0b6Y/a1dGKqPQNHPbzbs6awwYZ8qVm1paO0+bLkfLCIofOh0rdL+1NG5Rf5
         CQFT+CctpC95jcQdnrtamS8xm4ThlZ4T2XDE/B0Pjbq90EK5YmbtjFD0d6Zwsyp1rwZm
         4WU1Qk13BlMZwgsu/nlwl1vnUDg0YUoy5GirEeb6GhG48kq92FGcMwc9gDu0qwEEk0EO
         fX0L9/UMhqBaHG+xNg1mpVrmn7RMABw8GLrn6MAvDumXg8akxoz/IzytdqxJsv9PQoiw
         rbRg==
X-Gm-Message-State: AOAM533JNmB0yUAm3NGIHqTUkWerH7ntbprE7ilO7x9h8icuZEZoNAlx
        jhd4iMI+rBa7h9K584srS/JdUsqnZz9GeWZt
X-Google-Smtp-Source: ABdhPJyPHQ4oKCQVlPq7oABlp0epYlKyCcWLSkhrq20oX0b4nK5ZSjvVdcLB9NAm3phrXMbVzTAlOQ==
X-Received: by 2002:a17:90b:4c92:: with SMTP id my18mr4108574pjb.246.1633442549477;
        Tue, 05 Oct 2021 07:02:29 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id e20sm18101343pfc.11.2021.10.05.07.02.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Oct 2021 07:02:29 -0700 (PDT)
Message-ID: <615c5af5.1c69fb81.4942b.6e19@mx.google.com>
Date:   Tue, 05 Oct 2021 07:02:29 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.4.285-42-g72b93c725842
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.4.y
Subject: stable-rc/linux-4.4.y baseline: 73 runs,
 8 regressions (v4.4.285-42-g72b93c725842)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y baseline: 73 runs, 8 regressions (v4.4.285-42-g72b93c=
725842)

Regressions Summary
-------------------

platform            | arch   | lab           | compiler | defconfig        =
            | regressions
--------------------+--------+---------------+----------+------------------=
------------+------------
panda               | arm    | lab-collabora | gcc-8    | omap2plus_defconf=
ig          | 1          =

qemu_arm-virt-gicv2 | arm    | lab-baylibre  | gcc-8    | multi_v7_defconfi=
g           | 1          =

qemu_arm-virt-gicv2 | arm    | lab-broonie   | gcc-8    | multi_v7_defconfi=
g           | 1          =

qemu_arm-virt-gicv2 | arm    | lab-cip       | gcc-8    | multi_v7_defconfi=
g           | 1          =

qemu_arm-virt-gicv3 | arm    | lab-baylibre  | gcc-8    | multi_v7_defconfi=
g           | 1          =

qemu_arm-virt-gicv3 | arm    | lab-broonie   | gcc-8    | multi_v7_defconfi=
g           | 1          =

qemu_arm-virt-gicv3 | arm    | lab-cip       | gcc-8    | multi_v7_defconfi=
g           | 1          =

qemu_x86_64         | x86_64 | lab-broonie   | gcc-8    | x86_64_defcon...6=
-chromebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.4.y/kern=
el/v4.4.285-42-g72b93c725842/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.4.y
  Describe: v4.4.285-42-g72b93c725842
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      72b93c7258429eb65b95794f69218e8d8e0caeaa =



Test Regressions
---------------- =



platform            | arch   | lab           | compiler | defconfig        =
            | regressions
--------------------+--------+---------------+----------+------------------=
------------+------------
panda               | arm    | lab-collabora | gcc-8    | omap2plus_defconf=
ig          | 1          =


  Details:     https://kernelci.org/test/plan/id/615c2209f5a5429cb799a2f6

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.285=
-42-g72b93c725842/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.285=
-42-g72b93c725842/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/615c2209f5a5429=
cb799a2fc
        new failure (last pass: v4.4.285-42-g6bba7eb5c641)
        2 lines

    2021-10-05T09:59:20.631775  [   19.554718] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-10-05T09:59:20.682544  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/119
    2021-10-05T09:59:20.691289  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
26c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =



platform            | arch   | lab           | compiler | defconfig        =
            | regressions
--------------------+--------+---------------+----------+------------------=
------------+------------
qemu_arm-virt-gicv2 | arm    | lab-baylibre  | gcc-8    | multi_v7_defconfi=
g           | 1          =


  Details:     https://kernelci.org/test/plan/id/615c22ff8867fb6a8199a2da

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.285=
-42-g72b93c725842/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.285=
-42-g72b93c725842/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615c22ff8867fb6a8199a=
2db
        failing since 324 days (last pass: v4.4.243-14-gcb8e837cb602, first=
 fail: v4.4.243-20-g3c35b64319c2) =

 =



platform            | arch   | lab           | compiler | defconfig        =
            | regressions
--------------------+--------+---------------+----------+------------------=
------------+------------
qemu_arm-virt-gicv2 | arm    | lab-broonie   | gcc-8    | multi_v7_defconfi=
g           | 1          =


  Details:     https://kernelci.org/test/plan/id/615c3d99c1cb8691ff99a346

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.285=
-42-g72b93c725842/arm/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.285=
-42-g72b93c725842/arm/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615c3d99c1cb8691ff99a=
347
        failing since 324 days (last pass: v4.4.243-14-gcb8e837cb602, first=
 fail: v4.4.243-20-g3c35b64319c2) =

 =



platform            | arch   | lab           | compiler | defconfig        =
            | regressions
--------------------+--------+---------------+----------+------------------=
------------+------------
qemu_arm-virt-gicv2 | arm    | lab-cip       | gcc-8    | multi_v7_defconfi=
g           | 1          =


  Details:     https://kernelci.org/test/plan/id/615c24078dea226eb599a2ea

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.285=
-42-g72b93c725842/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-vi=
rt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.285=
-42-g72b93c725842/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-vi=
rt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615c24078dea226eb599a=
2eb
        failing since 324 days (last pass: v4.4.243-14-gcb8e837cb602, first=
 fail: v4.4.243-20-g3c35b64319c2) =

 =



platform            | arch   | lab           | compiler | defconfig        =
            | regressions
--------------------+--------+---------------+----------+------------------=
------------+------------
qemu_arm-virt-gicv3 | arm    | lab-baylibre  | gcc-8    | multi_v7_defconfi=
g           | 1          =


  Details:     https://kernelci.org/test/plan/id/615c23133c9140a20099a2f6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.285=
-42-g72b93c725842/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.285=
-42-g72b93c725842/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615c23133c9140a20099a=
2f7
        failing since 324 days (last pass: v4.4.243-14-gcb8e837cb602, first=
 fail: v4.4.243-20-g3c35b64319c2) =

 =



platform            | arch   | lab           | compiler | defconfig        =
            | regressions
--------------------+--------+---------------+----------+------------------=
------------+------------
qemu_arm-virt-gicv3 | arm    | lab-broonie   | gcc-8    | multi_v7_defconfi=
g           | 1          =


  Details:     https://kernelci.org/test/plan/id/615c3e257a082c8e6199a2f2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.285=
-42-g72b93c725842/arm/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.285=
-42-g72b93c725842/arm/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615c3e257a082c8e6199a=
2f3
        failing since 324 days (last pass: v4.4.243-14-gcb8e837cb602, first=
 fail: v4.4.243-20-g3c35b64319c2) =

 =



platform            | arch   | lab           | compiler | defconfig        =
            | regressions
--------------------+--------+---------------+----------+------------------=
------------+------------
qemu_arm-virt-gicv3 | arm    | lab-cip       | gcc-8    | multi_v7_defconfi=
g           | 1          =


  Details:     https://kernelci.org/test/plan/id/615c247ff014d9b23499a2ea

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.285=
-42-g72b93c725842/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-vi=
rt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.285=
-42-g72b93c725842/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-vi=
rt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615c247ff014d9b23499a=
2eb
        failing since 324 days (last pass: v4.4.243-14-gcb8e837cb602, first=
 fail: v4.4.243-20-g3c35b64319c2) =

 =



platform            | arch   | lab           | compiler | defconfig        =
            | regressions
--------------------+--------+---------------+----------+------------------=
------------+------------
qemu_x86_64         | x86_64 | lab-broonie   | gcc-8    | x86_64_defcon...6=
-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/615c3af0fa1f56ac5299a2e2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.285=
-42-g72b93c725842/x86_64/x86_64_defconfig+x86-chromebook/gcc-8/lab-broonie/=
baseline-qemu_x86_64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.285=
-42-g72b93c725842/x86_64/x86_64_defconfig+x86-chromebook/gcc-8/lab-broonie/=
baseline-qemu_x86_64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615c3af0fa1f56ac5299a=
2e3
        new failure (last pass: v4.4.285-42-g6bba7eb5c641) =

 =20
