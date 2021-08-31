Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA24A3FCEB3
	for <lists+stable@lfdr.de>; Tue, 31 Aug 2021 22:40:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241289AbhHaUlA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Aug 2021 16:41:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241288AbhHaUkz (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 31 Aug 2021 16:40:55 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0D5EC0612E7
        for <stable@vger.kernel.org>; Tue, 31 Aug 2021 13:39:59 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id k24so431250pgh.8
        for <stable@vger.kernel.org>; Tue, 31 Aug 2021 13:39:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=q6jgqWbMaYIF0mbX7lNB6ouEwpq76lptXYt66waL3cY=;
        b=gpcNryMlFjNMovv5SGZfZ6BEVYK7ZWz2SZ2Y50oI635rjAO40BoUDdz0D8rUiYglgh
         97hsfzEpXdU5+Z4V9grAHlWcJ6ccOPv6MNb5K/63JsnQ+hplxaa1b6o7iBlPY2tteXLW
         +gcfnDJo3U5yHDhU5FiS+zMps4N1Hviwvh6xyqty3mQB09IlfKJ5z8FN6mIO2W87EyjZ
         ehDGhYZJuNMFmPz++s+uyOUYb7LR8ngD9d7+x3qp2G16iBDnbjLDVl+si3pTaOxoeO7J
         aFdnGqqPcPoORKfO1llzkeplBBDr+M3MIpyBFWT7UpKtoUSQC9Ie/tgSFyDn1b5PmTH/
         IALQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=q6jgqWbMaYIF0mbX7lNB6ouEwpq76lptXYt66waL3cY=;
        b=CPvoaf+l+T28cNKhb4KzUQ8Db41m+dipF3hxGzkPh91VTm/gS0eNz9ZaqDe7jYkJFN
         r28CffP7ZIF39NKZxXTymeagaJRMagpza9ZmT7EZGse4z76xkTVTJTJ42PwJv9MCUwnO
         ba5Ve2U3Jxticp0PIqCTHyCvfm6imS1iLWPosC0HqIGaoZMQS32OWcE6gBhMj41atLEz
         Hsh6HLhRqGpNee0ogr/ZErndnnPN5t0OeG4ea4zy9oki3rPhSdvcFIcxp6E8wk9eVb5z
         KKB/Guw1UeoHdhFsf5Oxz3JihfnRFHx1VsNl2fuxmbJLrm8q5j/2M+VJtFHX3uaZGVmJ
         h3Aw==
X-Gm-Message-State: AOAM531os56MYi8pmRMF2PPgjMem1JFkdOjDCjlKiClPMfBbRZstUcwY
        EDWUP8qO9ZgDVw18iJaF1/5G7gpZxme4PtZk
X-Google-Smtp-Source: ABdhPJyajeVj5KYOOIdul/z83ORKr4raUuAAtV/oSxuwyrGgNh/tDFEU0pwiL9JbnHEpFe5SPpsIeQ==
X-Received: by 2002:a65:5887:: with SMTP id d7mr29214732pgu.285.1630442399325;
        Tue, 31 Aug 2021 13:39:59 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id i132sm4918241pgc.35.2021.08.31.13.39.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Aug 2021 13:39:59 -0700 (PDT)
Message-ID: <612e939f.1c69fb81.2c5cf.e50a@mx.google.com>
Date:   Tue, 31 Aug 2021 13:39:59 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.9
X-Kernelci-Kernel: v4.9.281
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.9 baseline: 105 runs, 4 regressions (v4.9.281)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 105 runs, 4 regressions (v4.9.281)

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
el/v4.9.281/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.281
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      ee4959c91711d87bc57c762cd050804c04b08739 =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6128e8bcb2e140d82d8e2c89

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.281/a=
rm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.281/a=
rm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6128e8bcb2e140d82d8e2=
c8a
        failing since 286 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6128eaae78848c67628e2c7d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.281/a=
rm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.281/a=
rm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6128eaae78848c67628e2=
c7e
        failing since 286 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6128e89e2371a9d0598e2caf

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.281/a=
rm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.281/a=
rm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6128e89e2371a9d0598e2=
cb0
        failing since 286 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6129153c399cbe308e8e2c87

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.281/a=
rm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_arm-versatilepb.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.281/a=
rm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_arm-versatilepb.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6129153c399cbe308e8e2=
c88
        failing since 286 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =20
