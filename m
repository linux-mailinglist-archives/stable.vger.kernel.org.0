Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F0033613B1
	for <lists+stable@lfdr.de>; Thu, 15 Apr 2021 22:50:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234899AbhDOUvR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Apr 2021 16:51:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234668AbhDOUvR (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Apr 2021 16:51:17 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 954B4C061574
        for <stable@vger.kernel.org>; Thu, 15 Apr 2021 13:50:52 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id d124so16847436pfa.13
        for <stable@vger.kernel.org>; Thu, 15 Apr 2021 13:50:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=6zdS/hb2gSmKOhD+N2Aq7EB7q/cFAUrLjz36FYK2k/k=;
        b=ApSF/PHfd9Pxn5OjRwVxum/qNr+m8h2RpwLCdNqeQjvHAxrBJaba214UB8NLWralBs
         cmiBr4q8HYzneETsENDPmREQijJ1rEDF0GXECnbdOo5qioKXGzCGxjv+ROxORFVbE6hO
         X4H+vuHIUB2GbB7srE3NJJdcNdk3XYo26hOzVFOTqNv4wk7rK9iWIIx417eK3NJgyfdT
         Tv40fQSelqR5tXPayCtgUyL7EJuGqkeIYW/hB8onpXaFmUzniYZ5qLVp/9Z5V8vpNgzZ
         bl1gLqhCNlqdppVVQtknyAiIBbJ/QjS3OemWOEeJCPiaIiIKqBuIdVQNaDdXuI70jiK5
         uctw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=6zdS/hb2gSmKOhD+N2Aq7EB7q/cFAUrLjz36FYK2k/k=;
        b=hLCEUQ6dcn1JVNiesaxEGPZvT2PPLIUPPg9sLFDgvB9zWg+l+3+lRmUvyT2YTjqYML
         PtmsbOZ3tl6zLtvwd8u16GsYJQoYW2RFmKmDW+AAIWT/VgvxsMCWbJpoezCUdo1J5/Yp
         /+1IcEwa0iAMpkDSuqQh9dnKQYYih8Xq+FJzeFU1vrlMVIW1rGGdIMuXtM61BaCvlQSu
         RhZ1NqnHvDvYrwM2ny6M6SGQb8R2Sg73hACC5AAcF8hoBHYK8+qELUcwD2vmKvd3MALc
         uIrlDXIhTSIRJ3FNoYUm2jC6WA7xs9qX8ijJ06QvAf9eguDvfKE49wLiyKPNSSfNUUMh
         uqYQ==
X-Gm-Message-State: AOAM530+KT9L79G0sMZlJag7ZytERvf8AKmWFpt1QIjxgGji0rtpeZAf
        ae/gTGcRzJeXS9hwRzBUpPeh8vOzCB2Y3xIB
X-Google-Smtp-Source: ABdhPJx9CwsVLQe/IpnWuBExCvswPMZo/diZwEHYO1qcVZ+LeporMjthc/JsM2zUvMG1uUro+Qb/OA==
X-Received: by 2002:a62:e90c:0:b029:203:90f:6f34 with SMTP id j12-20020a62e90c0000b0290203090f6f34mr5044063pfh.29.1618519851900;
        Thu, 15 Apr 2021 13:50:51 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id e1sm3099749pgl.25.2021.04.15.13.50.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Apr 2021 13:50:51 -0700 (PDT)
Message-ID: <6078a72b.1c69fb81.47e81.95a7@mx.google.com>
Date:   Thu, 15 Apr 2021 13:50:51 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.19.187-13-g4babd110760d2
X-Kernelci-Branch: queue/4.19
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.19 baseline: 134 runs,
 4 regressions (v4.19.187-13-g4babd110760d2)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 134 runs, 4 regressions (v4.19.187-13-g4babd=
110760d2)

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.187-13-g4babd110760d2/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.187-13-g4babd110760d2
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      4babd110760d264e78d43194624dd3d0280b5ede =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/607872625c503df905dac6b8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.187=
-13-g4babd110760d2/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.187=
-13-g4babd110760d2/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/607872625c503df905dac=
6b9
        failing since 152 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6078726fcec4a52e10dac6bd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.187=
-13-g4babd110760d2/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.187=
-13-g4babd110760d2/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6078726fcec4a52e10dac=
6be
        failing since 152 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60787271bc5a0cbf7adac6b9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.187=
-13-g4babd110760d2/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.187=
-13-g4babd110760d2/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60787271bc5a0cbf7adac=
6ba
        failing since 152 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/607871fe3ed6db7f44dac6c1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.187=
-13-g4babd110760d2/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.187=
-13-g4babd110760d2/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/607871fe3ed6db7f44dac=
6c2
        failing since 152 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =20
