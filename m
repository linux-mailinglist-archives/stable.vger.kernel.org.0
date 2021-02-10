Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E81F9316EB4
	for <lists+stable@lfdr.de>; Wed, 10 Feb 2021 19:32:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234327AbhBJSb0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Feb 2021 13:31:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234294AbhBJS3w (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Feb 2021 13:29:52 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05B13C061786
        for <stable@vger.kernel.org>; Wed, 10 Feb 2021 10:29:12 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id lw17so3325857pjb.0
        for <stable@vger.kernel.org>; Wed, 10 Feb 2021 10:29:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=VNMxoxPUEWsul7OUD9nlPwaFcVXxc74BBomuGTv1Zao=;
        b=uKLAlWaF27e8HK79uGyOKNGPQZm7N2SZUrYuTgiDv+NXUUgYGFjIRodHETtlZkHili
         C0yu+JxGu4RewOceeHYWeF69kiULEzCDoEjc9DEVa8HSaouU+H72ddO86pj9zu0pgSsm
         vnstEXjNdt9XFAVMLAPL3v1pO7tLA670y1cF7vVWk0iiG1yvojV5wg1n5SqWO6WObJkW
         8rKFSn6lCnPw3jz0vgkcb7CnrNXAAHpInjlbFCmcJY+jCZ0ip7iZYVLQ3iYDCT2Gv2Nz
         lI5+9GE9g7c2bXr5wEdjmhIKo5Rj/bUW0GdFJGHRNBW8VWCTpGR+wRRV21PuGyYO09YJ
         +f1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=VNMxoxPUEWsul7OUD9nlPwaFcVXxc74BBomuGTv1Zao=;
        b=B8jKQZyFG9ExnJ51Sl8PWm1jOsuZLxfQrfQf37hIDL/WVrY73N7HYSSpDUi//r2D44
         zJe6dFbJanJA8dhSial+qO2Y+4LUJcCwK1Ok0hhXPlmIdgxHqajyqD3t83cfcS9VK/wq
         pFWF7IEG4DzeGgcA4pYvbAqRhJwtkOMSoRMoU+j+SupHuAeBAzfDdcm3Eae4F3JVCltw
         Dq+7Zf4QnUl2o9yG+sypmo0YwuRTlZE4GQ43cKxAKUf9Sob5yZBLqTTntkbzhMFAOzus
         Ckj5m5SmTx+V/H5g6leUQxHBa4CSK4my0CE7vY2NbPY9WqvEtWf++gY/qyKnllJaUrt/
         Mevw==
X-Gm-Message-State: AOAM5337eX5aCa1Nkz2V5oPnr1RL2QO5lled/Wl+oA2IAQ9G81/PDXkZ
        MBlAOkXss3HHz5MOMO1ue4GbQIExRunGVQ==
X-Google-Smtp-Source: ABdhPJzWMXt6fKdIsWdRrYJpMXg2AG6u+sXy5vwwmiCV5mCAxppKCkbKi/MwCSaQyHamValCEFz5Ww==
X-Received: by 2002:a17:902:6b87:b029:dc:3402:18af with SMTP id p7-20020a1709026b87b02900dc340218afmr4274670plk.29.1612981751215;
        Wed, 10 Feb 2021 10:29:11 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id w3sm2906379pjb.2.2021.02.10.10.29.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Feb 2021 10:29:10 -0800 (PST)
Message-ID: <602425f6.1c69fb81.1ee41.64c3@mx.google.com>
Date:   Wed, 10 Feb 2021 10:29:10 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.4.97
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-5.4.y
Subject: stable/linux-5.4.y baseline: 107 runs, 2 regressions (v5.4.97)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.4.y baseline: 107 runs, 2 regressions (v5.4.97)

Regressions Summary
-------------------

platform             | arch  | lab          | compiler | defconfig | regres=
sions
---------------------+-------+--------------+----------+-----------+-------=
-----
bcm2837-rpi-3-b      | arm64 | lab-baylibre | gcc-8    | defconfig | 1     =
     =

hifive-unleashed-a00 | riscv | lab-baylibre | gcc-8    | defconfig | 1     =
     =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.4.y/kernel/=
v5.4.97/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.4.y
  Describe: v5.4.97
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      5e1942063dc3633f7a127aa2b159c13507580d21 =



Test Regressions
---------------- =



platform             | arch  | lab          | compiler | defconfig | regres=
sions
---------------------+-------+--------------+----------+-----------+-------=
-----
bcm2837-rpi-3-b      | arm64 | lab-baylibre | gcc-8    | defconfig | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/6023f465b44b4cbe5a3abe81

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.97/arm=
64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.97/arm=
64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.dmesg.crit: https://kernelci.org/test/case/id/6023f465b44b4cbe=
5a3abe86
        new failure (last pass: v5.4.96)
        1 lines

    2021-02-10 14:55:31.370000+00:00  Connected to bcm2837-rpi-3-b console =
[channel connected] (~$quit to exit)
    2021-02-10 14:55:31.371000+00:00  (user:khilman) is already connected
    2021-02-10 14:55:47.328000+00:00  =00
    2021-02-10 14:55:47.328000+00:00  =

    2021-02-10 14:55:47.329000+00:00  U-Boot 2018.11 (Dec 04 2018 - 10:54:3=
2 -0800)
    2021-02-10 14:55:47.329000+00:00  =

    2021-02-10 14:55:47.329000+00:00  DRAM:  948 MiB
    2021-02-10 14:55:47.347000+00:00  RPI 3 Model B (0xa02082)
    2021-02-10 14:55:47.431000+00:00  MMC:   mmc@7e202000: 0, sdhci@7e30000=
0: 1
    2021-02-10 14:55:47.463000+00:00  Loading Environment from FAT... *** W=
arning - bad CRC, using default environment =

    ... (384 line(s) more)  =

 =



platform             | arch  | lab          | compiler | defconfig | regres=
sions
---------------------+-------+--------------+----------+-----------+-------=
-----
hifive-unleashed-a00 | riscv | lab-baylibre | gcc-8    | defconfig | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/6023f33316e63a5ded3abe77

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (riscv64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.97/ris=
cv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleashed-a00.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.97/ris=
cv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleashed-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/riscv/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6023f33316e63a5ded3ab=
e78
        failing since 83 days (last pass: v5.4.77, first fail: v5.4.78) =

 =20
