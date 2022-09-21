Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6CC35E56D4
	for <lists+stable@lfdr.de>; Thu, 22 Sep 2022 01:45:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229804AbiIUXpu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Sep 2022 19:45:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229816AbiIUXps (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Sep 2022 19:45:48 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6DDBA060B
        for <stable@vger.kernel.org>; Wed, 21 Sep 2022 16:45:46 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id f23so7190111plr.6
        for <stable@vger.kernel.org>; Wed, 21 Sep 2022 16:45:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date;
        bh=3/GnkukxXQNi2jUbHAmp4+TZPwXnv0Uh/y0G1akwkF8=;
        b=b0yj7E2268YpRVzIxy5rpfZoIO/p13jHelgXbKwoWBLrTHXajniljfPxefr8sYP7Pk
         WQ/imq/vBxDktlq3jiXHF+FN6ZY29CRiGgMVMjuRCqkgQYtihc76F6LPeyqGPbjqFjzX
         njmNRWgYolIzC3iJuB+r13eUhRno6QF4PRVqzPZCU1AkMOqvGXr4QWzzPWQePjIal7/x
         ZlwLH+4jj/aZCBkR/vn2djoEX9UmDo5obyedk7eumfZuyXwmCfuMpFMelkW6ivmPOvEV
         gNFCZS4w2cBsoXbVL1JISlpdDKwMwg/zxtalOYFAh+09dr0ecvtAuHfLwDDo0cjxSXBm
         maWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date;
        bh=3/GnkukxXQNi2jUbHAmp4+TZPwXnv0Uh/y0G1akwkF8=;
        b=iv4wwhy3SFvYaqJBPiQX/qiOEpVtKVuJIWoGhDxdEnhdKMDirmdhFP2S5DQEleOOAX
         GybXFD0dVHPNEgHyaP6AnggpKep/bVtwB5edyE76VQE1NaF2zMYB4va9CpmQpl5x4ELn
         EK/caIxsmREXS363Vb475D/yiQ3/krB7dUd2yB+Jh0Uwf/eZ2PzN6y/A1mICRPZFFfnx
         rKsAKtKC6gAQQN6P93KsowrHmT5gLkjiP/K2VRqV0WOgjTQs2Jd3ceuSPD2MESmWhY3C
         UuxLrEYg1dmxl1PIFf1AaGsl2mIZ0zkTkspYqVCWCu5jWs3p+kXW5n8cbo0t1n6xugL+
         FL6A==
X-Gm-Message-State: ACrzQf1f+2+IayYk0k+N4Z+BOYnqsyxfCSYkgrYzkGrFboV/9t85XVW7
        6GObzYaO7D6PaK6lGVjdP1+uDXQOkmtSjFy2itE=
X-Google-Smtp-Source: AMsMyM7m3zFMVuaeFALRxJjvFsgUtt9Gh4kVKOzsJDoyNH3IqZ1kGI97RpycgaQJ7EQs9MWLYAIqJg==
X-Received: by 2002:a17:902:e88c:b0:176:a427:be6a with SMTP id w12-20020a170902e88c00b00176a427be6amr632686plg.150.1663803946105;
        Wed, 21 Sep 2022 16:45:46 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id r15-20020a170903020f00b00174ea015ee2sm2610045plh.38.2022.09.21.16.45.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Sep 2022 16:45:45 -0700 (PDT)
Message-ID: <632ba229.170a0220.85ec7.5cac@mx.google.com>
Date:   Wed, 21 Sep 2022 16:45:45 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.15
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.15.69-45-g01bb9cc9bf6e
Subject: stable-rc/queue/5.15 baseline: 174 runs,
 5 regressions (v5.15.69-45-g01bb9cc9bf6e)
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

stable-rc/queue/5.15 baseline: 174 runs, 5 regressions (v5.15.69-45-g01bb9c=
c9bf6e)

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
nel/v5.15.69-45-g01bb9cc9bf6e/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.69-45-g01bb9cc9bf6e
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      01bb9cc9bf6e7ef10c981d7de4079c126e098e24 =



Test Regressions
---------------- =



platform      | arch | lab          | compiler | defconfig           | regr=
essions
--------------+------+--------------+----------+---------------------+-----=
-------
at91sam9g20ek | arm  | lab-broonie  | gcc-10   | at91_dt_defconfig   | 1   =
       =


  Details:     https://kernelci.org/test/plan/id/632b6d363cf9f6c611355659

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: at91_dt_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.69-=
45-g01bb9cc9bf6e/arm/at91_dt_defconfig/gcc-10/lab-broonie/baseline-at91sam9=
g20ek.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.69-=
45-g01bb9cc9bf6e/arm/at91_dt_defconfig/gcc-10/lab-broonie/baseline-at91sam9=
g20ek.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/632b6d363cf9f6c611355=
65a
        failing since 1 day (last pass: v5.15.68-34-gb4f486b4ff9c, first fa=
il: v5.15.69-17-g7d846e6eef7f) =

 =



platform      | arch | lab          | compiler | defconfig           | regr=
essions
--------------+------+--------------+----------+---------------------+-----=
-------
at91sam9g20ek | arm  | lab-broonie  | gcc-10   | multi_v5_defconfig  | 1   =
       =


  Details:     https://kernelci.org/test/plan/id/632b6e8b7ce3365c61355684

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v5_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.69-=
45-g01bb9cc9bf6e/arm/multi_v5_defconfig/gcc-10/lab-broonie/baseline-at91sam=
9g20ek.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.69-=
45-g01bb9cc9bf6e/arm/multi_v5_defconfig/gcc-10/lab-broonie/baseline-at91sam=
9g20ek.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/632b6e8b7ce3365c61355=
685
        new failure (last pass: v5.15.69-17-g7d846e6eef7f) =

 =



platform      | arch | lab          | compiler | defconfig           | regr=
essions
--------------+------+--------------+----------+---------------------+-----=
-------
beagle-xm     | arm  | lab-baylibre | gcc-10   | omap2plus_defconfig | 1   =
       =


  Details:     https://kernelci.org/test/plan/id/632b6f8cb480390cd5355671

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.69-=
45-g01bb9cc9bf6e/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagl=
e-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.69-=
45-g01bb9cc9bf6e/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagl=
e-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/632b6f8cb480390cd5355=
672
        new failure (last pass: v5.15.69-17-g7d846e6eef7f) =

 =



platform      | arch | lab          | compiler | defconfig           | regr=
essions
--------------+------+--------------+----------+---------------------+-----=
-------
panda         | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig  | 1   =
       =


  Details:     https://kernelci.org/test/plan/id/632b757bb8aca590d6355642

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.69-=
45-g01bb9cc9bf6e/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-panda.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.69-=
45-g01bb9cc9bf6e/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-panda.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/632b757bb8aca590d6355=
643
        failing since 36 days (last pass: v5.15.60-48-g789367af88749, first=
 fail: v5.15.60-779-ge1dae9850fdff) =

 =



platform      | arch | lab          | compiler | defconfig           | regr=
essions
--------------+------+--------------+----------+---------------------+-----=
-------
panda         | arm  | lab-baylibre | gcc-10   | omap2plus_defconfig | 1   =
       =


  Details:     https://kernelci.org/test/plan/id/632b7015bd1255b854355686

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.69-=
45-g01bb9cc9bf6e/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-panda=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.69-=
45-g01bb9cc9bf6e/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-panda=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/632b7015bd1255b854355=
687
        failing since 29 days (last pass: v5.15.61-1-geccb923b9eab2, first =
fail: v5.15.62-232-g7f3b8845612d) =

 =20
