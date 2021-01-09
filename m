Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 462D22F035B
	for <lists+stable@lfdr.de>; Sat,  9 Jan 2021 21:14:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726005AbhAIUOE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 9 Jan 2021 15:14:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726001AbhAIUOE (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 9 Jan 2021 15:14:04 -0500
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02FF9C061786
        for <stable@vger.kernel.org>; Sat,  9 Jan 2021 12:13:24 -0800 (PST)
Received: by mail-pl1-x62b.google.com with SMTP id x12so7440083plr.10
        for <stable@vger.kernel.org>; Sat, 09 Jan 2021 12:13:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=C/INbGpwqpIXcv8uF6EpqcXSOOxo/jrx99lzhmeOg5g=;
        b=A+0ldQcl8T3oZWdgVWRWZmpWKGm/XJKQnOq7egTRNeRkY3KtH9DXzCkCXYwyfGRU4K
         pHiQvgzXSLqRfNa677WKpYrGExtFsz8AWx76xvsCPCxiUff9IQaeUr+5Hsy2lDLYM+UZ
         t8M0n8e36U7UES7gZbWC6IofKzKCSSU9YYqOUk1uG1jn6nJAppt64P9WuhDr5F17YuF1
         4dRfQ0i7G9huUy1LDrNXudBK5DznGLSH1PbnfxGtdoHHg2Rz9s0Y8x/mQQQbMVCmr2Ny
         LxROphB0rBBMuuMP3NCpUkUCv+g+Jl2nfFWYgBw+dPbiPM17ONj0S9zuP2utWbGMdaAP
         VDOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=C/INbGpwqpIXcv8uF6EpqcXSOOxo/jrx99lzhmeOg5g=;
        b=F1UNxlQmcpdddYg2F5FmaHKEv2ZEaOppXFBYhJ1i/TUQx4j8prj0mwcAMbEOa0NvJ4
         ozKsozLHAjKfCXXDssEU/krjfBSyNNhWdX8KjLl5i7sK7CdF8PK0wrod0Eatyw4ATezj
         VLfEtK0AHhb36+LApNWoat8ChtaPNenHnaVHQYsg4yvod8ldcOW7ZODtiAsKxdRH1JOZ
         SYnDK+EKi2uW4CwWj+llubKMZpqtBoYE4JnP3rvmkA9vKhtaHAO/fndcj1WtKGgWWWEF
         vcOlxLa/VNUx8EoUvyfxKFIpZeIvshGC51Z3DbfBAowdg+wx3i/tYP4GTuAmgThViRG1
         O5Fw==
X-Gm-Message-State: AOAM532511Q7k9mRRbGIx3vfq7bGI+yBlddDMJkDpYK7JsKrDCgnhXte
        MxCWzxgJuR0AyvMIZA1YGcoVlfP4c5ep/A==
X-Google-Smtp-Source: ABdhPJy35Bfw7q3Sa2UAqahfr4WniLNgegeZ0AwAfYdNrG/Efdi1wxbiW6AAX+171g/6lYx64mChfg==
X-Received: by 2002:a17:90a:bd13:: with SMTP id y19mr9782713pjr.24.1610223203232;
        Sat, 09 Jan 2021 12:13:23 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id o123sm13780783pfd.197.2021.01.09.12.13.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 09 Jan 2021 12:13:22 -0800 (PST)
Message-ID: <5ffa0e62.1c69fb81.d04ea.e5d0@mx.google.com>
Date:   Sat, 09 Jan 2021 12:13:22 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.9
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.9.250-3-gad22df8e1d0e
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.9 baseline: 115 runs,
 4 regressions (v4.9.250-3-gad22df8e1d0e)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 115 runs, 4 regressions (v4.9.250-3-gad22df8e=
1d0e)

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
el/v4.9.250-3-gad22df8e1d0e/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.250-3-gad22df8e1d0e
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      ad22df8e1d0e9499ba7beee16d0ad7fce893db4c =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/5ff9d9e7ca4180c8f2c94cc0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.250-3=
-gad22df8e1d0e/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.250-3=
-gad22df8e1d0e/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5ff9d9e7ca4180c8f2c94=
cc1
        failing since 56 days (last pass: v4.9.243-16-gd8d67e375b0a, first =
fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/5ff9d9fcb729bece2cc94dd3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.250-3=
-gad22df8e1d0e/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-=
versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.250-3=
-gad22df8e1d0e/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-=
versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5ff9d9fcb729bece2cc94=
dd4
        failing since 56 days (last pass: v4.9.243-16-gd8d67e375b0a, first =
fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/5ff9d9f8047ed98321c94cbd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.250-3=
-gad22df8e1d0e/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-vers=
atilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.250-3=
-gad22df8e1d0e/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-vers=
atilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5ff9d9f8047ed98321c94=
cbe
        failing since 56 days (last pass: v4.9.243-16-gd8d67e375b0a, first =
fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/5ff9d9d057cfafdc0cc94cda

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.250-3=
-gad22df8e1d0e/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.250-3=
-gad22df8e1d0e/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5ff9d9d057cfafdc0cc94=
cdb
        failing since 56 days (last pass: v4.9.243-16-gd8d67e375b0a, first =
fail: v4.9.243-25-ga01fe8e99a22) =

 =20
