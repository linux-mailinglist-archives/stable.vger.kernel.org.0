Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B21B43BB892
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 10:03:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230026AbhGEIGC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Jul 2021 04:06:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230009AbhGEIGC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Jul 2021 04:06:02 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFC57C061574
        for <stable@vger.kernel.org>; Mon,  5 Jul 2021 01:03:25 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id ie21so9520199pjb.0
        for <stable@vger.kernel.org>; Mon, 05 Jul 2021 01:03:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=+pBW7/0YXZPo0dhEbA+9g2aBgUuSDqUjusESxO6AZII=;
        b=h3ouWkm+hseZJjEPSpgUFQQe9L2117apZzy++ItoHxyxcMQTqBWpcGRidJzJThdjc2
         wBCjomeo5wOwdK8nXAGDYR0jhGtBjkU02FpU0Pm8bybe+29ae2zQ0fSRd5TpTnEqwY/F
         mXEMIRh15vF/4feUc/2vGErAH1zuPuCACLq1Oe1d8QVXa5nOScPhVHmz/M5Mk9T2S22X
         fKu/ELjuvoN9RHp3362gleTZA8FQqdyEUyBlOFSuOIP47QX7c7cWd3UNrBQUIMBjSFI4
         1fWT6snq3KDBXy2QTXn5KSi4NbwoBs1r+JfnHaq0eBKmUTLvsU8gV9rNGp70WzAJ/LjW
         3cyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=+pBW7/0YXZPo0dhEbA+9g2aBgUuSDqUjusESxO6AZII=;
        b=gdMqdbbxS+EqNHpfaMrODwJ/gvKh0FIU+JqWAaZmO6XKZG/Jd/HjMXYBEdOVDTgz/Y
         GdhkaX3unUOyj6UtaPs8TECNaO2SvauUWa32wBwakkUF9bVINKu7uBcNzfj/gLEungs6
         haXZyBz3nT40H4W0iwzwRfiTeWNtZigNU5kRYluNdKegqqnjk/0jSbTiqq5q6MVt/75q
         48nQWTCWhXojvfgqEmvGkzm7ewcwKynGb1y8t5ZRFUklvtaAkObkztWkFYUQDGULwBuj
         2yjmzSLyAn684w+fZ/gDa7CeH+bN0nO0n1PsB7+uu0v1Xe/53Rex3USU8489Uoj6vhqm
         TSng==
X-Gm-Message-State: AOAM53335d50KgSRQtXCswRT0X1DzkYgq0MjjQflTYelhG+p3zG4EpZ7
        TAC9b7CthpSUWAQi3o5DX+uYEEn3PydULS8n
X-Google-Smtp-Source: ABdhPJwYkktzN6ultIW2HRgmqDg73gbt13grZOaMl5G1Pp5PCZ0kr8oAID1TkrUqtdng2E1P8vlgsw==
X-Received: by 2002:a17:903:2341:b029:129:33d3:60ee with SMTP id c1-20020a1709032341b029012933d360eemr11566361plh.66.1625472205036;
        Mon, 05 Jul 2021 01:03:25 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id x3sm12005051pfq.161.2021.07.05.01.03.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Jul 2021 01:03:24 -0700 (PDT)
Message-ID: <60e2bccc.1c69fb81.88de2.3f8a@mx.google.com>
Date:   Mon, 05 Jul 2021 01:03:24 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.10.47-4-g61e4c095e258
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
Subject: stable-rc/queue/5.10 baseline: 150 runs,
 4 regressions (v5.10.47-4-g61e4c095e258)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 150 runs, 4 regressions (v5.10.47-4-g61e4c09=
5e258)

Regressions Summary
-------------------

platform           | arch | lab             | compiler | defconfig         =
  | regressions
-------------------+------+-----------------+----------+-------------------=
--+------------
imx6ul-pico-hobbit | arm  | lab-pengutronix | gcc-8    | imx_v6_v7_defconfi=
g | 1          =

rk3288-veyron-jaq  | arm  | lab-collabora   | gcc-8    | multi_v7_defconfig=
  | 3          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.47-4-g61e4c095e258/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.47-4-g61e4c095e258
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      61e4c095e2582a558359532787033501356bc321 =



Test Regressions
---------------- =



platform           | arch | lab             | compiler | defconfig         =
  | regressions
-------------------+------+-----------------+----------+-------------------=
--+------------
imx6ul-pico-hobbit | arm  | lab-pengutronix | gcc-8    | imx_v6_v7_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60e2887f5006594f59117993

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.47-=
4-g61e4c095e258/arm/imx_v6_v7_defconfig/gcc-8/lab-pengutronix/baseline-imx6=
ul-pico-hobbit.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.47-=
4-g61e4c095e258/arm/imx_v6_v7_defconfig/gcc-8/lab-pengutronix/baseline-imx6=
ul-pico-hobbit.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60e2887f5006594f59117=
994
        new failure (last pass: v5.10.46-100-g3b96099161c8b) =

 =



platform           | arch | lab             | compiler | defconfig         =
  | regressions
-------------------+------+-----------------+----------+-------------------=
--+------------
rk3288-veyron-jaq  | arm  | lab-collabora   | gcc-8    | multi_v7_defconfig=
  | 3          =


  Details:     https://kernelci.org/test/plan/id/60e29354e8d1f2c986117976

  Results:     67 PASS, 3 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.47-=
4-g61e4c095e258/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-=
veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.47-=
4-g61e4c095e258/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-=
veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/60e29354e8d1f2c98611798e
        failing since 20 days (last pass: v5.10.43-44-g253317604975, first =
fail: v5.10.43-130-g87b5f83f722c)

    2021-07-05T05:06:21.613277  /lava-4139333/1/../bin/lava-test-case
    2021-07-05T05:06:21.631035  <8>[   13.124915] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>
    2021-07-05T05:06:21.631795  /lava-4139333/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/60e29354e8d1f2c9861179a5
        failing since 20 days (last pass: v5.10.43-44-g253317604975, first =
fail: v5.10.43-130-g87b5f83f722c)

    2021-07-05T05:06:20.187139  /lava-4139333/1/../bin/lava-test-case
    2021-07-05T05:06:20.192708  <8>[   11.699287] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/60e29354e8d1f2c9861179a6
        failing since 20 days (last pass: v5.10.43-44-g253317604975, first =
fail: v5.10.43-130-g87b5f83f722c)

    2021-07-05T05:06:19.174160  /lava-4139333/1/../bin/lava-test-case<8>[  =
 10.679725] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Ddwmmc_rockchip-sdmmc-probe=
d RESULT=3Dfail>
    2021-07-05T05:06:19.174604     =

 =20
