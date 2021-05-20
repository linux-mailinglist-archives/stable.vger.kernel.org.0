Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A3EC38B856
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 22:24:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236771AbhETUZY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 16:25:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235410AbhETUZY (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 May 2021 16:25:24 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 656BBC061574
        for <stable@vger.kernel.org>; Thu, 20 May 2021 13:24:02 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id c17so13233363pfn.6
        for <stable@vger.kernel.org>; Thu, 20 May 2021 13:24:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=YXkQGSYkj+RRNWo+g1cQqYFSqGwt6uLDuK5f/RHoQxs=;
        b=2A2PcuqXkgMjRn6u4sMgK0wFAKE7o1lxTdczG4dRXqkxLo1rjEYtpXiiJ1zgCPqu10
         iBJAiWlmu3LPlisJyYLMEzfB4ZEDsayhFwxHmDs3YsIKReGspz6EulRuy9546Cd8vgnf
         2D6BgvxIeitcrVij+HdM/03udAJgc4nmkXmRi9S2npPYXdDDSalw6dcXLJH4QF1iNIZL
         Er2DfntLyvbkffM18OAFVqm7ub0F0L0V7L4l/ef4eL69IDH7TRxiwLOqXPmSwXi5S+8i
         k2XjwQDo886mbrgsGpEp13+R2swI8snkPG4GC9xSvCia7xRC0WTlZQdQf0okX4rNJTQ7
         y0OA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=YXkQGSYkj+RRNWo+g1cQqYFSqGwt6uLDuK5f/RHoQxs=;
        b=XMTAV+2KqwyKX4of7Gp7g8xti0t1dbVgeLZMLnvsa6MHk8BnM6h6ZjfKs1hK0S9NxJ
         Mfca4/HkOLL5w38JJDsc2xVXnOWZjYFo8TfhizVzRvYHjgqQD+zJ8X/QOk960/w84T9B
         n6UnLzwh7aB6VyO+PvkJjkTZjMdL+xEX1Wms1YMNaMrLxK/JaFIXtsc6H2Wu7Iol0iSb
         UN0Cv0zu1mmvIRrRjUBdiQAzKNVXQ3CWqDRk6g6QxH2oxHpdh3sLm9A+wLYMWszy/qwk
         ySQGuTnkm4Ncggz3GaEQ9cjs3udyQ7m1AYiHbJF2n7DNgXCKnaTS4CqGWHo/rq9Ysi31
         upQw==
X-Gm-Message-State: AOAM531P0qT2Xg1lqAafPXU6MJSTJtGJ/KiBnJZF0DqbvTxVhDCs4U38
        AMm+bEsA7J00toCKkdvxf/A3rHG+uUn1K0g0
X-Google-Smtp-Source: ABdhPJzLxx/T/xvbAfknsTEaG+1ts11edC/3mKh0ZTeTREafcl+I/M6u9oEEAfErZ0T12QWAOHdCmQ==
X-Received: by 2002:a63:9612:: with SMTP id c18mr6345215pge.29.1621542241799;
        Thu, 20 May 2021 13:24:01 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id t22sm7195882pjr.43.2021.05.20.13.24.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 May 2021 13:24:01 -0700 (PDT)
Message-ID: <60a6c561.1c69fb81.29168.91cf@mx.google.com>
Date:   Thu, 20 May 2021 13:24:01 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.9.268-239-gc3b58ee120f7
X-Kernelci-Branch: queue/4.9
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.9 baseline: 104 runs,
 4 regressions (v4.9.268-239-gc3b58ee120f7)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 104 runs, 4 regressions (v4.9.268-239-gc3b58e=
e120f7)

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.268-239-gc3b58ee120f7/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.268-239-gc3b58ee120f7
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      c3b58ee120f736ccc8ffd359f8462c6267aeebd4 =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60a69235ea7d902002b3afa9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.268-2=
39-gc3b58ee120f7/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.268-2=
39-gc3b58ee120f7/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60a69235ea7d902002b3a=
faa
        failing since 187 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60a691d8fa97af5a7db3afa7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.268-2=
39-gc3b58ee120f7/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.268-2=
39-gc3b58ee120f7/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60a691d8fa97af5a7db3a=
fa8
        failing since 187 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60a69284c96d597736b3afa7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.268-2=
39-gc3b58ee120f7/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.268-2=
39-gc3b58ee120f7/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60a69284c96d597736b3a=
fa8
        failing since 187 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60a69339aeebde8e19b3afb1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.268-2=
39-gc3b58ee120f7/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.268-2=
39-gc3b58ee120f7/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60a69339aeebde8e19b3a=
fb2
        failing since 187 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =20
