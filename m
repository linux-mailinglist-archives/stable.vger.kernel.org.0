Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE11251B761
	for <lists+stable@lfdr.de>; Thu,  5 May 2022 07:11:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243253AbiEEFOh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 May 2022 01:14:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243252AbiEEFOg (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 May 2022 01:14:36 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A29796441
        for <stable@vger.kernel.org>; Wed,  4 May 2022 22:10:58 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id j8-20020a17090a060800b001cd4fb60dccso3139915pjj.2
        for <stable@vger.kernel.org>; Wed, 04 May 2022 22:10:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=vTmfhJyaodZ68e8wQLfGr5YDPLYgVvVh37r7wPjwYbI=;
        b=44WevsbsVDyZRkdEvEvpis3U/SCT/3NXy5juqnVgYGk1TTPkIAVAUdxtcwl7TtdubG
         O/12Zg7dWjg6rpSkkbwB5VxJGf2k64U3+JOecUySXf3Wio8uWbqbsAstbQDbk6t/mMCt
         HXyNNjNhhhMFRaRyAmBI3hX+LANXlMuUA7bSrNdHIDpPBoza+v7+achvpN6o66u2vVXl
         yNMtoB9Udsa13EuUXsj9/2LmYrF9hdn7w6eC5NumRHhxAQgCkPly8pRJYd1SVhNmEoRz
         p33ZMpLmX+S6pdf872YDiRxioJKbs32conYODXiWsjqiLUxn3AIbAkuuB1WVZdmeCSBK
         vU6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=vTmfhJyaodZ68e8wQLfGr5YDPLYgVvVh37r7wPjwYbI=;
        b=F2XGmFjagPA2vtQ0LByE+lfeb0JehKC3Rr4XdO/c1/EyB557u39/ixCLn55ZcNBlzZ
         n++3/SgbKD4AlqfszsRF7Dmi4ST7OlQ6y8FBvRe7mmN3O63TkrZvYYsvWvL4x94NAWaD
         Q8POEWfw4rOP0S8kRe7p6rBLZaCphd2suNkYvwth7hIG+sU2GwMugEn3VSbIEAw3g87s
         fZXWl+l0hAC3F1rP7zb+kCTsNomXe4s7cGrDXdy8KK8gfcd4/xcNn+6M16bcy9Wwj8M9
         GJZnYtObMgxVpOBkejW9/N70QnYukwQ0r5ND/ojaADK6XCO1nTgYG0cqqNP7jCbS5Kc9
         kwnw==
X-Gm-Message-State: AOAM530tgtAs4nqHYrSZk6iI0FPC+/HoExOc6UbE34wXEyzE04CvdleX
        mBDZhqrlWtjos081eaXrZn/e89xxMK1W6iXrZXU=
X-Google-Smtp-Source: ABdhPJyt+u6J2LF8wwj2uDydkPxCzyjJF3II6q+id+ob0MGnMV3UoVk/cEwb/EwoYfnc+mYsUkmBHg==
X-Received: by 2002:a17:902:82c9:b0:15d:3a76:936f with SMTP id u9-20020a17090282c900b0015d3a76936fmr25165187plz.139.1651727458046;
        Wed, 04 May 2022 22:10:58 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id x125-20020a623183000000b0050dc7628198sm335734pfx.114.2022.05.04.22.10.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 May 2022 22:10:57 -0700 (PDT)
Message-ID: <62735c61.1c69fb81.bead2.0e7a@mx.google.com>
Date:   Wed, 04 May 2022 22:10:57 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Kernel: v5.4.191-85-ga4a4cbb41380
Subject: stable-rc/linux-5.4.y baseline: 98 runs,
 2 regressions (v5.4.191-85-ga4a4cbb41380)
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

stable-rc/linux-5.4.y baseline: 98 runs, 2 regressions (v5.4.191-85-ga4a4cb=
b41380)

Regressions Summary
-------------------

platform             | arch  | lab           | compiler | defconfig        =
          | regressions
---------------------+-------+---------------+----------+------------------=
----------+------------
hifive-unleashed-a00 | riscv | lab-baylibre  | gcc-10   | defconfig        =
          | 1          =

rk3399-gru-kevin     | arm64 | lab-collabora | gcc-10   | defconfig+arm64-c=
hromebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.4.y/kern=
el/v5.4.191-85-ga4a4cbb41380/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.4.y
  Describe: v5.4.191-85-ga4a4cbb41380
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      a4a4cbb413802e07ea4b9e45236bd75e241dd4ca =



Test Regressions
---------------- =



platform             | arch  | lab           | compiler | defconfig        =
          | regressions
---------------------+-------+---------------+----------+------------------=
----------+------------
hifive-unleashed-a00 | riscv | lab-baylibre  | gcc-10   | defconfig        =
          | 1          =


  Details:     https://kernelci.org/test/plan/id/627328fe91925d1e438f5798

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (riscv64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.191=
-85-ga4a4cbb41380/riscv/defconfig/gcc-10/lab-baylibre/baseline-hifive-unlea=
shed-a00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.191=
-85-ga4a4cbb41380/riscv/defconfig/gcc-10/lab-baylibre/baseline-hifive-unlea=
shed-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220428.0/riscv/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/627328fe91925d1e438f5=
799
        failing since 28 days (last pass: v5.4.188-371-g48b29a8f8ae0, first=
 fail: v5.4.188-368-ga24be10a1a9ef) =

 =



platform             | arch  | lab           | compiler | defconfig        =
          | regressions
---------------------+-------+---------------+----------+------------------=
----------+------------
rk3399-gru-kevin     | arm64 | lab-collabora | gcc-10   | defconfig+arm64-c=
hromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/627336c7d5b45531ee8f576a

  Results:     88 PASS, 2 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.191=
-85-ga4a4cbb41380/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.191=
-85-ga4a4cbb41380/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220428.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/627336c7d5b45531ee8f578c
        failing since 59 days (last pass: v5.4.181-51-gb77a12b8d613, first =
fail: v5.4.182-54-gf27af6bf3c32)

    2022-05-05T02:30:21.538338  /lava-6269536/1/../bin/lava-test-case   =

 =20
