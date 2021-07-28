Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 571913D9833
	for <lists+stable@lfdr.de>; Thu, 29 Jul 2021 00:13:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232105AbhG1WNt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Jul 2021 18:13:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231989AbhG1WNs (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Jul 2021 18:13:48 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0A8AC061757
        for <stable@vger.kernel.org>; Wed, 28 Jul 2021 15:13:45 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id d1so4494912pll.1
        for <stable@vger.kernel.org>; Wed, 28 Jul 2021 15:13:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=DnxvSN5DBUbKwx540Dk/ryzmF0c16Qu73h0wtyDGXbE=;
        b=v9dYP3zmZixDptMtccl9kOd6g1AdHB6t02iPvxjp7vhlK2H6M77xnxEpI4yxZJbhx3
         ebsu2ns3CJpSI2gO03D/An0YRQPNQhCfBSVY405wdrddinltubXJKBNF78VEwO8tm3Is
         aJFxdB7Ag27vfZwIc5u1XcffpHlDb6nVJmOKo0d9x9niwWYsAaoepnjXSBLbURyBQhSp
         ppo4DEVIlqkhMxk5vnVA3j9nldRh3a9EdkvGjNSyoxdFU2g4RqG4iuyG/Wq6Qq+V+Do/
         BLhWPyMQyGpoE5IiUYzPYKmsL/YpLiY3txX1Oc+QViEI4tiKcEQ4QJ4/mjMUblQI+I8R
         5SRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=DnxvSN5DBUbKwx540Dk/ryzmF0c16Qu73h0wtyDGXbE=;
        b=rVZI5GWReu9vHuwGLdG2ZzL6zbfb8EH/YKEpClSYY38yLVZRPPWzA+oKFTQS5mrDr9
         38jwxX5NxVQQuL/k7FeYYHjkwIyd7LfUbvXJ3fWyGNL+x3Yz76cUdP3mKYcEPK37MmbZ
         TDjhdySpQoNPZoVXwPspdZE/JYDqLkbthSVssECinHhoX1rtsdR1sX+pYFQymGbG6f24
         pwAaR3t5SBG+1Z+x/WiqFuWRGYHIzRVsV/H3U93R0czw1oP7pQMsk5Stdq88XwqtCd2o
         04HByubpPea0kWaSRhb6kB9F7ddK371HORo60deACIcLd7Ezrfz1hqc2RBeTbePXBK6E
         /t1w==
X-Gm-Message-State: AOAM532a+SWvgWkXx/eVijtI5qWcJ6r+lWBiPJFc35291I7KHFH282AZ
        ftk1rEGoB99EcHP3vM/IKwCPTEbOreswTDeN
X-Google-Smtp-Source: ABdhPJxnQQ+l15vOEVWs9xozrXbKPVvRoKO0TSPsMoaQiZB7tvdiP8p06K8iSbnklvL4/tP3PNaCdg==
X-Received: by 2002:a17:90a:d816:: with SMTP id a22mr1906826pjv.180.1627510425305;
        Wed, 28 Jul 2021 15:13:45 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id w15sm718600pjc.45.2021.07.28.15.13.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jul 2021 15:13:44 -0700 (PDT)
Message-ID: <6101d698.1c69fb81.6245c.321b@mx.google.com>
Date:   Wed, 28 Jul 2021 15:13:44 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.9.277
Subject: stable-rc/linux-4.9.y baseline: 82 runs, 3 regressions (v4.9.277)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y baseline: 82 runs, 3 regressions (v4.9.277)

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.9.y/kern=
el/v4.9.277/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.9.y
  Describe: v4.9.277
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      edcc1d3a1c2e80a7fe254889877c0b073474fd5a =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/61019dcdc9a3afec7f5018f4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.277=
/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb.t=
xt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.277=
/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61019dcdc9a3afec7f501=
8f5
        failing since 256 days (last pass: v4.9.243-17-g9c24315b745a0, firs=
t fail: v4.9.243-26-g7b603f689c1c) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/61019dcc86f15db5885018c2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.277=
/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.277=
/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61019dcc86f15db588501=
8c3
        failing since 256 days (last pass: v4.9.243-17-g9c24315b745a0, firs=
t fail: v4.9.243-26-g7b603f689c1c) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/61019e36b3c3621785501906

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.277=
/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilepb.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.277=
/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilepb.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61019e36b3c3621785501=
907
        failing since 256 days (last pass: v4.9.243-17-g9c24315b745a0, firs=
t fail: v4.9.243-26-g7b603f689c1c) =

 =20
