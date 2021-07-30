Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCD6F3DB0A9
	for <lists+stable@lfdr.de>; Fri, 30 Jul 2021 03:37:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234357AbhG3Bh2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Jul 2021 21:37:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234325AbhG3Bh1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Jul 2021 21:37:27 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34CD8C061765
        for <stable@vger.kernel.org>; Thu, 29 Jul 2021 18:37:23 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id nh14so1103344pjb.2
        for <stable@vger.kernel.org>; Thu, 29 Jul 2021 18:37:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=gefrgZXKXUU0ZsEUnR1RwfcTU4Sv7ZJuTF+VgiEjM30=;
        b=zmuKam5m7Sk9xDxOvBO4DsBLGyt0U6l49O7xcyzFg0k05Dc/ZIRwzMrBm0pm72MmQ1
         Ox2qZ6HllGp+CnkhKBeVdlevUC3Rk8SDNQClzL/gt47NBIFupuDozGqpBMKULGxP5RNm
         UwNxOFA/teIA7PwwtFnqMqqp6K///CezH3E8NSRWPSSBXO/w1RRl+MM7duzg2swYmviD
         jVJmYBc5nD9ivOelqK6ot1hWkkmVIG3iTGVla6LmRLzyVFek/D+sqdF9lQ58xKDjyeOc
         44IgeXV2OZvRgtKr+9coOE1M5NnjvrGw+SSE+FSxzqV2oJS6TA603ON4uogy+IoGID6k
         XYRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=gefrgZXKXUU0ZsEUnR1RwfcTU4Sv7ZJuTF+VgiEjM30=;
        b=pIX+ojEA6qAoZkopTslVJmviYCi39x++1WwOwrbc2tFr8YrLgVyycdz8tDI1dQHXZd
         NjA4vrDRQ46A9XAehraJ/9nEvxTAiJ3s004DtsknEa5gFg+BkWNaZXA+kcZC/sKv+o2u
         3mXFs80r6sTG+eLSnzZO1G8xSesV6qP65EPPjWUrG+cmxySsSAqwPfpzrChDMT50btIW
         WbEpmq+2qQ9vf1YwfQBhuDNORMZTNpmWLUNBYT74dQ2lyQwOwuaQme8/i9gPk1SwrVnP
         LTux91gBYS/zDZB/8fCDsM37y4tg9E1KQZSsrHD3oEpsGW8huCiU+DPpc/W+hlsVC9OP
         sp7Q==
X-Gm-Message-State: AOAM532Yqk4mkUnUWLRH0IhfPUguYwA4FO2ZsbAcYNHUL8ceTlaQs2yC
        vxaJDoVc7AyuZ4o4d1KIr8oMCPV4lADtYyVM
X-Google-Smtp-Source: ABdhPJzjmKZpA+7oOKgbc+QfCOSqjLnY64zAUfjP7Z4B+hsUb0Xd8tUCkiHezi5qlmFnEa44fAFiXA==
X-Received: by 2002:a17:90a:a105:: with SMTP id s5mr311328pjp.9.1627609042535;
        Thu, 29 Jul 2021 18:37:22 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id k8sm89892pfu.116.2021.07.29.18.37.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Jul 2021 18:37:22 -0700 (PDT)
Message-ID: <610357d2.1c69fb81.e475a.0661@mx.google.com>
Date:   Thu, 29 Jul 2021 18:37:22 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.4.136-22-gf73de39e1fb7
Subject: stable-rc/linux-5.4.y baseline: 90 runs,
 5 regressions (v5.4.136-22-gf73de39e1fb7)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.4.y baseline: 90 runs, 5 regressions (v5.4.136-22-gf73de3=
9e1fb7)

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

qemu_arm-versatilepb | arm   | lab-cip       | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-collabora | gcc-8    | versatile_defconf=
ig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.4.y/kern=
el/v5.4.136-22-gf73de39e1fb7/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.4.y
  Describe: v5.4.136-22-gf73de39e1fb7
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      f73de39e1fb7b0cbd29bf959b3a305eca0e182e7 =



Test Regressions
---------------- =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
bcm2837-rpi-3-b-32   | arm   | lab-baylibre  | gcc-8    | bcm2835_defconfig=
   | 1          =


  Details:     https://kernelci.org/test/plan/id/61031f88b2160e8be95018cb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.136=
-22-gf73de39e1fb7/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837=
-rpi-3-b-32.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.136=
-22-gf73de39e1fb7/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837=
-rpi-3-b-32.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61031f88b2160e8be9501=
8cc
        new failure (last pass: v5.4.136) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
hifive-unleashed-a00 | riscv | lab-baylibre  | gcc-8    | defconfig        =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/61031dcd52c00e97235018fb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (riscv64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.136=
-22-gf73de39e1fb7/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleas=
hed-a00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.136=
-22-gf73de39e1fb7/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleas=
hed-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/riscv/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61031dcd52c00e9723501=
8fc
        failing since 251 days (last pass: v5.4.77-152-ga3746663c3479, firs=
t fail: v5.4.78) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-baylibre  | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/61031d5ca5cd0f15e25018d5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.136=
-22-gf73de39e1fb7/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.136=
-22-gf73de39e1fb7/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61031d5ca5cd0f15e2501=
8d6
        failing since 257 days (last pass: v5.4.77-44-g28fe0e171c204, first=
 fail: v5.4.77-46-ga3e34830d912) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-cip       | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/61031d5dbe19f241cf5018cf

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.136=
-22-gf73de39e1fb7/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.136=
-22-gf73de39e1fb7/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61031d5dbe19f241cf501=
8d0
        failing since 257 days (last pass: v5.4.77-44-g28fe0e171c204, first=
 fail: v5.4.77-46-ga3e34830d912) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-collabora | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/61031d01123f3a3d495018ed

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.136=
-22-gf73de39e1fb7/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.136=
-22-gf73de39e1fb7/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61031d01123f3a3d49501=
8ee
        failing since 257 days (last pass: v5.4.77-44-g28fe0e171c204, first=
 fail: v5.4.77-46-ga3e34830d912) =

 =20
