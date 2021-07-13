Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0F663C6900
	for <lists+stable@lfdr.de>; Tue, 13 Jul 2021 06:03:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229448AbhGMEGD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Jul 2021 00:06:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbhGMEGD (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Jul 2021 00:06:03 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 248AEC0613DD
        for <stable@vger.kernel.org>; Mon, 12 Jul 2021 21:03:11 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id k20so13466901pgg.7
        for <stable@vger.kernel.org>; Mon, 12 Jul 2021 21:03:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=5lW5Wt6T3aCF0NsdY9ZDwNNok/Yv/TdfMu+2znteFbw=;
        b=dwvwB29f1B/ak1IwbSUKb9la0rAJ4mvg6TMgRO6wiKYFP8vP4OpLe82aZXbFXLW5w3
         n/xxd9PLGN8sKAyBXMpg0Yq4WNNc36qpSooIgc/qkUsXsQz2YRgO+ilG23g/ZApdOQVZ
         OktUeUyMsI5R5W9chrQHCfMoO1aunmZ33SgBqG0VuEFa29h2QQvtIdtkcIBRsccG2ZD7
         ut5a3zNhUjtCsJsMQQQAVLVXMjINKAwyBVzSlYYlM1ByyZFmFJM8urt2j85qoBIF7E82
         bjGtnMt+0YXySVYWTj0fDcamT92OWB4VFAaydYZ01PXz1tj2Sk17CD0iSoNqQqDStX89
         Hqaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=5lW5Wt6T3aCF0NsdY9ZDwNNok/Yv/TdfMu+2znteFbw=;
        b=mgUoiHgawj2ucC9dsgYJGsM7rVRdMRkryMUE5YXXuuWRVf0PrnBxakF3H1fHgqjMLm
         70y4qU1m8EEYKR0/0i1zYgTdM2tDjcnFEg1oL/s1AK90xZ5RaP5b+VrV1MRxF2/J9V9Y
         As5Cdbwg+c9LKQ5ouG4mqnNlRJ0oPcrEqGtHrgDbj9YdO2Idcu0tvTQme27hy8OzVBGP
         Pml3StJhZYU87bUIq97PbBPIOOW3AK5MjWOyvYIreSVuhtCztIxA70XUBXqRJ6zH1+rZ
         8DCEVB3ib2wKBDazjcjl9MT85/1B7lNlJ0FvzXHb9HtQ4l+tFMXW/hjcahuvTF3gewLr
         Ac9A==
X-Gm-Message-State: AOAM530aO8n171xlasKz44hfg65SDViwl6Q3BxQre0lLqszxz1ESviyb
        uqhg43fEBvdBrOLoO0xKaBiifQ0AbQQNDYmE
X-Google-Smtp-Source: ABdhPJwB6pY8xfIpFJ0Jx00qN3Xu8IPGk92FbhuSs6AsEr/CCEvTrpgQkYWHTaCJyD9VKlovHaEqwQ==
X-Received: by 2002:a63:5345:: with SMTP id t5mr2387822pgl.167.1626148990373;
        Mon, 12 Jul 2021 21:03:10 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 10sm17909554pfh.174.2021.07.12.21.03.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jul 2021 21:03:10 -0700 (PDT)
Message-ID: <60ed107e.1c69fb81.becd.6547@mx.google.com>
Date:   Mon, 12 Jul 2021 21:03:10 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.239-159-g3434dfcb53058
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.14
Subject: stable-rc/queue/4.14 baseline: 152 runs,
 4 regressions (v4.14.239-159-g3434dfcb53058)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 152 runs, 4 regressions (v4.14.239-159-g3434=
dfcb53058)

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
nel/v4.14.239-159-g3434dfcb53058/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.239-159-g3434dfcb53058
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      3434dfcb530587790c52495b0722b3b3666119ce =



Test Regressions
---------------- =



platform          | arch  | lab           | compiler | defconfig          |=
 regressions
------------------+-------+---------------+----------+--------------------+=
------------
meson-gxm-q200    | arm64 | lab-baylibre  | gcc-8    | defconfig          |=
 1          =


  Details:     https://kernelci.org/test/plan/id/60ecd95e7bf36595551179c2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.239=
-159-g3434dfcb53058/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q=
200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.239=
-159-g3434dfcb53058/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q=
200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ecd95e7bf3659555117=
9c3
        failing since 133 days (last pass: v4.14.222-11-g13b8482a0f700, fir=
st fail: v4.14.222-120-gdc8887cba23e) =

 =



platform          | arch  | lab           | compiler | defconfig          |=
 regressions
------------------+-------+---------------+----------+--------------------+=
------------
rk3288-veyron-jaq | arm   | lab-collabora | gcc-8    | multi_v7_defconfig |=
 3          =


  Details:     https://kernelci.org/test/plan/id/60ed0a749a22113988117979

  Results:     63 PASS, 6 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.239=
-159-g3434dfcb53058/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3=
288-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.239=
-159-g3434dfcb53058/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3=
288-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/60ed0a749a22113988117991
        failing since 27 days (last pass: v4.14.236-20-gdb14655bb4bf, first=
 fail: v4.14.236-49-gfd4c319f2583)

    2021-07-13T03:37:13.509318  /lava-4187767/1/../bin/lava-test-case
    2021-07-13T03:37:13.526300  [   16.500229] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>
    2021-07-13T03:37:13.526817  /lava-4187767/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/60ed0a749a221139881179aa
        failing since 27 days (last pass: v4.14.236-20-gdb14655bb4bf, first=
 fail: v4.14.236-49-gfd4c319f2583)

    2021-07-13T03:37:11.077299  /lava-4187767/1/../bin/lava-test-case
    2021-07-13T03:37:11.094205  [   14.067950] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/60ed0a749a221139881179ab
        failing since 27 days (last pass: v4.14.236-20-gdb14655bb4bf, first=
 fail: v4.14.236-49-gfd4c319f2583)

    2021-07-13T03:37:10.058334  /lava-4187767/1/../bin/lava-test-case
    2021-07-13T03:37:10.063595  [   13.049171] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =

 =20
