Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A6E72EA2A4
	for <lists+stable@lfdr.de>; Tue,  5 Jan 2021 02:10:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728620AbhAEBEp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jan 2021 20:04:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728373AbhAEBEp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Jan 2021 20:04:45 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0DA5C061574
        for <stable@vger.kernel.org>; Mon,  4 Jan 2021 17:04:04 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id w1so546633pjc.0
        for <stable@vger.kernel.org>; Mon, 04 Jan 2021 17:04:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Sgb9HlTKghxsF+8I0z0ERDqLShCCT88LB6XVfQEPPU0=;
        b=btn8SepfPNtp8PExuXa3tWijDS9iiwMk9LLgvpAszlrnwbeGKT78dLhdaWhV+xRhkG
         7mZ7MIqGK2J0WVhuLNkJcOzQldOTLS17ZMwiy3468Rbb1Q+gLx/JyIJUE1kkpbHTmB4+
         9MhUvD5ufQyf4wSadlNg5tvynBbD3pRtKpqlKWopZwtcTkLZ6aF3LUUqGpQigNvvYOOH
         U39Zf6riRJfX8dDXb+3FnzJotrPQpih54MygjB1QV9Z7iY+W80P3KwLD9nxi+g7DcxZ1
         QjGZePvUbOXY8dgC+Sf8kb8P7fnxvCA7PyzdpPWX3d2ZIOhrL5t15vAefLGudnLkSQBb
         LjSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Sgb9HlTKghxsF+8I0z0ERDqLShCCT88LB6XVfQEPPU0=;
        b=ePqzmuBEq0sh4fMsI7JbtH+zfzzsxSz2G0GG3rFMgNXz0bNPLZjNT52wPHjBx/BsEB
         IxC8iK0bmvqJEC2DSVezQJ+3QAxxrAlCuQzUzed7L84DAKw0GzX7JyxH+wzcBTgmba1c
         NA3VrKZOXzlxVQUNb75Qst5avPAYPw7ugA1XMjC+Rq8npUQqM6ChBrsJ2sQy8k6gSkjs
         7Ql3CQq+ZyHJwZ10BdhNQTtwnWiqqHv3++6s/hnMUs55zpcXa3thyhWSn+JDryv2wXsD
         vNwIm6Hfo2ZH1aOMRSeIyluH0ZZ9e0ZTrHLqpvmEaa+6WYi4Kgacl110/xttYjvdRarC
         wYZA==
X-Gm-Message-State: AOAM531ZPwMrI+rMAyg7avYb1g1ztgsaHa6xlDe+gAZpuGPzjsvned1p
        VKMYyH9/i38MaE+JWVbcnljHr6m2XC6JOg==
X-Google-Smtp-Source: ABdhPJwDEykIK9GV9YNMS+UZmoZjV1h9DCsfDLvq5RyXxZGLSTlsw+HTXYm+dVdOwBQa4blF3MNtJQ==
X-Received: by 2002:a17:90a:a2a:: with SMTP id o39mr1478182pjo.161.1609808644012;
        Mon, 04 Jan 2021 17:04:04 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id j23sm43317801pgj.34.2021.01.04.17.04.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Jan 2021 17:04:03 -0800 (PST)
Message-ID: <5ff3bb03.1c69fb81.51e1f.6367@mx.google.com>
Date:   Mon, 04 Jan 2021 17:04:03 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable
X-Kernelci-Kernel: v4.14.213
X-Kernelci-Report-Type: test
Subject: stable/linux-4.14.y baseline: 136 runs, 7 regressions (v4.14.213)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.14.y baseline: 136 runs, 7 regressions (v4.14.213)

Regressions Summary
-------------------

platform                   | arch  | lab           | compiler | defconfig  =
         | regressions
---------------------------+-------+---------------+----------+------------=
---------+------------
meson-gxbb-p200            | arm64 | lab-baylibre  | gcc-8    | defconfig  =
         | 1          =

meson-gxl-s905x-khadas-vim | arm64 | lab-baylibre  | gcc-8    | defconfig  =
         | 1          =

panda                      | arm   | lab-collabora | gcc-8    | omap2plus_d=
efconfig | 1          =

qemu_arm-versatilepb       | arm   | lab-baylibre  | gcc-8    | versatile_d=
efconfig | 1          =

qemu_arm-versatilepb       | arm   | lab-broonie   | gcc-8    | versatile_d=
efconfig | 1          =

