Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C5AA36376A
	for <lists+stable@lfdr.de>; Sun, 18 Apr 2021 21:59:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232148AbhDRUAS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Apr 2021 16:00:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229488AbhDRUAR (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 18 Apr 2021 16:00:17 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39E5FC06174A
        for <stable@vger.kernel.org>; Sun, 18 Apr 2021 12:59:49 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id h11so4129623pfn.0
        for <stable@vger.kernel.org>; Sun, 18 Apr 2021 12:59:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=X6ySwvlbkhoiycu/XQ8MP8uTAxxjK7xBaZw3ZZaYnl0=;
        b=slcq68O+XYndU9lBFrmOv5ie4J+D838ClqpHSDdeliKXh2h+Jd9p8mXGtkk0OQo2a3
         eUnM1R8O66X759LbMg8dVqDr/rMJKZzop+CbB4dmq43l6lnKISxBEGgDB5PlZfKz50RM
         2PNIHj9vhEiWapdT6ZKXtoKku4azPM95ji4VY/J2EMNyNjD8Fy2Mv8A6zX/0dfu28GOa
         ynqz4UM+vL07HMhS00LVEhUBJMfWLPJOMIz/vGQaHYv0iwajyPadsXGUg5fyKBAR7a/O
         6d/cp8OHcpuoz75LlUE+kv+GhrztZ0t9a0ZwRq1SrzSKxq9AEgsdRKN+yqQIZeJyVijZ
         k/Sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=X6ySwvlbkhoiycu/XQ8MP8uTAxxjK7xBaZw3ZZaYnl0=;
        b=qYDtkqtRZKp7j/CBnSbAB8GgUkW9wNU4t/5N91hfGJXRbLUHL77VGc8OpoKEQAoQBH
         AsQjbYbodjuO/5FARqTLQYaM0Lh+T8jpI8xjfUJ5eb+ykBBpFJXXC1Ax4VClETXMf6uD
         muufCqxspLh6P0KfmSi9pVMryJofQGzL7py0n3cAgm3CH/WN595KvPjY+jEHrVeeTAdJ
         bg+26HYV3r+Sjo52DNyuMy+ERH5P2XgFT+nmZj9W0EQKDd73JkrymvCIL887HKUHapOf
         9CqJirQ0z6wlU9+KRQN01kwd67tnJ4Jp6x7v8+SZ4EJzTplM8U/K/td30ZuPAvs99BKL
         3oFQ==
X-Gm-Message-State: AOAM5307I40y3xntAwE9h32/h+uPb75oMO7GVRZQBPHg4wuUEi9iZoA4
        7U9Kqk01+iEV29cmkPMZlHVLgW0rPqvM5vVE
X-Google-Smtp-Source: ABdhPJx+qnVCjsyCEDVprDmn+YsAllT2NiPU9iE4Za14nMKQPeWlLbMJPyindFuUSQuSGsvxwy6hVg==
X-Received: by 2002:a65:5b87:: with SMTP id i7mr8248450pgr.315.1618775988463;
        Sun, 18 Apr 2021 12:59:48 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id l10sm10332426pfc.125.2021.04.18.12.59.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 Apr 2021 12:59:48 -0700 (PDT)
Message-ID: <607c8fb4.1c69fb81.15a3e.b2e5@mx.google.com>
Date:   Sun, 18 Apr 2021 12:59:48 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.9.267-19-gf35581a21fd0
X-Kernelci-Branch: queue/4.9
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.9 baseline: 44 runs,
 4 regressions (v4.9.267-19-gf35581a21fd0)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 44 runs, 4 regressions (v4.9.267-19-gf35581a2=
1fd0)

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
el/v4.9.267-19-gf35581a21fd0/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.267-19-gf35581a21fd0
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      f35581a21fd04210f6db010c7277efc22d6846d1 =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/607c2cd47b7b779d00dac6b1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.267-1=
9-gf35581a21fd0/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.267-1=
9-gf35581a21fd0/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/607c2cd47b7b779d00dac=
6b2
        failing since 155 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/607c2cd44c1e5434eddac6b1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.267-1=
9-gf35581a21fd0/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.267-1=
9-gf35581a21fd0/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/607c2cd44c1e5434eddac=
6b2
        failing since 155 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/607c2c6851c3944c2cdac6b8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.267-1=
9-gf35581a21fd0/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.267-1=
9-gf35581a21fd0/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/607c2c6851c3944c2cdac=
6b9
        failing since 155 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/607c2c18087ab3af77dac6bf

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.267-1=
9-gf35581a21fd0/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.267-1=
9-gf35581a21fd0/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/607c2c18087ab3af77dac=
6c0
        failing since 155 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =20
