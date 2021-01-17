Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 221DC2F9530
	for <lists+stable@lfdr.de>; Sun, 17 Jan 2021 21:41:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730279AbhAQUli (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 17 Jan 2021 15:41:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730282AbhAQUl0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 17 Jan 2021 15:41:26 -0500
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9935AC061574
        for <stable@vger.kernel.org>; Sun, 17 Jan 2021 12:40:39 -0800 (PST)
Received: by mail-pg1-x529.google.com with SMTP id p18so9636323pgm.11
        for <stable@vger.kernel.org>; Sun, 17 Jan 2021 12:40:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=WKxzIzc8bktYrUFuzJNFMghyBIfxyuNtY8WMK/XAj04=;
        b=f71uggIsEoGYnHEaWCkACdIsN2GRljPi6aDOG0PeQelsEVkfU/wdbij7azO0mhxgS3
         fEWHkqRoDlYskMLSEmn/DMGBPa4Un6XhHXhv6saB+Hf4Rv3StRxsEeskyWRjaU9wOe+X
         +zoAk6qyJQkcMColgYobdJbKEQi/BYLhn/7fZAryUtBo1M76PkMuV4MH5eKp+CYCzMBR
         gGQVV8Vz3nwvBBpUykam/Ziv/Giw7lauuL1iHisjoBsmUuW1KoJzZoWutzg1Amt/9tP7
         vtqkUEdA3rsT+p/8TKKpwPx2xUJM+83mAOngb/um0GBeYN6IVIBUz+UCcX1LQMa1Ow6c
         pqGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=WKxzIzc8bktYrUFuzJNFMghyBIfxyuNtY8WMK/XAj04=;
        b=mKPtmJDbQCwatUyOGmFBq/v9AFuXM4mqA+Ez809CQm4M0EPEV1VsT/PlxBm/WQceg+
         m1xWA8tcg01hKt4FT/VORCqSSFjmsZfs+TiFr9ybG8jP1/FgjV8hv/XNjEY57LVATmAc
         Z4k/O3wcM5o77HVRau8fabDKUqn0AMuxSO4sBaGkiO0/qP/yLvT96h0cIf0kssxp6vQJ
         l/NrgZIkaxj5FAxEICyLK62jdcIOW8vCiyN9ZDM97+Eh4qmSwUIgwsGma3/foR17JO50
         uN+pEgh9fwlbC5o+nptLr2/k3Defz2TTOu9Yp7cQh0eZ/5MMSsZ9dkprsNS2QUqgv7cT
         uQSA==
X-Gm-Message-State: AOAM531sYgz5vBzfSColbNXp/1Az7th9lcL1ZnBVwj7FmC+o8rjo/Mdg
        NvSkkPkHYMms2YPoOz/c1PFe8Mm/BAjdCw==
X-Google-Smtp-Source: ABdhPJwlxf8KStcp0m7GW78u/ZlvnohtUJ16FNrbPveYywivT04VqCrTbYH+slp7IK8wZZZzwqD8Rg==
X-Received: by 2002:a63:e151:: with SMTP id h17mr22879558pgk.120.1610916038764;
        Sun, 17 Jan 2021 12:40:38 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id x27sm14458012pfr.122.2021.01.17.12.40.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 Jan 2021 12:40:37 -0800 (PST)
Message-ID: <6004a0c5.1c69fb81.14fa3.41e1@mx.google.com>
Date:   Sun, 17 Jan 2021 12:40:37 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.9
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.9.251-33-gc2c58b54e9ac3
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.9 baseline: 131 runs,
 7 regressions (v4.9.251-33-gc2c58b54e9ac3)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 131 runs, 7 regressions (v4.9.251-33-gc2c58b5=
4e9ac3)

Regressions Summary
-------------------

platform             | arch   | lab             | compiler | defconfig     =
      | regressions
---------------------+--------+-----------------+----------+---------------=
------+------------
qemu_arm-versatilepb | arm    | lab-baylibre    | gcc-8    | versatile_defc=
onfig | 1          =

qemu_arm-versatilepb | arm    | lab-broonie     | gcc-8    | versatile_defc=
onfig | 1          =

qemu_arm-versatilepb | arm    | lab-cip         | gcc-8    | versatile_defc=
onfig | 1          =

qemu_arm-versatilepb | arm    | lab-collabora   | gcc-8    | versatile_defc=
onfig | 1          =

qemu_arm-versatilepb | arm    | lab-linaro-lkft | gcc-8    | versatile_defc=
onfig | 1          =

qemu_i386            | i386   | lab-broonie     | gcc-8    | i386_defconfig=
      | 1          =

qemu_x86_64-uefi     | x86_64 | lab-broonie     | gcc-8    | x86_64_defconf=
ig    | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.251-33-gc2c58b54e9ac3/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.251-33-gc2c58b54e9ac3
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      c2c58b54e9ac306e359671a8309d8dfb6c8f25f4 =



Test Regressions
---------------- =



platform             | arch   | lab             | compiler | defconfig     =
      | regressions
---------------------+--------+-----------------+----------+---------------=
------+------------
qemu_arm-versatilepb | arm    | lab-baylibre    | gcc-8    | versatile_defc=
onfig | 1          =


  Details:     https://kernelci.org/test/plan/id/60046d01edc8d5bbcfc94cb9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.251-3=
3-gc2c58b54e9ac3/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.251-3=
3-gc2c58b54e9ac3/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60046d01edc8d5bbcfc94=
cba
        failing since 64 days (last pass: v4.9.243-16-gd8d67e375b0a, first =
fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch   | lab             | compiler | defconfig     =
      | regressions
---------------------+--------+-----------------+----------+---------------=
------+------------
qemu_arm-versatilepb | arm    | lab-broonie     | gcc-8    | versatile_defc=
onfig | 1          =


  Details:     https://kernelci.org/test/plan/id/6004700618548d6491c94cc3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.251-3=
3-gc2c58b54e9ac3/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.251-3=
3-gc2c58b54e9ac3/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6004700618548d6491c94=
cc4
        failing since 64 days (last pass: v4.9.243-16-gd8d67e375b0a, first =
fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch   | lab             | compiler | defconfig     =
      | regressions
---------------------+--------+-----------------+----------+---------------=
------+------------
qemu_arm-versatilepb | arm    | lab-cip         | gcc-8    | versatile_defc=
onfig | 1          =


  Details:     https://kernelci.org/test/plan/id/60046c9917bdd56212c94cbd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.251-3=
3-gc2c58b54e9ac3/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.251-3=
3-gc2c58b54e9ac3/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60046c9917bdd56212c94=
cbe
        failing since 64 days (last pass: v4.9.243-16-gd8d67e375b0a, first =
fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch   | lab             | compiler | defconfig     =
      | regressions
---------------------+--------+-----------------+----------+---------------=
------+------------
qemu_arm-versatilepb | arm    | lab-collabora   | gcc-8    | versatile_defc=
onfig | 1          =


  Details:     https://kernelci.org/test/plan/id/60046cadc4343e1ae5c94cc0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.251-3=
3-gc2c58b54e9ac3/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.251-3=
3-gc2c58b54e9ac3/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60046cadc4343e1ae5c94=
cc1
        failing since 64 days (last pass: v4.9.243-16-gd8d67e375b0a, first =
fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch   | lab             | compiler | defconfig     =
      | regressions
---------------------+--------+-----------------+----------+---------------=
------+------------
qemu_arm-versatilepb | arm    | lab-linaro-lkft | gcc-8    | versatile_defc=
onfig | 1          =


  Details:     https://kernelci.org/test/plan/id/60046c54a22ca1fab4c94cf8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.251-3=
3-gc2c58b54e9ac3/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.251-3=
3-gc2c58b54e9ac3/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60046c54a22ca1fab4c94=
cf9
        failing since 64 days (last pass: v4.9.243-16-gd8d67e375b0a, first =
fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch   | lab             | compiler | defconfig     =
      | regressions
---------------------+--------+-----------------+----------+---------------=
------+------------
qemu_i386            | i386   | lab-broonie     | gcc-8    | i386_defconfig=
      | 1          =


  Details:     https://kernelci.org/test/plan/id/60046f1fb3449146e8c94ce2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.251-3=
3-gc2c58b54e9ac3/i386/i386_defconfig/gcc-8/lab-broonie/baseline-qemu_i386.t=
xt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.251-3=
3-gc2c58b54e9ac3/i386/i386_defconfig/gcc-8/lab-broonie/baseline-qemu_i386.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60046f1fb3449146e8c94=
ce3
        new failure (last pass: v4.9.251-32-g805ede0da892) =

 =



platform             | arch   | lab             | compiler | defconfig     =
      | regressions
---------------------+--------+-----------------+----------+---------------=
------+------------
qemu_x86_64-uefi     | x86_64 | lab-broonie     | gcc-8    | x86_64_defconf=
ig    | 1          =


  Details:     https://kernelci.org/test/plan/id/60046f80bbef1decb1c94cba

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.251-3=
3-gc2c58b54e9ac3/x86_64/x86_64_defconfig/gcc-8/lab-broonie/baseline-qemu_x8=
6_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.251-3=
3-gc2c58b54e9ac3/x86_64/x86_64_defconfig/gcc-8/lab-broonie/baseline-qemu_x8=
6_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60046f80bbef1decb1c94=
cbb
        new failure (last pass: v4.9.251-32-g805ede0da892) =

 =20
