Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1A345E6819
	for <lists+stable@lfdr.de>; Thu, 22 Sep 2022 18:09:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231934AbiIVQJh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Sep 2022 12:09:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231869AbiIVQJg (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 22 Sep 2022 12:09:36 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0FAE267B
        for <stable@vger.kernel.org>; Thu, 22 Sep 2022 09:09:32 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id a80so9775809pfa.4
        for <stable@vger.kernel.org>; Thu, 22 Sep 2022 09:09:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date;
        bh=7G6Pq33i/tURrjJZFOaIQdQZaZ4ld58XNUndeg3YKeY=;
        b=1X+xy5dQHM04thEzjDzQxUGVFUjHnRqbCMgjtLm6TCgDXbv4c0ibDinNBTvEQ7yeDX
         cdlNGz1zD1mdhbjq6VfncrgqaxFUddNHAivsMqeqwK0/D2fFvTSRDp4loyx6qE5j/sDs
         qMaVArjIuDwkl2W4/7FtzVQJ9hmhdYPMudFqK71k3i2927CMYQa7v8HWMQIdtPER+/d7
         A7ecctQ083f604mCyR8e21JXZHtO5c608bn4B6/2b7nfpscHSwFy/e+eFTYvrAB+rZ9g
         MlwCtHJSpU7P8GfxW3i9JV4LKVBWJnfvD/lX80Vr0oaRXCMi6xOWiRUg1yZsOoPp50OY
         iuPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date;
        bh=7G6Pq33i/tURrjJZFOaIQdQZaZ4ld58XNUndeg3YKeY=;
        b=OrRZQAuhYjuVxOuotuzAlFlib1x20JfzWhsy5vTOMXjdSlK1hl0LtGzO7dio5yqar4
         Ne2NpbBAjLUYD7wsfnx1sGm1Q1F4mXCoU7F1VwaikmcI5BkTuBRn4BMjTh+r3m16t1tG
         sIz1TjVIDkOM437NL0ASzuHVj2u9oac5WD9fdX4iTbUAOxwRKf5hxB8XBqsQ/qEowzru
         FYkl09HBpbnLvTcz0z31wg0oa7DkXf823/LdJqFBWPYCQ17UNEs1tVZHC8Y3Ntu6Dg7T
         LV3Fa7H7+DyiQa6HqRkM3Nxl2cfXKY9qdUXNvVg4uWoYxExJ90i8eKKqJEeMNxMugcnM
         34Ww==
X-Gm-Message-State: ACrzQf3sBnWnwMKUPaCc/qMtI+g/zOEi09Nnxa08RjHM6FOf8tvl8CT2
        dX4j59/A0YwPgQ254+xNHc/k/vpbajNHju8hAk0=
X-Google-Smtp-Source: AMsMyM5/KrtEoCbJsWNv5lGK3vHX+zGIRqvHE6uc0hYW2NHC0rjCjlYdjUvijmtVZHFQ6xJ0SyH5JA==
X-Received: by 2002:a05:6a00:1596:b0:540:f547:8509 with SMTP id u22-20020a056a00159600b00540f5478509mr4343545pfk.80.1663862971940;
        Thu, 22 Sep 2022 09:09:31 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id u4-20020a170902e5c400b0016cf3f124e1sm4424870plf.234.2022.09.22.09.09.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Sep 2022 09:09:31 -0700 (PDT)
Message-ID: <632c88bb.170a0220.36c10.8e6a@mx.google.com>
Date:   Thu, 22 Sep 2022 09:09:31 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.15
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.15.69-45-gbf904bb06a9a
Subject: stable-rc/queue/5.15 baseline: 153 runs,
 6 regressions (v5.15.69-45-gbf904bb06a9a)
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

stable-rc/queue/5.15 baseline: 153 runs, 6 regressions (v5.15.69-45-gbf904b=
b06a9a)

Regressions Summary
-------------------

platform                     | arch  | lab          | compiler | defconfig =
          | regressions
-----------------------------+-------+--------------+----------+-----------=
----------+------------
at91sam9g20ek                | arm   | lab-broonie  | gcc-10   | at91_dt_de=
fconfig   | 1          =

at91sam9g20ek                | arm   | lab-broonie  | gcc-10   | multi_v5_d=
efconfig  | 1          =

beagle-xm                    | arm   | lab-baylibre | gcc-10   | omap2plus_=
defconfig | 1          =

meson-g12b-a311d-khadas-vim3 | arm64 | lab-baylibre | gcc-10   | defconfig =
          | 1          =

panda                        | arm   | lab-baylibre | gcc-10   | multi_v7_d=
efconfig  | 1          =

panda                        | arm   | lab-baylibre | gcc-10   | omap2plus_=
defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.69-45-gbf904bb06a9a/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.69-45-gbf904bb06a9a
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      bf904bb06a9abec2af97069647d9a2e9b5fbd91e =



Test Regressions
---------------- =



platform                     | arch  | lab          | compiler | defconfig =
          | regressions
-----------------------------+-------+--------------+----------+-----------=
----------+------------
at91sam9g20ek                | arm   | lab-broonie  | gcc-10   | at91_dt_de=
fconfig   | 1          =


  Details:     https://kernelci.org/test/plan/id/632c50dabecd58a8a8355656

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: at91_dt_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.69-=
45-gbf904bb06a9a/arm/at91_dt_defconfig/gcc-10/lab-broonie/baseline-at91sam9=
g20ek.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.69-=
45-gbf904bb06a9a/arm/at91_dt_defconfig/gcc-10/lab-broonie/baseline-at91sam9=
g20ek.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/632c50dabecd58a8a8355=
657
        failing since 1 day (last pass: v5.15.68-34-gb4f486b4ff9c, first fa=
il: v5.15.69-17-g7d846e6eef7f) =

 =



platform                     | arch  | lab          | compiler | defconfig =
          | regressions
-----------------------------+-------+--------------+----------+-----------=
----------+------------
at91sam9g20ek                | arm   | lab-broonie  | gcc-10   | multi_v5_d=
efconfig  | 1          =


  Details:     https://kernelci.org/test/plan/id/632c522e4505dadf50355686

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v5_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.69-=
45-gbf904bb06a9a/arm/multi_v5_defconfig/gcc-10/lab-broonie/baseline-at91sam=
9g20ek.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.69-=
45-gbf904bb06a9a/arm/multi_v5_defconfig/gcc-10/lab-broonie/baseline-at91sam=
9g20ek.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/632c522e4505dadf50355=
687
        failing since 0 day (last pass: v5.15.69-17-g7d846e6eef7f, first fa=
il: v5.15.69-45-g01bb9cc9bf6e) =

 =



platform                     | arch  | lab          | compiler | defconfig =
          | regressions
-----------------------------+-------+--------------+----------+-----------=
----------+------------
beagle-xm                    | arm   | lab-baylibre | gcc-10   | omap2plus_=
defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/632c55a636c36cdebc355686

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.69-=
45-gbf904bb06a9a/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagl=
e-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.69-=
45-gbf904bb06a9a/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagl=
e-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/632c55a636c36cdebc355=
687
        failing since 0 day (last pass: v5.15.69-17-g7d846e6eef7f, first fa=
il: v5.15.69-45-g01bb9cc9bf6e) =

 =



platform                     | arch  | lab          | compiler | defconfig =
          | regressions
-----------------------------+-------+--------------+----------+-----------=
----------+------------
meson-g12b-a311d-khadas-vim3 | arm64 | lab-baylibre | gcc-10   | defconfig =
          | 1          =


  Details:     https://kernelci.org/test/plan/id/632c536772a02e9728355673

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.69-=
45-gbf904bb06a9a/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-g12b-a3=
11d-khadas-vim3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.69-=
45-gbf904bb06a9a/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-g12b-a3=
11d-khadas-vim3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/632c536772a02e9728355=
674
        failing since 1 day (last pass: v5.15.68-34-gb4f486b4ff9c, first fa=
il: v5.15.69-17-g7d846e6eef7f) =

 =



platform                     | arch  | lab          | compiler | defconfig =
          | regressions
-----------------------------+-------+--------------+----------+-----------=
----------+------------
panda                        | arm   | lab-baylibre | gcc-10   | multi_v7_d=
efconfig  | 1          =


  Details:     https://kernelci.org/test/plan/id/632c5518537de04257355643

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.69-=
45-gbf904bb06a9a/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-panda.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.69-=
45-gbf904bb06a9a/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-panda.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/632c5518537de04257355=
644
        failing since 37 days (last pass: v5.15.60-48-g789367af88749, first=
 fail: v5.15.60-779-ge1dae9850fdff) =

 =



platform                     | arch  | lab          | compiler | defconfig =
          | regressions
-----------------------------+-------+--------------+----------+-----------=
----------+------------
panda                        | arm   | lab-baylibre | gcc-10   | omap2plus_=
defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/632c58743eb016538e3556ab

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.69-=
45-gbf904bb06a9a/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-panda=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.69-=
45-gbf904bb06a9a/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-panda=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/632c58743eb016538e355=
6ac
        failing since 30 days (last pass: v5.15.61-1-geccb923b9eab2, first =
fail: v5.15.62-232-g7f3b8845612d) =

 =20
