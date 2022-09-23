Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE04F5E7F3D
	for <lists+stable@lfdr.de>; Fri, 23 Sep 2022 18:03:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231184AbiIWQDa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Sep 2022 12:03:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229724AbiIWQD3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 23 Sep 2022 12:03:29 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A39F2128482
        for <stable@vger.kernel.org>; Fri, 23 Sep 2022 09:03:28 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id e68so599260pfe.1
        for <stable@vger.kernel.org>; Fri, 23 Sep 2022 09:03:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date;
        bh=lJYz+wX8wgoHUNbDM2yUZlsfiih1DDsiUchlc371hIM=;
        b=bc5/R0we4s2uhuojwbxz3ju3vgEif/+rAxsLtqqZ91Y3Q/v5NXRcfwmLPtMzlxZhfn
         NVKoO4tHJ/sIBgpeIWfXEruxVur4VxD3biHc6CB0JhXSN2YY59IfQ8DSHfipx26ec9wE
         LCdG3deFrO7EtXuJAbFO1o8tH1/opjX2NdQ/VqmKY3DDN9NqXJDeHXG2k2nplPZZ1jgb
         PHixD/r8iHhVRQt+jckgBLYCavlmPXU4CvXxAH+Hib7LeuBK2GHsp/PJ/GUPDrd2kwjL
         6U3W4cM3Ij1MwXYp8U/5X5L9mVLmVwQS4DHr3OH0rM9GRH1XBIjg35YxTsoMOpXfREQE
         R9QQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date;
        bh=lJYz+wX8wgoHUNbDM2yUZlsfiih1DDsiUchlc371hIM=;
        b=FZqo42cNdVVzO1nqp80bmAtsHwpLivlW/fXPcJIs1HHuwAIaiUoBz40lZ/WY+UZM9l
         j74pR0MT1v3nqnRYr7eQIDVAS3tT3kZPtTAaPJf3V49cK8SyYyrRLK/8WIYFWganMkSo
         1RcCGXCek4WcWKw6SU7zwnE22EUTpp2gCMJm+0g9vZ55ljLZ9g303AKs3g8jDGMjnZ1g
         +1p+wshuDTq1Sl6XlV2fFXpOcJKDP5rvHQaQ9oqh8y3mJOi5GAWO+IKTi9sbjDQvlYZd
         riax0e/SN3PnOTxByXezrwnVKjgnQeGDsG5aMJMg6F2Z5DIbRPUn3c8dY28snsiJvab3
         /nuQ==
X-Gm-Message-State: ACrzQf0HQauN1ywSfNlGtn6CILA3m9lPJhmiBps0j3XInH6riinhIwVP
        FuVM8eFyhHguWyzNNnv5iv7LnS7USWsTAFQyycg=
X-Google-Smtp-Source: AMsMyM7wYcxiYCjzgzqtx2y830KLQCHmOxi0KrKJCL1FPyZIBFYHQRMmAeGXanPHQSdw7tOKBNiiCg==
X-Received: by 2002:aa7:8893:0:b0:544:7429:b077 with SMTP id z19-20020aa78893000000b005447429b077mr9904491pfe.69.1663949007850;
        Fri, 23 Sep 2022 09:03:27 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id n10-20020a170902e54a00b00176ca74c58bsm6200666plf.245.2022.09.23.09.03.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Sep 2022 09:03:27 -0700 (PDT)
Message-ID: <632dd8cf.170a0220.e3a7b.caf0@mx.google.com>
Date:   Fri, 23 Sep 2022 09:03:27 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.15
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.15.69-44-g6aec68b9e852
Subject: stable-rc/queue/5.15 baseline: 172 runs,
 5 regressions (v5.15.69-44-g6aec68b9e852)
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

stable-rc/queue/5.15 baseline: 172 runs, 5 regressions (v5.15.69-44-g6aec68=
b9e852)

Regressions Summary
-------------------

platform      | arch | lab          | compiler | defconfig           | regr=
essions
--------------+------+--------------+----------+---------------------+-----=
-------
at91sam9g20ek | arm  | lab-broonie  | gcc-10   | at91_dt_defconfig   | 1   =
       =

