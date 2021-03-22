Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DFB4343BA5
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 09:26:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229548AbhCVI0D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 04:26:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229455AbhCVIZt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Mar 2021 04:25:49 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FAFBC061574
        for <stable@vger.kernel.org>; Mon, 22 Mar 2021 01:25:49 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id v186so8132699pgv.7
        for <stable@vger.kernel.org>; Mon, 22 Mar 2021 01:25:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=+WI8/RbX80gOFtlqxp5J3d49e6JyzNB1Puipn9E86X8=;
        b=ee20rkbwrKxkWThG/vB2S10BP8CNMDhwda88d9HoHynJnZTuFC4srJehoZRS+5HYXa
         7YzKgCXivlZ/gt4PKX1SL5zZrYzBbfOO6B3Ik68sm+ISVjjrGab8NtmXS50NN0GoBiSi
         B1xyOFiMZ5DFNvNpav5XexR/kmQY5/QIv4MY3X/sWPedWeKzkwEXAVqaqQyv/zeghDo9
         FBMz6TNCIG8tvj8tuFzHmMsuabMQq3uJiLN0kYTRzHXJktDGPhld4TciOv2Qk44Cz5Qy
         mkrMHfeh8trhB8HhaL9InnpOldr/4Sjl9MZo6sgfOAMNhgB59/qQLiA0ov802l7zVOq6
         iSog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=+WI8/RbX80gOFtlqxp5J3d49e6JyzNB1Puipn9E86X8=;
        b=X8kSGeIgljhoowDzA5WAU4VhDAfRq3tkRt82n02BE4fRx/sYfKGJLzH6gLNrVkZGjs
         rdhXjjC0IcgbeRyqhfofXyAZ2VQR2fTuvQKeLj9fD4fwoRYjhVFVyfANc6yCwSNC2SvV
         tvmXFwnRJKGWeicnSaxyGZVecfNrScgKR47REULIk66OpZhZ+2B0s/YABD+hA+KeyY64
         HZDxh2vWyyXNjwKKVjN3+efHfT39JmzZWwz6cY+OEJ2pUoX5tb60aU+ehCWU6fOkmn/h
         RBRoZB8+alIQdQGW3TZXhyKbwcekmzRA4ZptOV+rvcnGxXJ9GQjAODHY+8LhBZadWCFZ
         LU4A==
X-Gm-Message-State: AOAM530XHglMmgmyrT/wXy7imbIyZLvIXn2ydLaH2Y1Yc8SDGcz9QBj+
        3PGuC2HlmS4WBtq4D6ISKQ6PMTtL20Xbrg==
X-Google-Smtp-Source: ABdhPJx7aJfdVYFk5spDSo3OsDaRQxWPHYB+EqNnVmX8k3rhnSUT9d4evWVV2PJ8dTc0hIo7DXgGOg==
X-Received: by 2002:a62:5c5:0:b029:217:7019:d9e8 with SMTP id 188-20020a6205c50000b02902177019d9e8mr6006288pff.10.1616401548462;
        Mon, 22 Mar 2021 01:25:48 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id co20sm12552820pjb.32.2021.03.22.01.25.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Mar 2021 01:25:48 -0700 (PDT)
Message-ID: <6058548c.1c69fb81.6e2f7.e9b9@mx.google.com>
Date:   Mon, 22 Mar 2021 01:25:48 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.262-13-g15fefca921f6a
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.9
Subject: stable-rc/queue/4.9 baseline: 101 runs,
 4 regressions (v4.9.262-13-g15fefca921f6a)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 101 runs, 4 regressions (v4.9.262-13-g15fefca=
921f6a)

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.262-13-g15fefca921f6a/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.262-13-g15fefca921f6a
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      15fefca921f6a69a26b00eb391c4767e4d40f306 =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/605820c7f610e83a8aaddcd1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.262-1=
3-g15fefca921f6a/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.262-1=
3-g15fefca921f6a/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/605820c7f610e83a8aadd=
cd2
        failing since 128 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/605820cdb1313d8169addcbb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.262-1=
3-g15fefca921f6a/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.262-1=
3-g15fefca921f6a/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/605820cdb1313d8169add=
cbc
        failing since 128 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60582118995ef11911addcb2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.262-1=
3-g15fefca921f6a/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.262-1=
3-g15fefca921f6a/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60582118995ef11911add=
cb3
        failing since 128 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60581fb61364d74e58addcef

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.262-1=
3-g15fefca921f6a/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.262-1=
3-g15fefca921f6a/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60581fb61364d74e58add=
cf0
        failing since 128 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =20
