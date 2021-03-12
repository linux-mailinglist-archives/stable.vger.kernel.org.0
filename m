Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEEED339782
	for <lists+stable@lfdr.de>; Fri, 12 Mar 2021 20:38:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234200AbhCLTh3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Mar 2021 14:37:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233940AbhCLThY (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 12 Mar 2021 14:37:24 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4908DC061574
        for <stable@vger.kernel.org>; Fri, 12 Mar 2021 11:37:24 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id q6-20020a17090a4306b02900c42a012202so11554332pjg.5
        for <stable@vger.kernel.org>; Fri, 12 Mar 2021 11:37:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=LvGys2tJYEtDtkc+jgzClcuhP1NsmvUjDPrEWIayKVE=;
        b=BmeHLMLsHo1ZRwsOhyjSnm5a8J0IYO8mjGj1PdrrRPYjmk6k9HR1yGlx2zBtrDfJZn
         ZMBmbDXYnvxBhIpq+yEmCGPVHTx94J9oE/X+3AbmNRuCqWxev6h0LNwHQ/iBeh9+1tOZ
         tK6WfZCS1bxrM5qUVBApXFyxJoMQCuVfjeShBPkblKShoUMgE1GZ+jzl6ER4fH4QZ2Ye
         QhTYjJae1L6gxmsgPO6tSfyZl9o5Deg3ljfLg8qCwqD0VzARh1Lb+tQcfnmSfUKJWg/5
         JocmK6CJdRclx+l8EduIXVfqLK6KH8ghjeU2UiOn12o8jucaKfvc390RVXUjf7bEvJVA
         2R7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=LvGys2tJYEtDtkc+jgzClcuhP1NsmvUjDPrEWIayKVE=;
        b=XrVLuXE1d9p71XskSgvKNPou8d4emzSVVexlcm6ILamG5GH4BIs+/8CnCWga10OSne
         KQarABPDXptD0Kwi73r220vmi6fEKFHmNLA8J6m+kl2GrJFEvQjTxqiAYafbRSGtC/0e
         oFyduvEqewVjt/c+b9Gk+SceHBahNPtAP0rakJ34hEOqeWSdH0/WA59HU2Ti7ZjaLl27
         WheOi/9J4O91Yt2du14CeW2aV+3uCcY2le4y5bsIPoGJb3pshY6j60NYr5BZd7S9dnNY
         J3Ok2E62SIWIBX+AyEsJ27bt3lbRRsmNtNoUz0CfoVdpfl6But7qJp+QJjr2Vc5sPFFd
         k0lw==
X-Gm-Message-State: AOAM532t5jbQboIsEWjFTYaBUnzJXDHxbz/4TO50qJFp3rL6elhIVudy
        ami+4Z/7b8JrgD+2xntxBMqV91v35yttiA==
X-Google-Smtp-Source: ABdhPJw6tcmTQnFpP91Ju3FKoPQjSA0gMagc66yLOzvSDTAIAhFzjigFVVpSt8nmkVnoHUUXEQRLmA==
X-Received: by 2002:a17:902:c246:b029:e4:63a6:e8d2 with SMTP id 6-20020a170902c246b02900e463a6e8d2mr60290plg.51.1615577843566;
        Fri, 12 Mar 2021 11:37:23 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id x7sm6307471pff.12.2021.03.12.11.37.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Mar 2021 11:37:23 -0800 (PST)
Message-ID: <604bc2f3.1c69fb81.bdba3.10b5@mx.google.com>
Date:   Fri, 12 Mar 2021 11:37:23 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.180-40-g3f0127cea9d86
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.19
Subject: stable-rc/queue/4.19 baseline: 142 runs,
 7 regressions (v4.19.180-40-g3f0127cea9d86)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 142 runs, 7 regressions (v4.19.180-40-g3f012=
7cea9d86)

Regressions Summary
-------------------

platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
meson-gxm-q200       | arm64 | lab-baylibre  | gcc-8    | defconfig        =
   | 2          =

panda                | arm   | lab-collabora | gcc-8    | omap2plus_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-baylibre  | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-broonie   | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-cip       | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-collabora | gcc-8    | versatile_defconf=
ig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.180-40-g3f0127cea9d86/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.180-40-g3f0127cea9d86
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      3f0127cea9d86870a0a6342cc18c80dc128b7d7e =



Test Regressions
---------------- =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
meson-gxm-q200       | arm64 | lab-baylibre  | gcc-8    | defconfig        =
   | 2          =


  Details:     https://kernelci.org/test/plan/id/604b95bedc1bb3151caddcd6

  Results:     3 PASS, 2 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.180=
-40-g3f0127cea9d86/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q2=
00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.180=
-40-g3f0127cea9d86/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q2=
00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.dmesg.alert: https://kernelci.org/test/case/id/604b95bedc1bb31=
51caddcda
        new failure (last pass: v4.19.180-12-g6a32fa6ca6b5)
        11 lines

    2021-03-12 16:24:08.959000+00:00  kern  :alert :   Exception class =3D =
DABT (current EL), IL =3D 32 bits
    2021-03-12 16:24:08.959000+00:00  kern  :alert :   SET =3D 0, FnV =3D 0
    2021-03-12 16:24:08.959000+00:00  kern  :alert :   EA =3D 0, S1PTW =3D 0
    2021-03-12 16:24:08.959000+00:00  kern  :alert : Dat<8>[   16.552122] <=
LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASU=
REMENT=3D3>
    2021-03-12 16:24:08.959000+00:00  a abort info<8>[   16.561698] <LAVA_S=
IGNAL_ENDRUN 0_dmesg 797843_1.5.2.4.1>
    2021-03-12 16:24:08.959000+00:00  :
    2021-03-12 16:24:08.960000+00:00  kern  :alert :   ISV =3D 0, ISS =3D 0=
x00000004   =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/604b95bedc1bb31=
51caddcdb
        new failure (last pass: v4.19.180-12-g6a32fa6ca6b5)
        3 lines =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
panda                | arm   | lab-collabora | gcc-8    | omap2plus_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/604b8af8458339aadaaddcd0

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.180=
-40-g3f0127cea9d86/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pan=
da.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.180=
-40-g3f0127cea9d86/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pan=
da.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/604b8af8458339a=
adaaddcd5
        new failure (last pass: v4.19.180-18-g4334f738815bb)
        2 lines

    2021-03-12 15:38:27.941000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xffffed34 [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-baylibre  | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/604b90569f6f84df31addcd8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.180=
-40-g3f0127cea9d86/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.180=
-40-g3f0127cea9d86/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/604b90569f6f84df31add=
cd9
        failing since 118 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-broonie   | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/604b8855e40943623daddcb6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.180=
-40-g3f0127cea9d86/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.180=
-40-g3f0127cea9d86/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/604b8855e40943623dadd=
cb7
        failing since 118 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-cip       | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/604b88a38608bd811aaddcc8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.180=
-40-g3f0127cea9d86/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.180=
-40-g3f0127cea9d86/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/604b88a38608bd811aadd=
cc9
        failing since 118 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-collabora | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/604b87c72310afdc31addcd9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.180=
-40-g3f0127cea9d86/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.180=
-40-g3f0127cea9d86/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/604b87c72310afdc31add=
cda
        failing since 118 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =20
