Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AF3421C122
	for <lists+stable@lfdr.de>; Sat, 11 Jul 2020 02:27:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726605AbgGKA11 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Jul 2020 20:27:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726581AbgGKA11 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Jul 2020 20:27:27 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F570C08C5DC
        for <stable@vger.kernel.org>; Fri, 10 Jul 2020 17:27:27 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id x9so2917886plr.2
        for <stable@vger.kernel.org>; Fri, 10 Jul 2020 17:27:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=qs4WyXbkFajIqNH7sVCWQMqw3zXnJvRbwhZxK/yyfbQ=;
        b=EdtNZWLMVlh1DWtfI5wgFylRAIkTgb0VOA0HFe5W18QV9q5GdSnYGxztXrud24s2md
         y/CY1ALQ9tYu0FhsxSOvYnKobtAA5Ok6z/gAec8jfXcnVu08QsN8zV65gCECW3RizZK6
         +QcEzljRfJKyuwd8HJSwBmxdudzo7ffPyCSSDaq8f+KCgXdLEOfbu0z7x1Cyl3I0m7aD
         w/ev8dqwbj5ArrMwYWKQbVULfYTU9czcxXdIXM7pdYfKuRjDoQE4l0PZOaWhSyzb2hi6
         uks9D9BPcD48+pEc7Gtrgb111wiRUXQd+53o93KG0WWf2aREU2ZBjTPqetcay/rjQwJd
         K4sQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=qs4WyXbkFajIqNH7sVCWQMqw3zXnJvRbwhZxK/yyfbQ=;
        b=a/8QtrzoZD4TDGpuJ0Zur9FjOPaTDWIYz8e7nsd+iBWU4xpj3ls+Dq13ToyNtDyyNU
         jpVC2ZXPEqyclvx5Ls+K1mriACbBBpk39GpJjCoug/EcKDqoYGafoIc0aLpBeiGzbvSG
         51aH7GtHHnaQ0BPnaqIO6lN7wwT8U1zKyc/Qu64gGdMQ3S31ulVlkEzGuUsDn6eH5sAu
         vrwl2kYTv/7CEmxnw1omlrG1O6Fe+MnfEcCgXVoJ8fOlF8t62YFQc0AAH4+xvsdZ1vCY
         Feb9SzO4R6HjfelfDiRepIy52p9UmeSz845eeHc1MUGzGMwR0GEY6BC59cYOh7TIrkuM
         gx2g==
X-Gm-Message-State: AOAM532IoyOglSuKZwGp67uFXoWmtxIXSCr96CqK4uXZtCgxNTd9bpZb
        UTa17+XR8JRIfPDh8g5oVybXTVf0ulg=
X-Google-Smtp-Source: ABdhPJz4CulXUZTiF+j6Ts0p9gLBm0rMiFzVrGWbIDIELhxS++5ny7sFGK9OKe5+TcUCAQ3k5YG5+w==
X-Received: by 2002:a17:90a:784b:: with SMTP id y11mr8483893pjl.51.1594427246293;
        Fri, 10 Jul 2020 17:27:26 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id k23sm6746993pgb.92.2020.07.10.17.27.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jul 2020 17:27:25 -0700 (PDT)
Message-ID: <5f09076d.1c69fb81.c2ead.0313@mx.google.com>
Date:   Fri, 10 Jul 2020 17:27:25 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.4.51
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-5.4.y
Subject: stable/linux-5.4.y baseline: 102 runs, 4 regressions (v5.4.51)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.4.y baseline: 102 runs, 4 regressions (v5.4.51)

Regressions Summary
-------------------

platform              | arch   | lab          | compiler | defconfig       =
 | results
----------------------+--------+--------------+----------+-----------------=
-+--------
at91-sama5d4_xplained | arm    | lab-baylibre | gcc-8    | sama5_defconfig =
 | 0/1    =

bcm2837-rpi-3-b       | arm64  | lab-baylibre | gcc-8    | defconfig       =
 | 4/5    =

qemu_i386             | i386   | lab-baylibre | gcc-8    | i386_defconfig  =
 | 0/1    =

qemu_x86_64           | x86_64 | lab-baylibre | gcc-8    | x86_64_defconfig=
 | 0/1    =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.4.y/kernel/=
v5.4.51/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.4.y
  Describe: v5.4.51
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      1c54d3c15afacf179c07ce6c57a0d43f412f1b3a =



Test Regressions
---------------- =



platform              | arch   | lab          | compiler | defconfig       =
 | results
----------------------+--------+--------------+----------+-----------------=
-+--------
at91-sama5d4_xplained | arm    | lab-baylibre | gcc-8    | sama5_defconfig =
 | 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f08cf280c95683a2f85bb20

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sama5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.51/arm=
/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5d4_xplained.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.51/arm=
/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5d4_xplained.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2019=
.02-11-g17e793fa4728/armel/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f08cf280c95683a2f85b=
b21
      failing since 23 days (last pass: v5.4.46, first fail: v5.4.47) =



platform              | arch   | lab          | compiler | defconfig       =
 | results
----------------------+--------+--------------+----------+-----------------=
-+--------
bcm2837-rpi-3-b       | arm64  | lab-baylibre | gcc-8    | defconfig       =
 | 4/5    =


  Details:     https://kernelci.org/test/plan/id/5f08d1b3fbdbfe93df85bb19

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.51/arm=
64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.51/arm=
64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2019=
.02-11-g17e793fa4728/arm64/baseline/rootfs.cpio.gz =


  * baseline.dmesg.crit: https://kernelci.org/test/case/id/5f08d1b3fbdbfe93=
df85bb1c
      failing since 9 days (last pass: v5.4.49, first fail: v5.4.50)
      3 lines =



platform              | arch   | lab          | compiler | defconfig       =
 | results
----------------------+--------+--------------+----------+-----------------=
-+--------
qemu_i386             | i386   | lab-baylibre | gcc-8    | i386_defconfig  =
 | 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f08d3e2603b864bdf85bb4b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.51/i38=
6/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i386.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.51/i38=
6/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i386.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2019=
.02-11-g17e793fa4728/x86/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f08d3e2603b864bdf85b=
b4c
      new failure (last pass: v5.4.49) =



platform              | arch   | lab          | compiler | defconfig       =
 | results
----------------------+--------+--------------+----------+-----------------=
-+--------
qemu_x86_64           | x86_64 | lab-baylibre | gcc-8    | x86_64_defconfig=
 | 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f08d4014d07bf4e0985bb75

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.51/x86=
_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu_x86_64.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.51/x86=
_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu_x86_64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2019=
.02-11-g17e793fa4728/x86/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f08d4014d07bf4e0985b=
b76
      new failure (last pass: v5.4.45) =20