at91sam9g20ek | arm  | lab-broonie  | gcc-10   | multi_v5_defconfig  | 1   =
       =

beagle-xm     | arm  | lab-baylibre | gcc-10   | omap2plus_defconfig | 1   =
       =

panda         | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig  | 1   =
       =

panda         | arm  | lab-baylibre | gcc-10   | omap2plus_defconfig | 1   =
       =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.69-44-g6aec68b9e852/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.69-44-g6aec68b9e852
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      6aec68b9e852cbee9fb598fa76c3854481fbdbf7 =



Test Regressions
---------------- =



platform      | arch | lab          | compiler | defconfig           | regr=
essions
--------------+------+--------------+----------+---------------------+-----=
-------
at91sam9g20ek | arm  | lab-broonie  | gcc-10   | at91_dt_defconfig   | 1   =
       =


  Details:     https://kernelci.org/test/plan/id/632da9351c22f28e6f355643

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: at91_dt_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.69-=
44-g6aec68b9e852/arm/at91_dt_defconfig/gcc-10/lab-broonie/baseline-at91sam9=
g20ek.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.69-=
44-g6aec68b9e852/arm/at91_dt_defconfig/gcc-10/lab-broonie/baseline-at91sam9=
g20ek.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/632da9351c22f28e6f355=
644
        failing since 2 days (last pass: v5.15.68-34-gb4f486b4ff9c, first f=
ail: v5.15.69-17-g7d846e6eef7f) =

 =



platform      | arch | lab          | compiler | defconfig           | regr=
essions
--------------+------+--------------+----------+---------------------+-----=
-------
at91sam9g20ek | arm  | lab-broonie  | gcc-10   | multi_v5_defconfig  | 1   =
       =


  Details:     https://kernelci.org/test/plan/id/632da601b6ec28e192355706

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v5_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.69-=
44-g6aec68b9e852/arm/multi_v5_defconfig/gcc-10/lab-broonie/baseline-at91sam=
9g20ek.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.69-=
44-g6aec68b9e852/arm/multi_v5_defconfig/gcc-10/lab-broonie/baseline-at91sam=
9g20ek.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/632da601b6ec28e192355=
707
        failing since 1 day (last pass: v5.15.69-17-g7d846e6eef7f, first fa=
il: v5.15.69-45-g01bb9cc9bf6e) =

 =



platform      | arch | lab          | compiler | defconfig           | regr=
essions
--------------+------+--------------+----------+---------------------+-----=
-------
beagle-xm     | arm  | lab-baylibre | gcc-10   | omap2plus_defconfig | 1   =
       =


  Details:     https://kernelci.org/test/plan/id/632da68acbca49fe9d3556c7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.69-=
44-g6aec68b9e852/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagl=
e-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.69-=
44-g6aec68b9e852/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagl=
e-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/632da68acbca49fe9d355=
6c8
        failing since 1 day (last pass: v5.15.69-17-g7d846e6eef7f, first fa=
il: v5.15.69-45-g01bb9cc9bf6e) =

 =



platform      | arch | lab          | compiler | defconfig           | regr=
essions
--------------+------+--------------+----------+---------------------+-----=
-------
panda         | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig  | 1   =
       =


  Details:     https://kernelci.org/test/plan/id/632dac34eab8e990f5355668

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.69-=
44-g6aec68b9e852/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-panda.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.69-=
44-g6aec68b9e852/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-panda.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/632dac34eab8e990f5355=
669
        failing since 38 days (last pass: v5.15.60-48-g789367af88749, first=
 fail: v5.15.60-779-ge1dae9850fdff) =

 =



platform      | arch | lab          | compiler | defconfig           | regr=
essions
--------------+------+--------------+----------+---------------------+-----=
-------
panda         | arm  | lab-baylibre | gcc-10   | omap2plus_defconfig | 1   =
       =


  Details:     https://kernelci.org/test/plan/id/632daa7ce752469e9d355666

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.69-=
44-g6aec68b9e852/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-panda=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.69-=
44-g6aec68b9e852/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-panda=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/632daa7ce752469e9d355=
667
        failing since 31 days (last pass: v5.15.61-1-geccb923b9eab2, first =
fail: v5.15.62-232-g7f3b8845612d) =

 =20
