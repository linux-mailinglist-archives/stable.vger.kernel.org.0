Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E25EE3F52B0
	for <lists+stable@lfdr.de>; Mon, 23 Aug 2021 23:18:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232748AbhHWVTY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Aug 2021 17:19:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232503AbhHWVTY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 Aug 2021 17:19:24 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 680BAC061575
        for <stable@vger.kernel.org>; Mon, 23 Aug 2021 14:18:41 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id j1so12819813pjv.3
        for <stable@vger.kernel.org>; Mon, 23 Aug 2021 14:18:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=zYRck1fyVMRy4qW40NMxQmxrdfwpHufKVemCYbuW3kQ=;
        b=ih5dnFdTAVL6CnnipF+wkY1BqZxKrrKEzQW3L3am3etWlSb92QyIeh+pjLsOj9JZVB
         PMPkgfYgtj6yls57Zh4e4oygpMQtaAkpTbbF7eFuhYlLWNf4/i8S34PD4nsZvKN9Irgu
         KlmfeTXnP1l9rbJvmbpc0tWht2mc0Pp4lbtA9dbRHveYGvrwQOhYDZgVPIlQbOSMdCw2
         9EsSZx8JXDRqy9nCwWVtqn4hpZVieo1piFLZJYsdv4sIURRsYMuTyIyMrxLNiLSiorBw
         gwgoZcH62Ya4Yw5KhxphGqtjR7HauM+X+qY3W1ggvrXwq1Sxw9aGviQguplEcNId3Qn5
         BHpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=zYRck1fyVMRy4qW40NMxQmxrdfwpHufKVemCYbuW3kQ=;
        b=ge7cqdd9RHdrrs3fJ2yk+uZ2QEKCbioXhG+Z0mIZtYm7AJKd7s4NJArXG8qziiQB86
         ZwcW2cT60cIKYbbZlilaTy3LulJvdvJbm7W5Izv3mKDcdrC6BaWhS0E4HcPf0wqQtRd5
         2CFgZntikkdikQrhs8dWXpOYyQJeQWPLn+ExLHWG4Q5ceqLqcOK3NCag24zRDqKxnPRR
         3yz+U2HfGy9TlYgnwO5wgTIYfSiZrtceHG7b3MXMLISwMnOjvdFdCnnf8pztH0a8mzTa
         D1NvtJHHJZCFmUw+iM42XyB6QRm5Iqhbgug3+97s4/w5bnjbNS/QTm8ZgavQNMcOaayR
         Ow2w==
X-Gm-Message-State: AOAM531tMQ0SIKhPBcYpdw8d7NUkHwrrYsnJ0hITBuyve75/y8Zn1m/U
        eaUqSmIeTmMH9Yr5CJN98tpSrqinMWnKkY4L
X-Google-Smtp-Source: ABdhPJx+3wQwhR18PGOQfCjYEyVhBY9K5k2SRF0Jhs5DhnDNCdlr8kLdoPN24ONmLgDvkj3akA/8Yw==
X-Received: by 2002:a17:90a:8809:: with SMTP id s9mr588349pjn.44.1629753520856;
        Mon, 23 Aug 2021 14:18:40 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id f5sm17345231pfe.128.2021.08.23.14.18.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Aug 2021 14:18:40 -0700 (PDT)
Message-ID: <612410b0.1c69fb81.2c26.2965@mx.google.com>
Date:   Mon, 23 Aug 2021 14:18:40 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.9
X-Kernelci-Kernel: v4.9.280-34-g2660ee18b71c
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.9 baseline: 155 runs,
 5 regressions (v4.9.280-34-g2660ee18b71c)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 155 runs, 5 regressions (v4.9.280-34-g2660ee1=
8b71c)

Regressions Summary
-------------------

platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.280-34-g2660ee18b71c/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.280-34-g2660ee18b71c
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      2660ee18b71c5729c29415fc7b084c26fb7dba59 =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6123d9300a6c5e45ea8e2cc7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.280-3=
4-g2660ee18b71c/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.280-3=
4-g2660ee18b71c/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6123d9300a6c5e45ea8e2=
cc8
        failing since 282 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6123f92939f2f03de88e2c85

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.280-3=
4-g2660ee18b71c/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.280-3=
4-g2660ee18b71c/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6123f92939f2f03de88e2=
c86
        failing since 282 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6123d98363b7df5a188e2c94

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.280-3=
4-g2660ee18b71c/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.280-3=
4-g2660ee18b71c/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6123d98363b7df5a188e2=
c95
        failing since 282 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6123d5b6b5e87d66a48e2cae

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.280-3=
4-g2660ee18b71c/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.280-3=
4-g2660ee18b71c/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6123d5b6b5e87d66a48e2=
caf
        failing since 282 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6123d45a34f7174f2b8e2c82

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.280-3=
4-g2660ee18b71c/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.280-3=
4-g2660ee18b71c/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6123d45a34f7174f2b8e2=
c83
        failing since 282 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =20
