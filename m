Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E021414CE0
	for <lists+stable@lfdr.de>; Wed, 22 Sep 2021 17:19:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236400AbhIVPUm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Sep 2021 11:20:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232318AbhIVPUm (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Sep 2021 11:20:42 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AE6BC061574
        for <stable@vger.kernel.org>; Wed, 22 Sep 2021 08:19:12 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id e7so3039224pgk.2
        for <stable@vger.kernel.org>; Wed, 22 Sep 2021 08:19:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=MmyrYf3rdDatAKbh/jjSPFjp0PEHCQxSSxfIpQYk9aQ=;
        b=R0nFBfpzPGotUEXj+A4xNQXf6iuMy7NMVXBdPaUz7VSNR2NDvHCSoHvzdLS1V/E/B7
         AQHKn6puA5DwmkskWXZP97TcMi8vKqxnG8/4NdyJUuKXsFPbJ2ouxao1Wvaqan69osXv
         ptfX057tFoQyiuimwF6pwCKdzZEASry5qVGfR26W/R8r/7gNe6jJlSJDfSdLg3Rh3/ny
         Z97KpNwFDuCzf5CENJ1iVkncdwtaUvhA9K7STyGFZMV0LruQzdgGM+nEMCVa8BLSOXTg
         V3S8NjYXJgLq/0CGganXrJ/rM7PahqA3GxbWYYX5jLytBu5dmds73giS2hRP2WvBmbDp
         TSgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=MmyrYf3rdDatAKbh/jjSPFjp0PEHCQxSSxfIpQYk9aQ=;
        b=KoLp1bskWCci3PIGb4wY7YbGC2i0C4ynInygxjGg+bGC8WbDSFhHTnKe7+xLWdw3L8
         e0c/XhD/gWm1iY93fNzbU1nQLd0DzEljT3N/16cq1Qu/jZO2Us3MMG4HZNlswgzRRv0R
         E8lF43p1xiTtCot3TbyVhiSr+XkoPIaiFFRLjyPCDFvI7lbyl27i6xmbjGlHzWEXG7xE
         j0lrwn8vAcwjyvJSDvonUpzk0ZLnE1QR9vcdPlkciIF2DUb4g2HS4FqDMuycKtANZMVm
         I+9DRMgWdcaRMtFSPIjS0Sov1+qXXJ91O2NrWDHFplI2TScWOPjyy6ZV99Zks/v6k7Bk
         BPuw==
X-Gm-Message-State: AOAM533cSQpOteVA4CHiFtSYsB6gl351xgA+xx1rJpgewPIEPacc6y0k
        a+6V1IJA1RSdf9CwfBMEk/CP2NMQp3AjGt81
X-Google-Smtp-Source: ABdhPJymtAa8THUcQpdcoMjY9Ipmkq8P54ok3TgHfE7PhjAATnCxxcTk1zihQmE6UyMHHAACi2v91w==
X-Received: by 2002:a05:6a00:aca:b029:392:9c79:3a39 with SMTP id c10-20020a056a000acab02903929c793a39mr336943pfl.57.1632323951755;
        Wed, 22 Sep 2021 08:19:11 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id c1sm2706451pjd.35.2021.09.22.08.19.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Sep 2021 08:19:11 -0700 (PDT)
Message-ID: <614b496f.1c69fb81.cc51.6f30@mx.google.com>
Date:   Wed, 22 Sep 2021 08:19:11 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.206-294-gae99e791bb87
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.19
Subject: stable-rc/queue/4.19 baseline: 83 runs,
 3 regressions (v4.19.206-294-gae99e791bb87)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 83 runs, 3 regressions (v4.19.206-294-gae99e=
791bb87)

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.206-294-gae99e791bb87/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.206-294-gae99e791bb87
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      ae99e791bb8705b898f3c81ef431a4fdb1d02070 =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/614b0ebac247963dd799a2e6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.206=
-294-gae99e791bb87/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.206=
-294-gae99e791bb87/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/614b0ebac247963dd799a=
2e7
        failing since 312 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/614b0f0798c1de283a99a2fb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.206=
-294-gae99e791bb87/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.206=
-294-gae99e791bb87/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/614b0f0798c1de283a99a=
2fc
        failing since 312 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/614b0f2d4c3390fdc899a2de

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.206=
-294-gae99e791bb87/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.206=
-294-gae99e791bb87/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/614b0f2d4c3390fdc899a=
2df
        failing since 312 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =20
