Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 703C5401BF9
	for <lists+stable@lfdr.de>; Mon,  6 Sep 2021 14:59:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242377AbhIFNAv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Sep 2021 09:00:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243338AbhIFM7z (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Sep 2021 08:59:55 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 861B0C06175F
        for <stable@vger.kernel.org>; Mon,  6 Sep 2021 05:57:50 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id v1so3882527plo.10
        for <stable@vger.kernel.org>; Mon, 06 Sep 2021 05:57:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=v99JPbwkJo2uVaclZfPsrlMYEE5wrZRNgkCAh2owUzg=;
        b=CPTwWg9kvhGkkjs5EYF5FgkWJToRkF/rlJYEGsxxXzfXZOmOUl8UH126toqqMoYuoi
         4r88yLDIRzYNkGJfu6Us0/g0ddGteyWl6arNfI6jcNrrT8sJXyFmshKCjZy80RcTl6uB
         K0SBVGqb4WhhBvvUQ0ZOBXuEcz664LFy/EqsRiv4lArLPsYGzOAvpekmxOVbqlQUyowy
         cJVXCFN++XF9SYSmpfVSDkCscoXcGJp0fJJeifdI1tyirnURk5XpTHgowJCeFogQoqQe
         5K/x7RMlqK/Lajqdw+iE3iX4tGAOtahIMpQyY0LPIGHTjzYZJNdAPnFg/sbcYnvogdhn
         faCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=v99JPbwkJo2uVaclZfPsrlMYEE5wrZRNgkCAh2owUzg=;
        b=cp2fNIW3n5bKYULzIWVaHuZ5nuhHZ3utNQdEcqq7NKE70aaXlL9nBUchgA0LGBwUIJ
         xcRmpeoLke/IjtV2Goz3yS0WL/5YpbPc0Q507g6RpwWbjAPitsapsAbVhwA9uCox1tTD
         wwQcPi2zzf/2OIaw8HQsD9sXG/42ijHa5Sd86HACe+8IPVyLiBr3LdgeeJgPy8jPOrfe
         wfCaQN35gZEzodJ6ax2+u7Yp3YjdQRVNow7vH68jEOqoiHN0xSqpKMO6VD69JdgaTyCD
         2ylVgjTFd7f94av2NMMkB3WxVP5yUd9x4fkQ7f5KVyrjYEidLsDpdstrDVT2DcyCd6vO
         T2mA==
X-Gm-Message-State: AOAM532GDJ1OU4Du08WjANoqh0QMa0pNojcoJK2t6/C0TBIGeu1p6p5R
        /gCgeY6AgUVue8KhXIjsR+6fLWTWinuYQ9vL
X-Google-Smtp-Source: ABdhPJwVrWG0m9LK437PpytTVZt62V9uMO5t9c6zfloM3AWbIcUJyZ0YtuUIYvxqGVLeGblphF3kGg==
X-Received: by 2002:a17:902:a3ce:b0:13a:259:69f0 with SMTP id q14-20020a170902a3ce00b0013a025969f0mr10843424plb.58.1630933068392;
        Mon, 06 Sep 2021 05:57:48 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b17sm9310360pgl.61.2021.09.06.05.57.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Sep 2021 05:57:48 -0700 (PDT)
Message-ID: <6136104c.1c69fb81.f2a44.9b06@mx.google.com>
Date:   Mon, 06 Sep 2021 05:57:48 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.14.246-11-g268a3df3692c
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.14
Subject: stable-rc/queue/4.14 baseline: 159 runs,
 4 regressions (v4.14.246-11-g268a3df3692c)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 159 runs, 4 regressions (v4.14.246-11-g268a3=
df3692c)

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
nel/v4.14.246-11-g268a3df3692c/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.246-11-g268a3df3692c
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      268a3df3692c9429c3d9cc93e2c4deea7998b898 =



Test Regressions
---------------- =



platform          | arch  | lab           | compiler | defconfig          |=
 regressions
------------------+-------+---------------+----------+--------------------+=
------------
meson-gxm-q200    | arm64 | lab-baylibre  | gcc-8    | defconfig          |=
 1          =


  Details:     https://kernelci.org/test/plan/id/6135e6b3b7fd90778bd59686

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.246=
-11-g268a3df3692c/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q20=
0.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.246=
-11-g268a3df3692c/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q20=
0.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6135e6b3b7fd90778bd59=
687
        failing since 189 days (last pass: v4.14.222-11-g13b8482a0f700, fir=
st fail: v4.14.222-120-gdc8887cba23e) =

 =



platform          | arch  | lab           | compiler | defconfig          |=
 regressions
------------------+-------+---------------+----------+--------------------+=
------------
rk3288-veyron-jaq | arm   | lab-collabora | gcc-8    | multi_v7_defconfig |=
 3          =


  Details:     https://kernelci.org/test/plan/id/6135eace7426297f75d59675

  Results:     63 PASS, 6 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.246=
-11-g268a3df3692c/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk328=
8-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.246=
-11-g268a3df3692c/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk328=
8-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/6135eace7426297f75d59689
        failing since 83 days (last pass: v4.14.236-20-gdb14655bb4bf, first=
 fail: v4.14.236-49-gfd4c319f2583)

    2021-09-06T10:17:25.771392  /lava-4456758/1/../bin/lava-test-case
    2021-09-06T10:17:25.788381  [   18.532856] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>
    2021-09-06T10:17:25.788616  /lava-4456758/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/6135eacf7426297f75d596a2
        failing since 83 days (last pass: v4.14.236-20-gdb14655bb4bf, first=
 fail: v4.14.236-49-gfd4c319f2583)

    2021-09-06T10:17:23.339625  /lava-4456758/1/../bin/lava-test-case
    2021-09-06T10:17:23.356545  [   16.100999] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/6135eacf7426297f75d596a3
        failing since 83 days (last pass: v4.14.236-20-gdb14655bb4bf, first=
 fail: v4.14.236-49-gfd4c319f2583)

    2021-09-06T10:17:22.319695  /lava-4456758/1/../bin/lava-test-case
    2021-09-06T10:17:22.325133  [   15.081865] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =

 =20