qemu_arm-versatilepb       | arm   | lab-cip       | gcc-8    | versatile_d=
efconfig | 1          =

qemu_arm-versatilepb       | arm   | lab-collabora | gcc-8    | versatile_d=
efconfig | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-4.14.y/kernel=
/v4.14.213/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-4.14.y
  Describe: v4.14.213
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      1752938529c614a8ed4432ecce6ebc95d3b87207 =



Test Regressions
---------------- =



platform                   | arch  | lab           | compiler | defconfig  =
         | regressions
---------------------------+-------+---------------+----------+------------=
---------+------------
meson-gxbb-p200            | arm64 | lab-baylibre  | gcc-8    | defconfig  =
         | 1          =


  Details:     https://kernelci.org/test/plan/id/5ff38b0ebd80c7c69ac94cba

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.14.y/v4.14.213/=
arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-p200.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.14.y/v4.14.213/=
arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-p200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5ff38b0ebd80c7c69ac94=
cbb
        failing since 277 days (last pass: v4.14.172, first fail: v4.14.175=
) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
         | regressions
---------------------------+-------+---------------+----------+------------=
---------+------------
meson-gxl-s905x-khadas-vim | arm64 | lab-baylibre  | gcc-8    | defconfig  =
         | 1          =


  Details:     https://kernelci.org/test/plan/id/5ff38a37b32874e2dac94cba

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.14.y/v4.14.213/=
arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxl-s905x-khadas-vim.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.14.y/v4.14.213/=
arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxl-s905x-khadas-vim.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5ff38a37b32874e2dac94=
cbb
        new failure (last pass: v4.14.212) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
         | regressions
---------------------------+-------+---------------+----------+------------=
---------+------------
panda                      | arm   | lab-collabora | gcc-8    | omap2plus_d=
efconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5ff387ae0539ba4113c94cc4

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.14.y/v4.14.213/=
arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.14.y/v4.14.213/=
arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5ff387ae0539ba4=
113c94cc9
        failing since 33 days (last pass: v4.14.209, first fail: v4.14.210)
        2 lines

    2021-01-04 21:24:58.605000+00:00  kern  :emerg : BUG: spinlock bad magi=
c on CPU#0, udevd/95
    2021-01-04 21:24:58.614000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xffffed34 [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =



platform                   | arch  | lab           | compiler | defconfig  =
         | regressions
---------------------------+-------+---------------+----------+------------=
---------+------------
qemu_arm-versatilepb       | arm   | lab-baylibre  | gcc-8    | versatile_d=
efconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5ff38610f18136587fc94cca

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.14.y/v4.14.213/=
arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.14.y/v4.14.213/=
arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5ff38610f18136587fc94=
ccb
        failing since 47 days (last pass: v4.14.206, first fail: v4.14.207) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
         | regressions
---------------------------+-------+---------------+----------+------------=
---------+------------
qemu_arm-versatilepb       | arm   | lab-broonie   | gcc-8    | versatile_d=
efconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5ff386232aa2f83e5bc94cb9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.14.y/v4.14.213/=
arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.14.y/v4.14.213/=
arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5ff386232aa2f83e5bc94=
cba
        failing since 47 days (last pass: v4.14.206, first fail: v4.14.207) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
         | regressions
---------------------------+-------+---------------+----------+------------=
---------+------------
qemu_arm-versatilepb       | arm   | lab-cip       | gcc-8    | versatile_d=
efconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5ff3861879ae2929a1c94ce7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.14.y/v4.14.213/=
arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.14.y/v4.14.213/=
arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5ff3861879ae2929a1c94=
ce8
        failing since 47 days (last pass: v4.14.206, first fail: v4.14.207) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
         | regressions
---------------------------+-------+---------------+----------+------------=
---------+------------
qemu_arm-versatilepb       | arm   | lab-collabora | gcc-8    | versatile_d=
efconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5ff3888bb3e43b9fecc94ceb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.14.y/v4.14.213/=
arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilepb.t=
xt
  HTML log:    https://storage.kernelci.org//stable/linux-4.14.y/v4.14.213/=
arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilepb.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5ff3888bb3e43b9fecc94=
cec
        failing since 47 days (last pass: v4.14.206, first fail: v4.14.207) =

 =20
