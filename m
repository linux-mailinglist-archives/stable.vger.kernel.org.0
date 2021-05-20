Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C47B338B855
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 22:23:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236752AbhETUZU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 16:25:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235410AbhETUZT (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 May 2021 16:25:19 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B23AC061574
        for <stable@vger.kernel.org>; Thu, 20 May 2021 13:23:58 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id x18so8934354pfi.9
        for <stable@vger.kernel.org>; Thu, 20 May 2021 13:23:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=lPP4w7sZtfMxrpC96qQodz5VgVFSoCl7X329p4IvIaM=;
        b=e5x9IMIoK3cTRf4nY3s0yrSHPWD0n/TjhQe4yOTE5GsrDgkuQdQhT+33JFYOLEk7JM
         vAD6lVz78l1IR6bpH7t/PAPNwHmUSWOSwjYOAI8dbt0gZuzzSkEiPBz6W0JYh8nm16ir
         vagWElyeN7smj1uDaKMDMfZjbnnNRWbNE1T5io4wNnukLz5MkvuRLcT3yPlBdiMMSNdT
         l7ozQt2R+UTBgDm+YDb8yLuU+0/0xPj/bs5dAXcs06fe6+o20cgtHcBtrGHNlrDglpBo
         qc/eTHq4Sit9DYtpCvLyMap6Ol+FFDLzxi2G3GxISW2+LOrmRoYFPjlteIi4Aj6A7q5P
         nr+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=lPP4w7sZtfMxrpC96qQodz5VgVFSoCl7X329p4IvIaM=;
        b=nbkvK+IvKEqHktlg5biPeOnGPp84SZpXgEX12n1aGZ4PrMtB9wg3zWlz4iA1k9FrxN
         ui68j47mfRgA1/c4x0rgSk2Y+D9Ed/Hw5dZ2/1wV7DotqxQ5Y9d4p69irF9eizKDN9Uw
         NMFURHIW/0dqF8heY8xtNbyUQOx0IeGn8/aFLk9DdlALNADv6kokYmghB/BZQCrg+WGz
         wzdoTGRz1DZ9W6VyExrbSUSVaNN+G8u1ZmYiaFwS7szv95W/X4oxMYciHV0B6XQt3BQn
         e39liaQINMFcBAEdF5P4Qtu1sARzCfc5KLNEkrP2D3c6tg0NepT+7CxzN/ua7aE3edoO
         yFhg==
X-Gm-Message-State: AOAM530DBnbxKCgtixjOeeg1VtKL3WMjGG/sfLUIhVwk91yuM9YGb5Vh
        Hrj9EA/cBG558FvjXu3gZcvwvkB0eCuJDjOC
X-Google-Smtp-Source: ABdhPJzULk9uXIdKBCXuehYGG5yPmQ1gtlPegrEkLbka0mCuQsYnhwiGOcknr4PerhP9GN0U4YaGmA==
X-Received: by 2002:a63:8c16:: with SMTP id m22mr6278838pgd.165.1621542237534;
        Thu, 20 May 2021 13:23:57 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 80sm2775842pgc.23.2021.05.20.13.23.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 May 2021 13:23:57 -0700 (PDT)
Message-ID: <60a6c55d.1c69fb81.fe30f.9e57@mx.google.com>
Date:   Thu, 20 May 2021 13:23:57 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.12.5-43-g6d16d79b1eab
X-Kernelci-Branch: queue/5.12
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.12 baseline: 151 runs,
 2 regressions (v5.12.5-43-g6d16d79b1eab)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.12 baseline: 151 runs, 2 regressions (v5.12.5-43-g6d16d79=
b1eab)

Regressions Summary
-------------------

platform           | arch  | lab          | compiler | defconfig         | =
regressions
-------------------+-------+--------------+----------+-------------------+-=
-----------
bcm2837-rpi-3-b-32 | arm   | lab-baylibre | gcc-8    | bcm2835_defconfig | =
1          =

imx8mp-evk         | arm64 | lab-nxp      | gcc-8    | defconfig         | =
1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.12/ker=
nel/v5.12.5-43-g6d16d79b1eab/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.12
  Describe: v5.12.5-43-g6d16d79b1eab
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      6d16d79b1eab8a9fe9d3421df755c4bc3b7c3f8d =



Test Regressions
---------------- =



platform           | arch  | lab          | compiler | defconfig         | =
regressions
-------------------+-------+--------------+----------+-------------------+-=
-----------
bcm2837-rpi-3-b-32 | arm   | lab-baylibre | gcc-8    | bcm2835_defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/60a68dd3c813b9a175b3afb5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.5-4=
3-g6d16d79b1eab/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837-r=
pi-3-b-32.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.5-4=
3-g6d16d79b1eab/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837-r=
pi-3-b-32.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60a68dd3c813b9a175b3a=
fb6
        new failure (last pass: v5.12.5-45-gd771f12f8049) =

 =



platform           | arch  | lab          | compiler | defconfig         | =
regressions
-------------------+-------+--------------+----------+-------------------+-=
-----------
imx8mp-evk         | arm64 | lab-nxp      | gcc-8    | defconfig         | =
1          =


  Details:     https://kernelci.org/test/plan/id/60a69201e7655c93fab3afd8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.5-4=
3-g6d16d79b1eab/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.5-4=
3-g6d16d79b1eab/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60a69201e7655c93fab3a=
fd9
        new failure (last pass: v5.12.5-45-gd771f12f8049) =

 =20
