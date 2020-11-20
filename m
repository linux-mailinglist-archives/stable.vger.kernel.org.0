Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90E642BB158
	for <lists+stable@lfdr.de>; Fri, 20 Nov 2020 18:26:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728353AbgKTRWz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Nov 2020 12:22:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727222AbgKTRWz (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 Nov 2020 12:22:55 -0500
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E666C0613CF
        for <stable@vger.kernel.org>; Fri, 20 Nov 2020 09:22:55 -0800 (PST)
Received: by mail-pg1-x52a.google.com with SMTP id i13so7826834pgm.9
        for <stable@vger.kernel.org>; Fri, 20 Nov 2020 09:22:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ZVu0t5Bu8nfiRebP0c24scs+R4io1RrPEPhONLXDzIg=;
        b=kdHzn46DI4lcSpa5tKazrnJD8QNxFQak6egAAdWQxcTxJPu971xqk2xk508whpOnlu
         sNrvNN0yFOyCdpylhW6FcPF/kE+Kfm6EyleVICvdv0VuO7ilN/ub9YYYmZdMwOfgRZl/
         QiLNjeRRW1S2xZI8y3pj6WR2WAR2wxMdqnoysS9NJUmOqkU0M5cLvWxXhfVkP53ltULj
         ZP9SnrB/vhZ/6w4h48uQu6Ci5fnjo/WKyNXD3lnO1HqRPH2QPxpNthnp2RNXoRJ6jNeL
         w+NKbkfRMOevMcX4Nmld5P/a4/KdO3Vy4O376OuLx/oGWEdGIkxur+8FDtTlbhV5p+iA
         G+dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ZVu0t5Bu8nfiRebP0c24scs+R4io1RrPEPhONLXDzIg=;
        b=adqJam6u9EqUZrz5S+WLk76x+9AUx/4KuUvJTcBFrQbqCEVjne0Cy0BfyqLFFLSiAU
         J+jM7A4MKDwJWKpmaVmtfZqCKlpacbxR/lWXKnfymSrmxQol15jr9p7h0IDCgVfByT74
         mdNvYN+NnWgVYtwd677ZEM6sdahNS+wdqS2YNNN03sF/wUEvXpnWtnY7GjvC1rd3XZub
         WqMMTV7n5Yv+C3vDzujl8yuHwAzCuHohuM8g6bonuSgBA2vmRn1lFE6muCqMBeHY8Otm
         fC+Ud4Vp5MtX/7TIk2Wf+WkqDBqTK7+99tkkYYkgnOOKhZr5+QL9uPwaTSwAU6PP8ZjO
         tQZw==
X-Gm-Message-State: AOAM533fWz6qCwUw5Lu3IrvkXvcD17QPaSkggVaECLV30okQeK2uzJ+8
        xWIcMGi6nJTT8HMppwDOewffE55sF59Fig==
X-Google-Smtp-Source: ABdhPJwraId35MzAZWp1RaY6DDk3WnrxRAVAOqxu7QJ24bN38QMlrJPGYJbXIISTKosfP3MxqIJzPw==
X-Received: by 2002:a63:904:: with SMTP id 4mr13209244pgj.338.1605892974622;
        Fri, 20 Nov 2020 09:22:54 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id d2sm4304314pji.7.2020.11.20.09.22.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Nov 2020 09:22:52 -0800 (PST)
Message-ID: <5fb7fb6c.1c69fb81.5ac3d.7b37@mx.google.com>
Date:   Fri, 20 Nov 2020 09:22:52 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.14.207-18-g5602fbd93fec
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.14
Subject: stable-rc/queue/4.14 baseline: 128 runs,
 3 regressions (v4.14.207-18-g5602fbd93fec)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 128 runs, 3 regressions (v4.14.207-18-g5602f=
bd93fec)

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.207-18-g5602fbd93fec/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.207-18-g5602fbd93fec
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      5602fbd93fec4652696d61892a31a7ff7794dde6 =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/5fb7c6f3d591c149dad8d917

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.207=
-18-g5602fbd93fec/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.207=
-18-g5602fbd93fec/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fb7c6f3d591c149dad8d=
918
        failing since 6 days (last pass: v4.14.206-21-g787a7a3ca16c, first =
fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/5fb7c6f5d591c149dad8d91a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.207=
-18-g5602fbd93fec/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.207=
-18-g5602fbd93fec/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fb7c6f5d591c149dad8d=
91b
        failing since 6 days (last pass: v4.14.206-21-g787a7a3ca16c, first =
fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/5fb7c6a369f0da8516d8d91f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.207=
-18-g5602fbd93fec/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.207=
-18-g5602fbd93fec/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fb7c6a369f0da8516d8d=
920
        failing since 6 days (last pass: v4.14.206-21-g787a7a3ca16c, first =
fail: v4.14.206-22-ga949bf40fb01) =

 =20
