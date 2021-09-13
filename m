Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CF89409A2E
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 18:57:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239542AbhIMQ6q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 12:58:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238966AbhIMQ6q (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Sep 2021 12:58:46 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 765A7C061574
        for <stable@vger.kernel.org>; Mon, 13 Sep 2021 09:57:30 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id w7so10002914pgk.13
        for <stable@vger.kernel.org>; Mon, 13 Sep 2021 09:57:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=tTR6qO8G594wEDaWrVLwOBsJpvg1oi6/VF7MAhAsuhM=;
        b=ZYKwv+XGdBKxpF0nhpEdN8DB2wzUVZ6/OWwvd5mnVe8pPGw3THAJaYyQtC1DTPvQGa
         D0M3fyK3Hxk2jTiKC99zXgcyruGEffcza/j2kjLX/wg3YJ+ppx83XOBbsHnNRijW5wdk
         WgNfNrrnCv1nbdQ4b4M+XAbSHw1w3tn+2GdjiBsyY1Y6QdhYIKjQHe5cAH202Ls+ox6y
         D3BonGVTYecmeurNPZKrWPiwmfgAE//zOTfk+bFqyNS+ItvhdUbs3P98ip5uOnXuxfC4
         Pa7VoZHff1nvhzum0qho3ap7q1clpB4oaGukZA7GD9Uew35x1NFK1MgEH5DZejK5l0Je
         pgTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=tTR6qO8G594wEDaWrVLwOBsJpvg1oi6/VF7MAhAsuhM=;
        b=vQfVPkQlJu1OogwSwIlMWRp8+f3CGLUVu3GwqABDiulz0HPAM16fy7pk+4IKOwbRIY
         9jMKmIaqCW8qPbuAEHclHbHB8eDioTWIuYaukP3iGtlnxt6kuDLaMYKvCCHh91FI6zgA
         ufmCSgtDmPctYohufFQV64bXtx+9m6/IGk0//sobaYFmqAf+KVZfZOmuordsKe46Fo8d
         S2Hh1YEXkE6ArKLkBtOvMqg3lUHguyvq9VjD7QXOTERuDx5y62p9sxz8KJfXU8ZJscAL
         eJsfmGYMR7OqtH1UxgWiXMsY2sX8HVuXMOos6tXwZZu8Z92uGJJY8CjqMWUczJtv1o7M
         0oLw==
X-Gm-Message-State: AOAM532gAWAAWusfEemsrd126rzlr8lhwrNNwnTc6qOGygBSXSr8mBqi
        4cHZjZSbvjzdf5DFV5D/EnEaN2g2gjTlRhhq
X-Google-Smtp-Source: ABdhPJxBQrMdO1kqLjcZSzo/2O0m9hzyK7ArGvfNJwdGYAwXxEk1bPCX+timNjJy9M3CBCHVDWb9CQ==
X-Received: by 2002:a62:b511:0:b0:416:30f0:daab with SMTP id y17-20020a62b511000000b0041630f0daabmr458214pfe.47.1631552249616;
        Mon, 13 Sep 2021 09:57:29 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id u6sm8666567pgr.3.2021.09.13.09.57.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Sep 2021 09:57:29 -0700 (PDT)
Message-ID: <613f82f9.1c69fb81.1ab06.8eac@mx.google.com>
Date:   Mon, 13 Sep 2021 09:57:29 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.4.283-72-g3c0ec2b2f105
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.4
Subject: stable-rc/queue/4.4 baseline: 103 runs,
 9 regressions (v4.4.283-72-g3c0ec2b2f105)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 baseline: 103 runs, 9 regressions (v4.4.283-72-g3c0ec2b=
2f105)

Regressions Summary
-------------------

platform            | arch | lab           | compiler | defconfig          =
 | regressions
--------------------+------+---------------+----------+--------------------=
-+------------
beagle-xm           | arm  | lab-baylibre  | gcc-8    | omap2plus_defconfig=
 | 2          =

qemu_arm-virt-gicv2 | arm  | lab-baylibre  | gcc-8    | multi_v7_defconfig =
 | 1          =

qemu_arm-virt-gicv2 | arm  | lab-cip       | gcc-8    | multi_v7_defconfig =
 | 1          =

qemu_arm-virt-gicv2 | arm  | lab-collabora | gcc-8    | multi_v7_defconfig =
 | 1          =

qemu_arm-virt-gicv3 | arm  | lab-baylibre  | gcc-8    | multi_v7_defconfig =
 | 1          =

qemu_arm-virt-gicv3 | arm  | lab-cip       | gcc-8    | multi_v7_defconfig =
 | 1          =

qemu_arm-virt-gicv3 | arm  | lab-collabora | gcc-8    | multi_v7_defconfig =
 | 1          =

qemu_i386           | i386 | lab-collabora | gcc-8    | i386_defconfig     =
 | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.4/kern=
el/v4.4.283-72-g3c0ec2b2f105/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.4
  Describe: v4.4.283-72-g3c0ec2b2f105
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      3c0ec2b2f105ab806aa101d4b746b8c7a451b1b2 =



Test Regressions
---------------- =



platform            | arch | lab           | compiler | defconfig          =
 | regressions
--------------------+------+---------------+----------+--------------------=
-+------------
beagle-xm           | arm  | lab-baylibre  | gcc-8    | omap2plus_defconfig=
 | 2          =


  Details:     https://kernelci.org/test/plan/id/613f51c0654085bd0999a331

  Results:     3 PASS, 2 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.283-7=
2-g3c0ec2b2f105/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle-=
xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.283-7=
2-g3c0ec2b2f105/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle-=
xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.crit: https://kernelci.org/test/case/id/613f51c0654085bd=
0999a337
        new failure (last pass: v4.4.283-68-ga03032d89254)
        1 lines

    2021-09-13T13:27:08.315236  =

    2021-09-13T13:27:08.419200  / # #
    2021-09-13T13:27:08.419857  =

    2021-09-13T13:27:08.521259  / # #export SHELL=3D/bin/sh
    2021-09-13T13:27:08.521692  =

    2021-09-13T13:27:08.622906  / # export SHELL=3D/bin/sh. /lava-837764/en=
vironment
    2021-09-13T13:27:08.623395  =

    2021-09-13T13:27:08.724656  / # . /lava-837764/environment/lava-837764/=
bin/lava-test-runner /lava-837764/0
    2021-09-13T13:27:08.725905  =

    2021-09-13T13:27:08.726800  / # /lava-837764/bin/lava-test-runner /lava=
-837764/0 =

    ... (8 line(s) more)  =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/613f51c0654085b=
d0999a339
        new failure (last pass: v4.4.283-68-ga03032d89254)
        28 lines

    2021-09-13T13:27:09.190856  [   49.942626] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-09-13T13:27:09.243348  kern  :emerg : Internal error: Oops - BUG: =
0 [#1] SMP ARM
    2021-09-13T13:27:09.248976  kern  :emerg : Process udevd (pid: 105, sta=
ck limit =3D 0xcb8e6218)
    2021-09-13T13:27:09.253251  kern  :emerg : Stack: (0xcb8e7d10 to 0xcb8e=
8000)
    2021-09-13T13:27:09.261575  kern  :emerg : 7d00:                       =
              bf03283c bf017b84 cb96e010 bf0328c8
    2021-09-13T13:27:09.274499  kern  :emerg : 7d20: cb96e010 bf1f70a8 0000=
0002 cb[   50.023010] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Demerg RESULT=3Df=
ail UNITS=3Dlines MEASUREMENT=3D28>   =

 =



platform            | arch | lab           | compiler | defconfig          =
 | regressions
--------------------+------+---------------+----------+--------------------=
-+------------
qemu_arm-virt-gicv2 | arm  | lab-baylibre  | gcc-8    | multi_v7_defconfig =
 | 1          =


  Details:     https://kernelci.org/test/plan/id/613f52be1987073e0d99a323

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.283-7=
2-g3c0ec2b2f105/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm=
-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.283-7=
2-g3c0ec2b2f105/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm=
-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/613f52be1987073e0d99a=
324
        failing since 303 days (last pass: v4.4.243-18-gfc7e8c68369a, first=
 fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch | lab           | compiler | defconfig          =
 | regressions
--------------------+------+---------------+----------+--------------------=
-+------------
qemu_arm-virt-gicv2 | arm  | lab-cip       | gcc-8    | multi_v7_defconfig =
 | 1          =


  Details:     https://kernelci.org/test/plan/id/613f536776057a493a99a2e6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.283-7=
2-g3c0ec2b2f105/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-virt=
-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.283-7=
2-g3c0ec2b2f105/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-virt=
-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/613f536776057a493a99a=
2e7
        failing since 303 days (last pass: v4.4.243-18-gfc7e8c68369a, first=
 fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch | lab           | compiler | defconfig          =
 | regressions
--------------------+------+---------------+----------+--------------------=
-+------------
qemu_arm-virt-gicv2 | arm  | lab-collabora | gcc-8    | multi_v7_defconfig =
 | 1          =


  Details:     https://kernelci.org/test/plan/id/613f54c11d7ccb45da99a2e0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.283-7=
2-g3c0ec2b2f105/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-qemu_ar=
m-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.283-7=
2-g3c0ec2b2f105/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-qemu_ar=
m-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/613f54c11d7ccb45da99a=
2e1
        failing since 303 days (last pass: v4.4.243-18-gfc7e8c68369a, first=
 fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch | lab           | compiler | defconfig          =
 | regressions
--------------------+------+---------------+----------+--------------------=
-+------------
qemu_arm-virt-gicv3 | arm  | lab-baylibre  | gcc-8    | multi_v7_defconfig =
 | 1          =


  Details:     https://kernelci.org/test/plan/id/613f52323e3748777799a2e2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.283-7=
2-g3c0ec2b2f105/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm=
-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.283-7=
2-g3c0ec2b2f105/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm=
-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/613f52323e3748777799a=
2e3
        failing since 303 days (last pass: v4.4.243-18-gfc7e8c68369a, first=
 fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch | lab           | compiler | defconfig          =
 | regressions
--------------------+------+---------------+----------+--------------------=
-+------------
qemu_arm-virt-gicv3 | arm  | lab-cip       | gcc-8    | multi_v7_defconfig =
 | 1          =


  Details:     https://kernelci.org/test/plan/id/613f52c764e11e331d99a2da

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.283-7=
2-g3c0ec2b2f105/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-virt=
-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.283-7=
2-g3c0ec2b2f105/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-virt=
-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/613f52c764e11e331d99a=
2db
        failing since 303 days (last pass: v4.4.243-18-gfc7e8c68369a, first=
 fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch | lab           | compiler | defconfig          =
 | regressions
--------------------+------+---------------+----------+--------------------=
-+------------
qemu_arm-virt-gicv3 | arm  | lab-collabora | gcc-8    | multi_v7_defconfig =
 | 1          =


  Details:     https://kernelci.org/test/plan/id/613f538ffec74d812999a2db

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.283-7=
2-g3c0ec2b2f105/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-qemu_ar=
m-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.283-7=
2-g3c0ec2b2f105/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-qemu_ar=
m-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/613f538ffec74d812999a=
2dc
        failing since 303 days (last pass: v4.4.243-18-gfc7e8c68369a, first=
 fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch | lab           | compiler | defconfig          =
 | regressions
--------------------+------+---------------+----------+--------------------=
-+------------
qemu_i386           | i386 | lab-collabora | gcc-8    | i386_defconfig     =
 | 1          =


  Details:     https://kernelci.org/test/plan/id/613f507d4d9299264299a2e9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.283-7=
2-g3c0ec2b2f105/i386/i386_defconfig/gcc-8/lab-collabora/baseline-qemu_i386.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.283-7=
2-g3c0ec2b2f105/i386/i386_defconfig/gcc-8/lab-collabora/baseline-qemu_i386.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/613f507d4d9299264299a=
2ea
        new failure (last pass: v4.4.283-68-ga03032d89254) =

 =20
