Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F17A23A0A90
	for <lists+stable@lfdr.de>; Wed,  9 Jun 2021 05:21:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233346AbhFIDW7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 23:22:59 -0400
Received: from mail-pl1-f170.google.com ([209.85.214.170]:37407 "EHLO
        mail-pl1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233222AbhFIDW7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Jun 2021 23:22:59 -0400
Received: by mail-pl1-f170.google.com with SMTP id h12so450248plf.4
        for <stable@vger.kernel.org>; Tue, 08 Jun 2021 20:20:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=6fe/G/iL0+WUnI96x+IVFXlWfRzQxuiaQhMP4qQaXeo=;
        b=B0xCNfQN/C56ZG7VCHSHQJp8X3gC/2KtDL0sC8lWglGzZ4K5Bi05rVSILYDli2xc8K
         IqCcs+vNmnFN2CchhCAE6XzUnehPdrFgDUTVgyPybLMI8Ihc4fDeX3BRhge2hP0KYnFz
         dI4Re89FSS9s2idRyZPdS1uu+re5jz983/9p/WXmJbCZGpf0t7/0WbqF2CzwVMWFpblD
         YKDj5InVhGP72txDqZGVxjDyRB4O65w0FaMUV+dsh/42jy3AHsBWXpDksyuGS8EG+SJn
         IeoOjTHSGx5KhiQzXI7wjsqVQT8GFgJdel8L84U90j5DKoBvhXBJYaFbf5XEZiNpYwO2
         OSoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=6fe/G/iL0+WUnI96x+IVFXlWfRzQxuiaQhMP4qQaXeo=;
        b=m/wYB24T8ZWbf/ySba1RRNgX4lQ9gib4CQReOnwztEc0h96T5qm8NfvQhvUj0zS0yw
         e0eIOE4+LpADLGxhNcGdUYBRuFpD8nPtJCdF7AA0SgJtMLTp4MbHh/kLF2pN69fx4dvu
         LG5NBSliZoTg40O66/bOX4czKam47PuRbLkkWrum9TEaQRS4szmvDA+OPAWbqTEEgQ/P
         GE1/P1mg6pq6ce16PoZU8GWils4b7CQLcYSQwmUfM3We0LjT1EWbFAFGkeO/tLFLyd9b
         Kt3R7vq5VwM36lTfwAFy3Yr/zg3h64MYC4CHbA+Q2mJXWVf1h+HVgNtpz5A/Lfi0T/KU
         5uig==
X-Gm-Message-State: AOAM5312q43IdXL9u4FB1FhFTEHTLJcg8wRzexCSfPt0kM823GgdoShQ
        yAF2+xI5/HtAK4sNKZMJpPEKDcPgdFbJMLrD
X-Google-Smtp-Source: ABdhPJxeDR90spXgiRIptXy+VNE0NPov1uRRIskcJZJCV2ibdShZjZ7V+ZUzUde/ARghnSbVMwfldQ==
X-Received: by 2002:a17:902:aa04:b029:ec:f779:3a2b with SMTP id be4-20020a170902aa04b02900ecf7793a2bmr3024543plb.44.1623208790851;
        Tue, 08 Jun 2021 20:19:50 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id i74sm3518438pgc.85.2021.06.08.20.19.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Jun 2021 20:19:50 -0700 (PDT)
Message-ID: <60c03356.1c69fb81.bd2fe.c386@mx.google.com>
Date:   Tue, 08 Jun 2021 20:19:50 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.193-59-g1eec51fc497b
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.19.y
Subject: stable-rc/linux-4.19.y baseline: 96 runs,
 4 regressions (v4.19.193-59-g1eec51fc497b)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y baseline: 96 runs, 4 regressions (v4.19.193-59-g1eec=
51fc497b)

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.19.y/ker=
nel/v4.19.193-59-g1eec51fc497b/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.19.y
  Describe: v4.19.193-59-g1eec51fc497b
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      1eec51fc497ba0beccb30f8ff5bd61d21404d691 =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60bffe883346e9b1ef0c0e2a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
93-59-g1eec51fc497b/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
93-59-g1eec51fc497b/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60bffe883346e9b1ef0c0=
e2b
        failing since 202 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60bffead6a58ec01f90c0e32

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
93-59-g1eec51fc497b/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
93-59-g1eec51fc497b/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60bffead6a58ec01f90c0=
e33
        failing since 202 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60bffe9698aedc23720c0e00

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
93-59-g1eec51fc497b/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
93-59-g1eec51fc497b/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60bffe9698aedc23720c0=
e01
        failing since 202 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60c016c515f9fc77240c0e12

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
93-59-g1eec51fc497b/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qe=
mu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
93-59-g1eec51fc497b/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qe=
mu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60c016c515f9fc77240c0=
e13
        failing since 202 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =20
