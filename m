Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08A803F12F8
	for <lists+stable@lfdr.de>; Thu, 19 Aug 2021 07:55:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230111AbhHSF4Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Aug 2021 01:56:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229782AbhHSF4Y (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 Aug 2021 01:56:24 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72114C061756
        for <stable@vger.kernel.org>; Wed, 18 Aug 2021 22:55:48 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id k19so4481848pfc.11
        for <stable@vger.kernel.org>; Wed, 18 Aug 2021 22:55:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=GDi4DzJbLFaobKJl7gZYOg4DX4SA2nCk5DbV4mxSpnw=;
        b=mEHn7EeIwMsmEb8t4NYsQej3yzuR7jzYhQLVRNKT0m9fTGheHdfaC1D3DTl2ak0Pez
         4AXqo5L2LqcLCEV+tuJ37Gk1W/GEr+gtshjW4dp7cttGdWtrI76NqCkk2VtlT33KWh0n
         8LzG016n0QRKCQTJvYk6jHCpXRKUrr5b73qhkqfYb6UHgp6+sKgTH/0Wrajmx5ACrnaP
         mlburJqAf8/cpzifEbQq0OrZAdWgHB9W9a9AC9JtbQL069iLxgvtfi8b4NlZ1PKc4P5z
         RI4o/ToBy/F/x6s3j0ogRPVxg4mIG37jJZt/O/NVECzn2OUK0JU0AWOX5lqVKqk9IEGj
         qbWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=GDi4DzJbLFaobKJl7gZYOg4DX4SA2nCk5DbV4mxSpnw=;
        b=shTDSdWp0FicL4QMCMe03fwkT1GM0UsepYtye0F71wlHKEX64PPIVsYhTaX1r3lDat
         +BPVpVaXWk6AVDD8gMRxJK0jofnd9W5QkTErCNGzqiePoJa/I3IZ4Z9vZAw46KhzMUeA
         XE957fWYTFN3pXkbt5TC9MWg45Ko+Dsb1Lw4l5C8ucFQ7XNr1AV+AmLfdfYFKgKczHcq
         Jmz3RxmMfdGXp5Ii9XsVNwBLW/1uePxtHkq6w66aq7Jt9512PR4KigGVkZFrjJ3sDiB5
         4jYup+p4RcT6xn9lW3/hRJNIYc/RgZ7VBfTaohUJ1Rq/Qbgs+9XA2pkDsqPJowNWGW2d
         S6yw==
X-Gm-Message-State: AOAM533h0fA6BgncKiPhcs6KENjSjtvWilyyq31sCvV2HC820s2JESva
        xvJVLK+7GnNtbIkKZfO8mZbyv6DZb2V891Y1
X-Google-Smtp-Source: ABdhPJwdo3En2sYXUavzTdLl+VdEa/1U3iJneJ6mUH/B7KsN1CCVMG80D1ToJppKMtq4vrZY6vyXqQ==
X-Received: by 2002:a62:1e83:0:b029:3c8:ac32:3b41 with SMTP id e125-20020a621e830000b02903c8ac323b41mr13344267pfe.0.1629352547838;
        Wed, 18 Aug 2021 22:55:47 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 11sm1745225pfp.155.2021.08.18.22.55.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Aug 2021 22:55:47 -0700 (PDT)
Message-ID: <611df263.1c69fb81.2630b.70cc@mx.google.com>
Date:   Wed, 18 Aug 2021 22:55:47 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.4
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.4.142-13-g0e72e05908b0
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.4 baseline: 140 runs,
 3 regressions (v5.4.142-13-g0e72e05908b0)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 140 runs, 3 regressions (v5.4.142-13-g0e72e05=
908b0)

Regressions Summary
-------------------

platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
rk3288-veyron-jaq | arm  | lab-collabora | gcc-8    | multi_v7_defconfig | =
3          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.142-13-g0e72e05908b0/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.142-13-g0e72e05908b0
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      0e72e05908b039c20cd4fa73387bf18bb6a42fe3 =



Test Regressions
---------------- =



platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
rk3288-veyron-jaq | arm  | lab-collabora | gcc-8    | multi_v7_defconfig | =
3          =


  Details:     https://kernelci.org/test/plan/id/611dc3b07cd2f8f1ebb13670

  Results:     67 PASS, 3 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.142-1=
3-g0e72e05908b0/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-=
veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.142-1=
3-g0e72e05908b0/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-=
veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/611dc3b07cd2f8f1ebb13688
        failing since 65 days (last pass: v5.4.125-37-g7cda316475cf, first =
fail: v5.4.125-84-g411d62eda127)

    2021-08-19T02:36:22.703905  /lava-4382247/1/../bin/lava-test-case<8>[  =
 14.971112] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Drockchip-iodomain-grf-prob=
ed RESULT=3Dfail>
    2021-08-19T02:36:22.704443  =

    2021-08-19T02:36:22.704809  /lava-4382247/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/611dc3b07cd2f8f1ebb136a0
        failing since 65 days (last pass: v5.4.125-37-g7cda316475cf, first =
fail: v5.4.125-84-g411d62eda127)

    2021-08-19T02:36:21.260670  /lava-4382247/1/../bin/lava-test-case
    2021-08-19T02:36:21.278738  <8>[   13.545431] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/611dc3b07cd2f8f1ebb136a1
        failing since 65 days (last pass: v5.4.125-37-g7cda316475cf, first =
fail: v5.4.125-84-g411d62eda127)

    2021-08-19T02:36:20.241977  /lava-4382247/1/../bin/lava-test-case
    2021-08-19T02:36:20.247174  <8>[   12.525843] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =

 =20
