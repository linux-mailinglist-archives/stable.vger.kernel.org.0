Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 017BB34D09E
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 14:57:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230244AbhC2M5Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 08:57:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230370AbhC2M5L (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Mar 2021 08:57:11 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81D67C061574
        for <stable@vger.kernel.org>; Mon, 29 Mar 2021 05:57:11 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id v3so9375670pgq.2
        for <stable@vger.kernel.org>; Mon, 29 Mar 2021 05:57:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=1z7PYI9OEoRC/3yL6uPwCxcmfI5kGlX1TG4Jzj5GXPk=;
        b=MFM2Kek2kqiaEKCMpnltqavjpFradOWwoStfGUvjFSZ/iYUneZSbGALwQnq9Er2E8d
         j2a9YCF7qc819jLr1xvBAdt2RfjMMOIL9EBlJBem4tZP3iT6jht8g/RzIyKN8LqbvR7k
         cJxdhdKSLpZAmv8PqKh9X7U9BHYW9PQNV+hl2QhvozMIabooy1LL34UZFm/Kokav9v4Y
         oiWg3fb+esFqzEadFyH5s2tSD0G/U52H4Hf3HdMUuXm0OsOHMo33FHo7+wIvfHpsYbrq
         cOfqVs2BwIuQjHF+hOQ3zyydMYGQ+Jmno0mkhdE7yC6Y8y/6AttWms9dywj4tiMWvHnV
         jFyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=1z7PYI9OEoRC/3yL6uPwCxcmfI5kGlX1TG4Jzj5GXPk=;
        b=pHH1VPXvbdC1zvzRIUt9/+GIoY1Mz8jshPm4We26AphEevJuYz5NVHx0xqKnK2NkMP
         C2V8oazY77qEHYsi81QdX3wTag9HdmwWHZIfk87iPImn1YVmlVCIpf56dh0ZgvNz1r+F
         T6NiNAhyxR3Yx3Ox3mU/YYOVmH6cS4D3U+nhheVxfs9D6BVjzX3lrUDv3DoTrX8zY6a/
         l5V1Th8M8YbbtU8wj3lpjvzYNVKXHvoWj/nrYPaeonOJ5BegYx53/ECPbT8PU0SGrKOv
         uhpoSxsMXfE4CdOYYR5K358TPMNbrO+VC8mmLoMct82HWTB7UdtCUTghExcAnqpOcLNK
         8xYw==
X-Gm-Message-State: AOAM531csYoJEqkCYzmEV+goOIG81a7YYimsZnQ5AKDD8u50sosEhzhA
        bnwmzpby5FLba5io825lHM05Dl8gwFoFWw==
X-Google-Smtp-Source: ABdhPJzs4KtxTHpwmV6UHrMqQAZyFNdM9k4qF1mlTdEOW0ZqDJp+WyDl8ShuaR0Dr2G5bEPqtjq9AQ==
X-Received: by 2002:aa7:85c1:0:b029:1f4:4fcc:384d with SMTP id z1-20020aa785c10000b02901f44fcc384dmr25575647pfn.10.1617022630708;
        Mon, 29 Mar 2021 05:57:10 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 27sm17360398pgq.51.2021.03.29.05.57.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Mar 2021 05:57:10 -0700 (PDT)
Message-ID: <6061cea6.1c69fb81.d7a9.adf6@mx.google.com>
Date:   Mon, 29 Mar 2021 05:57:10 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.9.263-53-g852454a98243
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.9
Subject: stable-rc/queue/4.9 baseline: 103 runs,
 4 regressions (v4.9.263-53-g852454a98243)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 103 runs, 4 regressions (v4.9.263-53-g852454a=
98243)

Regressions Summary
-------------------

platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.263-53-g852454a98243/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.263-53-g852454a98243
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      852454a98243c2503d5e24cfb137aa81ba76db6c =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6061937d0e0a4767a0af02b2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.263-5=
3-g852454a98243/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.263-5=
3-g852454a98243/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6061937d0e0a4767a0af0=
2b3
        failing since 135 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6061937919fd9bfcaaaf02cc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.263-5=
3-g852454a98243/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.263-5=
3-g852454a98243/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6061937919fd9bfcaaaf0=
2cd
        failing since 135 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/606193870e0a4767a0af02d8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.263-5=
3-g852454a98243/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.263-5=
3-g852454a98243/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/606193870e0a4767a0af0=
2d9
        failing since 135 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6061c07b2d1c1034e9af02b9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.263-5=
3-g852454a98243/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.263-5=
3-g852454a98243/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6061c07b2d1c1034e9af0=
2ba
        failing since 135 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =20
