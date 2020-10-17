Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35D5F291253
	for <lists+stable@lfdr.de>; Sat, 17 Oct 2020 16:20:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2411556AbgJQOUm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 17 Oct 2020 10:20:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392579AbgJQOUl (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 17 Oct 2020 10:20:41 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E3ABC061755
        for <stable@vger.kernel.org>; Sat, 17 Oct 2020 07:20:40 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id a200so3196624pfa.10
        for <stable@vger.kernel.org>; Sat, 17 Oct 2020 07:20:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=f0kNer5nUiyFXU4UiQWu4RZs10x6adYE6flzaUyNRUA=;
        b=LeN9NToXfo9vjPFijgghnKaVVf9PoFUSuLfsQjqJsP2JYHG6mwRSpIEVJ2t0/OwBEH
         CWe+RePj6g/ZFqZnOjwvFxAP5ag7H587yWvJ5sw9qLZ7Qndq5Yz5mhPuIS2ADHvVTxXL
         kMSASDx4CMbKgerTFEuwYa4UwR00MEKxBjo+vk+QslGtam//gTaCtTVegf3RjuoKdD31
         yA8PBon/x6VuZ0rudfXeIV+QEgJ5U1rOFQ8F6tzAbX9+1nTkEWDKKHQ00ljgDJw5plm+
         NDCubBvxyzTKecZsEa/EUJkWe/VCux6y2GGncLsekXvqEbNhEVPoapUg9Zcw3tW5EJif
         qa+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=f0kNer5nUiyFXU4UiQWu4RZs10x6adYE6flzaUyNRUA=;
        b=uEnZ/WjNI2SgdYCwbJhTqHAaUhNTDrmMO8P6swI06Cf+tTlEMhqd5pqRN/Iwxw3Mai
         N0rUy6+ETOMWSJuxByOAq9AVfacy0dyUU3FFye9QMe5a87zPgvlo/AhWafLuv88M5g2+
         q5mcjsqw3uy6yADRD81VkNzq4H5Wn1CE2CBxmpLcfod5uKZo5RuBGLa4vL0owHU4Pu/h
         pIBLgIxC7ynbplzdqFT79eKrcUCk+AndTS0Z6tO6K2pWDKlcjMVLjxuod9Y/ZC6xidoG
         5w7+jOaxLIhPCL0U7Xl0TRg3FkdBubWzPGrZulXmVijXCF9WfQr0cUBMeF7D/BHlFUU9
         LFdw==
X-Gm-Message-State: AOAM533r5o2I6XOxAC/ZGyByxbh7Z2YA/0aJqghUOCEefx+3YTfKCD/4
        lP3ii1AnrrrUZ0L8pWbJLtkyKZvgfM53oQ==
X-Google-Smtp-Source: ABdhPJzmpabipEE8T+IdYAeORenNAyV5vbZWvG5C2QELLx/8LIY4Hf1Dnf7h0j223Sn8yXGbPl7wWA==
X-Received: by 2002:aa7:9e4a:0:b029:152:54d1:bffa with SMTP id z10-20020aa79e4a0000b029015254d1bffamr8768553pfq.6.1602944439468;
        Sat, 17 Oct 2020 07:20:39 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 190sm6177054pfc.151.2020.10.17.07.20.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 17 Oct 2020 07:20:38 -0700 (PDT)
Message-ID: <5f8afdb6.1c69fb81.b67cd.d1c1@mx.google.com>
Date:   Sat, 17 Oct 2020 07:20:38 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.8.16-25-g2ffb90131f29
X-Kernelci-Branch: queue/5.8
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.8 baseline: 203 runs,
 1 regressions (v5.8.16-25-g2ffb90131f29)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.8 baseline: 203 runs, 1 regressions (v5.8.16-25-g2ffb9013=
1f29)

Regressions Summary
-------------------

platform        | arch  | lab          | compiler | defconfig | results
----------------+-------+--------------+----------+-----------+--------
bcm2837-rpi-3-b | arm64 | lab-baylibre | gcc-8    | defconfig | 3/4    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.8/kern=
el/v5.8.16-25-g2ffb90131f29/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.8
  Describe: v5.8.16-25-g2ffb90131f29
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      2ffb90131f29f9fcec90e942620ef77bf792c849 =



Test Regressions
---------------- =



platform        | arch  | lab          | compiler | defconfig | results
----------------+-------+--------------+----------+-----------+--------
bcm2837-rpi-3-b | arm64 | lab-baylibre | gcc-8    | defconfig | 3/4    =


  Details:     https://kernelci.org/test/plan/id/5f8ac29678a6a8636f4ff3e4

  Results:     3 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.8/v5.8.16-25=
-g2ffb90131f29/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.8/v5.8.16-25=
-g2ffb90131f29/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-3-g27eeeac7da2d/arm64/baseline/rootfs.cpio.gz =


  * baseline.dmesg.crit: https://kernelci.org/test/case/id/5f8ac29678a6a863=
6f4ff3e8
      new failure (last pass: v5.8.15-14-g28ec5b4f313f)
      3 lines

    2020-10-17 10:05:41.659000  Connected to bcm2837-rpi-3-b console [chann=
el connected] (~$quit to exit)
    2020-10-17 10:05:41.660000  (user:khilman) is already connected
    2020-10-17 10:05:56.920000  =00
    2020-10-17 10:05:56.921000  =

    2020-10-17 10:05:56.921000  U-Boot 2018.11 (Dec 04 2018 - 10:54:32 -080=
0)
    2020-10-17 10:05:56.921000  =

    2020-10-17 10:05:56.921000  DRAM:  948 MiB
    2020-10-17 10:05:56.936000  RPI 3 Model B (0xa02082)
    2020-10-17 10:05:57.024000  MMC:   mmc@7e202000: 0, sdhci@7e300000: 1
    2020-10-17 10:05:57.057000  Loading Environment from FAT... *** Warning=
 - bad CRC, using default environment
    ... (392 line(s) more)
      =20
