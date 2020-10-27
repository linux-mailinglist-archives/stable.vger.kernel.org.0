Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB02129C9D5
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 21:13:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1830959AbgJ0UMN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 16:12:13 -0400
Received: from mail-pl1-f174.google.com ([209.85.214.174]:33020 "EHLO
        mail-pl1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1830957AbgJ0UMN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Oct 2020 16:12:13 -0400
Received: by mail-pl1-f174.google.com with SMTP id b19so1361487pld.0
        for <stable@vger.kernel.org>; Tue, 27 Oct 2020 13:12:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=w4xHdz31RwxiLV3EKKydlXk40aZioL7OqymsIw+Nudk=;
        b=Sf3PKH/Stxb52Jy/EOTcpt0+NX2KZ7yLJYYKqfbnsO1ue1E/ULFv9e08xbsVdY1mWP
         ggAj7McbT+rcAM+pGfr3shS1ezjLHasHITuTEqnrc9dAUMU6hhJqt2P37BKUXiVP3l7+
         n0YFVXOM+paMQ8xEux2ABylo5gD7HNSgcQksAajomeASjX1OmdcXSo7pLayqge+LcpjD
         zShZ6sPJUWLXwKqLePRX7F4lAO8alk7R8hdYxpNuvLoQd91zbwzOW/1s8eqvy/Fx4Bf/
         pblHdEkzldfd+Isp64zmeq4elDx6Pht3MiVnhmMXS5qHdW8fMmR89tay0+tSWXisH59x
         LNfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=w4xHdz31RwxiLV3EKKydlXk40aZioL7OqymsIw+Nudk=;
        b=qypGHF37qGeLDhQ0LJYOnSEj0FKMT3Pdy3lTUKHbwWHk4AiGA+rj15HkF1+nkTEEBX
         G7NdMLZTQ8KlE90EDvGdKD03hGxFKCdBDMWoHpETvvPQOnLtCtQaxj9kGrqOBgZJJ4qj
         TdXZE7ZK7g5N8gclMjeqPSH3I1S/ZjEQdUZrH/gsW6VkBqPjY+J0cUdMME6jQG7ux1EB
         sP63E0/UY5+UD4W1pSssSlJrZkS3PFT0XryBKHiTWTZMhlgbUFVxlBPjrBIibB5usNvj
         4ikCGnvqzLvKcByh5oguaPAkSAllVcOmACLsgPiIy/WMW9CUhWSDRQzPJ6+mujMWW5pz
         2wuw==
X-Gm-Message-State: AOAM531X9EpEBEko9PXfn2HE/Na7Hno6sLCod8wWsnxckq4raruUCAHG
        Sn2JihKpkEbElEMYtut9SizmEzkr5Vp/yw==
X-Google-Smtp-Source: ABdhPJyzzkTUH2oGAbPdKUIAT70x+YeP9Y7f8zV925YYWcSAMx07IcSPFau20V0POLU7SzI2o+kdxQ==
X-Received: by 2002:a17:90b:90d:: with SMTP id bo13mr3457691pjb.111.1603829531634;
        Tue, 27 Oct 2020 13:12:11 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id w74sm3275451pff.200.2020.10.27.13.12.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2020 13:12:10 -0700 (PDT)
Message-ID: <5f987f1a.1c69fb81.8d9a1.6694@mx.google.com>
Date:   Tue, 27 Oct 2020 13:12:10 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.8.16-634-g5be39e9f29ce
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.8.y
Subject: stable-rc/linux-5.8.y baseline: 190 runs,
 3 regressions (v5.8.16-634-g5be39e9f29ce)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.8.y baseline: 190 runs, 3 regressions (v5.8.16-634-g5be39=
e9f29ce)

Regressions Summary
-------------------

platform                  | arch  | lab          | compiler | defconfig    =
      | regressions
--------------------------+-------+--------------+----------+--------------=
------+------------
bcm2837-rpi-3-b           | arm64 | lab-baylibre | gcc-8    | defconfig    =
      | 1          =

stm32mp157c-dk2           | arm   | lab-baylibre | gcc-8    | multi_v7_defc=
onfig | 1          =

sun8i-h3-bananapi-m2-plus | arm   | lab-baylibre | gcc-8    | multi_v7_defc=
onfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.8.y/kern=
el/v5.8.16-634-g5be39e9f29ce/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.8.y
  Describe: v5.8.16-634-g5be39e9f29ce
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      5be39e9f29ceb931a3c8bfa71a3f18345bb6d3d5 =



Test Regressions
---------------- =



platform                  | arch  | lab          | compiler | defconfig    =
      | regressions
--------------------------+-------+--------------+----------+--------------=
------+------------
bcm2837-rpi-3-b           | arm64 | lab-baylibre | gcc-8    | defconfig    =
      | 1          =


  Details:     https://kernelci.org/test/plan/id/5f9849cfe77c281c5f38103e

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.8.y/v5.8.16-=
634-g5be39e9f29ce/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3=
-b.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.8.y/v5.8.16-=
634-g5be39e9f29ce/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3=
-b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.dmesg.crit: https://kernelci.org/test/case/id/5f9849cfe77c281c=
5f381043
        new failure (last pass: v5.8.16-79-g7b491c4b6b5a)
        2 lines

    2020-10-27 16:22:29.871000+00:00  Connected to bcm2837-rpi-3-b console =
[channel connected] (~$quit to exit)
    2020-10-27 16:22:29.871000+00:00  (user:khilman) is already connected
    2020-10-27 16:22:45.356000+00:00  =00
    2020-10-27 16:22:45.356000+00:00  =

    2020-10-27 16:22:45.371000+00:00  U-Boot 2018.11 (Dec 04 2018 - 10:54:3=
2 -0800)
    2020-10-27 16:22:45.371000+00:00  =

    2020-10-27 16:22:45.371000+00:00  DRAM:  948 MiB
    2020-10-27 16:22:45.403000+00:00  RPI 3 Model B (0xa02082)
    2020-10-27 16:22:45.480000+00:00  MMC:   mmc@7e202000: 0, sdhci@7e30000=
0: 1
    2020-10-27 16:22:45.511000+00:00  Loading Environment from FAT... *** W=
arning - bad CRC, using default environment =

    ... (386 line(s) more)  =

 =



platform                  | arch  | lab          | compiler | defconfig    =
      | regressions
--------------------------+-------+--------------+----------+--------------=
------+------------
stm32mp157c-dk2           | arm   | lab-baylibre | gcc-8    | multi_v7_defc=
onfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5f98507038e975b6f5381021

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.8.y/v5.8.16-=
634-g5be39e9f29ce/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-stm32m=
p157c-dk2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.8.y/v5.8.16-=
634-g5be39e9f29ce/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-stm32m=
p157c-dk2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5f98507038e975b6f5381=
022
        new failure (last pass: v5.8.16-79-g7b491c4b6b5a) =

 =



platform                  | arch  | lab          | compiler | defconfig    =
      | regressions
--------------------------+-------+--------------+----------+--------------=
------+------------
sun8i-h3-bananapi-m2-plus | arm   | lab-baylibre | gcc-8    | multi_v7_defc=
onfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5f98581399fd1150a2381030

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.8.y/v5.8.16-=
634-g5be39e9f29ce/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-sun8i-=
h3-bananapi-m2-plus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.8.y/v5.8.16-=
634-g5be39e9f29ce/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-sun8i-=
h3-bananapi-m2-plus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5f98581399fd1150a2381=
031
        new failure (last pass: v5.8.16-79-g7b491c4b6b5a) =

 =20
