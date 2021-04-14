Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF10C35F665
	for <lists+stable@lfdr.de>; Wed, 14 Apr 2021 16:46:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232380AbhDNOos (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Apr 2021 10:44:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344890AbhDNOom (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Apr 2021 10:44:42 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CABFEC061574
        for <stable@vger.kernel.org>; Wed, 14 Apr 2021 07:44:18 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id p16so6269118plf.12
        for <stable@vger.kernel.org>; Wed, 14 Apr 2021 07:44:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=mSbtw5uzlAG/2TI3Y32QpvnB9Gwp7DRumY30zyIIdw4=;
        b=WwTRz78ko5DncFKRc26SeT9yRwVN8+fjOri79o/czC/IdB4PUdEj6ZAszuM32gC81m
         KaLtp41GFoUOt5EHO+HnDf2ZqVARl8DOiAI5ysUDT7qHXZ0x2tb7sc0vu6X23Xf6XyND
         MpCv6Mq0qBfbMEYVw5XBBZ65vw4nurp0FVie7ZKUd8kFrnD//AHh28YxHrZJOKYuNGvJ
         Q2e9SG162h1TrprK2qsqpYNeJMNRTCNCOHxo1ftlqJYTwFGxPt1F6BUPT6ImldvO09NT
         511C0kB0kofMyFGfI61uQX2IQpVYQSfnRocr8/KPA5IBLLdiea6/qB1lLZjW8RYEiS3E
         zO8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=mSbtw5uzlAG/2TI3Y32QpvnB9Gwp7DRumY30zyIIdw4=;
        b=WWKwQb/OBs2eH6r3m54cdyYHKVMbypmNyAzhM/LSiiJBxqZd3+zxy4zPFlZ3kAdFDD
         hsKV9avNJvk0IJvYDSchXqHCQ0d5jMMEzK33T186xwUUSg+hVfXHFMmvQ3mruxE/DTQm
         9maqA8FwqxaUWKnTghJ7sJcNnT5UsQolVLPL+WNjwUUvX4Mw4cvgA7n5YCJn3C5a8v1l
         PqIq+yFW2Mt+yUvf0JVnmIyuOu7jJOhzRxVsGzUHAu0o9EGAK+6EyeFII2NBEP6jd96/
         YWh13uT1xFhMISduveSuI//GtxFeBfycndkvtBRrOgG3TAlfuLgLj3nTPYJvrA+3CGAn
         cC0g==
X-Gm-Message-State: AOAM530qgIUOlYgPeKGOkmxQJtA7bAT0RGQ+r2ISxvYnz/oDGlIblNXf
        E1Mzx4ujzshzwF4qfiMwK/eKdoxihUGY0Q==
X-Google-Smtp-Source: ABdhPJw1Ygn8wQahQs1ZzQ4AXjgxaDzRKT1y2NwQnmTT676WAlJivT0y2uyMwgu5CxC7cX01vrRqHw==
X-Received: by 2002:a17:90a:f2c7:: with SMTP id gt7mr4178974pjb.157.1618411458254;
        Wed, 14 Apr 2021 07:44:18 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id e12sm11583386pfm.29.2021.04.14.07.44.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Apr 2021 07:44:18 -0700 (PDT)
Message-ID: <6076ffc2.1c69fb81.9425a.cad2@mx.google.com>
Date:   Wed, 14 Apr 2021 07:44:18 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.4.112
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Tree: stable
Subject: stable/linux-5.4.y baseline: 136 runs, 4 regressions (v5.4.112)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.4.y baseline: 136 runs, 4 regressions (v5.4.112)

Regressions Summary
-------------------

platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
hifive-unleashed-a00 | riscv | lab-baylibre  | gcc-8    | defconfig        =
   | 1          =

qemu_arm-versatilepb | arm   | lab-baylibre  | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-cip       | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-collabora | gcc-8    | versatile_defconf=
ig | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.4.y/kernel/=
v5.4.112/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.4.y
  Describe: v5.4.112
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      8f55ad4daf001b6ee8ddf672e14475a35403b258 =



Test Regressions
---------------- =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
hifive-unleashed-a00 | riscv | lab-baylibre  | gcc-8    | defconfig        =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/6076c94a9808b9c965dac6c0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (riscv64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.112/ri=
scv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleashed-a00.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.112/ri=
scv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleashed-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/riscv/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6076c94a9808b9c965dac=
6c1
        failing since 146 days (last pass: v5.4.77, first fail: v5.4.78) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-baylibre  | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/6076c7c7c5feda4727dac6c2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.112/ar=
m/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.112/ar=
m/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6076c7c7c5feda4727dac=
6c3
        failing since 146 days (last pass: v5.4.77, first fail: v5.4.78) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-cip       | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/6076c7bc3f7baf2fd9dac6b3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.112/ar=
m/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.112/ar=
m/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6076c7bc3f7baf2fd9dac=
6b4
        failing since 146 days (last pass: v5.4.77, first fail: v5.4.78) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-collabora | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/6076c78753d951d5ffdac6c4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.112/ar=
m/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.112/ar=
m/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6076c78753d951d5ffdac=
6c5
        failing since 146 days (last pass: v5.4.77, first fail: v5.4.78) =

 =20
