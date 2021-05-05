Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3AA637491A
	for <lists+stable@lfdr.de>; Wed,  5 May 2021 22:10:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233830AbhEEULS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 May 2021 16:11:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230227AbhEEULQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 May 2021 16:11:16 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CB63C061574
        for <stable@vger.kernel.org>; Wed,  5 May 2021 13:10:18 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id s20so1709458plr.13
        for <stable@vger.kernel.org>; Wed, 05 May 2021 13:10:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=EMF/noYYS9Aq438/lLJsnCZHJFVKv8fkCbleRpsuqCI=;
        b=nUFIi8kArKuofjTPduxf+Pz1Szz9fUKJeQTwedZEeUQ22w9AxhGU6D30vs0p3VBpYT
         wjw50eH9gp//LUg6iceNJRTLtfDKV5bSz4tpgkQnCYp4BdHM3+kOMq9qpZR6tBYGoN7f
         zmAdcRP6tV4XkGdpqiiVSIyVDUgv3wU2FS3JIO+6yKL2SKVHsoSuFmzjLUna9/v2kxQ7
         6JTIawDWhGYeIj/nc5eSABNITj6gpFkV/13vGbfQvwU4u6tFdLlcCtyOW6YOGSdfKinl
         p5KDjZ1F3G7KmMVvf5VpQXKyNb7UNNHqLlV/syhPiY5sHpcC7oVv6dH3KcNlamV7WtUU
         r8eA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=EMF/noYYS9Aq438/lLJsnCZHJFVKv8fkCbleRpsuqCI=;
        b=GHgPGNSkIarxAYjIYM3r+49nvnM90wINRZBcq2wF0qr3TeE0eJl/aMdUpI5aYZdZW/
         W3lKKMsR+HEzxsCAycqFB3RVV3QWcd3O0VAjiiWvYQFPlgq9RC1eY/kTayMXO6BSl0f2
         XtXyIjq0Fm1wFr97J7sk0BT52MA5ArI4HaywwrJLFg7j5RmkGhS34H5uaG9VJzrpeNuZ
         IKwUoCabqSlIwgoEY9irpkp0a/F+otaS+FNT7EVhUVUa1JyDTDxGHnx3apKQ3P6MiKBm
         dTFKqZNzL7J0/Ol6dms0lP8NfwmD4F/++GYEHRocOuN5whUmzvYh1d+Sm8rr8V65WnHk
         1Nlw==
X-Gm-Message-State: AOAM5303aVt/wNHMz9zg05La8wS0bS0+lpGB/FidwPzKTKwh4fm3DPeE
        fgX5Rs0IF3YdwIdf9l9rxX7L9Lftvs9+M56m
X-Google-Smtp-Source: ABdhPJx2dterdbov7EiprgMlakuxQcD5teLgK45drCXO1IRQTSQ2iXphD37ZZDmXmbKXFXeY609Jxg==
X-Received: by 2002:a17:90a:9f4b:: with SMTP id q11mr13094469pjv.180.1620245417752;
        Wed, 05 May 2021 13:10:17 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id dw18sm7831754pjb.36.2021.05.05.13.10.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 May 2021 13:10:17 -0700 (PDT)
Message-ID: <6092fba9.1c69fb81.4a3d0.281a@mx.google.com>
Date:   Wed, 05 May 2021 13:10:17 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.189-16-g5a3ba2f90f878
X-Kernelci-Branch: linux-4.19.y
Subject: stable-rc/linux-4.19.y baseline: 70 runs,
 3 regressions (v4.19.189-16-g5a3ba2f90f878)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y baseline: 70 runs, 3 regressions (v4.19.189-16-g5a3b=
a2f90f878)

Regressions Summary
-------------------

platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-baylibre | gcc-8    | versatile_defconfig=
 | 1          =

qemu_arm-versatilepb | arm  | lab-broonie  | gcc-8    | versatile_defconfig=
 | 1          =

qemu_arm-versatilepb | arm  | lab-cip      | gcc-8    | versatile_defconfig=
 | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.19.y/ker=
nel/v4.19.189-16-g5a3ba2f90f878/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.19.y
  Describe: v4.19.189-16-g5a3ba2f90f878
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      5a3ba2f90f8789162a03e07a37224bab4c643d1d =



Test Regressions
---------------- =



platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-baylibre | gcc-8    | versatile_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/6092c6d5337d0413b26f546a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
89-16-g5a3ba2f90f878/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qe=
mu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
89-16-g5a3ba2f90f878/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qe=
mu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6092c6d5337d0413b26f5=
46b
        failing since 168 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =



platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-broonie  | gcc-8    | versatile_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/6092c6cc465a0eeb7a6f5471

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
89-16-g5a3ba2f90f878/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
89-16-g5a3ba2f90f878/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6092c6cc465a0eeb7a6f5=
472
        failing since 168 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =



platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-cip      | gcc-8    | versatile_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/6092c6e1b25c2fafc76f5475

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
89-16-g5a3ba2f90f878/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
89-16-g5a3ba2f90f878/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6092c6e1b25c2fafc76f5=
476
        failing since 168 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =20
