Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7767136DD75
	for <lists+stable@lfdr.de>; Wed, 28 Apr 2021 18:49:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241162AbhD1Qub (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Apr 2021 12:50:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241146AbhD1Qu3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Apr 2021 12:50:29 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF1B1C061573
        for <stable@vger.kernel.org>; Wed, 28 Apr 2021 09:49:42 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id v191so2353004pfc.8
        for <stable@vger.kernel.org>; Wed, 28 Apr 2021 09:49:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=cA4liFRkFCtU1rbCc/628MVxDUbybHKIltf4wn8ohZc=;
        b=tMcjjlk/xgagEmTTZJYZ2nA/b76QjDejI9Oi3XUGtL686WkDZCywRHCTTcBHluWiMX
         QluPcqoPkUydDqbBc8K6ucLwcPNen0OptKKS+vOO9qizV1dHBaf7vnZH7a4rZIjyoebo
         w4fhHY5iKe6mYxt7E6soJJFENumaDO4QBby1cgp88PUS2H1+DNS+5MgLkt/eQwbuSYDy
         +GzmXpEZphA62ZDOiVq3oTihWPUBFjVDos3HcoGuWAQeshPZNGRu2bMRtla8Qj3MnX+S
         cQQU007obw9zDBuUN6iRwuc0lrPIOc2hW5vP/lq0oDoP/QwZC11SV5XKALx68B46ShJM
         4KAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=cA4liFRkFCtU1rbCc/628MVxDUbybHKIltf4wn8ohZc=;
        b=mWlkd8pp7WiJKNwHk0WgeoHAFoYrmOHN2NREwdUwP9+Nl/nMJcrZeKez6s+vQp8zF7
         nZhAE70lBZQykPWxd63NZEDPzZmScX0xhuYn0lkjsRkmvztSRUiyv/EZ/wTczsTep3GW
         f4mMR4GN74abiEDUA8/bFLmQhGiwY2OZdebrugJ8IoGl7hqQrYlNf0YuRPpDZW7luPEI
         m9QFvK4jjsULxJwTRvjSFAxBpati+N2eTDKkkktz3w9vwNJQmc0fLMPaEl7ucP+kdBo/
         hfwM5yZWPZxoC+8HcQfhxG+L+rGd2FH8hFnTldHXqpahhoVHhE33+yquC5yMWz+uATzY
         ezBQ==
X-Gm-Message-State: AOAM532Ni2k/Ui2v0ENIWSbbyovr8gtw5gBz8srt9FJxmVhMfQEXmlqe
        K78SaL55pmHRGquJ5AUK8wtG9/z1AE1oeSmt
X-Google-Smtp-Source: ABdhPJxNmu2zcvpcWOgGYS39sHPjAB0JOfu6sz0bgLzApV34uU+3GgbbhY6AXr0O2ob7PSpAphYzdw==
X-Received: by 2002:aa7:8389:0:b029:209:da1c:17b5 with SMTP id u9-20020aa783890000b0290209da1c17b5mr28957976pfm.29.1619628581445;
        Wed, 28 Apr 2021 09:49:41 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id a20sm219789pfi.138.2021.04.28.09.49.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Apr 2021 09:49:41 -0700 (PDT)
Message-ID: <60899225.1c69fb81.f10b7.0cc3@mx.google.com>
Date:   Wed, 28 Apr 2021 09:49:41 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.4.115
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-5.4.y
Subject: stable/linux-5.4.y baseline: 125 runs, 3 regressions (v5.4.115)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.4.y baseline: 125 runs, 3 regressions (v5.4.115)

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


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.4.y/kernel/=
v5.4.115/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.4.y
  Describe: v5.4.115
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      19bfeb47e96bb342d8c43a8ba0e68baf053b0dfc =



Test Regressions
---------------- =



platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-baylibre | gcc-8    | versatile_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/60895e58bc3af930f29b7799

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.115/ar=
m/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.115/ar=
m/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60895e58bc3af930f29b7=
79a
        failing since 160 days (last pass: v5.4.77, first fail: v5.4.78) =

 =



platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-broonie  | gcc-8    | versatile_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/60895e66bc3af930f29b77b6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.115/ar=
m/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.115/ar=
m/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60895e66bc3af930f29b7=
7b7
        failing since 160 days (last pass: v5.4.77, first fail: v5.4.78) =

 =



platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-cip      | gcc-8    | versatile_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/60895e7dbc3e99486b9b77a2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.115/ar=
m/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.115/ar=
m/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60895e7dbc3e99486b9b7=
7a3
        failing since 160 days (last pass: v5.4.77, first fail: v5.4.78) =

 =20
