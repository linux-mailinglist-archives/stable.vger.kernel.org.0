Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 692624309BE
	for <lists+stable@lfdr.de>; Sun, 17 Oct 2021 16:26:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343855AbhJQO2V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 17 Oct 2021 10:28:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231156AbhJQO2U (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 17 Oct 2021 10:28:20 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E881C061765
        for <stable@vger.kernel.org>; Sun, 17 Oct 2021 07:26:11 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id r2so13354381pgl.10
        for <stable@vger.kernel.org>; Sun, 17 Oct 2021 07:26:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=O/6bec9BlT5n246NzjSZHrqZhksRhfzSnSJgD6Muo+o=;
        b=rS73HSC/erqmnr1OD01a0UHrJWW9iv38A825wflVsRTm45yL23HDjYzAiz8bZwT18x
         QNj9fWTSOPGRmoQePUKNdIc08YpwaKmWJbUn2VT+aPsU83m9q/ytBYKOxCAQtSds72CH
         ldvV4w5fHOJZ8FqJV5Htrc8bKShadxm8MdvyAoQsxL9rmR0dCWTkc4zeycjDDrhPSgOS
         fmFHcY1Df7q75QJDQzkItk673hM8+J1shbMREgmXrtGHLeMK3FfW5oTeH/reFqikiP2o
         AtKSXcA38ulpmxEaOdLsVPHG0SShAED8/9w+7fwFvoTlcGMC4u4TJnPIEydUcoRINtsk
         +XNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=O/6bec9BlT5n246NzjSZHrqZhksRhfzSnSJgD6Muo+o=;
        b=bFLuL/araaZAfA6TXdzf3ixwTPzrlR7i9ZwyvnNVjVgrIcTkNz0XLwvE9zHZxCSmz/
         pu35CImDWaPR07KWpVC60ccUfTgsLRZk5zv9+RzzfOCMGDHjRmZowhwotCV7307BDZmD
         ReEYoSdbAosOmONJFjgqW5wkM+1ETiTDqk4n5M0kduxfOsQXYT/GflA3vf+b9QhimAFf
         Bz5eZZNQlzdbGcyGazfqA726RmzbSdwArbFvxDflUCHWqaYsTwCzs8pgdjW3ICioFMIw
         iV6WULha3Vc8vVStWy9oV8+2USOBgZ2FLGTViihrEH5qQf2rjdtZDbfg3OwkZHgLl93f
         xmng==
X-Gm-Message-State: AOAM531LfE5b5cYUpHrDwvCZkYU527LRptAyPgqYvUgs2IrEwHdcukh0
        cxRxXeRBIBqq2dveGI9VZpgJm48i4w57cSk2
X-Google-Smtp-Source: ABdhPJy32OJ90Hd0cSm8f9GHiYT9W3nunat7i7uprrvzkFvLO4pCf0JJ0tPWxhSaEBlEu6DGTLhdAQ==
X-Received: by 2002:a63:33cb:: with SMTP id z194mr18693985pgz.380.1634480770463;
        Sun, 17 Oct 2021 07:26:10 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id t8sm9992221pgk.66.2021.10.17.07.26.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 Oct 2021 07:26:10 -0700 (PDT)
Message-ID: <616c3282.1c69fb81.ca49b.c6d2@mx.google.com>
Date:   Sun, 17 Oct 2021 07:26:10 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Tree: stable
X-Kernelci-Kernel: v4.9.287
X-Kernelci-Report-Type: test
Subject: stable/linux-4.9.y baseline: 69 runs, 5 regressions (v4.9.287)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.9.y baseline: 69 runs, 5 regressions (v4.9.287)

Regressions Summary
-------------------

platform             | arch   | lab             | compiler | defconfig     =
               | regressions
---------------------+--------+-----------------+----------+---------------=
---------------+------------
qemu_arm-versatilepb | arm    | lab-baylibre    | gcc-8    | versatile_defc=
onfig          | 1          =

qemu_arm-versatilepb | arm    | lab-broonie     | gcc-8    | versatile_defc=
onfig          | 1          =

qemu_arm-versatilepb | arm    | lab-cip         | gcc-8    | versatile_defc=
onfig          | 1          =

qemu_arm-versatilepb | arm    | lab-linaro-lkft | gcc-8    | versatile_defc=
onfig          | 1          =

qemu_x86_64          | x86_64 | lab-broonie     | gcc-8    | x86_64_defcon.=
..6-chromebook | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-4.9.y/kernel/=
v4.9.287/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-4.9.y
  Describe: v4.9.287
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      aa13f01432a22d28998d7e2cd0d197db768db51a =



Test Regressions
---------------- =



platform             | arch   | lab             | compiler | defconfig     =
               | regressions
---------------------+--------+-----------------+----------+---------------=
---------------+------------
qemu_arm-versatilepb | arm    | lab-baylibre    | gcc-8    | versatile_defc=
onfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/616bf20cbf35012aad3358f3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.9.y/v4.9.287/ar=
m/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.9.y/v4.9.287/ar=
m/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/616bf20cbf35012aad335=
8f4
        failing since 332 days (last pass: v4.9.243, first fail: v4.9.244) =

 =



platform             | arch   | lab             | compiler | defconfig     =
               | regressions
---------------------+--------+-----------------+----------+---------------=
---------------+------------
qemu_arm-versatilepb | arm    | lab-broonie     | gcc-8    | versatile_defc=
onfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/616bf2162fa69b95e23358dd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.9.y/v4.9.287/ar=
m/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.9.y/v4.9.287/ar=
m/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/616bf2162fa69b95e2335=
8de
        failing since 332 days (last pass: v4.9.243, first fail: v4.9.244) =

 =



platform             | arch   | lab             | compiler | defconfig     =
               | regressions
---------------------+--------+-----------------+----------+---------------=
---------------+------------
qemu_arm-versatilepb | arm    | lab-cip         | gcc-8    | versatile_defc=
onfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/616bf1f6bf35012aad3358dc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.9.y/v4.9.287/ar=
m/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.9.y/v4.9.287/ar=
m/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/616bf1f6bf35012aad335=
8dd
        failing since 332 days (last pass: v4.9.243, first fail: v4.9.244) =

 =



platform             | arch   | lab             | compiler | defconfig     =
               | regressions
---------------------+--------+-----------------+----------+---------------=
---------------+------------
qemu_arm-versatilepb | arm    | lab-linaro-lkft | gcc-8    | versatile_defc=
onfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/616bf1b815080afb0c3358ec

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.9.y/v4.9.287/ar=
m/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_arm-versatilepb.t=
xt
  HTML log:    https://storage.kernelci.org//stable/linux-4.9.y/v4.9.287/ar=
m/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_arm-versatilepb.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/616bf1b815080afb0c335=
8ed
        failing since 332 days (last pass: v4.9.243, first fail: v4.9.244) =

 =



platform             | arch   | lab             | compiler | defconfig     =
               | regressions
---------------------+--------+-----------------+----------+---------------=
---------------+------------
qemu_x86_64          | x86_64 | lab-broonie     | gcc-8    | x86_64_defcon.=
..6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/616bf970b2939a5fbf3358f3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.9.y/v4.9.287/x8=
6_64/x86_64_defconfig+x86-chromebook/gcc-8/lab-broonie/baseline-qemu_x86_64=
.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.9.y/v4.9.287/x8=
6_64/x86_64_defconfig+x86-chromebook/gcc-8/lab-broonie/baseline-qemu_x86_64=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/616bf970b2939a5fbf335=
8f4
        new failure (last pass: v4.9.286) =

 =20
