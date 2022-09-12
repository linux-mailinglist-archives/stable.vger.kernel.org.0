Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 585205B6463
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 01:54:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229670AbiILXy1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Sep 2022 19:54:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229932AbiILXyZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Sep 2022 19:54:25 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 750E751438
        for <stable@vger.kernel.org>; Mon, 12 Sep 2022 16:54:24 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id jm11so10061601plb.13
        for <stable@vger.kernel.org>; Mon, 12 Sep 2022 16:54:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date;
        bh=usdus48ag+OL/KhbeqncR6II8hwbL5d09epLXTTNqMY=;
        b=D4s9SCzaXDShbvL12Msl99OFxdEGhbS38yCyO2iXKnLYLHlCsoFR4irKljg625DS0U
         QUZFrPn1rG8XCqc1TP2Nw/KXKjPMMHOg7igRKPSBMXuf7ZKADg2jeHbXYn6Z2nOqfZEj
         t//c8ZgQlfRtovtIvtk87cT0Uy+Z5T/5yiPITZsGMoEAelLjgi+U25R/yjlYYCuVos2/
         h32pA/IyTwqXKptKGWM+yEyMJ2KNXsjXL2jrUGPD5JuVbkhNAUn6kA5adXx0vQCUJkvN
         ml0690moXkk1sWzW7IC4r27YKPIPWuu04yEAEQkU8GB1N9e5Zsx1LHvefxcy/SA/BaoR
         rg0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date;
        bh=usdus48ag+OL/KhbeqncR6II8hwbL5d09epLXTTNqMY=;
        b=KfvyLjPEnrWp8YIF0Vi0IjjWduTl4HCefMIhVt28kLs89rCHe9lSZjIEUt12CROXOB
         0bbMUJVZEgQ5CBe08AyiwFOjlHHozS/bCvayrH8BFcoEtS0VyVoYHKPKci/8EUjV1BIa
         4vWJh/y/3iTD/37YbzFKyCO3MnKqS5WA4fABLHb2rXYizXAoOMhiVSrjZ0/K09TXLjQB
         9eZh98Iw8Tqe5z2MhVBVtfqv4Eg4fe1aBWa8KFPOeTcKxlzb4mgvm/pe2WbRds2THxjg
         pSFzTXGP2RMTh34e5HigaHN7Q/axvrtfBJs1AA2km1k3XDUUlw8Hcqm694VhkPNXDA1c
         CeNQ==
X-Gm-Message-State: ACgBeo354X+3AEpl4DFHBmLx1V418zZrj7PK8LX+zU+janHRZyv1QR20
        ga7F2TvSZdT1BU88i5dwDBKymTuKXvtGrnQ5Ln8=
X-Google-Smtp-Source: AA6agR6AJA0VsY28Q6jplABkLrHefTjDfMhJihbbSq6LE2c8gYQBKZ7FOYpEuPQU4hzwY+aFIDOlVQ==
X-Received: by 2002:a17:90b:2712:b0:1fa:fe17:16db with SMTP id px18-20020a17090b271200b001fafe1716dbmr917111pjb.165.1663026863726;
        Mon, 12 Sep 2022 16:54:23 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id f62-20020a623841000000b00541c68a0689sm5365892pfa.7.2022.09.12.16.54.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Sep 2022 16:54:23 -0700 (PDT)
Message-ID: <631fc6af.620a0220.e450a.8884@mx.google.com>
Date:   Mon, 12 Sep 2022 16:54:23 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.19
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.19.8-190-g006ae7d3df80a
Subject: stable-rc/queue/5.19 baseline: 186 runs,
 2 regressions (v5.19.8-190-g006ae7d3df80a)
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

stable-rc/queue/5.19 baseline: 186 runs, 2 regressions (v5.19.8-190-g006ae7=
d3df80a)

Regressions Summary
-------------------

platform           | arch | lab             | compiler | defconfig         =
  | regressions
-------------------+------+-----------------+----------+-------------------=
--+------------
imx6ul-pico-hobbit | arm  | lab-pengutronix | gcc-10   | imx_v6_v7_defconfi=
g | 1          =

imx7d-sdb          | arm  | lab-nxp         | gcc-10   | imx_v6_v7_defconfi=
g | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.19/ker=
nel/v5.19.8-190-g006ae7d3df80a/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.19
  Describe: v5.19.8-190-g006ae7d3df80a
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      006ae7d3df80a5cdc6e61e1b28481628cdc49b1b =



Test Regressions
---------------- =



platform           | arch | lab             | compiler | defconfig         =
  | regressions
-------------------+------+-----------------+----------+-------------------=
--+------------
imx6ul-pico-hobbit | arm  | lab-pengutronix | gcc-10   | imx_v6_v7_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/631fa57e9da0d25b7c355653

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.8-1=
90-g006ae7d3df80a/arm/imx_v6_v7_defconfig/gcc-10/lab-pengutronix/baseline-i=
mx6ul-pico-hobbit.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.8-1=
90-g006ae7d3df80a/arm/imx_v6_v7_defconfig/gcc-10/lab-pengutronix/baseline-i=
mx6ul-pico-hobbit.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/631fa57e9da0d25b7c355=
654
        failing since 27 days (last pass: v5.19.1-1157-g615e53e38bef5, firs=
t fail: v5.19.1-1159-g6c70b627ef512) =

 =



platform           | arch | lab             | compiler | defconfig         =
  | regressions
-------------------+------+-----------------+----------+-------------------=
--+------------
imx7d-sdb          | arm  | lab-nxp         | gcc-10   | imx_v6_v7_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/631f93d1e00f8dc0c0355653

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.8-1=
90-g006ae7d3df80a/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx7d-sdb=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.8-1=
90-g006ae7d3df80a/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx7d-sdb=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/631f93d1e00f8dc0c0355=
654
        failing since 0 day (last pass: v5.19.4-389-gf2d8facb7bd4, first fa=
il: v5.19.8-186-g25c29f8a1cae5) =

 =20
