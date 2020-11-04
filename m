Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B8CA2A66C0
	for <lists+stable@lfdr.de>; Wed,  4 Nov 2020 15:51:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729862AbgKDOvu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Nov 2020 09:51:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730097AbgKDOvt (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Nov 2020 09:51:49 -0500
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2977C0613D3
        for <stable@vger.kernel.org>; Wed,  4 Nov 2020 06:51:49 -0800 (PST)
Received: by mail-pl1-x62b.google.com with SMTP id b12so10402074plr.4
        for <stable@vger.kernel.org>; Wed, 04 Nov 2020 06:51:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=u2zczyQW/B+DLSjXOTijTQs6rn8y62O7fDDDqNX7f6I=;
        b=WYkAWrKkd/DKWHAYiQDRQuTVcz7riXLtZHKzVXTs/L3QJE6PVosaQua4CatlFZgOWf
         nFG5DuPvYVPNkdhU3GwTl3BrxANWQhucGBsuLzbDCrHnjOhhcyZJc3DF4egKolTt2xfJ
         DD+sV2a4NnJXLN8qZcBcgzcLqnQGsxRXp78ak+m8kwA9Pbs5PLm5SAA1r/ZymEqJAwVd
         Y8R9pVKYrSDLh6f1tNicvIdh/OsjHi9fbtoBTa9g17wfgUswDBEH3OxxXLY7usaVtGQ5
         Q6bhVUksFH0VM3VesXv4R1F8zvNMhkGtNekxicHAAZKekcG8nY5QMz/RxJN2uwiQGAWT
         WPUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=u2zczyQW/B+DLSjXOTijTQs6rn8y62O7fDDDqNX7f6I=;
        b=NaO4Iutd63lQHzeQqG0p8d8X4kkc2KPhVGNROtnPoWUVuhEhwBEEq9DGCxtPSxUpcN
         I+hcy2q4R74NlZ21Cabraq0OINhfM/XROBpDdD1JE8RomcgMb+S2BZkGpBweAUH+IfD5
         Oe7R5gxSKKikQuEInqfDuD8ajqvLCHmTe9fL7yKAxEReF4CLDyD3R0neNV1K8Q41ws/T
         RxVRgSop+R06HSs5vYdLK4uR/kfzIJrKNbUIFbA3qviiel9irZEDdJGr2Qn4MwatT9E+
         RUq9JjNSkAiArfM9qlArUJnV9r3qeKZUe0fLhQNNzA2nFA/huCZIOytCMNyUJn+i66Uq
         dfRQ==
X-Gm-Message-State: AOAM532xBI8BPF91a/xeuUCUPTnKndmDZuth9R9KxFpVPI950DmNMLU9
        LsmKuGISPkn7tFUE0Ccd8xQ19uBKlAnNpw==
X-Google-Smtp-Source: ABdhPJyQGEj9FWiROuR2Dkfniy+n5DrAijztda64yEeXEhc8di5MbHydRh8cwDxcsCB1svUGr3x8CQ==
X-Received: by 2002:a17:902:fe0f:b029:d6:cf9d:3260 with SMTP id g15-20020a170902fe0fb02900d6cf9d3260mr13005486plj.3.1604501509005;
        Wed, 04 Nov 2020 06:51:49 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id w10sm2510582pjy.57.2020.11.04.06.51.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2020 06:51:48 -0800 (PST)
Message-ID: <5fa2c004.1c69fb81.f04ee.5d6d@mx.google.com>
Date:   Wed, 04 Nov 2020 06:51:48 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.4.74-212-g1156c065dac4
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/5.4
Subject: stable-rc/queue/5.4 baseline: 212 runs,
 3 regressions (v5.4.74-212-g1156c065dac4)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 212 runs, 3 regressions (v5.4.74-212-g1156c06=
5dac4)

Regressions Summary
-------------------

platform              | arch  | lab          | compiler | defconfig        =
  | regressions
----------------------+-------+--------------+----------+------------------=
--+------------
at91-sama5d4_xplained | arm   | lab-baylibre | gcc-8    | sama5_defconfig  =
  | 1          =

bcm2837-rpi-3-b       | arm64 | lab-baylibre | gcc-8    | defconfig        =
  | 1          =

stm32mp157c-dk2       | arm   | lab-baylibre | gcc-8    | multi_v7_defconfi=
g | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.74-212-g1156c065dac4/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.74-212-g1156c065dac4
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      1156c065dac4bd9d2a5d63488904de2ede9bb688 =



Test Regressions
---------------- =



platform              | arch  | lab          | compiler | defconfig        =
  | regressions
----------------------+-------+--------------+----------+------------------=
--+------------
at91-sama5d4_xplained | arm   | lab-baylibre | gcc-8    | sama5_defconfig  =
  | 1          =


  Details:     https://kernelci.org/test/plan/id/5fa28da43d68fc98fafb5329

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sama5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.74-21=
2-g1156c065dac4/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5d=
4_xplained.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.74-21=
2-g1156c065dac4/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5d=
4_xplained.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fa28da43d68fc98fafb5=
32a
        failing since 6 days (last pass: v5.4.72-409-gbbe9df5e07cf, first f=
ail: v5.4.72-409-ga6e47f533653) =

 =



platform              | arch  | lab          | compiler | defconfig        =
  | regressions
----------------------+-------+--------------+----------+------------------=
--+------------
bcm2837-rpi-3-b       | arm64 | lab-baylibre | gcc-8    | defconfig        =
  | 1          =


  Details:     https://kernelci.org/test/plan/id/5fa28b34e6d22d6461fb530f

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.74-21=
2-g1156c065dac4/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.74-21=
2-g1156c065dac4/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.dmesg.crit: https://kernelci.org/test/case/id/5fa28b34e6d22d64=
61fb5314
        failing since 0 day (last pass: v5.4.74-95-g49cb9af04b0c, first fai=
l: v5.4.74-213-g67dd1e38607a)
        2 lines

    2020-11-04 11:04:16.289000+00:00  Connected to bcm2837-rpi-3-b console =
[channel connected] (~$quit to exit)
    2020-11-04 11:04:16.289000+00:00  (user:khilman) is already connected
    2020-11-04 11:04:32.218000+00:00  =00
    2020-11-04 11:04:32.218000+00:00  =

    2020-11-04 11:04:32.219000+00:00  U-Boot 2018.11 (Dec 04 2018 - 10:54:3=
2 -0800)
    2020-11-04 11:04:32.219000+00:00  =

    2020-11-04 11:04:32.219000+00:00  DRAM:  948 MiB
    2020-11-04 11:04:32.234000+00:00  RPI 3 Model B (0xa02082)
    2020-11-04 11:04:32.321000+00:00  MMC:   mmc@7e202000: 0, sdhci@7e30000=
0: 1
    2020-11-04 11:04:32.353000+00:00  Loading Environment from FAT... *** W=
arning - bad CRC, using default environment =

    ... (381 line(s) more)  =

 =



platform              | arch  | lab          | compiler | defconfig        =
  | regressions
----------------------+-------+--------------+----------+------------------=
--+------------
stm32mp157c-dk2       | arm   | lab-baylibre | gcc-8    | multi_v7_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/5fa28ed8b7046f266afb5319

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.74-21=
2-g1156c065dac4/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-stm32mp1=
57c-dk2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.74-21=
2-g1156c065dac4/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-stm32mp1=
57c-dk2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fa28ed8b7046f266afb5=
31a
        failing since 9 days (last pass: v5.4.72-54-gc97bc0eb3ef2, first fa=
il: v5.4.72-402-g22eb6f319bc6) =

 =20
