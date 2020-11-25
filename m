Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E42B72C4728
	for <lists+stable@lfdr.de>; Wed, 25 Nov 2020 19:02:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731956AbgKYSAl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 Nov 2020 13:00:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731429AbgKYSAk (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 25 Nov 2020 13:00:40 -0500
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1D25C0613D4
        for <stable@vger.kernel.org>; Wed, 25 Nov 2020 10:00:40 -0800 (PST)
Received: by mail-pf1-x431.google.com with SMTP id n137so3071383pfd.3
        for <stable@vger.kernel.org>; Wed, 25 Nov 2020 10:00:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=zbmODqS96hDtN09cKShc1ZxcfuxMeWkj+ikwLFHGbjQ=;
        b=E75fHP6MLVsl/nTAaeff51+6vTo+fO2cS39rPnpY3EXErEdihLk+gkxG8VpTDm+jaW
         0O5WGlyye82y1z6nflOXxsxFsFFun49Q+BCCenke4PCl5tMPa0rbmmcqGzs82X/hnuUk
         VLwwUgom5dsC7DkAudVm1z0bGtEMfnnlYZqmQ/NBtpfFc9Rkip90AX3Uak143AT00yIu
         Ky3WaerH04k9170Ec6nWgGN/MhpxnisaxreEPMOrtjM9EnkbqQsmSQSKF5bYgP89VPuN
         viw25bQvzoDI2jscsCQA4rJoIyIvjs+Ak48L/3eir4egnbUwIiqeSEHJRHlIcB5MpYxU
         F7Ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=zbmODqS96hDtN09cKShc1ZxcfuxMeWkj+ikwLFHGbjQ=;
        b=uKXfQez1s6fPVOCc263Aez0kh9fz0HYwPjIjjnvwJWVI3wc6gwm4a9z00HvVWaIOmU
         FSolFs75vconZBG322xN3ZTqMY8woku6u7Im1rHYhp8VT4gamYoAqc1QDtj4R9PIfesi
         UMWG4mdZ6bEgMDAcEiYO43veQvfCns2/JzwjXyt3y+auJaFOroNk+NYWWj9Lj/voZRSh
         kAjQ5NKALPeOZSvQk0ButzGdcB9q/oQSjWc2e6oPQVVrk2lVYV5uL3EsDY7HDrBHabPb
         aHHfaIzP9PP63ILPLxYfclSNsm1EVLuqrr+rORyvI7M13OAfK2AcAfZgQnza/uHf+sPC
         6NAw==
X-Gm-Message-State: AOAM530l7TLrlSJQjVXRz+5wtVAczH1ctSFGA/7Iiwczm9daHQZywbjJ
        F90xjQC3GMnomKBAJju+rmsTHJmEoz8MNA==
X-Google-Smtp-Source: ABdhPJziQopHcnlbeQQCrxKBJONrkijA+GxlGVD6bF+H4jn9b2RT4K5jrs1LKfTzXxckGavav/1OBw==
X-Received: by 2002:a62:8244:0:b029:198:1f1:7384 with SMTP id w65-20020a6282440000b029019801f17384mr4033047pfd.27.1606327239569;
        Wed, 25 Nov 2020 10:00:39 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id e23sm2553457pfd.64.2020.11.25.10.00.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Nov 2020 10:00:38 -0800 (PST)
Message-ID: <5fbe9bc6.1c69fb81.c64dd.644a@mx.google.com>
Date:   Wed, 25 Nov 2020 10:00:38 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.4
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.4.80-3-g778c35c99c99
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.4 baseline: 209 runs,
 9 regressions (v5.4.80-3-g778c35c99c99)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 209 runs, 9 regressions (v5.4.80-3-g778c35c99=
c99)

Regressions Summary
-------------------

platform              | arch  | lab             | compiler | defconfig     =
      | regressions
----------------------+-------+-----------------+----------+---------------=
------+------------
at91-sama5d4_xplained | arm   | lab-baylibre    | gcc-8    | sama5_defconfi=
g     | 1          =

bcm2837-rpi-3-b       | arm64 | lab-baylibre    | gcc-8    | defconfig     =
      | 1          =

hifive-unleashed-a00  | riscv | lab-baylibre    | gcc-8    | defconfig     =
      | 1          =

qemu_arm-versatilepb  | arm   | lab-baylibre    | gcc-8    | versatile_defc=
onfig | 1          =

qemu_arm-versatilepb  | arm   | lab-broonie     | gcc-8    | versatile_defc=
onfig | 1          =

qemu_arm-versatilepb  | arm   | lab-cip         | gcc-8    | versatile_defc=
onfig | 1          =

qemu_arm-versatilepb  | arm   | lab-collabora   | gcc-8    | versatile_defc=
onfig | 1          =

qemu_arm-versatilepb  | arm   | lab-linaro-lkft | gcc-8    | versatile_defc=
onfig | 1          =

sun8i-h3-orangepi-pc  | arm   | lab-clabbe      | gcc-8    | multi_v7_defco=
nfig  | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.80-3-g778c35c99c99/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.80-3-g778c35c99c99
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      778c35c99c9965dba9e44feede3bb5f913dbe346 =



Test Regressions
---------------- =



platform              | arch  | lab             | compiler | defconfig     =
      | regressions
----------------------+-------+-----------------+----------+---------------=
------+------------
at91-sama5d4_xplained | arm   | lab-baylibre    | gcc-8    | sama5_defconfi=
g     | 1          =


  Details:     https://kernelci.org/test/plan/id/5fbe682966226629efc94cc5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sama5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.80-3-=
g778c35c99c99/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5d4_=
xplained.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.80-3-=
g778c35c99c99/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5d4_=
xplained.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fbe682966226629efc94=
cc6
        failing since 27 days (last pass: v5.4.72-409-gbbe9df5e07cf, first =
fail: v5.4.72-409-ga6e47f533653) =

 =



platform              | arch  | lab             | compiler | defconfig     =
      | regressions
----------------------+-------+-----------------+----------+---------------=
------+------------
bcm2837-rpi-3-b       | arm64 | lab-baylibre    | gcc-8    | defconfig     =
      | 1          =


  Details:     https://kernelci.org/test/plan/id/5fbe666c63ca568ea1c94cb9

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.80-3-=
g778c35c99c99/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b.t=
xt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.80-3-=
g778c35c99c99/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.dmesg.crit: https://kernelci.org/test/case/id/5fbe666c63ca568e=
a1c94cbc
        new failure (last pass: v5.4.80-2-g916d352681d9)
        2 lines

    2020-11-25 14:10:52.422000+00:00  Connected to bcm2837-rpi-3-b console =
[channel connected] (~$quit to exit)
    2020-11-25 14:10:52.423000+00:00  (user:khilman) is already connected
    2020-11-25 14:11:08.557000+00:00  =00
    2020-11-25 14:11:08.557000+00:00  =

    2020-11-25 14:11:08.557000+00:00  U-Boot 2018.11 (Dec 04 2018 - 10:54:3=
2 -0800)
    2020-11-25 14:11:08.557000+00:00  =

    2020-11-25 14:11:08.557000+00:00  DRAM:  948 MiB
    2020-11-25 14:11:08.573000+00:00  RPI 3 Model B (0xa02082)
    2020-11-25 14:11:08.660000+00:00  MMC:   mmc@7e202000: 0, sdhci@7e30000=
0: 1
    2020-11-25 14:11:08.691000+00:00  Loading Environment from FAT... *** W=
arning - bad CRC, using default environment =

    ... (380 line(s) more)  =

 =



platform              | arch  | lab             | compiler | defconfig     =
      | regressions
----------------------+-------+-----------------+----------+---------------=
------+------------
hifive-unleashed-a00  | riscv | lab-baylibre    | gcc-8    | defconfig     =
      | 1          =


  Details:     https://kernelci.org/test/plan/id/5fbe67f5de89109573c94cb9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (riscv64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.80-3-=
g778c35c99c99/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleashed-=
a00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.80-3-=
g778c35c99c99/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleashed-=
a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/riscv/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fbe67f5de89109573c94=
cba
        failing since 5 days (last pass: v5.4.78-5-g843222460ebea, first fa=
il: v5.4.78-13-g81acf0f7c6ec) =

 =



platform              | arch  | lab             | compiler | defconfig     =
      | regressions
----------------------+-------+-----------------+----------+---------------=
------+------------
qemu_arm-versatilepb  | arm   | lab-baylibre    | gcc-8    | versatile_defc=
onfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fbe663b46a1a23af7c94ce6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.80-3-=
g778c35c99c99/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-=
versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.80-3-=
g778c35c99c99/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-=
versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fbe663b46a1a23af7c94=
ce7
        failing since 11 days (last pass: v5.4.77-44-gce6b18c3a8969, first =
fail: v5.4.77-45-gfd610189f77e1) =

 =



platform              | arch  | lab             | compiler | defconfig     =
      | regressions
----------------------+-------+-----------------+----------+---------------=
------+------------
qemu_arm-versatilepb  | arm   | lab-broonie     | gcc-8    | versatile_defc=
onfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fbe6654389e91e03ac94d39

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.80-3-=
g778c35c99c99/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-v=
ersatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.80-3-=
g778c35c99c99/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-v=
ersatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fbe6654389e91e03ac94=
d3a
        failing since 11 days (last pass: v5.4.77-44-gce6b18c3a8969, first =
fail: v5.4.77-45-gfd610189f77e1) =

 =



platform              | arch  | lab             | compiler | defconfig     =
      | regressions
----------------------+-------+-----------------+----------+---------------=
------+------------
qemu_arm-versatilepb  | arm   | lab-cip         | gcc-8    | versatile_defc=
onfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fbe664246a1a23af7c94cf5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.80-3-=
g778c35c99c99/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versa=
tilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.80-3-=
g778c35c99c99/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versa=
tilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fbe664246a1a23af7c94=
cf6
        failing since 11 days (last pass: v5.4.77-44-gce6b18c3a8969, first =
fail: v5.4.77-45-gfd610189f77e1) =

 =



platform              | arch  | lab             | compiler | defconfig     =
      | regressions
----------------------+-------+-----------------+----------+---------------=
------+------------
qemu_arm-versatilepb  | arm   | lab-collabora   | gcc-8    | versatile_defc=
onfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fbe661dc86fc8288cc94cce

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.80-3-=
g778c35c99c99/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.80-3-=
g778c35c99c99/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fbe661dc86fc8288cc94=
ccf
        failing since 11 days (last pass: v5.4.77-44-gce6b18c3a8969, first =
fail: v5.4.77-45-gfd610189f77e1) =

 =



platform              | arch  | lab             | compiler | defconfig     =
      | regressions
----------------------+-------+-----------------+----------+---------------=
------+------------
qemu_arm-versatilepb  | arm   | lab-linaro-lkft | gcc-8    | versatile_defc=
onfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fbe7a34f763e4ffaac94cf9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.80-3-=
g778c35c99c99/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.80-3-=
g778c35c99c99/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fbe7a34f763e4ffaac94=
cfa
        failing since 11 days (last pass: v5.4.77-44-gce6b18c3a8969, first =
fail: v5.4.77-45-gfd610189f77e1) =

 =



platform              | arch  | lab             | compiler | defconfig     =
      | regressions
----------------------+-------+-----------------+----------+---------------=
------+------------
sun8i-h3-orangepi-pc  | arm   | lab-clabbe      | gcc-8    | multi_v7_defco=
nfig  | 1          =


  Details:     https://kernelci.org/test/plan/id/5fbe68f5e3c4fb9113c94ce5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.80-3-=
g778c35c99c99/arm/multi_v7_defconfig/gcc-8/lab-clabbe/baseline-sun8i-h3-ora=
ngepi-pc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.80-3-=
g778c35c99c99/arm/multi_v7_defconfig/gcc-8/lab-clabbe/baseline-sun8i-h3-ora=
ngepi-pc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fbe68f5e3c4fb9113c94=
ce6
        new failure (last pass: v5.4.80-2-g916d352681d9) =

 =20
