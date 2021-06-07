Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6729639D309
	for <lists+stable@lfdr.de>; Mon,  7 Jun 2021 04:42:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230175AbhFGCny (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Jun 2021 22:43:54 -0400
Received: from mail-pf1-f175.google.com ([209.85.210.175]:46868 "EHLO
        mail-pf1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230127AbhFGCnx (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 6 Jun 2021 22:43:53 -0400
Received: by mail-pf1-f175.google.com with SMTP id u126so8013277pfu.13
        for <stable@vger.kernel.org>; Sun, 06 Jun 2021 19:41:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=vtU76xTY3EPkKrZ9rxjWeVrAa+kBRdsYiYx+YSo5Suo=;
        b=soTAmL0Vgj7MLlxyGdB8ZvFslFQtlLflcFwohCPD87KC84W4KyRRruJPwTyEii753x
         iPKltIxqn/5Q7aUQEII4plZ5/A7GNjAHxUrdD5RZjiU1siwwI72HW4z0XEa/tAc5tmno
         eLez/A8j6ISUHVVUUPROr+T/OKD/R39exD3ebnF7P2xAmFtyJOr0k2yECeXCPg7nCiK8
         h9ElsnnaywuDMcOGSNSHTcfqR4D+8X5D0A8DPabWwvrba/xcSS39QHparcEM+T2rXFvT
         2WXIezM8+BPmySASVpHiKYCE1QaeDHrI9hIPIdBN8mEFz7ZDLN6TMod2xPM7xQ3Tmhhb
         zw8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=vtU76xTY3EPkKrZ9rxjWeVrAa+kBRdsYiYx+YSo5Suo=;
        b=tClb8hq6m5VkerG3mz8/To1dSQoxMPOB/2bnPdpNdlSYtXhibs/5/EKKVu7XE57BPK
         RGcwijAITP+x3ebJMa03FodBUDQdtk+jWxm95YteI/jBm5/9nqzLGNtNIdZ0Brz+qfEp
         6fZz2c64IEg8EEyYg5c5vIuph27spmEHQmghfKQuRk0qXKPMUg8Xc6LEILhgB3xi6tLG
         7Wr0ub1EkqO3SYIIdekE7y9B9qdsr7rYVpyiNeyqXoeqw5xnjQaWJLWqItQ3YQJlX/UA
         RozXWagrkThpVrM3RA/9q2YOlteoiUif1/hdarw7VGkQbUVvYbxIZHdr5OAFDHvGp/cP
         bGYg==
X-Gm-Message-State: AOAM5314+6kHbk7OSyuqJb8Eig18S/zcKtgbw/wBxZw9ITgBJ7j20BvT
        IVL2Lbs7Ml3NwQBF8Z8O1u8mNHeCOJgGJGtj
X-Google-Smtp-Source: ABdhPJxp04IDgkcI9rSpqUCK/7XmT2qmMB946xPidtT9KsSgolrkQnq35MgisDaCGcVSzEX/M98BgA==
X-Received: by 2002:a63:f40d:: with SMTP id g13mr16137657pgi.290.1623033649755;
        Sun, 06 Jun 2021 19:40:49 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id m2sm10652910pjf.24.2021.06.06.19.40.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Jun 2021 19:40:49 -0700 (PDT)
Message-ID: <60bd8731.1c69fb81.ee157.1d94@mx.google.com>
Date:   Sun, 06 Jun 2021 19:40:49 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.271-12-g3048d41c748e
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.9
Subject: stable-rc/queue/4.9 baseline: 144 runs,
 6 regressions (v4.9.271-12-g3048d41c748e)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 144 runs, 6 regressions (v4.9.271-12-g3048d41=
c748e)

Regressions Summary
-------------------

platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
beaglebone-black     | arm  | lab-collabora   | gcc-8    | multi_v7_defconf=
ig  | 1          =

qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.271-12-g3048d41c748e/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.271-12-g3048d41c748e
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      3048d41c748ec724f3632f3b9af80f9e7f202597 =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
beaglebone-black     | arm  | lab-collabora   | gcc-8    | multi_v7_defconf=
ig  | 1          =


  Details:     https://kernelci.org/test/plan/id/60bd5f691da88be76b0c0e2e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.271-1=
2-g3048d41c748e/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-beagleb=
one-black.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.271-1=
2-g3048d41c748e/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-beagleb=
one-black.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60bd5f691da88be76b0c0=
e2f
        new failure (last pass: v4.9.271-1-g54ce4f464197) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60bd5576648ff80fac0c0e0b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.271-1=
2-g3048d41c748e/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.271-1=
2-g3048d41c748e/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60bd5576648ff80fac0c0=
e0c
        failing since 204 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60bd55c432eff799b90c0e08

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.271-1=
2-g3048d41c748e/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.271-1=
2-g3048d41c748e/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60bd55c432eff799b90c0=
e09
        failing since 204 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60bd5585b1f40630c10c0e07

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.271-1=
2-g3048d41c748e/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.271-1=
2-g3048d41c748e/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60bd5585b1f40630c10c0=
e08
        failing since 204 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60bd5650ad63dc9b3f0c0e36

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.271-1=
2-g3048d41c748e/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.271-1=
2-g3048d41c748e/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60bd5650ad63dc9b3f0c0=
e37
        failing since 204 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60bd55268782d40db60c0e11

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.271-1=
2-g3048d41c748e/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.271-1=
2-g3048d41c748e/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60bd55268782d40db60c0=
e12
        failing since 204 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =20
