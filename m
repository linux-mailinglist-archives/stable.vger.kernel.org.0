Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C57273D3155
	for <lists+stable@lfdr.de>; Fri, 23 Jul 2021 03:35:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233079AbhGWAyZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Jul 2021 20:54:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232892AbhGWAyY (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 22 Jul 2021 20:54:24 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 154FEC061575
        for <stable@vger.kernel.org>; Thu, 22 Jul 2021 18:34:58 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id u9-20020a17090a1f09b029017554809f35so6788959pja.5
        for <stable@vger.kernel.org>; Thu, 22 Jul 2021 18:34:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=OwbWP0hy/eBpbGk6XcUZiJgZCNcttjPIzpnrok1qZkY=;
        b=SC8+/MoQxPiDjQd8Z7vFT6n2Lg6ajMTqbCjPmf4mFd/QFcC0+Vazf2ugVnI9VavP5b
         ry+LtWO5D0m7PHkjNnwRdf23s7nUNxjdZHdCi6nWPbmoV12EyZA/8raxNF4F4KFNw/GI
         O8a9UzvId9m8fpp+bJ7D6yQbGU8zyOqYGeQfHEZII8DGMwAhWj0TDlwcLIHNECUOducP
         8ben7y+HIkAujAJMdnvkCZqtjrQItaCnq2yGOYmM0nUKiTyGL0tx2g19Kk4rIL/wrQ28
         oFvg7no9+9DH/67xoRQJsCouWTdGphKMof93in3rM7TxdMnhw25I+f92EqnfVmuG2Gif
         DmMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=OwbWP0hy/eBpbGk6XcUZiJgZCNcttjPIzpnrok1qZkY=;
        b=YsNIzABx+QRWsyVhe7FW3rvh6UcNSqFks5ta+xwgLKCVf50ZwtWcTDG4zFdzldvOyx
         /onUyzi6t1KaIXQDO5/Lkef4O5FxILjL9CuOCvDQeug7eJfo8U0Au24V+akmX3Lq/lBA
         FdglxH/OSRlR83XDvumlp+JCdywgWRsE0dt+D0SkAsq1mLt9IHfmvx+W5UDHohbSIcQC
         CkeNWqb9bP1wNAlEG2Udn8VHEsyQo6dCN5nSGIunUgX0eo1L3MmeMBuLee1ZGEWDFgQv
         5dYSfThLB1JLLZJkyMepNu5G1GVmJbrX4b6kQmbc4f+texWCU00jOqJ8ZYMJ2vG6JWAo
         UGaw==
X-Gm-Message-State: AOAM533vlduWQ5bV9ccYnh1GWC+ON+128zdDmuqME0P/ddw7INrXjojA
        +t6ef8M1YPlAshnjLexUNfwg3I4rAFIhHXTG
X-Google-Smtp-Source: ABdhPJx0f2EqvoIF0ApNRzQ6TRvKNZg8DNe/IJcK22YxRY/vWfbrwsi/ULQJbLHrVAcF8X23N9gwIg==
X-Received: by 2002:a63:5643:: with SMTP id g3mr2631843pgm.263.1627004097403;
        Thu, 22 Jul 2021 18:34:57 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id f31sm35932708pgm.1.2021.07.22.18.34.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Jul 2021 18:34:57 -0700 (PDT)
Message-ID: <60fa1cc1.1c69fb81.50f87.ee26@mx.google.com>
Date:   Thu, 22 Jul 2021 18:34:57 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.9
X-Kernelci-Kernel: v4.9.275-270-ge3941815b267
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.9 baseline: 124 runs,
 4 regressions (v4.9.275-270-ge3941815b267)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 124 runs, 4 regressions (v4.9.275-270-ge39418=
15b267)

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
el/v4.9.275-270-ge3941815b267/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.275-270-ge3941815b267
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      e3941815b2671084bbb01178450c9e1a63446f3e =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60f9e2e4aeb4afd9a485c25e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.275-2=
70-ge3941815b267/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.275-2=
70-ge3941815b267/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60f9e2e4aeb4afd9a485c=
25f
        failing since 250 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60f9faa95ec1899dca85c302

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.275-2=
70-ge3941815b267/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.275-2=
70-ge3941815b267/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60f9faa95ec1899dca85c=
303
        failing since 250 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60f9e2de829a4a2e8b85c28a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.275-2=
70-ge3941815b267/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.275-2=
70-ge3941815b267/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60f9e2de829a4a2e8b85c=
28b
        failing since 250 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60f9f541594fd929ad85c261

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.275-2=
70-ge3941815b267/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.275-2=
70-ge3941815b267/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60f9f541594fd929ad85c=
262
        failing since 250 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =20
