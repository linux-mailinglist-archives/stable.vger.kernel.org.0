Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C56C31B314
	for <lists+stable@lfdr.de>; Sun, 14 Feb 2021 23:40:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230052AbhBNWj5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 14 Feb 2021 17:39:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229789AbhBNWj4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 14 Feb 2021 17:39:56 -0500
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66A36C061574
        for <stable@vger.kernel.org>; Sun, 14 Feb 2021 14:39:16 -0800 (PST)
Received: by mail-pf1-x42e.google.com with SMTP id w18so3075235pfu.9
        for <stable@vger.kernel.org>; Sun, 14 Feb 2021 14:39:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=jbQ4CVpfd4zFASXJtWFQ0WEoGYwu0g0NQRcUgKfI/QY=;
        b=U/rL4sfUWLIgAsi1ArNz9kPPPOkEOlvSr+HL3J7WK6ZxRNZbOvGrMdChxBj8CpJzjh
         NLCDyvsDE8MqAc4Jv5ID871u3LVgBt2/dOO5dDgNC2q+9qoARpdjoPpxUZIusGpZ5trU
         S6sxYPLeofAL76ULOqJ9WKL9a+euU3aXRZtBmlVHW2OlFDGSSkRydNSwivuRAqDp+usG
         fe6hkhs5BXlKaZMLE/WUcBVt0FbQlpX8mCgp0SNel2gDNDabUIzHUkCH4AOAKopuRIkP
         7ber5QiQAFX1ZLs3VTDs6eUz6Yw4nC2xhtvWzEdzGd55Y9gVLdzFzwD3nC8DvDxc2x22
         XUWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=jbQ4CVpfd4zFASXJtWFQ0WEoGYwu0g0NQRcUgKfI/QY=;
        b=V2NDhp74rZPUxQQ93uu9y1xGydYqC/saiSsTUmxiRoPP9+EqPnUHNvqlMncZ0IiPVA
         +zlDzMDIQMxmXGUbrE/QY530gXQwtyLb0Emc7Hli/OXXAK90iwTIH9PXJv0qMTwTbN4I
         vo9hGqfclrG7ETE1Oorx1o4wq09Im57y9yySxVjQ+FrpOxbIlocK1aueK1DN8Aicx9t9
         RlLg8VYtpBjGR7MLqA+kn72JYBjt4wrexZx/RRpmzTA0a7yMZlGQM4Z/uux0RvfUIwdu
         /cn/+w1P17kLiUkVSeS230JE7JZLFnTAzO16Pkrimf6FwXQU4evoDd6KsfIje0uBMz2J
         mbSA==
X-Gm-Message-State: AOAM531gKM3mtu48iWsxwm/H5GruIOoPRNVbm1ctjxUBaB4Pimmu2J6o
        MgPkmL/lxdBMXlbWfFqQAHVMW9XOju92MA==
X-Google-Smtp-Source: ABdhPJzQsdyOCS54bprmOqhLTVr0LhpOxt8udTpPEXWZAvg3iICd+22kyXZvpPWuxQi7SBotmV72Aw==
X-Received: by 2002:a63:5952:: with SMTP id j18mr12587351pgm.29.1613342355667;
        Sun, 14 Feb 2021 14:39:15 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id e12sm15119859pjj.23.2021.02.14.14.39.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 14 Feb 2021 14:39:15 -0800 (PST)
Message-ID: <6029a693.1c69fb81.e31f7.017a@mx.google.com>
Date:   Sun, 14 Feb 2021 14:39:15 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.14.221-28-g014cf8e02a4c
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.14
Subject: stable-rc/queue/4.14 baseline: 61 runs,
 2 regressions (v4.14.221-28-g014cf8e02a4c)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 61 runs, 2 regressions (v4.14.221-28-g014cf8=
e02a4c)

Regressions Summary
-------------------

platform       | arch  | lab           | compiler | defconfig           | r=
egressions
---------------+-------+---------------+----------+---------------------+--=
----------
meson-gxm-q200 | arm64 | lab-baylibre  | gcc-8    | defconfig           | 1=
          =

panda          | arm   | lab-collabora | gcc-8    | omap2plus_defconfig | 1=
          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.221-28-g014cf8e02a4c/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.221-28-g014cf8e02a4c
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      014cf8e02a4c917c2d8a0d9291c93dde93bc857f =



Test Regressions
---------------- =



platform       | arch  | lab           | compiler | defconfig           | r=
egressions
---------------+-------+---------------+----------+---------------------+--=
----------
meson-gxm-q200 | arm64 | lab-baylibre  | gcc-8    | defconfig           | 1=
          =


  Details:     https://kernelci.org/test/plan/id/60297967a449cd131c3abea6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.221=
-28-g014cf8e02a4c/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q20=
0.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.221=
-28-g014cf8e02a4c/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q20=
0.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60297967a449cd131c3ab=
ea7
        failing since 68 days (last pass: v4.14.210-20-gc32b9f7cbda7, first=
 fail: v4.14.210-20-g5ea7913395d3) =

 =



platform       | arch  | lab           | compiler | defconfig           | r=
egressions
---------------+-------+---------------+----------+---------------------+--=
----------
panda          | arm   | lab-collabora | gcc-8    | omap2plus_defconfig | 1=
          =


  Details:     https://kernelci.org/test/plan/id/602974fac4c089a2523abe62

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.221=
-28-g014cf8e02a4c/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.221=
-28-g014cf8e02a4c/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/602974fac4c089a=
2523abe69
        failing since 8 days (last pass: v4.14.219-15-g82c6ae41b66a6, first=
 fail: v4.14.219-15-g8b9453943a205)
        2 lines

    2021-02-14 19:07:34.874000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xffffed34 [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =20
