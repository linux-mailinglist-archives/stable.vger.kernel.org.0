Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F215E2D336D
	for <lists+stable@lfdr.de>; Tue,  8 Dec 2020 21:27:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726338AbgLHUTB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Dec 2020 15:19:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726210AbgLHUTA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Dec 2020 15:19:00 -0500
Received: from mail-oi1-x22a.google.com (mail-oi1-x22a.google.com [IPv6:2607:f8b0:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A626BC061793
        for <stable@vger.kernel.org>; Tue,  8 Dec 2020 12:18:19 -0800 (PST)
Received: by mail-oi1-x22a.google.com with SMTP id s2so11314172oij.2
        for <stable@vger.kernel.org>; Tue, 08 Dec 2020 12:18:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=hCoX6ERxtMAiP0idY6ud+OBpbS3GU8zKNTUnGmcDEDY=;
        b=gA2DrFj7QNaMwlIOEIiJcoZW6cbG2Xzs5aI83q3VwU0RNnRYH8QFgrOwovDkNkQRn8
         ndXS0LkHgZTFqq1MS/r6R2T2sXr9TsYuFbE9DGtdNUHD1wLFTwZEuvP5GCfr8ah+EUg/
         EKygiVCD7HiXFMNi68hAXry3tbfeJuzD0XhQ8RNfQUly2jY4hCy+7pAd/oK1ghX97IgO
         bYAGvOetjYFAx6MynIJUxpFlfSX1zoP61an3H1ingn2jrZyebpsOZYx625EoLU71h/T4
         cx6SDQo1pGlpWtEFHbLWdjjMw4Niqh/2GORnIF/2dALt2QkOAeVYy2oiCsqXvQuoTcBD
         Yl0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=hCoX6ERxtMAiP0idY6ud+OBpbS3GU8zKNTUnGmcDEDY=;
        b=S6UeGs08H3ZUpYqCvSG+7pQE+y731qAg/M6AwFLt1qnajEKJ8gq+RGTBIbZ3uvzq7f
         ny7L4Huh2rqBP0dNQyEj1F4W8s/0sKuojUIUIFMX//CI0azkhoqRYqmoIo0nFdDeWuXH
         9A3jNdSyWva3HhDDhrLGnU+rvtDW3BNY8qLfEqsD8gniNVimcgbcPBVHUqHfkfpisnCz
         NQuRrl0WLlG8JjSQa8zsI8SvqSeQMptQ8rWm7kISPEm2n2OtMiW2OGp4Xx3OkJdl7pX9
         c/BfL0HOjhWdHtkJVRrDpYxXccsmlPw5qwD+93apQvAeF5MX3SfG0riqSsfmIJd6r7ZJ
         Wvug==
X-Gm-Message-State: AOAM5306oH/GNYGuMwrj8lI9Xfd582+KFM33j4fPsAyNGRZZWWPJNhTR
        U/IlfbtgC5zvPMCRsJ2PMLA0XlvrQZ6paw==
X-Google-Smtp-Source: ABdhPJyXfK/FaZH6u69barkRzsWQ5lq4f52cz8foJQaENdZwSC1AKOtmxIPMhGo8BzrS7V+giqshoQ==
X-Received: by 2002:a17:90a:5788:: with SMTP id g8mr5712309pji.219.1607458066255;
        Tue, 08 Dec 2020 12:07:46 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id x1sm18864285pfj.95.2020.12.08.12.07.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Dec 2020 12:07:45 -0800 (PST)
Message-ID: <5fcfdd11.1c69fb81.1cbf6.b62e@mx.google.com>
Date:   Tue, 08 Dec 2020 12:07:45 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.4
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.4.81-43-g14810ae56a6b
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.4 baseline: 163 runs,
 7 regressions (v5.4.81-43-g14810ae56a6b)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 163 runs, 7 regressions (v5.4.81-43-g14810ae5=
6a6b)

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

qemu_arm-versatilepb  | arm   | lab-linaro-lkft | gcc-8    | versatile_defc=
onfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.81-43-g14810ae56a6b/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.81-43-g14810ae56a6b
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      14810ae56a6b1ec33317cd6e2206383991e85d95 =



Test Regressions
---------------- =



platform              | arch  | lab             | compiler | defconfig     =
      | regressions
----------------------+-------+-----------------+----------+---------------=
------+------------
at91-sama5d4_xplained | arm   | lab-baylibre    | gcc-8    | sama5_defconfi=
g     | 1          =


  Details:     https://kernelci.org/test/plan/id/5fcfa96c109e5f79aec94ce4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sama5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.81-43=
-g14810ae56a6b/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5d4=
_xplained.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.81-43=
-g14810ae56a6b/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5d4=
_xplained.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fcfa96c109e5f79aec94=
ce5
        failing since 40 days (last pass: v5.4.72-409-gbbe9df5e07cf, first =
fail: v5.4.72-409-ga6e47f533653) =

 =



platform              | arch  | lab             | compiler | defconfig     =
      | regressions
----------------------+-------+-----------------+----------+---------------=
------+------------
bcm2837-rpi-3-b       | arm64 | lab-baylibre    | gcc-8    | defconfig     =
      | 1          =


  Details:     https://kernelci.org/test/plan/id/5fcfa5c569399be3e2c94cdc

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.81-43=
-g14810ae56a6b/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.81-43=
-g14810ae56a6b/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.dmesg.crit: https://kernelci.org/test/case/id/5fcfa5c569399be3=
e2c94cdf
        failing since 0 day (last pass: v5.4.81-39-g99db1ab959b5, first fai=
l: v5.4.81-39-g6914c65a99a14)
        1 lines

    2020-12-08 16:09:38.657000+00:00  Connected to bcm2837-rpi-3-b console =
[channel connected] (~$quit to exit)
    2020-12-08 16:09:38.658000+00:00  (user:khilman) is already connected
    2020-12-08 16:09:53.939000+00:00  =00
    2020-12-08 16:09:53.939000+00:00  =

    2020-12-08 16:09:53.939000+00:00  U-Boot 2018.11 (Dec 04 2018 - 10:54:3=
2 -0800)
    2020-12-08 16:09:53.940000+00:00  =

    2020-12-08 16:09:53.940000+00:00  DRAM:  948 MiB
    2020-12-08 16:09:53.955000+00:00  RPI 3 Model B (0xa02082)
    2020-12-08 16:09:54.042000+00:00  MMC:   mmc@7e202000: 0, sdhci@7e30000=
0: 1
    2020-12-08 16:09:54.074000+00:00  Loading Environment from FAT... *** W=
arning - bad CRC, using default environment =

    ... (377 line(s) more)  =

 =



platform              | arch  | lab             | compiler | defconfig     =
      | regressions
----------------------+-------+-----------------+----------+---------------=
------+------------
hifive-unleashed-a00  | riscv | lab-baylibre    | gcc-8    | defconfig     =
      | 1          =


  Details:     https://kernelci.org/test/plan/id/5fcfa8bab1f8e3812dc94cf8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (riscv64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.81-43=
-g14810ae56a6b/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleashed=
-a00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.81-43=
-g14810ae56a6b/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleashed=
-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/riscv/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fcfa8bab1f8e3812dc94=
cf9
        failing since 18 days (last pass: v5.4.78-5-g843222460ebea, first f=
ail: v5.4.78-13-g81acf0f7c6ec) =

 =



platform              | arch  | lab             | compiler | defconfig     =
      | regressions
----------------------+-------+-----------------+----------+---------------=
------+------------
qemu_arm-versatilepb  | arm   | lab-baylibre    | gcc-8    | versatile_defc=
onfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fcfa61b64c958037ac94cc3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.81-43=
-g14810ae56a6b/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.81-43=
-g14810ae56a6b/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fcfa61b64c958037ac94=
cc4
        failing since 24 days (last pass: v5.4.77-44-gce6b18c3a8969, first =
fail: v5.4.77-45-gfd610189f77e1) =

 =



platform              | arch  | lab             | compiler | defconfig     =
      | regressions
----------------------+-------+-----------------+----------+---------------=
------+------------
qemu_arm-versatilepb  | arm   | lab-broonie     | gcc-8    | versatile_defc=
onfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fcfa77cb279a0b63dc94cc8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.81-43=
-g14810ae56a6b/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-=
versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.81-43=
-g14810ae56a6b/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-=
versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fcfa77cb279a0b63dc94=
cc9
        failing since 24 days (last pass: v5.4.77-44-gce6b18c3a8969, first =
fail: v5.4.77-45-gfd610189f77e1) =

 =



platform              | arch  | lab             | compiler | defconfig     =
      | regressions
----------------------+-------+-----------------+----------+---------------=
------+------------
qemu_arm-versatilepb  | arm   | lab-cip         | gcc-8    | versatile_defc=
onfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fcfa64f688f69bac3c94cba

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.81-43=
-g14810ae56a6b/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-vers=
atilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.81-43=
-g14810ae56a6b/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-vers=
atilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fcfa64f688f69bac3c94=
cbb
        failing since 24 days (last pass: v5.4.77-44-gce6b18c3a8969, first =
fail: v5.4.77-45-gfd610189f77e1) =

 =



platform              | arch  | lab             | compiler | defconfig     =
      | regressions
----------------------+-------+-----------------+----------+---------------=
------+------------
qemu_arm-versatilepb  | arm   | lab-linaro-lkft | gcc-8    | versatile_defc=
onfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fcfb79d7fd3b07cc9c94cb9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.81-43=
-g14810ae56a6b/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.81-43=
-g14810ae56a6b/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fcfb79d7fd3b07cc9c94=
cba
        failing since 24 days (last pass: v5.4.77-44-gce6b18c3a8969, first =
fail: v5.4.77-45-gfd610189f77e1) =

 =20
