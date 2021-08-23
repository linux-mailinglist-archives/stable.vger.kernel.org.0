Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4D2F3F518E
	for <lists+stable@lfdr.de>; Mon, 23 Aug 2021 21:50:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231716AbhHWTvT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Aug 2021 15:51:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230187AbhHWTvT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 Aug 2021 15:51:19 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E85DC061575
        for <stable@vger.kernel.org>; Mon, 23 Aug 2021 12:50:36 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id j1so12671372pjv.3
        for <stable@vger.kernel.org>; Mon, 23 Aug 2021 12:50:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=cNsh0LLIEVXN9DDjm/iLvbZIOib+73GczOhcDqyGJTA=;
        b=ysmN9wBlLKTQWTcOVXZn0QqsZplX7XBfoxvQ55hMUX3L+XVWYWAoncRbibQQ0THVUs
         0SzIeePbokHKSM3p0pHFMG6ephd1F/G9vndAo/e8n1WTM5//AjYbyg0kuBVLPbWruMEv
         G2EoFX4AO9tpZVzJH/NGkc9glja90cIriINQASTtxfpGFrpRSVZre7a9zWF0n/Q1e16m
         dHsPaKw2/GUvcN5SY76V5z8lwirjGXRTWReJJ5xKYif8nKOBBXn23pHXPAQdSD0ro2E6
         bl14rjd5TnuZSolj58t4imdQghgH9b69SwfJuTbEhKDJPW1f/Qeho3ikoy54pK66QDPN
         tdBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=cNsh0LLIEVXN9DDjm/iLvbZIOib+73GczOhcDqyGJTA=;
        b=L2u/EBsiXUDvWroQf3V0bpOcecljGmy+/3/DOSDSmAP6rspIXAUnWvYIiPbXXRcm/N
         iMzh/gDBMaC+9dmr74b+9O4UssnuobHr52FPKbqEcHRGRdB/PsDm0YJMsTnJhjxIXsk6
         dPMfKKPlFn8KhPwD7d5MZEOVYgnm/04nPrqM0s+DRB++k1Pa3kKujEhoyqxeMXh8HLCH
         x2U1t7EgXGt79cIgra47A6gEVt3PpBo3HEFBBz/zIxLhvRMKdagz6LD+6Hw4ZfWt63E7
         Nj+fzcmVnneVTKeyomnfK9/17E1cGJf4wUKGxIksy6UyWj8NgO6CzD1isoS1Rj+aWXqh
         hUUA==
X-Gm-Message-State: AOAM533ecDoecVwiruvZ7BAKrOoJnnasNyYWxxC2M1rDz9EfiXI/yvNf
        TvN9TSLCfxlUzpcWhmnwwaF1idV4gbQpzsk4
X-Google-Smtp-Source: ABdhPJwYUnYJfhTo32lZ3CeKrI7F4MWwYsUj/ngbzD6gtxmvZN3pJ+kIsOnDA50fw19jSFY9crbHAQ==
X-Received: by 2002:a17:902:b40b:b029:12b:997f:5677 with SMTP id x11-20020a170902b40bb029012b997f5677mr30071084plr.11.1629748235630;
        Mon, 23 Aug 2021 12:50:35 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id s32sm17341374pfw.84.2021.08.23.12.50.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Aug 2021 12:50:35 -0700 (PDT)
Message-ID: <6123fc0b.1c69fb81.4c2d.28df@mx.google.com>
Date:   Mon, 23 Aug 2021 12:50:35 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.4
X-Kernelci-Kernel: v5.4.142-45-g9addf567ed83
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.4 baseline: 204 runs,
 3 regressions (v5.4.142-45-g9addf567ed83)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 204 runs, 3 regressions (v5.4.142-45-g9addf56=
7ed83)

Regressions Summary
-------------------

platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
rk3288-veyron-jaq | arm  | lab-collabora | gcc-8    | multi_v7_defconfig | =
3          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.142-45-g9addf567ed83/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.142-45-g9addf567ed83
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      9addf567ed83dfd137546fcce2125ded6e2c647a =



Test Regressions
---------------- =



platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
rk3288-veyron-jaq | arm  | lab-collabora | gcc-8    | multi_v7_defconfig | =
3          =


  Details:     https://kernelci.org/test/plan/id/6123decead2bd850a88e2c95

  Results:     67 PASS, 3 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.142-4=
5-g9addf567ed83/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-=
veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.142-4=
5-g9addf567ed83/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-=
veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/6123decead2bd850a88e2ca9
        failing since 69 days (last pass: v5.4.125-37-g7cda316475cf, first =
fail: v5.4.125-84-g411d62eda127)

    2021-08-23T17:45:38.111372  /lava-4400041/1/../bin/lava-test-case<8>[  =
 15.028051] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Drockchip-iodomain-grf-prob=
ed RESULT=3Dfail>
    2021-08-23T17:45:38.111713     =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/6123decead2bd850a88e2cc1
        failing since 69 days (last pass: v5.4.125-37-g7cda316475cf, first =
fail: v5.4.125-84-g411d62eda127)

    2021-08-23T17:45:36.681878  /lava-4400041/1/../bin/lava-test-case
    2021-08-23T17:45:36.687073  <8>[   13.603605] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/6123decead2bd850a88e2cc2
        failing since 69 days (last pass: v5.4.125-37-g7cda316475cf, first =
fail: v5.4.125-84-g411d62eda127)

    2021-08-23T17:45:35.661704  /lava-4400041/1/../bin/lava-test-case
    2021-08-23T17:45:35.666888  <8>[   12.584091] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =

 =20
