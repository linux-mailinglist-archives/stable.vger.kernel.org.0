Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C2A329E566
	for <lists+stable@lfdr.de>; Thu, 29 Oct 2020 08:56:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727178AbgJ2HYp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Oct 2020 03:24:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726715AbgJ2HYd (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Oct 2020 03:24:33 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E95C3C0613B6
        for <stable@vger.kernel.org>; Wed, 28 Oct 2020 22:14:51 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id i26so1386026pgl.5
        for <stable@vger.kernel.org>; Wed, 28 Oct 2020 22:14:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=2LdgmoDA1jfv3qEwqnYJIM2BJ1ki3oav4lv+vPaQbRc=;
        b=Od6+zzHaNPmumt+uh8ZOKXRQh3ZrHdQFab2Tc4rrWlFoVQ04Sf34Wuyg+2EpyZzq8B
         aP3pxg2L8YSHQ/swJU83JdQjTobuUalbvFKcclFe0XU/g99GVkLjmtcGC6xOd3NJZg6i
         0P5B92AWmhYDC/beiUNY3N4dk6ou37Mt2e1PTSTHWL3UDIR1fZoUZ5l+JwYpMBu5wbks
         KnwjWxNGkXqJQ1LH5cxZIRFDcBco+h7PI70cpqe8vMwf+oYNtRlJ61mf30Tgqam9OMY9
         DMgPCyJQOBRxUF1kKHPsNSnMxvFXTLyXRB00EngoD2DsHZTdWrzWNm5xjGWygMYnzKw8
         gV/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=2LdgmoDA1jfv3qEwqnYJIM2BJ1ki3oav4lv+vPaQbRc=;
        b=ulFqUNz0f9OS8gyP1mRmcrh6EH17cmHibCMLRIOEM9kWGiOH6vPRPnDSGEqv/MFI9F
         gJRIMx7iXscHoaaYfTSb68yc3gJvcm1q2KtiKP8uw5VkDgjS+QC67ap/NuV+xfLOCeP/
         NdhsYMaYDWReOGKd2nGVzSMIqEUOqd89xiOuhWQR7/ypviY0cOy+HEc3PLjWv9e8Zl7s
         Dd1BE270NqF3/tBDIIQl5ll9NWPumXj/yYUe9M0YFL29JxUrfth6MtCQn1fLerJpLzsA
         2C6WbcjMSLZbdG5MbRoqrTT8YID0+rYPx89+hj84+QTARpQYy1yBwjWngZjnxHEYJAEh
         1w/Q==
X-Gm-Message-State: AOAM532VrzkH33RYV4zTeTCDsGjCNyf/qRO/tAdRn2YDA10uHYhbmqmQ
        Sp66x2wKRvoTXaqNlQLriCkDNwrZWS6gSQ==
X-Google-Smtp-Source: ABdhPJz7dmzrTAZWk8+Fix6hh4/SDOqEO66L5tzwTd8tu7a9B9CnpX/yMMSvv12Mc2qYoDoE/3jjEg==
X-Received: by 2002:a17:90b:378c:: with SMTP id mz12mr2501615pjb.137.1603948491036;
        Wed, 28 Oct 2020 22:14:51 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id f5sm1071329pgi.86.2020.10.28.22.14.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Oct 2020 22:14:50 -0700 (PDT)
Message-ID: <5f9a4fca.1c69fb81.611ab.318a@mx.google.com>
Date:   Wed, 28 Oct 2020 22:14:50 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.4.72-409-ga6e47f533653
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.4
Subject: stable-rc/queue/5.4 baseline: 207 runs,
 5 regressions (v5.4.72-409-ga6e47f533653)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 207 runs, 5 regressions (v5.4.72-409-ga6e47f5=
33653)

Regressions Summary
-------------------

platform               | arch   | lab          | compiler | defconfig      =
    | regressions
-----------------------+--------+--------------+----------+----------------=
----+------------
at91-sama5d4_xplained  | arm    | lab-baylibre | gcc-8    | sama5_defconfig=
    | 1          =

bcm2837-rpi-3-b        | arm64  | lab-baylibre | gcc-8    | defconfig      =
    | 1          =

qemu_i386              | i386   | lab-baylibre | gcc-8    | i386_defconfig =
    | 1          =

qemu_x86_64-uefi-mixed | x86_64 | lab-baylibre | gcc-8    | x86_64_defconfi=
g   | 1          =

stm32mp157c-dk2        | arm    | lab-baylibre | gcc-8    | multi_v7_defcon=
fig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.72-409-ga6e47f533653/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.72-409-ga6e47f533653
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      a6e47f533653965ebb11d2adf8f6d660f66f2ead =



Test Regressions
---------------- =



platform               | arch   | lab          | compiler | defconfig      =
    | regressions
-----------------------+--------+--------------+----------+----------------=
----+------------
at91-sama5d4_xplained  | arm    | lab-baylibre | gcc-8    | sama5_defconfig=
    | 1          =


  Details:     https://kernelci.org/test/plan/id/5f9a1c32a419360373381032

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sama5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.72-40=
9-ga6e47f533653/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5d=
4_xplained.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.72-40=
9-ga6e47f533653/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5d=
4_xplained.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5f9a1c32a419360373381=
033
        new failure (last pass: v5.4.72-409-gbbe9df5e07cf) =

 =



platform               | arch   | lab          | compiler | defconfig      =
    | regressions
-----------------------+--------+--------------+----------+----------------=
----+------------
bcm2837-rpi-3-b        | arm64  | lab-baylibre | gcc-8    | defconfig      =
    | 1          =


  Details:     https://kernelci.org/test/plan/id/5f9a1b72b91b9db96138101e

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.72-40=
9-ga6e47f533653/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.72-40=
9-ga6e47f533653/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.dmesg.crit: https://kernelci.org/test/case/id/5f9a1b72b91b9db9=
61381023
        failing since 2 days (last pass: v5.4.72-402-g22eb6f319bc6, first f=
ail: v5.4.72-402-ga4d1bb864783)
        2 lines

    2020-10-29 01:28:50.531000+00:00  Connected to bcm2837-rpi-3-b console =
[channel connected] (~$quit to exit)
    2020-10-29 01:28:50.531000+00:00  (user:khilman) is already connected
    2020-10-29 01:29:06.061000+00:00  =00
    2020-10-29 01:29:06.062000+00:00  =

    2020-10-29 01:29:06.077000+00:00  U-Boot 2018.11 (Dec 04 2018 - 10:54:3=
2 -0800)
    2020-10-29 01:29:06.078000+00:00  =

    2020-10-29 01:29:06.078000+00:00  DRAM:  948 MiB
    2020-10-29 01:29:06.093000+00:00  RPI 3 Model B (0xa02082)
    2020-10-29 01:29:06.185000+00:00  MMC:   mmc@7e202000: 0, sdhci@7e30000=
0: 1
    2020-10-29 01:29:06.217000+00:00  Loading Environment from FAT... *** W=
arning - bad CRC, using default environment =

    ... (385 line(s) more)  =

 =



platform               | arch   | lab          | compiler | defconfig      =
    | regressions
-----------------------+--------+--------------+----------+----------------=
----+------------
qemu_i386              | i386   | lab-baylibre | gcc-8    | i386_defconfig =
    | 1          =


  Details:     https://kernelci.org/test/plan/id/5f9a1c9d79004aae86381025

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.72-40=
9-ga6e47f533653/i386/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i386.t=
xt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.72-40=
9-ga6e47f533653/i386/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i386.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5f9a1c9d79004aae86381=
026
        new failure (last pass: v5.4.72-409-gbbe9df5e07cf) =

 =



platform               | arch   | lab          | compiler | defconfig      =
    | regressions
-----------------------+--------+--------------+----------+----------------=
----+------------
qemu_x86_64-uefi-mixed | x86_64 | lab-baylibre | gcc-8    | x86_64_defconfi=
g   | 1          =


  Details:     https://kernelci.org/test/plan/id/5f9a1cd09e2a8984c638101c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.72-40=
9-ga6e47f533653/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu_x8=
6_64-uefi-mixed.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.72-40=
9-ga6e47f533653/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu_x8=
6_64-uefi-mixed.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5f9a1cd09e2a8984c6381=
01d
        new failure (last pass: v5.4.72-409-gbbe9df5e07cf) =

 =



platform               | arch   | lab          | compiler | defconfig      =
    | regressions
-----------------------+--------+--------------+----------+----------------=
----+------------
stm32mp157c-dk2        | arm    | lab-baylibre | gcc-8    | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5f9a1dbcb7cede3df2381015

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.72-40=
9-ga6e47f533653/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-stm32mp1=
57c-dk2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.72-40=
9-ga6e47f533653/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-stm32mp1=
57c-dk2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5f9a1dbcb7cede3df2381=
016
        failing since 2 days (last pass: v5.4.72-54-gc97bc0eb3ef2, first fa=
il: v5.4.72-402-g22eb6f319bc6) =

 =20
