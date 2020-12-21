Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92EBB2E0083
	for <lists+stable@lfdr.de>; Mon, 21 Dec 2020 19:56:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726239AbgLUSzg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Dec 2020 13:55:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726127AbgLUSzg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Dec 2020 13:55:36 -0500
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B244C0613D3
        for <stable@vger.kernel.org>; Mon, 21 Dec 2020 10:54:55 -0800 (PST)
Received: by mail-pg1-x534.google.com with SMTP id w5so6870575pgj.3
        for <stable@vger.kernel.org>; Mon, 21 Dec 2020 10:54:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=c4YvVaJWmTnjxaJ5r2ryohaDBftLwjvUV4h9NwotWuQ=;
        b=dYMk0uqNbkBD0T0kuSWuWWOLUdUvxR90jZMrRz0MUcTDCvotnF78NQk1+QisNkOEl6
         3FTECCSL/f/N5RyrhdYsVTuRSKOPBU8eV+fcIyVGB+v6/e/8IBL/7oN26seWlPfzVTbh
         89Kk7/cFfLBMmvf0KeKhgXiMFa5eJEMz8C+rzJT9GGxAbsrEQo60gm1OuYzMdBh6LZZg
         kE063RxZDKYIUdpCRF/qFKs1mmnnAkoTeX9DcBhGvMsMf7rOei5RfvB8UI5Mki2O+KAQ
         42iJg0topuV2Zi0nKD+I7dQy4pgtfdjsHsepUy7Anuu5mteY0ptJVjV8MPUI8/mcI2jJ
         Rzyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=c4YvVaJWmTnjxaJ5r2ryohaDBftLwjvUV4h9NwotWuQ=;
        b=Uy/Vlp2dc9QZqGW7ekEYZpI6FG6b4pdZazymqUQoGQgHhLvXhoJ9+gZQfPlIBlAZYU
         c/pamK+yH/actsDsxbVaSm9Zek2+n9R3JB4Y22+/2t03cPQRyZt1Wp+FwfnhINPnAB1y
         IhpmscZLI7YsgWSLB7c4AgFXJXX5WjgYR0t0gPbrXSgZ6ShpYYlHI9NkIKRMGEoYl5qK
         F0KiqYEgoILtvHvzzDMkAn5Wo07gviotK9RJPiUNCgMp0bnjHxKpUaWS41vTyTTFdNyE
         2i9NU3hxAj627LokuK5xZ3OyHgJYaOn006Ej1nNJgxXE+4EqYcEru/6k9tis0I39uyD1
         pJoA==
X-Gm-Message-State: AOAM532c5vuisVuinhvUdFEHjS/qiusnk1r0zTxtsyTMLJ5A3EmOX7tw
        hiTIagam7X5Rn5ZiNPQxuCusv9DeSGvjnw==
X-Google-Smtp-Source: ABdhPJykDDWsf8Ie5q/T5jbMxtMlWHqvFSlYh400K6EqwNhpSARkCe8jFf4HGkdzI+40PttPADB5rA==
X-Received: by 2002:a63:c155:: with SMTP id p21mr16072411pgi.377.1608576894822;
        Mon, 21 Dec 2020 10:54:54 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id j15sm17415533pfn.180.2020.12.21.10.54.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Dec 2020 10:54:54 -0800 (PST)
Message-ID: <5fe0ef7e.1c69fb81.be208.27dd@mx.google.com>
Date:   Mon, 21 Dec 2020 10:54:54 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.9
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.9.248-25-gb874f9fd96f4b
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.9 baseline: 108 runs,
 3 regressions (v4.9.248-25-gb874f9fd96f4b)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 108 runs, 3 regressions (v4.9.248-25-gb874f9f=
d96f4b)

Regressions Summary
-------------------

platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.248-25-gb874f9fd96f4b/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.248-25-gb874f9fd96f4b
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      b874f9fd96f4b6d2ce262b8d0ed58796532f6553 =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/5fe0b6dcfdcb8fe07ac94cd3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.248-2=
5-gb874f9fd96f4b/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.248-2=
5-gb874f9fd96f4b/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fe0b6dcfdcb8fe07ac94=
cd4
        failing since 37 days (last pass: v4.9.243-16-gd8d67e375b0a, first =
fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/5fe0b6e4a7ff3e475ec94cd3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.248-2=
5-gb874f9fd96f4b/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.248-2=
5-gb874f9fd96f4b/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fe0b6e4a7ff3e475ec94=
cd4
        failing since 37 days (last pass: v4.9.243-16-gd8d67e375b0a, first =
fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/5fe0b9281a176c3e99c94cbd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.248-2=
5-gb874f9fd96f4b/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.248-2=
5-gb874f9fd96f4b/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fe0b9281a176c3e99c94=
cbe
        failing since 37 days (last pass: v4.9.243-16-gd8d67e375b0a, first =
fail: v4.9.243-25-ga01fe8e99a22) =

 =20
