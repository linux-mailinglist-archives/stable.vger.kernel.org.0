Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6158B382DC7
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 15:45:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237491AbhEQNrD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 09:47:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237482AbhEQNrC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 May 2021 09:47:02 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2557BC061573
        for <stable@vger.kernel.org>; Mon, 17 May 2021 06:45:46 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id d78so4109557pfd.10
        for <stable@vger.kernel.org>; Mon, 17 May 2021 06:45:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=iv+ZgX+Rzk+/Ut/k2goSo+3gmg6Jn1hVEe/sz/OczBo=;
        b=rdud9YPGtvkjRaEbYszCCnCVyNKIalukOx3X1RKuG1Jk1Aey24N/wUASYPnGYbWHmL
         hkFXtL6C/GX7om/DH+qCV7DSDdn9dOXs0gvJdl5oqCzG8247pa5CiEp3pzcA08o8NNZl
         yCSCnfxusVwfY6TPviXfo/+c3oL/jxQ0+yoJKJ9gKhuKtBGwEhQrqCbftGrvmoKglDRs
         AG0OMOrKzOBWxqh24SjBEKykIBVxNp18/0mxe7vDthNP3eRWT2SRJVB2l2/N63FHZo+Z
         Vg79mexkk/GB+T5W2QFyqs2xMtFTjB2/+x3sChTZKPdrm6z4fwBL205fU2QdHmvzezuC
         sEYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=iv+ZgX+Rzk+/Ut/k2goSo+3gmg6Jn1hVEe/sz/OczBo=;
        b=pFBjIl4e1RbqszDv3jZst5FkvVoMkG3UvvqwozYR675cQ4xLFjh5+JxaUpU0oDshgg
         +p0Lp4cKDh2GwYVaaEgD7uHWvdOtea3STVMU4OJoyna/2rx4sIloNXJ94pDg7dc/iMK/
         GpLSH0GFSAueZv0ceKiWOCb4lMFWyugTp2zSo8jmvPA9LO1zpUdkWintz/pvuXN0bGrL
         edYvAz+9zjVZCZMG9ztwTeHcebes9E7bPPkMM0xK8e70irGXtnUoeiqtUHukPp0pctfb
         ASzl1BpONJ/xuOYwk7zZ0KsuyWw8KMxkcPJXoDm0DT1IvJe3Mff9p3fPrgUNYJUj9tVL
         9ueA==
X-Gm-Message-State: AOAM5320suc9rZuXus0lJJzV8+Ggp28UY5zRfzIqUjUA+dB2I2Kr93Pt
        Dq/mnduY24johNwsCTuKH903QhWIy5xJRHFU
X-Google-Smtp-Source: ABdhPJyGEiqnExMvAMnAhYyU4R3KSsdUwnkmkdjnyRDcL1z6yS0p7jyje6cK7W1v4EBbyd8vZmyQTA==
X-Received: by 2002:a63:465b:: with SMTP id v27mr60932590pgk.445.1621259145560;
        Mon, 17 May 2021 06:45:45 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id t13sm15663961pjo.54.2021.05.17.06.45.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 May 2021 06:45:45 -0700 (PDT)
Message-ID: <60a27389.1c69fb81.44286.3dc6@mx.google.com>
Date:   Mon, 17 May 2021 06:45:45 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.190-374-g4c6f6d599d56
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-4.19.y baseline: 118 runs,
 3 regressions (v4.19.190-374-g4c6f6d599d56)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y baseline: 118 runs, 3 regressions (v4.19.190-374-g4c=
6f6d599d56)

Regressions Summary
-------------------

platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-baylibre | gcc-8    | versatile_defconfig=
 | 1          =

qemu_arm-versatilepb | arm  | lab-broonie  | gcc-8    | versatile_defconfig=
 | 1          =

qemu_arm-versatilepb | arm  | lab-cip      | gcc-8    | versatile_defconfig=
 | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.19.y/ker=
nel/v4.19.190-374-g4c6f6d599d56/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.19.y
  Describe: v4.19.190-374-g4c6f6d599d56
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      4c6f6d599d5647ee6ab6b965b83334a076298a8b =



Test Regressions
---------------- =



platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-baylibre | gcc-8    | versatile_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/60a23e35de5523b2a7b3afb8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
90-374-g4c6f6d599d56/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qe=
mu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
90-374-g4c6f6d599d56/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qe=
mu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60a23e35de5523b2a7b3a=
fb9
        failing since 180 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =



platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-broonie  | gcc-8    | versatile_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/60a23e58273cbcdf6db3afaf

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
90-374-g4c6f6d599d56/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
90-374-g4c6f6d599d56/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60a23e58273cbcdf6db3a=
fb0
        failing since 180 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =



platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-cip      | gcc-8    | versatile_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/60a23e435e52f33bafb3afbd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
90-374-g4c6f6d599d56/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
90-374-g4c6f6d599d56/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60a23e435e52f33bafb3a=
fbe
        failing since 180 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =20
