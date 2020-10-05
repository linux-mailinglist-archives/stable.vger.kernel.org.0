Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B3EC2842A4
	for <lists+stable@lfdr.de>; Tue,  6 Oct 2020 00:46:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725870AbgJEWqC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Oct 2020 18:46:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725846AbgJEWqC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Oct 2020 18:46:02 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07FF5C0613CE
        for <stable@vger.kernel.org>; Mon,  5 Oct 2020 15:46:02 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id x16so6889883pgj.3
        for <stable@vger.kernel.org>; Mon, 05 Oct 2020 15:46:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=BXwIL8PAyxxrQAi9XZq8PREN3Qh0hK89akZJjLExRKA=;
        b=HXF/51ivKR20JUnJmJ6pNODcZYZs4RWa0gZJFX3Z2YZZ7As9DPFpuOLzV4S3kYYPK6
         xwA5UocltTjzwlbtkv0+ZQDGouxG1vzJ/mI/4Vopx47GAreuClwroDkG4V4Wk3bewFQN
         TnY5I6qW1rJVgLwvJXSlmYUj7ZYN+0zU9KPviHawcW0SmUBwha6L24pNH0fRlfJBzrWT
         PM8NJ26coxQtz/ZPTzzvoX1LOGuj0LyfeMEyORqfSvOO6/y8IDsIO0aItG1J8YsAwSJe
         XBEm6trsN2zvFVFliZ4hzxMYA4CnGa4lmSb/8fXXOUOOeHaePua4OtQKv7rE+tx3g2Ii
         Yo+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=BXwIL8PAyxxrQAi9XZq8PREN3Qh0hK89akZJjLExRKA=;
        b=lmoRkOZRlY1UkaEJ4qNz6WnwZAzHSGIn+xD2QmOXN65Cv+9Xs3GTfQMHjGqJJwVQ1R
         eeKHREK7xCjHkNO9uRi/4UwiGQYVRCnJD/KVfLIKsA+49uJJMiyifj89qzbc+FwWujvt
         xJpC1uZL52h0Sn/irRYhcq71kcGY8nFcGYVhOej+jzr4VWGnm+WkghBxVOofDYYExJL/
         lvLw4Rg10uziqkbo0CQ1K6cMFDGzWG+bX+LoTApKPTnRBpNzdPlV47tET98turj8XN+1
         QLsE76o9TM5GJxpP6DNDIr3IgXb2NJnwIHFwfcjd4sjeN6KcC2YbL11ctrCTtNHb7pcZ
         zL6Q==
X-Gm-Message-State: AOAM532tii/soucCC3nYYUCx2PLJHGp7RtqQ5R5azlD7rnHUMxGQik76
        XBPSQh91gXo6l0MAVTrPURqoWVQv/ROfLA==
X-Google-Smtp-Source: ABdhPJzWyY/k48ulmWRu6U68u/ikjzQWwzqjJMPMWyKyC1D9asPmM2Lcc2njRpr6jlQ0buzLqc5BKg==
X-Received: by 2002:a63:758:: with SMTP id 85mr1489749pgh.336.1601937961029;
        Mon, 05 Oct 2020 15:46:01 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id j12sm608020pjn.29.2020.10.05.15.45.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Oct 2020 15:46:00 -0700 (PDT)
Message-ID: <5f7ba228.1c69fb81.3d2c4.19b8@mx.google.com>
Date:   Mon, 05 Oct 2020 15:46:00 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.14.200-31-g8a81fe854906
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.14.y baseline: 98 runs,
 3 regressions (v4.14.200-31-g8a81fe854906)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y baseline: 98 runs, 3 regressions (v4.14.200-31-g8a81=
fe854906)

Regressions Summary
-------------------

platform              | arch  | lab           | compiler | defconfig       =
    | results
----------------------+-------+---------------+----------+-----------------=
----+--------
at91-sama5d4_xplained | arm   | lab-baylibre  | gcc-8    | sama5_defconfig =
    | 0/1    =

meson-gxbb-p200       | arm64 | lab-baylibre  | gcc-8    | defconfig       =
    | 0/1    =

panda                 | arm   | lab-collabora | gcc-8    | omap2plus_defcon=
fig | 3/5    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.14.y/ker=
nel/v4.14.200-31-g8a81fe854906/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.14.y
  Describe: v4.14.200-31-g8a81fe854906
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      8a81fe8549065d549e5d7b443df873ba13b0744f =



Test Regressions
---------------- =



platform              | arch  | lab           | compiler | defconfig       =
    | results
----------------------+-------+---------------+----------+-----------------=
----+--------
at91-sama5d4_xplained | arm   | lab-baylibre  | gcc-8    | sama5_defconfig =
    | 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f7b66ad23e7bd81714ff409

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sama5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
00-31-g8a81fe854906/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sa=
ma5d4_xplained.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
00-31-g8a81fe854906/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sa=
ma5d4_xplained.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-3-g27eeeac7da2d/armel/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f7b66ad23e7bd81714ff=
40a
      failing since 73 days (last pass: v4.14.188-126-g5b1e982af0f8, first =
fail: v4.14.189)  =



platform              | arch  | lab           | compiler | defconfig       =
    | results
----------------------+-------+---------------+----------+-----------------=
----+--------
meson-gxbb-p200       | arm64 | lab-baylibre  | gcc-8    | defconfig       =
    | 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f7b66b3d2adf179ca4ff3e0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
00-31-g8a81fe854906/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-=
p200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
00-31-g8a81fe854906/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-=
p200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-3-g27eeeac7da2d/arm64/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f7b66b3d2adf179ca4ff=
3e1
      failing since 188 days (last pass: v4.14.172-114-g734382e2d26e, first=
 fail: v4.14.174-131-g234ce78cac23)  =



platform              | arch  | lab           | compiler | defconfig       =
    | results
----------------------+-------+---------------+----------+-----------------=
----+--------
panda                 | arm   | lab-collabora | gcc-8    | omap2plus_defcon=
fig | 3/5    =


  Details:     https://kernelci.org/test/plan/id/5f7b69e64b795539934ff3fc

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
00-31-g8a81fe854906/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pa=
nda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
00-31-g8a81fe854906/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pa=
nda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-3-g27eeeac7da2d/armel/baseline/rootfs.cpio.gz =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5f7b69e64b79553=
9934ff403
      failing since 3 days (last pass: v4.14.199-167-g7b80cb61f2b2, first f=
ail: v4.14.200)
      2 lines  =20
