Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3B1A3DC738
	for <lists+stable@lfdr.de>; Sat, 31 Jul 2021 19:36:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229811AbhGaRge (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 31 Jul 2021 13:36:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbhGaRge (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 31 Jul 2021 13:36:34 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E64AC06175F
        for <stable@vger.kernel.org>; Sat, 31 Jul 2021 10:36:28 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id e5so14856468pld.6
        for <stable@vger.kernel.org>; Sat, 31 Jul 2021 10:36:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=cjTNAR8laqabEr9BOvDo7xMRuPz/zTa9ternAe4m/s0=;
        b=Ytxldf1pM1KuCWnyCD2JOY1lXGLgMqZXw+UfidSp8bSZy86jNsUiWax0WTKiRjrEQR
         602V/v9VSq9hVCrHVQIpdFOIkzwxzDk/DA+6bgViDA9wJnpdZh5jqBRKLgFVkB0Nav9g
         7KUUAT29EmrmxdfwoUXxjNiy0zdr/Jj4rdAiHnx73jPJOq5QYq6K7PP4OM4S3rGUSY6/
         khGbM0IjhOcFaXJNMMeEMymnjhdHI7RiNZD/cQ5o278Kb1ovdPPiSEZ0x9Ratfl4NiRz
         aVB8P2JV/eLQ7ptOEsFUgnb+VUDHFrVr270btDayNsQsBDoFPX/EWWu43Vzog/zAWyGm
         8DSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=cjTNAR8laqabEr9BOvDo7xMRuPz/zTa9ternAe4m/s0=;
        b=Omq5H5h8ceWlvvlXvij/VZZZf3BNz1K/cI/w0tICbqQoocafdv5PyokhiEikclh6x/
         THRS/uzpjDSP3wZYq27GihhvQoOhYC3YemjjgRFGk5ClkIHAMjZGfWOmMwS+Ose2KZp6
         d+5ACslNHLZUez5nq0sI8OHO2kul1DrE3rry98JS9BqUwr3rde4cAb0qYWGQbB6zHna9
         jeRmNeuihkBxzJ116/+gWW7a5VbXDYp308+W9oqJGUBvv5g21OKUh8qQlmOA054tB59J
         qAJizcQIppFPwYmpWaYlcksubNfMEF9ACsfo5EOoUbkWgAq67Td0g86e6Tf1JwhO93Sx
         V21A==
X-Gm-Message-State: AOAM531JhZ997ZK4ej0CG9A90ddbgLBgNf3irSK1liizciHD9FyYR2Gr
        HkxVj4KvVJRm1378MYzm5FjEcAQ0DgJEM/7E
X-Google-Smtp-Source: ABdhPJyH4hFQrjkarJI5N4VJhCn/vdH5a89IkgRO8gvmtqlYDY0bdcvUztd/70tmBEcaLbf/85JIlA==
X-Received: by 2002:a17:90b:1a92:: with SMTP id ng18mr9229040pjb.86.1627752987389;
        Sat, 31 Jul 2021 10:36:27 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id l2sm6324507pfc.157.2021.07.31.10.36.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 31 Jul 2021 10:36:26 -0700 (PDT)
Message-ID: <61058a1a.1c69fb81.54b83.1317@mx.google.com>
Date:   Sat, 31 Jul 2021 10:36:26 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Kernel: v4.19.200-15-g5b0f1f3c91d6
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.19.y baseline: 132 runs,
 3 regressions (v4.19.200-15-g5b0f1f3c91d6)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y baseline: 132 runs, 3 regressions (v4.19.200-15-g5b0=
f1f3c91d6)

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.19.y/ker=
nel/v4.19.200-15-g5b0f1f3c91d6/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.19.y
  Describe: v4.19.200-15-g5b0f1f3c91d6
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      5b0f1f3c91d65fa0be6c669481396905a0ced083 =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/610551d1fa1e45a26885f46e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
00-15-g5b0f1f3c91d6/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
00-15-g5b0f1f3c91d6/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/610551d1fa1e45a26885f=
46f
        failing since 255 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/61055211beb17e41ce85f477

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
00-15-g5b0f1f3c91d6/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
00-15-g5b0f1f3c91d6/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61055211beb17e41ce85f=
478
        failing since 255 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6105515a495e3f846285f45e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
00-15-g5b0f1f3c91d6/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qe=
mu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
00-15-g5b0f1f3c91d6/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qe=
mu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6105515a495e3f846285f=
45f
        failing since 255 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =20
