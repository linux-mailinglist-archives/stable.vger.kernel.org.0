Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F06636C24C0
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 23:27:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229668AbjCTW1H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 18:27:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229679AbjCTW1G (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 18:27:06 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 999231A956
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 15:26:50 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id p13-20020a17090a284d00b0023d2e945aebso351637pjf.0
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 15:26:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112; t=1679351210;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=7sYy9voLsfRvOmz/4epaOa+3MBWImlW2gyaA6KGSiMI=;
        b=ZcB/iDCMKm5nEIlI2OiSWorQFY8fTMNBxhFA3Rg25EbNLtSYDV2FznEfDceiiUsNrG
         V4H3ZDm/M0bIc4QNSsWmt/ISmY43Jy2e8GlGJCkhzvgXhyQ+PrrVwP5R0Lh/Ab95MM12
         ft2cs9GKN940PX0Sglpi62ojMzx87YrtPQ0ldmfpYGEBPaLPBxmkaDX59v5sE4/WSSvE
         eOe74ftFjie+ph98c5ag+8pTi9MpGxXG6MYV1XwJloLby4kG3ApdIavGtAPWL2ojL5Ic
         0mL19tr/d4GPPSn7NW3LtRQQu8ZNg0fwz53g2oR7lzTMsz5FsoNoH4JxmjH6XoTnkH17
         K8cQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679351210;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7sYy9voLsfRvOmz/4epaOa+3MBWImlW2gyaA6KGSiMI=;
        b=lXMDWrDldQuIQhlp2x+GnTvVP7fyr/RoX0CE7akzKHKtFB5W9Reqz+LS0CPQBXKvtF
         XqtM9L5dQpIBq/CSIxZjiRzwGmw61pQAvF+lfTlKBS/A3YpUQGxJYfRTU6MMtRCFDEjI
         G5YRI7+FlFSDWr4hlYx9s3HKSbaR98HMoGQWc0shw1y/mN93gjNdq5ja4L57oqxMeNN6
         JRIrMl0HpZvSWxKVMLYAvvzqU2HOprsAEqo5c9Sq5hALnMjhESoYdz/dH3zga0aniAEH
         cYzB6O5gg5W1NUw522skIETBEvsitUiAyDVNjhkYdekHk2O1cbxYPJcNsXzUVeodJbSo
         hU7g==
X-Gm-Message-State: AO0yUKVNe6dJsMYSXvLxMs7V0JMEOtUV99dLNu4Rbkc1neIdyaYezxpF
        rS4EWcc+MqEUeJM+7SiSAeu2zSEeS0IQxOdyIeg=
X-Google-Smtp-Source: AK7set/3yR7fhYk/GCN3sr6ryqIOXIQLz/BprEOHisypAbOZibfLSklwiI1iWYkPyI/v9EPZ7dqJNQ==
X-Received: by 2002:a05:6a20:b704:b0:d9:cde:d2a9 with SMTP id fg4-20020a056a20b70400b000d90cded2a9mr79592pzb.20.1679351209757;
        Mon, 20 Mar 2023 15:26:49 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id s14-20020a62e70e000000b00625ddb1f4c5sm6806492pfh.114.2023.03.20.15.26.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Mar 2023 15:26:49 -0700 (PDT)
Message-ID: <6418dda9.620a0220.e5d63.bafb@mx.google.com>
Date:   Mon, 20 Mar 2023 15:26:49 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/6.1
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v6.1.20-199-g6cf974ec371c0
Subject: stable-rc/queue/6.1 baseline: 169 runs,
 3 regressions (v6.1.20-199-g6cf974ec371c0)
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

stable-rc/queue/6.1 baseline: 169 runs, 3 regressions (v6.1.20-199-g6cf974e=
c371c0)

Regressions Summary
-------------------

platform           | arch  | lab         | compiler | defconfig         | r=
egressions
-------------------+-------+-------------+----------+-------------------+--=
----------
bcm2835-rpi-b-rev2 | arm   | lab-broonie | gcc-10   | bcm2835_defconfig | 1=
          =

kontron-pitx-imx8m | arm64 | lab-kontron | gcc-10   | defconfig         | 2=
          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F6.1/kern=
el/v6.1.20-199-g6cf974ec371c0/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/6.1
  Describe: v6.1.20-199-g6cf974ec371c0
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      6cf974ec371c04dde909f695957625f49a7229d3 =



Test Regressions
---------------- =



platform           | arch  | lab         | compiler | defconfig         | r=
egressions
-------------------+-------+-------------+----------+-------------------+--=
----------
bcm2835-rpi-b-rev2 | arm   | lab-broonie | gcc-10   | bcm2835_defconfig | 1=
          =


  Details:     https://kernelci.org/test/plan/id/6418a4f32473a4b31a8c862f

  Results:     50 PASS, 2 FAIL, 1 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.20-19=
9-g6cf974ec371c0/arm/bcm2835_defconfig/gcc-10/lab-broonie/baseline-bcm2835-=
rpi-b-rev2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.20-19=
9-g6cf974ec371c0/arm/bcm2835_defconfig/gcc-10/lab-broonie/baseline-bcm2835-=
rpi-b-rev2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6418a4f32473a4b31a8c8665
        failing since 0 day (last pass: v6.1.20-142-g50c2c02e4ebf, first fa=
il: v6.1.20-190-gfb3ddaa27aa7)

    2023-03-20T18:24:34.953899  + set +x
    2023-03-20T18:24:34.957712  <8>[   17.880484] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 196031_1.5.2.4.1>
    2023-03-20T18:24:35.072783  / # #
    2023-03-20T18:24:35.175428  export SHELL=3D/bin/sh
    2023-03-20T18:24:35.176223  #
    2023-03-20T18:24:35.278190  / # export SHELL=3D/bin/sh. /lava-196031/en=
vironment
    2023-03-20T18:24:35.278870  =

    2023-03-20T18:24:35.380825  / # . /lava-196031/environment/lava-196031/=
bin/lava-test-runner /lava-196031/1
    2023-03-20T18:24:35.381841  =

    2023-03-20T18:24:35.387826  / # /lava-196031/bin/lava-test-runner /lava=
-196031/1 =

    ... (14 line(s) more)  =

 =



platform           | arch  | lab         | compiler | defconfig         | r=
egressions
-------------------+-------+-------------+----------+-------------------+--=
----------
kontron-pitx-imx8m | arm64 | lab-kontron | gcc-10   | defconfig         | 2=
          =


  Details:     https://kernelci.org/test/plan/id/6418acd55420c67be48c864c

  Results:     50 PASS, 2 FAIL, 1 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.20-19=
9-g6cf974ec371c0/arm64/defconfig/gcc-10/lab-kontron/baseline-kontron-pitx-i=
mx8m.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.20-19=
9-g6cf974ec371c0/arm64/defconfig/gcc-10/lab-kontron/baseline-kontron-pitx-i=
mx8m.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6418acd55420c67be48c8653
        failing since 0 day (last pass: v6.1.19-139-g6d04fa2f2978, first fa=
il: v6.1.20-142-g50c2c02e4ebf)

    2023-03-20T18:58:07.783950  / # #
    2023-03-20T18:58:07.885031  export SHELL=3D/bin/sh
    2023-03-20T18:58:07.885236  #
    2023-03-20T18:58:07.986180  / # export SHELL=3D/bin/sh. /lava-299455/en=
vironment
    2023-03-20T18:58:07.986379  =

    2023-03-20T18:58:08.087337  / # . /lava-299455/environment/lava-299455/=
bin/lava-test-runner /lava-299455/1
    2023-03-20T18:58:08.087702  =

    2023-03-20T18:58:08.098055  / # /lava-299455/bin/lava-test-runner /lava=
-299455/1
    2023-03-20T18:58:08.157009  + export 'TESTRUN_ID=3D1_bootrr'
    2023-03-20T18:58:08.157225  + cd /l<8>[   14.508474] <LAVA_SIGNAL_START=
RUN 1_bootrr 299455_1.5.2.4.5> =

    ... (10 line(s) more)  =


  * baseline.bootrr.dwc3-usb1-probed: https://kernelci.org/test/case/id/641=
8acd55420c67be48c8663
        failing since 0 day (last pass: v6.1.19-139-g6d04fa2f2978, first fa=
il: v6.1.20-142-g50c2c02e4ebf)

    2023-03-20T18:58:10.506493  /lava-299455/1/../bin/lava-test-case
    2023-03-20T18:58:10.506980  <8>[   16.952500] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwc3-usb1-probed RESULT=3Dfail>
    2023-03-20T18:58:10.507387  /lava-299455/1/../bin/lava-test-case   =

 =20
