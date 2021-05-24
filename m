Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3C5B38F4DE
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 23:29:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233858AbhEXVae (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 17:30:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233833AbhEXVad (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 May 2021 17:30:33 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36851C061574
        for <stable@vger.kernel.org>; Mon, 24 May 2021 14:29:04 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id q25so3862144pfn.1
        for <stable@vger.kernel.org>; Mon, 24 May 2021 14:29:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=JOowVNoremKorvgAAmALUdBPGpgrulnylb+7EKaSqpI=;
        b=dGqa3J2pTVWFH5wb9fmwDcR4Vt6qkneutk939OFxvl5Nc8MP1p9k3FvVfCvPZ/eTIW
         4q5126Ji4vc5UE9XBbYLbRZAV9SYGxlSWa6RbzIHHVhjGnxw0J2BoVF07evQy3eOu9U1
         xerZUk0qv8HzYxktNPNcTtwnSR3HBIH+bwOChKmKl5SHxz1bxAZQ4Q7d2eTtnAyULblX
         lGv6X/Y968LSiTDHPwYpCZIFPcAs+yQMM7/58AgQX/LS/xPtxSv+4po6mwN/ny+9knM0
         erGnMr3EC1+R8/8aHoGTMxe//J9Q6otvgQfrZfPU4DBNuKftKRmdGVhNtLNWl8uOqrFH
         lbnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=JOowVNoremKorvgAAmALUdBPGpgrulnylb+7EKaSqpI=;
        b=XJ7eiydodC5gtAuPaalsBwPypHsVqxkdpcnTKl+9nzPAolnRScR7edtcFFxPClank7
         rXFoB144POeoFVCXwlFp2F7X27vcGtTACUgvUJB/wp5wPhqKKCAtIvu0sm3In4jXOFab
         lialypiNHYjvKjpUrc2q1himwYliKC0ZWHzVBgV9GK3ZD491t6Q0tUJFp6T+phf6bjwJ
         Of7jehtHoSUshAipqWJW9dQ92KGkaN/RTz1/8jIUstfyDcK6djRJsEL+sGCOEddZybYN
         b9PXpTHcYoaNxuLvuH/lgY/JhJIdVGBAZPDA3HKCREkFp1U1kxA5XXGSyg26gJc8dskh
         Zxag==
X-Gm-Message-State: AOAM530PXHLLxEOBraC9gJxowsa/D3DrwBH41WSDZdjWS5Pm1IGxS2K9
        wRzaFMdqGnYEXt0qf1r8QfezJ1odEc17nQqG
X-Google-Smtp-Source: ABdhPJyKgW5fG2NTY97fsVRXu/LVaDYmfbLiZZHPgijsLMylGGbsnRxuSgw7h95YzwKsmSpZDvKQEQ==
X-Received: by 2002:a63:6cc:: with SMTP id 195mr15517676pgg.401.1621891743557;
        Mon, 24 May 2021 14:29:03 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id f3sm590338pjo.3.2021.05.24.14.29.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 May 2021 14:29:03 -0700 (PDT)
Message-ID: <60ac1a9f.1c69fb81.15b5a.2a95@mx.google.com>
Date:   Mon, 24 May 2021 14:29:03 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.4.121-72-gee309f4d1199
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-5.4.y baseline: 109 runs,
 4 regressions (v5.4.121-72-gee309f4d1199)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.4.y baseline: 109 runs, 4 regressions (v5.4.121-72-gee309=
f4d1199)

Regressions Summary
-------------------

platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
hifive-unleashed-a00 | riscv | lab-baylibre  | gcc-8    | defconfig        =
   | 1          =

qemu_arm-versatilepb | arm   | lab-broonie   | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-cip       | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-collabora | gcc-8    | versatile_defconf=
ig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.4.y/kern=
el/v5.4.121-72-gee309f4d1199/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.4.y
  Describe: v5.4.121-72-gee309f4d1199
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      ee309f4d11991b6f668fee11d74ed92c3a988f6e =



Test Regressions
---------------- =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
hifive-unleashed-a00 | riscv | lab-baylibre  | gcc-8    | defconfig        =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/60abe83971720527e9b3afc6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (riscv64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.121=
-72-gee309f4d1199/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleas=
hed-a00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.121=
-72-gee309f4d1199/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleas=
hed-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/riscv/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60abe83971720527e9b3a=
fc7
        failing since 185 days (last pass: v5.4.77-152-ga3746663c3479, firs=
t fail: v5.4.78) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-broonie   | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/60abe96c66f19bc46db3af9d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.121=
-72-gee309f4d1199/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.121=
-72-gee309f4d1199/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60abe96c66f19bc46db3a=
f9e
        failing since 191 days (last pass: v5.4.77-44-g28fe0e171c204, first=
 fail: v5.4.77-46-ga3e34830d912) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-cip       | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/60abe7b363631096a2b3afaa

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.121=
-72-gee309f4d1199/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.121=
-72-gee309f4d1199/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60abe7b363631096a2b3a=
fab
        failing since 191 days (last pass: v5.4.77-44-g28fe0e171c204, first=
 fail: v5.4.77-46-ga3e34830d912) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-collabora | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/60abea36c39f8c2898b3afa2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.121=
-72-gee309f4d1199/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.121=
-72-gee309f4d1199/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60abea36c39f8c2898b3a=
fa3
        failing since 191 days (last pass: v5.4.77-44-g28fe0e171c204, first=
 fail: v5.4.77-46-ga3e34830d912) =

 =20
