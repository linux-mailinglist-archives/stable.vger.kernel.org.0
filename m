Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC4FD416183
	for <lists+stable@lfdr.de>; Thu, 23 Sep 2021 16:56:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241734AbhIWO5v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Sep 2021 10:57:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241735AbhIWO5s (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Sep 2021 10:57:48 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B119C061574
        for <stable@vger.kernel.org>; Thu, 23 Sep 2021 07:56:17 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id q68so6578469pga.9
        for <stable@vger.kernel.org>; Thu, 23 Sep 2021 07:56:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=QCAkSB556tNRQiUJ9EaSNNaNvpJbveeKxPR5lduG7mU=;
        b=zUImpJADzc/kVLsSDzs54fJgxCfeKN8HoGa8jOGYar1nBN28DPvSMfvu7Lbtb5ttDI
         ca44+YHjipPbh9pl4X86jjfSEnP2FSXk3WHK2F6o3RSj1gx36c5kC2tqMkiC+R+kfRAs
         vX7cuPzbaRZOnJzBjFsqPYXxPb7D+LrWInpDJy6v/oKSmS9sWXJ/fRulY/cCTUC2zPco
         onT6pyPi2l0i1BzvJiYA2UXMK/bBhVdsaA+BMGoPjXwgjSrSRVHCbv5V7KicmcHtVEOX
         ZvSdcsRT28vRRVbZSHJv6FtK0uK/VD4g7gmrjTj8wRLIUFDMiwhYuF2ndPQTNW8yKXTh
         Okrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=QCAkSB556tNRQiUJ9EaSNNaNvpJbveeKxPR5lduG7mU=;
        b=JJe79ZuGD3V/dISXkk0M3mAiz1+MkN9OQDRdmjGrgrwVNyk3HUI28V633g3yTYS/pn
         amxaqg3/RMMYKbxmiRMYUl4HblgS2Z+z99rq2jGS3Vvj4i2Sskxa6uSpQneHauIl8pa0
         hXWZaTQQv3aSTCfkmxRaLG7Izc5ZbiNpu2/QD1S6SG7x3RgGK1SbUcLmkviVZx4woUtS
         pMBchzLoKiXGCJ1RvzTREPv57UjFHed8gqD4PBdTCiQF8T8JM1y47qWmfKHdQwK8//tl
         pm4ri2ElHlRg3+eqkf6hpgmd7fWykTJTHC//q+/2qEd24u5k2ktVwiN5E2GSXy3/734T
         SY2A==
X-Gm-Message-State: AOAM530UxoBo9XNzkY6GTICP0HN+is9oaGDgZHdLi+N0YuGIwuckODxQ
        0cir9aa3Ngu9r3TGSrwfrC2auES+y9pIFc3E
X-Google-Smtp-Source: ABdhPJx3uYplV2HQTaI8GS2q6fjg2Ol4RBH1/Mmx/1wvLl98cobIJ1hs/s70BD+hGAV4pZKtQRmXyA==
X-Received: by 2002:a63:d40a:: with SMTP id a10mr4603320pgh.7.1632408976435;
        Thu, 23 Sep 2021 07:56:16 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id c24sm6023713pfd.120.2021.09.23.07.56.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Sep 2021 07:56:16 -0700 (PDT)
Message-ID: <614c9590.1c69fb81.4e068.16fc@mx.google.com>
Date:   Thu, 23 Sep 2021 07:56:16 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.283-3-g9db471376cec
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.9
Subject: stable-rc/queue/4.9 baseline: 103 runs,
 5 regressions (v4.9.283-3-g9db471376cec)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 103 runs, 5 regressions (v4.9.283-3-g9db47137=
6cec)

Regressions Summary
-------------------

platform             | arch   | lab           | compiler | defconfig       =
             | regressions
---------------------+--------+---------------+----------+-----------------=
-------------+------------
qemu_arm-versatilepb | arm    | lab-baylibre  | gcc-8    | versatile_defcon=
fig          | 1          =

qemu_arm-versatilepb | arm    | lab-broonie   | gcc-8    | versatile_defcon=
fig          | 1          =

qemu_arm-versatilepb | arm    | lab-cip       | gcc-8    | versatile_defcon=
fig          | 1          =

qemu_arm-versatilepb | arm    | lab-collabora | gcc-8    | versatile_defcon=
fig          | 1          =

qemu_x86_64          | x86_64 | lab-broonie   | gcc-8    | x86_64_defcon...=
6-chromebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.283-3-g9db471376cec/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.283-3-g9db471376cec
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      9db471376cec84e67d1cf6efd6cf3d9eb0f3f5b5 =



Test Regressions
---------------- =



platform             | arch   | lab           | compiler | defconfig       =
             | regressions
---------------------+--------+---------------+----------+-----------------=
-------------+------------
qemu_arm-versatilepb | arm    | lab-baylibre  | gcc-8    | versatile_defcon=
fig          | 1          =


  Details:     https://kernelci.org/test/plan/id/614c5d2f7e79033bdb99a2ef

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.283-3=
-g9db471376cec/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.283-3=
-g9db471376cec/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/614c5d2f7e79033bdb99a=
2f0
        failing since 313 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch   | lab           | compiler | defconfig       =
             | regressions
---------------------+--------+---------------+----------+-----------------=
-------------+------------
qemu_arm-versatilepb | arm    | lab-broonie   | gcc-8    | versatile_defcon=
fig          | 1          =


  Details:     https://kernelci.org/test/plan/id/614c8d51df763ca99899a3d7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.283-3=
-g9db471376cec/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-=
versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.283-3=
-g9db471376cec/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-=
versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/614c8d51df763ca99899a=
3d8
        failing since 313 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch   | lab           | compiler | defconfig       =
             | regressions
---------------------+--------+---------------+----------+-----------------=
-------------+------------
qemu_arm-versatilepb | arm    | lab-cip       | gcc-8    | versatile_defcon=
fig          | 1          =


  Details:     https://kernelci.org/test/plan/id/614c5d58d08ca89e9399a2f8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.283-3=
-g9db471376cec/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-vers=
atilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.283-3=
-g9db471376cec/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-vers=
atilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/614c5d58d08ca89e9399a=
2f9
        failing since 313 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch   | lab           | compiler | defconfig       =
             | regressions
---------------------+--------+---------------+----------+-----------------=
-------------+------------
qemu_arm-versatilepb | arm    | lab-collabora | gcc-8    | versatile_defcon=
fig          | 1          =


  Details:     https://kernelci.org/test/plan/id/614c684a5042db0b6399a2e9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.283-3=
-g9db471376cec/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.283-3=
-g9db471376cec/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/614c684a5042db0b6399a=
2ea
        failing since 313 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch   | lab           | compiler | defconfig       =
             | regressions
---------------------+--------+---------------+----------+-----------------=
-------------+------------
qemu_x86_64          | x86_64 | lab-broonie   | gcc-8    | x86_64_defcon...=
6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/614c8c751c6d2e776899a318

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.283-3=
-g9db471376cec/x86_64/x86_64_defconfig+x86-chromebook/gcc-8/lab-broonie/bas=
eline-qemu_x86_64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.283-3=
-g9db471376cec/x86_64/x86_64_defconfig+x86-chromebook/gcc-8/lab-broonie/bas=
eline-qemu_x86_64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/614c8c751c6d2e776899a=
319
        new failure (last pass: v4.9.282-177-g6b230604d6e1) =

 =20
