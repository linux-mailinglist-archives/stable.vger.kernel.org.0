Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9E5D50FD17
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 14:33:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349979AbiDZMgn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 08:36:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349964AbiDZMgm (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 08:36:42 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E7DED117D
        for <stable@vger.kernel.org>; Tue, 26 Apr 2022 05:33:31 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id w5-20020a17090aaf8500b001d74c754128so2135094pjq.0
        for <stable@vger.kernel.org>; Tue, 26 Apr 2022 05:33:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=W7uerVL0KAYwBxZQoXfBVu99Yrmtdh7tYW+bdVwXY1Q=;
        b=xkUeswpqCvfq1SSQCh3uLNGuLVMEpHJPYCV26VYGcSvNlv3t2WVvKesuXgK1DxrN4H
         xzKygNIWO0XPbhUsv2SlRhPmvPx5cxJ1X+2Bj9Y024jaquGBH5e+aRCZ7P1wnSgPtdfT
         B3BHAOBZdEejkDC4vQztr9bAIaS6tAWrpAFRWaK6UltecfUF1EVEHJyKJSQXWuK5t2Ks
         qKqal948567Dtkdqk0cVet9WGfYcuhTiZALkzeHnTE6lceiMNDolmUVFgVSHKRYK6Cuw
         3ZiNr2aa6v15eixOqNhQu/ABKeZebWxg5s2sJ4jcHArxq7DLvyan1ZWoxEPqzGvLjYhH
         IFKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=W7uerVL0KAYwBxZQoXfBVu99Yrmtdh7tYW+bdVwXY1Q=;
        b=F0i4R4RdEGxgz32m0JO+gTqOAboPr0lQfrYriZZTae1LRzkMjFBn/Mybw0N52oROUy
         o+2FsQ2oypKELDpVySY6VkE7Nlz3V/PSQe03NLP3ltqHlLXVEGdmZeOmPfBCenrjYghp
         RLhE+zQLCJk7J3ptWxmHlJwdn7kWjJSdOUuaLD4UIVZzKuMWZnzEiBcdBlrZ59fQFR3v
         oBfNQ1QS5blpajfBpKSIKHxQ6ZdAtvPjswb9QbKvzrcWM53bEz0qu7nuOpiuvWUoV8If
         Mdzg44NIBuT6IpZy9HwW56CpImnBgQeSqcG79RRLMpSoCOX00JmNz1RVyz3qvPsUDY7M
         da8A==
X-Gm-Message-State: AOAM5311HPux7pB66RMkIpdkVUR/wkqXKGlhkEgnhAWB9eiU5BQ2o4cm
        aABT9Ovi+pfU+m5bbjg8nJg0+Vxkra5wQxrTFsI=
X-Google-Smtp-Source: ABdhPJz97J9qwFM9qVWeXO/OhwPaNvSTppLHoQVunoubTH7uZ4Phe3/AxvI2KQF1i1I/ED4aDHAVSg==
X-Received: by 2002:a17:903:22c1:b0:15d:1f54:2246 with SMTP id y1-20020a17090322c100b0015d1f542246mr7580351plg.159.1650976410598;
        Tue, 26 Apr 2022 05:33:30 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id l15-20020a62be0f000000b005059cc9cc34sm15480569pff.92.2022.04.26.05.33.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Apr 2022 05:33:30 -0700 (PDT)
Message-ID: <6267e69a.1c69fb81.7cf6e.4697@mx.google.com>
Date:   Tue, 26 Apr 2022 05:33:30 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.15.35-124-g4ee77b595524f
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.15
Subject: stable-rc/queue/5.15 baseline: 113 runs,
 3 regressions (v5.15.35-124-g4ee77b595524f)
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

stable-rc/queue/5.15 baseline: 113 runs, 3 regressions (v5.15.35-124-g4ee77=
b595524f)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
at91sam9g20ek    | arm   | lab-broonie   | gcc-10   | multi_v5_defconfig   =
      | 1          =

beagle-xm        | arm   | lab-baylibre  | gcc-10   | omap2plus_defconfig  =
      | 1          =

rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.35-124-g4ee77b595524f/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.35-124-g4ee77b595524f
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      4ee77b595524f58e6a4b86eb132143554655c62c =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
at91sam9g20ek    | arm   | lab-broonie   | gcc-10   | multi_v5_defconfig   =
      | 1          =


  Details:     https://kernelci.org/test/plan/id/6267b4096673b15433ff946b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v5_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.35-=
124-g4ee77b595524f/arm/multi_v5_defconfig/gcc-10/lab-broonie/baseline-at91s=
am9g20ek.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.35-=
124-g4ee77b595524f/arm/multi_v5_defconfig/gcc-10/lab-broonie/baseline-at91s=
am9g20ek.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220422.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6267b4096673b15433ff9=
46c
        new failure (last pass: v5.15.35-119-g4fff198d225d) =

 =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
beagle-xm        | arm   | lab-baylibre  | gcc-10   | omap2plus_defconfig  =
      | 1          =


  Details:     https://kernelci.org/test/plan/id/6267b3e594e67515bfff946a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.35-=
124-g4ee77b595524f/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-bea=
gle-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.35-=
124-g4ee77b595524f/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-bea=
gle-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220422.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6267b3e594e67515bfff9=
46b
        failing since 26 days (last pass: v5.15.31-2-g57d4301e22c2, first f=
ail: v5.15.31-3-g4ae45332eb9c) =

 =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6267b6f66bab632e8eff9471

  Results:     88 PASS, 4 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.35-=
124-g4ee77b595524f/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/ba=
seline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.35-=
124-g4ee77b595524f/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/ba=
seline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220422.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/6267b6f66bab632e8eff9497
        failing since 49 days (last pass: v5.15.26-42-gc89c0807b943, first =
fail: v5.15.26-257-g2b9a22cd5eb8)

    2022-04-26T09:09:53.396077  <8>[   32.763612] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s0-probed RESULT=3Dpass>
    2022-04-26T09:09:54.419611  /lava-6180838/1/../bin/lava-test-case
    2022-04-26T09:09:54.430966  <8>[   33.798465] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s1-probed RESULT=3Dfail>   =

 =20
