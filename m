Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ADD665386BD
	for <lists+stable@lfdr.de>; Mon, 30 May 2022 19:25:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231679AbiE3RZj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 May 2022 13:25:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230490AbiE3RZj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 May 2022 13:25:39 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 336C3793AD
        for <stable@vger.kernel.org>; Mon, 30 May 2022 10:25:38 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id f4so10639806pgf.4
        for <stable@vger.kernel.org>; Mon, 30 May 2022 10:25:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=kW0zJyN49Mv1Mg603RRCHxYEzzfLVAButd2eSFD7YGw=;
        b=Ak2fJCYFlLkOUKKKcPTMD/7/J1X1jCWbv29Pyy8/ssKVBYObi5XpSbdjtaV3Y+uhG+
         2IIW9n7qQ2+rOszCuILiw74AcFnQQc/apRa+3mjMlh6vE28mbwPWt1hYZq5p1kvBjm07
         WI6hFpm7dZx4aiyn8kssJgir9dTtmQ6ZLJnvMv7a64qj4FLrp0SQL9JuQR5Ayq3BUdO2
         Tda4PE4UzKk0kvs63tSAdxLt99SSg0hVhFk5bs72bOBmsfVsrcZ3F7tP3fk2rCswVOPK
         5lxnV+y/NkkRFMWgEmei7AXkuyYr1pVdZS6sGxZbq634RW+XrxXDLGkYW/sQ36DiV3ke
         BaAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=kW0zJyN49Mv1Mg603RRCHxYEzzfLVAButd2eSFD7YGw=;
        b=fx/Ns5NnS/7HXdZ99xG257LDJVksrisxVWszarruVSTlRt9Kyz3IxvcaY2z1SgFAip
         BbF0+In4usoW8rzg2SlK0u04JWF6zQZ0jgUtItE7pzodH7qmc5l0JmMuAWf1BcpF5174
         m2BuUusvSrxiA4xzWEO2BXnjfkA+DSjuAuMqIYakPrcibhAMDoMEf3zYRuB4ep7zKC+P
         k9wsz8oB4N3gYBlqhda4UwVNYMf9ydPo+bbaTdXUOPtbinxaJRaqyg3lKY/pkgU25O7h
         JdIekJ1aaGYY0U/pqNx35dEjcgkqvRx5UASZuLoTVLmMfAwNfxUntM387BeWf5jTrhh6
         RJ4w==
X-Gm-Message-State: AOAM532eqnRU5SgQ+mfQQZdlXc8jnDdHiNdTaXt5Oqu8STyxNUqfNOFp
        mv/EIJ7SeSKn1EkQPxBiH8eGpUXr1ZYo9Qw4BWw=
X-Google-Smtp-Source: ABdhPJyLu6KQmMB1tpaTGbFAxUWmLlvZpiBsTO6rhOs2MWYcgAeGCxvTEewTVi85QI8e+4JKDY4p4g==
X-Received: by 2002:a65:6d0d:0:b0:3fb:1477:5191 with SMTP id bf13-20020a656d0d000000b003fb14775191mr19069843pgb.541.1653931537550;
        Mon, 30 May 2022 10:25:37 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id x1-20020a633101000000b003f60a8d7dadsm8670742pgx.15.2022.05.30.10.25.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 May 2022 10:25:37 -0700 (PDT)
Message-ID: <6294fe11.1c69fb81.f68ed.33eb@mx.google.com>
Date:   Mon, 30 May 2022 10:25:37 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.15.44
X-Kernelci-Branch: linux-5.15.y
X-Kernelci-Tree: stable
Subject: stable/linux-5.15.y baseline: 184 runs, 3 regressions (v5.15.44)
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

stable/linux-5.15.y baseline: 184 runs, 3 regressions (v5.15.44)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
jetson-tk1       | arm   | lab-baylibre  | gcc-10   | multi_v7_defconfig   =
      | 1          =

jetson-tk1       | arm   | lab-baylibre  | gcc-10   | tegra_defconfig      =
      | 1          =

rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.15.y/kernel=
/v5.15.44/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.15.y
  Describe: v5.15.44
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      4e67be407725b1d8b829ed2075987037abec98ec =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
jetson-tk1       | arm   | lab-baylibre  | gcc-10   | multi_v7_defconfig   =
      | 1          =


  Details:     https://kernelci.org/test/plan/id/6294d816e9b10b8707a39c42

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.44/a=
rm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-jetson-tk1.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.44/a=
rm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-jetson-tk1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220527.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6294d816e9b10b8707a39=
c43
        failing since 5 days (last pass: v5.15.39, first fail: v5.15.42) =

 =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
jetson-tk1       | arm   | lab-baylibre  | gcc-10   | tegra_defconfig      =
      | 1          =


  Details:     https://kernelci.org/test/plan/id/6294cab77c7794daf4a39bda

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: tegra_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.44/a=
rm/tegra_defconfig/gcc-10/lab-baylibre/baseline-jetson-tk1.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.44/a=
rm/tegra_defconfig/gcc-10/lab-baylibre/baseline-jetson-tk1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220527.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6294cab77c7794daf4a39=
bdb
        failing since 5 days (last pass: v5.15.39, first fail: v5.15.42) =

 =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6294c95965eaa751b2a39bcd

  Results:     88 PASS, 4 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.44/a=
rm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gru-ke=
vin.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.44/a=
rm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gru-ke=
vin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220527.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/6294c95965eaa751b2a39bef
        failing since 82 days (last pass: v5.15.25, first fail: v5.15.27)

    2022-05-30T13:40:27.550989  /lava-6502024/1/../bin/lava-test-case
    2022-05-30T13:40:27.562365  <8>[   60.879485] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s1-probed RESULT=3Dfail>   =

 =20
