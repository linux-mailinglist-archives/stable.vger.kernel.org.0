Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B246647928F
	for <lists+stable@lfdr.de>; Fri, 17 Dec 2021 18:14:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231920AbhLQROV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Dec 2021 12:14:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239398AbhLQROR (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Dec 2021 12:14:17 -0500
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E021FC061574
        for <stable@vger.kernel.org>; Fri, 17 Dec 2021 09:14:16 -0800 (PST)
Received: by mail-pf1-x435.google.com with SMTP id t123so1441558pfc.13
        for <stable@vger.kernel.org>; Fri, 17 Dec 2021 09:14:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=WoeFI7McQtaSWn9Nw3QkLRVX3c5wbrzIhBP0LTtsMPM=;
        b=0Z+zRjz4/fMrl5zGTy+dvVfWpmtnRwhksEpcgw2fn7WGjI4986yXa8nNGuiOhbJUL4
         54Jx0JsQJX5nyKGDrUQTUWIxLreC8kpo2JEsiCBQS5mzHUP5UwIFobxTizprg7+GXQCM
         zL9zapWZmDShJxwrAR3AA6XYpumiKQHmmhtb34g3ZeiLQLvdoeH2ctGFnL1tsgnleNoq
         yCvdGva7gSw3fbGL6PvDV+IwodF6nMRSSubFErNj2tau2ZqdEYzXbrNIi9Hm2GSXkua3
         sxlxBKEndkmwG48RKm4jMXEntix+L76HxavQV7Z7I/UlP0YHu9hwrPGcWFlMR5m6hqYt
         Zrzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=WoeFI7McQtaSWn9Nw3QkLRVX3c5wbrzIhBP0LTtsMPM=;
        b=u5HX7fWsAHVvtK6XNi5G4UDnwHDU2VoBaLejD+mZfyzZry4Y5oAAhcH9gEZ0hLvXaR
         JSM1FQucVRHOBSS1DZWdMm+GJBcb1bgVdPLNcF6oPR4ir4tG7CFyKJWlOR9so2qGHGau
         QwdLxQM+ga0aP1aMyMeblCW1FEOM4MDFw1jHa8IxdOkqbOZAoHUJJXxfrPwvylghTSpV
         xod9sQgle+2q0u5jQuuDAqnNEkI1Qv0mjsmYREeBNOBZroy+Cs+81X2ug7E1QE9wC49L
         7r4tGbuM0yBBdG97UuuDUe8mCijsgkKKH0RNKi8dBp5on3Bb9qfts+dsu+3wlV0QyW3X
         KM+A==
X-Gm-Message-State: AOAM530WgAQim57LBsnxm5n5WbUmh1ZwHgYLYxu1AdAiXMh8Ugxwwdyv
        Kj10MM09QYT4RqWUNAIHgScqOM41p+XjEU/a
X-Google-Smtp-Source: ABdhPJyF1OTnDab68/Srl1GpSgzf5vy892Jr3ZutcZVLrVitkOluAFjvPYZRLStiptGB8HqNz6WL/g==
X-Received: by 2002:a05:6a00:1248:b0:4a2:5cba:89cb with SMTP id u8-20020a056a00124800b004a25cba89cbmr4120107pfi.12.1639761256271;
        Fri, 17 Dec 2021 09:14:16 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id lx10sm8976903pjb.45.2021.12.17.09.14.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Dec 2021 09:14:16 -0800 (PST)
Message-ID: <61bcc568.1c69fb81.712e9.7467@mx.google.com>
Date:   Fri, 17 Dec 2021 09:14:16 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.293-7-g5494b85558f4
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/4.9
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.9 baseline: 109 runs,
 2 regressions (v4.9.293-7-g5494b85558f4)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 109 runs, 2 regressions (v4.9.293-7-g5494b855=
58f4)

Regressions Summary
-------------------

platform                 | arch   | lab           | compiler | defconfig   =
        | regressions
-------------------------+--------+---------------+----------+-------------=
--------+------------
minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
nfig    | 1          =

panda                    | arm    | lab-collabora | gcc-10   | omap2plus_de=
fconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.293-7-g5494b85558f4/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.293-7-g5494b85558f4
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      5494b85558f449ba6de244deb0115a9f3d4cd9dc =



Test Regressions
---------------- =



platform                 | arch   | lab           | compiler | defconfig   =
        | regressions
-------------------------+--------+---------------+----------+-------------=
--------+------------
minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
nfig    | 1          =


  Details:     https://kernelci.org/test/plan/id/61bc8c3a9544d44ad839716a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.293-7=
-g5494b85558f4/x86_64/x86_64_defconfig/gcc-10/lab-collabora/baseline-minnow=
board-turbot-E3826.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.293-7=
-g5494b85558f4/x86_64/x86_64_defconfig/gcc-10/lab-collabora/baseline-minnow=
board-turbot-E3826.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61bc8c3a9544d44ad8397=
16b
        failing since 0 day (last pass: v4.9.293-7-g3a18355545cb, first fai=
l: v4.9.293-7-gd89b8545a1fa) =

 =



platform                 | arch   | lab           | compiler | defconfig   =
        | regressions
-------------------------+--------+---------------+----------+-------------=
--------+------------
panda                    | arm    | lab-collabora | gcc-10   | omap2plus_de=
fconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/61bc8ebc6aec3506a2397137

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.293-7=
-g5494b85558f4/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.293-7=
-g5494b85558f4/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61bc8ebc6aec350=
6a239713a
        failing since 0 day (last pass: v4.9.293-7-gd89b8545a1fa, first fai=
l: v4.9.293-7-g534f383585ec)
        2 lines

    2021-12-17T13:20:42.486875  [   20.142883] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-12-17T13:20:42.525136  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, swapper/0/0
    2021-12-17T13:20:42.534588  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
230 [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =20
