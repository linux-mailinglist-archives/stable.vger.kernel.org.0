Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6045B39187B
	for <lists+stable@lfdr.de>; Wed, 26 May 2021 15:04:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233227AbhEZNFn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 May 2021 09:05:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232896AbhEZNFd (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 May 2021 09:05:33 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2C76C06175F
        for <stable@vger.kernel.org>; Wed, 26 May 2021 06:03:58 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id n8so580724plf.7
        for <stable@vger.kernel.org>; Wed, 26 May 2021 06:03:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=v9tFyvCD5CJxDVMVEEKVjbo3L//wVA01Fx2IA+oyphE=;
        b=CwxWgXkdhL8N+/eWf+GyeWUnDOLPTB3CFShxxDWT2OZIrEHQnDRg9qv4eyGbMi5yE3
         6Mxuiirr2IAMIvOvXGkIfRjhiIGMN8xGtZrtcp1yZ1opknFBzqVokY13NGI+VBrLzUcI
         GWQqPwPym1wx7ldmZhneLbZYQmQLuVLORBtFnrp3UlzakSVBLc4JVDGaDicBXCnwnbUi
         JvKVXErjQpSVOKICy45RDcZucsydW+21ebueZ5RR3IIMMHziwStIUrofiWESfbMUnE+f
         z9RDU5uG6DLPj+1lcT5jnHtTx+25deYq/5/wSsVsE2FVCKzYQWh5XOVbbTTvFo606pO2
         8VpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=v9tFyvCD5CJxDVMVEEKVjbo3L//wVA01Fx2IA+oyphE=;
        b=Hiv23Qx59PRhlHA85rlEpv4sLi8cCWX4Ol3MK5QVNqBkyfZ9RHD78luX9KIkF9HID2
         ivPEIq015HlnDrlia/Kbx5Tq6R/sivVr7BwMWaeSJh1GicrDerE6VCQb3ctWAnQU8JDa
         l8kuo5UEgS9LbXAYZwYJFIZaEVtfRMnJP+GGJcJcZH8FEng+U/vXlCB9oQ+0JhLHH5+/
         SJepj1TI2jsCiISzexGrB8kdl8mARJV7mmrMO3N21ZFa0xQbZzzuPwAF1ctRqFVoQWrf
         dj643x2hhVpzpU7YLRhdjOmS0Gd9qQQNusdONMiUgQ0czlOAenpSN7hnAOFV/Fa3M+1M
         mS/g==
X-Gm-Message-State: AOAM533Pmgl+3jy0/l1BOIWmw2WWilTVSX0ndfOuz4vFC4dcFfDqyHAk
        Zg/KQScj2IUh0qqQ3m2knrk6fCMmXMgHrqNU
X-Google-Smtp-Source: ABdhPJxjZJQnsXLiQNTmvBq0QW7BX1IaggBh/nI5hBr/iZ9Db9n8B21CKtN37JGyg4sb5mdCyIGx9Q==
X-Received: by 2002:a17:90a:cc0e:: with SMTP id b14mr6190435pju.51.1622034238268;
        Wed, 26 May 2021 06:03:58 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y64sm15400921pfy.204.2021.05.26.06.03.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 May 2021 06:03:57 -0700 (PDT)
Message-ID: <60ae473d.1c69fb81.8014.2406@mx.google.com>
Date:   Wed, 26 May 2021 06:03:57 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.191-48-g8fa7abf723c3
X-Kernelci-Branch: queue/4.19
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.19 baseline: 90 runs,
 3 regressions (v4.19.191-48-g8fa7abf723c3)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 90 runs, 3 regressions (v4.19.191-48-g8fa7ab=
f723c3)

Regressions Summary
-------------------

platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.191-48-g8fa7abf723c3/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.191-48-g8fa7abf723c3
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      8fa7abf723c32c837b7f9ecd5a67108220728b6a =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60ae129f4483841923b3afd2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.191=
-48-g8fa7abf723c3/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.191=
-48-g8fa7abf723c3/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ae129f4483841923b3a=
fd3
        failing since 193 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60ae1153028e7c8ae3b3afab

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.191=
-48-g8fa7abf723c3/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.191=
-48-g8fa7abf723c3/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ae1153028e7c8ae3b3a=
fac
        failing since 193 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60ae1140e196991f38b3afbe

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.191=
-48-g8fa7abf723c3/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.191=
-48-g8fa7abf723c3/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ae1140e196991f38b3a=
fbf
        failing since 193 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =20
