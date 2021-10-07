Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 490874255C2
	for <lists+stable@lfdr.de>; Thu,  7 Oct 2021 16:48:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242097AbhJGOuP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Oct 2021 10:50:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233419AbhJGOuP (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 Oct 2021 10:50:15 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8B49C061570
        for <stable@vger.kernel.org>; Thu,  7 Oct 2021 07:48:21 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id ls18so5047478pjb.3
        for <stable@vger.kernel.org>; Thu, 07 Oct 2021 07:48:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=80JS+T7f+lEn+4qNe4inYPigOSzX8jFyyQD1Pc60ut4=;
        b=lHoOdbNtJpIzpFlrSRJlMyxWHggoCHTb4Y4GfIg6HrGdcy+nTDcEv7nwiYX9WlhZwJ
         GjecMBqaZypoWVSEF/sDyOBlL16m2n8lgFksZvaZrMunE9fCwcUWwIF59ikAaE0nUvB/
         6bUXtgyF4jJy+tHhZLQjusWcRLwKyxZ3bA3PedUIEWXjoZY8MP1NFIZeUvCj6Pja4P1m
         nEXD615nqVG/HCxr5kKbwqqCEbbH1DxwcBTbpjyJIrErSRlcATjMQeDlIgIlasvRg6JF
         5nYWB0l5W1mSogt1vSrZYd6J368KI8FhL91HqMQMF/MwLTD9+qmMTEV00c8X/5zNN45E
         PL3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=80JS+T7f+lEn+4qNe4inYPigOSzX8jFyyQD1Pc60ut4=;
        b=cpw79nhdQ+URzum8Ww1s9FSuwmITWTLDDyuDSCsxPu7ijQmv9eNd6WCsALn81iHYG2
         Jx0U0+MyI7g5kh5cb32tsE2RzvCpu6h2OlbtCmGvZAeTeY2c5qLIEvDfKbWrPkDm67R6
         ZtxvHnOcQJ9giywEmVvmjkRKfmTgDCHQ2I4y06IJUAR7yIgn+yUIKp5Z42hpmhNdC4Ve
         0X0Q9RB9b3oHc4rxQeOji/NNGQqwlfx4E9uCydNSdRhknuei8M/v7SaH+ovThdt5ufBF
         KTEwctb6o/uQ8Ur50phgVKpuZJ5mg9sfFa9FOutyNZE2nLuO9hXH94vJTCl4PHRwJhfW
         SpPw==
X-Gm-Message-State: AOAM533a6wgrL7WzIWkPpXI63DB7nF2Taf09ziwnAJc/fS87bPM532/h
        GV/RNUPhDBCuhTKwpKeqAEqBdM4Mt2ipsg==
X-Google-Smtp-Source: ABdhPJx/cgqb4zR7LedqpTqDKXT57BaJqMa6zvI9cIanKou5C4Cb90mX0dbOj4907YMQcIKBnKXFGA==
X-Received: by 2002:a17:90b:388f:: with SMTP id mu15mr5282983pjb.28.1633618100990;
        Thu, 07 Oct 2021 07:48:20 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id ie13sm8359147pjb.20.2021.10.07.07.48.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 07:48:20 -0700 (PDT)
Message-ID: <615f08b4.1c69fb81.4f2d4.845a@mx.google.com>
Date:   Thu, 07 Oct 2021 07:48:20 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.249
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.14.y
Subject: stable-rc/linux-4.14.y baseline: 114 runs, 4 regressions (v4.14.249)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y baseline: 114 runs, 4 regressions (v4.14.249)

Regressions Summary
-------------------

platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
panda                | arm  | lab-collabora | gcc-8    | omap2plus_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.14.y/ker=
nel/v4.14.249/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.14.y
  Describe: v4.14.249
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      756db2ba8bde4ead58ceb54e9cbc71f526f9a98f =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
panda                | arm  | lab-collabora | gcc-8    | omap2plus_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/615ed0bfef8d1c0fcc99a2ec

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
49/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
49/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/615ed0bfef8d1c0=
fcc99a2f2
        new failure (last pass: v4.14.248-76-gb56df9ef1a53)
        2 lines

    2021-10-07T10:49:24.183742  [   20.651641] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-10-07T10:49:24.226862  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/97
    2021-10-07T10:49:24.234550  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
d34 [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0
    2021-10-07T10:49:24.247649  [   20.716705] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/615ed7a8932b11a39399a2f1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
49/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
49/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615ed7a8932b11a39399a=
2f2
        failing since 326 days (last pass: v4.14.206-21-gf1262f26e4d0, firs=
t fail: v4.14.206-23-g520c3568920c8) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/615ecd47e4a700f30899a2e1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
49/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
49/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615ecd47e4a700f30899a=
2e2
        failing since 326 days (last pass: v4.14.206-21-gf1262f26e4d0, firs=
t fail: v4.14.206-23-g520c3568920c8) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/615ee3c7dc08784e1099a320

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
49/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilep=
b.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
49/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilep=
b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615ee3c7dc08784e1099a=
321
        failing since 326 days (last pass: v4.14.206-21-gf1262f26e4d0, firs=
t fail: v4.14.206-23-g520c3568920c8) =

 =20
