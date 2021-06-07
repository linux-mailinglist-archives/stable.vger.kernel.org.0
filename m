Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7608639D39A
	for <lists+stable@lfdr.de>; Mon,  7 Jun 2021 05:44:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230239AbhFGDqa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Jun 2021 23:46:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230246AbhFGDqa (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 6 Jun 2021 23:46:30 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB35FC061766
        for <stable@vger.kernel.org>; Sun,  6 Jun 2021 20:44:27 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id j12so12783076pgh.7
        for <stable@vger.kernel.org>; Sun, 06 Jun 2021 20:44:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=uM1i+puZKo1UL2/yKB6C0c1CZf5jKCmfuav2YMBMQR0=;
        b=VZ6Bn0WVNx9j9g63KjAM/WazWuquFkmLv3o2R0p7UXJ/84EH4alESa6Mp6V8C7J04D
         qRDBkf0QQKLWMePOvyhD33E7pucWh3SZNpjcq2AGB5T1u/zkHJre1GtyH9LZnonLNzL4
         zqUtNn/eSdiKwLYM98r9DzVvfDpNhy+dQiopRaakyYuplvI5t/e43tTNbsYfMcQhewiL
         dH55NRZYNgCEgRD4H80mXYDC2e2G1U9AUnC/UP4cWY+RGznpTw/5BbYYW2qKpJIKgzeL
         3A2QCnb0qiC+7YV5PnU2H9grZ0f3SA09T88rBbMt/YypQ0smGcdfITgh0eG9iGqkUoCz
         Pigw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=uM1i+puZKo1UL2/yKB6C0c1CZf5jKCmfuav2YMBMQR0=;
        b=K/nGuS1JQHIbXwuentt45QDqlz2nKQSMYaGt5V8Pb7OClbCtjHljKamwFa9IFDaZId
         2GJG6r2luK8nNgpaw8vuAUtjpAi0QProOhHzAkLcAJH6oAAft+n3eCczspnTOLQ7YE6N
         MRH+Ch04DCFo+Yapo4ji86TT4fOSIc22wEBmNFrFgd878iVA89svpuPF9sO88nPa3hk/
         x9B0xwe/V3hXe6Lm23KlmZTR4CpVCUEshh0+4e0KQrAEGw1Wk8C3kj2+bwqLiezPeXJP
         s+rtBp6GVfBz3nLDbf/4ZU4nlRDFsuDd3iZ9zHrwzx61W+oCMuZGbRc0pDUFkQfbnIl8
         0/pw==
X-Gm-Message-State: AOAM531eksCXwIMO5tYuj2ViyTkGlh3c4vlrIQYn1BP6zrT6nNk5JMyN
        sRreLBx7ebWqBBJfY99/BgCCrqIjMn2NvMtY
X-Google-Smtp-Source: ABdhPJx7ZNYv7Wd0F2OjPTUr7SU250FdVQO8R4bPOg1+v/j4l1w7Je0cP1LYQCIIM4vS1dV6vP4qvQ==
X-Received: by 2002:a63:4653:: with SMTP id v19mr15768152pgk.240.1623037467131;
        Sun, 06 Jun 2021 20:44:27 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id j4sm6492366pfj.111.2021.06.06.20.44.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Jun 2021 20:44:26 -0700 (PDT)
Message-ID: <60bd961a.1c69fb81.e458d.5729@mx.google.com>
Date:   Sun, 06 Jun 2021 20:44:26 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.235-12-ga098c3d57ce9
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.14
Subject: stable-rc/queue/4.14 baseline: 162 runs,
 2 regressions (v4.14.235-12-ga098c3d57ce9)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 162 runs, 2 regressions (v4.14.235-12-ga098c=
3d57ce9)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig          | =
regressions
-----------------+-------+---------------+----------+--------------------+-=
-----------
beaglebone-black | arm   | lab-collabora | gcc-8    | multi_v7_defconfig | =
1          =

meson-gxm-q200   | arm64 | lab-baylibre  | gcc-8    | defconfig          | =
1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.235-12-ga098c3d57ce9/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.235-12-ga098c3d57ce9
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      a098c3d57ce9427f675209cc3051ac63a998fd69 =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig          | =
regressions
-----------------+-------+---------------+----------+--------------------+-=
-----------
beaglebone-black | arm   | lab-collabora | gcc-8    | multi_v7_defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/60bd7b29c51276dc6d0c0e54

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.235=
-12-ga098c3d57ce9/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-beagl=
ebone-black.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.235=
-12-ga098c3d57ce9/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-beagl=
ebone-black.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60bd7b29c51276dc6d0c0=
e55
        new failure (last pass: v4.14.235-12-gc3f88167dd62) =

 =



platform         | arch  | lab           | compiler | defconfig          | =
regressions
-----------------+-------+---------------+----------+--------------------+-=
-----------
meson-gxm-q200   | arm64 | lab-baylibre  | gcc-8    | defconfig          | =
1          =


  Details:     https://kernelci.org/test/plan/id/60bd65f4ab3f317bb30c0e4d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.235=
-12-ga098c3d57ce9/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q20=
0.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.235=
-12-ga098c3d57ce9/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q20=
0.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60bd65f4ab3f317bb30c0=
e4e
        failing since 97 days (last pass: v4.14.222-11-g13b8482a0f700, firs=
t fail: v4.14.222-120-gdc8887cba23e) =

 =20
