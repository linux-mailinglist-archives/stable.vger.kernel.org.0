Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CD0A3BB81E
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 09:46:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229972AbhGEHsf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Jul 2021 03:48:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229884AbhGEHsf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Jul 2021 03:48:35 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED1BBC061574
        for <stable@vger.kernel.org>; Mon,  5 Jul 2021 00:45:58 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id u14so17496292pga.11
        for <stable@vger.kernel.org>; Mon, 05 Jul 2021 00:45:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=BszpMs0JonWYqZgtKDBBtUo1TRh0vEkAtuLenqiVM1c=;
        b=nuHt92PhnlcxGIqd7WnI7LnySMzxNIQzeaYvP8PO7lWiPm3AYF9N4ChiSCcyJ9sRjD
         HBlXSh8iOwdqCE0TIbHrQWVWFdS7LoGpO1qNhWcQ8N9rDxtzyLY15jjhXy8IYzXpcUP8
         pdovgDEOsADVMAvXwuG5IkXQphfqRc5WQ/GtsGYO/LYaagLJ/5MeGAHEKPSTVOpe2MpP
         AXpOkX9UThMuXMVSQJ958t0bRrcw/pe21Zw4GDprGG2nzHJ1WVCFk/19tGOw5YbtYfhZ
         Luilgz8rJEBuU6QexgN5TJu4XdcjcmVGvWlW/2c3WqTYxHZIee7XtHKJkn2YiG3W/YTf
         g6aQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=BszpMs0JonWYqZgtKDBBtUo1TRh0vEkAtuLenqiVM1c=;
        b=jEvQIi2PbPpcnTWFPA/2lDPBmkKJqBOaQKRMaHB1VFkLhT1ZbefU4Q4HQlm3EDduCT
         bASCT9mpvVwldMT65uSaDyZb7syUOoViZwc8FFVLVmcmO/ZY0cnzBoUfRQH/j/Uu2Gk2
         XcSgsLhGegNApVw4IPtseBybvYSD47WdmuEYFhQCPk91/5VOGN/O07m3fOJiOLcMojZ7
         mmN1MQBYfleUcdlxW5GW9nIJ5YiR+43p+VMyVMiwWngQO4qzMoHQZDCBRPC+JfNkLbsg
         0riTFRKmnwPndjCATETAknDQWO0XkD/NpVdb01c3flyVTrzINxPJmx3m6V2y2ScDNyaH
         sPGQ==
X-Gm-Message-State: AOAM531XDEwVMXF3+SzQ3S37KP5Ev0fm22fxEqFryHjC5x+JOv2WVy6R
        7FFN+zUsWpdEligQtrki/QwH6FPfj2kCmNFL
X-Google-Smtp-Source: ABdhPJx4EVXwRbt/6k8gK2nuDTalORMGI1b+j4WMRyrriSUqOcL6iJVvrqGY38jkL3ygBxHAfnOlxg==
X-Received: by 2002:a05:6a00:2293:b029:309:e87c:1f4a with SMTP id f19-20020a056a002293b0290309e87c1f4amr13316245pfe.36.1625471158251;
        Mon, 05 Jul 2021 00:45:58 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id i8sm11789068pfq.165.2021.07.05.00.45.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Jul 2021 00:45:57 -0700 (PDT)
Message-ID: <60e2b8b5.1c69fb81.fdcd9.36d4@mx.google.com>
Date:   Mon, 05 Jul 2021 00:45:57 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.12.14-5-g0029a8b67c08
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.12
Subject: stable-rc/queue/5.12 baseline: 200 runs,
 5 regressions (v5.12.14-5-g0029a8b67c08)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.12 baseline: 200 runs, 5 regressions (v5.12.14-5-g0029a8b=
67c08)

Regressions Summary
-------------------

platform          | arch  | lab           | compiler | defconfig          |=
 regressions
------------------+-------+---------------+----------+--------------------+=
------------
hip07-d05         | arm64 | lab-collabora | gcc-8    | defconfig          |=
 1          =

imx8mp-evk        | arm64 | lab-nxp       | gcc-8    | defconfig          |=
 1          =

rk3288-veyron-jaq | arm   | lab-collabora | gcc-8    | multi_v7_defconfig |=
 3          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.12/ker=
nel/v5.12.14-5-g0029a8b67c08/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.12
  Describe: v5.12.14-5-g0029a8b67c08
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      0029a8b67c082ba31a5b74f792df16bbca5bc3ad =



Test Regressions
---------------- =



platform          | arch  | lab           | compiler | defconfig          |=
 regressions
------------------+-------+---------------+----------+--------------------+=
------------
hip07-d05         | arm64 | lab-collabora | gcc-8    | defconfig          |=
 1          =


  Details:     https://kernelci.org/test/plan/id/60e28ad6ebaf81905411796c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.14-=
5-g0029a8b67c08/arm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.14-=
5-g0029a8b67c08/arm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60e28ad6ebaf819054117=
96d
        failing since 3 days (last pass: v5.12.13-109-g5add6842f3ea, first =
fail: v5.12.13-109-g47e1fda87919) =

 =



platform          | arch  | lab           | compiler | defconfig          |=
 regressions
------------------+-------+---------------+----------+--------------------+=
------------
imx8mp-evk        | arm64 | lab-nxp       | gcc-8    | defconfig          |=
 1          =


  Details:     https://kernelci.org/test/plan/id/60e284bd37376bd7ee11798b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.14-=
5-g0029a8b67c08/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.14-=
5-g0029a8b67c08/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60e284bd37376bd7ee117=
98c
        new failure (last pass: v5.12.13-109-g47e1fda87919) =

 =



platform          | arch  | lab           | compiler | defconfig          |=
 regressions
------------------+-------+---------------+----------+--------------------+=
------------
rk3288-veyron-jaq | arm   | lab-collabora | gcc-8    | multi_v7_defconfig |=
 3          =


  Details:     https://kernelci.org/test/plan/id/60e290e6524dd3718111796c

  Results:     67 PASS, 3 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.14-=
5-g0029a8b67c08/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-=
veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.14-=
5-g0029a8b67c08/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-=
veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/60e290e6524dd37181117984
        failing since 20 days (last pass: v5.12.10-48-g5e97c6651365, first =
fail: v5.12.10-173-gfd0b35fa0b0c)

    2021-07-05T04:55:59.263177  /lava-4139236/1/../bin/lava-test-case<8>[  =
 14.962876] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Drockchip-iodomain-grf-prob=
ed RESULT=3Dfail>
    2021-07-05T04:55:59.263479     =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/60e290e6524dd3718111799c
        failing since 20 days (last pass: v5.12.10-48-g5e97c6651365, first =
fail: v5.12.10-173-gfd0b35fa0b0c)

    2021-07-05T04:55:57.830051  /lava-4139236/1/../bin/lava-test-case<8>[  =
 13.533343] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Ddwmmc_rockchip-sdio0-probe=
d RESULT=3Dfail>
    2021-07-05T04:55:57.830540     =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/60e290e6524dd3718111799d
        failing since 20 days (last pass: v5.12.10-48-g5e97c6651365, first =
fail: v5.12.10-173-gfd0b35fa0b0c)

    2021-07-05T04:55:56.809043  /lava-4139236/1/../bin/lava-test-case
    2021-07-05T04:55:56.814628  <8>[   12.513362] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =

 =20
