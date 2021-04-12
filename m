Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F8E335D096
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 20:49:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236813AbhDLSth (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 14:49:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236804AbhDLStg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Apr 2021 14:49:36 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F826C061574
        for <stable@vger.kernel.org>; Mon, 12 Apr 2021 11:49:18 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id y2so6871332plg.5
        for <stable@vger.kernel.org>; Mon, 12 Apr 2021 11:49:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=xzDMNx5K+W6CkKdH+YXtcw0fQHH93IsQeew0d7mDeIc=;
        b=Nzb2IUZuoJBSDnAyrE1kVQiqv110a8l25738GYP/1DupFDhEVjfk/rIA9MeSVLfP15
         V2tEBQAG2KWeiDrp1mnr+2ISrVMw2JuzOsWn+xYvrHcpbXuco/Ml8pHP2cR1q2N/Ok3d
         HfpnB90+35hmcBr+KYrNVGMryqPOH34SWarL/lFffjcyXG5b1gUSIhxB0VmoMBTNaDlA
         HXbN8aQNdxhEbumxcYmRx1zwe/9pk1VTff4YbRyBfI7aP+wK//uVgwtlIcTYgCAbK0sJ
         nbHT8c7rn+3R7QMGxLqV3nZMbjAItRnH9K8ytyJLsjHaY16YSygxsWQ1R9quz+ItAHot
         IPbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=xzDMNx5K+W6CkKdH+YXtcw0fQHH93IsQeew0d7mDeIc=;
        b=I+XguFGcRTf4IpyI9IEvYbmJHqw1fKHNKS0fdquK1MPew/sNCxsMkEsj0p96etZDRi
         Q14Sx2TlDZBhS7rL4CJXAEmD/NGmh8NKJL3+/YJgsiq9nnjPQFA1a3VlF8GJ1UaIe7CH
         Pl7GbukZ+E0ArEA/GlCr7Q79UEQ4ndwucR5cqErlTHFvQPyUf1qiq4IyZQUJzsJyGBKf
         wyg33/gE5ZkOOg9B88FPYtLgayipJjCNw3QNZTA0PxSMnOQNgBhnT/Necmo3cvXDFmOy
         LbFCQ4LZV5yD2xK6a9NtH5oPteGSZFcRbF+IvKp8oyyiBitUUMyl9fxus26oY41U3+hY
         wYpQ==
X-Gm-Message-State: AOAM530TCW1ZsPQPO+5Ftb7eiNoM5A5e3A8WsyUyWTBcnSXWMilR+Yy5
        zLs3CbE9Wit32hdA2XQmhFQn3KBPf6qar50L
X-Google-Smtp-Source: ABdhPJyhqgnBmn4+6vaovpl/uWqZFGj8/F26lx3gwp+rUOXQsZE3dE+nGVbIbs6q0vbdJoQQyPPvSA==
X-Received: by 2002:a17:90a:af97:: with SMTP id w23mr592957pjq.101.1618253357561;
        Mon, 12 Apr 2021 11:49:17 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id i66sm2568714pfg.206.2021.04.12.11.49.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Apr 2021 11:49:17 -0700 (PDT)
Message-ID: <6074962d.1c69fb81.bcce6.61b1@mx.google.com>
Date:   Mon, 12 Apr 2021 11:49:17 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.14.230-59-gf0bb9847b3ee1
X-Kernelci-Branch: queue/4.14
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.14 baseline: 102 runs,
 3 regressions (v4.14.230-59-gf0bb9847b3ee1)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 102 runs, 3 regressions (v4.14.230-59-gf0bb9=
847b3ee1)

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.230-59-gf0bb9847b3ee1/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.230-59-gf0bb9847b3ee1
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      f0bb9847b3ee1ee6d710ace821b5097600a9b70b =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/607458e05e5dcf1934dac6e5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.230=
-59-gf0bb9847b3ee1/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.230=
-59-gf0bb9847b3ee1/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/607458e05e5dcf1934dac=
6e6
        failing since 149 days (last pass: v4.14.206-21-g787a7a3ca16c, firs=
t fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/607459099f875bcf9cdac6bb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.230=
-59-gf0bb9847b3ee1/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.230=
-59-gf0bb9847b3ee1/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/607459099f875bcf9cdac=
6bc
        failing since 149 days (last pass: v4.14.206-21-g787a7a3ca16c, firs=
t fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/607458955e5dcf1934dac6b5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.230=
-59-gf0bb9847b3ee1/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.230=
-59-gf0bb9847b3ee1/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/607458955e5dcf1934dac=
6b6
        failing since 149 days (last pass: v4.14.206-21-g787a7a3ca16c, firs=
t fail: v4.14.206-22-ga949bf40fb01) =

 =20
