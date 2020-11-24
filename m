Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C5732C31AF
	for <lists+stable@lfdr.de>; Tue, 24 Nov 2020 21:08:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730083AbgKXUHv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Nov 2020 15:07:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726433AbgKXUHu (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Nov 2020 15:07:50 -0500
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7964C0613D6
        for <stable@vger.kernel.org>; Tue, 24 Nov 2020 12:07:50 -0800 (PST)
Received: by mail-pl1-x62e.google.com with SMTP id x15so11254916pll.2
        for <stable@vger.kernel.org>; Tue, 24 Nov 2020 12:07:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=/CNRy2DqqNRaHbRc20xpz6dH3xDvt17nbUW/odGCfJE=;
        b=GjcqE+1NIV0p6hASKYNxMLHV2kTqb7ridzpaxVHgEmIwcva7WZPGkMWmWSpBwkskeD
         9crqjjrsf2phY99k76g+PD+mh+R9MrYjjrmvxMuhzZK8PeWyCWbZYvK+wKDLPtgyCDBQ
         Lf4xpoABsquGVtdiVt5XEWdsKxOsbQswY1Afeq6npydKz4+atprswbPsTh9BYFg7aCbs
         kuESo1Q4p+3rpKtqSoppzETatqt37b7IhwQtcTrRaNWeYhC1jaOXnhbkR2x3IS4eC4ms
         92/GljKSUQAx4BkZycTNVP67v2CXukALVC0fRVCkldUqxixSxrCTWj6lLTbyPMj8or1j
         S4kA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=/CNRy2DqqNRaHbRc20xpz6dH3xDvt17nbUW/odGCfJE=;
        b=fDnwOMcuTwueVwxAn4vAew9OCdQhoJR68WiG3s7KeJlrKNYgdduUrB/ZRVJmisrNpv
         tN/AwOJJJTHGWY/C/pkEZ9CeKpX6L+SAtxVfN3qWT09uaenl8vKdElEahEs3bH/oIopk
         u6H3xk/O9Qzv72odh9ngmH2OI9EOK/i3kVbLWK6u7UJ61wxY7/9ntjWfutWxfV/o17t9
         frWjnwDR3ToameX2EYumhGXkw3Z02dXXa5Sscu9HmVGvfXp5OnkIiUxO5GTEABWhvdLk
         Cbo7dswlxeQgfHzc/5rsrJ76DnDhF4Pu5+z874Ovq46PmLeCBtEDuWtlnH+9XJzwwXeG
         hZUQ==
X-Gm-Message-State: AOAM531UXi5625BwiK86Empmid+dI+4GniJkja/799LInw/EgSBHkS21
        lG0h5Y6cPJV2o9ELBu6uQ4vxzahh9DCwyA==
X-Google-Smtp-Source: ABdhPJxYkiIqjOEg2skRbciw5lFdm2upBfUTff05m3iI7GHyveInvltQzJx4OE/MlBs21XfHreIW+A==
X-Received: by 2002:a17:902:860c:b029:da:1ba0:3979 with SMTP id f12-20020a170902860cb02900da1ba03979mr29639plo.8.1606248469823;
        Tue, 24 Nov 2020 12:07:49 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id q126sm16402378pfc.168.2020.11.24.12.07.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Nov 2020 12:07:48 -0800 (PST)
Message-ID: <5fbd6814.1c69fb81.d1e5d.5bbd@mx.google.com>
Date:   Tue, 24 Nov 2020 12:07:48 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Tree: stable
X-Kernelci-Kernel: v5.4.80
X-Kernelci-Report-Type: test
Subject: stable/linux-5.4.y baseline: 195 runs, 7 regressions (v5.4.80)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.4.y baseline: 195 runs, 7 regressions (v5.4.80)

Regressions Summary
-------------------

platform              | arch  | lab           | compiler | defconfig       =
    | regressions
----------------------+-------+---------------+----------+-----------------=
----+------------
at91-sama5d4_xplained | arm   | lab-baylibre  | gcc-8    | sama5_defconfig =
    | 1          =

beagle-xm             | arm   | lab-baylibre  | gcc-8    | multi_v7_defconf=
ig  | 1          =

hifive-unleashed-a00  | riscv | lab-baylibre  | gcc-8    | defconfig       =
    | 1          =

qemu_arm-versatilepb  | arm   | lab-baylibre  | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb  | arm   | lab-broonie   | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb  | arm   | lab-cip       | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb  | arm   | lab-collabora | gcc-8    | versatile_defcon=
fig | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.4.y/kernel/=
v5.4.80/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.4.y
  Describe: v5.4.80
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      9f4b26f3ea18cb2066c9e58a84ff202c71739a41 =



Test Regressions
---------------- =



platform              | arch  | lab           | compiler | defconfig       =
    | regressions
----------------------+-------+---------------+----------+-----------------=
----+------------
at91-sama5d4_xplained | arm   | lab-baylibre  | gcc-8    | sama5_defconfig =
    | 1          =


  Details:     https://kernelci.org/test/plan/id/5fbd3475984ffaeac7c94cc7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sama5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.80/arm=
/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5d4_xplained.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.80/arm=
/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5d4_xplained.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fbd3475984ffaeac7c94=
cc8
        failing since 159 days (last pass: v5.4.46, first fail: v5.4.47) =

 =



platform              | arch  | lab           | compiler | defconfig       =
    | regressions
----------------------+-------+---------------+----------+-----------------=
----+------------
beagle-xm             | arm   | lab-baylibre  | gcc-8    | multi_v7_defconf=
ig  | 1          =


  Details:     https://kernelci.org/test/plan/id/5fbd60809975ce8211c94cc6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.80/arm=
/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-beagle-xm.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.80/arm=
/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-beagle-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fbd60809975ce8211c94=
cc7
        new failure (last pass: v5.4.79) =

 =



platform              | arch  | lab           | compiler | defconfig       =
    | regressions
----------------------+-------+---------------+----------+-----------------=
----+------------
hifive-unleashed-a00  | riscv | lab-baylibre  | gcc-8    | defconfig       =
    | 1          =


  Details:     https://kernelci.org/test/plan/id/5fbd33615ba10053b8c94cd7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (riscv64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.80/ris=
cv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleashed-a00.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.80/ris=
cv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleashed-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/riscv/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fbd33615ba10053b8c94=
cd8
        failing since 5 days (last pass: v5.4.77, first fail: v5.4.78) =

 =



platform              | arch  | lab           | compiler | defconfig       =
    | regressions
----------------------+-------+---------------+----------+-----------------=
----+------------
qemu_arm-versatilepb  | arm   | lab-baylibre  | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fbd33dfb9c910f91ac94cba

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.80/arm=
/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.80/arm=
/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fbd33dfb9c910f91ac94=
cbb
        failing since 5 days (last pass: v5.4.77, first fail: v5.4.78) =

 =



platform              | arch  | lab           | compiler | defconfig       =
    | regressions
----------------------+-------+---------------+----------+-----------------=
----+------------
qemu_arm-versatilepb  | arm   | lab-broonie   | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fbd33f6cf38f6a5cbc94cda

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.80/arm=
/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.80/arm=
/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fbd33f6cf38f6a5cbc94=
cdb
        failing since 5 days (last pass: v5.4.77, first fail: v5.4.78) =

 =



platform              | arch  | lab           | compiler | defconfig       =
    | regressions
----------------------+-------+---------------+----------+-----------------=
----+------------
qemu_arm-versatilepb  | arm   | lab-cip       | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fbd3402b9c910f91ac94cf7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.80/arm=
/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.80/arm=
/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fbd3402b9c910f91ac94=
cf8
        failing since 5 days (last pass: v5.4.77, first fail: v5.4.78) =

 =



platform              | arch  | lab           | compiler | defconfig       =
    | regressions
----------------------+-------+---------------+----------+-----------------=
----+------------
qemu_arm-versatilepb  | arm   | lab-collabora | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fbd33cfd599ff48a7c94d59

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.80/arm=
/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.80/arm=
/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fbd33cfd599ff48a7c94=
d5a
        failing since 5 days (last pass: v5.4.77, first fail: v5.4.78) =

 =20
