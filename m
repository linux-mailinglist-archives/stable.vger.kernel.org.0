Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 864FB3F2068
	for <lists+stable@lfdr.de>; Thu, 19 Aug 2021 21:13:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230058AbhHSTN4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Aug 2021 15:13:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231500AbhHSTNw (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 Aug 2021 15:13:52 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D38D8C061575
        for <stable@vger.kernel.org>; Thu, 19 Aug 2021 12:13:14 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id u13-20020a17090abb0db0290177e1d9b3f7so12077737pjr.1
        for <stable@vger.kernel.org>; Thu, 19 Aug 2021 12:13:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=JQB4GkQ7CbMJVtncA9CesuFpjndh132F9/0RawNxXrA=;
        b=qJQp4lFnF08YGEscfN4BW95J/o89JUae2HN+p9+IFaBZ5twjKYMs1pashrH0wFjZhd
         cj/p0z1YqDpYQW5T3Y2r2WyeQDhPMNzE1+SHQE0eSQVkxBCZIvlcPS2ttwK3toxhyatr
         /YfEDCC4N6LcNaGf+20ynDewEEqWk56wyqRPRq/KGAC1RgiVLJVBIyAO92VvAuelXt5I
         IqCXcsM8WGGD1YFKFoEiPNNYspQI5RJXKlPLXcZgD4WBzLQjb4SudAgalbFzkjp4MKzP
         VC3asejO3MW/j8lzcq7SFBFC7hohGVt+2b7UoDQ+C5qrOtUEeRHJ9ZaxLRmqQBtDHMSl
         4+nA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=JQB4GkQ7CbMJVtncA9CesuFpjndh132F9/0RawNxXrA=;
        b=E+P5Y2GXq3jyxA3hFpx8qSryM77d7cp39p5BCep/xUvea7l/oQ9EWv4zaWM4rPtBuC
         L3XuOXQgfu7DbY91az4h8TKh8TKyInRqbb3yDgPdtt/REaiyM0gqN1SJL1h2LonEF8ti
         alBnrYxXXPYjvUNbBAne/n3O4/MTLdkhITrrGrDcPCfRC+wV5pF7YpnZloLM6B5+JPNK
         Jj/wRO0dE8U5WZ2sWx194st8G6FQ1UQ2r61qQhTEBbGH2Eg5gNfZv7M09tLOgTjErOkT
         TRQStWEoQVm2PVOR1MkE4YwRUlOkIwYW6IrcnpiYsWWr1KAcigS1LhLWKWXlQr/MrEuY
         vskw==
X-Gm-Message-State: AOAM530bn3wgotP8XmVJoF7rczM4p4g6EKpV1AGgWz76nyzG8+2LvdDL
        UUmG6O7g/ZLw7WRk+WhdTiWKX4bhQU03T6k9
X-Google-Smtp-Source: ABdhPJyevIamMIzk4Vjv+uPjA3r7J2RFuqIIkeU6V14co3kzesZy4f3jC5ecPeEH68A717VGrmpGzg==
X-Received: by 2002:a17:90a:d587:: with SMTP id v7mr290773pju.110.1629400394256;
        Thu, 19 Aug 2021 12:13:14 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id hd21sm9178241pjb.7.2021.08.19.12.13.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Aug 2021 12:13:14 -0700 (PDT)
Message-ID: <611ead4a.1c69fb81.c0580.af3c@mx.google.com>
Date:   Thu, 19 Aug 2021 12:13:14 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.4
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.4.142-24-g3dfdd3447e77
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.4 baseline: 173 runs,
 3 regressions (v5.4.142-24-g3dfdd3447e77)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 173 runs, 3 regressions (v5.4.142-24-g3dfdd34=
47e77)

Regressions Summary
-------------------

platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
rk3288-veyron-jaq | arm  | lab-collabora | gcc-8    | multi_v7_defconfig | =
3          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.142-24-g3dfdd3447e77/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.142-24-g3dfdd3447e77
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      3dfdd3447e77d36cf63f3a17c4fbb216998b4f13 =



Test Regressions
---------------- =



platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
rk3288-veyron-jaq | arm  | lab-collabora | gcc-8    | multi_v7_defconfig | =
3          =


  Details:     https://kernelci.org/test/plan/id/611e7b8c20ba6f75fdb136da

  Results:     67 PASS, 3 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.142-2=
4-g3dfdd3447e77/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-=
veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.142-2=
4-g3dfdd3447e77/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-=
veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/611e7b8c20ba6f75fdb136f2
        failing since 65 days (last pass: v5.4.125-37-g7cda316475cf, first =
fail: v5.4.125-84-g411d62eda127)

    2021-08-19T15:40:51.377719  /lava-4386880/1/../bin/lava-test-case<8>[  =
 15.586992] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Drockchip-iodomain-grf-prob=
ed RESULT=3Dfail>
    2021-08-19T15:40:51.378085  =

    2021-08-19T15:40:51.378286  /lava-4386880/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/611e7b8c20ba6f75fdb1370a
        failing since 65 days (last pass: v5.4.125-37-g7cda316475cf, first =
fail: v5.4.125-84-g411d62eda127)

    2021-08-19T15:40:49.936363  /lava-4386880/1/../bin/lava-test-case
    2021-08-19T15:40:49.953666  <8>[   14.162227] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>
    2021-08-19T15:40:49.954067  /lava-4386880/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/611e7b8c20ba6f75fdb1370b
        failing since 65 days (last pass: v5.4.125-37-g7cda316475cf, first =
fail: v5.4.125-84-g411d62eda127)

    2021-08-19T15:40:48.922475  /lava-4386880/1/../bin/lava-test-case<8>[  =
 13.142846] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Ddwmmc_rockchip-sdmmc-probe=
d RESULT=3Dfail>
    2021-08-19T15:40:48.922881     =

 =20
