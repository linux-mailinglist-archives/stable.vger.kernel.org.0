Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A34AA34BA01
	for <lists+stable@lfdr.de>; Sat, 27 Mar 2021 23:52:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230490AbhC0Wvj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 27 Mar 2021 18:51:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230176AbhC0WvD (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 27 Mar 2021 18:51:03 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B16B2C0613B1
        for <stable@vger.kernel.org>; Sat, 27 Mar 2021 15:51:03 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id s11so1277806pfm.1
        for <stable@vger.kernel.org>; Sat, 27 Mar 2021 15:51:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=9kJb/0CcFsZdCTMrXsqi0DPG7D3opca6qWT3gcdaGko=;
        b=E3/jLyfjqGjfTZRSCqvVWg+DrSyego5REusYWY2NeesiYYcbPZ8GnyZppL+cXEJaxj
         HrmsSmhtNg2rtXoB7zeMomtGwtCvbGrqFwhOj2BwW0IHl6V5GofprmTzabv5FKV/hB9m
         pp+uTJWTrsnBQrmn//pmVUgcJ1R7G7LqUybqIZH80L6+A6D41dZytjqnUQjfQnlfRUBq
         xdTtGvRI0zT0VUOxFiMdg9YlFf/7UNVCVZ/EyWcE3m3GlrwzlnSc0hMWI/6VdLEuuMby
         lvnA/3a/JPM4CyC1MwWBAejqBTnjecwpP404RGjREtXKD8ZFlG6WItoQ40L+3kirzfIM
         7nOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=9kJb/0CcFsZdCTMrXsqi0DPG7D3opca6qWT3gcdaGko=;
        b=P7uGogi4pr7MQsnx5AmlRZ0Eu1DlX9ekJRciB0P/lve5a7d1pnOIEvDfOk0ASHlR5f
         LbHKg71xgRQo/FVnC6GEOw9PlT7ANeYNhYNrwj5dOYHTmxr7GNnCH0EuQ8dflH0CpQwW
         I+TlLYdQEUgmz7B5mDjfLQHdHAvN+qFaCLBbB4ZIWhOZJV8VCwPYhu+OtBDFTrMlrTNG
         Tt8qLzssSSyltbudrHFRK6b01bB+t0qw8HYEW1oTfNK1ybTTyrVWjvKmfabVKsMRK2Un
         FJFaoA7IbHyQp4k7dwofn86zHM8YqkkLClg3A3wb7pmtdt3DKwq7B4zI0hNvXPuo79Sc
         JAcQ==
X-Gm-Message-State: AOAM530oI10iwA24eARMSbLtucnDivOtpAHFufwTKgdRK69PwGE7CdOk
        23vc4nNoFPdxrF1E+7CLoVoSgNkPnzru6Q==
X-Google-Smtp-Source: ABdhPJxcCtAWJA3CcIYcpiHsdr3O3zcK5582MFP96F4BEC08MZhIpOxn5Oe51eQvlvPScnw64uvemQ==
X-Received: by 2002:a63:1a0d:: with SMTP id a13mr17703940pga.167.1616885462965;
        Sat, 27 Mar 2021 15:51:02 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id p5sm13120835pfq.56.2021.03.27.15.51.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 27 Mar 2021 15:51:02 -0700 (PDT)
Message-ID: <605fb6d6.1c69fb81.10d7.0943@mx.google.com>
Date:   Sat, 27 Mar 2021 15:51:02 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.4.108-53-gf6e98ecf3430
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.4.y
Subject: stable-rc/linux-5.4.y baseline: 105 runs,
 5 regressions (v5.4.108-53-gf6e98ecf3430)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.4.y baseline: 105 runs, 5 regressions (v5.4.108-53-gf6e98=
ecf3430)

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

qemu_arm-versatilepb | arm   | lab-broonie     | gcc-8    | versatile_defco=
nfig | 1          =

qemu_arm-versatilepb | arm   | lab-collabora   | gcc-8    | versatile_defco=
nfig | 1          =

qemu_arm-versatilepb | arm   | lab-linaro-lkft | gcc-8    | versatile_defco=
nfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.4.y/kern=
el/v5.4.108-53-gf6e98ecf3430/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.4.y
  Describe: v5.4.108-53-gf6e98ecf3430
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      f6e98ecf34303bfe946414761781ffcaf5b0f630 =



Test Regressions
---------------- =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
hifive-unleashed-a00 | riscv | lab-baylibre    | gcc-8    | defconfig      =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/605f7c79f1cc8f5fb0af02b9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (riscv64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.108=
-53-gf6e98ecf3430/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleas=
hed-a00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.108=
-53-gf6e98ecf3430/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleas=
hed-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/riscv/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/605f7c79f1cc8f5fb0af0=
2ba
        failing since 127 days (last pass: v5.4.77-152-ga3746663c3479, firs=
t fail: v5.4.78) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-baylibre    | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/605f79aff14c63ea10af031f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.108=
-53-gf6e98ecf3430/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.108=
-53-gf6e98ecf3430/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/605f79aff14c63ea10af0=
320
        failing since 133 days (last pass: v5.4.77-44-g28fe0e171c204, first=
 fail: v5.4.77-46-ga3e34830d912) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-broonie     | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/605f799af14c63ea10af02d7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.108=
-53-gf6e98ecf3430/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.108=
-53-gf6e98ecf3430/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/605f799af14c63ea10af0=
2d8
        failing since 133 days (last pass: v5.4.77-44-g28fe0e171c204, first=
 fail: v5.4.77-46-ga3e34830d912) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-collabora   | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/605f794c236dc1efe4af02b8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.108=
-53-gf6e98ecf3430/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.108=
-53-gf6e98ecf3430/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/605f794c236dc1efe4af0=
2b9
        failing since 133 days (last pass: v5.4.77-44-g28fe0e171c204, first=
 fail: v5.4.77-46-ga3e34830d912) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-linaro-lkft | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/605fb082ec3f02d443af02d0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.108=
-53-gf6e98ecf3430/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qe=
mu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.108=
-53-gf6e98ecf3430/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qe=
mu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/605fb082ec3f02d443af0=
2d1
        failing since 133 days (last pass: v5.4.77-44-g28fe0e171c204, first=
 fail: v5.4.77-46-ga3e34830d912) =

 =20
