Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54C393638C4
	for <lists+stable@lfdr.de>; Mon, 19 Apr 2021 02:21:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232530AbhDSAWC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Apr 2021 20:22:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231489AbhDSAWC (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 18 Apr 2021 20:22:02 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E8A5C06174A
        for <stable@vger.kernel.org>; Sun, 18 Apr 2021 17:21:33 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id s14so12064074pjl.5
        for <stable@vger.kernel.org>; Sun, 18 Apr 2021 17:21:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=dFcGsJWG3+hrkIT6c911rkJFvhJ7nEum2S0CB8fflnQ=;
        b=QljSAnrvJkbmNqUDvOMmDW1hYtOi8W70Z54H2snwZNOqvsgn7jsqrql3MRKbevGdOd
         YDQirtlGfhx/PRAUs2vB/WkuXAZi5YMxTljgcNEBCXLOcOmOww6eAYMQxQ48pNi+t5kK
         sZjNWePyM7Wt2ea/2XrD9O/5ExCUhkHfbVNaND5nAu+Y9KucLxx3OxFJyRyxSFsMiDt5
         4n0Krk7v6+jr208mwTw8xXy4y0SnAZ1zFL05dOaDtd/H2Qzi1QKthZDcplpXG1E9Klj/
         JVVKEpque+3ny8zaMKQnNlJ4yyD7Yp+CbRac5HnnSQ4jebgwI4bqiFMGT9xfttSowcB0
         tEsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=dFcGsJWG3+hrkIT6c911rkJFvhJ7nEum2S0CB8fflnQ=;
        b=IHIGUs7+tZPWEjclUm+DqzFDMEdofVY8GtUFKrPz2d3UqNe9THG19KRud0ot1vB1FC
         8xZ9Dpc39ITqvbwl4dGfOH6bUFZvLrPRn4Ohfc8Bd78FWzN/hGPtrduR2/zQxyfuW7T9
         MKSAmw/k54Js16NVTVYRGOJBQWZ3KqDI0E/Z7mAqHcNHzjSRvCRMTzCmxb+nmpLWX5PH
         wVPCTHneuk4kdmUd9YNcB+vskA4Xn1SKCLz9qZ8hVDC4XgQoTOGFX5de1bsp320z1jjD
         XYYKxhPs4Wwi92NjZGHH1dTtu4CJqPgWdymlEJJ8mLIC4LLugz7CGfEmfrM86vG2z4wD
         IWJg==
X-Gm-Message-State: AOAM531JqNY+ypHl6sxkp6Oy+qX07GRP/oKviUXieY46KqOuJKqHRY4F
        EEt8NTQQIcBcDIa7k7BDg80YfASdiQIgaROs
X-Google-Smtp-Source: ABdhPJxCXUcCRjsiOU+HUuGJ4xGTHKLQ4mkQM9kLzfK3zTxuMFD2nFwizcclGJrp9Vdl0w48UDxDNg==
X-Received: by 2002:a17:902:264:b029:eb:3d3a:a09c with SMTP id 91-20020a1709020264b02900eb3d3aa09cmr20498538plc.0.1618791692647;
        Sun, 18 Apr 2021 17:21:32 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id q13sm11145623pgp.37.2021.04.18.17.21.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 Apr 2021 17:21:32 -0700 (PDT)
Message-ID: <607ccd0c.1c69fb81.b500b.d285@mx.google.com>
Date:   Sun, 18 Apr 2021 17:21:32 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.9.267-23-geba0ee52d3b15
X-Kernelci-Branch: queue/4.9
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.9 baseline: 98 runs,
 5 regressions (v4.9.267-23-geba0ee52d3b15)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 98 runs, 5 regressions (v4.9.267-23-geba0ee52=
d3b15)

Regressions Summary
-------------------

platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
panda                | arm  | lab-collabora | gcc-8    | omap2plus_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.267-23-geba0ee52d3b15/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.267-23-geba0ee52d3b15
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      eba0ee52d3b151d556367d79bd4fefbe263dabc6 =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
panda                | arm  | lab-collabora | gcc-8    | omap2plus_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/607c9ab32b71059dd9dac6c2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.267-2=
3-geba0ee52d3b15/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.267-2=
3-geba0ee52d3b15/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/607c9ab32b71059dd9dac=
6c3
        new failure (last pass: v4.9.267-17-ge0b4ecae19839) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/607c9517cc375690eedac6b7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.267-2=
3-geba0ee52d3b15/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.267-2=
3-geba0ee52d3b15/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/607c9517cc375690eedac=
6b8
        failing since 155 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/607c9508d09e5d0c37dac6d6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.267-2=
3-geba0ee52d3b15/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.267-2=
3-geba0ee52d3b15/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/607c9508d09e5d0c37dac=
6d7
        failing since 155 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/607c9518b9228d474adac6b4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.267-2=
3-geba0ee52d3b15/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.267-2=
3-geba0ee52d3b15/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/607c9518b9228d474adac=
6b5
        failing since 155 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/607c94bf7c1c6652c0dac6b3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.267-2=
3-geba0ee52d3b15/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.267-2=
3-geba0ee52d3b15/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/607c94bf7c1c6652c0dac=
6b4
        failing since 155 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =20
