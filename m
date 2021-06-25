Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 692AF3B4717
	for <lists+stable@lfdr.de>; Fri, 25 Jun 2021 17:58:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229864AbhFYQBD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Jun 2021 12:01:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229738AbhFYQBD (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Jun 2021 12:01:03 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74F39C061574
        for <stable@vger.kernel.org>; Fri, 25 Jun 2021 08:58:42 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id s137so751878pfc.4
        for <stable@vger.kernel.org>; Fri, 25 Jun 2021 08:58:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=6FwjGFvA346CtKtI5rXUyDWa7Qi3dk0sJ2I4aEGysWo=;
        b=Y98BfCQmczmRXZQcQ29xTSEcR5GK6POsUz3CUVxfIqcvibDoZWDPUDufmUlbO/ssMy
         zcLwtHRwxuBe7nsD98X5FfROpnOQVwBO6nszdU/ae2Onz/jHRHUZD6neYvKV9Lx/OO0K
         qXhdkuPcBz4jY8Jaqxe12sNeSSLqiqY4R6D/brLzn00JM6DOlvoduhPtxCDF5xV7Grw7
         QVE6NKUoD8NSi5/4RpATPHPohIBvJKD3acQEVb1/0t//mCKYAnMrbQ/g9FxG7TNDH7ge
         HPuqwhrVLfNSxffXHHhUbw9pcPQRclm/X17XTvWtZ064BagENr3CtsRMga5rlPE9eMPO
         bR6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=6FwjGFvA346CtKtI5rXUyDWa7Qi3dk0sJ2I4aEGysWo=;
        b=MwrDOWzdnslADDg/IGedg0wTYP5SqxS5Kv0+k7mEOgpr62cBMjGmg8pb5kPK7JJ891
         YVDyofZ2fez39jZWU0efHADQAYbLQX9YVq05j2jmrUcCmhJgCFpTvZui9NcnVxMdJUct
         PkSGLG+Xv900y6z2dh2yav/g8VHxvW2/hmrlkZ/fpWsgn1WznoQr48aZrw5XBCdOgSvm
         FmCiApvBB4dHS1NIv3nlt4j+K7aZS0jXgsgcRaMY2FygOBGBLmkNj+etizwNW9Ib9wzJ
         g+/a7w+cXQb7jSr6HEE4XLwTjxZRaYCCNy+HAE9TyyrXDTAbTMUI24RedryD9+x1pkft
         GqbA==
X-Gm-Message-State: AOAM530nDyWDH+g16vTfT0XfcbFvKQX8ib0h3qRdZw068CQ1qH33svVc
        2TACp59+1p2Mf8gSIsaMtYmUUh27wRqLVVzr
X-Google-Smtp-Source: ABdhPJytW78OlAHTxywWjX7jQsqeCBtsGzBBz+ItA20FPa4B3I6hLoJr9Qy+rUQO3w2Wfxt4fazfWA==
X-Received: by 2002:aa7:8254:0:b029:2ed:b41:fefc with SMTP id e20-20020aa782540000b02902ed0b41fefcmr11353467pfn.42.1624636721916;
        Fri, 25 Jun 2021 08:58:41 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id j3sm6356959pfe.98.2021.06.25.08.58.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Jun 2021 08:58:41 -0700 (PDT)
Message-ID: <60d5fd31.1c69fb81.a79eb.17cb@mx.google.com>
Date:   Fri, 25 Jun 2021 08:58:41 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.9.273-54-g05d095cc1282
X-Kernelci-Branch: queue/4.9
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.9 baseline: 110 runs,
 4 regressions (v4.9.273-54-g05d095cc1282)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 110 runs, 4 regressions (v4.9.273-54-g05d095c=
c1282)

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
el/v4.9.273-54-g05d095cc1282/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.273-54-g05d095cc1282
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      05d095cc12828d9a555a4ef69cd09c80d7cba39f =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60d5c7524c56ec74ef41328a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.273-5=
4-g05d095cc1282/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.273-5=
4-g05d095cc1282/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60d5c7524c56ec74ef413=
28b
        failing since 223 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60d5c802b50903762c413269

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.273-5=
4-g05d095cc1282/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.273-5=
4-g05d095cc1282/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60d5c802b50903762c413=
26a
        failing since 223 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60d5c7cad1b7b13a3641326a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.273-5=
4-g05d095cc1282/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.273-5=
4-g05d095cc1282/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60d5c7cad1b7b13a36413=
26b
        failing since 223 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60d5d6f362f6e5315e41328a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.273-5=
4-g05d095cc1282/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.273-5=
4-g05d095cc1282/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60d5d6f362f6e5315e413=
28b
        failing since 223 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =20
