Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA53A5F210F
	for <lists+stable@lfdr.de>; Sun,  2 Oct 2022 04:37:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229542AbiJBChQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 1 Oct 2022 22:37:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbiJBChO (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 1 Oct 2022 22:37:14 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1F614F1B8
        for <stable@vger.kernel.org>; Sat,  1 Oct 2022 19:37:13 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id o59-20020a17090a0a4100b0020a6d5803dfso2534019pjo.4
        for <stable@vger.kernel.org>; Sat, 01 Oct 2022 19:37:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date;
        bh=ofHGIHcc3N3yEHq538K6TE0cERxAEVBlbUYKYSIPiV0=;
        b=H0bb1D5/uhkSiu+7+7tG+wIeIlQna7yDYMONjXUJUKR0OKNF45/Wv3QMeF637oGkgj
         RrsaKofrNRUgTpXkZHI5MOwbYbuioe4Y6d1bdwYk+FMTtnLhMluhk6sf06wMNViPce8D
         v6Pvo3y6l5TQmTazRlND+gnJdPxZh4UNOVZrRlBWHcjAtqbnIal/QE221HVDobN9Ngm6
         ErbS7ieJEILhEsqxFN+UarO2i1/95W2IFEq1s88xKXpM7JusESXm89xt5DLzB1GoVeaU
         xvaV2haWKlG7ivpIfxZiBl3anMRtRF3mGRQWbyBkPyiCCIIWao4aDtNu06llQDYOP8qw
         nuyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date;
        bh=ofHGIHcc3N3yEHq538K6TE0cERxAEVBlbUYKYSIPiV0=;
        b=3z3aUeI+8a+UptceN/HKjvcUkDwwP/SF2PMHC/8P8CJIBO/t4n8TTcC3xpN2Pw2MR9
         4OX0P83jvsAIcFbF9nw9CIwKUHirIK2yMrNbTmLLM/MIcoxX2p+Ly3/grX73cY+xTsw+
         6kSonUx+jst+UtMwECnOtDVvIdqEpl5IRSID2J+IKcRG+JaY+KCpIjWNuwcVl84gzqbM
         UCR05mwnCvNw1iEHBav9RfRE/7nbMrzUq/7zcdbmrM0G8dGTTSJcsiYto+CE7+RRDvyC
         KqwRLndmaWSINLPgdB2sEOKLZqQ8M4loFUVs6D45EO5cKBlktv4Ch5f8PnTODT2G7W60
         3/Uw==
X-Gm-Message-State: ACrzQf1qufTD2M+0rb9vjpl/D1mcksOw2ePHC7U7jyOXyNKGRaK10+gL
        sJrdZ5rkWk/r1H/zN2gBxHSTqqvZouboR/kJwrk=
X-Google-Smtp-Source: AMsMyM67F7+wtXlN1BWh0dt06q7EpQqfLuEiXFQmE9HoaPD0EsG3/KYioR6jM3P3pz7Tl0ty49CvRw==
X-Received: by 2002:a17:90a:f8f:b0:20a:302f:92b8 with SMTP id 15-20020a17090a0f8f00b0020a302f92b8mr5625072pjz.80.1664678233155;
        Sat, 01 Oct 2022 19:37:13 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id o190-20020a625ac7000000b0052d4b0d0c74sm4455359pfb.70.2022.10.01.19.37.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 01 Oct 2022 19:37:12 -0700 (PDT)
Message-ID: <6338f958.620a0220.70fe6.7e4a@mx.google.com>
Date:   Sat, 01 Oct 2022 19:37:12 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.15.71-6-g484b1d27e3e0d
X-Kernelci-Branch: queue/5.15
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.15 baseline: 177 runs,
 4 regressions (v5.15.71-6-g484b1d27e3e0d)
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

stable-rc/queue/5.15 baseline: 177 runs, 4 regressions (v5.15.71-6-g484b1d2=
7e3e0d)

Regressions Summary
-------------------

platform    | arch | lab          | compiler | defconfig           | regres=
sions
------------+------+--------------+----------+---------------------+-------=
-----
imx7ulp-evk | arm  | lab-nxp      | gcc-10   | imx_v6_v7_defconfig | 1     =
     =

imx7ulp-evk | arm  | lab-nxp      | gcc-10   | multi_v7_defconfig  | 1     =
     =

panda       | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig  | 1     =
     =

panda       | arm  | lab-baylibre | gcc-10   | omap2plus_defconfig | 1     =
     =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.71-6-g484b1d27e3e0d/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.71-6-g484b1d27e3e0d
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      484b1d27e3e0dfc49e2ae069e89c6a4a74f6a5f1 =



Test Regressions
---------------- =



platform    | arch | lab          | compiler | defconfig           | regres=
sions
------------+------+--------------+----------+---------------------+-------=
-----
imx7ulp-evk | arm  | lab-nxp      | gcc-10   | imx_v6_v7_defconfig | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/6338c69c3eab76c045ec4ea6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.71-=
6-g484b1d27e3e0d/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-ev=
k.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.71-=
6-g484b1d27e3e0d/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-ev=
k.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6338c69c3eab76c045ec4=
ea7
        failing since 6 days (last pass: v5.15.70-117-g5ae36aa8ead6e, first=
 fail: v5.15.70-133-gbad831d5b9cf) =

 =



platform    | arch | lab          | compiler | defconfig           | regres=
sions
------------+------+--------------+----------+---------------------+-------=
-----
imx7ulp-evk | arm  | lab-nxp      | gcc-10   | multi_v7_defconfig  | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/6338c9aa6292083310ec4edc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.71-=
6-g484b1d27e3e0d/arm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-evk=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.71-=
6-g484b1d27e3e0d/arm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-evk=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6338c9aa6292083310ec4=
edd
        failing since 6 days (last pass: v5.15.69-44-g09c929d3da79, first f=
ail: v5.15.70-123-gaf951c1b9b36) =

 =



platform    | arch | lab          | compiler | defconfig           | regres=
sions
------------+------+--------------+----------+---------------------+-------=
-----
panda       | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig  | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/6338ca5cdccff1f39eec4ebf

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.71-=
6-g484b1d27e3e0d/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-panda.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.71-=
6-g484b1d27e3e0d/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-panda.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6338ca5cdccff1f39eec4=
ec0
        failing since 47 days (last pass: v5.15.60-48-g789367af88749, first=
 fail: v5.15.60-779-ge1dae9850fdff) =

 =



platform    | arch | lab          | compiler | defconfig           | regres=
sions
------------+------+--------------+----------+---------------------+-------=
-----
panda       | arm  | lab-baylibre | gcc-10   | omap2plus_defconfig | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/6338c87b4da708a067ec4ea8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.71-=
6-g484b1d27e3e0d/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-panda=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.71-=
6-g484b1d27e3e0d/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-panda=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6338c87b4da708a067ec4=
ea9
        failing since 39 days (last pass: v5.15.61-1-geccb923b9eab2, first =
fail: v5.15.62-232-g7f3b8845612d) =

 =20
