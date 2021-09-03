Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CCB64001B0
	for <lists+stable@lfdr.de>; Fri,  3 Sep 2021 17:06:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235480AbhICPH0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Sep 2021 11:07:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229997AbhICPHZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Sep 2021 11:07:25 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C12FEC061575
        for <stable@vger.kernel.org>; Fri,  3 Sep 2021 08:06:25 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id u6so4533030pfi.0
        for <stable@vger.kernel.org>; Fri, 03 Sep 2021 08:06:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=VYrCcEFunlVIR1MvsmNEQ/3JKDb2gobky/mAl/dINHc=;
        b=hKbG6A9aOtZucFf1MrdftrV1vz4gPasHCd3v7Zte853YsPu0VVBQRUUCkMzUhooXm/
         m3sq7S0wPrM8VhpaA5DVMftF9u2w5xDlcYjMc+82ezOcDK+XWEGT1A2qdURVi1OtUNo8
         Uqe8IR1xT/XKh3ml+9ssoDCs9h8EmV0m114Z1o/+aZ0CrkwxINO46cM3MKCLSRMHw39v
         CR1EjKelAypzlJH9t2DRXsRp84Ke5r/mzMYAOc9ZGctyeOZL6ELrNjgSqLEq/rxI/sPc
         xITQgWVqkgcb0Z4w9g4fNgmIsTO/8XMVxtLC6EvZvBee3CVY/VaMwlwQQf7q9UUiVQp+
         jLrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=VYrCcEFunlVIR1MvsmNEQ/3JKDb2gobky/mAl/dINHc=;
        b=KtOy5zhsTr8u0qiXGuPTBobY2wBi599grpKnI3k1Duuaa79ZVcady8jNBtnIDR76H3
         lrCPxuhHzBu1FhWQUwchGMTP+872fNDQNGYD+vTkPVp7IffPLlB/E+33uGp2WxN8c43k
         yl0xv1qvVFCalbI9l/wyafVJbPF+qDgycCqMBb27s992d6mR3VDH9OMsn3IonMY2gtGs
         0065Fxp9x5ZbFcPhbYPv9loxis7ANwXK76j/Tj3joldqct4mLZvPvnXxzFQ2EvCVySeV
         A2gX3CorxEH1Gxx+kLOzP2KLWkGEdOnsJh4Z8JaWnKLKIoA4Fep7P/YG0Va0EodR9CbE
         KgdQ==
X-Gm-Message-State: AOAM531Ar2wDJ/diHkc/U7xu18Qdsy//BIBWNnIAncbqGPqdAI8OfIp5
        Xfxr6RWOv3uX6pokazr9/YqVQSHron4EsA+e
X-Google-Smtp-Source: ABdhPJyKOhGQjq2/bPNw+i1943MzeUmuGtXeoDfT/Y9VaQK1WA0cH32A0xRw52wU56eQ0tcTsavJWg==
X-Received: by 2002:a65:4008:: with SMTP id f8mr3934402pgp.310.1630681585044;
        Fri, 03 Sep 2021 08:06:25 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 73sm5922661pfu.92.2021.09.03.08.06.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Sep 2021 08:06:24 -0700 (PDT)
Message-ID: <613239f0.1c69fb81.994f6.f2d6@mx.google.com>
Date:   Fri, 03 Sep 2021 08:06:24 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.10.62
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-5.10.y
Subject: stable/linux-5.10.y baseline: 180 runs, 4 regressions (v5.10.62)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.10.y baseline: 180 runs, 4 regressions (v5.10.62)

Regressions Summary
-------------------

platform          | arch  | lab           | compiler | defconfig          |=
 regressions
------------------+-------+---------------+----------+--------------------+=
------------
hip07-d05         | arm64 | lab-collabora | gcc-8    | defconfig          |=
 1          =

rk3288-veyron-jaq | arm   | lab-collabora | gcc-8    | multi_v7_defconfig |=
 3          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.10.y/kernel=
/v5.10.62/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.10.y
  Describe: v5.10.62
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      f6dd002450bf7b9143aff3af42ad1e12efe9a4f8 =



Test Regressions
---------------- =



platform          | arch  | lab           | compiler | defconfig          |=
 regressions
------------------+-------+---------------+----------+--------------------+=
------------
hip07-d05         | arm64 | lab-collabora | gcc-8    | defconfig          |=
 1          =


  Details:     https://kernelci.org/test/plan/id/61320b7a17ce01a447d59665

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.62/a=
rm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.62/a=
rm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61320b7a17ce01a447d59=
666
        failing since 57 days (last pass: v5.10.46, first fail: v5.10.48) =

 =



platform          | arch  | lab           | compiler | defconfig          |=
 regressions
------------------+-------+---------------+----------+--------------------+=
------------
rk3288-veyron-jaq | arm   | lab-collabora | gcc-8    | multi_v7_defconfig |=
 3          =


  Details:     https://kernelci.org/test/plan/id/61320b0ff4b9496b09d5968d

  Results:     67 PASS, 3 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.62/a=
rm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.62/a=
rm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/61320b0ff4b9496b09d596a1
        failing since 78 days (last pass: v5.10.43, first fail: v5.10.44)

    2021-09-03T11:46:14.769732  /lava-4442442/1/../bin/lava-test-case
    2021-09-03T11:46:14.786956  <8>[   14.024546] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>
    2021-09-03T11:46:14.787211  /lava-4442442/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/61320b0ff4b9496b09d596b9
        failing since 78 days (last pass: v5.10.43, first fail: v5.10.44)

    2021-09-03T11:46:13.344291  /lava-4442442/1/../bin/lava-test-case
    2021-09-03T11:46:13.361323  <8>[   12.598729] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>
    2021-09-03T11:46:13.361560  /lava-4442442/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/61320b0ff4b9496b09d596ba
        failing since 78 days (last pass: v5.10.43, first fail: v5.10.44)

    2021-09-03T11:46:12.324406  /lava-4442442/1/../bin/lava-test-case
    2021-09-03T11:46:12.329815  <8>[   11.579381] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =

 =20
