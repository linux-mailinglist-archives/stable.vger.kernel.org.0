Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21C7F3D44A3
	for <lists+stable@lfdr.de>; Sat, 24 Jul 2021 05:47:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233774AbhGXDGe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Jul 2021 23:06:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234023AbhGXDGd (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 23 Jul 2021 23:06:33 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4064C06175F
        for <stable@vger.kernel.org>; Fri, 23 Jul 2021 20:47:05 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id k4-20020a17090a5144b02901731c776526so11679372pjm.4
        for <stable@vger.kernel.org>; Fri, 23 Jul 2021 20:47:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=3xP0snDaATP3NLLsBxUqZs7WkE9UMqNY4rb6B4WbOT4=;
        b=14B1XeWd04n7yTO0urSdS6o3jstyjLkvTsDcfPOCCHqkumRRtcHbGFeEhxVKXWwFph
         zBkf+pI0qJ3YPQESAAGLApWriGuoPuMq2NZeo02QPhRd/RrBOtoKDYEuCbtMSTkLLUUI
         HzJirpGFb+jx7m4qd93eDpt0SpWv0vwa0uJej8KGjqK4OOHi22AqzF4OJh9epa+djdFc
         /tp3ZuKZLjaOUnDEbhYhncrukB4N7EY0nwL0vRn/otgWRfJYgs8v0DRhMGtZBcMyemRn
         X2ZwRDUYyQgUuOdaTSUo16zkggzZcy0CS945CmRAPvTe++htBrsokP2s+kPP9AZrFnf5
         RBVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=3xP0snDaATP3NLLsBxUqZs7WkE9UMqNY4rb6B4WbOT4=;
        b=WGCkxX9IfqSlFog3jXAyb/qNrnvHN1HsS3CdPJUBu+B70BiyxcX5BTXmz7lF49emSa
         bo1IdPua5CJ39FpDllOWVnIQz0rf01pCCQWn+4nG+MeTuV7YYHjEptZbAbSwU6vCcjxZ
         9PoVxufmjVcuSa1sgoFW2bgb9Ezjpk8rxGqHwY44Zb9DGHqjBREIKVGR0y4EAUoUEB7e
         ++RMIOgL16/4DmqgvvlsUj6ebDApWQuWZGuPlmcO6E0fcQOxg6UuRDlRMtBDgZG8ZegA
         44K4N/PNQlluOc1hfxtd5RCKrF6k6nn6qv2qlFLSZ19+g1bURv4EXfNlMI4ihYclKYyb
         e9xg==
X-Gm-Message-State: AOAM530W1yfRNnkAwZstaJMBuifKbh+xqlLrdlUvIV4Sk9vbvdv3OPSs
        jJ48tHCYibQOv2R0sK7+3gNIHit5uQzASlj4
X-Google-Smtp-Source: ABdhPJwr24Q2IlNajCKjAn5ou3v39ZjsMOxiPbzgEnCT1SluUvR2sKzQ2psKTq/tEpun+jiRMgKgCg==
X-Received: by 2002:a17:90a:4404:: with SMTP id s4mr16651157pjg.218.1627098425192;
        Fri, 23 Jul 2021 20:47:05 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id m6sm4089175pgs.75.2021.07.23.20.47.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Jul 2021 20:47:04 -0700 (PDT)
Message-ID: <60fb8d38.1c69fb81.ee65a.ca96@mx.google.com>
Date:   Fri, 23 Jul 2021 20:47:04 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.14
X-Kernelci-Kernel: v4.14.239-350-g5faeafe07d1c
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.14 baseline: 164 runs,
 4 regressions (v4.14.239-350-g5faeafe07d1c)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 164 runs, 4 regressions (v4.14.239-350-g5fae=
afe07d1c)

Regressions Summary
-------------------

platform          | arch  | lab           | compiler | defconfig          |=
 regressions
------------------+-------+---------------+----------+--------------------+=
------------
meson-gxm-q200    | arm64 | lab-baylibre  | gcc-8    | defconfig          |=
 1          =

rk3288-veyron-jaq | arm   | lab-collabora | gcc-8    | multi_v7_defconfig |=
 3          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.239-350-g5faeafe07d1c/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.239-350-g5faeafe07d1c
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      5faeafe07d1ce0ba20bd233bc54af3530868208a =



Test Regressions
---------------- =



platform          | arch  | lab           | compiler | defconfig          |=
 regressions
------------------+-------+---------------+----------+--------------------+=
------------
meson-gxm-q200    | arm64 | lab-baylibre  | gcc-8    | defconfig          |=
 1          =


  Details:     https://kernelci.org/test/plan/id/60fb545409611439943a2f43

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.239=
-350-g5faeafe07d1c/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q2=
00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.239=
-350-g5faeafe07d1c/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q2=
00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60fb545409611439943a2=
f44
        failing since 144 days (last pass: v4.14.222-11-g13b8482a0f700, fir=
st fail: v4.14.222-120-gdc8887cba23e) =

 =



platform          | arch  | lab           | compiler | defconfig          |=
 regressions
------------------+-------+---------------+----------+--------------------+=
------------
rk3288-veyron-jaq | arm   | lab-collabora | gcc-8    | multi_v7_defconfig |=
 3          =


  Details:     https://kernelci.org/test/plan/id/60fb73195dc3da1c7b3a2f47

  Results:     63 PASS, 6 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.239=
-350-g5faeafe07d1c/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk32=
88-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.239=
-350-g5faeafe07d1c/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk32=
88-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/60fb73195dc3da1c7b3a2f5b
        failing since 38 days (last pass: v4.14.236-20-gdb14655bb4bf, first=
 fail: v4.14.236-49-gfd4c319f2583)

    2021-07-24T01:55:21.921551  /lava-4239953/1/../bin/lava-test-case
    2021-07-24T01:55:21.938443  [   16.791895] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>
    2021-07-24T01:55:21.938681  /lava-4239953/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/60fb73195dc3da1c7b3a2f74
        failing since 38 days (last pass: v4.14.236-20-gdb14655bb4bf, first=
 fail: v4.14.236-49-gfd4c319f2583)

    2021-07-24T01:55:18.478030  /lava-4239953/1/../bin/lava-test-case[   13=
.342644] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Ddwmmc_rockchip-sdmmc-probed R=
ESULT=3Dfail>
    2021-07-24T01:55:18.478230  =

    2021-07-24T01:55:19.490071  /lava-4239953/1/../bin/lava-test-case
    2021-07-24T01:55:19.508349  [   14.361369] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>
    2021-07-24T01:55:19.508561  /lava-4239953/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/60fb73195dc3da1c7b3a2f75
        failing since 38 days (last pass: v4.14.236-20-gdb14655bb4bf, first=
 fail: v4.14.236-49-gfd4c319f2583) =

 =20
