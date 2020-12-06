Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 169442D0621
	for <lists+stable@lfdr.de>; Sun,  6 Dec 2020 17:55:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726762AbgLFQzF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Dec 2020 11:55:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726186AbgLFQzE (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 6 Dec 2020 11:55:04 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E21BC0613D0
        for <stable@vger.kernel.org>; Sun,  6 Dec 2020 08:54:18 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id hk16so6048694pjb.4
        for <stable@vger.kernel.org>; Sun, 06 Dec 2020 08:54:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=KOMx0nG5rKaU4r/bgqrivMh/wGdWvn/TbsPCgzKa0Tg=;
        b=0vPsrIWgcC8yHeFAc41yYhxSj4WUzXc+qaUGBoma9nZZNuclcMQrVjB3eAnDFqKV2V
         nbqKx3KTFH40ZihhIuYVjmnVG4N32d2C1pSGINFeQtvFTWhODSprZ86HNMqvQcQANRe0
         rLCURxhvAd5Kwtbr5YurAsse6p1T+UTvTPYqsDeh9jOz/ob1baeaAmLcWNK9hoGRhtOO
         ioETi4epHB/uu35YVXEXGhFaWnknidV7tX0LwygupVmR6v95uLR4p+yy/P20aqyKvWox
         1JlECCx0hcekhgCwUt0cvmF2VYtYuZKMAX1OLRO0vtH7HKF6U8V4nKlIrXn9zVmt6F0z
         HZ2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=KOMx0nG5rKaU4r/bgqrivMh/wGdWvn/TbsPCgzKa0Tg=;
        b=HYdvGZFkTzkEttLIu4cIvylotKyQyfOVZlQdBTw7ysQmNHhUizNC1wxaO43CtLwpUy
         d5LWdG45YQW1hpTmJigIlZAFzcuJXwveGykpR1YoQtwOoawxgNXN2+hq8wti6fSffuJx
         MuCL8fPBzBJlRNuAoy570xwmU3w0YkyRka6Nr+tehNR5v+PeuczxQvYURC/8yUZeVVqa
         GhD6U9b15yY/JwIrbjUjpbbV00zTA04wt/M58VTVJtzuTc4jadbcQisXXX+QW6sF1pb6
         XF4m0GjVHjLlFGWl4Exs3PAwdoqO/t6YW0lCq/lOkGshE4wqWWD2nWsRv9ih3gxBo6d4
         B6wQ==
X-Gm-Message-State: AOAM5303njLcEgPW79Zwvaun7De7ykGwGISa9b3IBrYaNcRLkeONSjqn
        2PfpjUiX40J1JuBW8HFdFgl+BapgJJSqDw==
X-Google-Smtp-Source: ABdhPJyJ7cO2XdCagOvDyqI52U3n26t292ilngiyrXKnCk7oU1W5TYswjEhcKQvEHFYaUtzk3EdOaA==
X-Received: by 2002:a17:902:b688:b029:d9:d374:68d with SMTP id c8-20020a170902b688b02900d9d374068dmr12477584pls.9.1607273657419;
        Sun, 06 Dec 2020 08:54:17 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id c3sm9988457pgm.41.2020.12.06.08.54.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Dec 2020 08:54:16 -0800 (PST)
Message-ID: <5fcd0cb8.1c69fb81.80fbf.6416@mx.google.com>
Date:   Sun, 06 Dec 2020 08:54:16 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.4
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.4.247-12-g559c117bf41f
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.4 baseline: 112 runs,
 11 regressions (v4.4.247-12-g559c117bf41f)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 baseline: 112 runs, 11 regressions (v4.4.247-12-g559c11=
7bf41f)

Regressions Summary
-------------------

platform            | arch | lab           | compiler | defconfig          =
 | regressions
--------------------+------+---------------+----------+--------------------=
-+------------
panda               | arm  | lab-collabora | gcc-8    | omap2plus_defconfig=
 | 1          =

qemu_arm-virt-gicv2 | arm  | lab-baylibre  | gcc-8    | multi_v7_defconfig =
 | 1          =

qemu_arm-virt-gicv2 | arm  | lab-broonie   | gcc-8    | multi_v7_defconfig =
 | 1          =

qemu_arm-virt-gicv2 | arm  | lab-cip       | gcc-8    | multi_v7_defconfig =
 | 1          =

qemu_arm-virt-gicv2 | arm  | lab-collabora | gcc-8    | multi_v7_defconfig =
 | 1          =

qemu_arm-virt-gicv3 | arm  | lab-baylibre  | gcc-8    | multi_v7_defconfig =
 | 1          =

qemu_arm-virt-gicv3 | arm  | lab-broonie   | gcc-8    | multi_v7_defconfig =
 | 1          =

qemu_arm-virt-gicv3 | arm  | lab-cip       | gcc-8    | multi_v7_defconfig =
 | 1          =

qemu_arm-virt-gicv3 | arm  | lab-collabora | gcc-8    | multi_v7_defconfig =
 | 1          =

qemu_i386           | i386 | lab-baylibre  | gcc-8    | i386_defconfig     =
 | 1          =

qemu_i386-uefi      | i386 | lab-baylibre  | gcc-8    | i386_defconfig     =
 | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.4/kern=
el/v4.4.247-12-g559c117bf41f/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.4
  Describe: v4.4.247-12-g559c117bf41f
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      559c117bf41f6c326a563c755f04331d94fa1fd3 =



Test Regressions
---------------- =



platform            | arch | lab           | compiler | defconfig          =
 | regressions
--------------------+------+---------------+----------+--------------------=
-+------------
panda               | arm  | lab-collabora | gcc-8    | omap2plus_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/5fccdaa5618af70310c94ce6

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.247-1=
2-g559c117bf41f/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.247-1=
2-g559c117bf41f/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5fccdaa5618af70=
310c94ceb
        failing since 2 days (last pass: v4.4.247-4-ga92d60286ae0, first fa=
il: v4.4.247-4-gef81364d5eda)
        2 lines =

 =



platform            | arch | lab           | compiler | defconfig          =
 | regressions
--------------------+------+---------------+----------+--------------------=
-+------------
qemu_arm-virt-gicv2 | arm  | lab-baylibre  | gcc-8    | multi_v7_defconfig =
 | 1          =


  Details:     https://kernelci.org/test/plan/id/5fccdaad73fa8d67f5c94cb9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.247-1=
2-g559c117bf41f/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm=
-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.247-1=
2-g559c117bf41f/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm=
-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fccdaad73fa8d67f5c94=
cba
        failing since 22 days (last pass: v4.4.243-18-gfc7e8c68369a, first =
fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch | lab           | compiler | defconfig          =
 | regressions
--------------------+------+---------------+----------+--------------------=
-+------------
qemu_arm-virt-gicv2 | arm  | lab-broonie   | gcc-8    | multi_v7_defconfig =
 | 1          =


  Details:     https://kernelci.org/test/plan/id/5fccdabb73fa8d67f5c94ccb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.247-1=
2-g559c117bf41f/arm/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-=
virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.247-1=
2-g559c117bf41f/arm/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-=
virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fccdabb73fa8d67f5c94=
ccc
        failing since 22 days (last pass: v4.4.243-18-gfc7e8c68369a, first =
fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch | lab           | compiler | defconfig          =
 | regressions
--------------------+------+---------------+----------+--------------------=
-+------------
qemu_arm-virt-gicv2 | arm  | lab-cip       | gcc-8    | multi_v7_defconfig =
 | 1          =


  Details:     https://kernelci.org/test/plan/id/5fccdaa3a0daaf245fc94cb9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.247-1=
2-g559c117bf41f/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-virt=
-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.247-1=
2-g559c117bf41f/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-virt=
-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fccdaa3a0daaf245fc94=
cba
        failing since 22 days (last pass: v4.4.243-18-gfc7e8c68369a, first =
fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch | lab           | compiler | defconfig          =
 | regressions
--------------------+------+---------------+----------+--------------------=
-+------------
qemu_arm-virt-gicv2 | arm  | lab-collabora | gcc-8    | multi_v7_defconfig =
 | 1          =


  Details:     https://kernelci.org/test/plan/id/5fccdac973fa8d67f5c94cda

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.247-1=
2-g559c117bf41f/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-qemu_ar=
m-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.247-1=
2-g559c117bf41f/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-qemu_ar=
m-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fccdac973fa8d67f5c94=
cdb
        failing since 22 days (last pass: v4.4.243-18-gfc7e8c68369a, first =
fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch | lab           | compiler | defconfig          =
 | regressions
--------------------+------+---------------+----------+--------------------=
-+------------
qemu_arm-virt-gicv3 | arm  | lab-baylibre  | gcc-8    | multi_v7_defconfig =
 | 1          =


  Details:     https://kernelci.org/test/plan/id/5fccdad30bd1c4f9c8c94cca

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.247-1=
2-g559c117bf41f/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm=
-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.247-1=
2-g559c117bf41f/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm=
-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fccdad30bd1c4f9c8c94=
ccb
        failing since 22 days (last pass: v4.4.243-18-gfc7e8c68369a, first =
fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch | lab           | compiler | defconfig          =
 | regressions
--------------------+------+---------------+----------+--------------------=
-+------------
qemu_arm-virt-gicv3 | arm  | lab-broonie   | gcc-8    | multi_v7_defconfig =
 | 1          =


  Details:     https://kernelci.org/test/plan/id/5fccdb84caf626acffc94cce

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.247-1=
2-g559c117bf41f/arm/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-=
virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.247-1=
2-g559c117bf41f/arm/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-=
virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fccdb84caf626acffc94=
ccf
        failing since 22 days (last pass: v4.4.243-18-gfc7e8c68369a, first =
fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch | lab           | compiler | defconfig          =
 | regressions
--------------------+------+---------------+----------+--------------------=
-+------------
qemu_arm-virt-gicv3 | arm  | lab-cip       | gcc-8    | multi_v7_defconfig =
 | 1          =


  Details:     https://kernelci.org/test/plan/id/5fccdaf9d3102bde2fc94cc3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.247-1=
2-g559c117bf41f/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-virt=
-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.247-1=
2-g559c117bf41f/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-virt=
-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fccdaf9d3102bde2fc94=
cc4
        failing since 22 days (last pass: v4.4.243-18-gfc7e8c68369a, first =
fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch | lab           | compiler | defconfig          =
 | regressions
--------------------+------+---------------+----------+--------------------=
-+------------
qemu_arm-virt-gicv3 | arm  | lab-collabora | gcc-8    | multi_v7_defconfig =
 | 1          =


  Details:     https://kernelci.org/test/plan/id/5fccdacb73fa8d67f5c94cdd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.247-1=
2-g559c117bf41f/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-qemu_ar=
m-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.247-1=
2-g559c117bf41f/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-qemu_ar=
m-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fccdacb73fa8d67f5c94=
cde
        failing since 22 days (last pass: v4.4.243-18-gfc7e8c68369a, first =
fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch | lab           | compiler | defconfig          =
 | regressions
--------------------+------+---------------+----------+--------------------=
-+------------
qemu_i386           | i386 | lab-baylibre  | gcc-8    | i386_defconfig     =
 | 1          =


  Details:     https://kernelci.org/test/plan/id/5fccda937e661eff2fc94cf2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.247-1=
2-g559c117bf41f/i386/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i386.t=
xt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.247-1=
2-g559c117bf41f/i386/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i386.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fccda937e661eff2fc94=
cf3
        failing since 0 day (last pass: v4.4.247-4-gef81364d5eda, first fai=
l: v4.4.247-9-ged127671ab0e) =

 =



platform            | arch | lab           | compiler | defconfig          =
 | regressions
--------------------+------+---------------+----------+--------------------=
-+------------
qemu_i386-uefi      | i386 | lab-baylibre  | gcc-8    | i386_defconfig     =
 | 1          =


  Details:     https://kernelci.org/test/plan/id/5fccda78e714e81094c94cd1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.247-1=
2-g559c117bf41f/i386/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i386-u=
efi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.247-1=
2-g559c117bf41f/i386/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i386-u=
efi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fccda78e714e81094c94=
cd2
        new failure (last pass: v4.4.247-9-ged127671ab0e) =

 =20
