Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8B853220C6
	for <lists+stable@lfdr.de>; Mon, 22 Feb 2021 21:24:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232838AbhBVUXk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Feb 2021 15:23:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232447AbhBVUXh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Feb 2021 15:23:37 -0500
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB884C061574
        for <stable@vger.kernel.org>; Mon, 22 Feb 2021 12:22:57 -0800 (PST)
Received: by mail-pg1-x52f.google.com with SMTP id g4so305742pgj.0
        for <stable@vger.kernel.org>; Mon, 22 Feb 2021 12:22:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Gal8BxyvS7o4IRKR5LULJSaqFJpk2h0F1r1Nj921V40=;
        b=B8DYPiBs+rm09kDm1+HwU5I1IInObMATM66E1rggPKYV2bt/kUNGnnuOLoNg0/z16L
         W199dZKITY9dSBi5s1pCpbvP8YRGqWqib7Lsh6Tj/uAoPbsfSz30Yq0EtrpguLxaavev
         LG2gUEAq0CcSIpuocKp670k6gCYEePQ9u2sWwqosyFaynzig2B3CcEVM4PUxYINhy2Fq
         gZQAjdejZQpGAwZ5tJicZnAl2V0OiFFQISNu01c7HvLvDxeqsRgBT+wVS6hGcZAoqbVx
         XBye/m6PSeOiTEcFqDZ/k8T8RX09+oakVJKo/YZe7AxZ9oEaqtNja6Sd4MPnsr8nlygJ
         Ofkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Gal8BxyvS7o4IRKR5LULJSaqFJpk2h0F1r1Nj921V40=;
        b=URh49ZVI476fvDdQXhm3whXgqeSmjFcRZubmaLMC+GbBYWKQzofNB9fz0VpdtkAfeh
         UEP8d13DdSI7yJIw9dxIjt2/KJIhwpCtbjNYrEGqH4O/Nj3vnrKyZpsW/6PY38+1W8nU
         GdzFsPaWYTGFC0Izd+srjgZdgHtwEisIa52uVCmL8eUcyIwGhSpVS8D9z/UTxb8wFUge
         amK5kSkaV2Kffd8RIGaJIHVY9BHeIoVQebHNuyJA8rpMNMHqzwgSI0jsuk4f1pFXBvMQ
         wQwSs44i+VAohod0a3NVrhDpZdN7KFNbz7hu9QVa/ZhbCXENl3mVhm7j1eIoN5MASkCC
         fy0Q==
X-Gm-Message-State: AOAM531jvYCmOCah1PrjTe5kI4eDqwrtSi6vX8yh8Gk7LbY0mvLeYHCo
        43YBl113JSefHzJQHKoDnv/czsqcLr2wUA==
X-Google-Smtp-Source: ABdhPJwqhQUNF4FchkOvu/Elrg3DOigatW15ot/u6IE2hjWy0FUPaqUlUk5174OqZTsnW0SS3tCtDw==
X-Received: by 2002:a63:a54e:: with SMTP id r14mr19925041pgu.380.1614025377169;
        Mon, 22 Feb 2021 12:22:57 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id m12sm261453pjk.47.2021.02.22.12.22.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Feb 2021 12:22:56 -0800 (PST)
Message-ID: <603412a0.1c69fb81.73edb.0b5d@mx.google.com>
Date:   Mon, 22 Feb 2021 12:22:56 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.4.99-14-g2a63a6a366e1b
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.4
Subject: stable-rc/queue/5.4 baseline: 104 runs,
 2 regressions (v5.4.99-14-g2a63a6a366e1b)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 104 runs, 2 regressions (v5.4.99-14-g2a63a6a3=
66e1b)

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.99-14-g2a63a6a366e1b/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.99-14-g2a63a6a366e1b
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      2a63a6a366e1b31232b1652e1f3a9a94e0120a84 =



Test Regressions
---------------- =



platform             | arch  | lab          | compiler | defconfig         =
| regressions
---------------------+-------+--------------+----------+-------------------=
+------------
bcm2837-rpi-3-b-32   | arm   | lab-baylibre | gcc-8    | bcm2835_defconfig =
| 1          =


  Details:     https://kernelci.org/test/plan/id/6033dc67ada1044908addcc6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.99-14=
-g2a63a6a366e1b/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837-r=
pi-3-b-32.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.99-14=
-g2a63a6a366e1b/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837-r=
pi-3-b-32.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6033dc67ada1044908add=
cc7
        new failure (last pass: v5.4.99-14-gca97cc5c886f) =

 =



platform             | arch  | lab          | compiler | defconfig         =
| regressions
---------------------+-------+--------------+----------+-------------------=
+------------
hifive-unleashed-a00 | riscv | lab-baylibre | gcc-8    | defconfig         =
| 1          =


  Details:     https://kernelci.org/test/plan/id/6033db802e64508a2eaddcb2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (riscv64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.99-14=
-g2a63a6a366e1b/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleashe=
d-a00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.99-14=
-g2a63a6a366e1b/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleashe=
d-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/riscv/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6033db802e64508a2eadd=
cb3
        failing since 94 days (last pass: v5.4.78-5-g843222460ebea, first f=
ail: v5.4.78-13-g81acf0f7c6ec) =

 =20
