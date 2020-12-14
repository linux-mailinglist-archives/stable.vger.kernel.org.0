Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA01E2D926F
	for <lists+stable@lfdr.de>; Mon, 14 Dec 2020 06:09:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728545AbgLNFHj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Dec 2020 00:07:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725776AbgLNFHh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Dec 2020 00:07:37 -0500
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 460E5C0613D3
        for <stable@vger.kernel.org>; Sun, 13 Dec 2020 21:06:57 -0800 (PST)
Received: by mail-pg1-x529.google.com with SMTP id w5so10908939pgj.3
        for <stable@vger.kernel.org>; Sun, 13 Dec 2020 21:06:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=kp7NlKDIQ3GrgjggutU4tIH38PhuF00yq+0TzbJDs4g=;
        b=Co3x5zZMzn3G4VSoQ8vQ+/R7rDmJ/vilZ587A0p7RTFQFGy0sJdDCEyN40wBQAjYaQ
         KkHhRvCfOeRsPVvhOposdtw9T+U6CJKQPzJFf6WRC7IMJDoFnD5JOoh4dlN/DVWvzkOX
         Dbzg+/HJxx1byakK/zMzX8PMPrD1Jl68W9NXhYSnwAcZDJ+lPbMl/Lc9aEP5nPSCNOJU
         qQ2YJyQndUqo2xa/5DdIXukHzUxwU34m7zc8I8SRpXmIgXxbJijzGAqa16aZ2W6oYXJZ
         gMoIEUC9/CRlPn8ThSRz1TsHN5xZa8YiyY7WrkzZRZJ28seU8wTWvxWsArIS7fNld8le
         S7QA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=kp7NlKDIQ3GrgjggutU4tIH38PhuF00yq+0TzbJDs4g=;
        b=rza7+DkV+cxw8H8b26UjuVoV0G8Ac6jUJFAfXY/D82Xmasl0myR6yIRHkq0F/uqioh
         jv/Dda0qvBnckihzv8HVuRiRmcH6kBq7kYtkklR3INOXvQkFF9+e7S6TGM32O9d8BKu1
         vFgX9mfTYESr1FNp4MVZlSYRhovMiuiIq4KZ+fZZir+F18c0GJE925OPDvVP4y+72Acu
         8HT2E8+ZJG1KJpaVYHXChyDRzaxxQ4Me9yJaWXnzGTA24w9UjT1gR67ejnEScjG7/HW8
         q2vFd72LMNHhdU6s3eQtbEtftLOHd9WehN+QZ3NlB+f9XfmylXB0BxDQGacCm1wAysFO
         ZWvA==
X-Gm-Message-State: AOAM531GU+2b+mIfYnTX4x92bNpqFX38DcmGpjhZUs9Qj/7EMGwujCgQ
        86TBC465t4Vy15mjAhzCz+rwhTbV8LOuHA==
X-Google-Smtp-Source: ABdhPJx21aNXGT6hc7hqKt/qVhL0b9zCWMerK3UhAgioFy2SUosqytHwlpSxMzrH8RfFv5t1X4d2bw==
X-Received: by 2002:a62:2ec4:0:b029:18e:f566:d459 with SMTP id u187-20020a622ec40000b029018ef566d459mr22354902pfu.80.1607922416403;
        Sun, 13 Dec 2020 21:06:56 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id a31sm12353634pgb.93.2020.12.13.21.06.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Dec 2020 21:06:55 -0800 (PST)
Message-ID: <5fd6f2ef.1c69fb81.23669.a8c1@mx.google.com>
Date:   Sun, 13 Dec 2020 21:06:55 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.4
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.4.83-22-gd980ab12fc40
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.4 baseline: 186 runs,
 5 regressions (v5.4.83-22-gd980ab12fc40)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 186 runs, 5 regressions (v5.4.83-22-gd980ab12=
fc40)

Regressions Summary
-------------------

platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
hifive-unleashed-a00 | riscv | lab-baylibre    | gcc-8    | defconfig      =
     | 1          =

qemu_arm-versatilepb | arm   | lab-baylibre    | gcc-8    | versatile_defco=
nfig | 1          =

qemu_arm-versatilepb | arm   | lab-cip         | gcc-8    | versatile_defco=
nfig | 1          =

qemu_arm-versatilepb | arm   | lab-collabora   | gcc-8    | versatile_defco=
nfig | 1          =

qemu_arm-versatilepb | arm   | lab-linaro-lkft | gcc-8    | versatile_defco=
nfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.83-22-gd980ab12fc40/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.83-22-gd980ab12fc40
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      d980ab12fc4005ffdd5b657ed0c8d391e16473e0 =



Test Regressions
---------------- =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
hifive-unleashed-a00 | riscv | lab-baylibre    | gcc-8    | defconfig      =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/5fd6bebb14477876f3c94cc4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (riscv64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.83-22=
-gd980ab12fc40/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleashed=
-a00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.83-22=
-gd980ab12fc40/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleashed=
-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/riscv/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fd6bebb14477876f3c94=
cc5
        failing since 23 days (last pass: v5.4.78-5-g843222460ebea, first f=
ail: v5.4.78-13-g81acf0f7c6ec) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-baylibre    | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fd6be2c5be717c82cc94cd8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.83-22=
-gd980ab12fc40/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.83-22=
-gd980ab12fc40/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fd6be2c5be717c82cc94=
cd9
        failing since 30 days (last pass: v5.4.77-44-gce6b18c3a8969, first =
fail: v5.4.77-45-gfd610189f77e1) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-cip         | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fd6be50e50261ee0bc94cb9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.83-22=
-gd980ab12fc40/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-vers=
atilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.83-22=
-gd980ab12fc40/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-vers=
atilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fd6be50e50261ee0bc94=
cba
        failing since 30 days (last pass: v5.4.77-44-gce6b18c3a8969, first =
fail: v5.4.77-45-gfd610189f77e1) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-collabora   | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fd6bdf172d2404c98c94ccc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.83-22=
-gd980ab12fc40/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.83-22=
-gd980ab12fc40/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fd6bdf172d2404c98c94=
ccd
        failing since 30 days (last pass: v5.4.77-44-gce6b18c3a8969, first =
fail: v5.4.77-45-gfd610189f77e1) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-linaro-lkft | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fd6be02550adb2690c94ce7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.83-22=
-gd980ab12fc40/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.83-22=
-gd980ab12fc40/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fd6be02550adb2690c94=
ce8
        failing since 30 days (last pass: v5.4.77-44-gce6b18c3a8969, first =
fail: v5.4.77-45-gfd610189f77e1) =

 =20
