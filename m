Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83EA8330378
	for <lists+stable@lfdr.de>; Sun,  7 Mar 2021 18:56:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230455AbhCGR4I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Mar 2021 12:56:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231703AbhCGRzt (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 7 Mar 2021 12:55:49 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0689BC06174A
        for <stable@vger.kernel.org>; Sun,  7 Mar 2021 09:55:48 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id cl21-20020a17090af695b02900c61ac0f0e9so3394331pjb.1
        for <stable@vger.kernel.org>; Sun, 07 Mar 2021 09:55:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=d1nBIRujURFVfksFWM0cahbNBJpDUGrIH45CR8dISaY=;
        b=WUxl31sVCVSrh23ZUDcdmjomSmrsBEbdMB6uTHbhJAGnO8NKqa55YSNhY/xG9br6tG
         UGUC7tlHFrgNUTfKIBEm1Or0lsncM6zpDurFsOcTCvfZ1dNG1iVKQOkCuA3HTMIb/NSU
         QC6CpgIGz9zAif4S0En0SWaXUyg7GTNybqCH2u6pDndIRKH2HI5hC2noD6Mmm17HkhOW
         FsdQpaChnp09Unre54OT60ut6XZOr8OJq2yTEkLgbqJaS+3VTD8Dg4Lo6v4xk4q08EYc
         ffm8+q4zh7wmxyQYP6b2hwiFNrd6Uya3TcxasFSNLmkHTyoxwS9T8qZ1gPS07UZ6p6/K
         T+4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=d1nBIRujURFVfksFWM0cahbNBJpDUGrIH45CR8dISaY=;
        b=AFUi/HmK8ZSCjQlrZuFfQ1yzf2FjJkvpB++BV84htEERz6d5RyUHGlSZVb547jAz03
         PZsYpdUBEvgexiuIyruAmvqeR5xqpscUFE3b3VwwuNmwgTbZh95iwRcRqipWSBt604MF
         QMf96uts1t+3Z/jAApHwtgJ8uAUEgU8dEJLKm5VyCHg5KuS6VrjYgrcrNO/NqL4DPty4
         It6Z4IjCPdBwyoR8xlP+jxei8Rjli96rJysoDnkP5xvt3PVNG0EzKaXnIoNkwUuJhGg3
         rFNUEuMYOOsHtwdoW7MTqenlVloedTS76oAvMWpBSXrNnwi+0A6alkFtFQTYu9JEqurJ
         DdUA==
X-Gm-Message-State: AOAM53159zHjbZCUJp7UaSuDxK55wE0M0naEsnoare3Gu0sJ4z98nwRK
        RD0gRlC4fWjDo5+eY+iWZ3nJbZ3KG3kdOQ==
X-Google-Smtp-Source: ABdhPJwTLZrd1BqjqZcJC6MkUszL+vx0q2m1P9Jg6KZO0B4+cGcc2RSgh7hb4uRgclSc6odgVQk5hg==
X-Received: by 2002:a17:90a:ff91:: with SMTP id hf17mr17960576pjb.34.1615139748343;
        Sun, 07 Mar 2021 09:55:48 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 197sm3596439pgg.53.2021.03.07.09.55.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 Mar 2021 09:55:48 -0800 (PST)
Message-ID: <604513a4.1c69fb81.802eb.83d6@mx.google.com>
Date:   Sun, 07 Mar 2021 09:55:48 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.4.103
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-5.4.y
Subject: stable/linux-5.4.y baseline: 172 runs, 7 regressions (v5.4.103)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.4.y baseline: 172 runs, 7 regressions (v5.4.103)

Regressions Summary
-------------------

platform             | arch   | lab             | compiler | defconfig     =
      | regressions
---------------------+--------+-----------------+----------+---------------=
------+------------
hifive-unleashed-a00 | riscv  | lab-baylibre    | gcc-8    | defconfig     =
      | 1          =

qemu_arm-versatilepb | arm    | lab-baylibre    | gcc-8    | versatile_defc=
onfig | 1          =

qemu_arm-versatilepb | arm    | lab-broonie     | gcc-8    | versatile_defc=
onfig | 1          =

qemu_arm-versatilepb | arm    | lab-cip         | gcc-8    | versatile_defc=
onfig | 1          =

qemu_arm-versatilepb | arm    | lab-collabora   | gcc-8    | versatile_defc=
onfig | 1          =

qemu_arm-versatilepb | arm    | lab-linaro-lkft | gcc-8    | versatile_defc=
onfig | 1          =

qemu_x86_64-uefi     | x86_64 | lab-baylibre    | gcc-8    | x86_64_defconf=
ig    | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.4.y/kernel/=
v5.4.103/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.4.y
  Describe: v5.4.103
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      c4ca4659678e07f0a14b3b143f6fb746efe11f88 =



Test Regressions
---------------- =



platform             | arch   | lab             | compiler | defconfig     =
      | regressions
---------------------+--------+-----------------+----------+---------------=
------+------------
hifive-unleashed-a00 | riscv  | lab-baylibre    | gcc-8    | defconfig     =
      | 1          =


  Details:     https://kernelci.org/test/plan/id/6044e00c7eaaead97eaddd14

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (riscv64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.103/ri=
scv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleashed-a00.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.103/ri=
scv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleashed-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/riscv/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6044e00c7eaaead97eadd=
d15
        failing since 108 days (last pass: v5.4.77, first fail: v5.4.78) =

 =



platform             | arch   | lab             | compiler | defconfig     =
      | regressions
---------------------+--------+-----------------+----------+---------------=
------+------------
qemu_arm-versatilepb | arm    | lab-baylibre    | gcc-8    | versatile_defc=
onfig | 1          =


  Details:     https://kernelci.org/test/plan/id/6044df631f92669ee8addcda

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.103/ar=
m/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.103/ar=
m/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6044df631f92669ee8add=
cdb
        failing since 108 days (last pass: v5.4.77, first fail: v5.4.78) =

 =



platform             | arch   | lab             | compiler | defconfig     =
      | regressions
---------------------+--------+-----------------+----------+---------------=
------+------------
qemu_arm-versatilepb | arm    | lab-broonie     | gcc-8    | versatile_defc=
onfig | 1          =


  Details:     https://kernelci.org/test/plan/id/6044fdfec76233b594addcd0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.103/ar=
m/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.103/ar=
m/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6044fdffc76233b594add=
cd1
        failing since 108 days (last pass: v5.4.77, first fail: v5.4.78) =

 =



platform             | arch   | lab             | compiler | defconfig     =
      | regressions
---------------------+--------+-----------------+----------+---------------=
------+------------
qemu_arm-versatilepb | arm    | lab-cip         | gcc-8    | versatile_defc=
onfig | 1          =


  Details:     https://kernelci.org/test/plan/id/6044ff8fe73dfb16c7addcbb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.103/ar=
m/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.103/ar=
m/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6044ff8fe73dfb16c7add=
cbc
        failing since 108 days (last pass: v5.4.77, first fail: v5.4.78) =

 =



platform             | arch   | lab             | compiler | defconfig     =
      | regressions
---------------------+--------+-----------------+----------+---------------=
------+------------
qemu_arm-versatilepb | arm    | lab-collabora   | gcc-8    | versatile_defc=
onfig | 1          =


  Details:     https://kernelci.org/test/plan/id/6044de12aa05d75106addcc2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.103/ar=
m/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.103/ar=
m/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6044de12aa05d75106add=
cc3
        failing since 108 days (last pass: v5.4.77, first fail: v5.4.78) =

 =



platform             | arch   | lab             | compiler | defconfig     =
      | regressions
---------------------+--------+-----------------+----------+---------------=
------+------------
qemu_arm-versatilepb | arm    | lab-linaro-lkft | gcc-8    | versatile_defc=
onfig | 1          =


  Details:     https://kernelci.org/test/plan/id/6044de1b8117855830addd04

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.103/ar=
m/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_arm-versatilepb.t=
xt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.103/ar=
m/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_arm-versatilepb.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6044de1b8117855830add=
d05
        failing since 108 days (last pass: v5.4.77, first fail: v5.4.78) =

 =



platform             | arch   | lab             | compiler | defconfig     =
      | regressions
---------------------+--------+-----------------+----------+---------------=
------+------------
qemu_x86_64-uefi     | x86_64 | lab-baylibre    | gcc-8    | x86_64_defconf=
ig    | 1          =


  Details:     https://kernelci.org/test/plan/id/6044dfca0efdb16461addd48

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.103/x8=
6_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu_x86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.103/x8=
6_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu_x86_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6044dfca0efdb16461add=
d49
        new failure (last pass: v5.4.102) =

 =20
