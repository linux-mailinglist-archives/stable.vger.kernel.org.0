Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 668F63BBDA4
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 15:44:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230414AbhGENrH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Jul 2021 09:47:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230333AbhGENrH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Jul 2021 09:47:07 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54B38C061574
        for <stable@vger.kernel.org>; Mon,  5 Jul 2021 06:44:29 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id 145so2729940pfv.0
        for <stable@vger.kernel.org>; Mon, 05 Jul 2021 06:44:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=jskxnyEsD2xCmMMFi5ZB3UL1j9L5a2FmKRbMoRsKQp4=;
        b=R/vARMZoshbWF+VL2AyDb4cc1xNkvLOCvKZKFiaGPjRALEownvJ6BhvshwY71l8mmM
         5EFsv1YewHgIjJ6E32jDNFdd6xlssAjkujDyibQTJMoBJ3zjLeYUa1lIBDZB0mD756yB
         i4RQ4Qv/12f/4HoPwgjwh7lKje+efpfNpJlQHJJy0Zld2z+5HURBfw5p2JjIQ36FshLw
         NlJvwnH59kPaAlhqd39inFCAVG5UTfIrgexueZaeB6fmPeWVQgdkSbz8xlK9O+WDP91O
         kl352XAAeYs3A0aNcydH2F9m56Tv+8HHrzHRwrUnfYJL+9exoSiw3t8BhkiIR4qHkRW1
         Dn5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=jskxnyEsD2xCmMMFi5ZB3UL1j9L5a2FmKRbMoRsKQp4=;
        b=JLRnvZC4srtHaoETl2YPG1NuMqAT+oqo4aOfvIYed74f0tQXajbxX5SNXl0YQuw4tz
         1NbqsoZVR8DAPoFbYRfdtpcrIaiOOXe5LzfPUHPR5obO/2G8fwgcN/H9XiBdl1QIqGMx
         GSuNpdIk9TlWb35pph3u8LicXjMtc1vHUe+U21/X/n0u5AWRjXNta9hlY1C8qofxpRhT
         RG4FCGgcDa4tvCmmq1PqMi/nUOETGOFwEv+LCVLdglbrM1nWqf7018PP2fmPGqJv0lNX
         wAk62Wjl7yRWEeFHDaObv62G0F2GGQ/7QUfzFGmz4G5l64LTg7cGbvPXBQxxyOQ8+gIY
         NG9g==
X-Gm-Message-State: AOAM533n8ht/kkYd8AWlY11fg4/yImQi9WSnl7AuZ4L5hWZgOGIvzzF3
        XrZvv5KOBRHKYKTtLeqAnqGz9gxegCdRq46F
X-Google-Smtp-Source: ABdhPJxtBlu4BlwZQOmRkg75MOF7jYhikEMPgYXrzZdOtGiOI4MnpaeStqhhkZJRgDBR6Wy3dsTHaw==
X-Received: by 2002:a62:1a4b:0:b029:309:ab40:9a22 with SMTP id a72-20020a621a4b0000b0290309ab409a22mr14992561pfa.55.1625492668765;
        Mon, 05 Jul 2021 06:44:28 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y8sm13613720pfe.162.2021.07.05.06.44.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Jul 2021 06:44:28 -0700 (PDT)
Message-ID: <60e30cbc.1c69fb81.bb6b5.871a@mx.google.com>
Date:   Mon, 05 Jul 2021 06:44:28 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.10.47-6-gbe997714814b
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
Subject: stable-rc/queue/5.10 baseline: 182 runs,
 4 regressions (v5.10.47-6-gbe997714814b)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 182 runs, 4 regressions (v5.10.47-6-gbe99771=
4814b)

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
nel/v5.10.47-6-gbe997714814b/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.47-6-gbe997714814b
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      be997714814be6296281ed50eb71b0edb4672fca =



Test Regressions
---------------- =



platform          | arch  | lab           | compiler | defconfig          |=
 regressions
------------------+-------+---------------+----------+--------------------+=
------------
hip07-d05         | arm64 | lab-collabora | gcc-8    | defconfig          |=
 1          =


  Details:     https://kernelci.org/test/plan/id/60e2dcd1d79ab7a4be11797e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.47-=
6-gbe997714814b/arm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.47-=
6-gbe997714814b/arm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60e2dcd1d79ab7a4be117=
97f
        failing since 3 days (last pass: v5.10.46-100-gce5b41f85637, first =
fail: v5.10.46-100-g3b96099161c8b) =

 =



platform          | arch  | lab           | compiler | defconfig          |=
 regressions
------------------+-------+---------------+----------+--------------------+=
------------
rk3288-veyron-jaq | arm   | lab-collabora | gcc-8    | multi_v7_defconfig |=
 3          =


  Details:     https://kernelci.org/test/plan/id/60e2dff3af21c061cf117985

  Results:     67 PASS, 3 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.47-=
6-gbe997714814b/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-=
veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.47-=
6-gbe997714814b/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-=
veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/60e2dff3af21c061cf11799d
        failing since 20 days (last pass: v5.10.43-44-g253317604975, first =
fail: v5.10.43-130-g87b5f83f722c)

    2021-07-05T10:33:16.645222  /lava-4140663/1/../bin/lava-test-case
    2021-07-05T10:33:16.661109  <8>[   13.857871] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/60e2dff4af21c061cf1179b3
        failing since 20 days (last pass: v5.10.43-44-g253317604975, first =
fail: v5.10.43-130-g87b5f83f722c)

    2021-07-05T10:33:15.220039  /lava-4140663/1/../bin/lava-test-case
    2021-07-05T10:33:15.238234  <8>[   12.433688] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>
    2021-07-05T10:33:15.238546  /lava-4140663/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/60e2dff4af21c061cf1179b4
        failing since 20 days (last pass: v5.10.43-44-g253317604975, first =
fail: v5.10.43-130-g87b5f83f722c)

    2021-07-05T10:33:14.207245  /lava-4140663/1/../bin/lava-test-case<8>[  =
 11.414544] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Ddwmmc_rockchip-sdmmc-probe=
d RESULT=3Dfail>
    2021-07-05T10:33:14.207525     =

 =20
