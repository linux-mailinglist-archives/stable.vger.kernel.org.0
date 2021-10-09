Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DBF1427D25
	for <lists+stable@lfdr.de>; Sat,  9 Oct 2021 21:37:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229763AbhJITjB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 9 Oct 2021 15:39:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229558AbhJITjA (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 9 Oct 2021 15:39:00 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5E39C061570
        for <stable@vger.kernel.org>; Sat,  9 Oct 2021 12:37:03 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id t11so8380630plq.11
        for <stable@vger.kernel.org>; Sat, 09 Oct 2021 12:37:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=tfLEMm6JM/IfxhHsDvEY2NtdYar2zHx6tohigxXS260=;
        b=OoipemtkjaH6hsjNJC+7zYOha6Q89FVNSc+b8ReT1uGOj2H1KXjg43g5bG61WPodyQ
         8ByKHEMmQQokI8neXLSFbyrenOmfVSDF6sUTLJ2fpzBxCiTdcNCJa0K/zkjXEumf/PAq
         CmV3dFL4mZDEOAHNCQOsIuBq3x61gDvcBbtpf6sK/A9NPC8FZ16bdjgjvatRE8Sg5/qv
         M/vqYfSIW93g1DhVUwPsD93Fuul9FoYykqoIXIS5wBaFJVT0gwAhnrgAuOXkT6oqyuIW
         1x6zvqgO0TTvojJBCNsrGr4yAZQPzwlmCEvRX+NCTwNs0A+5oyC7geSGw3Ak41nn5z2J
         9r/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=tfLEMm6JM/IfxhHsDvEY2NtdYar2zHx6tohigxXS260=;
        b=0eg57+3iI0tsrX3Z1Csf8HbeiZ1ddSp6PoJKXsvB//VH70ig+3vBNjr9MctrozNBhh
         Qbp3zk5BTqaw7IjTo1N3DR7jlR7lK5kFa0gg8oMRp/52ShbGf0malMyheci+5Nc2+AYh
         pZKD47QQUTQw4BxH7cIaBEchjQ5+rXAJC25nI2D1fcdfecfpwDh0Otd4RiQ2FWrmQCmb
         RuOBSzfcg8azDLrTVx5ZDtj/oTIbNO9ii9TjoGGYJqlQtuF4P6wRjdG1hP4PlIEUGIfq
         paQqETyf23RxK1zo0XIrJTXztCWW80W2A9Hz4suaxJh3eDBYTdJLUNl54juEwYkFPBMB
         ZQow==
X-Gm-Message-State: AOAM532iy8DX+hs1vRT7pYC18myq9vWmVyPMSu+GMGWNJlIQsk5iyFEy
        hDPVsy7pHhHfCJdiG71EkwW7Yrywp0SoNxoO
X-Google-Smtp-Source: ABdhPJzx+NuPMx0Z2xtsBLZxvrh2zqsw7Eo3Vvuq8TDJHNyF9TSyh0BYdTEDNuyq0e/nj4yjzz8Plw==
X-Received: by 2002:a17:90b:4b4c:: with SMTP id mi12mr19950120pjb.57.1633808223108;
        Sat, 09 Oct 2021 12:37:03 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id n9sm12180324pjk.3.2021.10.09.12.37.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 09 Oct 2021 12:37:02 -0700 (PDT)
Message-ID: <6161ef5e.1c69fb81.2e5d0.4f88@mx.google.com>
Date:   Sat, 09 Oct 2021 12:37:02 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.210-9-g2ca4e64e8c5a
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.19
Subject: stable-rc/queue/4.19 baseline: 104 runs,
 4 regressions (v4.19.210-9-g2ca4e64e8c5a)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 104 runs, 4 regressions (v4.19.210-9-g2ca4e6=
4e8c5a)

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
nel/v4.19.210-9-g2ca4e64e8c5a/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.210-9-g2ca4e64e8c5a
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      2ca4e64e8c5a6a9ad4a6920f7a413facc9bddd8d =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6161b44f7d66b106ed99a2ea

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.210=
-9-g2ca4e64e8c5a/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.210=
-9-g2ca4e64e8c5a/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6161b44f7d66b106ed99a=
2eb
        failing since 329 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6161b4447d66b106ed99a2dd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.210=
-9-g2ca4e64e8c5a/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.210=
-9-g2ca4e64e8c5a/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6161b4447d66b106ed99a=
2de
        failing since 329 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6161b4b46aa50075f699a2db

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.210=
-9-g2ca4e64e8c5a/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.210=
-9-g2ca4e64e8c5a/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6161b4b46aa50075f699a=
2dc
        failing since 329 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6161b3fbf4e9d7a5d199a2da

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.210=
-9-g2ca4e64e8c5a/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.210=
-9-g2ca4e64e8c5a/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6161b3fbf4e9d7a5d199a=
2db
        failing since 329 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =20
