Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 048393D4482
	for <lists+stable@lfdr.de>; Sat, 24 Jul 2021 05:27:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233776AbhGXCrA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Jul 2021 22:47:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233774AbhGXCrA (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 23 Jul 2021 22:47:00 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CEE9C061575
        for <stable@vger.kernel.org>; Fri, 23 Jul 2021 20:27:31 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id m2-20020a17090a71c2b0290175cf22899cso6330997pjs.2
        for <stable@vger.kernel.org>; Fri, 23 Jul 2021 20:27:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=eLk48XNsR1IzwbQz0daKkd1AAhQo63bzBLE3KZ1BQGU=;
        b=auUxWRSK7fB4PpF1zwMW+442vP1YpOjX6fwXUuYmFMpa0LoBEBpjB6SPW727tlp/W0
         OoxThX77mNIiFn9biNxHdsiyrZVdeqLHitaUePTKbuR8MXcuXWOlHylD/MAZrqnEoAyN
         jqw3Q1T5F88g109UhqSD+Bzyao7qOziWI6YuKdGnyKTPk0XF+41Mog+dNqyJrtehSOWU
         BAEk0FLhHBkHhRq6tCfwYqrFSmP8EYgtCpVn4BWx94khAfHXXRVh0lVTaOE1UwKr/C1+
         t/GeMv3hO86RIZIziW1ArQFdZ7oGpo6qhBiLicLgfJWBCfCJmxQTfzYP3vtnr357AIxH
         CYoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=eLk48XNsR1IzwbQz0daKkd1AAhQo63bzBLE3KZ1BQGU=;
        b=fqTxQGPeNmY1qXfianpcMx5If4AtBA9WkWMYWb30cIbXySVFyFpbi8k4wZt/VE67tu
         AvJqAwF5Mty+LbGKK7hH3YIbpPuO4u3+cDO467K8u3fdU1aA2y0m4PR9wVlhludVTisd
         /aGIyYz0i+BAlz/fIrkeVe+6KYAnlq1O7G4M5W78B4RPTI4OzrN5UoU60MtZ6IPHPPMP
         jU1m0HuusTQ6nmvDLXH18gk1mFdhpA6RaAerNeHoI7Z8eR423K8xk4NNnDRJP3Q7BTua
         OeOBs1MSr0/BSkncBs7jH2i4fPFgsKH6s8f/wNI0qYC8iCBU3Lq7LnEqpqcycmmoQYAm
         dVlw==
X-Gm-Message-State: AOAM530RkDcXtyQaEZ43Ps9aGYLZcbIDvSdo5s3iKVmFwf6N2AWKimsx
        DzBJlKS5CcI7/4sD96hAhSNvPMGH4Zf0IHU0
X-Google-Smtp-Source: ABdhPJxwjlk/egSyi+7ibpozJtZVO1Sz9mzoMB6kkw2a8gIQwWj7Rej/8mF/sWtOUG195YwEKZ8RPg==
X-Received: by 2002:a17:90a:6be1:: with SMTP id w88mr7277857pjj.121.1627097250489;
        Fri, 23 Jul 2021 20:27:30 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 26sm4787033pgx.72.2021.07.23.20.27.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Jul 2021 20:27:30 -0700 (PDT)
Message-ID: <60fb88a2.1c69fb81.ac71a.fe5f@mx.google.com>
Date:   Fri, 23 Jul 2021 20:27:30 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.4
X-Kernelci-Kernel: v5.4.133-220-g3fa0819bf9a1
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.4 baseline: 198 runs,
 4 regressions (v5.4.133-220-g3fa0819bf9a1)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 198 runs, 4 regressions (v5.4.133-220-g3fa081=
9bf9a1)

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.133-220-g3fa0819bf9a1/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.133-220-g3fa0819bf9a1
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      3fa0819bf9a16553dce27d791d652a08f23aa46d =



Test Regressions
---------------- =



platform          | arch  | lab           | compiler | defconfig          |=
 regressions
------------------+-------+---------------+----------+--------------------+=
------------
meson-gxm-q200    | arm64 | lab-baylibre  | gcc-8    | defconfig          |=
 1          =


  Details:     https://kernelci.org/test/plan/id/60fb560c974c71aa283a2f33

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.133-2=
20-g3fa0819bf9a1/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q200=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.133-2=
20-g3fa0819bf9a1/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q200=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60fb560c974c71aa283a2=
f34
        new failure (last pass: v5.4.133-220-gf339372bde31) =

 =



platform          | arch  | lab           | compiler | defconfig          |=
 regressions
------------------+-------+---------------+----------+--------------------+=
------------
rk3288-veyron-jaq | arm   | lab-collabora | gcc-8    | multi_v7_defconfig |=
 3          =


  Details:     https://kernelci.org/test/plan/id/60fb729eb2c84f07813a2f40

  Results:     67 PASS, 3 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.133-2=
20-g3fa0819bf9a1/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288=
-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.133-2=
20-g3fa0819bf9a1/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288=
-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/60fb729eb2c84f07813a2f54
        failing since 38 days (last pass: v5.4.125-37-g7cda316475cf, first =
fail: v5.4.125-84-g411d62eda127)

    2021-07-24T01:53:16.830641  /lava-4239909/1/../bin/lava-test-case
    2021-07-24T01:53:16.846115  <8>[   15.415422] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>
    2021-07-24T01:53:16.846359  /lava-4239909/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/60fb729eb2c84f07813a2f6a
        failing since 38 days (last pass: v5.4.125-37-g7cda316475cf, first =
fail: v5.4.125-84-g411d62eda127)

    2021-07-24T01:53:15.402005  /lava-4239909/1/../bin/lava-test-case
    2021-07-24T01:53:15.420558  <8>[   13.989060] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>
    2021-07-24T01:53:15.420981  /lava-4239909/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/60fb729eb2c84f07813a2f6b
        failing since 38 days (last pass: v5.4.125-37-g7cda316475cf, first =
fail: v5.4.125-84-g411d62eda127)

    2021-07-24T01:53:14.388602  /lava-4239909/1/../bin/lava-test-case<8>[  =
 12.969602] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Ddwmmc_rockchip-sdmmc-probe=
d RESULT=3Dfail>
    2021-07-24T01:53:14.389101     =

 =20
