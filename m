Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4AA12A0778
	for <lists+stable@lfdr.de>; Fri, 30 Oct 2020 15:08:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726772AbgJ3OI6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Oct 2020 10:08:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726653AbgJ3OI6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 30 Oct 2020 10:08:58 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 697F9C0613CF
        for <stable@vger.kernel.org>; Fri, 30 Oct 2020 07:08:58 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id i7so3367554pgh.6
        for <stable@vger.kernel.org>; Fri, 30 Oct 2020 07:08:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Ikny6+P9/EmzsXxPBtj+pYawibXhP9rVIWyelWiVDE0=;
        b=MhFVBqNf4pGg5lkkIfq29KD/tDraCO9f1lEaVueyZLlx9PON0/ZIcioq3N8QQAfllj
         EIEJHBPvoeLS5PJW93YoEqjB7xEQhfhqlRf5mfifxLH0ngWC1JQ494gX7BVyWA/+LDEh
         vksFGGdNevShFuZ1uTR8tTUoUkkExeKuG4ETl8oXyBA/to0B0etkpsy20VHuue/nWZVq
         5TL3liKKOsVnk0v+THaoR071oS+S4Gbo4G3I0D8ESnGRVV27UYADQ1nCOS1U9qumMyPe
         JaXzpwf0m+QnVd6RALMK17+Lt6mkAAjAFf/R5s4kFGXN1wffQXKvfX74OF/3uv4WeNmO
         z9vQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Ikny6+P9/EmzsXxPBtj+pYawibXhP9rVIWyelWiVDE0=;
        b=aK7NSsPe2s7bZi3BsFwwofKWyFVXWtk2ccQNg7mWFLMq6zFTekVsF9qNxBF/CQ4XuV
         pR4o10vLeamYcCAQcMHPOAQo8FYKgC36pblDt3zLvJ44JCuT2khljPBErbtcaN2PWMF3
         IUf6GS4tVKHXygbXcm/2nv7zFS4DVLTlpBntsqNLxJlYzOIUIGQ+6/jJuEHFoJ4Bi1u+
         MykiNQv2VvKZvAKzPMrLlDH4vZeTHLOv1wn9cmF/FjeT1UUJQwH3fZHGCgyCdCiSKu/7
         icwcTHU0Brnw8Iy71qm1abG+o9kTx+EYbTJAnyTPhK+U3CAH+rod6EndoKrVbgtN4U6a
         NyQA==
X-Gm-Message-State: AOAM533yiPAaKdZpKMl39zLiRhqCAS6xeumZRImNLelYrL9GPlMQYjdY
        29YzcEgIRiLSJ6s6MTc6TyytrkrU63ydCw==
X-Google-Smtp-Source: ABdhPJzqpTWAkeeWPwdzNWkKSUtAqCWjXRS8L6qocNLy493+vUbzEvTGo7EpUNWRs/gdQuPtLCQx1w==
X-Received: by 2002:a17:90b:3542:: with SMTP id lt2mr3054695pjb.187.1604066937630;
        Fri, 30 Oct 2020 07:08:57 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id k8sm5734572pgi.39.2020.10.30.07.08.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Oct 2020 07:08:57 -0700 (PDT)
Message-ID: <5f9c1e79.1c69fb81.8d5fe.ca59@mx.google.com>
Date:   Fri, 30 Oct 2020 07:08:57 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.4.73-9-g812d5e88da7e
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.4
Subject: stable-rc/queue/5.4 baseline: 195 runs,
 3 regressions (v5.4.73-9-g812d5e88da7e)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 195 runs, 3 regressions (v5.4.73-9-g812d5e88d=
a7e)

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
el/v5.4.73-9-g812d5e88da7e/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.73-9-g812d5e88da7e
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      812d5e88da7e4742f168ef8764d79a496f9c3fc4 =



Test Regressions
---------------- =



platform              | arch  | lab          | compiler | defconfig        =
  | regressions
----------------------+-------+--------------+----------+------------------=
--+------------
at91-sama5d4_xplained | arm   | lab-baylibre | gcc-8    | sama5_defconfig  =
  | 1          =


  Details:     https://kernelci.org/test/plan/id/5f9bea8dc87425b5dd38104e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sama5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.73-9-=
g812d5e88da7e/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5d4_=
xplained.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.73-9-=
g812d5e88da7e/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5d4_=
xplained.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5f9bea8dc87425b5dd381=
04f
        failing since 1 day (last pass: v5.4.72-409-gbbe9df5e07cf, first fa=
il: v5.4.72-409-ga6e47f533653) =

 =



platform              | arch  | lab          | compiler | defconfig        =
  | regressions
----------------------+-------+--------------+----------+------------------=
--+------------
bcm2837-rpi-3-b       | arm64 | lab-baylibre | gcc-8    | defconfig        =
  | 1          =


  Details:     https://kernelci.org/test/plan/id/5f9be8e4eb7ca811f238102b

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.73-9-=
g812d5e88da7e/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b.t=
xt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.73-9-=
g812d5e88da7e/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.dmesg.crit: https://kernelci.org/test/case/id/5f9be8e4eb7ca811=
f2381030
        new failure (last pass: v5.4.73-9-ga9c55e5daa9c)
        1 lines

    2020-10-30 10:18:21.395000+00:00  Connected to bcm2837-rpi-3-b console =
[channel connected] (~$quit to exit)
    2020-10-30 10:18:21.395000+00:00  (user:khilman) is already connected
    2020-10-30 10:18:37.762000+00:00  =00
    2020-10-30 10:18:37.763000+00:00  =

    2020-10-30 10:18:37.763000+00:00  U-Boot 2018.11 (Dec 04 2018 - 10:54:3=
2 -0800)
    2020-10-30 10:18:37.763000+00:00  =

    2020-10-30 10:18:37.763000+00:00  DRAM:  948 MiB
    2020-10-30 10:18:37.779000+00:00  RPI 3 Model B (0xa02082)
    2020-10-30 10:18:37.866000+00:00  MMC:   mmc@7e202000: 0, sdhci@7e30000=
0: 1
    2020-10-30 10:18:37.898000+00:00  Loading Environment from FAT... *** W=
arning - bad CRC, using default environment =

    ... (379 line(s) more)  =

 =



platform              | arch  | lab          | compiler | defconfig        =
  | regressions
----------------------+-------+--------------+----------+------------------=
--+------------
stm32mp157c-dk2       | arm   | lab-baylibre | gcc-8    | multi_v7_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/5f9bee6723374fad0a38101d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.73-9-=
g812d5e88da7e/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-stm32mp157=
c-dk2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.73-9-=
g812d5e88da7e/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-stm32mp157=
c-dk2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5f9bee6723374fad0a381=
01e
        failing since 4 days (last pass: v5.4.72-54-gc97bc0eb3ef2, first fa=
il: v5.4.72-402-g22eb6f319bc6) =

 =20
