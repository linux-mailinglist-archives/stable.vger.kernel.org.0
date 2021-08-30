Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C406A3FB6DF
	for <lists+stable@lfdr.de>; Mon, 30 Aug 2021 15:19:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236631AbhH3NTt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Aug 2021 09:19:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbhH3NTr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Aug 2021 09:19:47 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 299ACC061575
        for <stable@vger.kernel.org>; Mon, 30 Aug 2021 06:18:53 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id j4-20020a17090a734400b0018f6dd1ec97so9964271pjs.3
        for <stable@vger.kernel.org>; Mon, 30 Aug 2021 06:18:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=umQjxGK4Ie/qTYtOpq9h0hby3vdsy8knQIOHy2yiLWM=;
        b=wfHdAkC+IiREqlzmzZ8TTp0L3jLa7CdMKODKNt+1EYosEy/Ednkc1X9AkPPx0A/0CS
         NPUmHl0xkecXNroYCwwd92LoZF5iyKVe36+cQV5JlhAvfD312rF62IbmZD4H+cE6MfYQ
         jRxdNkTOpTC36c6TZE8RYgFqMIpZc4kxa/qYckEwYZTJT4sMZkXDn8eyVdbuwuVT2btE
         427GBS76fKDLW8VAxitSME3GmhP4y/C9wPUZWAQuu9feDxOi8quet0+cNcb92fxE3Srk
         3ibJXWaWKSK7dD17I/V5fKk/ul0y7M/luRXzBFjQCV/vxe9a2XBTYzLOcZ4yE0sFBfuw
         uMcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=umQjxGK4Ie/qTYtOpq9h0hby3vdsy8knQIOHy2yiLWM=;
        b=UfRBKbewxd10XjkKScqZuHSIA+U2+OTlrtmgECGojtsTC4ys5gMMOUjff/GQUfkdd3
         cfd8xCq9y8by5fXOpZ9fc7duCtzWgZBjm0YYPUzLsgl97pgELkt5jJSTaoIAo4NlpoIO
         nu/u+WCUG350PZitOmN8RfNn66qJ/SsatylE4gANdryzZlgvgqb9mj0Ig3Kl4lkBqSWT
         RCuu7KCtViUyThRK7N1W8jmOUb3+mDjIeNRIcnS/5KdBZ9bus6VAGtMdK4lq8MOl2WO4
         VBnDNe92WFpiNiWL/HznufhCdfx2q5QWdDyN0Fa6FWgAooEidj4XkVbATViR0oL71kGL
         tEGg==
X-Gm-Message-State: AOAM532MXPk+W8vrOeRzba8vZIg1QZu5Eoe5YQWut2PfLamPtyXskPdB
        u9iI5ovQOVzGJF/oyr1RRVgxAG8ErNGn/HdC
X-Google-Smtp-Source: ABdhPJw5sTRs4h7W2oML3ryxb4NQ64juVMnFmCfHsLyiA7zHnNjtQfjFAjqEj7W0Fd2Tw9+NcU1Mmg==
X-Received: by 2002:a17:90a:12:: with SMTP id 18mr28064433pja.104.1630329532225;
        Mon, 30 Aug 2021 06:18:52 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id l127sm4401651pfl.99.2021.08.30.06.18.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Aug 2021 06:18:51 -0700 (PDT)
Message-ID: <612cdabb.1c69fb81.c1660.9eb8@mx.google.com>
Date:   Mon, 30 Aug 2021 06:18:51 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Kernel: v4.19.205-20-g0ec64a47cbb1
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.19.y baseline: 138 runs,
 3 regressions (v4.19.205-20-g0ec64a47cbb1)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y baseline: 138 runs, 3 regressions (v4.19.205-20-g0ec=
64a47cbb1)

Regressions Summary
-------------------

platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-baylibre | gcc-8    | versatile_defconfig=
 | 1          =

qemu_arm-versatilepb | arm  | lab-broonie  | gcc-8    | versatile_defconfig=
 | 1          =

qemu_arm-versatilepb | arm  | lab-cip      | gcc-8    | versatile_defconfig=
 | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.19.y/ker=
nel/v4.19.205-20-g0ec64a47cbb1/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.19.y
  Describe: v4.19.205-20-g0ec64a47cbb1
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      0ec64a47cbb11f5919e47cdab83f201ea5ca6076 =



Test Regressions
---------------- =



platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-baylibre | gcc-8    | versatile_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/612ca6b438ab5850b18e2c77

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
05-20-g0ec64a47cbb1/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
05-20-g0ec64a47cbb1/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/612ca6b438ab5850b18e2=
c78
        failing since 285 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =



platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-broonie  | gcc-8    | versatile_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/612ca7b5428727c3548e2c9c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
05-20-g0ec64a47cbb1/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
05-20-g0ec64a47cbb1/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/612ca7b5428727c3548e2=
c9d
        failing since 285 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =



platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-cip      | gcc-8    | versatile_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/612ca6a9f775a571fd8e2c98

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
05-20-g0ec64a47cbb1/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
05-20-g0ec64a47cbb1/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/612ca6a9f775a571fd8e2=
c99
        failing since 285 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =20
