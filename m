Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1A2F35FE8A
	for <lists+stable@lfdr.de>; Thu, 15 Apr 2021 01:44:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229596AbhDNXoz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Apr 2021 19:44:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229573AbhDNXoz (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Apr 2021 19:44:55 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F0FEC061574
        for <stable@vger.kernel.org>; Wed, 14 Apr 2021 16:44:33 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id y2so11030032plg.5
        for <stable@vger.kernel.org>; Wed, 14 Apr 2021 16:44:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Kbs6IfLAPKXHmXubKWHKovpLJH8eA8uLO93q/K5lCdw=;
        b=wgNkENLqM7dPwzmpJg3yTrHf3kuQQeTP2kOBk42tRO+X38XwRMkQzgSKApgzFkQqAr
         VQd6dNN7Up0FKSN+MtMRbTNl+dW8TWz2MpJFffCvlP8Ku0RNfqpAD+6T45pa6C27gbFt
         SG/c0W964n3l29YefjCPGUyIxmwT+/0QaHvEnnKlGcOEGUrCJn1pOW6+b9j3ijdfY/2g
         CsXqmdUXbYv73bWWIxF1E/6y91YTBkWX+hC41rfp0jV8uGqMkKE5YiwbR+AXXP1nFtBt
         W2FQTpI8vhx9GVWTNgOgvCSEGYgH5XBuwS+JN54QAaXOC411q7DmQ6ztj8yCSXYk0C81
         GZYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Kbs6IfLAPKXHmXubKWHKovpLJH8eA8uLO93q/K5lCdw=;
        b=YVL53ShRuxlKKg1Wfw3yCa1NGIIVkAQvFhhcV7q09GIxo5p/YR46OJzwju4KmvyHPc
         V0NuC/Inq+L+zl87yTxP51tXQMy9JIXI6/sWwkCwT4fERXQOE9mFVLvH0V9/qmdV0zEI
         OewZCqqCVToEqPLAy06OEfuuktaxInmxr/5DjojaFLFVSok0RRl5DosZocfirgBepFbb
         o/hfOjg16+wUpJbzI96SjDsKKfeRjiectVm9bIts/MaXqSVR81LhxdDzdAUJl92krJbC
         DbY84ayJ+3HUJPxAAv+QkGznTbZ4b+Pq//BLcXzq0ZEZEEkxSF/nbgKOL7glpjNgw4ah
         552w==
X-Gm-Message-State: AOAM5308Q/ixy/SK2LgbiQzc8rKNFUJZarcQuUnLXuNVxPOXXo1fzg9A
        WGZsPc2P3UFneyyuboDGgjOYHwBgqLzjXTvS
X-Google-Smtp-Source: ABdhPJzX8SudmLYnTopgeY34/4Xz6QIx8U6m78mz0SpFP4YQybGGXHxV2z7qFsi/L6M3Bm020qF3Cg==
X-Received: by 2002:a17:90a:b112:: with SMTP id z18mr691023pjq.18.1618443872962;
        Wed, 14 Apr 2021 16:44:32 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b67sm418539pfb.37.2021.04.14.16.44.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Apr 2021 16:44:32 -0700 (PDT)
Message-ID: <60777e60.1c69fb81.9fdb.21de@mx.google.com>
Date:   Wed, 14 Apr 2021 16:44:32 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.9.266-44-g7c3ef782e2f1f
X-Kernelci-Branch: queue/4.9
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.9 baseline: 106 runs,
 4 regressions (v4.9.266-44-g7c3ef782e2f1f)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 106 runs, 4 regressions (v4.9.266-44-g7c3ef78=
2e2f1f)

Regressions Summary
-------------------

platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.266-44-g7c3ef782e2f1f/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.266-44-g7c3ef782e2f1f
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      7c3ef782e2f1f834f67d6f2067bf95135d4b151e =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6077441e017af327c1dac6b2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.266-4=
4-g7c3ef782e2f1f/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.266-4=
4-g7c3ef782e2f1f/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6077441e017af327c1dac=
6b3
        failing since 151 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6077445ba56df36cfedac6c8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.266-4=
4-g7c3ef782e2f1f/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.266-4=
4-g7c3ef782e2f1f/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6077445ba56df36cfedac=
6c9
        failing since 151 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/607743ce4e3e337d87dac6c3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.266-4=
4-g7c3ef782e2f1f/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.266-4=
4-g7c3ef782e2f1f/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/607743ce4e3e337d87dac=
6c4
        failing since 151 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/607755d6dc5b90755fdac6cf

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.266-4=
4-g7c3ef782e2f1f/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.266-4=
4-g7c3ef782e2f1f/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/607755d6dc5b90755fdac=
6d0
        failing since 151 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =20
