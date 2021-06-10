Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE8003A33D0
	for <lists+stable@lfdr.de>; Thu, 10 Jun 2021 21:18:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230117AbhFJTUP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Jun 2021 15:20:15 -0400
Received: from mail-pg1-f169.google.com ([209.85.215.169]:43694 "EHLO
        mail-pg1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230035AbhFJTUP (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Jun 2021 15:20:15 -0400
Received: by mail-pg1-f169.google.com with SMTP id e22so523524pgv.10
        for <stable@vger.kernel.org>; Thu, 10 Jun 2021 12:18:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=j9H+1/JMHf7WMUjrhcrbeyUmxjVP97N3cwdExeXjYs0=;
        b=yV324mXmdzGyb3seBOGh/o895bzmbcd2IznOajnKlPn1Bw5fYsU9vfonbwAcPhVUHj
         lohkatToeDSMDa65elBAYOYDqB1SgJGod3M3Q4QKWUbpJWV4v0I61ML00UaZsETHDY5x
         pYpZBstWdtA2R7In4HQa0/4n/9e7BF918ixMXWP25b2eharCjY+KJ2egqK6Q33O7LExW
         APALPGF7MOODGZ1VzEH+jowPtFFnAGT+g5xya9cbSx7E31XvGiXvb67vTn+Jc5J6XHcD
         qfSNMo6hjNMvvV/HMbWrsFzTPQOuvydL7UpSDyyVvt5fT5HSa0s9Vq3J6w30K8ToAL0U
         Fxrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=j9H+1/JMHf7WMUjrhcrbeyUmxjVP97N3cwdExeXjYs0=;
        b=jJ82f/bw+rlMeqT7ibjPx6rVMT24qWJGQpGd05zcdT5rgV6rMj2dDnhkxmCjEkGNZj
         GjG0Ums8c0J2P2Rm0b3kHxWjH53rrGw5+kVVXzptAcfe3dSjK96k4r8pRLnhhfJRYLLK
         n9YEButidFM9+f5EEYYgicvUzqPMDnBU5QIJ26mDae7/m4f0BBcUfVqMiItR8/jsV8qK
         KC4ITfsxlBv6MOsEHmdhbWqvTuxRNATp0kcWnSCESTmv8B7TvsnQJb9gBYfJOzopdLYY
         tnoHvZquw11ptpJ1SroHC6q0MZ06OkKP3KhYMc6hW4waGn04lnafQqlPAG4QW7OoKAw1
         RIhQ==
X-Gm-Message-State: AOAM531glMpTRgluQolAltTJWhRD9/X7K2cfmpNcZMub9RFUwT/GhzaP
        1DNbzp8ycmdLTGKpJMsGBrx5DZEZZ+WKVDLo
X-Google-Smtp-Source: ABdhPJwlKQ8jxB4z95MsTSO/3ryK6tc23xwFXnj0pGZU/Q6kKJFWD48f/XdJui0YqqdrzWO0s1IAZg==
X-Received: by 2002:a63:4d0:: with SMTP id 199mr6436456pge.423.1623352625483;
        Thu, 10 Jun 2021 12:17:05 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id o16sm3044182pfu.75.2021.06.10.12.17.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Jun 2021 12:17:05 -0700 (PDT)
Message-ID: <60c26531.1c69fb81.1db42.9673@mx.google.com>
Date:   Thu, 10 Jun 2021 12:17:05 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.4.125
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-5.4.y
Subject: stable/linux-5.4.y baseline: 122 runs, 6 regressions (v5.4.125)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.4.y baseline: 122 runs, 6 regressions (v5.4.125)

Regressions Summary
-------------------

platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
bcm2837-rpi-3-b-32   | arm   | lab-baylibre  | gcc-8    | bcm2835_defconfig=
   | 1          =

hifive-unleashed-a00 | riscv | lab-baylibre  | gcc-8    | defconfig        =
   | 1          =

qemu_arm-versatilepb | arm   | lab-baylibre  | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-broonie   | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-cip       | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-collabora | gcc-8    | versatile_defconf=
ig | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.4.y/kernel/=
v5.4.125/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.4.y
  Describe: v5.4.125
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      3909e2374335335c9504467caabc906d3f7487e4 =



Test Regressions
---------------- =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
bcm2837-rpi-3-b-32   | arm   | lab-baylibre  | gcc-8    | bcm2835_defconfig=
   | 1          =


  Details:     https://kernelci.org/test/plan/id/60c22a1c1afbb518ea0c0e19

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.125/ar=
m/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b-32.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.125/ar=
m/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b-32.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/60c22a1c1afbb51=
8ea0c0e1e
        new failure (last pass: v5.4.124)
        64 lines

    2021-06-10 15:04:34.370000+00:00  kern  :emerg : Process udevd (pid: 90=
, stack limit =3D 0xeaeb5522)
    2021-06-10 15:04:34.371000+00:00  kern  :emerg : Stack: (0xeaf1bdc8 to =
0xeaf1c000)
    2021-06-10 15:04:34.372000+00:00  kern  :emerg : bdc0:                 =
  eaf1bde8 00000003 eaf1be34 c0d5c178 00000002 00000000
    2021-06-10 15:04:34.373000+00:00  kern  :emerg : bde0: 00000000 ea82a1c=
0 ffffffe0 c03b192c 00000000 00000000 00000000 ffffffff
    2021-06-10 15:04:34.374000+00:00  kern  :emerg : be00: ffffffff 013aedf=
e 00000000 eaf1beb8 c0d04248 eaf1bed0 ea82a1c0 eae983c0
    2021-06-10 15:04:34.413000+00:00  kern  :emerg : be20: be87d538 0000000=
0 eaf1be44 eaf1be38 c05e2e9c c069b9d8 eaf1bea4 eaf1be48
    2021-06-10 15:04:34.414000+00:00  kern  :emerg : be40: c05e2f78 c05e2e8=
c 00000028 00000000 00000000 00000005 00000000 00000000
    2021-06-10 15:04:34.415000+00:00  kern  :emerg : be60: eaf1beb0 0000000=
1 eaf1bed8 00000000 00000000 00000000 eaf1bed0 013aedfe
    2021-06-10 15:04:34.416000+00:00  kern  :emerg : be80: c0d04248 c0d0424=
8 eaf1bf50 eae983c0 00000000 00000000 eaf1bf24 eaf1bea8
    2021-06-10 15:04:34.417000+00:00  kern  :emerg : bea0: c023a174 c05e2ed=
4 00000000 ea848e58 be87d538 00000000 00000005 00000000 =

    ... (36 line(s) more)  =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
hifive-unleashed-a00 | riscv | lab-baylibre  | gcc-8    | defconfig        =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/60c229bb9f6b208e480c0e0f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (riscv64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.125/ri=
scv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleashed-a00.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.125/ri=
scv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleashed-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/riscv/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60c229bb9f6b208e480c0=
e10
        failing since 203 days (last pass: v5.4.77, first fail: v5.4.78) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-baylibre  | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/60c2294c34941d37090c0e13

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.125/ar=
m/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.125/ar=
m/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60c2294c34941d37090c0=
e14
        failing since 203 days (last pass: v5.4.77, first fail: v5.4.78) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-broonie   | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/60c2294e34941d37090c0e19

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.125/ar=
m/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.125/ar=
m/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60c2294e34941d37090c0=
e1a
        failing since 203 days (last pass: v5.4.77, first fail: v5.4.78) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-cip       | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/60c2295434941d37090c0e1f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.125/ar=
m/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.125/ar=
m/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60c2295434941d37090c0=
e20
        failing since 203 days (last pass: v5.4.77, first fail: v5.4.78) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-collabora | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/60c228fac39900c4330c0dfe

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.125/ar=
m/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.125/ar=
m/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60c228fac39900c4330c0=
dff
        failing since 203 days (last pass: v5.4.77, first fail: v5.4.78) =

 =20
