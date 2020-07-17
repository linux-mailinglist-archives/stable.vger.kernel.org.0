Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25793224091
	for <lists+stable@lfdr.de>; Fri, 17 Jul 2020 18:29:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726256AbgGQQ3o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Jul 2020 12:29:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726221AbgGQQ3n (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Jul 2020 12:29:43 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0957C0619D2
        for <stable@vger.kernel.org>; Fri, 17 Jul 2020 09:29:42 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id d1so5654702plr.8
        for <stable@vger.kernel.org>; Fri, 17 Jul 2020 09:29:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=n8JVGaMe3Z44B7qoi2FAKTE2Sz25ES+TtQruPDJLrb8=;
        b=oqmGv/+wl51r1UohOpSYYZD6WubpEdix2egWgsZ3COTAh6SUkP5LKZwq9H0fXOeLy0
         kRwOdaUTx8fvpJMQv4WEiMPtuNYcnid9prd6apeSfEEGwZ5Xe9ypQdQWS5jKZmKg3j1H
         2AK6Lk/AkNPnmOqsw1Qbmz2JUp3dPlbNzQ2ZlzskuI6Qwnba99obldtxh+RybJy5pLu4
         k+G+l9eunoPElkJDf1soMn73eb2ikvblHWynRVDQt647yGDwWCykOP6kQaAIPKurPyRN
         Zj2BAQN9UWsdIAlHCv12rbFE1BlZIYv8w9sOKvdLOUPnlACfHlTv5V/MF99b3q0fn0mS
         0KyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=n8JVGaMe3Z44B7qoi2FAKTE2Sz25ES+TtQruPDJLrb8=;
        b=E19jsoQHSnEJnq8T+59qRQedYpMRF7F9fmh5l30kTp6Hc9PN/8yneTJhEbFvE0fF86
         5yBQ9EwwKa2Ed2Kq59+pQcNVJ8rfQg5//hh36XMi4ya4I3bmXqB8ytwPRDUJ4bEsppvm
         IzlnJLGyB7Wqff0A9CaqZ24YeGVgAhvIoN49duIo3CjLeI0h1WrqztZYtW2gnvSX0+qr
         50qABr0V5EScVAulB3ntWvO4q+L/6syVpjc4KCp2pz240BcaNbSDGiyRM58qBSsSUH6S
         Hbku1jm3faSgu6PUIQlFZxx53me33NvMvit0C2FMjLA5YJX/NzrMoZNZjGlAmE/iX2wV
         aLOw==
X-Gm-Message-State: AOAM532Y34RoVuHgpFB1BBVfYKuTnNDEv3a82cXUgiGj7AcUV+iS/L/9
        6qyN7PuqeMiBedFSMAvCzY8jASH+yRY=
X-Google-Smtp-Source: ABdhPJzMQy0RrFzNbNG7ArfcDmXPG/dCC/ydOEN6/7PayZ06v8g2lbDrsDoYNsIO+Xkx9lnnqdi/gA==
X-Received: by 2002:a17:90a:1f08:: with SMTP id u8mr11148500pja.154.1595003381134;
        Fri, 17 Jul 2020 09:29:41 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id d18sm3264638pjv.25.2020.07.17.09.29.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jul 2020 09:29:40 -0700 (PDT)
Message-ID: <5f11d1f4.1c69fb81.9a6d1.ad0b@mx.google.com>
Date:   Fri, 17 Jul 2020 09:29:40 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.7.9-32-g83669367670a
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.7.y
Subject: stable-rc/linux-5.7.y baseline: 113 runs,
 4 regressions (v5.7.9-32-g83669367670a)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.7.y baseline: 113 runs, 4 regressions (v5.7.9-32-g8366936=
7670a)

Regressions Summary
-------------------

platform                | arch  | lab          | compiler | defconfig      =
    | results
------------------------+-------+--------------+----------+----------------=
----+--------
at91-sama5d4_xplained   | arm   | lab-baylibre | gcc-8    | sama5_defconfig=
    | 0/1    =

meson-gxl-s905d-p230    | arm64 | lab-baylibre | gcc-8    | defconfig      =
    | 0/1    =

omap3-beagle-xm         | arm   | lab-baylibre | gcc-8    | multi_v7_defcon=
fig | 0/1    =

sun50i-a64-bananapi-m64 | arm64 | lab-clabbe   | gcc-8    | defconfig      =
    | 0/1    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.7.y/kern=
el/v5.7.9-32-g83669367670a/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.7.y
  Describe: v5.7.9-32-g83669367670a
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      83669367670a429e399df551489a52116fd98c96 =



Test Regressions
---------------- =



platform                | arch  | lab          | compiler | defconfig      =
    | results
------------------------+-------+--------------+----------+----------------=
----+--------
at91-sama5d4_xplained   | arm   | lab-baylibre | gcc-8    | sama5_defconfig=
    | 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f119e2b8a88b427bf85bb3e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sama5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.7.y/v5.7.9-3=
2-g83669367670a/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5d=
4_xplained.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.7.y/v5.7.9-3=
2-g83669367670a/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5d=
4_xplained.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/armel/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f119e2b8a88b427bf85b=
b3f
      failing since 0 day (last pass: v5.7.8-167-gc2fb28a4b6e4, first fail:=
 v5.7.9) =



platform                | arch  | lab          | compiler | defconfig      =
    | results
------------------------+-------+--------------+----------+----------------=
----+--------
meson-gxl-s905d-p230    | arm64 | lab-baylibre | gcc-8    | defconfig      =
    | 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f119ff7565d5513b785bb22

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.7.y/v5.7.9-3=
2-g83669367670a/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxl-s905d=
-p230.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.7.y/v5.7.9-3=
2-g83669367670a/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxl-s905d=
-p230.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/arm64/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f119ff7565d5513b785b=
b23
      new failure (last pass: v5.7.9) =



platform                | arch  | lab          | compiler | defconfig      =
    | results
------------------------+-------+--------------+----------+----------------=
----+--------
omap3-beagle-xm         | arm   | lab-baylibre | gcc-8    | multi_v7_defcon=
fig | 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f11a058cc4f2290bb85bb33

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.7.y/v5.7.9-3=
2-g83669367670a/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-omap3-be=
agle-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.7.y/v5.7.9-3=
2-g83669367670a/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-omap3-be=
agle-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/armel/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f11a058cc4f2290bb85b=
b34
      new failure (last pass: v5.7.9) =



platform                | arch  | lab          | compiler | defconfig      =
    | results
------------------------+-------+--------------+----------+----------------=
----+--------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe   | gcc-8    | defconfig      =
    | 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f119f420df796681385bb5e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.7.y/v5.7.9-3=
2-g83669367670a/arm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-banana=
pi-m64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.7.y/v5.7.9-3=
2-g83669367670a/arm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-banana=
pi-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/arm64/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f119f420df796681385b=
b5f
      new failure (last pass: v5.7.9) =20
