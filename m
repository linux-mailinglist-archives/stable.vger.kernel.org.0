Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D20AD3BC12D
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 17:46:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231839AbhGEPss (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Jul 2021 11:48:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231806AbhGEPss (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Jul 2021 11:48:48 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE25DC061574
        for <stable@vger.kernel.org>; Mon,  5 Jul 2021 08:46:10 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id g6-20020a17090adac6b029015d1a9a6f1aso125821pjx.1
        for <stable@vger.kernel.org>; Mon, 05 Jul 2021 08:46:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=BVyYaQF3Z7Js0Ki5tXRB+3clM15xg0fQLAzDcvBqq4I=;
        b=W6gfuAGNgIfnucQHmUYPZrCxO0lQEbFFPAAAhv/T7WEmQAG0HGxxjUvP/ciLbwr3Bu
         Ns1vByXkcXI+zfEM6li4aix2Q5UEAfx/bL2KDFQ4L7xZv1EMGWVvmn4RgteAR3GCvXaK
         ntlIaSjzxXaZRhEnATCr/1X9O4dq3yb0wTsPmfCkm7Opp2QQ1K5L7+v0V09+sZRDe7+1
         bk+gVPkE0Y3NacY3E0qW8GNS/VjAKfdrMNCy5EfKw8tAITIYUWo44cPxfkZ/I/WxsHck
         K+OYx8Xc0JmWtDCIBaNulaG/UqNjvQ6e93Smuc8lP7+BYCXeBMYoWgdC4eWV5E8mASSD
         LQwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=BVyYaQF3Z7Js0Ki5tXRB+3clM15xg0fQLAzDcvBqq4I=;
        b=SSNBIxK8m/edKpY/vRcL0qLhmlRr0FCyc0l2D9UNSJuN/xSfuI346QPKfRD0ty5kbS
         dT3Hvh0J/YgEXNEuAf1Z+l2qebX6QuGUn5vYsraB5EXIfBya0tsxZkho3wd18/VRfmnS
         uY5n8SkAOhZcpUYZx6/2kjl4eTSIu2pah5d4sP5cC5HH8xLq5ZIvJje+1h8xb/yDQhuw
         lYWlKCEnN+c073KK7wxjJ5WiueBhSwpQFCDyHIubOPTrLTGyQeiPAWdSHuxJJTPSVXB4
         T7pa4v0ZxIkNVO7j2Zc9RtIqXL6ssnwp+QuoBMXt/OUuVRSKgSC3kBuWVJTRexqz0+u1
         koQA==
X-Gm-Message-State: AOAM530URuI5C8IOY4hnByxvHNfekyYMh3g3j3VSiarCP6inUW/8Vaib
        U2Qmwky0wo6WSO+WMtuI+ewZ6gZre78OSJUA
X-Google-Smtp-Source: ABdhPJz6bfqO0T4Yudzj4uSE+Ht5zAP3kKU1XOCouOc2YwY2Jjd8xsdaiCxW5Bdomf63HBlnTNuGkQ==
X-Received: by 2002:a17:902:fe8b:b029:129:7797:ff4d with SMTP id x11-20020a170902fe8bb02901297797ff4dmr8572247plm.17.1625499970078;
        Mon, 05 Jul 2021 08:46:10 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y7sm13893229pfy.153.2021.07.05.08.46.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Jul 2021 08:46:09 -0700 (PDT)
Message-ID: <60e32941.1c69fb81.b8532.8bf6@mx.google.com>
Date:   Mon, 05 Jul 2021 08:46:09 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.238-21-gfabbaad9e1e7
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.14
Subject: stable-rc/queue/4.14 baseline: 146 runs,
 4 regressions (v4.14.238-21-gfabbaad9e1e7)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 146 runs, 4 regressions (v4.14.238-21-gfabba=
ad9e1e7)

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
nel/v4.14.238-21-gfabbaad9e1e7/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.238-21-gfabbaad9e1e7
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      fabbaad9e1e75ca9045ba3ccb90a8da972d1d46a =



Test Regressions
---------------- =



platform          | arch  | lab           | compiler | defconfig          |=
 regressions
------------------+-------+---------------+----------+--------------------+=
------------
meson-gxm-q200    | arm64 | lab-baylibre  | gcc-8    | defconfig          |=
 1          =


  Details:     https://kernelci.org/test/plan/id/60e2f941f0052e94411179ee

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.238=
-21-gfabbaad9e1e7/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q20=
0.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.238=
-21-gfabbaad9e1e7/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q20=
0.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60e2f941f0052e9441117=
9ef
        failing since 126 days (last pass: v4.14.222-11-g13b8482a0f700, fir=
st fail: v4.14.222-120-gdc8887cba23e) =

 =



platform          | arch  | lab           | compiler | defconfig          |=
 regressions
------------------+-------+---------------+----------+--------------------+=
------------
rk3288-veyron-jaq | arm   | lab-collabora | gcc-8    | multi_v7_defconfig |=
 3          =


  Details:     https://kernelci.org/test/plan/id/60e319f359da015c8d11797e

  Results:     63 PASS, 6 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.238=
-21-gfabbaad9e1e7/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk328=
8-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.238=
-21-gfabbaad9e1e7/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk328=
8-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/60e319f359da015c8d117996
        failing since 20 days (last pass: v4.14.236-20-gdb14655bb4bf, first=
 fail: v4.14.236-49-gfd4c319f2583)

    2021-07-05T14:40:37.765326  /lava-4141871/1/../bin/lava-test-case
    2021-07-05T14:40:37.781424  [   17.348065] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>
    2021-07-05T14:40:37.781646  /lava-4141871/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/60e319f359da015c8d1179ad
        failing since 20 days (last pass: v4.14.236-20-gdb14655bb4bf, first=
 fail: v4.14.236-49-gfd4c319f2583) =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/60e319f359da015c8d1179ae
        failing since 20 days (last pass: v4.14.236-20-gdb14655bb4bf, first=
 fail: v4.14.236-49-gfd4c319f2583)

    2021-07-05T14:40:34.314625  /lava-4141871/1/../bin/lava-test-case
    2021-07-05T14:40:34.321515  [   13.897568] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =

 =20
