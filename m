Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06A2B3C3F7A
	for <lists+stable@lfdr.de>; Sun, 11 Jul 2021 23:20:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229951AbhGKVXY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 11 Jul 2021 17:23:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229544AbhGKVXY (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 11 Jul 2021 17:23:24 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A24C6C0613E5
        for <stable@vger.kernel.org>; Sun, 11 Jul 2021 14:20:37 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id s18so768858pgq.3
        for <stable@vger.kernel.org>; Sun, 11 Jul 2021 14:20:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=sa5IVuZd/mRLex0iiu640VoFTOJcuiBIWLhtClwWg5Y=;
        b=ORZAgFQsiOoGjog4uSr5+ANhIL+9iOyppmWgvCYXiK3dZYbLgKkWjGxVkRIrrFv1SS
         BcsS7uxv6S5HTuqn6+qn4SmeyAmJXN6tsNIozK6LUUE8wNYc77Fd1ToVYDb4Tha8/ht8
         z8i0h1in8l6KHYOtAPKkeDJYC1OYjgpJF0BIvyk+HN8JPyuIiZbpraWEmujN90RpN8Fx
         Qk2wsF4DyOemZt0OXdnTdI3xdWFbW3dcA+jf3b5b4R0uMlj0u3vfrJ4Ln7J4noqwImWJ
         pmlgHJ3PSWXdU4MOFpH9LVY+YiBdxj3pPDCCYLi8sTx5J6j/bw4Ap1/Q94l5EINW+tXn
         2muw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=sa5IVuZd/mRLex0iiu640VoFTOJcuiBIWLhtClwWg5Y=;
        b=GnxOMyoedsttCf+nayCSkxlHOaorS546Ap6xSwS2pJadjGh4cpL/s31f8GBdhsUBjA
         ZtNLzV5Wg9pWSBEwxLYl/YOD4ni01EeNpUa6WLzEINYvQ/DPCvCa4iGsDfnIX41qQrOR
         9B92BEmEWcUapKA6sTKrqvbuHfoHFkmyR1AWjR98b1h5ZlF0NlZTUJw5nnlnJqPTmWOv
         +JYyom36lhsISfDeyNzrU7L6KiX3vySBQjBnQ3QsOApykJS/0ALD8gDInF4nBHiNr+/c
         dVaiTVDZ6tMBqd1iC/yrrRjG7x6nqvhZrbw0HgqwKvNmdrWzPMMxLEXEF8ISGbaRqK7w
         L8MQ==
X-Gm-Message-State: AOAM530K/NLhJaoNybor3G6oaxkz0Kbe4h4/2Kc/WrTqZVmiUW1YlC2Y
        Xr5APGE5gWQkyc6cDTbL7eZvpO3x/mUZFomh
X-Google-Smtp-Source: ABdhPJwrLlTZrttst6pYvZENfW/fIHkz8tlD7iLTGIZXC9XlF+FYpUp5A8OdDfPu7qIiWBzWKbZvCQ==
X-Received: by 2002:a05:6a00:2494:b029:31e:2c3f:4186 with SMTP id c20-20020a056a002494b029031e2c3f4186mr41132855pfv.25.1626038436985;
        Sun, 11 Jul 2021 14:20:36 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id q21sm6030265pff.55.2021.07.11.14.20.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Jul 2021 14:20:36 -0700 (PDT)
Message-ID: <60eb60a4.1c69fb81.9ad65.1804@mx.google.com>
Date:   Sun, 11 Jul 2021 14:20:36 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.10.49-580-g8c6d681edabf
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
Subject: stable-rc/queue/5.10 baseline: 192 runs,
 7 regressions (v5.10.49-580-g8c6d681edabf)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 192 runs, 7 regressions (v5.10.49-580-g8c6d6=
81edabf)

Regressions Summary
-------------------

platform                | arch   | lab           | compiler | defconfig    =
                | regressions
------------------------+--------+---------------+----------+--------------=
----------------+------------
d2500cc                 | x86_64 | lab-clabbe    | gcc-8    | x86_64_defcon=
...6-chromebook | 1          =

d2500cc                 | x86_64 | lab-clabbe    | gcc-8    | x86_64_defcon=
fig             | 1          =

hip07-d05               | arm64  | lab-collabora | gcc-8    | defconfig    =
                | 1          =

rk3288-veyron-jaq       | arm    | lab-collabora | gcc-8    | multi_v7_defc=
onfig           | 3          =

sun50i-a64-bananapi-m64 | arm64  | lab-clabbe    | gcc-8    | defconfig    =
                | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.49-580-g8c6d681edabf/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.49-580-g8c6d681edabf
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      8c6d681edabf0819e54c77350800393582eb03b1 =



Test Regressions
---------------- =



platform                | arch   | lab           | compiler | defconfig    =
                | regressions
------------------------+--------+---------------+----------+--------------=
----------------+------------
d2500cc                 | x86_64 | lab-clabbe    | gcc-8    | x86_64_defcon=
...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/60eb36e98770155760117981

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.49-=
580-g8c6d681edabf/x86_64/x86_64_defconfig+x86-chromebook/gcc-8/lab-clabbe/b=
aseline-d2500cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.49-=
580-g8c6d681edabf/x86_64/x86_64_defconfig+x86-chromebook/gcc-8/lab-clabbe/b=
aseline-d2500cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60eb36e98770155760117=
982
        failing since 0 day (last pass: v5.10.48-6-gea5b7eca594d, first fai=
l: v5.10.49-580-g094fb99ca365) =

 =



platform                | arch   | lab           | compiler | defconfig    =
                | regressions
------------------------+--------+---------------+----------+--------------=
----------------+------------
d2500cc                 | x86_64 | lab-clabbe    | gcc-8    | x86_64_defcon=
fig             | 1          =


  Details:     https://kernelci.org/test/plan/id/60eb383daa22fc1edd117989

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.49-=
580-g8c6d681edabf/x86_64/x86_64_defconfig/gcc-8/lab-clabbe/baseline-d2500cc=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.49-=
580-g8c6d681edabf/x86_64/x86_64_defconfig/gcc-8/lab-clabbe/baseline-d2500cc=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60eb383daa22fc1edd117=
98a
        failing since 0 day (last pass: v5.10.48-6-gea5b7eca594d, first fai=
l: v5.10.49-580-g094fb99ca365) =

 =



platform                | arch   | lab           | compiler | defconfig    =
                | regressions
------------------------+--------+---------------+----------+--------------=
----------------+------------
hip07-d05               | arm64  | lab-collabora | gcc-8    | defconfig    =
                | 1          =


  Details:     https://kernelci.org/test/plan/id/60eb41d0bcdb82afdb1179d6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.49-=
580-g8c6d681edabf/arm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.49-=
580-g8c6d681edabf/arm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60eb41d0bcdb82afdb117=
9d7
        failing since 10 days (last pass: v5.10.46-100-gce5b41f85637, first=
 fail: v5.10.46-100-g3b96099161c8b) =

 =



platform                | arch   | lab           | compiler | defconfig    =
                | regressions
------------------------+--------+---------------+----------+--------------=
----------------+------------
rk3288-veyron-jaq       | arm    | lab-collabora | gcc-8    | multi_v7_defc=
onfig           | 3          =


  Details:     https://kernelci.org/test/plan/id/60eb58de2a8af10e5c11797a

  Results:     67 PASS, 3 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.49-=
580-g8c6d681edabf/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk328=
8-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.49-=
580-g8c6d681edabf/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk328=
8-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/60eb58de2a8af10e5c11798e
        failing since 26 days (last pass: v5.10.43-44-g253317604975, first =
fail: v5.10.43-130-g87b5f83f722c)

    2021-07-11T20:47:21.464367  /lava-4177734/1/../bin/lava-test-case
    2021-07-11T20:47:21.481604  <8>[   13.197890] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>
    2021-07-11T20:47:21.482059  /lava-4177734/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/60eb58de2a8af10e5c1179a1
        failing since 26 days (last pass: v5.10.43-44-g253317604975, first =
fail: v5.10.43-130-g87b5f83f722c)

    2021-07-11T20:47:20.042319  /lava-4177734/1/../bin/lava-test-case<8>[  =
 11.770965] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Ddwmmc_rockchip-sdio0-probe=
d RESULT=3Dfail>
    2021-07-11T20:47:20.042804     =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/60eb58de2a8af10e5c1179a2
        failing since 26 days (last pass: v5.10.43-44-g253317604975, first =
fail: v5.10.43-130-g87b5f83f722c)

    2021-07-11T20:47:19.019353  /lava-4177734/1/../bin/lava-test-case
    2021-07-11T20:47:19.019708  <8>[   10.751027] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =

 =



platform                | arch   | lab           | compiler | defconfig    =
                | regressions
------------------------+--------+---------------+----------+--------------=
----------------+------------
sun50i-a64-bananapi-m64 | arm64  | lab-clabbe    | gcc-8    | defconfig    =
                | 1          =


  Details:     https://kernelci.org/test/plan/id/60eb313444a5af48b4117995

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.49-=
580-g8c6d681edabf/arm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-bana=
napi-m64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.49-=
580-g8c6d681edabf/arm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-bana=
napi-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60eb313444a5af48b4117=
996
        new failure (last pass: v5.10.48-6-gce110db8e44b7) =

 =20
