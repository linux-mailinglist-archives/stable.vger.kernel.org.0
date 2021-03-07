Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07ED0330431
	for <lists+stable@lfdr.de>; Sun,  7 Mar 2021 20:17:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232590AbhCGTRM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Mar 2021 14:17:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232513AbhCGTRD (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 7 Mar 2021 14:17:03 -0500
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 451D8C06174A
        for <stable@vger.kernel.org>; Sun,  7 Mar 2021 11:17:03 -0800 (PST)
Received: by mail-pf1-x431.google.com with SMTP id 18so5761346pfo.6
        for <stable@vger.kernel.org>; Sun, 07 Mar 2021 11:17:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=HZl3xra4xzvNeRbTtHV2BcTtklIoaS/guzx+hv9nnoA=;
        b=YunUn1XToPnuM4bIcYp9zU4wxLNVHzm1T+2x1G95DPmanKMsWwGvr/hURM/RLCmdY8
         nDlFMq5T62WmyI3JLJPaPCWFyIRmMvxEzBDJ9W7T4/OtDnKhMCvRvD8qgybdteJYWj7S
         1nwZWDTH4p0BoUNMo0xfPdBy0KcU9o6h7inquxivmQ13wC3leABMsNFapeX7WfLx6FkC
         6eqEriS5Xb+08aU6GlVDjS9PdfcKE3fRhMdVAFU1k8eQKt71/uUJxZPysCR6+q0dGwY/
         H8xwNHEo/PArtr2kh8J1hOhhktXxCVCVOO52IoYTdOi2uw5zRxxCnXFAOxcoqkju+FIx
         tHgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=HZl3xra4xzvNeRbTtHV2BcTtklIoaS/guzx+hv9nnoA=;
        b=POaUkGM8X9qExHRIW54SsREYtmuUjR3/iupsrcb1zrvCe7Led8RQ82jk0++QfLacKN
         NHTd/gUfXCJBWJhAlVkB4K/05ASdLfyfDkCji/dwhHWLg8/TwDTcumeIWSORhcsJu5ry
         8i46Xmcewms5s1yaokt4udUj7h0Lc6gwMCs4Ng+FYwDZS5OB8XnPh4QuE9/6T6GLMhZz
         Ijbq/eapL5n4hIPZnekUpRpDpjwKD0dhjO9uSZ/OQ2prUFyfXxsB5+js1l9uoujiY689
         DYBa+SXnLzmkBu15gk1cfLT02OwgbaYheUhXH99arXEVJj1N9+t4nnN8ofBEwWUSoUPm
         415g==
X-Gm-Message-State: AOAM530aMCYUiMpDyQeXqN7ETnGVOribSoJHmizt09Kcp1YO9b9ZIQyV
        hcVkswFuIK6ysEGe1qIYU4mXhs16/naGnA==
X-Google-Smtp-Source: ABdhPJxvztLbK+ymUZ6cXrCyApoFdD4BDlft6YcDNZjkcxhYQbXLA2N18HAkKC8G69rdzV/qxVHpXA==
X-Received: by 2002:a65:6642:: with SMTP id z2mr17443894pgv.214.1615144622715;
        Sun, 07 Mar 2021 11:17:02 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id c72sm7965372pfb.165.2021.03.07.11.17.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 Mar 2021 11:17:02 -0800 (PST)
Message-ID: <604526ae.1c69fb81.10f9f.3944@mx.google.com>
Date:   Sun, 07 Mar 2021 11:17:02 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.4.102-84-ge3ce9b478a13e
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.4
Subject: stable-rc/queue/5.4 baseline: 169 runs,
 3 regressions (v5.4.102-84-ge3ce9b478a13e)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 169 runs, 3 regressions (v5.4.102-84-ge3ce9b4=
78a13e)

Regressions Summary
-------------------

platform             | arch  | lab          | compiler | defconfig         =
| regressions
---------------------+-------+--------------+----------+-------------------=
+------------
bcm2837-rpi-3-b-32   | arm   | lab-baylibre | gcc-8    | bcm2835_defconfig =
| 1          =

hifive-unleashed-a00 | riscv | lab-baylibre | gcc-8    | defconfig         =
| 1          =

meson-gxm-q200       | arm64 | lab-baylibre | gcc-8    | defconfig         =
| 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.102-84-ge3ce9b478a13e/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.102-84-ge3ce9b478a13e
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      e3ce9b478a13e7178a21c8eb9e4cc79e7f56edcd =



Test Regressions
---------------- =



platform             | arch  | lab          | compiler | defconfig         =
| regressions
---------------------+-------+--------------+----------+-------------------=
+------------
bcm2837-rpi-3-b-32   | arm   | lab-baylibre | gcc-8    | bcm2835_defconfig =
| 1          =


  Details:     https://kernelci.org/test/plan/id/6044f21637b8b8f898addcff

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.102-8=
4-ge3ce9b478a13e/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837-=
rpi-3-b-32.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.102-8=
4-ge3ce9b478a13e/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837-=
rpi-3-b-32.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6044f21637b8b8f898add=
d00
        new failure (last pass: v5.4.102-72-g2219284ec8a8b) =

 =



platform             | arch  | lab          | compiler | defconfig         =
| regressions
---------------------+-------+--------------+----------+-------------------=
+------------
hifive-unleashed-a00 | riscv | lab-baylibre | gcc-8    | defconfig         =
| 1          =


  Details:     https://kernelci.org/test/plan/id/6044f1b7c93edc6495addd37

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (riscv64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.102-8=
4-ge3ce9b478a13e/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleash=
ed-a00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.102-8=
4-ge3ce9b478a13e/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleash=
ed-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/riscv/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6044f1b7c93edc6495add=
d38
        failing since 107 days (last pass: v5.4.78-5-g843222460ebea, first =
fail: v5.4.78-13-g81acf0f7c6ec) =

 =



platform             | arch  | lab          | compiler | defconfig         =
| regressions
---------------------+-------+--------------+----------+-------------------=
+------------
meson-gxm-q200       | arm64 | lab-baylibre | gcc-8    | defconfig         =
| 1          =


  Details:     https://kernelci.org/test/plan/id/6044f5727bd1acc3c5addcb9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.102-8=
4-ge3ce9b478a13e/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q200=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.102-8=
4-ge3ce9b478a13e/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q200=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6044f5727bd1acc3c5add=
cba
        new failure (last pass: v5.4.102-72-g2219284ec8a8b) =

 =20
