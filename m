Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59E0B3E8736
	for <lists+stable@lfdr.de>; Wed, 11 Aug 2021 02:25:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235692AbhHKAZZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 20:25:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235680AbhHKAZZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Aug 2021 20:25:25 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6EB1C061765
        for <stable@vger.kernel.org>; Tue, 10 Aug 2021 17:25:02 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id bo18so760824pjb.0
        for <stable@vger.kernel.org>; Tue, 10 Aug 2021 17:25:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=E+QrxtvNLA1dtZzrlZo8EIVtz9+D1qHkez+FByNWpNQ=;
        b=WjSS7yPvRSI98ktomG+1Q+/j4phNH139lCvP2g2n/rPXhcsY0i6XCeFIAFDraCyPy3
         yiIQnqKGVAwdRLPkCt2fUA0jo0cx/tp9NCrha6wGx+P70+xsbyoI2IeluAcyTaZLbLSq
         efVtpHkc25Hxjp93ELJVod/rVui+jIB9YTnjpzwCVey1w7bmuJbuXmc/TTWjIxf5YfW+
         JjZfPYcO39oJj9bUgnMGaIk7h7HUz236kXlotTEkUqOiuRCuga/2beIRoph5pcoOpYlg
         u5jH09vxGsCOfaOaHVrK3aMJ/kH8aSc/DZk7VlIhpTL6b41TOPqga71BWRlYaVyhdZ7Z
         5Stw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=E+QrxtvNLA1dtZzrlZo8EIVtz9+D1qHkez+FByNWpNQ=;
        b=Lk1g4a6VseAb1HyFk2FrhXa7aTz7veaveyxCNZe1i4//fdCoTKsmrEXasc4BVfj9bi
         TiRkDVmEhoP2Pq6rETzVOJ3nOQS8FMtf2+qOMDEsLSaT+v9QJ/xi6DNcQwvxIZLX1F1Q
         iCM5zvHoqw95N0ZclZnbrucwF3rxJFi8fnNHfQ9glTFfSn1kRyQsPi9oUUV/JBwGrdP1
         anH0GBPdNKlmh1rrn8n3T1Xs7ZnqJxlfemsv7uYQvhpi6VpqJmmpAwlHsQ3vrTVxx210
         3UXbbJ0QxeMVlzNdTAG1DHbtyftVZSjzqF71M7nyWjiiofgM6/Xa6b8MbRskfSRg5W5y
         IzUA==
X-Gm-Message-State: AOAM532uWmBAVzxt+k7hLsgVCGKy1P2EWjGRqJ+tBBdzIUaP930LGanU
        0ze2N67xDy/r53H++CEuonDeWdq9igUSAMgy
X-Google-Smtp-Source: ABdhPJxBEhsoOoHlVr4n4ZMnr+pqyr01jNxqYsBL8Yr2nLs19hERsgL4Pk/mUN1wbXSIpOo8BT3Ihw==
X-Received: by 2002:a17:902:70c3:b029:12c:475a:96ff with SMTP id l3-20020a17090270c3b029012c475a96ffmr27389730plt.1.1628641501868;
        Tue, 10 Aug 2021 17:25:01 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id m11sm4324535pjn.2.2021.08.10.17.25.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Aug 2021 17:25:01 -0700 (PDT)
Message-ID: <611318dd.1c69fb81.b5d5c.e1b9@mx.google.com>
Date:   Tue, 10 Aug 2021 17:25:01 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.4
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.4.139-85-gd1a62f9876ac
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.4 baseline: 151 runs,
 3 regressions (v5.4.139-85-gd1a62f9876ac)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 151 runs, 3 regressions (v5.4.139-85-gd1a62f9=
876ac)

Regressions Summary
-------------------

platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
rk3288-veyron-jaq | arm  | lab-collabora | gcc-8    | multi_v7_defconfig | =
3          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.139-85-gd1a62f9876ac/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.139-85-gd1a62f9876ac
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      d1a62f9876ac04aef247f0f99e5afb1040e90f5d =



Test Regressions
---------------- =



platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
rk3288-veyron-jaq | arm  | lab-collabora | gcc-8    | multi_v7_defconfig | =
3          =


  Details:     https://kernelci.org/test/plan/id/6112e31110f396bbfab13674

  Results:     67 PASS, 3 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.139-8=
5-gd1a62f9876ac/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-=
veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.139-8=
5-gd1a62f9876ac/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-=
veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/6112e31110f396bbfab1368c
        failing since 56 days (last pass: v5.4.125-37-g7cda316475cf, first =
fail: v5.4.125-84-g411d62eda127)

    2021-08-10T20:35:08.035201  /lava-4344289/1/../bin/lava-test-case
    2021-08-10T20:35:08.052415  <8>[   14.978004] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>
    2021-08-10T20:35:08.052716  /lava-4344289/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/6112e31110f396bbfab136a4
        failing since 56 days (last pass: v5.4.125-37-g7cda316475cf, first =
fail: v5.4.125-84-g411d62eda127)

    2021-08-10T20:35:06.610360  /lava-4344289/1/../bin/lava-test-case
    2021-08-10T20:35:06.627236  <8>[   13.553018] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/6112e31110f396bbfab136a5
        failing since 56 days (last pass: v5.4.125-37-g7cda316475cf, first =
fail: v5.4.125-84-g411d62eda127)

    2021-08-10T20:35:05.582139  /lava-4344289/1/../bin/lava-test-case
    2021-08-10T20:35:05.592354  <8>[   12.533458] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =

 =20
