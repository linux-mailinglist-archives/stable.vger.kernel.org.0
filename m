Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 053A62BC638
	for <lists+stable@lfdr.de>; Sun, 22 Nov 2020 15:51:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728024AbgKVOtZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Nov 2020 09:49:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727634AbgKVOtY (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Nov 2020 09:49:24 -0500
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1185C0613CF
        for <stable@vger.kernel.org>; Sun, 22 Nov 2020 06:49:24 -0800 (PST)
Received: by mail-pf1-x430.google.com with SMTP id 10so12463088pfp.5
        for <stable@vger.kernel.org>; Sun, 22 Nov 2020 06:49:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=PoTQaV39Y7gy4N7IBFokLjZmhOZFxcKDDIFiFtuGFA8=;
        b=MUdaEqznFM2rGOLFN9ItB5yo21afj7uUmuYn7lfosyM5EcqJ0xockq/10CSv16TQvd
         YgN1nZtAtn5E8NUhSDdVxFccISitPy0owVhTs8PHNbhF4HPEgSqpeDujfP1IdaFtA2bH
         Ra4DQgG86TEntoPbt5WtoYMcSao6Xcu1Xi8j2WwqSY8NcyEml5E2hO0XTg+1unsb4r1F
         Cz4L0j/6zJdOAUQ5VZoEIa0nGi6SZiyBakoto6AvhkQCt/NVJq0JVVH9ZPj3545+MPDY
         PWPQiGXzWPFGWD3H/yCCIoHEgNOugQUwglsBQFx2EIwjTzfs0+z29N097E/0rWkAvVl1
         ToPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=PoTQaV39Y7gy4N7IBFokLjZmhOZFxcKDDIFiFtuGFA8=;
        b=uXgvxi8l1xJ2UH2hHKYUMZBDptvBX+uQploIEseI2Vp0vY4OmRB2/nT+uHQe6fyAph
         96TFkSiRB/JLMIPqr7l8tKMJzwijkPsuJW2DNItNdiFePGEFmNt/7goZnBF6GqwRP23p
         /vZlXwjAaAx1fMa0s9qjJxpamzUYayKfQgRl8+J2xU/vDaKVwso6wSmE60h+lTTGoe0Y
         skTHyYrWelonHxNNuHjxwf9bBTFZ8kmphf4ofIwHTFXL+lUHUfPndGzPS2KpYrMG0qJm
         TgAG8QDPC09gkorm/XJD3t73r8kFnGcSCyD+9+z7+RmNeM2SdJZwrMtIFlox4yYweTKF
         Jn1w==
X-Gm-Message-State: AOAM531VgaWs0NKBGWJD/9Vg5YCTEw/qK0AA9wsB/lWsp+cDNAiV6W5l
        quAtdi0H4hEp80O4kmMaqN142gAxndowaQ==
X-Google-Smtp-Source: ABdhPJyIjVoAIu5D25tR4f2go33+s72g07hgMHwHHnCNbZxBuqYojhV1KNB7H8rjmAa2ueaiomI2mQ==
X-Received: by 2002:a17:90b:1888:: with SMTP id mn8mr13168029pjb.158.1606056562648;
        Sun, 22 Nov 2020 06:49:22 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id o18sm136041pfp.16.2020.11.22.06.49.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Nov 2020 06:49:21 -0800 (PST)
Message-ID: <5fba7a71.1c69fb81.e0098.0459@mx.google.com>
Date:   Sun, 22 Nov 2020 06:49:21 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.4.78-17-gc4c31af571ec
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.4
Subject: stable-rc/queue/5.4 baseline: 208 runs,
 8 regressions (v5.4.78-17-gc4c31af571ec)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 208 runs, 8 regressions (v5.4.78-17-gc4c31af5=
71ec)

Regressions Summary
-------------------

platform              | arch  | lab             | compiler | defconfig     =
      | regressions
----------------------+-------+-----------------+----------+---------------=
------+------------
at91-sama5d4_xplained | arm   | lab-baylibre    | gcc-8    | sama5_defconfi=
g     | 1          =

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

stm32mp157c-dk2       | arm   | lab-baylibre    | gcc-8    | multi_v7_defco=
nfig  | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.78-17-gc4c31af571ec/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.78-17-gc4c31af571ec
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      c4c31af571ec63b5670566e30d1f408c22862592 =



Test Regressions
---------------- =



platform              | arch  | lab             | compiler | defconfig     =
      | regressions
----------------------+-------+-----------------+----------+---------------=
------+------------
at91-sama5d4_xplained | arm   | lab-baylibre    | gcc-8    | sama5_defconfi=
g     | 1          =


  Details:     https://kernelci.org/test/plan/id/5fba429c02fee3df27d8d917

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sama5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.78-17=
-gc4c31af571ec/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5d4=
_xplained.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.78-17=
-gc4c31af571ec/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5d4=
_xplained.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fba429c02fee3df27d8d=
918
        failing since 24 days (last pass: v5.4.72-409-gbbe9df5e07cf, first =
fail: v5.4.72-409-ga6e47f533653) =

 =



platform              | arch  | lab             | compiler | defconfig     =
      | regressions
----------------------+-------+-----------------+----------+---------------=
------+------------
hifive-unleashed-a00  | riscv | lab-baylibre    | gcc-8    | defconfig     =
      | 1          =


  Details:     https://kernelci.org/test/plan/id/5fba41eb4e926097f6d8d904

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (riscv64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.78-17=
-gc4c31af571ec/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleashed=
-a00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.78-17=
-gc4c31af571ec/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleashed=
-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/riscv/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fba41eb4e926097f6d8d=
905
        failing since 2 days (last pass: v5.4.78-5-g843222460ebea, first fa=
il: v5.4.78-13-g81acf0f7c6ec) =

 =



platform              | arch  | lab             | compiler | defconfig     =
      | regressions
----------------------+-------+-----------------+----------+---------------=
------+------------
qemu_arm-versatilepb  | arm   | lab-baylibre    | gcc-8    | versatile_defc=
onfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fba42a85b0339d72ad8d901

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.78-17=
-gc4c31af571ec/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.78-17=
-gc4c31af571ec/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fba42a85b0339d72ad8d=
902
        failing since 8 days (last pass: v5.4.77-44-gce6b18c3a8969, first f=
ail: v5.4.77-45-gfd610189f77e1) =

 =



platform              | arch  | lab             | compiler | defconfig     =
      | regressions
----------------------+-------+-----------------+----------+---------------=
------+------------
qemu_arm-versatilepb  | arm   | lab-broonie     | gcc-8    | versatile_defc=
onfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fba42c05b0339d72ad8d927

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.78-17=
-gc4c31af571ec/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-=
versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.78-17=
-gc4c31af571ec/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-=
versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fba42c05b0339d72ad8d=
928
        failing since 8 days (last pass: v5.4.77-44-gce6b18c3a8969, first f=
ail: v5.4.77-45-gfd610189f77e1) =

 =



platform              | arch  | lab             | compiler | defconfig     =
      | regressions
----------------------+-------+-----------------+----------+---------------=
------+------------
qemu_arm-versatilepb  | arm   | lab-cip         | gcc-8    | versatile_defc=
onfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fba4c09aac95acec7d8d936

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.78-17=
-gc4c31af571ec/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-vers=
atilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.78-17=
-gc4c31af571ec/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-vers=
atilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fba4c09aac95acec7d8d=
937
        failing since 8 days (last pass: v5.4.77-44-gce6b18c3a8969, first f=
ail: v5.4.77-45-gfd610189f77e1) =

 =



platform              | arch  | lab             | compiler | defconfig     =
      | regressions
----------------------+-------+-----------------+----------+---------------=
------+------------
qemu_arm-versatilepb  | arm   | lab-collabora   | gcc-8    | versatile_defc=
onfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fba4272a6f0ecd1a2d8d8fd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.78-17=
-gc4c31af571ec/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.78-17=
-gc4c31af571ec/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fba4272a6f0ecd1a2d8d=
8fe
        failing since 8 days (last pass: v5.4.77-44-gce6b18c3a8969, first f=
ail: v5.4.77-45-gfd610189f77e1) =

 =



platform              | arch  | lab             | compiler | defconfig     =
      | regressions
----------------------+-------+-----------------+----------+---------------=
------+------------
qemu_arm-versatilepb  | arm   | lab-linaro-lkft | gcc-8    | versatile_defc=
onfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fba427fdc99ab6115d8d8fe

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.78-17=
-gc4c31af571ec/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.78-17=
-gc4c31af571ec/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fba427fdc99ab6115d8d=
8ff
        failing since 8 days (last pass: v5.4.77-44-gce6b18c3a8969, first f=
ail: v5.4.77-45-gfd610189f77e1) =

 =



platform              | arch  | lab             | compiler | defconfig     =
      | regressions
----------------------+-------+-----------------+----------+---------------=
------+------------
stm32mp157c-dk2       | arm   | lab-baylibre    | gcc-8    | multi_v7_defco=
nfig  | 1          =


  Details:     https://kernelci.org/test/plan/id/5fba4491f58cc8cdead8d92d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.78-17=
-gc4c31af571ec/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-stm32mp15=
7c-dk2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.78-17=
-gc4c31af571ec/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-stm32mp15=
7c-dk2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fba4491f58cc8cdead8d=
92e
        failing since 27 days (last pass: v5.4.72-54-gc97bc0eb3ef2, first f=
ail: v5.4.72-402-g22eb6f319bc6) =

 =20
