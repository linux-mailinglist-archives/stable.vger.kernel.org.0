Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC92E68DC9A
	for <lists+stable@lfdr.de>; Tue,  7 Feb 2023 16:11:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232004AbjBGPLU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Feb 2023 10:11:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231793AbjBGPLN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Feb 2023 10:11:13 -0500
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AA813BD91
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 07:10:53 -0800 (PST)
Received: by mail-pf1-x42e.google.com with SMTP id y132so30805pfg.2
        for <stable@vger.kernel.org>; Tue, 07 Feb 2023 07:10:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=F2lsTRW7o8u7jryd8AuW6fA1TPE1dMjArtaM/zMadLs=;
        b=ehtvJxPEwtZjY0dOGzopJ4sIZXUk4pnHqvfpuI/BHbV+KKlQGoICC1LL62KsZq2xjL
         1GVu/6JxZ041BlhQGWLz0R5f9SX4MGtY6yV9xxdZO2k/ivaWkpxNrZGrFSe1GinkrvAb
         BDIh6HrmA7eTxFSdc4cO716NFtjbVGgSCJxNu7UpeR+PVyd2h4ZQrQi0DGLOa0zLl6Sz
         7p04flVIkswr3v4UG//y41ZceN42htwDOhwbl/Ocune7+OgOcT5Mcn87GKszLkBigRHw
         J/X3R3LQJlqk4isSkEUDTLInzSf/nTDaZFiojlMoWLMWZf86ppk/NqZQoSK6n26oTLOD
         jR+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=F2lsTRW7o8u7jryd8AuW6fA1TPE1dMjArtaM/zMadLs=;
        b=aW0jCFJPlkyx700InjyVTwk8SF8yx9haYlzUxVxyocQsMWc8oqVpZA7q+JCeKndYKo
         GkaEEQGOnrF9bRDUyBZjccIHMfQPgYgpPtKWz0L7rV0TUy/DZUTwixJpmtKlf7wC7XK3
         1Iek1ssPgUxz0iNwOBRNiRbw93L2Jbc2oiMdM/bhWrxci92RBMBq8NYICEuSGLzM3czD
         0KHNNuYhs8UDCncksaHxMi71qmkmt2Y1i34Jk21wo6ZSeNY4Qai1gvrZWgvLBUyNpPEb
         ziX7SSDsCLFWRn2Dqoji2OltWuI52lOwY/QmXLCSvYLv06YquxRyu0yuiZ0dOASprkzO
         Bc/w==
X-Gm-Message-State: AO0yUKVsOv5Kwd9HeX+jZevG41vb5F/q9DMjvu/+dMKqfjs6jVb9+8/W
        0wppFmj3hkuwy//+xHJcbRJM1ta7numamwg/aF56Bw==
X-Google-Smtp-Source: AK7set8pe+UGIQRorzRflq+zS8C0u/7856xsZMUlbFQeFfJSIyJHMCUYAgGE6YMVBhAAV70eKJD6Zg==
X-Received: by 2002:aa7:971b:0:b0:594:1f1c:3d35 with SMTP id a27-20020aa7971b000000b005941f1c3d35mr13963601pfg.10.1675782650996;
        Tue, 07 Feb 2023 07:10:50 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id j7-20020aa78007000000b00593baab06dcsm3925626pfi.198.2023.02.07.07.10.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Feb 2023 07:10:50 -0800 (PST)
Message-ID: <63e269fa.a70a0220.a7402.760a@mx.google.com>
Date:   Tue, 07 Feb 2023 07:10:50 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.10
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.10.166-92-g66e7380d4d04
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.10 baseline: 169 runs,
 3 regressions (v5.10.166-92-g66e7380d4d04)
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

stable-rc/queue/5.10 baseline: 169 runs, 3 regressions (v5.10.166-92-g66e73=
80d4d04)

Regressions Summary
-------------------

platform                     | arch | lab          | compiler | defconfig  =
        | regressions
-----------------------------+------+--------------+----------+------------=
--------+------------
at91-sama5d4_xplained        | arm  | lab-baylibre | gcc-10   | multi_v7_de=
fconfig | 1          =

cubietruck                   | arm  | lab-baylibre | gcc-10   | multi_v7_de=
fconfig | 1          =

