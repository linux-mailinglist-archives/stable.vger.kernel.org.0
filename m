Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96B4237F052
	for <lists+stable@lfdr.de>; Thu, 13 May 2021 02:22:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235010AbhEMAXa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 20:23:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233315AbhEMAXX (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 May 2021 20:23:23 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFA11C03543D
        for <stable@vger.kernel.org>; Wed, 12 May 2021 16:58:56 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id s20so13403914plr.13
        for <stable@vger.kernel.org>; Wed, 12 May 2021 16:58:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=33Z/h9nQDlltPLAOUcGmHYEiF3HLG/yJcBQ01FupXjw=;
        b=lvicTZey+k629HXAHMQuDt0ul6Mn1c53llUFXXU9qQOH0q+HvJ0m/7+QEm+j3e/AIu
         CELv1MWmcq10f75JfvupA2inZb4aap2NtIrcifZtpRylDvRI04RtFmwHqPckA+r636nu
         t+iJ+1e+pMvLladWrt9+/y+u2RcyOmtuX/SfI9oMf43lWylrrthzXC7Mj56MD/O3NfKC
         I9RxxB2/qPVMHBG8fIFal+redKIXKGtPvC6Mv90KQvHeO3IvwxMinfLgT+13xd3rJpA5
         y56x8XF1hGjciirahNXzv/st4931liA4Yb1IGG6xgEwpGVI7SFnYIeG2F3JJLYgvwjqt
         VE/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=33Z/h9nQDlltPLAOUcGmHYEiF3HLG/yJcBQ01FupXjw=;
        b=puCWUebEBzNEpJQWMj55Y/xZMJDS7pqDjV1dn68tBJ+UOW23yuvJyH8mtVkeHldgDD
         l3EQk0+EYhY563OGSigPC30aMPD0CzIOTsCdGCVk3abrp9vOf1AaBts+2QC8mMJhxx/w
         oRIietMxlxSTk6HajCDQk1a/B2LaNPze789lF0fDGmo4P6WXHtRwasyndjRh29lyR/GS
         vvIRcalN31S47JIzMg0D2U/Y4yToJUh1bdfT7nQbsTAOCRYloVad5mIJ8/O8PGbS+9ht
         50YPihZWm0dQ0FJU5xbVkcJJ/mtoq34mzJoizNdpP5h2CxTm5BDtqZGL+6IGVarkXCWd
         O5VQ==
X-Gm-Message-State: AOAM530hWONT1mbKdYPfxJ6dj9Mh1Yj2Gn3VqhOFvyd5p2S89N/kS1Py
        IPyAfAapM4Ua2KifKYjzqEBGOeEyoRsOhdzZ
X-Google-Smtp-Source: ABdhPJyf5Aodidwt6Y8BWQLVSC1Jx8aJAr3lS9JtTRQ6vBRD/Xz/E/z0ixx5hM9qYqM6Ve4uLlbLOw==
X-Received: by 2002:a17:902:8ecc:b029:ef:6471:dc08 with SMTP id x12-20020a1709028eccb02900ef6471dc08mr10139236plo.5.1620863936307;
        Wed, 12 May 2021 16:58:56 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b3sm701575pfv.61.2021.05.12.16.58.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 May 2021 16:58:56 -0700 (PDT)
Message-ID: <609c6bc0.1c69fb81.aa6be.33ff@mx.google.com>
Date:   Wed, 12 May 2021 16:58:56 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.9.268-169-ge30e89ea7d9a
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.9
Subject: stable-rc/queue/4.9 baseline: 108 runs,
 4 regressions (v4.9.268-169-ge30e89ea7d9a)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 108 runs, 4 regressions (v4.9.268-169-ge30e89=
ea7d9a)

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
el/v4.9.268-169-ge30e89ea7d9a/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.268-169-ge30e89ea7d9a
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      e30e89ea7d9a2e3d9589ca1d31b57d40136c2862 =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/609c378b4137f07242199278

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.268-1=
69-ge30e89ea7d9a/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.268-1=
69-ge30e89ea7d9a/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/609c378b4137f07242199=
279
        failing since 179 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/609c37858d04ccc398199297

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.268-1=
69-ge30e89ea7d9a/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.268-1=
69-ge30e89ea7d9a/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/609c37858d04ccc398199=
298
        failing since 179 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/609c37938d04ccc3981992a2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.268-1=
69-ge30e89ea7d9a/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.268-1=
69-ge30e89ea7d9a/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/609c37938d04ccc398199=
2a3
        failing since 179 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/609c372ceb22119814199286

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.268-1=
69-ge30e89ea7d9a/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.268-1=
69-ge30e89ea7d9a/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/609c372ceb22119814199=
287
        failing since 179 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =20
