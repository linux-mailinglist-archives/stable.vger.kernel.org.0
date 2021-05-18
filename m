Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDC4438705A
	for <lists+stable@lfdr.de>; Tue, 18 May 2021 05:48:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236460AbhERDte (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 23:49:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240661AbhERDt2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 May 2021 23:49:28 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FFF1C061763
        for <stable@vger.kernel.org>; Mon, 17 May 2021 20:47:57 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id gc22-20020a17090b3116b02901558435aec1so786288pjb.4
        for <stable@vger.kernel.org>; Mon, 17 May 2021 20:47:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=0Nx29gq74+GlrLdvLE6kaJ7uiCpWMRyzmSJryL5lMT8=;
        b=v0qNYUzoODicDNy5mMsMKo5qXqasWe8udmUdKunX5tEGiFrqjECY+bXci+3kbsJ35H
         L84rBMbXCCNEsRJv1dW5ABYynT5GSVSob5BKBXjIkJHodpmDogWfNY5pbw+d5rd6AY5z
         PdaeIC1k1N74YABgtvpPU6S7U6KRTJfNP8g0FKeWrLPYYvT7wrACp/kIJCf2iOCKbdIv
         6CagqwZWvxIzScDEcUxaXNnmbdrXVoMgmURSK0wmIwsajuBhpwE5nyJs77vu/pPDLoxf
         TBRAR97DIg/XpWYLQNyz9pY537Mtpj8G0w14DTVqFzxZziJ6AFs7lmijGuGPobEiUrFY
         QS0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=0Nx29gq74+GlrLdvLE6kaJ7uiCpWMRyzmSJryL5lMT8=;
        b=bIKjcduqrIyT+dcIcWtMPaPb/TaNygFFTWCh/+1EEUzuDQ7KVSMLvWtwTXziwQP9FK
         9gWAeX/cPmZKhvpDPHQiL1y3ogl4KNUG3M86DfwGfhL2nrfT2wVydxXORBhha3rzGmYW
         DF+86zU/4jKRJZOXDQNBdi87GKURsLIre5yR3t/ahA29K5CjkBZ8HkXoxaYWNIZpIW/6
         4rIaEjGNlsdTVS21HFurusxZW5C/alYC5LxMX+GXGJmQ5CfIkTiJ5MwrcQnO8LKpq4mU
         duTv92zCfYwyd4ET24Kq4ZRoFFKLnLt+2JdXtK1Ga4Na3JGe/9WnwSPqBrVf5f44PsOD
         /otg==
X-Gm-Message-State: AOAM530zL+w77SN8WRPLrGwzUmHBRLXWA3oM/yh6sVjp/ccTq4Z+IQB8
        3HPB87+aZVSHcQgL8L3+rU2qfa/Uhd21yEZm
X-Google-Smtp-Source: ABdhPJy8g9HbmHjQsuymDK51XOXtbGzviU28BNIRKdKzOl/4Qhu567WAu77j/7SRfz+ryXz/yNlyAg==
X-Received: by 2002:a17:90a:728f:: with SMTP id e15mr2728782pjg.137.1621309676306;
        Mon, 17 May 2021 20:47:56 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b7sm11503514pjq.36.2021.05.17.20.47.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 May 2021 20:47:55 -0700 (PDT)
Message-ID: <60a338eb.1c69fb81.a6b31.6b4f@mx.google.com>
Date:   Mon, 17 May 2021 20:47:55 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.9.268-224-g447e9f3db5ba
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-4.9.y baseline: 84 runs,
 4 regressions (v4.9.268-224-g447e9f3db5ba)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y baseline: 84 runs, 4 regressions (v4.9.268-224-g447e9=
f3db5ba)

Regressions Summary
-------------------

platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm   | lab-baylibre | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm   | lab-broonie  | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm   | lab-cip      | gcc-8    | versatile_defconfi=
g | 1          =

r8a7795-salvator-x   | arm64 | lab-baylibre | gcc-8    | defconfig         =
  | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.9.y/kern=
el/v4.9.268-224-g447e9f3db5ba/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.9.y
  Describe: v4.9.268-224-g447e9f3db5ba
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      447e9f3db5ba1753207fb9ad6586c102e9d6216b =



Test Regressions
---------------- =



platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm   | lab-baylibre | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60a304c2563e1a2cbab3afb2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.268=
-224-g447e9f3db5ba/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.268=
-224-g447e9f3db5ba/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60a304c2563e1a2cbab3a=
fb3
        failing since 184 days (last pass: v4.9.243-17-g9c24315b745a0, firs=
t fail: v4.9.243-26-g7b603f689c1c) =

 =



platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm   | lab-broonie  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60a304ccd53cb8171cb3af9e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.268=
-224-g447e9f3db5ba/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.268=
-224-g447e9f3db5ba/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60a304ccd53cb8171cb3a=
f9f
        failing since 184 days (last pass: v4.9.243-17-g9c24315b745a0, firs=
t fail: v4.9.243-26-g7b603f689c1c) =

 =



platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm   | lab-cip      | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60a304c8d53cb8171cb3af98

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.268=
-224-g447e9f3db5ba/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.268=
-224-g447e9f3db5ba/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60a304c8d53cb8171cb3a=
f99
        failing since 184 days (last pass: v4.9.243-17-g9c24315b745a0, firs=
t fail: v4.9.243-26-g7b603f689c1c) =

 =



platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
r8a7795-salvator-x   | arm64 | lab-baylibre | gcc-8    | defconfig         =
  | 1          =


  Details:     https://kernelci.org/test/plan/id/60a305ceb2b24d0cdfb3af9d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.268=
-224-g447e9f3db5ba/arm64/defconfig/gcc-8/lab-baylibre/baseline-r8a7795-salv=
ator-x.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.268=
-224-g447e9f3db5ba/arm64/defconfig/gcc-8/lab-baylibre/baseline-r8a7795-salv=
ator-x.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60a305ceb2b24d0cdfb3a=
f9e
        failing since 180 days (last pass: v4.9.243-17-g9c24315b745a0, firs=
t fail: v4.9.243-79-gd3e70b39d31a) =

 =20
