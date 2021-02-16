Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 410BF31D188
	for <lists+stable@lfdr.de>; Tue, 16 Feb 2021 21:26:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230206AbhBPUYs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Feb 2021 15:24:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230131AbhBPUYn (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Feb 2021 15:24:43 -0500
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15433C06174A
        for <stable@vger.kernel.org>; Tue, 16 Feb 2021 12:24:03 -0800 (PST)
Received: by mail-pg1-x52f.google.com with SMTP id p21so1315036pgl.12
        for <stable@vger.kernel.org>; Tue, 16 Feb 2021 12:24:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=uEdYIC/lgPOa2j8Ruus1UcoDMgmvDTPRo1InF8w8dB0=;
        b=AEUDIx3zf7WH5uv0NJ0G6/0WLMkyylWSwVCOKyv1M+T4y7TRtMVTxdZ7/eeYwM9eNo
         4OFwDv+F8T8K8E7AaxRRFXP39kWhLWmutImgtQA7O3ZaICymyW6MrPAS6QC+eAUNWk19
         hItWQLTk6IJQ8iEvdu7tSjv5wfFN6U11sa9O0VRTWILDGIK9RZF2PYNTOPoiaYSBqhMJ
         TXY0YleJkv88nkyT1kqUc9bYekQonDZ9WBgKDV6GQTcr4VyFRPWB0s/vyhjPFCwWRuFN
         v5UUeIeTr8eX3nsEwVBevk2BQq/lkvkZ2MNz+dvT/DrwL/ZvJPfZFBJNYoUYTytdIleh
         kokQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=uEdYIC/lgPOa2j8Ruus1UcoDMgmvDTPRo1InF8w8dB0=;
        b=eKfjtD4hn2O6BgGbWMgY5LFfZ+AgDdGbFXi7Q57gB0xu7uilpmjMEM8684taypJ7Kn
         +/dv/7YCmRy99ALGP++sb+b67sWgYh02QeNFXekDPZ3SGWWb2jpM57g5k57i0x5DZaMh
         qjvAc5Hf0f86Slxczybb3dACDO/DXHUdYFeWAYZoULR9HnIbOWgCr7w/Ia7cNo1zxzY7
         o523UmYISAUBJi+9r79Mwld4uNaIgOoaPn/qphOQNAW7nUoMs38Yrp+JNqjMAC4dOG1m
         7DmpOCpgDR1zAt7/plRLwhOndMeXpYo19upSG204KH6NvXAv87Bs4edNzgffXyj3Bce3
         ivOQ==
X-Gm-Message-State: AOAM533FA7rNzUb7DldKa71T71ByML+mmBtw/CEr1n8DBeQw8CsBfPFw
        UWDKCR+ebVCJk3c6ooiPGGxdUXv8Gvm50g==
X-Google-Smtp-Source: ABdhPJwhIiHcwbrfOz66AHvxFYRaa5yL5CraLkZTkV0f7PCbLOoCsMYp5wiBb6T7WfcDPMnwg3J8TA==
X-Received: by 2002:a63:f050:: with SMTP id s16mr20618889pgj.433.1613507042308;
        Tue, 16 Feb 2021 12:24:02 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id w13sm209326pjg.0.2021.02.16.12.24.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Feb 2021 12:24:01 -0800 (PST)
Message-ID: <602c29e1.1c69fb81.39ce0.0b6c@mx.google.com>
Date:   Tue, 16 Feb 2021 12:24:01 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.4.98-61-gc65ed94f3071
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.4.y
Subject: stable-rc/linux-5.4.y baseline: 103 runs,
 2 regressions (v5.4.98-61-gc65ed94f3071)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.4.y baseline: 103 runs, 2 regressions (v5.4.98-61-gc65ed9=
4f3071)

Regressions Summary
-------------------

platform             | arch  | lab          | compiler | defconfig | regres=
sions
---------------------+-------+--------------+----------+-----------+-------=
-----
bcm2837-rpi-3-b      | arm64 | lab-baylibre | gcc-8    | defconfig | 1     =
     =

hifive-unleashed-a00 | riscv | lab-baylibre | gcc-8    | defconfig | 1     =
     =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.4.y/kern=
el/v5.4.98-61-gc65ed94f3071/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.4.y
  Describe: v5.4.98-61-gc65ed94f3071
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      c65ed94f3071e59865975e91b52ec522a50f7ade =



Test Regressions
---------------- =



platform             | arch  | lab          | compiler | defconfig | regres=
sions
---------------------+-------+--------------+----------+-----------+-------=
-----
bcm2837-rpi-3-b      | arm64 | lab-baylibre | gcc-8    | defconfig | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/602bf5ebd65c26c29eaddced

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.98-=
61-gc65ed94f3071/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-=
b.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.98-=
61-gc65ed94f3071/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-=
b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.dmesg.crit: https://kernelci.org/test/case/id/602bf5ebd65c26c2=
9eaddcf0
        new failure (last pass: v5.4.98-7-g642aa3284e09)
        1 lines

    2021-02-16 16:40:11.817000+00:00  Connected to bcm2837-rpi-3-b console =
[channel connected] (~$quit to exit)
    2021-02-16 16:40:11.818000+00:00  (user:khilman) is already connected
    2021-02-16 16:40:27.440000+00:00  =00
    2021-02-16 16:40:27.440000+00:00  =

    2021-02-16 16:40:27.440000+00:00  U-Boot 2018.11 (Dec 04 2018 - 10:54:3=
2 -0800)
    2021-02-16 16:40:27.441000+00:00  =

    2021-02-16 16:40:27.441000+00:00  DRAM:  948 MiB
    2021-02-16 16:40:27.456000+00:00  RPI 3 Model B (0xa02082)
    2021-02-16 16:40:27.543000+00:00  MMC:   mmc@7e202000: 0, sdhci@7e30000=
0: 1
    2021-02-16 16:40:27.575000+00:00  Loading Environment from FAT... *** W=
arning - bad CRC, using default environment =

    ... (385 line(s) more)  =

 =



platform             | arch  | lab          | compiler | defconfig | regres=
sions
---------------------+-------+--------------+----------+-----------+-------=
-----
hifive-unleashed-a00 | riscv | lab-baylibre | gcc-8    | defconfig | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/602bf17add67f67ae2addcc0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (riscv64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.98-=
61-gc65ed94f3071/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleash=
ed-a00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.98-=
61-gc65ed94f3071/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleash=
ed-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/riscv/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/602bf17add67f67ae2add=
cc1
        failing since 88 days (last pass: v5.4.77-152-ga3746663c3479, first=
 fail: v5.4.78) =

 =20
