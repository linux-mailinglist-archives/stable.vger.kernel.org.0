Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA88B31B54A
	for <lists+stable@lfdr.de>; Mon, 15 Feb 2021 06:37:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229486AbhBOFhG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Feb 2021 00:37:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbhBOFhB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Feb 2021 00:37:01 -0500
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DA43C061756
        for <stable@vger.kernel.org>; Sun, 14 Feb 2021 21:36:21 -0800 (PST)
Received: by mail-pl1-x632.google.com with SMTP id k22so3097940pll.6
        for <stable@vger.kernel.org>; Sun, 14 Feb 2021 21:36:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Vw2xX0zL/3xy+IlAWTscejW2/WCAkM+C03F4NXfUoiM=;
        b=xEuSjcBdg8DKWv8tWzRJsGK4lOQbYGbH+oDf5hvmm3ZxTB5OZjyCkgCvoNzu+1y+BQ
         8BC+Dc7/HlWDmwCTQLMCXCRYl8eb0Uqg/GmO29r0jddNZ0SYLIYgvzjJu2Ig//htiCbK
         xG0SnSBR1Uow51HULFM8UqkN79Cx4nUIB+wPt1KzPZFX2N4cKd6VId33/m2M26NM7Y5+
         P8h5aU5twLHaX514lv/nNI46jhaX5yhPP59NmfSUcANRofAbebYcM7aLqZ36RLdN3fuI
         QbH/TjxbAu/AJaX3qE1WK/bspjTQHhqFSlk6UqRYWEFh/QTPq/BJAEIEirCXeSmF10pD
         2vBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Vw2xX0zL/3xy+IlAWTscejW2/WCAkM+C03F4NXfUoiM=;
        b=PJYKU22ET5GYEtoUz79Yw45hg/mv6W00hiujTBbnealUd1+rc7yBObGjpyoyLL7S8D
         tTYm4/xoXeNZzegbJ/ggSXBbdK5/o9ZdxaYJnVFH8rGFXH7i/z9AIDirJWh+Ani3d4L0
         LHgmM1bw62BubLk+JW1cSelFPERuYhmlCHjVbnFNgP9KSObHMZl12HPWT5BinZOtr0/y
         ZG9q4JU4RFNYceq4eHsnawC8s9fqWoJBi0MNj+dWe1ziR3xmke8Eg7TDQiq+VsFrh2lH
         wz97MkwIj8EOgjA1i04NhMjW24m8VXAUzTFAeChRKKSj4kPdBIXg7aqQySypcckZ+DCN
         HPbA==
X-Gm-Message-State: AOAM5301MHnnU6o/n78IxKj5SwbTLvFJrfce/xn0On/zxgsF85SvoUIZ
        pj5yXIElzhJ0IcLvQuAGAp3LH+/psYrx/Q==
X-Google-Smtp-Source: ABdhPJycMsxRtS5kDcZQH1kyQ5zcvRXtcQ9frQOmPaWrGYfsEx6a30Af/sAuMJ2iBQqMUYzCeAdi/w==
X-Received: by 2002:a17:90a:46cc:: with SMTP id x12mr14386409pjg.114.1613367380786;
        Sun, 14 Feb 2021 21:36:20 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id s21sm15982361pga.12.2021.02.14.21.36.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 14 Feb 2021 21:36:20 -0800 (PST)
Message-ID: <602a0854.1c69fb81.a38f0.24dd@mx.google.com>
Date:   Sun, 14 Feb 2021 21:36:20 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.14.221-28-ge8a928022308
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.14
Subject: stable-rc/queue/4.14 baseline: 62 runs,
 2 regressions (v4.14.221-28-ge8a928022308)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 62 runs, 2 regressions (v4.14.221-28-ge8a928=
022308)

Regressions Summary
-------------------

platform       | arch  | lab           | compiler | defconfig           | r=
egressions
---------------+-------+---------------+----------+---------------------+--=
----------
meson-gxm-q200 | arm64 | lab-baylibre  | gcc-8    | defconfig           | 1=
          =

panda          | arm   | lab-collabora | gcc-8    | omap2plus_defconfig | 1=
          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.221-28-ge8a928022308/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.221-28-ge8a928022308
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      e8a928022308c0b33e49d6b752ad8a92411be03a =



Test Regressions
---------------- =



platform       | arch  | lab           | compiler | defconfig           | r=
egressions
---------------+-------+---------------+----------+---------------------+--=
----------
meson-gxm-q200 | arm64 | lab-baylibre  | gcc-8    | defconfig           | 1=
          =


  Details:     https://kernelci.org/test/plan/id/6029d6214c7b2ca7b83abe7c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.221=
-28-ge8a928022308/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q20=
0.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.221=
-28-ge8a928022308/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q20=
0.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6029d6214c7b2ca7b83ab=
e7d
        failing since 68 days (last pass: v4.14.210-20-gc32b9f7cbda7, first=
 fail: v4.14.210-20-g5ea7913395d3) =

 =



platform       | arch  | lab           | compiler | defconfig           | r=
egressions
---------------+-------+---------------+----------+---------------------+--=
----------
panda          | arm   | lab-collabora | gcc-8    | omap2plus_defconfig | 1=
          =


  Details:     https://kernelci.org/test/plan/id/6029d69e1490ca4c5f3abe6c

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.221=
-28-ge8a928022308/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.221=
-28-ge8a928022308/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/6029d69e1490ca4=
c5f3abe73
        failing since 8 days (last pass: v4.14.219-15-g82c6ae41b66a6, first=
 fail: v4.14.219-15-g8b9453943a205)
        2 lines

    2021-02-15 02:04:10.514000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xffffed34 [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
