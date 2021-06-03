Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D98039A679
	for <lists+stable@lfdr.de>; Thu,  3 Jun 2021 18:58:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229769AbhFCRAR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Jun 2021 13:00:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229719AbhFCRAR (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Jun 2021 13:00:17 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FC4EC06174A
        for <stable@vger.kernel.org>; Thu,  3 Jun 2021 09:58:21 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id f22so5397785pfn.0
        for <stable@vger.kernel.org>; Thu, 03 Jun 2021 09:58:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=OBJbjMndwQ4Ta9+gpAewy2QxhskK/KGKSesxDdl6N50=;
        b=D+ULeB8B+qr/FmRpR5HW4SuYemNRP4+RvkXnbJtcyI55NhzIwQSwAFcb0y7IgOI7su
         yO+nbZdbRUGivhcS/tYbn2fdpMHCQMoF+vj5kEEiK8sPe6Dgmb7/8zGJKvE67JQQ8GL+
         GeAD9//tdNHaaOQc6CFtficNODq85UaSrEa3LfiMGkdFjZs88pixyvKmMt6utVeZRSAo
         hlwtSImk9EURYtci9ZqQNB+XujsGh+3FlCWkMjx8d6hQ0CmNo/z8sUVDigF8R4kFNPMk
         JOmoJf3sB6K8JdfPFpJhx8Qf/O/1s4HTrPwgC/GhxPjjWNRjC9zxB3kZfgvzNmfhM9VG
         NVjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=OBJbjMndwQ4Ta9+gpAewy2QxhskK/KGKSesxDdl6N50=;
        b=UEHUligKyCF9m2zHliGtlDTIbS6BM1nKTvO7oAxW7XfTmaR+duyJ34aSvXtSW0dKyq
         jgC92DM5kM5xtDHjMplaAjEaVea4LQEIOowcyFpRQLfFk/aF+g3+wRjo2mziSGnR4432
         mtIn+r1Esv9h2DXTVCw5kP5FZ/V3v4gSLkZHKZBEE1Vs2acRQeqynMHTsassnm4CeDEE
         R+dCdGBKt4yZ18yblj0nF2sgHerLwprLcZg5VJEtpKK1YjZsBO5FtQTQb9J4J40thkgl
         /Uc86JBsC+V3O7hiVbM47GXYdzWMaAiUKNDy461jCkDwxfHWKJzg5vXKPPg4q7SgsL+1
         Kw8Q==
X-Gm-Message-State: AOAM531UWPpDdSHCgRp75tR8Wskhgz9gKPa/R6bGuuNLfd6wwhwHk/7O
        w173I1bUp/Kki1Ok0XZWa8DJ7p8qoE9L2w==
X-Google-Smtp-Source: ABdhPJyRQ9cLeC7RjL0/WUsu3sfwfFoavcq9FAtknb0v8cgOcJ1ZORyZWR/QT0XWYxrsNzWkvcVQKw==
X-Received: by 2002:a63:e205:: with SMTP id q5mr426710pgh.404.1622739500576;
        Thu, 03 Jun 2021 09:58:20 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id p7sm2792925pfb.45.2021.06.03.09.58.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Jun 2021 09:58:20 -0700 (PDT)
Message-ID: <60b90a2c.1c69fb81.9085d.8b75@mx.google.com>
Date:   Thu, 03 Jun 2021 09:58:20 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.12.8-295-g4101434d85a8
X-Kernelci-Branch: queue/5.12
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.12 baseline: 170 runs,
 2 regressions (v5.12.8-295-g4101434d85a8)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.12 baseline: 170 runs, 2 regressions (v5.12.8-295-g410143=
4d85a8)

Regressions Summary
-------------------

platform           | arch  | lab          | compiler | defconfig         | =
regressions
-------------------+-------+--------------+----------+-------------------+-=
-----------
bcm2837-rpi-3-b-32 | arm   | lab-baylibre | gcc-8    | bcm2835_defconfig | =
1          =

imx8mp-evk         | arm64 | lab-nxp      | gcc-8    | defconfig         | =
1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.12/ker=
nel/v5.12.8-295-g4101434d85a8/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.12
  Describe: v5.12.8-295-g4101434d85a8
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      4101434d85a8a9f11a1e3f2ce64f3ff119278194 =



Test Regressions
---------------- =



platform           | arch  | lab          | compiler | defconfig         | =
regressions
-------------------+-------+--------------+----------+-------------------+-=
-----------
bcm2837-rpi-3-b-32 | arm   | lab-baylibre | gcc-8    | bcm2835_defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/60b8d483c631a3d68cb3afb0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.8-2=
95-g4101434d85a8/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837-=
rpi-3-b-32.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.8-2=
95-g4101434d85a8/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837-=
rpi-3-b-32.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60b8d483c631a3d68cb3a=
fb1
        new failure (last pass: v5.12.7-303-g89387db068ad) =

 =



platform           | arch  | lab          | compiler | defconfig         | =
regressions
-------------------+-------+--------------+----------+-------------------+-=
-----------
imx8mp-evk         | arm64 | lab-nxp      | gcc-8    | defconfig         | =
1          =


  Details:     https://kernelci.org/test/plan/id/60b8d84fedba0e0359b3b00b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.8-2=
95-g4101434d85a8/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.8-2=
95-g4101434d85a8/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60b8d84fedba0e0359b3b=
00c
        failing since 2 days (last pass: v5.12.7-304-g7ade597cd7c1, first f=
ail: v5.12.7-303-g89387db068ad) =

 =20
