Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12FB3506C9A
	for <lists+stable@lfdr.de>; Tue, 19 Apr 2022 14:39:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350190AbiDSMmI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Apr 2022 08:42:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232267AbiDSMmI (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Apr 2022 08:42:08 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC26E3615C
        for <stable@vger.kernel.org>; Tue, 19 Apr 2022 05:39:25 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id 203so4449694pgb.3
        for <stable@vger.kernel.org>; Tue, 19 Apr 2022 05:39:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=36xITEEPCohanyCcVUD+yviBCFtZRkKHajU/jUvk3Sw=;
        b=z/pLmCfWOkiV2PSH7SlifImeSYwHvAH5Hvox1HdOHt91zsdJiRGyEnP+Uj7gdlEhzs
         HFXG/lxpriHvMrwwuDuSIKo30ujMxkuDkT2wSZYyEfc4jp1TXVhylne8HJvi4yOV7Tk5
         paa8vUQRNShce7E/PcU4kWZaxK4reqAlSzuNSGFcNbjbO//EOBvY3naFoh3EvbC8SmrO
         o2egcLMFeaomMuzyjPiLzxCdJFCh7XkJtvWwfHDGnCVdYCKl2InGcGbo7Ie9ArsP0XDN
         sP4qrZ9CgiQ3ac9qc87UE1SU7YlfhlIDyH3oy04EKJbJ3dgAuuDsubPgRUNcqtMEJCQ8
         JTAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=36xITEEPCohanyCcVUD+yviBCFtZRkKHajU/jUvk3Sw=;
        b=HSqvakwogohOREtD8fy7Bxgfu35xwRqQg+ucSFInbfEtm43rbM4yKV2fz0djRW+rez
         igSHruF5IRYnN4+zlVIYAsv6UKOYGA29iizv/Uez8zi93WqPEsgATza2qHBAoDQIQq1Y
         OPAr98gBfX6aqPnKOYdoqwGOT1ezx0qE4eogYgBaX0GsRUg3nFztrqOPMXC9EbwruSIn
         vZ2qw88etfULjqSGRXFDkoMt3Ucus3ZhdZTdrXbtaMrmNVs6QdwYgByuGjPBpCHmxzah
         es8jIV4nufYgbLWUfm9KqC1Npo/Ebu0hmk5Sncncfte2AoM+btUQIWN6Z6LiZLEeJqA9
         fWeA==
X-Gm-Message-State: AOAM532HFNpO7N4laC2bv64/Jid5vCNa6g3TPXFHnObCMun7GWjE83r8
        vHLq8IEOf+sV0WchCQ035ompcrKPzvOh5xpF
X-Google-Smtp-Source: ABdhPJwYdBCOsWWj7XWHjL1sYkEExZaefGtWuvMjzJgPwwXpShfZvKDFDEirbGpIKRvPhyMEKFOLQg==
X-Received: by 2002:a63:2111:0:b0:39d:9c12:7c1c with SMTP id h17-20020a632111000000b0039d9c127c1cmr14083727pgh.185.1650371965316;
        Tue, 19 Apr 2022 05:39:25 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id p42-20020a056a0026ea00b0050ab776f6a2sm85639pfw.103.2022.04.19.05.39.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Apr 2022 05:39:24 -0700 (PDT)
Message-ID: <625ead7c.1c69fb81.9e42d.026f@mx.google.com>
Date:   Tue, 19 Apr 2022 05:39:24 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Kernel: v4.19.238-33-g6124afa49867c
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-4.19.y baseline: 104 runs,
 3 regressions (v4.19.238-33-g6124afa49867c)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y baseline: 104 runs, 3 regressions (v4.19.238-33-g612=
4afa49867c)

Regressions Summary
-------------------

platform             | arch  | lab           | compiler | defconfig        =
          | regressions
---------------------+-------+---------------+----------+------------------=
----------+------------
meson-gxbb-p200      | arm64 | lab-baylibre  | gcc-10   | defconfig        =
          | 1          =

meson-gxl-s905d-p230 | arm64 | lab-baylibre  | gcc-10   | defconfig        =
          | 1          =

rk3399-gru-kevin     | arm64 | lab-collabora | gcc-10   | defconfig+arm64-c=
hromebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.19.y/ker=
nel/v4.19.238-33-g6124afa49867c/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.19.y
  Describe: v4.19.238-33-g6124afa49867c
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      6124afa49867cbf9d4266132d020c7bfd11b768d =



Test Regressions
---------------- =



platform             | arch  | lab           | compiler | defconfig        =
          | regressions
---------------------+-------+---------------+----------+------------------=
----------+------------
meson-gxbb-p200      | arm64 | lab-baylibre  | gcc-10   | defconfig        =
          | 1          =


  Details:     https://kernelci.org/test/plan/id/625db25a57a53ecbefae0691

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
38-33-g6124afa49867c/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxb=
b-p200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
38-33-g6124afa49867c/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxb=
b-p200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220411.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/625db25a57a53ecbefae0=
692
        failing since 12 days (last pass: v4.19.235-23-g354b947849d2, first=
 fail: v4.19.235-58-ga78343b23cae) =

 =



platform             | arch  | lab           | compiler | defconfig        =
          | regressions
---------------------+-------+---------------+----------+------------------=
----------+------------
meson-gxl-s905d-p230 | arm64 | lab-baylibre  | gcc-10   | defconfig        =
          | 1          =


  Details:     https://kernelci.org/test/plan/id/625db26e184e340241ae0700

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
38-33-g6124afa49867c/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxl=
-s905d-p230.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
38-33-g6124afa49867c/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxl=
-s905d-p230.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220411.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/625db26e184e340241ae0=
701
        failing since 7 days (last pass: v4.19.234-30-g4401d649cac2, first =
fail: v4.19.237) =

 =



platform             | arch  | lab           | compiler | defconfig        =
          | regressions
---------------------+-------+---------------+----------+------------------=
----------+------------
rk3399-gru-kevin     | arm64 | lab-collabora | gcc-10   | defconfig+arm64-c=
hromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/625db2c784434bdc9eae06c0

  Results:     83 PASS, 7 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
38-33-g6124afa49867c/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/=
baseline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
38-33-g6124afa49867c/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/=
baseline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220411.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/625db2c784434bdc9eae06e2
        failing since 43 days (last pass: v4.19.232, first fail: v4.19.232-=
45-g5da8d73687e7)

    2022-04-18T18:49:28.952958  <8>[   35.938416] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s0-probed RESULT=3Dpass>
    2022-04-18T18:49:29.967007  /lava-6117745/1/../bin/lava-test-case
    2022-04-18T18:49:29.975543  <8>[   36.962812] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s1-probed RESULT=3Dfail>   =

 =20
