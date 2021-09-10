Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C7B64072F1
	for <lists+stable@lfdr.de>; Fri, 10 Sep 2021 23:30:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234306AbhIJVbP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Sep 2021 17:31:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229669AbhIJVbK (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Sep 2021 17:31:10 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F9E4C061574
        for <stable@vger.kernel.org>; Fri, 10 Sep 2021 14:29:59 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id f3-20020a17090a638300b00199097ddf1aso2445842pjj.0
        for <stable@vger.kernel.org>; Fri, 10 Sep 2021 14:29:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=M7Lv3FZEn2iLuDBNaH/VbSKEBKkG9EwPsikD0WcRcyM=;
        b=hiFUtaS0iWBQUT2QQNFTdMbv6IqyCftNJ3N42TUBGZITga2kMpI6ZZL+xE4EqY5Jlr
         RRidB8hLme9JYg9ygGBfx5i8qO0THvkkqIy62FfppCmC9LwmmmOpwBeTbqi4i/WhStHE
         b5xWTo87dpYOlIZg9joPBLmA/FtG7UdCWcbYiSQHwdGzKCDZp+ggotJgy+9qXJ9PjRqg
         P5ztJGV4SfUh2fmwnLI2xA7BefvN3/ue5hxS+IjP4wBVP7IVQGWCzbiWFJthpm69Av6S
         6tmqkRxdBltwv+xZHFTJbV/X9KfACe9sJNurrzJw4QHPupDP7bqnBHU522HoCRrCs0pm
         4uuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=M7Lv3FZEn2iLuDBNaH/VbSKEBKkG9EwPsikD0WcRcyM=;
        b=m9MMRrH9IG2HxugyKeiWSUGDxrkAj11Rcy0DB5D8gZdlwc+Pdq1hbYMiF3dxxTwCkH
         zJX/07DkBZLIx/MgUhCgLFSfK0BdTazaeoLhyfYROSK4SsuY8pNvPqhXrvkN4wUP9eWc
         zfFySihiqMryjAlnuRsaV64d74cbAFmR28ODTOKbD1W3KUmiZ39a2bvVNqgqzPbMCJ/d
         z4Srjrq3DBrxAr8O8ANDvCjlv9V1fff0HM/IcGkTSl5i50mmhtL10qoC7kmmjFwudqvw
         aWHXDMiv1YyaFFDhzIFdEN3R4ny8UsuxSuaUkj091XWMllDB4hqMzEq7nqUfkKVbagGA
         1HUA==
X-Gm-Message-State: AOAM533D0too4diQDZbZiWTygBjhnDkWorvFndQw00DigTWRF85tiuo8
        G3N84TfPPTev2LTG/0P8D8MLJjkaDuwARb+m
X-Google-Smtp-Source: ABdhPJzqzaedY3bv5YR7Yff2ooh6qHrRlGm8c2k3MqJhBImvJgCU856pP8hmq6k5lmbPIKOqS88rWQ==
X-Received: by 2002:a17:90a:b105:: with SMTP id z5mr11505338pjq.64.1631309398619;
        Fri, 10 Sep 2021 14:29:58 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id h20sm5786416pfn.173.2021.09.10.14.29.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Sep 2021 14:29:58 -0700 (PDT)
Message-ID: <613bce56.1c69fb81.61b69.14ed@mx.google.com>
Date:   Fri, 10 Sep 2021 14:29:58 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.10.63-26-ge00e8baf3b90
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
Subject: stable-rc/queue/5.10 baseline: 184 runs,
 4 regressions (v5.10.63-26-ge00e8baf3b90)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 184 runs, 4 regressions (v5.10.63-26-ge00e8b=
af3b90)

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
nel/v5.10.63-26-ge00e8baf3b90/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.63-26-ge00e8baf3b90
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      e00e8baf3b9092e93de9c18338e6e41d2f46f5a2 =



Test Regressions
---------------- =



platform          | arch  | lab           | compiler | defconfig          |=
 regressions
------------------+-------+---------------+----------+--------------------+=
------------
hip07-d05         | arm64 | lab-collabora | gcc-8    | defconfig          |=
 1          =


  Details:     https://kernelci.org/test/plan/id/613b9e063466989f37d59687

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.63-=
26-ge00e8baf3b90/arm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.63-=
26-ge00e8baf3b90/arm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/613b9e063466989f37d59=
688
        failing since 71 days (last pass: v5.10.46-100-gce5b41f85637, first=
 fail: v5.10.46-100-g3b96099161c8b) =

 =



platform          | arch  | lab           | compiler | defconfig          |=
 regressions
------------------+-------+---------------+----------+--------------------+=
------------
rk3288-veyron-jaq | arm   | lab-collabora | gcc-8    | multi_v7_defconfig |=
 3          =


  Details:     https://kernelci.org/test/plan/id/613bb7a9d6a26968c1d59665

  Results:     67 PASS, 3 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.63-=
26-ge00e8baf3b90/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288=
-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.63-=
26-ge00e8baf3b90/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288=
-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/613bb7a9d6a26968c1d59679
        failing since 87 days (last pass: v5.10.43-44-g253317604975, first =
fail: v5.10.43-130-g87b5f83f722c)

    2021-09-10T20:14:06.636970  /lava-4493500/1/../bin/lava-test-case
    2021-09-10T20:14:06.653659  <8>[   13.623964] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/613bb7a9d6a26968c1d59691
        failing since 87 days (last pass: v5.10.43-44-g253317604975, first =
fail: v5.10.43-130-g87b5f83f722c)

    2021-09-10T20:14:05.210165  /lava-4493500/1/../bin/lava-test-case
    2021-09-10T20:14:05.227593  <8>[   12.197077] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>
    2021-09-10T20:14:05.227849  /lava-4493500/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/613bb7a9d6a26968c1d59692
        failing since 87 days (last pass: v5.10.43-44-g253317604975, first =
fail: v5.10.43-130-g87b5f83f722c)

    2021-09-10T20:14:04.190079  /lava-4493500/1/../bin/lava-test-case
    2021-09-10T20:14:04.195992  <8>[   11.177465] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =

 =20
