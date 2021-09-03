Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F3C34006FD
	for <lists+stable@lfdr.de>; Fri,  3 Sep 2021 22:46:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351039AbhICUrO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Sep 2021 16:47:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351042AbhICUrL (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Sep 2021 16:47:11 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9BE7C0617AD
        for <stable@vger.kernel.org>; Fri,  3 Sep 2021 13:46:06 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id t1so248714pgv.3
        for <stable@vger.kernel.org>; Fri, 03 Sep 2021 13:46:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=aSWSo2A/JHJ6w5KkEblMqo/4WWOV2x9pzLGZz00WvIU=;
        b=Y97r+Hmf4XHJQC5XbpTrLCj84MwMtnfdGY9SdPs0gV4fW7kXrtgihkqREH65m1cieZ
         fM5rH16PZxgxsEa7wCRzJ895+pHimD/4Lww/ra0cL4x/O2uxQ6NXkUBhaurxso+VxmDF
         MsbI5s41zEK/TSLe7LkTSDTGQN6cLsjkYgwNjQOKsSr/aKSrX57KhsmUwK4XSpINMSfN
         VOfFYuwOydU4wyqRF1CulctBrY1c5i3VPRDOgpxO0xy/c+GGq4wvfUmjEPpbMiZFOzWE
         EQ577FegjZrgtthLmxbx4Vi53FVylm0pZfKSr3CREpD5l9J2MPatw0WrZzWMsHvgnZWK
         +qPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=aSWSo2A/JHJ6w5KkEblMqo/4WWOV2x9pzLGZz00WvIU=;
        b=cuZuEeQTnqaweTMkArEzCTcsw6g6F0N36AQ6QYYNISNneSsQUg4p8DAosqk+mOfwTQ
         kUTc679OJbustjxiWMKs5kGwgJtcpYzsixN+evc6qUJaelUJKi2DG01M5e6NWPnjpY25
         VUjxABhllgkyO0KkyT3EHov2JqQ2mWGYAtsVJhy0rNAEf9zCVDEQSozL9g9YNNLqMvgl
         8qQYdXb6Ynp3ZCWP2J3iaf6wfwokuwuUjQ7eCJC8mLuAuexYzvSltLCp/M5SQOAg1Jse
         0rv8eqHy8Dj2D4E9wrFN5n4k5Shhg8st1eG5kpK2RvOGpym+0rOmuA45r1iZev5pet5G
         erXA==
X-Gm-Message-State: AOAM531o0mZ8NB95NTckjW9KAYB2LbSPWBUgsMvFjZLUdP07KkqVX6N6
        sqAHpYGy1KW45Oxm3GhqldreDq3Bch9xaAF3
X-Google-Smtp-Source: ABdhPJwKF+kjux2ZRn5VAB8+K9mHgTWZMGj6wG3TppwRWKT3sChVe3jNet9pOIBDamR0J+JVJwF97g==
X-Received: by 2002:aa7:9693:0:b0:412:448c:89c6 with SMTP id f19-20020aa79693000000b00412448c89c6mr728232pfk.82.1630701966062;
        Fri, 03 Sep 2021 13:46:06 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id t3sm244921pgo.51.2021.09.03.13.46.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Sep 2021 13:46:05 -0700 (PDT)
Message-ID: <6132898d.1c69fb81.2fa2f.1446@mx.google.com>
Date:   Fri, 03 Sep 2021 13:46:05 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.14.246-1-gb4cadb6113c3
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.14
Subject: stable-rc/queue/4.14 baseline: 136 runs,
 4 regressions (v4.14.246-1-gb4cadb6113c3)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 136 runs, 4 regressions (v4.14.246-1-gb4cadb=
6113c3)

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
nel/v4.14.246-1-gb4cadb6113c3/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.246-1-gb4cadb6113c3
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      b4cadb6113c3a602a373ce954424e4e03eeccf05 =



Test Regressions
---------------- =



platform          | arch  | lab           | compiler | defconfig          |=
 regressions
------------------+-------+---------------+----------+--------------------+=
------------
meson-gxm-q200    | arm64 | lab-baylibre  | gcc-8    | defconfig          |=
 1          =


  Details:     https://kernelci.org/test/plan/id/61325fb6150183348fd59687

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.246=
-1-gb4cadb6113c3/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q200=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.246=
-1-gb4cadb6113c3/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q200=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61325fb6150183348fd59=
688
        failing since 186 days (last pass: v4.14.222-11-g13b8482a0f700, fir=
st fail: v4.14.222-120-gdc8887cba23e) =

 =



platform          | arch  | lab           | compiler | defconfig          |=
 regressions
------------------+-------+---------------+----------+--------------------+=
------------
rk3288-veyron-jaq | arm   | lab-collabora | gcc-8    | multi_v7_defconfig |=
 3          =


  Details:     https://kernelci.org/test/plan/id/613265b69adbca1621d59671

  Results:     63 PASS, 6 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.246=
-1-gb4cadb6113c3/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288=
-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.246=
-1-gb4cadb6113c3/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288=
-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/613265b79adbca1621d5969d
        failing since 80 days (last pass: v4.14.236-20-gdb14655bb4bf, first=
 fail: v4.14.236-49-gfd4c319f2583) =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/613265b79adbca1621d5969e
        failing since 80 days (last pass: v4.14.236-20-gdb14655bb4bf, first=
 fail: v4.14.236-49-gfd4c319f2583)

    2021-09-03T18:12:44.531791  /lava-4445389/1/../bin/lava-test-case
    2021-09-03T18:12:44.537568  [   13.835618] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =


  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/613265b79adbca1621d596b5
        failing since 80 days (last pass: v4.14.236-20-gdb14655bb4bf, first=
 fail: v4.14.236-49-gfd4c319f2583)

    2021-09-03T18:12:47.982581  /lava-4445389/1/../bin/lava-test-case
    2021-09-03T18:12:47.999166  [   17.285556] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>
    2021-09-03T18:12:47.999446  /lava-4445389/1/../bin/lava-test-case   =

 =20
