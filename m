Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3866B5E80A3
	for <lists+stable@lfdr.de>; Fri, 23 Sep 2022 19:24:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230422AbiIWRY1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Sep 2022 13:24:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231255AbiIWRYX (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 23 Sep 2022 13:24:23 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36F27147690
        for <stable@vger.kernel.org>; Fri, 23 Sep 2022 10:24:22 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id fs14so647754pjb.5
        for <stable@vger.kernel.org>; Fri, 23 Sep 2022 10:24:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date;
        bh=mvqlkFOwx9EmNC4RZzyI3KBlF1li8BnevIJ5cuE+3hc=;
        b=zAwh+cttgp93LqqkBhfzyfgBnWFpST+zE5CyHEFMYTVnQuXfB0OpSBwV6WtLn0W7Rd
         LVyyj95aMM+AdySk6S6DwRSeciiNsr1vafVL2w0ut9tBk42YUmxAjiFOasrs+3ovVKGd
         elEqk84ye1Fz1kPTHEYlqYV8p3uwjWx0qo62IOwNhoNEDQhS4m5+SfR4MkPJtiwVrx2t
         4wZO2Wn3fnxRI2+Kcqa21LZS7w/zGtCg60qeMdQfnqZANJM/BFAV9+dmaj0AzBvKsaHy
         qLs7Z63Veir4C0EhyJiJFwGV+dFru72AMQlr3VxL61TtmTgA5Mn4S/50iUC7fdGKSVlP
         4RXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date;
        bh=mvqlkFOwx9EmNC4RZzyI3KBlF1li8BnevIJ5cuE+3hc=;
        b=eBjVnvVtENX1Nve0zbxsQVZJdIrdm+TXAbPQ5lkcafIqwf3eInry9j2LDgoxRc2eZr
         FI97Zyd6YIX3LutVTpFEitmrzjcPV2oceACLCgjNhlmjcpLEq2IQ2gW3d+ayv4BsO0YU
         dSUnH1dHiHE5FwnKt9f9RzYdi/+K4K+Y/znyaPh7rrER7N2j7581S62PflxLGF9PEd69
         h7dGlsEAA1JPRFbpZHFBfRt2qE8cpzF7qnbzC8l+FpIBw97mGOv1yuzEqF75JV6O6EkE
         GK/03xAHMRq6qYKahKcyhvuB3YHIuG6YXenBWsF86lycpfVg7Pz3h/+oD7NUOZksRodZ
         SQoA==
X-Gm-Message-State: ACrzQf3raSpr/v6bVcJKJ3OoA60jLi8BhcPFbuy9lsZTmha33T9FAW6s
        ji6hmfqtWf3Xe3NE2v9ICMr0k7xBQMRwW8XRvf0=
X-Google-Smtp-Source: AMsMyM6VeJOjTxqUAqrQAbtO1APl3ywes1Jsrzb/0kl8U32yPhEVlhH1D9aR3J25xZPF4PD1M/AFwg==
X-Received: by 2002:a17:902:dad2:b0:178:401c:f672 with SMTP id q18-20020a170902dad200b00178401cf672mr9269699plx.168.1663953861545;
        Fri, 23 Sep 2022 10:24:21 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id em20-20020a17090b015400b00203917403ccsm1869674pjb.1.2022.09.23.10.24.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Sep 2022 10:24:20 -0700 (PDT)
Message-ID: <632debc4.170a0220.fcfe3.40da@mx.google.com>
Date:   Fri, 23 Sep 2022 10:24:20 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.15.y
X-Kernelci-Tree: stable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.15.70
Subject: stable/linux-5.15.y baseline: 130 runs, 2 regressions (v5.15.70)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.15.y baseline: 130 runs, 2 regressions (v5.15.70)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
panda            | arm   | lab-baylibre  | gcc-10   | multi_v7_defconfig   =
      | 1          =

rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.15.y/kernel=
/v5.15.70/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.15.y
  Describe: v5.15.70
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      3e98e33d345e981800e03dd29f6f6343286d30b6 =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
panda            | arm   | lab-baylibre  | gcc-10   | multi_v7_defconfig   =
      | 1          =


  Details:     https://kernelci.org/test/plan/id/632db9e3586c17216335565c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.70/a=
rm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-panda.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.70/a=
rm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-panda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/632db9e3586c172163355=
65d
        failing since 36 days (last pass: v5.15.59, first fail: v5.15.61) =

 =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/632db945a7a8e15014355642

  Results:     88 PASS, 4 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.70/a=
rm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gru-ke=
vin.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.70/a=
rm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gru-ke=
vin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/632db945a7a8e15014355668
        failing since 198 days (last pass: v5.15.25, first fail: v5.15.27)

    2022-09-23T13:48:28.397207  /lava-7359076/1/../bin/lava-test-case
    2022-09-23T13:48:28.408663  <8>[   33.834317] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s1-probed RESULT=3Dfail>   =

 =20
