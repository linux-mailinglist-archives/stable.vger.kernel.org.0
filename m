Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 541E5407DB5
	for <lists+stable@lfdr.de>; Sun, 12 Sep 2021 15:53:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235361AbhILNyb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 12 Sep 2021 09:54:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235178AbhILNyb (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 12 Sep 2021 09:54:31 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0A86C061574
        for <stable@vger.kernel.org>; Sun, 12 Sep 2021 06:53:16 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id g13-20020a17090a3c8d00b00196286963b9so4742167pjc.3
        for <stable@vger.kernel.org>; Sun, 12 Sep 2021 06:53:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Md0NwOTO9UVVUoG4Cj18FLPYWTY8McQXdWbhibhT2HU=;
        b=LYNjgwubaeR56xtnMrL/hSh+Lz3UcjXpgXkZ25zFAr04K9IXzHKnF2Z6ruNjCI/8qX
         AhO9mFO6XIBZTgubrRQKJfgXfz7ZvFOfaM+v2KuDCU4gv49CORgwikPyrPGFWCz6b9KU
         yT7JntOlVBdG6fc1E50vwQdxFyDBjScs0RX0/zi/hgqc5G0bigtJM1GYnwA0/Xsmc+om
         TMHHbWrd8gGYMoNE2IXYgAIvBQddkQp/SCd+sdPlNQlo3irEICmtZUAg/tjqUG8eJILl
         1/UF+4YkLXo9itH1b8/oASvfzWOyrtqhFJ7xcV+xXdNEf/spcac4G584RBDZLmvCOIau
         jNZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Md0NwOTO9UVVUoG4Cj18FLPYWTY8McQXdWbhibhT2HU=;
        b=rWsxwWuVHO1/RgJ8Di9Cb4FLwzQ/HxvfZDbY2tvRL8qohzXE37Abq8rK2vuvwkejU+
         PU5qGVDooX23K2oGhM3hkpecje+xz7yYbFnfp+vVdUBP8fgIOHNroGLDWnaB+gWAapcK
         unFGOnazGjvSWsRTgdnhrYzv2oyCrQRgcVEIierwinKQrinD925rGanV5WcFj2qPw/fQ
         NdJjUT125WfDnutyXJUTf0Dvs17Vi39RIPSbLKb9pcgHJIkFEhshONhTcpRkZBOw8tRw
         A1ezcX3Dl2wZjGPazGvLDfqZNYak0HbWLmKFVlNLGy+xsZu2bTV8FWAmfbA+kku5ve2r
         Uv8w==
X-Gm-Message-State: AOAM530p5Wo0HJImF7LwJGJ3WVCYKDxhN+YJTeMS2kY8DHFIF8gK/JAO
        Lu8fzgtJrqlLrybi9wX64b+tZ2kojXeUDhYX
X-Google-Smtp-Source: ABdhPJzDduOhvVTfr5qnajrqukH/tJm5g5wkzR8XhnQX1PsUzL0dmWiag0nj0CiUcpXiE/ke/FC3uw==
X-Received: by 2002:a17:90a:7145:: with SMTP id g5mr7672333pjs.128.1631454796086;
        Sun, 12 Sep 2021 06:53:16 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id j2sm4161406pfr.126.2021.09.12.06.53.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Sep 2021 06:53:15 -0700 (PDT)
Message-ID: <613e064b.1c69fb81.6e707.a362@mx.google.com>
Date:   Sun, 12 Sep 2021 06:53:15 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.10.63-26-gfb6b5e198aab
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
Subject: stable-rc/queue/5.10 baseline: 217 runs,
 4 regressions (v5.10.63-26-gfb6b5e198aab)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 217 runs, 4 regressions (v5.10.63-26-gfb6b5e=
198aab)

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.63-26-gfb6b5e198aab/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.63-26-gfb6b5e198aab
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      fb6b5e198aabd1ffb3a2bf84e9694f264d6a9209 =



Test Regressions
---------------- =



platform          | arch  | lab           | compiler | defconfig          |=
 regressions
------------------+-------+---------------+----------+--------------------+=
------------
hip07-d05         | arm64 | lab-collabora | gcc-8    | defconfig          |=
 1          =


  Details:     https://kernelci.org/test/plan/id/613dd8e8af5c922938d5969e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.63-=
26-gfb6b5e198aab/arm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.63-=
26-gfb6b5e198aab/arm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/613dd8e8af5c922938d59=
69f
        failing since 72 days (last pass: v5.10.46-100-gce5b41f85637, first=
 fail: v5.10.46-100-g3b96099161c8b) =

 =



platform          | arch  | lab           | compiler | defconfig          |=
 regressions
------------------+-------+---------------+----------+--------------------+=
------------
rk3288-veyron-jaq | arm   | lab-collabora | gcc-8    | multi_v7_defconfig |=
 3          =


  Details:     https://kernelci.org/test/plan/id/613de853f742e5bd4ad5968c

  Results:     67 PASS, 3 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.63-=
26-gfb6b5e198aab/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288=
-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.63-=
26-gfb6b5e198aab/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288=
-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/613de853f742e5bd4ad596a0
        failing since 89 days (last pass: v5.10.43-44-g253317604975, first =
fail: v5.10.43-130-g87b5f83f722c)

    2021-09-12T11:45:02.066550  <8>[   12.281096] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-iodomain-driver-present RESULT=3Dpass>
    2021-09-12T11:45:03.080077  /lava-4501069/1/../bin/lava-test-case
    2021-09-12T11:45:03.097213  <8>[   13.300634] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>
    2021-09-12T11:45:03.097464  /lava-4501069/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/613de853f742e5bd4ad596b8
        failing since 89 days (last pass: v5.10.43-44-g253317604975, first =
fail: v5.10.43-130-g87b5f83f722c)

    2021-09-12T11:45:01.653263  /lava-4501069/1/../bin/lava-test-case
    2021-09-12T11:45:01.670210  <8>[   11.873600] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>
    2021-09-12T11:45:01.670474  /lava-4501069/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/613de853f742e5bd4ad596b9
        failing since 89 days (last pass: v5.10.43-44-g253317604975, first =
fail: v5.10.43-130-g87b5f83f722c)

    2021-09-12T11:45:00.633297  /lava-4501069/1/../bin/lava-test-case
    2021-09-12T11:45:00.638920  <8>[   10.853918] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =

 =20
