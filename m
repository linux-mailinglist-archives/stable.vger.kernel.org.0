Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 598A36E3A80
	for <lists+stable@lfdr.de>; Sun, 16 Apr 2023 19:27:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229568AbjDPR1N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 16 Apr 2023 13:27:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229575AbjDPR1M (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 16 Apr 2023 13:27:12 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87F05A6
        for <stable@vger.kernel.org>; Sun, 16 Apr 2023 10:27:09 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id w1so460699plg.6
        for <stable@vger.kernel.org>; Sun, 16 Apr 2023 10:27:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20221208.gappssmtp.com; s=20221208; t=1681666028; x=1684258028;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=7U7pVuAJ2jxR63wcnWmwOIBlZvWe2S7iDigbnsLWdec=;
        b=Q7o+0xC4HfmgR5cV/3o5UeiOhUYZ2TiILsYzayXqaxISt7x2G9IPeWZiNnE9zSuqE3
         o5FPGNFcdY7h1zPNrZvLCGTqiYqMZA5RVX0L/wcUfSWXEVSbCec0f0QjWLAAHPci8L7N
         NBVCpRLpF1xXbdEXLlJwDlBznhD4eHH3+X+/sXjN4ZGHzzShTOyxkZHAjloEavmeExRP
         PpPtM07ZMnUvWS5J7MmuViACr21jdNSRNgkpBpB/0UT7ee78jR0GwzAJ8dIZ6mGVtJtx
         UepcYmzwgYFH7ui+zgKJT9rbZ+4Heo9NNQM2QiXEZ2ngR6PDXzv7mKvlGf0Q5w2oc4wq
         q6+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681666028; x=1684258028;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7U7pVuAJ2jxR63wcnWmwOIBlZvWe2S7iDigbnsLWdec=;
        b=SIdcwrG7zID28MyArAHbcDWqw/4/buKtofRfq+O7aFZY0k6ph5QtolD9Fb2X58tpP4
         vwnB5rwisBJNDdI06E+l09cpC9kkFUhHV8kA2c3pOcQK/NhKUs2v2F7bdzppYY+FzMUE
         6sGyleZ9KmE4ijXIPnnKun5XkLJmOtZbRo0tuBdxLvKc8J3QBt1oHuuKXxY1k13XhgO1
         +np+p6jM9/zZZFezzyBtzIOARpcSSInXGqW8qioNYmqUnkTuPWPPzmbTwLFNE8TE67Uh
         tOUGfwX2cbcYLqCbPlfmhDC4aTq0BwmNtkrW05Hn4Sb6khoPi8utfgx17RwBCgCaTz0Q
         Gx9A==
X-Gm-Message-State: AAQBX9fuh44A9f22TGnOIxpjL6K9Ikh/Gy7bujHQLFkioycSUyeUDGvf
        SGkrsQ/MumBnfoECw0jiv5Psh+k7XcGnGzw+XkaD40gu
X-Google-Smtp-Source: AKy350YIIGoPsP5M3DaP5KO/BobwklXJRiok0Fivr1AlUIWf+2aGmr3WbyX6mRYKJFI6CfqgN2OYMw==
X-Received: by 2002:a17:902:eb89:b0:19c:d309:4612 with SMTP id q9-20020a170902eb8900b0019cd3094612mr9387244plg.6.1681666028605;
        Sun, 16 Apr 2023 10:27:08 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id jn12-20020a170903050c00b001a6b42fd5fbsm2633371plb.183.2023.04.16.10.27.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 16 Apr 2023 10:27:08 -0700 (PDT)
Message-ID: <643c2fec.170a0220.ae03a.4486@mx.google.com>
Date:   Sun, 16 Apr 2023 10:27:08 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.10
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.10.176-265-g7f13564f1195
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.10 baseline: 122 runs,
 5 regressions (v5.10.176-265-g7f13564f1195)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 122 runs, 5 regressions (v5.10.176-265-g7f13=
564f1195)

Regressions Summary
-------------------

platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
beaglebone-black             | arm    | lab-broonie   | gcc-10   | omap2plu=
s_defconfig          | 1          =

cubietruck                   | arm    | lab-baylibre  | gcc-10   | multi_v7=
_defconfig           | 1          =

hp-x360-12b-c...4020-octopus | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

hp-x360-14-G1-sona           | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

sun8i-h3-libretech-all-h3-cc | arm    | lab-baylibre  | gcc-10   | multi_v7=
_defconfig           | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.176-265-g7f13564f1195/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.176-265-g7f13564f1195
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      7f13564f1195759aceafd127ae16282f250be146 =



Test Regressions
---------------- =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
beaglebone-black             | arm    | lab-broonie   | gcc-10   | omap2plu=
s_defconfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/643bf6b1ac7dd32a362e85e9

  Results:     51 PASS, 4 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-265-g7f13564f1195/arm/omap2plus_defconfig/gcc-10/lab-broonie/baseline-beag=
lebone-black.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-265-g7f13564f1195/arm/omap2plus_defconfig/gcc-10/lab-broonie/baseline-beag=
lebone-black.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643bf6b1ac7dd32a362e861c
        failing since 61 days (last pass: v5.10.167-127-g921934d621e4, firs=
t fail: v5.10.167-139-gf9519a5a1701)

    2023-04-16T13:22:41.872412  <8>[   20.541851] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 337177_1.5.2.4.1>
    2023-04-16T13:22:41.983169  / # #
    2023-04-16T13:22:42.086139  export SHELL=3D/bin/sh
    2023-04-16T13:22:42.086694  #
    2023-04-16T13:22:42.188075  / # export SHELL=3D/bin/sh. /lava-337177/en=
vironment
    2023-04-16T13:22:42.188874  =

    2023-04-16T13:22:42.290932  / # . /lava-337177/environment/lava-337177/=
bin/lava-test-runner /lava-337177/1
    2023-04-16T13:22:42.291842  =

    2023-04-16T13:22:42.296278  / # /lava-337177/bin/lava-test-runner /lava=
-337177/1
    2023-04-16T13:22:42.399892  + export 'TESTRUN_ID=3D1_bootrr' =

    ... (11 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
cubietruck                   | arm    | lab-baylibre  | gcc-10   | multi_v7=
_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/643bf675aa0ba65c282e85fd

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-265-g7f13564f1195/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubi=
etruck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-265-g7f13564f1195/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubi=
etruck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643bf675aa0ba65c282e8602
        failing since 80 days (last pass: v5.10.165-76-g5c2e982fcf18, first=
 fail: v5.10.165-77-g4600242c13ed)

    2023-04-16T13:21:49.491902  <8>[   11.096248] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3502430_1.5.2.4.1>
    2023-04-16T13:21:49.604057  / # #
    2023-04-16T13:21:49.707278  export SHELL=3D/bin/sh
    2023-04-16T13:21:49.708265  #
    2023-04-16T13:21:49.810343  / # export SHELL=3D/bin/sh. /lava-3502430/e=
nvironment
    2023-04-16T13:21:49.811202  =

    2023-04-16T13:21:49.913122  / # . /lava-3502430/environment/lava-350243=
0/bin/lava-test-runner /lava-3502430/1
    2023-04-16T13:21:49.914602  =

    2023-04-16T13:21:49.922841  / # /lava-3502430/bin/lava-test-runner /lav=
a-3502430/1
    2023-04-16T13:21:49.923424  <3>[   11.531156] Bluetooth: hci0: command =
0x0c03 tx timeout =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-12b-c...4020-octopus | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/643bf81697dd1a987b2e8605

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-265-g7f13564f1195/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-12b-ca0010nr-n4020-octopus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-265-g7f13564f1195/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-12b-ca0010nr-n4020-octopus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643bf81697dd1a987b2e860a
        failing since 17 days (last pass: v5.10.176-61-g2332301f1fab4, firs=
t fail: v5.10.176-104-g2b4187983740)

    2023-04-16T13:28:38.442173  + set +x

    2023-04-16T13:28:38.448684  <8>[   10.942673] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10005471_1.4.2.3.1>

    2023-04-16T13:28:38.553526  / # #

    2023-04-16T13:28:38.654565  export SHELL=3D/bin/sh

    2023-04-16T13:28:38.654773  #

    2023-04-16T13:28:38.755692  / # export SHELL=3D/bin/sh. /lava-10005471/=
environment

    2023-04-16T13:28:38.755901  =


    2023-04-16T13:28:38.856796  / # . /lava-10005471/environment/lava-10005=
471/bin/lava-test-runner /lava-10005471/1

    2023-04-16T13:28:38.857087  =


    2023-04-16T13:28:38.861839  / # /lava-10005471/bin/lava-test-runner /la=
va-10005471/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-14-G1-sona           | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/643bf7c477990a4fbb2e8612

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-265-g7f13564f1195/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-14-G1-sona.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-265-g7f13564f1195/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-14-G1-sona.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643bf7c477990a4fbb2e8617
        failing since 17 days (last pass: v5.10.176-61-g2332301f1fab4, firs=
t fail: v5.10.176-104-g2b4187983740)

    2023-04-16T13:27:13.845018  <8>[   11.397627] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10005490_1.4.2.3.1>

    2023-04-16T13:27:13.848132  + set +x

    2023-04-16T13:27:13.949796  #

    2023-04-16T13:27:13.950105  =


    2023-04-16T13:27:14.051139  / # #export SHELL=3D/bin/sh

    2023-04-16T13:27:14.051342  =


    2023-04-16T13:27:14.152262  / # export SHELL=3D/bin/sh. /lava-10005490/=
environment

    2023-04-16T13:27:14.152504  =


    2023-04-16T13:27:14.253503  / # . /lava-10005490/environment/lava-10005=
490/bin/lava-test-runner /lava-10005490/1

    2023-04-16T13:27:14.253827  =

 =

    ... (13 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
sun8i-h3-libretech-all-h3-cc | arm    | lab-baylibre  | gcc-10   | multi_v7=
_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/643bf67137dcc8efd02e8641

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-265-g7f13564f1195/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-sun8=
i-h3-libretech-all-h3-cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-265-g7f13564f1195/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-sun8=
i-h3-libretech-all-h3-cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643bf67137dcc8efd02e8646
        failing since 73 days (last pass: v5.10.165-139-gefb57ce0f880, firs=
t fail: v5.10.165-149-ge30e8271d674)

    2023-04-16T13:21:31.540856  / # #
    2023-04-16T13:21:31.643220  export SHELL=3D/bin/sh
    2023-04-16T13:21:31.643935  #
    2023-04-16T13:21:31.745562  / # export SHELL=3D/bin/sh. /lava-3502426/e=
nvironment
    2023-04-16T13:21:31.746239  =

    2023-04-16T13:21:31.847886  / # . /lava-3502426/environment/lava-350242=
6/bin/lava-test-runner /lava-3502426/1
    2023-04-16T13:21:31.849003  =

    2023-04-16T13:21:31.865292  / # /lava-3502426/bin/lava-test-runner /lav=
a-3502426/1
    2023-04-16T13:21:31.955192  + export 'TESTRUN_ID=3D1_bootrr'
    2023-04-16T13:21:31.955708  + cd /lava-3502426/1/tests/1_bootrr =

    ... (10 line(s) more)  =

 =20
