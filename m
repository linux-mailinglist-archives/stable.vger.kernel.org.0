Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21C6832C843
	for <lists+stable@lfdr.de>; Thu,  4 Mar 2021 02:14:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377664AbhCDAfQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Mar 2021 19:35:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1391908AbhCCW62 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 3 Mar 2021 17:58:28 -0500
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C476C061756
        for <stable@vger.kernel.org>; Wed,  3 Mar 2021 14:45:42 -0800 (PST)
Received: by mail-pl1-x635.google.com with SMTP id u18so8717456plc.12
        for <stable@vger.kernel.org>; Wed, 03 Mar 2021 14:45:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=dlwWy0IzEuEObO/JiDgoHSaKC58Pg9BM9C9gE7CuPR4=;
        b=E5MjHig4PMZHOA8cadY4di3rMlFw1CdgF128XAjV1NTG8zTcEj+grcphsTvz/DAq1f
         c1fFy6uESdqC3QQglnXfBrxeSuH3x3DY7Av2FJAXFQLWleEBBQFve4HKWiPvP8yDziQi
         N/NmUnj9fXWVNaopDJo3xT1uiG5rNE8yJ3y6pq+MK91Z2qaEkL5OnErinW2qoyQLvr4w
         TZDQbQbd9VN3KbEBXsT8bG8Ib+0ZvludsQXqS9NtwRh7L7jovXPZwesuim8CxbgF9XKB
         TwBmpfzY5S7NwOIY5kq0xX7GE3sfZBUHFv69iU/dbDzk7gRG/UEaez/jWEwkkBZ1PZp1
         WI+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=dlwWy0IzEuEObO/JiDgoHSaKC58Pg9BM9C9gE7CuPR4=;
        b=jTdxDkJrotlR3kMogTy9+LYRLvi01PalY75MlNR+kV2mJS2IaS6E7TpL3GvtmPyUyw
         HBN8+uFY8/j/Hw1Q1KhTN1yajMqxFHKydDanFDHgNjmeDuurDXLtJ4FP457xOj/2iyyS
         hONHNbVqCBQiY8qz3K+zeYdwu4yqiRYzuwxHHgM6X0SKIFMqLWgBJkhBcpcOumIJAJbC
         AtbEGcQfWvB5koqgZZ55Of/OmjlTQJhmkwEop19ZGV1KooCyiZElM/6GsNQ23Dz8+jHB
         +6tachlIzSMUaa2Er9lmh/nk0X1bHHDnLJl0fStWgoU4eqI2Aor9xO6Wcbnp3QxvgsBf
         fi7g==
X-Gm-Message-State: AOAM5336j/mBEp+dBlSpT8LTrA/ZGZvGDizW1bcFr6Z6aWd7Wn7YSd0x
        fJSsHcP/kQlTGgYJNfHfe44IzZaBO4zzpMhw
X-Google-Smtp-Source: ABdhPJxP09qPAzByLEosxlin2FajX7PLqHUj0uy0yLIDal4IIjhRwCc6P2kNeMzmJLH9Uw+W1vi6CQ==
X-Received: by 2002:a17:90a:d497:: with SMTP id s23mr1288394pju.148.1614811541365;
        Wed, 03 Mar 2021 14:45:41 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id ge16sm7918529pjb.43.2021.03.03.14.45.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Mar 2021 14:45:41 -0800 (PST)
Message-ID: <60401195.1c69fb81.bcfdf.1a83@mx.google.com>
Date:   Wed, 03 Mar 2021 14:45:41 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.4.101-336-g3c46b38d7ba7
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.4
Subject: stable-rc/queue/5.4 baseline: 167 runs,
 5 regressions (v5.4.101-336-g3c46b38d7ba7)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 167 runs, 5 regressions (v5.4.101-336-g3c46b3=
8d7ba7)

Regressions Summary
-------------------

platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
hifive-unleashed-a00 | riscv | lab-baylibre    | gcc-8    | defconfig      =
     | 1          =

qemu_arm-versatilepb | arm   | lab-baylibre    | gcc-8    | versatile_defco=
nfig | 1          =

qemu_arm-versatilepb | arm   | lab-cip         | gcc-8    | versatile_defco=
nfig | 1          =

qemu_arm-versatilepb | arm   | lab-collabora   | gcc-8    | versatile_defco=
nfig | 1          =

qemu_arm-versatilepb | arm   | lab-linaro-lkft | gcc-8    | versatile_defco=
nfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.101-336-g3c46b38d7ba7/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.101-336-g3c46b38d7ba7
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      3c46b38d7ba77519c148011c49e8886856964b1d =



Test Regressions
---------------- =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
hifive-unleashed-a00 | riscv | lab-baylibre    | gcc-8    | defconfig      =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/603fdbc5bedc7977deaddcb1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (riscv64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.101-3=
36-g3c46b38d7ba7/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleash=
ed-a00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.101-3=
36-g3c46b38d7ba7/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleash=
ed-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/riscv/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/603fdbc5bedc7977deadd=
cb2
        failing since 103 days (last pass: v5.4.78-5-g843222460ebea, first =
fail: v5.4.78-13-g81acf0f7c6ec) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-baylibre    | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/603fda283ac6108516addcbe

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.101-3=
36-g3c46b38d7ba7/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.101-3=
36-g3c46b38d7ba7/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/603fda283ac6108516add=
cbf
        failing since 110 days (last pass: v5.4.77-44-gce6b18c3a8969, first=
 fail: v5.4.77-45-gfd610189f77e1) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-cip         | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/603fdeaedc0d164184addcda

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.101-3=
36-g3c46b38d7ba7/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.101-3=
36-g3c46b38d7ba7/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/603fdeaedc0d164184add=
cdb
        failing since 110 days (last pass: v5.4.77-44-gce6b18c3a8969, first=
 fail: v5.4.77-45-gfd610189f77e1) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-collabora   | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/603fd9db690723d65faddcb4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.101-3=
36-g3c46b38d7ba7/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.101-3=
36-g3c46b38d7ba7/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/603fd9db690723d65fadd=
cb5
        failing since 110 days (last pass: v5.4.77-44-gce6b18c3a8969, first=
 fail: v5.4.77-45-gfd610189f77e1) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-linaro-lkft | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/603fd9e17ca186782caddcca

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.101-3=
36-g3c46b38d7ba7/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.101-3=
36-g3c46b38d7ba7/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/603fd9e17ca186782cadd=
ccb
        failing since 110 days (last pass: v5.4.77-44-gce6b18c3a8969, first=
 fail: v5.4.77-45-gfd610189f77e1) =

 =20
