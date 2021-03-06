Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB88732FDF5
	for <lists+stable@lfdr.de>; Sun,  7 Mar 2021 00:09:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229854AbhCFXIH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 6 Mar 2021 18:08:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229758AbhCFXHp (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 6 Mar 2021 18:07:45 -0500
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A618BC06174A
        for <stable@vger.kernel.org>; Sat,  6 Mar 2021 15:07:45 -0800 (PST)
Received: by mail-pg1-x529.google.com with SMTP id x29so3890174pgk.6
        for <stable@vger.kernel.org>; Sat, 06 Mar 2021 15:07:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=hoXPFnaybAsFurGvBOZHTXlhB9V/qMYubV8VHWqigwc=;
        b=lvL975t+nbZ1gR2XUrYgKvEGN3C6JfZCYX6gWxVW5r53FowMF1q+MEPSFl16mz21+3
         PqxM+NVuazhAeXMphyysaFK/MewudVoUaKfLeDIXLXbmXe5HSqsIfu9g2jDHt37/8NUB
         assaiKr+SjckYUhnWzEXbILz/cgjn/j+ycTF3AESf2SupZOX7I4mNY8D8oJi8JDWxvVb
         hpnzrJUUOqn0QO8amUyqvXP+slz2SZZC4CXmIWeBpWMQU+F3xjEhWwrzBLXHlAhxKoUR
         +UJHjuNSehExUCvnS1gb25T+rO8iA9zvmS7+HbPM90FJhmS1dffVbiq6XNUEIH2/LWOo
         0tFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=hoXPFnaybAsFurGvBOZHTXlhB9V/qMYubV8VHWqigwc=;
        b=i5mW7ywNxA9xyK1baH8UxdQml7pnBuRYqEfy+6YKs/QeTyMkQaH6dlsdSUfheriHk2
         c/n0tIXM5ike4YPPPBFtORuUwcswYF+DVS5p8DHs1WLgvbGECDQcLC7yaXtNCxZ1qUSV
         b3Hzti737aXeg2kt/iHcP8rt1E8IK7zghn+CaREOkfLK2+vR2tvI3DrcdyVvKynBrOno
         BkTU4sdZLgNRUyzitTA99/maTWsMciv/H+KC5gWEC4TPYggRR4xNmLJ/tQnnys/cQ9fV
         HsM8/MIwAk+cG+lX0RC1NhGvamLptfak8JMKI/ILCQxDPWmhxYeG1oQyqMZfsdrI8IlB
         sGDw==
X-Gm-Message-State: AOAM531pztl7YIB6xn0I+wLNVIn9DnXyWw0sgAwuzlv7RM1wS8oqyPp0
        le6YMLu9KVU/4EQ2/Jp9lyxk8PF4siGj+Q==
X-Google-Smtp-Source: ABdhPJwWFHv7GBJ/U2q+G+/vxj53AeLMpFSX50Qoa0ff47nSQeKgaH4MpUytwftiPkwaaXSCODIrUQ==
X-Received: by 2002:a63:225f:: with SMTP id t31mr6519812pgm.371.1615072064855;
        Sat, 06 Mar 2021 15:07:44 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id e10sm6350574pgd.63.2021.03.06.15.07.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 06 Mar 2021 15:07:44 -0800 (PST)
Message-ID: <60440b40.1c69fb81.1f610.fe96@mx.google.com>
Date:   Sat, 06 Mar 2021 15:07:44 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.223-39-gff915c477268b
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.14
Subject: stable-rc/queue/4.14 baseline: 93 runs,
 5 regressions (v4.14.223-39-gff915c477268b)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 93 runs, 5 regressions (v4.14.223-39-gff915c=
477268b)

Regressions Summary
-------------------

platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
fsl-ls2088a-rdb      | arm64 | lab-nxp         | gcc-8    | defconfig      =
     | 1          =

qemu_arm-versatilepb | arm   | lab-broonie     | gcc-8    | versatile_defco=
nfig | 1          =

qemu_arm-versatilepb | arm   | lab-cip         | gcc-8    | versatile_defco=
nfig | 1          =

qemu_arm-versatilepb | arm   | lab-collabora   | gcc-8    | versatile_defco=
nfig | 1          =

qemu_arm-versatilepb | arm   | lab-linaro-lkft | gcc-8    | versatile_defco=
nfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.223-39-gff915c477268b/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.223-39-gff915c477268b
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      ff915c477268b1cf21c70dbc492ef8f4e54f970e =



Test Regressions
---------------- =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
fsl-ls2088a-rdb      | arm64 | lab-nxp         | gcc-8    | defconfig      =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/6043db9fb313408457addcbe

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.223=
-39-gff915c477268b/arm64/defconfig/gcc-8/lab-nxp/baseline-fsl-ls2088a-rdb.t=
xt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.223=
-39-gff915c477268b/arm64/defconfig/gcc-8/lab-nxp/baseline-fsl-ls2088a-rdb.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6043db9fb313408457add=
cbf
        new failure (last pass: v4.14.223-39-gddab7a93ed6a1) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-broonie     | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/6043d6e3a3157949c2addcc4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.223=
-39-gff915c477268b/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.223=
-39-gff915c477268b/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6043d6e3a3157949c2add=
cc5
        failing since 112 days (last pass: v4.14.206-21-g787a7a3ca16c, firs=
t fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-cip         | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/6043d707fda52af38aaddcd3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.223=
-39-gff915c477268b/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.223=
-39-gff915c477268b/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6043d707fda52af38aadd=
cd4
        failing since 112 days (last pass: v4.14.206-21-g787a7a3ca16c, firs=
t fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-collabora   | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/6043d6806648ec3b3eaddcb5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.223=
-39-gff915c477268b/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.223=
-39-gff915c477268b/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6043d6806648ec3b3eadd=
cb6
        failing since 112 days (last pass: v4.14.206-21-g787a7a3ca16c, firs=
t fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-linaro-lkft | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/6043d693bc6caed7b1addcbb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.223=
-39-gff915c477268b/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-q=
emu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.223=
-39-gff915c477268b/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-q=
emu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6043d693bc6caed7b1add=
cbc
        failing since 112 days (last pass: v4.14.206-21-g787a7a3ca16c, firs=
t fail: v4.14.206-22-ga949bf40fb01) =

 =20
