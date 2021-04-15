Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2068136169B
	for <lists+stable@lfdr.de>; Fri, 16 Apr 2021 01:56:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235418AbhDOX47 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Apr 2021 19:56:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234716AbhDOX47 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Apr 2021 19:56:59 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6C68C061574
        for <stable@vger.kernel.org>; Thu, 15 Apr 2021 16:56:35 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id h20so13010946plr.4
        for <stable@vger.kernel.org>; Thu, 15 Apr 2021 16:56:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=GEwmYKmz0TFjjmef6xzjSdXbez0E7z7FppLBNajYIs8=;
        b=Rf7HGk6XZ0yhn+xKGglTQVi4TBhwl+3Nkhqo2Mot9i1dfmYoBzIlDMUlQ03w2TMTtf
         pZOUO7uskSNT2D51S3eSdK2w+9cAa5H6YrRA/mEUBe2XHW/M7koQ84cjMrORZ0K9dqPR
         0AFn6IDONDIO+axTa5VRYiCBT9CH4NawObfYc+zYMLJRiMYbzVcpUHdno7Uif4oCyPEz
         hOS504sSib63nRMUPbbmcNQS5GSxIZcfFf5il+zWBz46s74VwAuZZhzEaAXirZjaAgxY
         tK5niCLh7mdv5POiq5JaVl/Anp/0G7uoZFmyMqz7fZC3Ap37mdR4gq1udLp24h4UxV0t
         s3FA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=GEwmYKmz0TFjjmef6xzjSdXbez0E7z7FppLBNajYIs8=;
        b=GFSbTgcJgU6ZiNfTGSqERENQ0An3mH6tVjakJjPVtDCKvHVyi3W4pYYcJ7PoWymKno
         wG1ozJ+0J8WL7P2ec18d9SPyueIFdaeG3/CtKt6dpIjYBG2Cxr+1y23I4ZAmPYKxKvoI
         4R1YPKZUztTbSYVR2W2Gl2zcBmx3ZJnHGkjI7k/9UVd32o0yMg1oeF4jj3VUCwevFFM1
         zQLhASqNiNIpqK/x4YQFBC4/3qiUu+8a85pZw6LwrT9F4qYyAWZkX10vx1+tU3ntRs9D
         iunHDpkTC+bLeJYmWsW2V2ySeUkQDYgPZRuulLV4meyz3fU+GSPMTJ/qd1euhj8+P5qi
         tnAA==
X-Gm-Message-State: AOAM5316euImlyeBAQ8+44mIIjyJU3Z6TQc0N/lVK7muDQJ6kVfs28fA
        Bbj2IymJdEP9aP6Zo9bTR9OxHzeCDdpMjpUJ
X-Google-Smtp-Source: ABdhPJybhshNbq5gL8LxoGluxL0KPRbj2eO+GVdJVn9MkIEPQ8a+yQ/yncVSnIJOncczdkJnLoUUHA==
X-Received: by 2002:a17:90a:df10:: with SMTP id gp16mr6450937pjb.209.1618530995254;
        Thu, 15 Apr 2021 16:56:35 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id g15sm2965554pfv.216.2021.04.15.16.56.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Apr 2021 16:56:34 -0700 (PDT)
Message-ID: <6078d2b2.1c69fb81.ade92.9479@mx.google.com>
Date:   Thu, 15 Apr 2021 16:56:34 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.4.112-19-g0d80f6c61d6ba
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-5.4.y baseline: 110 runs,
 4 regressions (v5.4.112-19-g0d80f6c61d6ba)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.4.y baseline: 110 runs, 4 regressions (v5.4.112-19-g0d80f=
6c61d6ba)

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.4.y/kern=
el/v5.4.112-19-g0d80f6c61d6ba/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.4.y
  Describe: v5.4.112-19-g0d80f6c61d6ba
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      0d80f6c61d6ba21b3cb64eae72b8485dd96b5a94 =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6078988bbc454e970edac6b5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.112=
-19-g0d80f6c61d6ba/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.112=
-19-g0d80f6c61d6ba/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6078988bbc454e970edac=
6b6
        failing since 152 days (last pass: v5.4.77-44-g28fe0e171c204, first=
 fail: v5.4.77-46-ga3e34830d912) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6078987357979f58f1dac6b1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.112=
-19-g0d80f6c61d6ba/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.112=
-19-g0d80f6c61d6ba/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6078987357979f58f1dac=
6b2
        failing since 152 days (last pass: v5.4.77-44-g28fe0e171c204, first=
 fail: v5.4.77-46-ga3e34830d912) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/607898b2b55227b6fddac6bf

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.112=
-19-g0d80f6c61d6ba/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.112=
-19-g0d80f6c61d6ba/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/607898b2b55227b6fddac=
6c0
        failing since 152 days (last pass: v5.4.77-44-g28fe0e171c204, first=
 fail: v5.4.77-46-ga3e34830d912) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6078981f3b9c5d1990dac6c2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.112=
-19-g0d80f6c61d6ba/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.112=
-19-g0d80f6c61d6ba/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6078981f3b9c5d1990dac=
6c3
        failing since 152 days (last pass: v5.4.77-44-g28fe0e171c204, first=
 fail: v5.4.77-46-ga3e34830d912) =

 =20
