Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8A6128330F
	for <lists+stable@lfdr.de>; Mon,  5 Oct 2020 11:20:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725910AbgJEJU3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Oct 2020 05:20:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725901AbgJEJU3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Oct 2020 05:20:29 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 905D3C0613CE
        for <stable@vger.kernel.org>; Mon,  5 Oct 2020 02:20:29 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id gm14so5675804pjb.2
        for <stable@vger.kernel.org>; Mon, 05 Oct 2020 02:20:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=qQDAzojOgj0HkLm3BL/VHKH0he6EjwP6gKsnwARJTPw=;
        b=QtrXCF2Bgoh/A8iRP1Hrc5RtNg0RaWAtQQwcr/ZV2Saro6P4uOSmMPFbv/XlQOBUyW
         4Uzv+lTDrJ3K6R3/cXRegrDMPXnW8Sc4BDpHsyzD4ayN60JOhTu3DkbP4amqgNdkpmFZ
         9v+jbD1IVvG5o+XAWwOx1D/SBZDvSbkR0pLf5Qtuzcyj8TkwaphoU7iddBCBQbW5vrLF
         8eM1TnJDEzaMK99BMbokD3HkfmKI/MNWn4Rh06MSr8sMcCR5MSCpyYtHSycXz32BoeJj
         f2s6KYkQ+QsA/8bCywhh7Imm1Ryep4nHFCT0zh/kYVMGt7ZBoSxxjCPf+FStlVgCHUWM
         n6UQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=qQDAzojOgj0HkLm3BL/VHKH0he6EjwP6gKsnwARJTPw=;
        b=Q9oW5L4/TY30hjS1/aVLM1VB40rerE/HqVHmQpYFCwxC8MR5Bd/ALVoO7e5PrFXeZY
         cGb8qoECRFZaHFxKd/lY5YmqG9LrF30ier+D4yP3lYbUkqG1hkIWVYeUz/7AIm39RkXt
         qOrtHlpr2KN8vd/QOgCdOF7NUiYv9mL6d1SD6wER0jfCQWNuluA4l44OUcOlk6Pmfxbj
         YDhpSLKLL8WHfUXCGoLb8ixmGxZChSgjhYR3sUm2AdPqvYC3JifyhdgLHPSPtpWlRkqB
         adsE+mtZzyRyYx/pxRn6YnW3uslObDQn/td3wKyECFf0C+4U5hn0rqIK6MV4Qg5RL8lp
         Wmiw==
X-Gm-Message-State: AOAM5311p0zqpksHZpBzh/ikDCRsCVd51Au9CdCiB5cw1U/BgaqsgBTA
        L7S0AmJizEdmZ9vBeF4ZPXkZbOEnGClbvA==
X-Google-Smtp-Source: ABdhPJxkS88rHkY1UJ0oQseXNo+S3/uenc0piocYuHBc/iuBRFv2BEfRDxiFZJUdWCzgCiFLvyuvng==
X-Received: by 2002:a17:90b:348b:: with SMTP id kd11mr16376231pjb.66.1601889628637;
        Mon, 05 Oct 2020 02:20:28 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id z73sm7841425pfc.75.2020.10.05.02.20.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Oct 2020 02:20:27 -0700 (PDT)
Message-ID: <5f7ae55b.1c69fb81.d691e.f2ad@mx.google.com>
Date:   Mon, 05 Oct 2020 02:20:27 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.19.149-30-ga5904fa46fda
X-Kernelci-Branch: queue/4.19
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.19 baseline: 91 runs,
 2 regressions (v4.19.149-30-ga5904fa46fda)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 91 runs, 2 regressions (v4.19.149-30-ga5904f=
a46fda)

Regressions Summary
-------------------

platform        | arch  | lab           | compiler | defconfig           | =
results
----------------+-------+---------------+----------+---------------------+-=
-------
bcm2837-rpi-3-b | arm64 | lab-baylibre  | gcc-8    | defconfig           | =
3/4    =

panda           | arm   | lab-collabora | gcc-8    | omap2plus_defconfig | =
4/5    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.149-30-ga5904fa46fda/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.149-30-ga5904fa46fda
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      a5904fa46fda676eff493362a7364baed5fc02ae =



Test Regressions
---------------- =



platform        | arch  | lab           | compiler | defconfig           | =
results
----------------+-------+---------------+----------+---------------------+-=
-------
bcm2837-rpi-3-b | arm64 | lab-baylibre  | gcc-8    | defconfig           | =
3/4    =


  Details:     https://kernelci.org/test/plan/id/5f7aa99f523763205f4ff479

  Results:     3 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.149=
-30-ga5904fa46fda/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3=
-b.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.149=
-30-ga5904fa46fda/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3=
-b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-3-g27eeeac7da2d/arm64/baseline/rootfs.cpio.gz =


  * baseline.dmesg.crit: https://kernelci.org/test/case/id/5f7aa99f52376320=
5f4ff47d
      failing since 1 day (last pass: v4.19.149-4-gb110045ffdd5, first fail=
: v4.19.149-4-g55b73b3448d7)
      1 lines

    2020-10-05 05:03:44.869000  Connected to bcm2837-rpi-3-b console [chann=
el connected] (~$quit to exit)
    2020-10-05 05:03:44.869000  (user:khilman) is already connected
    2020-10-05 05:04:01.442000  =00
    2020-10-05 05:04:01.442000  =

    2020-10-05 05:04:01.442000  U-Boot 2018.11 (Dec 04 2018 - 10:54:32 -080=
0)
    2020-10-05 05:04:01.442000  =

    2020-10-05 05:04:01.442000  DRAM:  948 MiB
    2020-10-05 05:04:01.457000  RPI 3 Model B (0xa02082)
    2020-10-05 05:04:01.544000  MMC:   mmc@7e202000: 0, sdhci@7e300000: 1
    2020-10-05 05:04:01.577000  Loading Environment from FAT... *** Warning=
 - bad CRC, using default environment
    ... (362 line(s) more)
      =



platform        | arch  | lab           | compiler | defconfig           | =
results
----------------+-------+---------------+----------+---------------------+-=
-------
panda           | arm   | lab-collabora | gcc-8    | omap2plus_defconfig | =
4/5    =


  Details:     https://kernelci.org/test/plan/id/5f7aad1ead6525f0464ff3e9

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.149=
-30-ga5904fa46fda/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.149=
-30-ga5904fa46fda/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-3-g27eeeac7da2d/armel/baseline/rootfs.cpio.gz =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5f7aad1ead6525f=
0464ff3f0
      failing since 1 day (last pass: v4.19.149-4-g55b73b3448d7, first fail=
: v4.19.149-5-gc7c6637a3e67)
      2 lines  =20
