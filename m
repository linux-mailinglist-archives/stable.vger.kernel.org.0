Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFA4B405B00
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 18:37:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229816AbhIIQim (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 12:38:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232192AbhIIQim (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Sep 2021 12:38:42 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83380C061574
        for <stable@vger.kernel.org>; Thu,  9 Sep 2021 09:37:32 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id s11so2327322pgr.11
        for <stable@vger.kernel.org>; Thu, 09 Sep 2021 09:37:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=9ePNxHzLDo3MEepAG8LUyUyfyzHZjU7Y32FrkqBVD78=;
        b=qK32RkAGomyuOOC3Io2SRcNX2Jl29R4asXmhZ1MjeyrZ/jR083ijbGzbyI/s2aL6ph
         8bagNMtQwRa9esupRyBbcZTO/fMT/a+k0bWr6hLRhlvt0bJckSqDoH4Q/SClv/AZ9ozc
         u4cNyk+vukdMLXiShJlzXrAMIyGS9FETmNTJIqtxNbtHih/aKDom3xCoQti+kvP07JBy
         3wLy6YFaWlX8+hpiTqscF+aAGA+zMpS0kQYVTX2ES9iFRW6y9GZhWLlDKaqz6RDb+4kF
         Z0CeAuw6puxHU2+oH+/ckrQU4O3CrxKBAS7wD215+QTI9ouJ9mjKHmz9dxMTKN4Zkrur
         rEOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=9ePNxHzLDo3MEepAG8LUyUyfyzHZjU7Y32FrkqBVD78=;
        b=SrOaQrBJWB+rzh6mfeVgcxdjXZocEFGaD0gJ8GPRFqxyFsVJnvCIHnbGSvqWFl6xYi
         cRmtFAQYbCpjy7rE6X+wwePMJs7r1dhCAYLV9JindnGI3fAwRLlJ5KCRmTkrq7fNN625
         UMCRFZ3Ytjt/WkAKcHMd8iNFLq7rLGbxFcU2XvJsm+o9zF645tuVsLKaAe0nHW7nR8/X
         /1ttoYfBc3/uWcqeL2Bpls2NnfQPHHvjPps+78Wp5j3CH81SO3T49qk3lZ7DV/AIOaLI
         O71jAEmodMkAbvzr0f2YEo4y+cf8scMhGaonV3bA0UOzQVjf925dsdvSrLd4eTIZnJPv
         NzdQ==
X-Gm-Message-State: AOAM532ZPvjoXN3TXfHo7mIXlUn0QmZS1mgGEPDHk7rFi5bKDjBtOx1x
        Fo4ldgICVXrEBpBcbHhK2I7INZ8f02m+yvBK
X-Google-Smtp-Source: ABdhPJy1PqCBK7iGjF1i+WzdaOHw38bDUAOvKRC0GM8HlpsJiv2t9wwrl7lVFOtZL2DuW5FpFavYUw==
X-Received: by 2002:a63:f62:: with SMTP id 34mr3386066pgp.159.1631205451934;
        Thu, 09 Sep 2021 09:37:31 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id s3sm2820249pfd.188.2021.09.09.09.37.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Sep 2021 09:37:31 -0700 (PDT)
Message-ID: <613a384b.1c69fb81.9b11.705e@mx.google.com>
Date:   Thu, 09 Sep 2021 09:37:31 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.14.246-24-g6eb592b0d912
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.14
Subject: stable-rc/queue/4.14 baseline: 173 runs,
 4 regressions (v4.14.246-24-g6eb592b0d912)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 173 runs, 4 regressions (v4.14.246-24-g6eb59=
2b0d912)

Regressions Summary
-------------------

platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
qemu_i386-uefi    | i386 | lab-broonie   | gcc-8    | i386_defconfig     | =
1          =

rk3288-veyron-jaq | arm  | lab-collabora | gcc-8    | multi_v7_defconfig | =
3          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.246-24-g6eb592b0d912/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.246-24-g6eb592b0d912
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      6eb592b0d912c3a67980f5743f23403ba4554031 =



Test Regressions
---------------- =



platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
qemu_i386-uefi    | i386 | lab-broonie   | gcc-8    | i386_defconfig     | =
1          =


  Details:     https://kernelci.org/test/plan/id/613a1804598b3f2a8dd596a2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.246=
-24-g6eb592b0d912/i386/i386_defconfig/gcc-8/lab-broonie/baseline-qemu_i386-=
uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.246=
-24-g6eb592b0d912/i386/i386_defconfig/gcc-8/lab-broonie/baseline-qemu_i386-=
uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/613a1804598b3f2a8dd59=
6a3
        failing since 0 day (last pass: v4.14.246-24-g2dd51cbf7f11, first f=
ail: v4.14.246-24-gfe366f20894d) =

 =



platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
rk3288-veyron-jaq | arm  | lab-collabora | gcc-8    | multi_v7_defconfig | =
3          =


  Details:     https://kernelci.org/test/plan/id/613a125211efc0b9f5d59680

  Results:     63 PASS, 6 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.246=
-24-g6eb592b0d912/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk328=
8-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.246=
-24-g6eb592b0d912/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk328=
8-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/613a125211efc0b9f5d59694
        failing since 86 days (last pass: v4.14.236-20-gdb14655bb4bf, first=
 fail: v4.14.236-49-gfd4c319f2583)

    2021-09-09T13:55:20.382934  /lava-4482677/1/../bin/lava-test-case
    2021-09-09T13:55:20.400190  [   16.399421] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>
    2021-09-09T13:55:20.400474  /lava-4482677/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/613a125211efc0b9f5d596ad
        failing since 86 days (last pass: v4.14.236-20-gdb14655bb4bf, first=
 fail: v4.14.236-49-gfd4c319f2583)

    2021-09-09T13:55:17.950990  /lava-4482677/1/../bin/lava-test-case
    2021-09-09T13:55:17.968931  [   13.967892] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/613a125211efc0b9f5d596ae
        failing since 86 days (last pass: v4.14.236-20-gdb14655bb4bf, first=
 fail: v4.14.236-49-gfd4c319f2583)

    2021-09-09T13:55:16.931791  /lava-4482677/1/../bin/lava-test-case
    2021-09-09T13:55:16.937945  [   12.949071] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =

 =20
