Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E069B309F13
	for <lists+stable@lfdr.de>; Sun, 31 Jan 2021 22:28:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229696AbhAaVUn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 31 Jan 2021 16:20:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229638AbhAaVQ7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 31 Jan 2021 16:16:59 -0500
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65284C06174A
        for <stable@vger.kernel.org>; Sun, 31 Jan 2021 13:04:58 -0800 (PST)
Received: by mail-pg1-x52d.google.com with SMTP id s23so9373311pgh.11
        for <stable@vger.kernel.org>; Sun, 31 Jan 2021 13:04:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ihGR6UhrOxVgImuyA6ydGhgps1LllEWI0PbhMaQ7quk=;
        b=bOfj3bL1dIBwixCjEE5ofKSOGng0KUNqvG9nU6jtQ7g+h4VVzLUDcKhWWfe1d1eUw4
         Bq2KT8XAtGs9IkIsRgpnc+ZgX0absWX8IJSEF1klqGGZZusDTYNB2zFH2ScBHj/glUhq
         bX4a53d3ivbBvD+2thAVotwJ80A05kEQFgjv3TH1OYOWrQmkUNHGk2Hw3BsAMCMNuaYD
         ytn2i+oUcyrY2yjjCEn+9SAMfEqHx6gDPRu2DA842v2K5Vmkq8qd/RjjTzo2VEDtY0nF
         3F38GbJLsUi1WELttKh/ApTL6r/AbLGftfw4IBXbzj28QR6dumoXv17lTETtro9KRuTe
         465w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ihGR6UhrOxVgImuyA6ydGhgps1LllEWI0PbhMaQ7quk=;
        b=eRd1fjOdxIkv5po17WSVR9VI+nNwKlO0X3NuOYnmEqI+xMo8BIv+zGzrfNuqhsMCPR
         u8T5ixEMiORX6l90oAre0XFBuNFy6UhO8z7T1QLuxnqssol3c6yyVGafdgl3FvJMOB2o
         osdaRk1o8hfSicXCYNoe53yZLIvOeK3wjc6zlveQ6419A8nAGwU7HNBmWY0PUdoWOTmn
         QWlpfxL9LKJYnJv/7ae/ma15ZeP2GirgA4fPH1QNYVHf0+2dqH8iIczLSQIx/q7/+d15
         2Tu0Nk0YhmrWBXgxpZIuGVN+eL8fPYVlih6XF/ct21XGlqzVihvMBnniHvNuhggwuZQB
         2NMg==
X-Gm-Message-State: AOAM531LcLM74r/qpId6J7f2zo74Lrq6zuu4y9wwwlXDT+4VilsKDTfT
        UR6kHa46/IR9qZYCN9ffZseAmfOH6vYRpQ==
X-Google-Smtp-Source: ABdhPJxc94wMz8PlsfIhDaVRF41ZE5saKuFsylZkuI3aWsiGVeQVxa1IFeFsAkHiy9vVViMbg1u1Yg==
X-Received: by 2002:a63:7c5d:: with SMTP id l29mr13958410pgn.32.1612127097538;
        Sun, 31 Jan 2021 13:04:57 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id l190sm15006613pfl.205.2021.01.31.13.04.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 31 Jan 2021 13:04:56 -0800 (PST)
Message-ID: <60171b78.1c69fb81.bc9b3.54cd@mx.google.com>
Date:   Sun, 31 Jan 2021 13:04:56 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.4.94-13-g26fa1633c7ed7
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.4
Subject: stable-rc/queue/5.4 baseline: 179 runs,
 4 regressions (v5.4.94-13-g26fa1633c7ed7)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 179 runs, 4 regressions (v5.4.94-13-g26fa1633=
c7ed7)

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.94-13-g26fa1633c7ed7/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.94-13-g26fa1633c7ed7
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      26fa1633c7ed7ee69e1b2cbe34d251ae796f1d15 =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6016e669d7c10b1363d3dfc9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.94-13=
-g26fa1633c7ed7/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.94-13=
-g26fa1633c7ed7/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6016e669d7c10b1363d3d=
fca
        failing since 78 days (last pass: v5.4.77-44-gce6b18c3a8969, first =
fail: v5.4.77-45-gfd610189f77e1) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6016e63e7e1b08a86cd3dfd4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.94-13=
-g26fa1633c7ed7/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.94-13=
-g26fa1633c7ed7/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6016e63e7e1b08a86cd3d=
fd5
        failing since 78 days (last pass: v5.4.77-44-gce6b18c3a8969, first =
fail: v5.4.77-45-gfd610189f77e1) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6016e656fb8304d412d3dff6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.94-13=
-g26fa1633c7ed7/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.94-13=
-g26fa1633c7ed7/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6016e656fb8304d412d3d=
ff7
        failing since 78 days (last pass: v5.4.77-44-gce6b18c3a8969, first =
fail: v5.4.77-45-gfd610189f77e1) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6016e5ea0e46141074d3dfe0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.94-13=
-g26fa1633c7ed7/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.94-13=
-g26fa1633c7ed7/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6016e5ea0e46141074d3d=
fe1
        failing since 78 days (last pass: v5.4.77-44-gce6b18c3a8969, first =
fail: v5.4.77-45-gfd610189f77e1) =

 =20
