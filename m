Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C8893DC409
	for <lists+stable@lfdr.de>; Sat, 31 Jul 2021 08:36:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231887AbhGaGgS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 31 Jul 2021 02:36:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229683AbhGaGgS (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 31 Jul 2021 02:36:18 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6F26C06175F
        for <stable@vger.kernel.org>; Fri, 30 Jul 2021 23:36:12 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id q17-20020a17090a2e11b02901757deaf2c8so17699651pjd.0
        for <stable@vger.kernel.org>; Fri, 30 Jul 2021 23:36:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=el60X9Ojmej19CiuIQUfWGgZ8wA6WOyaO7qSs8UyM3o=;
        b=1ZJx8yyMQlfp73I2ZZJuOQk0lmp6N8Yt3f3afBsI5WRbPp4XzaucARAtz12c1a+Yve
         Z/tZ7or/hytnMfv3Oj/QsgRhCXsXdbCt3d9lywFCqRlV7nOmVSlCGLziYyVQtY5tBYyl
         k0Yn8Oq/k8vjU51+Zhvbd3Z5cN1uvahf4AgIaz5M/Pd3QUpnAm6FARLkZE4XHdbQSeS2
         f73sDKoa965AAA/FDthIrWbsoiJCXyE/6hzLcU0SR9oDhiUMOEbKSjw3SPyvgI1OalZw
         fRd0xNgVQZEm5tEB3+9T3qtgEUzmvuNEUonbqYj8jRmHhiewUncgTcDJ4JsDs2sh+dl7
         SZbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=el60X9Ojmej19CiuIQUfWGgZ8wA6WOyaO7qSs8UyM3o=;
        b=Zf7XPvNqpO94BvAsTm+m5v7Ja+nKsSapQNkM8QvqiMvoQ/pPFq2pkrQcH3DgKP2yyh
         2uvcHU+k6GK+nMB7whDHW1YlteWViXFE2nNbQXh7S4OwoQuNqIuwNg6g+Km5x6OwJxlO
         S7WTKx2XdEuBbzDGX6ll6RIm8KQ9ubr7ZmqZBOZw13o3u4U1L6b77C9XjsBb6kioR3hl
         dWjexeacZnXaCPn3U7CjYapqxLAzardFqLSCCbBOv69TE0PVFS/Xi7yDNm/i8qdIaeHc
         TpErCJsevU0VGFsYG/ODJj+b2SpZi6QZMJsErqAqGjmne+D/SMykaehkS1dOE3w4c1Gc
         Mb5g==
X-Gm-Message-State: AOAM532m//7jWggZG+xGddatonCimxUMnM4B6kj4enlF6mZZ4sNaloHd
        SxsrG43OpWEzoIhb+SYjurXLyZTWe2ptHyxl
X-Google-Smtp-Source: ABdhPJw7m1L5NRdcETCL5PXVNW3YaliB7OPh9IKnNIdECbj6lAAXLpWwlTr68BDzh5OwroJZJy7I+g==
X-Received: by 2002:a63:5c1b:: with SMTP id q27mr5537186pgb.284.1627713372011;
        Fri, 30 Jul 2021 23:36:12 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id d13sm4305955pfn.136.2021.07.30.23.36.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Jul 2021 23:36:11 -0700 (PDT)
Message-ID: <6104ef5b.1c69fb81.e39f7.ca63@mx.google.com>
Date:   Fri, 30 Jul 2021 23:36:11 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.19
X-Kernelci-Kernel: v4.19.199-3-g72fd65069bfc
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.19 baseline: 120 runs,
 3 regressions (v4.19.199-3-g72fd65069bfc)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 120 runs, 3 regressions (v4.19.199-3-g72fd65=
069bfc)

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.199-3-g72fd65069bfc/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.199-3-g72fd65069bfc
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      72fd65069bfc6f13130e7c1c778a5569732ca180 =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6104b7493a4a05411285f463

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.199=
-3-g72fd65069bfc/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.199=
-3-g72fd65069bfc/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6104b7493a4a05411285f=
464
        failing since 259 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6104b739664240971b85f45a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.199=
-3-g72fd65069bfc/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.199=
-3-g72fd65069bfc/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6104b739664240971b85f=
45b
        failing since 259 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6104c42df64ade7cff85f45a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.199=
-3-g72fd65069bfc/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.199=
-3-g72fd65069bfc/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6104c42df64ade7cff85f=
45b
        failing since 259 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =20
