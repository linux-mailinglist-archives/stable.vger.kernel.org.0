Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 839C950ACB0
	for <lists+stable@lfdr.de>; Fri, 22 Apr 2022 02:14:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1442580AbiDVARs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 Apr 2022 20:17:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231574AbiDVARr (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 Apr 2022 20:17:47 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55B4B2729
        for <stable@vger.kernel.org>; Thu, 21 Apr 2022 17:14:56 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id g3so5366912pgg.3
        for <stable@vger.kernel.org>; Thu, 21 Apr 2022 17:14:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=omiGOL2qt0x2weSWdEECmvPW9dqTUCTWMwmX+rmjTzI=;
        b=G6qxx4I0LIah/NQ5cwQwElz9PBELwABOrA5LwmEQFKnkCFgrL17FQRdaVPg9vxzEGh
         RJmBB5Aceo4uD0/QcpHKyhMXufLhHoHUyCW81klFafzyi1b+6eHk4CDG4BGAS4QkOYXl
         q9eJDxCwKvKhreFbdrxrwGXUUFC7kVNU+pJT1ytbSnGU8Zr2Br0weC3seDmcwYfuJvDQ
         ovyU7HhETEW+8wsFRktJySxnWyviiG/tju7D7G5fi+iXR4xxgc0u1AqL4FBaUxogq3zP
         tCcqUCM+M1bl5x8Z0sg9B8p0rCmSuypNS4xkKkXaFw5pVxTiavQD5o/kctHhDjNQbozA
         IJsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=omiGOL2qt0x2weSWdEECmvPW9dqTUCTWMwmX+rmjTzI=;
        b=dN4NMb55vlvQHQX0PxbOhhakgbNW1eLIUScMoN/KAPk/9uN8aEJ5L/xilI7DWuclTm
         0RVpvUBrkv/ML3eScyxWHX7xGsla4Hd8yVLIeSflsPDn8emjS/Xx0uMBDLdTPfEE5FAK
         n7FvyESo1WT9yum0Jr9jRO309gKErismPkn7cmimw9O/Z5n7jM893qlDOeYQgtQ7ZrLy
         rsRGb7LbpLo1Bo8TrZd/cPtDAUqxTDjM6FiCNnkbgDzCANhpu/3JeCl735C8oPAv1h8O
         C+zpJ7onXd0o3nkWa48Kfsh2Xol0SUk6C66/Gi0IjmwjWPa+EbszCrw++MBLclNhP+Ms
         /mjw==
X-Gm-Message-State: AOAM533pUFIAwcpuffFtdRPSA5x2GuRoa2o3A5cZckS19OsDJvwwLme2
        ir6yauZMeBeIt47tjyyaqsEqR0kXYs90/Vrb6Ls=
X-Google-Smtp-Source: ABdhPJzvfl2uBT7CaZLQnQ/LMoXFfrk7ki1JozgYIEsKS/ZvpX+oeR3AbapoBMq05xgZIit2YbbR2Q==
X-Received: by 2002:a63:3fcb:0:b0:3aa:36aa:33e8 with SMTP id m194-20020a633fcb000000b003aa36aa33e8mr1652690pga.492.1650586495540;
        Thu, 21 Apr 2022 17:14:55 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id f14-20020a63380e000000b0038253c4d5casm285013pga.36.2022.04.21.17.14.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Apr 2022 17:14:55 -0700 (PDT)
Message-ID: <6261f37f.1c69fb81.5b82f.10dd@mx.google.com>
Date:   Thu, 21 Apr 2022 17:14:55 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.15.35-13-gfcfbe4b48b2d
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.15
Subject: stable-rc/queue/5.15 baseline: 136 runs,
 2 regressions (v5.15.35-13-gfcfbe4b48b2d)
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

stable-rc/queue/5.15 baseline: 136 runs, 2 regressions (v5.15.35-13-gfcfbe4=
b48b2d)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
beagle-xm        | arm   | lab-baylibre  | gcc-10   | omap2plus_defconfig  =
      | 1          =

rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.35-13-gfcfbe4b48b2d/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.35-13-gfcfbe4b48b2d
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      fcfbe4b48b2d5e976b297a08ecb6c7101d118013 =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
beagle-xm        | arm   | lab-baylibre  | gcc-10   | omap2plus_defconfig  =
      | 1          =


  Details:     https://kernelci.org/test/plan/id/6261bf31bdd83f8050ff9470

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.35-=
13-gfcfbe4b48b2d/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagl=
e-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.35-=
13-gfcfbe4b48b2d/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagl=
e-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220411.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6261bf31bdd83f8050ff9=
471
        failing since 22 days (last pass: v5.15.31-2-g57d4301e22c2, first f=
ail: v5.15.31-3-g4ae45332eb9c) =

 =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6261c36783911ea078ff9484

  Results:     88 PASS, 4 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.35-=
13-gfcfbe4b48b2d/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/base=
line-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.35-=
13-gfcfbe4b48b2d/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/base=
line-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220411.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/6261c36783911ea078ff94aa
        failing since 45 days (last pass: v5.15.26-42-gc89c0807b943, first =
fail: v5.15.26-257-g2b9a22cd5eb8)

    2022-04-21T20:49:18.677073  <8>[   59.740309] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s0-probed RESULT=3Dpass>
    2022-04-21T20:49:19.700168  /lava-6143930/1/../bin/lava-test-case
    2022-04-21T20:49:19.710763  <8>[   60.774439] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s1-probed RESULT=3Dfail>   =

 =20
