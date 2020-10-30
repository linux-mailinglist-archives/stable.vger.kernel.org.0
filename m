Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4028B2A0AC7
	for <lists+stable@lfdr.de>; Fri, 30 Oct 2020 17:12:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726930AbgJ3QM0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Oct 2020 12:12:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726890AbgJ3QMY (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 30 Oct 2020 12:12:24 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0540FC0613CF
        for <stable@vger.kernel.org>; Fri, 30 Oct 2020 09:12:24 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id b12so3186032plr.4
        for <stable@vger.kernel.org>; Fri, 30 Oct 2020 09:12:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=clRvQqOI/0667vVdQnGKImQJ/E5DS0RKL3Zy1LVrAic=;
        b=dPC9rJLKSTcx+VqME+dlMh2SonhLXrLbqtw1Ip8OeQ9iAqaA42asbOooknBW0dOyYG
         RB9123VSPonbz/E0WSxAlstKZeszuU/MJR8/Di+03ioYtDujrvYAENGZJYvhaLOcPcAs
         KRPQZSkGnbIrpBe2M429IAUaKLHQRwj+IA0Y434b4f1SV8bjtPfsQ9dPFb6vgsy6BG+R
         EFhmig5Aw8Y9cuTJSRQuZ5dTRTfXo1PB/k0jikdPBgsec/9vWnJex6kvfrmGQTl6d7Dz
         wUZRmUE4RXtSn438TjpqbTGvis9N5z5j+5ajBL/TaJXEG7EJHEXXgD3OZIWoAL8KS1eU
         usfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=clRvQqOI/0667vVdQnGKImQJ/E5DS0RKL3Zy1LVrAic=;
        b=QtJ5/JOo7ZPM1FBmCX7nr06Sh177SXS7cKCegwjFtL8oW/G4ASKdU1CeWHJggmbktM
         0XI8GdNQ9OrOH6gJUeTOovbqezTISZn5rRFNcKgQ0szn4U6v680VL9zRHzF5IdfP8yrD
         nH6iBhQ7jv9TCNfiDHQDOp/P1J8QUNIbh+a4e7IJbo/Elj/Qx4IAZ3He39yY0xgvllVw
         8+dnb5Gp4jM/aXt26MDnt8t08F80kMG+HpGinZ8trXs6UH6KUTDcg9sza4RXyNGVrHP3
         26y/rUhIKDWyQUCbG6WRe3DNzLcnsZfN7MNmWVIu8I8Z0RCUKr3EOMAuJOLuuY321I1H
         qa4A==
X-Gm-Message-State: AOAM533uas3pzzAmc+zkS8Z4yU1RABzFbHGO/8pFsGA7sol1SdzfVWPo
        ET3BAhxBanUn25OkHfZ/r5edFvGa77pxFw==
X-Google-Smtp-Source: ABdhPJxP8Zmb3qzMuNCuRvK6eV05ewAqQfD8/6rqAv4RrUrFoLHWpaEnrZD4xNUSgY5ngfx6RQE2vA==
X-Received: by 2002:a17:902:8545:b029:d5:dbd4:4ab5 with SMTP id d5-20020a1709028545b02900d5dbd44ab5mr9664186plo.31.1604074343090;
        Fri, 30 Oct 2020 09:12:23 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id d190sm6396175pfc.185.2020.10.30.09.12.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Oct 2020 09:12:22 -0700 (PDT)
Message-ID: <5f9c3b66.1c69fb81.6e986.f967@mx.google.com>
Date:   Fri, 30 Oct 2020 09:12:22 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.154-6-ga0d1e09b43bc
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.19
Subject: stable-rc/queue/4.19 baseline: 175 runs,
 2 regressions (v4.19.154-6-ga0d1e09b43bc)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 175 runs, 2 regressions (v4.19.154-6-ga0d1e0=
9b43bc)

Regressions Summary
-------------------

platform        | arch  | lab           | compiler | defconfig           | =
regressions
----------------+-------+---------------+----------+---------------------+-=
-----------
bcm2837-rpi-3-b | arm64 | lab-baylibre  | gcc-8    | defconfig           | =
1          =

panda           | arm   | lab-collabora | gcc-8    | omap2plus_defconfig | =
1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.154-6-ga0d1e09b43bc/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.154-6-ga0d1e09b43bc
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      a0d1e09b43bcbfe95dbd5d399aee601d91f34005 =



Test Regressions
---------------- =



platform        | arch  | lab           | compiler | defconfig           | =
regressions
----------------+-------+---------------+----------+---------------------+-=
-----------
bcm2837-rpi-3-b | arm64 | lab-baylibre  | gcc-8    | defconfig           | =
1          =


  Details:     https://kernelci.org/test/plan/id/5f9bff2b50bc5a712b3810a7

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.154=
-6-ga0d1e09b43bc/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-=
b.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.154=
-6-ga0d1e09b43bc/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-=
b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.dmesg.crit: https://kernelci.org/test/case/id/5f9bff2b50bc5a71=
2b3810ac
        new failure (last pass: v4.19.153-118-ga7e6db9970f8)
        2 lines

    2020-10-30 11:53:24.250000+00:00  Connected to bcm2837-rpi-3-b console =
[channel connected] (~$quit to exit)
    2020-10-30 11:53:24.251000+00:00  (user:khilman) is already connected
    2020-10-30 11:53:40.166000+00:00  =00
    2020-10-30 11:53:40.166000+00:00  =

    2020-10-30 11:53:40.182000+00:00  U-Boot 2018.11 (Dec 04 2018 - 10:54:3=
2 -0800)
    2020-10-30 11:53:40.182000+00:00  =

    2020-10-30 11:53:40.182000+00:00  DRAM:  948 MiB
    2020-10-30 11:53:40.198000+00:00  RPI 3 Model B (0xa02082)
    2020-10-30 11:53:40.287000+00:00  MMC:   mmc@7e202000: 0, sdhci@7e30000=
0: 1
    2020-10-30 11:53:40.319000+00:00  Loading Environment from FAT... *** W=
arning - bad CRC, using default environment =

    ... (374 line(s) more)  =

 =



platform        | arch  | lab           | compiler | defconfig           | =
regressions
----------------+-------+---------------+----------+---------------------+-=
-----------
panda           | arm   | lab-collabora | gcc-8    | omap2plus_defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/5f9c0561723e6f1aab38102b

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.154=
-6-ga0d1e09b43bc/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.154=
-6-ga0d1e09b43bc/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5f9c0561723e6f1=
aab381032
        new failure (last pass: v4.19.153-118-ga7e6db9970f8)
        2 lines =

 =20
