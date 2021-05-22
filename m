Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B20FD38D702
	for <lists+stable@lfdr.de>; Sat, 22 May 2021 20:43:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231311AbhEVSpL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 May 2021 14:45:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231252AbhEVSpL (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 May 2021 14:45:11 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63381C061574
        for <stable@vger.kernel.org>; Sat, 22 May 2021 11:43:45 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id h12so455520plf.11
        for <stable@vger.kernel.org>; Sat, 22 May 2021 11:43:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=OpZru3z7+bTKSyP3I0IaSBS7LRGov+ascsKFhNREc5o=;
        b=kDSZK+7yfvOaPsImEbRXO/qU1Lt55w1nHFVolbWOO/DkB5VOTYsIee6AB1BdSd9jSV
         Ojk7DWO8ITK0BtcZru8012Xu47TcBr2zkM3MQlH7g0jOJ/bU4JbdvP8LXoVIuv1EnmlY
         MjMwisj6D9hQzpeg9eBYY/qdhgMF37odeREpsQZwrOncKb7D9rxYX7WSZFhc8WI6hyOj
         qi8rU2+I1uniyHgMcskNyNw7Au7T7MLhGTwTGWm1UqzYt1T+aHJFaumoVlrkes+q5c4l
         xwPoGAXnq6XIGT+dkwU3vwi8CtV5w34X6XKGSLdf4DW5ung/i4oTflfhzMjgBFbcN06f
         S+Fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=OpZru3z7+bTKSyP3I0IaSBS7LRGov+ascsKFhNREc5o=;
        b=gkhzaf8xk4uBpCi1tCWYxGMNGhEBMSqvyCbVyRliHygIxoYAul46L2YQiUb/pxTvER
         SHceaxfxrvJHWdFh0/3ae7cO75MSSY4JaOSbJg/7cHTykwbDW1lMaSOKBEqM9kwMpJ3k
         xkEe8lZNIYbNNxMnYs/pjScVAlLMx7gAxgDGkQUvmuW0/jMUuZdLXOvOoapTQf17vWM2
         k93XFmGHhkzaNwiPFsMqVlFuKemzIvB/ZMi0iysIpNdDU5rr/CXz8xU7CNQQXYUX0lx0
         5BnbP4cS4vhvWIX0fQtjNUuOVjWf9sBiBrQX6scC0dZ8xj6suGBorSQlhDZfxqX9N8a2
         6jGw==
X-Gm-Message-State: AOAM530YxROsz0ZzXdqgAzMdSFf38raSA3aaJB6Yc7P/XbP9AdMHfPQq
        HSEQ6LgM1odReAevuxYnlKRN4RKUX9K3TKXi
X-Google-Smtp-Source: ABdhPJxbGzx6SPGWL6p4DvAyOPp41EFXUqD5QbzsBYEH8Kxbt7y63/Ri2J1e/kvSOjgUUs5o6vbEEg==
X-Received: by 2002:a17:902:b7c3:b029:ef:8d29:a7d1 with SMTP id v3-20020a170902b7c3b02900ef8d29a7d1mr18156693plz.55.1621709024632;
        Sat, 22 May 2021 11:43:44 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id a7sm6929328pfo.211.2021.05.22.11.43.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 22 May 2021 11:43:44 -0700 (PDT)
Message-ID: <60a950e0.1c69fb81.f323e.77a9@mx.google.com>
Date:   Sat, 22 May 2021 11:43:44 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable
X-Kernelci-Kernel: v5.4.121
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Report-Type: test
Subject: stable/linux-5.4.y baseline: 137 runs, 5 regressions (v5.4.121)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.4.y baseline: 137 runs, 5 regressions (v5.4.121)

Regressions Summary
-------------------

platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
hifive-unleashed-a00 | riscv | lab-baylibre    | gcc-8    | defconfig      =
     | 1          =

qemu_arm-versatilepb | arm   | lab-broonie     | gcc-8    | versatile_defco=
nfig | 1          =

qemu_arm-versatilepb | arm   | lab-cip         | gcc-8    | versatile_defco=
nfig | 1          =

qemu_arm-versatilepb | arm   | lab-collabora   | gcc-8    | versatile_defco=
nfig | 1          =

qemu_arm-versatilepb | arm   | lab-linaro-lkft | gcc-8    | versatile_defco=
nfig | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.4.y/kernel/=
v5.4.121/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.4.y
  Describe: v5.4.121
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      b239a0365b9339ad5e276ed9cb4605963c2d939a =



Test Regressions
---------------- =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
hifive-unleashed-a00 | riscv | lab-baylibre    | gcc-8    | defconfig      =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/60a91cf9eab815eb40b3afa0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (riscv64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.121/ri=
scv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleashed-a00.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.121/ri=
scv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleashed-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/riscv/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60a91cf9eab815eb40b3a=
fa1
        failing since 184 days (last pass: v5.4.77, first fail: v5.4.78) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-broonie     | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/60a91c4252a5e73bc9b3afa8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.121/ar=
m/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.121/ar=
m/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60a91c4252a5e73bc9b3a=
fa9
        failing since 184 days (last pass: v5.4.77, first fail: v5.4.78) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-cip         | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/60a91c4752a5e73bc9b3afb6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.121/ar=
m/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.121/ar=
m/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60a91c4752a5e73bc9b3a=
fb7
        failing since 184 days (last pass: v5.4.77, first fail: v5.4.78) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-collabora   | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/60a91bf4f6f19f8debb3afa6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.121/ar=
m/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.121/ar=
m/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60a91bf4f6f19f8debb3a=
fa7
        failing since 184 days (last pass: v5.4.77, first fail: v5.4.78) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-linaro-lkft | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/60a91bdd1a96dc6f4cb3afa9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.121/ar=
m/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_arm-versatilepb.t=
xt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.121/ar=
m/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_arm-versatilepb.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60a91bdd1a96dc6f4cb3a=
faa
        failing since 184 days (last pass: v5.4.77, first fail: v5.4.78) =

 =20
