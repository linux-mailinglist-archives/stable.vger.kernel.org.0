Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FDA231EDEE
	for <lists+stable@lfdr.de>; Thu, 18 Feb 2021 19:05:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230174AbhBRSD7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Feb 2021 13:03:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232738AbhBRQC5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Feb 2021 11:02:57 -0500
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B4B2C061756
        for <stable@vger.kernel.org>; Thu, 18 Feb 2021 08:01:29 -0800 (PST)
Received: by mail-pf1-x429.google.com with SMTP id t29so1561397pfg.11
        for <stable@vger.kernel.org>; Thu, 18 Feb 2021 08:01:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=tffnqRKjlcgId0db3XTobjoFuanV5tyot2uWn42FkRg=;
        b=MEuAbMIvyPUxFzo3TU0wzaq2TsIm87M5XRkxPelK3mCcLbSOOc7UUxS/UjvHmFOFrB
         Zp9uqkh7fIv2pbTMuzzRc1V6OULyqxhUjnT/hE7Lx0GJk5mAe+NjZO4KU93rKnhpgQUR
         7XI+ShuHQjp/LH5HOGAIWrhcsX7T14RMC5VoSrYQctkfSKVmjwcrPqP314KptJj1yBiT
         wdaoynsxmgRRz0zRsS2qpV3li3aT3NOgHaBAdEyHftHxlrQy3bCf/F2rXJrPXYmIYjn4
         jn0FGcEDyGs36HO3YnPS7tAcTgNSMfosmkwwaj3vTrHRq9nJ7/nraks22JaIgVm/0nK8
         s/+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=tffnqRKjlcgId0db3XTobjoFuanV5tyot2uWn42FkRg=;
        b=l5kvpTDssl4y4e2EU4RH8XiY9BUMQOjaKaFF4Wg8NmDpZbrAtT3RHcQ4ullchaVsd/
         V2KkFVmm9YJwSiOePTnXDEOVZNjn9l6gFSZquJCj5ocuXyhQXgVNE0eCvGFUj3F4mMZj
         +1buYkqS/tsWt/sX4FkshN3trahKllK+Br70tQdLT88gEuCHUNLKLmYgs3pf5Tklz4f3
         yTGUqUIRk7ao8Rr4KpOBmtssVVATiT6/Z/A9m3RYyzyOUgw5ook4NqM2b1z3tr8CJKCa
         EvbXWIaMBoUvaCFD57YnlE0ux+BvHL16kMF2knSYKZR7Vrx3z2xj3qpFNW86mpaPjkmQ
         wt0w==
X-Gm-Message-State: AOAM531W8xuWwmtSt42k8fYG3MLsfWIVbRzWES6/xn8Ig6zX+jnkW2o6
        DSCJB60YfBbqvJiXKyWmC0p8oD9671+Gxw==
X-Google-Smtp-Source: ABdhPJx+Ol/ocqQhoQR0d1iVcRkRCe9LuPyzjubVW6t+u6wooeOcdBdGd0sfYnJCbB0VnApE731eeA==
X-Received: by 2002:aa7:9987:0:b029:1d9:f115:6f3b with SMTP id k7-20020aa799870000b02901d9f1156f3bmr5232087pfh.50.1613664087739;
        Thu, 18 Feb 2021 08:01:27 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id h70sm6399303pfe.70.2021.02.18.08.01.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Feb 2021 08:01:27 -0800 (PST)
Message-ID: <602e8f57.1c69fb81.85d9.df9c@mx.google.com>
Date:   Thu, 18 Feb 2021 08:01:27 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.176-37-g14f9358b57b8
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.19
Subject: stable-rc/queue/4.19 baseline: 93 runs,
 2 regressions (v4.19.176-37-g14f9358b57b8)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 93 runs, 2 regressions (v4.19.176-37-g14f935=
8b57b8)

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
nel/v4.19.176-37-g14f9358b57b8/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.176-37-g14f9358b57b8
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      14f9358b57b80431a7d8a2ceea807d6609589d94 =



Test Regressions
---------------- =



platform        | arch  | lab           | compiler | defconfig           | =
regressions
----------------+-------+---------------+----------+---------------------+-=
-----------
bcm2837-rpi-3-b | arm64 | lab-baylibre  | gcc-8    | defconfig           | =
1          =


  Details:     https://kernelci.org/test/plan/id/602e5d0162b5e814adaddcf5

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.176=
-37-g14f9358b57b8/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3=
-b.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.176=
-37-g14f9358b57b8/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3=
-b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.dmesg.crit: https://kernelci.org/test/case/id/602e5d0162b5e814=
adaddcf8
        failing since 0 day (last pass: v4.19.176-37-g99b2feb86d78c, first =
fail: v4.19.176-37-g10e94a933ee7)
        1 lines

    2021-02-18 12:24:52.018000+00:00  Connected to bcm2837-rpi-3-b console =
[channel connected] (~$quit to exit)
    2021-02-18 12:24:52.018000+00:00  (user:khilman) is already connected
    2021-02-18 12:25:07.760000+00:00  =00
    2021-02-18 12:25:07.760000+00:00  =

    2021-02-18 12:25:07.760000+00:00  U-Boot 2018.11 (Dec 04 2018 - 10:54:3=
2 -0800)
    2021-02-18 12:25:07.760000+00:00  =

    2021-02-18 12:25:07.760000+00:00  DRAM:  948 MiB
    2021-02-18 12:25:07.775000+00:00  RPI 3 Model B (0xa02082)
    2021-02-18 12:25:07.862000+00:00  MMC:   mmc@7e202000: 0, sdhci@7e30000=
0: 1
    2021-02-18 12:25:07.894000+00:00  Loading Environment from FAT... *** W=
arning - bad CRC, using default environment =

    ... (367 line(s) more)  =

 =



platform        | arch  | lab           | compiler | defconfig           | =
regressions
----------------+-------+---------------+----------+---------------------+-=
-----------
panda           | arm   | lab-collabora | gcc-8    | omap2plus_defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/602e5b61f26b9a2d1daddcc3

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.176=
-37-g14f9358b57b8/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.176=
-37-g14f9358b57b8/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/602e5b61f26b9a2=
d1daddcc8
        failing since 1 day (last pass: v4.19.176-37-ga630db879c87e, first =
fail: v4.19.176-37-g99b2feb86d78c)
        2 lines

    2021-02-18 12:19:40.615000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xffffed34 [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
