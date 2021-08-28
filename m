Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D74A3FA204
	for <lists+stable@lfdr.de>; Sat, 28 Aug 2021 02:04:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232503AbhH1AFV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Aug 2021 20:05:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232354AbhH1AFU (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 Aug 2021 20:05:20 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10F42C0613D9
        for <stable@vger.kernel.org>; Fri, 27 Aug 2021 17:04:31 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id j4-20020a17090a734400b0018f6dd1ec97so5931885pjs.3
        for <stable@vger.kernel.org>; Fri, 27 Aug 2021 17:04:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=32TeGIrB9/sRJTAswlz2hvaEg/b1DxpBlpHxQzutR2c=;
        b=YTvNq3lVuUt/lIJaaFyYUPHSb6ODMQ0LRayLvnpwNPcN4HFF6YtTOfPMHiB67bsDTG
         nmfFd96k42G14V6rGMv5pKlX3MFc9bm7nUcEt6Rm+39dyqjEbtpo4SkrUban0kaGy8fb
         VzKSpgxMgSitK9O1pRDqhd0FkPzgu2eqHauMZnKobMhdW+6CCjRupPtRlXLWeoqOUhGx
         dXAEVwwZ9YvxzmAclLMLHgZj2xnzVDQnHutwfmnhFg0htNM1qopSsDeU7dHQ9vj3OgMo
         Azxj1BKvYy7v69xAckTdVtS/TPLrZMqdH9d1k6oWimafRmvnyWJ63KbpbEWsx7NYIrE+
         sdGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=32TeGIrB9/sRJTAswlz2hvaEg/b1DxpBlpHxQzutR2c=;
        b=H78WcXaOatJ97En9ymjsMw+Pah7U8Sbd/bNzdHMHMeBV4I7K1t7DboJFR+8lsBSzlD
         uWlmGpF+IRVxzZv20um2l9tLQrFBZTyxxy2CTRFLBMF6YO4da5ZfvMLRfIqMz6MCY9q4
         EwVNz4LkD6mpSqyhQMtlRWj5He5Q2zYZelTu5lGArRgjMHZoEPbkwe/AfUsm/FBl5ko+
         Xbhi7hSzF5ls013iSDr1tPMXPdG0aZaeUs+7M9pDHmkLQPd4iE91JHkqGKrlbsFSCGpk
         6IjMSnvruGNWP8j53AA9gR7JNpclW8mLUvL7fRa9a4zIUD+XRpxc8bT6xEiaGKEL6xPM
         URDg==
X-Gm-Message-State: AOAM531INTrPow6CXZ3riD6mRstm0NO9CbQlW1irZhU6Nas5EuLGoZ+t
        vCqszPSAheEEEyb6GbuB+5lX5WpDB9JbTIdG
X-Google-Smtp-Source: ABdhPJz1hoGGabFht0gO3RkDj1W94OJzcHbDztkJQHjhud9vNcRzXpX3ss3bdJEBF2Sifj4FeUelGQ==
X-Received: by 2002:a17:90a:6503:: with SMTP id i3mr2843722pjj.22.1630109070456;
        Fri, 27 Aug 2021 17:04:30 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id g7sm3105814pfj.70.2021.08.27.17.04.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Aug 2021 17:04:30 -0700 (PDT)
Message-ID: <61297d8e.1c69fb81.3f00e.873a@mx.google.com>
Date:   Fri, 27 Aug 2021 17:04:30 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.13
X-Kernelci-Kernel: v5.13.13-13-gc528c5e23aa0
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.13 baseline: 160 runs,
 4 regressions (v5.13.13-13-gc528c5e23aa0)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.13 baseline: 160 runs, 4 regressions (v5.13.13-13-gc528c5=
e23aa0)

Regressions Summary
-------------------

platform                | arch  | lab          | compiler | defconfig      =
     | regressions
------------------------+-------+--------------+----------+----------------=
-----+------------
beagle-xm               | arm   | lab-baylibre | gcc-8    | multi_v7_defcon=
fig  | 1          =

beagle-xm               | arm   | lab-baylibre | gcc-8    | omap2plus_defco=
nfig | 1          =

imx8mp-evk              | arm64 | lab-nxp      | gcc-8    | defconfig      =
     | 1          =

sun50i-a64-bananapi-m64 | arm64 | lab-clabbe   | gcc-8    | defconfig      =
     | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.13/ker=
nel/v5.13.13-13-gc528c5e23aa0/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.13
  Describe: v5.13.13-13-gc528c5e23aa0
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      c528c5e23aa0cd825c3f898ec589fb8b38d54ca6 =



Test Regressions
---------------- =



platform                | arch  | lab          | compiler | defconfig      =
     | regressions
------------------------+-------+--------------+----------+----------------=
-----+------------
beagle-xm               | arm   | lab-baylibre | gcc-8    | multi_v7_defcon=
fig  | 1          =


  Details:     https://kernelci.org/test/plan/id/61294e7aa3f404bb4c8e2c7a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.13-=
13-gc528c5e23aa0/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-beagle-=
xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.13-=
13-gc528c5e23aa0/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-beagle-=
xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61294e7aa3f404bb4c8e2=
c7b
        failing since 1 day (last pass: v5.13.12-126-g61c83bccf008, first f=
ail: v5.13.12-125-gf6c5dda713c6) =

 =



platform                | arch  | lab          | compiler | defconfig      =
     | regressions
------------------------+-------+--------------+----------+----------------=
-----+------------
beagle-xm               | arm   | lab-baylibre | gcc-8    | omap2plus_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/61294d120974a4e2b38e2ca4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.13-=
13-gc528c5e23aa0/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle=
-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.13-=
13-gc528c5e23aa0/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle=
-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61294d120974a4e2b38e2=
ca5
        failing since 30 days (last pass: v5.13.5-224-g078d5e3a85db, first =
fail: v5.13.5-223-g3a7649e5ffb5) =

 =



platform                | arch  | lab          | compiler | defconfig      =
     | regressions
------------------------+-------+--------------+----------+----------------=
-----+------------
imx8mp-evk              | arm64 | lab-nxp      | gcc-8    | defconfig      =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/6129552745665cfbfb8e2c92

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.13-=
13-gc528c5e23aa0/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.13-=
13-gc528c5e23aa0/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6129552745665cfbfb8e2=
c93
        new failure (last pass: v5.13.13-2-g4db03cfb5850) =

 =



platform                | arch  | lab          | compiler | defconfig      =
     | regressions
------------------------+-------+--------------+----------+----------------=
-----+------------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe   | gcc-8    | defconfig      =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/61294c1068b47c95218e2d63

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.13-=
13-gc528c5e23aa0/arm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-banan=
api-m64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.13-=
13-gc528c5e23aa0/arm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-banan=
api-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61294c1168b47c95218e2=
d64
        new failure (last pass: v5.13.13-2-g4db03cfb5850) =

 =20
