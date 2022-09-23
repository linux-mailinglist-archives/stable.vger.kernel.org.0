Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41ABB5E7FA3
	for <lists+stable@lfdr.de>; Fri, 23 Sep 2022 18:24:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230345AbiIWQYL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Sep 2022 12:24:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231835AbiIWQXh (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 23 Sep 2022 12:23:37 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D73FA12BD89
        for <stable@vger.kernel.org>; Fri, 23 Sep 2022 09:23:36 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id s90-20020a17090a2f6300b00203a685a1aaso647028pjd.1
        for <stable@vger.kernel.org>; Fri, 23 Sep 2022 09:23:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date;
        bh=z7XIfoSyQnVuve5/KBql6IvraP31gGy+IZNsDSw2VNw=;
        b=X/Y9g72oi/Pz3SnepXrKMz7IsVlVKi2e1U39LgpBZ89PDZUz0qP09mv/FJFT5HnBmZ
         Ens7+VjjkF44wFkyLHdkZpAIpaYu94w1aQSEUQ2ao+TO0dd3GzdVGmJOEW81gx6uSjGe
         cGfmP+a/ybrGB17ieUEmacvluQc0Bcy4vnalACFDyBTUU7YQeOhb/p+ePosliMBGRPBe
         IQFxrOc9ukO3naMf6I0rpnKz7MU/fnXG6qDQW/YV+gPVLQi63fZCxklVfhzoR9BuqbF/
         O/PfaeQ/7kiqp0Tsl0ugBNRhVxr8hVK6okG67EB/JqafY9oM7zhAezFYfa4gsq0nR1sb
         bvgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date;
        bh=z7XIfoSyQnVuve5/KBql6IvraP31gGy+IZNsDSw2VNw=;
        b=YZWPpo7AudjC5XqYrWP5kIbysoclYQ4ITQSaKT97uMFlHS0/hIbBlRwRwZQM9TJmxL
         nTNTkUvjtbc4BA+u58qAq6u+wdgLEvzD7g1YJUyCsus2qTYXypdGioWxRpC4Z8CPuZoS
         tkwQoouFBw3DSorta9pj6eKxDaJ/8W9Op/slCJ4y5vhIC7ka1cQ7kZvgofRZH97ru1yQ
         nppGDxlZomrjW75jlBRwLaelA0cW7dk+ScaLSZddD4UkIugVoyO+WtAoK6NfoIQCBtNC
         iqbNLmP1GLb+wrqYz7arwcQy04d1EoNJg8nEv5QfVrhm5Fbkvh7vPQT3GU5Dy+tArmxP
         qNhg==
X-Gm-Message-State: ACrzQf14L+Qm0gV2lsyp0o9DiE36PZne9QmhaVl4rJAaplhWgyXEef9d
        BF0KaxdayhiAgA0T5TsYCTgr3s2YIDHo/tKciWo=
X-Google-Smtp-Source: AMsMyM6Fx7+nWiAvWPjhhWqizZXrA3QKX+DOaSMkT2J8pwqDTSOGL2vHqworCzurX/GX/ykHoWUovA==
X-Received: by 2002:a17:902:ecc3:b0:178:3217:e455 with SMTP id a3-20020a170902ecc300b001783217e455mr9371758plh.18.1663950216147;
        Fri, 23 Sep 2022 09:23:36 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id mg13-20020a17090b370d00b001fd803f057bsm1793293pjb.33.2022.09.23.09.23.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Sep 2022 09:23:35 -0700 (PDT)
Message-ID: <632ddd87.170a0220.b0239.3830@mx.google.com>
Date:   Fri, 23 Sep 2022 09:23:35 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.19
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.19.10-39-g5c88edb51b10
Subject: stable-rc/queue/5.19 baseline: 174 runs,
 3 regressions (v5.19.10-39-g5c88edb51b10)
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

stable-rc/queue/5.19 baseline: 174 runs, 3 regressions (v5.19.10-39-g5c88ed=
b51b10)

Regressions Summary
-------------------

platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
hifive-unleashed-a00         | riscv | lab-baylibre  | gcc-10   | defconfig=
                  | 1          =

jetson-tk1                   | arm   | lab-baylibre  | gcc-10   | multi_v7_=
defconfig         | 1          =

sc7180-trogdo...zor-limozeen | arm64 | lab-collabora | gcc-10   | defconfig=
+arm64-chromebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.19/ker=
nel/v5.19.10-39-g5c88edb51b10/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.19
  Describe: v5.19.10-39-g5c88edb51b10
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      5c88edb51b10b444150b0f68332923af6e1b2d48 =



Test Regressions
---------------- =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
hifive-unleashed-a00         | riscv | lab-baylibre  | gcc-10   | defconfig=
                  | 1          =


  Details:     https://kernelci.org/test/plan/id/632da7f145de150e0c355662

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (riscv64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.10-=
39-g5c88edb51b10/riscv/defconfig/gcc-10/lab-baylibre/baseline-hifive-unleas=
hed-a00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.10-=
39-g5c88edb51b10/riscv/defconfig/gcc-10/lab-baylibre/baseline-hifive-unleas=
hed-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/riscv/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/632da7f145de150e0c355=
663
        failing since 1 day (last pass: v5.19.10-36-g00099e2e5131, first fa=
il: v5.19.10-39-g0c9655cc6e1a) =

 =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
jetson-tk1                   | arm   | lab-baylibre  | gcc-10   | multi_v7_=
defconfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/632db591c05bfa853935568b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.10-=
39-g5c88edb51b10/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-jetson=
-tk1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.10-=
39-g5c88edb51b10/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-jetson=
-tk1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/632db592c05bfa8539355=
68c
        new failure (last pass: v5.19.10-39-g0c9655cc6e1a) =

 =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
sc7180-trogdo...zor-limozeen | arm64 | lab-collabora | gcc-10   | defconfig=
+arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/632dab1e86b3b4cfe635564e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.10-=
39-g5c88edb51b10/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/base=
line-sc7180-trogdor-lazor-limozeen.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.10-=
39-g5c88edb51b10/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/base=
line-sc7180-trogdor-lazor-limozeen.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/632dab1e86b3b4cfe6355=
64f
        failing since 4 days (last pass: v5.19.9-55-g7dbe36eefdad, first fa=
il: v5.19.9-56-g29b6ff678b0e) =

 =20
