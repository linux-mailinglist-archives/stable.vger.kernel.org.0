Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F64A42E915
	for <lists+stable@lfdr.de>; Fri, 15 Oct 2021 08:35:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231315AbhJOGhj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Oct 2021 02:37:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229716AbhJOGhj (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Oct 2021 02:37:39 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51AB0C061570
        for <stable@vger.kernel.org>; Thu, 14 Oct 2021 23:35:33 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id f5so7695674pgc.12
        for <stable@vger.kernel.org>; Thu, 14 Oct 2021 23:35:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=pfb65uMsS7fnyL4XDVcOj93iuDAordUBmWeQJKmmF+4=;
        b=8G70/bGTT888w/N/D5WMW2VUzJqjs3sqbJZ25tYKLjnyxU/wdl1VA5Uxdz8f5yoBtm
         6twMyOOWHlllj1E1T5WmhK1NBkGCQ1Ko1DAbFJFIjXJ1lhtoD088oxqYfr50sH2nx9pn
         vAGDtWFWiKkOERsxZ4rBVzUEKOJ1HDJZU32XwNq8rDaH8/Jng++9t+wH0dAUB5cK2dD8
         tY2EBUUchBTvzYa0FOMSg4vdNF86DO1T0BLGhlmXMzLdug0VStavUIQK0XLKaZE/11o9
         nP2v7WDLpcBwHSKeF8K8Z9sZHPS3SdYpNv00RJStBiBZEkzkdIiTk4mnrzncbqRf+83e
         WafQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=pfb65uMsS7fnyL4XDVcOj93iuDAordUBmWeQJKmmF+4=;
        b=oP3mcPE+XxblAYICyFyMVs1TEhklUsjEdWsPYUzcQm3VdYw2Lhvg9yowQp3lkz9uAY
         p5jrRTeD8yTfHyEAZLJdILVDCRGILgG5VzWPFtnbj37OO+mXJuEXIYtaZZreOueSdUz0
         G9T3q1dufRDOtp8JDk743thkoUI6neM3+nakbc6kvTeb9weklQp8H22tiNIMSqsBYF82
         4EUe998Xx9CBy/2SMqGWJYXPaYFwHQFWEHxprrElEyRWYv7VNBQ/0TiwYfzO7XWBIhfR
         0+puQ0ajhKOMUaqmkHwtAl4F0SLPS2wlfhw1lsDPaOEQ0TZXgfJ0bX1pKjAVWpmanTuX
         stVA==
X-Gm-Message-State: AOAM531Ux/YL7Se3RRQ8q/uegdRcIZiTJKYJA53bXJQg4sj87kZxm1fc
        EJ2Whgoa1EoNVbs/n0Wn7zT6Af8vqOyJHPOM
X-Google-Smtp-Source: ABdhPJwejhC34rEw8StuIZALX2odQZlUJKqGVS1Dx2bOBY7WsuQiOINHN6aJi/qjJ3SxBiifCtJTQQ==
X-Received: by 2002:aa7:83d9:0:b0:44c:915b:8268 with SMTP id j25-20020aa783d9000000b0044c915b8268mr10005623pfn.43.1634279732540;
        Thu, 14 Oct 2021 23:35:32 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id js18sm10760008pjb.3.2021.10.14.23.35.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Oct 2021 23:35:32 -0700 (PDT)
Message-ID: <61692134.1c69fb81.0b55.0928@mx.google.com>
Date:   Thu, 14 Oct 2021 23:35:32 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.4.288-19-gf9c6c370e0b0
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-4.4.y baseline: 59 runs,
 8 regressions (v4.4.288-19-gf9c6c370e0b0)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y baseline: 59 runs, 8 regressions (v4.4.288-19-gf9c6c3=
70e0b0)

Regressions Summary
-------------------

platform            | arch | lab          | compiler | defconfig           =
| regressions
--------------------+------+--------------+----------+---------------------=
+------------
beagle-xm           | arm  | lab-baylibre | gcc-8    | omap2plus_defconfig =
| 2          =

qemu_arm-virt-gicv2 | arm  | lab-baylibre | gcc-8    | multi_v7_defconfig  =
| 1          =

qemu_arm-virt-gicv2 | arm  | lab-broonie  | gcc-8    | multi_v7_defconfig  =
| 1          =

qemu_arm-virt-gicv2 | arm  | lab-cip      | gcc-8    | multi_v7_defconfig  =
| 1          =

qemu_arm-virt-gicv3 | arm  | lab-baylibre | gcc-8    | multi_v7_defconfig  =
| 1          =

qemu_arm-virt-gicv3 | arm  | lab-broonie  | gcc-8    | multi_v7_defconfig  =
| 1          =

qemu_arm-virt-gicv3 | arm  | lab-cip      | gcc-8    | multi_v7_defconfig  =
| 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.4.y/kern=
el/v4.4.288-19-gf9c6c370e0b0/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.4.y
  Describe: v4.4.288-19-gf9c6c370e0b0
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      f9c6c370e0b0668289ebd46e9b1311e1a8b6e7a1 =



Test Regressions
---------------- =



platform            | arch | lab          | compiler | defconfig           =
| regressions
--------------------+------+--------------+----------+---------------------=
+------------
beagle-xm           | arm  | lab-baylibre | gcc-8    | omap2plus_defconfig =
| 2          =


  Details:     https://kernelci.org/test/plan/id/6168e641c2fa6b64823358e4

  Results:     3 PASS, 2 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.288=
-19-gf9c6c370e0b0/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagl=
e-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.288=
-19-gf9c6c370e0b0/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagl=
e-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.crit: https://kernelci.org/test/case/id/6168e641c2fa6b64=
823358e7
        new failure (last pass: v4.4.288-19-g46f1e1a33c90)
        1 lines

    2021-10-15T02:23:44.083738  / # =

    2021-10-15T02:23:44.084633  #
    2021-10-15T02:23:44.188452  / # #
    2021-10-15T02:23:44.189190  =

    2021-10-15T02:23:44.290745  / # #export SHELL=3D/bin/sh
    2021-10-15T02:23:44.291233  =

    2021-10-15T02:23:44.392592  / # export SHELL=3D/bin/sh. /lava-945957/en=
vironment
    2021-10-15T02:23:44.393081  =

    2021-10-15T02:23:44.494455  / # . /lava-945957/environment/lava-945957/=
bin/lava-test-runner /lava-945957/0
    2021-10-15T02:23:44.495764   =

    ... (9 line(s) more)  =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/6168e641c2fa6b6=
4823358e9
        new failure (last pass: v4.4.288-19-g46f1e1a33c90)
        28 lines

    2021-10-15T02:23:44.987964  kern  :emerg : Internal error: Oops - BUG: =
0 [#1] SMP ARM
    2021-10-15T02:23:44.993579  kern  :emerg : Process udevd (pid: 112, sta=
ck limit =3D 0xcb984218)
    2021-10-15T02:23:44.998211  kern  :emerg : Stack: (0xcb985d10 to 0xcb98=
6000)
    2021-10-15T02:23:45.006305  kern  :emerg : 5d00:                       =
              bf02b83c bf010b84 cb9a2c10 bf02b8c8   =

 =



platform            | arch | lab          | compiler | defconfig           =
| regressions
--------------------+------+--------------+----------+---------------------=
+------------
qemu_arm-virt-gicv2 | arm  | lab-baylibre | gcc-8    | multi_v7_defconfig  =
| 1          =


  Details:     https://kernelci.org/test/plan/id/6168e63550cad8770b335914

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.288=
-19-gf9c6c370e0b0/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.288=
-19-gf9c6c370e0b0/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6168e63550cad8770b335=
915
        failing since 334 days (last pass: v4.4.243-14-gcb8e837cb602, first=
 fail: v4.4.243-20-g3c35b64319c2) =

 =



platform            | arch | lab          | compiler | defconfig           =
| regressions
--------------------+------+--------------+----------+---------------------=
+------------
qemu_arm-virt-gicv2 | arm  | lab-broonie  | gcc-8    | multi_v7_defconfig  =
| 1          =


  Details:     https://kernelci.org/test/plan/id/6168e65871af1da8fd3358dc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.288=
-19-gf9c6c370e0b0/arm/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.288=
-19-gf9c6c370e0b0/arm/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6168e65871af1da8fd335=
8dd
        failing since 334 days (last pass: v4.4.243-14-gcb8e837cb602, first=
 fail: v4.4.243-20-g3c35b64319c2) =

 =



platform            | arch | lab          | compiler | defconfig           =
| regressions
--------------------+------+--------------+----------+---------------------=
+------------
qemu_arm-virt-gicv2 | arm  | lab-cip      | gcc-8    | multi_v7_defconfig  =
| 1          =


  Details:     https://kernelci.org/test/plan/id/6168e635a585e2700b3358f1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.288=
-19-gf9c6c370e0b0/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-vi=
rt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.288=
-19-gf9c6c370e0b0/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-vi=
rt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6168e635a585e2700b335=
8f2
        failing since 334 days (last pass: v4.4.243-14-gcb8e837cb602, first=
 fail: v4.4.243-20-g3c35b64319c2) =

 =



platform            | arch | lab          | compiler | defconfig           =
| regressions
--------------------+------+--------------+----------+---------------------=
+------------
qemu_arm-virt-gicv3 | arm  | lab-baylibre | gcc-8    | multi_v7_defconfig  =
| 1          =


  Details:     https://kernelci.org/test/plan/id/6168e6adfd644a96593358fd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.288=
-19-gf9c6c370e0b0/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.288=
-19-gf9c6c370e0b0/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6168e6adfd644a9659335=
8fe
        failing since 334 days (last pass: v4.4.243-14-gcb8e837cb602, first=
 fail: v4.4.243-20-g3c35b64319c2) =

 =



platform            | arch | lab          | compiler | defconfig           =
| regressions
--------------------+------+--------------+----------+---------------------=
+------------
qemu_arm-virt-gicv3 | arm  | lab-broonie  | gcc-8    | multi_v7_defconfig  =
| 1          =


  Details:     https://kernelci.org/test/plan/id/6168e70c2c8fd32b2c335902

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.288=
-19-gf9c6c370e0b0/arm/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.288=
-19-gf9c6c370e0b0/arm/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6168e70c2c8fd32b2c335=
903
        failing since 334 days (last pass: v4.4.243-14-gcb8e837cb602, first=
 fail: v4.4.243-20-g3c35b64319c2) =

 =



platform            | arch | lab          | compiler | defconfig           =
| regressions
--------------------+------+--------------+----------+---------------------=
+------------
qemu_arm-virt-gicv3 | arm  | lab-cip      | gcc-8    | multi_v7_defconfig  =
| 1          =


  Details:     https://kernelci.org/test/plan/id/6168e6d762d61bd34d3358ed

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.288=
-19-gf9c6c370e0b0/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-vi=
rt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.288=
-19-gf9c6c370e0b0/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-vi=
rt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6168e6d762d61bd34d335=
8ee
        failing since 334 days (last pass: v4.4.243-14-gcb8e837cb602, first=
 fail: v4.4.243-20-g3c35b64319c2) =

 =20
