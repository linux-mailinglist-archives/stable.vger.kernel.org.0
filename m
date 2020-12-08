Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A526F2D33DE
	for <lists+stable@lfdr.de>; Tue,  8 Dec 2020 21:28:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731021AbgLHUQF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Dec 2020 15:16:05 -0500
Received: from mail-pf1-f181.google.com ([209.85.210.181]:40702 "EHLO
        mail-pf1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730488AbgLHUMu (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Dec 2020 15:12:50 -0500
Received: by mail-pf1-f181.google.com with SMTP id t7so14947481pfh.7
        for <stable@vger.kernel.org>; Tue, 08 Dec 2020 12:12:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=DQ46vzFxUR3TKIq50mTJpF2h9R3D/BS8gz/FpE2oods=;
        b=uuFKDixYwqIcbo3h+Dste55lCwjEUCpOC5uZS2ymSxmmoYxluAKZJECHW8Meh4XVg3
         tG0gfMQqm3AEP+x5+kRGc7ENPC7fH99MswDLw28bh30nmhzVErY7P7GKkM2aLB1cQZvj
         pe3K8r0jFCicfJzXJ3nKl26bZeOduJzUoDuOoKPJRm470IeeI8NMjH455okYfZP7OQCg
         CjyOZ809JNyv1w4FErQ6PdRa1xC5xNKNNFdK45EyWBMAn3WtFO0hC68+5T3SiyoRzrcL
         absYbIam7xz5mqNmN4UTlYZoE5qK0OQk2BQRaRCUXGrha9tjF1ZQNiwBx6pNFp0BipJu
         hPAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=DQ46vzFxUR3TKIq50mTJpF2h9R3D/BS8gz/FpE2oods=;
        b=qa0TvlFMQyJCgQONQBvOBNQclRxMjI9igxNAMnvzzX2e3AjLiJmtz3tK+4Tu9O6qGg
         8OLi4m6CgOCQwtI95+flAoR7XZYCecerP7PTP7ayu8G+5guZ8wz6zoZMZvpcdfbjQH16
         /4K6DlHoGU90XbOMTib4brhkhhm7uA624pQoyWApoHzFBQ58M42HZ1Ajc9QnS11uxQei
         Xmvp3cCZrUscvcA7VRG0FQm5rhjH8KespoCPrRTPOAen5xkrhT6GBoWmHf+UFbT6ZU9a
         rJ4NAMqT22XIhAv0Bc/zOHrjQLtGCylAexoDxp88gU8mxEXlc+eLWExjEYj7Yj17OHL+
         xa7w==
X-Gm-Message-State: AOAM532CFmMRiH0CSraK1sAh4An8UnIzxWwmuV3KPuKF0ky0rqTzVWQj
        HlEXUIcksF2BHXFYgGy1yD25chLQ020riQ==
X-Google-Smtp-Source: ABdhPJw5ozD+gm5xeIwcSRwmAX/mJlULzpStX18wd5Ksg71aMWTgpvt+ztTqA1AaZ6N+IfgOYe8CdA==
X-Received: by 2002:a63:2fc5:: with SMTP id v188mr739132pgv.243.1607458287582;
        Tue, 08 Dec 2020 12:11:27 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id jz7sm4302174pjb.14.2020.12.08.12.11.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Dec 2020 12:11:26 -0800 (PST)
Message-ID: <5fcfddee.1c69fb81.a4601.97e7@mx.google.com>
Date:   Tue, 08 Dec 2020 12:11:26 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.19
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.161-34-gdbb3b64a7baa
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.19 baseline: 145 runs,
 4 regressions (v4.19.161-34-gdbb3b64a7baa)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 145 runs, 4 regressions (v4.19.161-34-gdbb3b=
64a7baa)

Regressions Summary
-------------------

platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.161-34-gdbb3b64a7baa/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.161-34-gdbb3b64a7baa
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      dbb3b64a7baa19706610d55146a5bd88b3c4a208 =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fcfaa6e6fec8e446fc94cdb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.161=
-34-gdbb3b64a7baa/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.161=
-34-gdbb3b64a7baa/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fcfaa6e6fec8e446fc94=
cdc
        failing since 24 days (last pass: v4.19.157-26-gd59f3161b3a0, first=
 fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fcfab37b356fe620cc94cc9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.161=
-34-gdbb3b64a7baa/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.161=
-34-gdbb3b64a7baa/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fcfab37b356fe620cc94=
cca
        failing since 24 days (last pass: v4.19.157-26-gd59f3161b3a0, first=
 fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fcfaa924408d52433c94ce6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.161=
-34-gdbb3b64a7baa/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.161=
-34-gdbb3b64a7baa/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fcfaa924408d52433c94=
ce7
        failing since 24 days (last pass: v4.19.157-26-gd59f3161b3a0, first=
 fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fcfb8f59fcd414e1dc94cec

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.161=
-34-gdbb3b64a7baa/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qe=
mu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.161=
-34-gdbb3b64a7baa/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qe=
mu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fcfb8f59fcd414e1dc94=
ced
        failing since 24 days (last pass: v4.19.157-26-gd59f3161b3a0, first=
 fail: v4.19.157-27-g5543cc2c41d55) =

 =20