sun8i-h3-libretech-all-h3-cc | arm  | lab-baylibre | gcc-10   | multi_v7_de=
fconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.166-92-g66e7380d4d04/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.166-92-g66e7380d4d04
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      66e7380d4d0485789372201e3fbf92590f466155 =



Test Regressions
---------------- =



platform                     | arch | lab          | compiler | defconfig  =
        | regressions
-----------------------------+------+--------------+----------+------------=
--------+------------
at91-sama5d4_xplained        | arm  | lab-baylibre | gcc-10   | multi_v7_de=
fconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/63e2366e4f37d77b608c866e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.166=
-92-g66e7380d4d04/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-at91-=
sama5d4_xplained.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.166=
-92-g66e7380d4d04/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-at91-=
sama5d4_xplained.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230203.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63e2366e4f37d77b608c8=
66f
        new failure (last pass: v5.10.166-9-gd4e703ee981a) =

 =



platform                     | arch | lab          | compiler | defconfig  =
        | regressions
-----------------------------+------+--------------+----------+------------=
--------+------------
cubietruck                   | arm  | lab-baylibre | gcc-10   | multi_v7_de=
fconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/63e23582ccb3191f488c8662

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.166=
-92-g66e7380d4d04/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubie=
truck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.166=
-92-g66e7380d4d04/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubie=
truck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230203.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63e23582ccb3191f488c866b
        failing since 11 days (last pass: v5.10.165-76-g5c2e982fcf18, first=
 fail: v5.10.165-77-g4600242c13ed)

    2023-02-07T11:26:17.306821  <8>[   10.966421] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3301074_1.5.2.4.1>
    2023-02-07T11:26:17.417237  / # #
    2023-02-07T11:26:17.520511  export SHELL=3D/bin/sh
    2023-02-07T11:26:17.521395  #
    2023-02-07T11:26:17.623443  / # export SHELL=3D/bin/sh. /lava-3301074/e=
nvironment
    2023-02-07T11:26:17.624377  =

    2023-02-07T11:26:17.726331  / # . /lava-3301074/environment/lava-330107=
4/bin/lava-test-runner /lava-3301074/1
    2023-02-07T11:26:17.727955  =

    2023-02-07T11:26:17.728451  / # /lava-3301074/bin/lava-test-runner /lav=
a-3301074/1<3>[   11.374826] Bluetooth: hci0: command 0x0c03 tx timeout
    2023-02-07T11:26:17.732475   =

    ... (12 line(s) more)  =

 =



platform                     | arch | lab          | compiler | defconfig  =
        | regressions
-----------------------------+------+--------------+----------+------------=
--------+------------
sun8i-h3-libretech-all-h3-cc | arm  | lab-baylibre | gcc-10   | multi_v7_de=
fconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/63e23547b1676db62c8c865b

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.166=
-92-g66e7380d4d04/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-sun8i=
-h3-libretech-all-h3-cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.166=
-92-g66e7380d4d04/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-sun8i=
-h3-libretech-all-h3-cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230203.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63e23547b1676db62c8c8664
        failing since 5 days (last pass: v5.10.165-139-gefb57ce0f880, first=
 fail: v5.10.165-149-ge30e8271d674)

    2023-02-07T11:25:48.894319  / # #
    2023-02-07T11:25:48.996429  export SHELL=3D/bin/sh
    2023-02-07T11:25:48.996951  #
    2023-02-07T11:25:49.098524  / # export SHELL=3D/bin/sh. /lava-3301072/e=
nvironment
    2023-02-07T11:25:49.099167  =

    2023-02-07T11:25:49.200768  / # . /lava-3301072/environment/lava-330107=
2/bin/lava-test-runner /lava-3301072/1
    2023-02-07T11:25:49.201735  =

    2023-02-07T11:25:49.219055  / # /lava-3301072/bin/lava-test-runner /lav=
a-3301072/1
    2023-02-07T11:25:49.306854  + export 'TESTRUN_ID=3D1_bootrr'
    2023-02-07T11:25:49.307297  + cd /lava-3301072/1/tests/1_bootrr =

    ... (10 line(s) more)  =

 =20
