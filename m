Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C7E33B483F
	for <lists+stable@lfdr.de>; Fri, 25 Jun 2021 19:32:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229653AbhFYReW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Jun 2021 13:34:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229531AbhFYReV (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Jun 2021 13:34:21 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4DA2C061574
        for <stable@vger.kernel.org>; Fri, 25 Jun 2021 10:32:00 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id x21-20020a17090aa395b029016e25313bfcso5952972pjp.2
        for <stable@vger.kernel.org>; Fri, 25 Jun 2021 10:32:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=+h4PEkNSEwiCwtOX51/Nsi1dYYIai/SvMjEwPry/YrQ=;
        b=o7uOabWCwWLXY9dkPciJ5XgaCVtWAag6hAAoM1NL08wOp7aOltpVdl64HYfgoQ/1tC
         LD8fHHKzvf05a0DQB9s+A5vCBpiFU1xvCUrqEQ43RKFCV3FDU+rOfnwmp36SZm2Q0/4n
         Cn522uF5dyUw0uwPdReF/ucjUdxeg/7Yu9PrmDu2f7b8sy700jNOGfxhwVkEHKuqoL/F
         04ezO4AYl4z1I7UU/Sgai/qXelRL8KEC8I4MjI1dxoT5YKWEGrKGxDKhD7a1BJ8RbP78
         BdJIMyH5iqMFIryKc2xBR5WmFLV2LFBs8+5b99ojpRo1kQeWOm3prCA+BnhhE81E3Btr
         do9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=+h4PEkNSEwiCwtOX51/Nsi1dYYIai/SvMjEwPry/YrQ=;
        b=uY1y3rv7ZxWexHOv5+bCHwfWNnA9/+dZW2/P66ThazS/KBfP/JN2+wUem3A2is3Udk
         trd/JdE3qz1dQ3mE38w4b2USVkH0K17Dn+D1zwSG44JN9FGFTLAyeHTF7u3fq+JMQ75b
         VVPu0wN5FLNjO6E05njhbAOtN8yGaPSs1TEVaYP8MJv04SO2L9sMCIxyys0Z/bFxFmK/
         zT6ILdQ4sfM/uxTyoPTSfZijq1Smepf6c2dQTFH+8N8fu+HUWjrstgkQUOcbm4PBXwB2
         EE0Y78zF5oLL2vMQ0A/Z4W7g6GrYYxYGMzRmX1zqEw9HMcs8U8TY/R1+LtikP/qLAiJX
         eq2g==
X-Gm-Message-State: AOAM531dGB/dal36bdn2ODT94TN3nez56+UhXVBR8AIb/ujmhBg2azIW
        dGq6ieuVtk2ccABaFWCyDQ0ATLSeqeSBoGx8
X-Google-Smtp-Source: ABdhPJwKkfyBhDufFqfJaEzZH2K9L7kzWRHAhlRcVgrTuuGnt3nfuXfmiibXwIE3U6fHCEFW+UaEAA==
X-Received: by 2002:a17:902:7444:b029:120:2f1a:b967 with SMTP id e4-20020a1709027444b02901202f1ab967mr10164404plt.45.1624642320194;
        Fri, 25 Jun 2021 10:32:00 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id g38sm5885088pgg.63.2021.06.25.10.31.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Jun 2021 10:31:59 -0700 (PDT)
Message-ID: <60d6130f.1c69fb81.0e66.f4a8@mx.google.com>
Date:   Fri, 25 Jun 2021 10:31:59 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.12.13-12-gf45ef4c1b3a2
X-Kernelci-Branch: queue/5.12
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.12 baseline: 158 runs,
 4 regressions (v5.12.13-12-gf45ef4c1b3a2)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.12 baseline: 158 runs, 4 regressions (v5.12.13-12-gf45ef4=
c1b3a2)

Regressions Summary
-------------------

platform          | arch  | lab           | compiler | defconfig          |=
 regressions
------------------+-------+---------------+----------+--------------------+=
------------
meson-gxbb-p200   | arm64 | lab-baylibre  | gcc-8    | defconfig          |=
 1          =

rk3288-veyron-jaq | arm   | lab-collabora | gcc-8    | multi_v7_defconfig |=
 3          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.12/ker=
nel/v5.12.13-12-gf45ef4c1b3a2/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.12
  Describe: v5.12.13-12-gf45ef4c1b3a2
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      f45ef4c1b3a223c430dac1f14af7d9445fac86fc =



Test Regressions
---------------- =



platform          | arch  | lab           | compiler | defconfig          |=
 regressions
------------------+-------+---------------+----------+--------------------+=
------------
meson-gxbb-p200   | arm64 | lab-baylibre  | gcc-8    | defconfig          |=
 1          =


  Details:     https://kernelci.org/test/plan/id/60d5e36bd273d84eb6413266

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.13-=
12-gf45ef4c1b3a2/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-p20=
0.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.13-=
12-gf45ef4c1b3a2/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-p20=
0.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60d5e36bd273d84eb6413=
267
        new failure (last pass: v5.12.13-10-g22f406ce15cb) =

 =



platform          | arch  | lab           | compiler | defconfig          |=
 regressions
------------------+-------+---------------+----------+--------------------+=
------------
rk3288-veyron-jaq | arm   | lab-collabora | gcc-8    | multi_v7_defconfig |=
 3          =


  Details:     https://kernelci.org/test/plan/id/60d5f7dad2dee6090441327f

  Results:     66 PASS, 3 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.13-=
12-gf45ef4c1b3a2/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288=
-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.13-=
12-gf45ef4c1b3a2/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288=
-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/60d5f7dad2dee6090441329c
        failing since 10 days (last pass: v5.12.10-48-g5e97c6651365, first =
fail: v5.12.10-173-gfd0b35fa0b0c)

    2021-06-25T15:35:46.929607  /lava-4095077/1/../bin/lava-test-case
    2021-06-25T15:35:46.935105  <8>[   12.733978] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/60d5f7dad2dee6090441329d
        failing since 10 days (last pass: v5.12.10-48-g5e97c6651365, first =
fail: v5.12.10-173-gfd0b35fa0b0c)

    2021-06-25T15:35:47.949565  /lava-4095077/1/../bin/lava-test-case
    2021-06-25T15:35:47.967546  <8>[   13.753919] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>
    2021-06-25T15:35:47.967826  /lava-4095077/1/../bin/lava-test-case   =


  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/60d5f7dad2dee609044132b5
        failing since 10 days (last pass: v5.12.10-48-g5e97c6651365, first =
fail: v5.12.10-173-gfd0b35fa0b0c)

    2021-06-25T15:35:49.397811  /lava-4095077/1/../bin/lava-test-case<8>[  =
 15.185149] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Drockchip-iodomain-grf-prob=
ed RESULT=3Dfail>
    2021-06-25T15:35:49.398248  =

    2021-06-25T15:35:49.398476  /lava-4095077/1/../bin/lava-test-case   =

 =20
