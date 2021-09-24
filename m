Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B2BE417853
	for <lists+stable@lfdr.de>; Fri, 24 Sep 2021 18:16:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347374AbhIXQRu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Sep 2021 12:17:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347373AbhIXQRu (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Sep 2021 12:17:50 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 741B0C061571
        for <stable@vger.kernel.org>; Fri, 24 Sep 2021 09:16:17 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id g2so5205494pfc.6
        for <stable@vger.kernel.org>; Fri, 24 Sep 2021 09:16:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=rH2Z5yGN8PwhpcSWg4m6xZkzKbvzUute1KiqGgR4pN4=;
        b=Kaiwsd+nOI4Iu32rLRirDZVRnGcWVEDTviUWCfANyJAeMzDVZgz5AW+OK5/av0DgA4
         gFPqKNt1ma8xcK62CL4m+TIN/XHJqTcqEZXFS8qDRyDAmhh/dK+V1qJP8iRUpNZCD8qF
         O5cd215ChEy5o6XlT4Q4TpmoN23TqEz1aEFk2USxqkjIdrGQNanUhbuk6oguZtobE0YK
         /zRvmxygahj32XnRIzWPkbokQOXMurcKbOehMgINGS3WfqaQrpxGyys8KWNJs00p9YSI
         lyFku8FfW83KID1JeuK/MaP625Ha5r5m7V1RSJRpQ82flX++5+eYsDHPQUjAXLo6xGqI
         eA/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=rH2Z5yGN8PwhpcSWg4m6xZkzKbvzUute1KiqGgR4pN4=;
        b=5bgqeRbBnvJwsB0zBAhAqXXGwDBpHXi6nO8CZaCpkGh7lzwhcGV8AQxA5442l4DE/e
         o9Mo/6d6paeqnYgBfOUkxQnNNo/W7BhZdN99z6RSnnY2l+oo7DNYc5gAof3uH/ikSNYO
         KEHZwJV9CeGlrNi/RwNWq2HGtxVXS3gjQooPC7X5QugXYDqhWIahPcrgxDK03S8bVfdl
         sguwPNS5kMRhjsuMjPvp+tdu7C6uNoIuA+ZkS3FtSUUv64a7ZGfdkP1cEf8rav33ever
         tFr9vpJt181Uo+zfjcPYSx82LH2Q+MjEDw72FHJxiiJsdsoK0ocaz1vRBm3KoULSYCLN
         B57Q==
X-Gm-Message-State: AOAM530ddOmaqGEqMoywcL8uwaA7tsh3xpUNXXS6UMCz09x6CPMiO5px
        csbT2+4613bhStDcgOc6h1NG1XNFIqSVXwVU
X-Google-Smtp-Source: ABdhPJy7MJInmLAcTsnHvW2XXNOrx8BZZGcsaYoCL/mHqaB04l+4hhxdX0mTXL3sy5s8OtsiZ6pBoQ==
X-Received: by 2002:a62:7806:0:b0:440:448c:f662 with SMTP id t6-20020a627806000000b00440448cf662mr10853070pfc.57.1632500176773;
        Fri, 24 Sep 2021 09:16:16 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id u10sm8824245pjf.46.2021.09.24.09.16.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Sep 2021 09:16:16 -0700 (PDT)
Message-ID: <614df9d0.1c69fb81.7759f.abe8@mx.google.com>
Date:   Fri, 24 Sep 2021 09:16:16 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.283-17-g8597a4a2fe64
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.9
Subject: stable-rc/queue/4.9 baseline: 79 runs,
 4 regressions (v4.9.283-17-g8597a4a2fe64)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 79 runs, 4 regressions (v4.9.283-17-g8597a4a2=
fe64)

Regressions Summary
-------------------

platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.283-17-g8597a4a2fe64/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.283-17-g8597a4a2fe64
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      8597a4a2fe642ba08b26dcd7ae8e8c54d2886214 =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/614dc08933e9d2973699a2f6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.283-1=
7-g8597a4a2fe64/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.283-1=
7-g8597a4a2fe64/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/614dc08933e9d2973699a=
2f7
        failing since 314 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/614dc08b33e9d2973699a2f9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.283-1=
7-g8597a4a2fe64/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.283-1=
7-g8597a4a2fe64/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/614dc08b33e9d2973699a=
2fa
        failing since 314 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/614dc087877ba4f52599a2fa

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.283-1=
7-g8597a4a2fe64/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.283-1=
7-g8597a4a2fe64/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/614dc087877ba4f52599a=
2fb
        failing since 314 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/614dc04757af822db199a301

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.283-1=
7-g8597a4a2fe64/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.283-1=
7-g8597a4a2fe64/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/614dc04757af822db199a=
302
        failing since 314 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =20
