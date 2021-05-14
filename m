Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88B51380FFB
	for <lists+stable@lfdr.de>; Fri, 14 May 2021 20:46:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229927AbhENSrj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 May 2021 14:47:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229819AbhENSrj (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 May 2021 14:47:39 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97E8EC061574
        for <stable@vger.kernel.org>; Fri, 14 May 2021 11:46:27 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id k15so11937438pgb.10
        for <stable@vger.kernel.org>; Fri, 14 May 2021 11:46:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=xSK14OLx8JFKmPJwmMqmVtzz4BrrHE4Cr+jWwUsmwU4=;
        b=YbESyNnprnvQZc0knszVrMcfetkBlCh2Qokp2tfQFH8ahlBxaaO7RSr4QkpZCYw0/O
         T6HFVaPiyEf3J7D9XN05LYUoXagKPfG4wjDlyrMsD9Q1bu0zMM7Rex/T1Xh2KA7GI+30
         7pSm97m9Dke0CVm3GH4B5MAkZPKRh4wPlwYvRI1UyGINTUhgZADgkr8a4+3zyU3Aw3YZ
         0EpGCbJfQYd1+3yfV3mSewyl7xkawidWaHY+A/aDvaqnLg1/VF8nU7bAEukKNJcePPkV
         2kUOyYsMzRWhI1xZiGW4DYlVPqAyEo5BG7OIeggG2+yk3J3yvJWOka9g3AHHIdhhRb/j
         qcxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=xSK14OLx8JFKmPJwmMqmVtzz4BrrHE4Cr+jWwUsmwU4=;
        b=YW95LES+VhpDniqgHvwvt8SCM/uH4suo9+w4TOLA6+S+7G4M3U2lxPISYf7Bo4CUyH
         gFN9qUjv5u/+vNyVwHPjnC36s2VCsmdsYdF/pDt3OJOANUAl4dOsPvAlpeSw7GzNaD9P
         F2qVgGaispaIBOv/B2UKXJ3ILHMRI/ZIwPvEvhvwdAd6wZ16hTW9rT8/3+JJilMPDdog
         B337rPRZOG9xrmEaHNIXSBiXAygSHezZiPbDUg10fcxT3dGVoU9M5EPGdBcqv3nCsewD
         taq5L4vaciKtcRT7VTmfZnqo6U9aW5fJ53+3QlwsSr3UQW2XNffEnI0KpDVImHUczZF5
         W07A==
X-Gm-Message-State: AOAM530ayRVx8HsTbFvMmRAu/cfWwRAaZFcPhnxNZCfCetJrqupmqDoQ
        KmU2krs3LmYhuuPSzqBunsHi1GjMAMcXOkqx
X-Google-Smtp-Source: ABdhPJxkFaoAKdpOgtO73rDb/GyIV1c7JccoSaFbOxML679+qB/Haul4IJQvxMGUobj67UjTYYTtrw==
X-Received: by 2002:a63:164f:: with SMTP id 15mr2068088pgw.175.1621017986936;
        Fri, 14 May 2021 11:46:26 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id k21sm4747575pgb.56.2021.05.14.11.46.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 May 2021 11:46:26 -0700 (PDT)
Message-ID: <609ec582.1c69fb81.3fe84.038a@mx.google.com>
Date:   Fri, 14 May 2021 11:46:26 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable
X-Kernelci-Kernel: v5.4.119
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Report-Type: test
Subject: stable/linux-5.4.y baseline: 110 runs, 4 regressions (v5.4.119)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.4.y baseline: 110 runs, 4 regressions (v5.4.119)

Regressions Summary
-------------------

platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
hifive-unleashed-a00 | riscv | lab-baylibre | gcc-8    | defconfig         =
  | 1          =

qemu_arm-versatilepb | arm   | lab-baylibre | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm   | lab-broonie  | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm   | lab-cip      | gcc-8    | versatile_defconfi=
g | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.4.y/kernel/=
v5.4.119/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.4.y
  Describe: v5.4.119
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      b82e5721a17325739adef83a029340a63b53d4ad =



Test Regressions
---------------- =



platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
hifive-unleashed-a00 | riscv | lab-baylibre | gcc-8    | defconfig         =
  | 1          =


  Details:     https://kernelci.org/test/plan/id/609e906bb461659573b3afa2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (riscv64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.119/ri=
scv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleashed-a00.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.119/ri=
scv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleashed-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/riscv/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/609e906bb461659573b3a=
fa3
        failing since 176 days (last pass: v5.4.77, first fail: v5.4.78) =

 =



platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm   | lab-baylibre | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/609e90dfa7ffa672c1b3afa7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.119/ar=
m/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.119/ar=
m/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/609e90dfa7ffa672c1b3a=
fa8
        failing since 176 days (last pass: v5.4.77, first fail: v5.4.78) =

 =



platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm   | lab-broonie  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/609e90fb049a2ca1c8b3afaa

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.119/ar=
m/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.119/ar=
m/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/609e90fb049a2ca1c8b3a=
fab
        failing since 176 days (last pass: v5.4.77, first fail: v5.4.78) =

 =



platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm   | lab-cip      | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/609e909a957fd07e9fb3afa6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.119/ar=
m/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.119/ar=
m/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/609e909a957fd07e9fb3a=
fa7
        failing since 176 days (last pass: v5.4.77, first fail: v5.4.78) =

 =20
