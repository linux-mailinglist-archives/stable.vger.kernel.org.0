Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D2E43615DC
	for <lists+stable@lfdr.de>; Fri, 16 Apr 2021 01:11:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236672AbhDOXLQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Apr 2021 19:11:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235086AbhDOXLQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Apr 2021 19:11:16 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95269C061574
        for <stable@vger.kernel.org>; Thu, 15 Apr 2021 16:10:52 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id p67so12141156pfp.10
        for <stable@vger.kernel.org>; Thu, 15 Apr 2021 16:10:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=OzU+S9DdnDtuXGdjt7QqJBcoeU/CYaHvIIpLTKbLFPI=;
        b=SUh4pgwKQT2NB9z55vMv1HC3Imt2diFjnVaheFOBW7y83GOR5Cz6+XgTUydk6CzU6Z
         zI0NkyWGL1xT4SEH2dXAUcD1WMaEcwEEROhgzVRz/sQp1wmS4gDsSU1wHUMrb//6/Dre
         SylSM85rDip5IGwN/j2qgWRupIZ2Jz1VxtUB03I6wkIUF8V3KMJgsjM+kkpQgLeCX6sB
         Oz13SxEJ3RxXMVa+0MUeB2fYKqWTbMdKh/A5d1cKPw+viImJzkQxmShe/GOqHusWhL/F
         rRVC0tUaKTqnXpjMoJkHT3ROlAy61z1Nk5AMK7RdWouHRQvzFBWOvwreC9uD5Kv4kiU4
         2Grw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=OzU+S9DdnDtuXGdjt7QqJBcoeU/CYaHvIIpLTKbLFPI=;
        b=or49+4M3+PILQk1I9KylcLdL/JN3n/zBOGqwkn2JbhveUuaYHoIEWewsgA0+C64Xls
         mxkG5XQiedye+jAllddEqTdmmfmtuPvP0J3B3qTW682qmEXpjue3k/LUYBdoDCtpe7iI
         5T+cFPQiss7LXq7vb32jLq1tvUjoMEpHiIJndFulLBks5YLMjgjfDeXOUgcF/pfIMvFY
         Aj5HSnzDvcSC7RpLXX45iTIhez68qdJqZdR55VknOGlQHww12mIpLpd+LMgi+LxdlPCZ
         BqVUtRohDLUOaWWxZpewgUew5uEWtAlzeft4mYKbJpi8EPHgtKpqLTDnJGmQ5QQ6t/uj
         7XyQ==
X-Gm-Message-State: AOAM531vNJEL22IwQw9j3SWnfLHSfixnSmzcuTXGk8/TNwXLmwbOrutq
        k5GdfG1qCJdq1l/I4b/ruS+Pi1FRqaz1RUWZ
X-Google-Smtp-Source: ABdhPJyLUPP1LMNhCxDtMuMQxebt14fa+9tAYgKw7xeDxL6PG23qF01/69de//+O17SpSWkUu6+6rQ==
X-Received: by 2002:a62:2f43:0:b029:253:b67f:2eb2 with SMTP id v64-20020a622f430000b0290253b67f2eb2mr5311551pfv.75.1618528251832;
        Thu, 15 Apr 2021 16:10:51 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id t24sm3286637pgi.30.2021.04.15.16.10.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Apr 2021 16:10:51 -0700 (PDT)
Message-ID: <6078c7fb.1c69fb81.c409b.9f6d@mx.google.com>
Date:   Thu, 15 Apr 2021 16:10:51 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.9.266-48-g5183cf83a541
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.9.y baseline: 112 runs,
 5 regressions (v4.9.266-48-g5183cf83a541)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y baseline: 112 runs, 5 regressions (v4.9.266-48-g5183c=
f83a541)

Regressions Summary
-------------------

platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-baylibre  | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-broonie   | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-cip       | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-collabora | gcc-8    | versatile_defconf=
ig | 1          =

r8a7795-salvator-x   | arm64 | lab-baylibre  | gcc-8    | defconfig        =
   | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.9.y/kern=
el/v4.9.266-48-g5183cf83a541/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.9.y
  Describe: v4.9.266-48-g5183cf83a541
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      5183cf83a541a4684e52ca704658b93e63fdf243 =



Test Regressions
---------------- =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-baylibre  | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/60788d486d257e8909dac6b2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.266=
-48-g5183cf83a541/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.266=
-48-g5183cf83a541/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60788d486d257e8909dac=
6b3
        failing since 152 days (last pass: v4.9.243-17-g9c24315b745a0, firs=
t fail: v4.9.243-26-g7b603f689c1c) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-broonie   | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/60788d6909011f4d00dac6c5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.266=
-48-g5183cf83a541/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.266=
-48-g5183cf83a541/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60788d6909011f4d00dac=
6c6
        failing since 152 days (last pass: v4.9.243-17-g9c24315b745a0, firs=
t fail: v4.9.243-26-g7b603f689c1c) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-cip       | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/60788d3cb56f1814b7dac6dd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.266=
-48-g5183cf83a541/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.266=
-48-g5183cf83a541/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60788d3cb56f1814b7dac=
6de
        failing since 152 days (last pass: v4.9.243-17-g9c24315b745a0, firs=
t fail: v4.9.243-26-g7b603f689c1c) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-collabora | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/60788ccd8d0cff27fcdac6b1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.266=
-48-g5183cf83a541/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.266=
-48-g5183cf83a541/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60788ccd8d0cff27fcdac=
6b2
        failing since 152 days (last pass: v4.9.243-17-g9c24315b745a0, firs=
t fail: v4.9.243-26-g7b603f689c1c) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
r8a7795-salvator-x   | arm64 | lab-baylibre  | gcc-8    | defconfig        =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/60788d626aaebc961adac6be

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.266=
-48-g5183cf83a541/arm64/defconfig/gcc-8/lab-baylibre/baseline-r8a7795-salva=
tor-x.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.266=
-48-g5183cf83a541/arm64/defconfig/gcc-8/lab-baylibre/baseline-r8a7795-salva=
tor-x.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60788d626aaebc961adac=
6bf
        failing since 148 days (last pass: v4.9.243-17-g9c24315b745a0, firs=
t fail: v4.9.243-79-gd3e70b39d31a) =

 =20
