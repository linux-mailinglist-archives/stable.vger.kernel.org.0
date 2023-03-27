Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2A046C9B07
	for <lists+stable@lfdr.de>; Mon, 27 Mar 2023 07:44:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232009AbjC0FoF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Mar 2023 01:44:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229577AbjC0FoE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Mar 2023 01:44:04 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEEEC4C1F
        for <stable@vger.kernel.org>; Sun, 26 Mar 2023 22:44:03 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id l7so6601545pjg.5
        for <stable@vger.kernel.org>; Sun, 26 Mar 2023 22:44:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112; t=1679895843;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=dJzkpOvcu2N05/0L5RlWW/pMxOcuYrC3DSljNO9ults=;
        b=y+mD4mbAU7v4Of9dAVaqj+FY/ZjgnvQkcMz0bZVNjvjfuneRxNu1YQwAKHrp5VIsB+
         0NBmpniwg61xwpAMALKaHcsvUJq69BPa4h7bSmlYeBBWIUc/ay0v0/asiBrvhLBl727r
         WRr5sc49IYOxgH7iGlh5N5UT+hrSe+UUl5FK+X6+7bxl6fDkRDArPvxpUWkfnC28BnAc
         ffl9tx5MTcgzx5r5nSPX9v16jioGMIs5Z6xWFfLxPV5oK/pjyDPjYV7v16kI/Nw/eCr/
         L1TecG9+EzOGznxWZuDB4cMhwIsthYLEEAO3sbqyUJ5LOtvGfql2vdB/iEK+Jhr5yOnT
         IbLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679895843;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dJzkpOvcu2N05/0L5RlWW/pMxOcuYrC3DSljNO9ults=;
        b=e7lR58ci5CpbADO+jEpERFwqwf7GA0y6hMohLyEtQQBWRG35ESEvufRKGDZSpRKFjv
         +m/Uw8vfjAM9SI5dKMzF3e0rCoYYrmEGAV3AsbIuWMDBnoxsTT7zPuFntIYJ+IaERYCW
         AK9/zgjaL3i5W16SUY4NJ8TU0jORXEr2pTtwgli8sZMt+VybVkBLrMSwzqfiVEN8z9jc
         JVFrFb5uTr1ILTK6xYJdeP1peN0xU4be/WkszlGUAGRAxNsClqaGfvioS7LN6OAUf9YE
         JxFpm6BmjhkqleQ3f2kuujtIhat29fh6gUtosXAhbI98hs4BCWCSev7ZJ8HPmltw9zBS
         YjFw==
X-Gm-Message-State: AAQBX9dJXdgasduORuOP5IButeV9JZ7+o7hKcHXwr92H8RwvlBkeHlD3
        PX4+RdkG90fSpO2qK1LUIIoXOYLL7bvU5/H5Tjo=
X-Google-Smtp-Source: AKy350YKFR8aSmhMoXciN7S3EOJP7iqRNS6+uN9iMsStRKPGvXvfL14fahqllp9QotWsjbK9egQdEw==
X-Received: by 2002:a17:90a:3e46:b0:237:2edb:d4e3 with SMTP id t6-20020a17090a3e4600b002372edbd4e3mr12519042pjm.27.1679895843260;
        Sun, 26 Mar 2023 22:44:03 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id iz4-20020a170902ef8400b0019f9fd5c24asm18175317plb.207.2023.03.26.22.44.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Mar 2023 22:44:02 -0700 (PDT)
Message-ID: <64212d22.170a0220.c0c70.0d08@mx.google.com>
Date:   Sun, 26 Mar 2023 22:44:02 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.15
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.15.104-69-g7f2bf21c3195
Subject: stable-rc/queue/5.15 baseline: 114 runs,
 2 regressions (v5.15.104-69-g7f2bf21c3195)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.15 baseline: 114 runs, 2 regressions (v5.15.104-69-g7f2bf=
21c3195)

Regressions Summary
-------------------

platform   | arch | lab          | compiler | defconfig           | regress=
ions
-----------+------+--------------+----------+---------------------+--------=
----
beagle-xm  | arm  | lab-baylibre | gcc-10   | omap2plus_defconfig | 1      =
    =

cubietruck | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig  | 1      =
    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.104-69-g7f2bf21c3195/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.104-69-g7f2bf21c3195
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      7f2bf21c319507e6245c490b74d703169aa6248e =



Test Regressions
---------------- =



platform   | arch | lab          | compiler | defconfig           | regress=
ions
-----------+------+--------------+----------+---------------------+--------=
----
beagle-xm  | arm  | lab-baylibre | gcc-10   | omap2plus_defconfig | 1      =
    =


  Details:     https://kernelci.org/test/plan/id/6420f5e3462189b3929c950d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.104=
-69-g7f2bf21c3195/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beag=
le-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.104=
-69-g7f2bf21c3195/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beag=
le-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6420f5e3462189b3929c9=
50e
        failing since 51 days (last pass: v5.15.91-12-g3290f78df1ab, first =
fail: v5.15.91-18-ga7afd81d41cb) =

 =



platform   | arch | lab          | compiler | defconfig           | regress=
ions
-----------+------+--------------+----------+---------------------+--------=
----
cubietruck | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig  | 1      =
    =


  Details:     https://kernelci.org/test/plan/id/6420f6c34c29a3287f9c951e

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.104=
-69-g7f2bf21c3195/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubie=
truck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.104=
-69-g7f2bf21c3195/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubie=
truck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6420f6c34c29a3287f9c9527
        failing since 68 days (last pass: v5.15.82-123-gd03dbdba21ef, first=
 fail: v5.15.87-100-ge215d5ead661)

    2023-03-27T01:51:37.268205  <8>[    9.931721] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3447624_1.5.2.4.1>
    2023-03-27T01:51:37.380784  / # #
    2023-03-27T01:51:37.484827  export SHELL=3D/bin/sh
    2023-03-27T01:51:37.485682  #
    2023-03-27T01:51:37.587702  / # export SHELL=3D/bin/sh. /lava-3447624/e=
nvironment
    2023-03-27T01:51:37.588710  =

    2023-03-27T01:51:37.690847  / # . /lava-3447624/environment/lava-344762=
4/bin/lava-test-runner /lava-3447624/1
    2023-03-27T01:51:37.692779  =

    2023-03-27T01:51:37.693307  / # <3>[   10.273287] Bluetooth: hci0: comm=
and 0x0c03 tx timeout
    2023-03-27T01:51:37.697195  /lava-3447624/bin/lava-test-runner /lava-34=
47624/1 =

    ... (12 line(s) more)  =

 =20
