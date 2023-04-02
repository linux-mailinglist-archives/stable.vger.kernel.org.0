Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC13D6D39E1
	for <lists+stable@lfdr.de>; Sun,  2 Apr 2023 20:44:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231146AbjDBSoG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 2 Apr 2023 14:44:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231304AbjDBSnx (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 2 Apr 2023 14:43:53 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C2412694
        for <stable@vger.kernel.org>; Sun,  2 Apr 2023 11:43:37 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id j13so25233297pjd.1
        for <stable@vger.kernel.org>; Sun, 02 Apr 2023 11:43:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112; t=1680461016;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=dxGYf8r8kV4MfwaaWW8ZnxYgViF/ea9Hx1V7mDu5PiE=;
        b=QMDyxX9V/R4EXlwKwryY97hfO2wix9DIVqb42NnwA1VjT+/espxdoOfKLgo8idfVMA
         1jfWkpoGYIy0d1QmFCP7lbDIJ9ypIlwpWwtYpSoAewgLl7Yjph9Z4jpfu/ej2nZdhkWl
         FPR7Be91WE1KRrJk1lL6eeg9MsVP9f3n0MoYGNjRSw4kiHLpY2e/aN7ihfFsP0F4EJhc
         aEIO2bjM+f4i7FKDMgcfjx1UkAQKKvsLeOpH/kJ7EdNi/BToALDYJ+MW5y3GywZvm53z
         G6C6LL6wliAEPKmNYd4GuphF3YGhMJPX5DPv92XwSSu8GD7p1WDaMV/09jChAOduw7py
         KJrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680461016;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dxGYf8r8kV4MfwaaWW8ZnxYgViF/ea9Hx1V7mDu5PiE=;
        b=li4jh1Q8vWNZHNygo7mV3h5v257wsIGfhI5FZ1PYJCNHLILZ9rqHZAvHlxZvaNhU9e
         nlW6qEH56g7u4N9mCXSECF5dsahAPxQ+TaaPm3cKoEBq1zdoTfL6P0Eamct1Ix7OnmYu
         uBBUTxdfEGesczQYZtfWyEDpOGI6MAX9JOwNH6qfPYrXW0q64Z/OkmvRwMoPEAk5XQN6
         TucA52k1Vf4vMZq1sEMPRb2vl8xj+V/MsPAKPyBCUrlEKEfBi9M7hMaPPEt9PwsrUVLx
         FH+UPvctofUtCitmuimQjAi7e6q2O2Bgs07h78dt1moFtE3u/GospjqipWM7UMhnRLkp
         nQfQ==
X-Gm-Message-State: AAQBX9eJLWTpMcI2AsK0go5rfAc3Kz4NR9hR5ifxtrttr4+6fJIX+15T
        5GKTRJb1351bDPlBr76Jtb7mlP+UwsGnFPRoJy8=
X-Google-Smtp-Source: AKy350aSxQs990DChKPVCjhbLMVIV0GzvbTYHpAgs7sHoCrwwVQE+QYIgrioyIOuMBZ6sFw6KPBuLQ==
X-Received: by 2002:a17:903:181:b0:1a1:f0ad:8657 with SMTP id z1-20020a170903018100b001a1f0ad8657mr43088201plg.37.1680461016372;
        Sun, 02 Apr 2023 11:43:36 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id x7-20020a1709027c0700b0019468fe44d3sm5106598pll.25.2023.04.02.11.43.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 02 Apr 2023 11:43:35 -0700 (PDT)
Message-ID: <6429ccd7.170a0220.69b0b.9bb6@mx.google.com>
Date:   Sun, 02 Apr 2023 11:43:35 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.19
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.19.279-68-g70c301528eb3
Subject: stable-rc/queue/4.19 baseline: 106 runs,
 3 regressions (v4.19.279-68-g70c301528eb3)
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

stable-rc/queue/4.19 baseline: 106 runs, 3 regressions (v4.19.279-68-g70c30=
1528eb3)

Regressions Summary
-------------------

platform         | arch | lab          | compiler | defconfig           | r=
egressions
-----------------+------+--------------+----------+---------------------+--=
----------
at91sam9g20ek    | arm  | lab-broonie  | gcc-10   | multi_v5_defconfig  | 1=
          =

beaglebone-black | arm  | lab-broonie  | gcc-10   | omap2plus_defconfig | 1=
          =

cubietruck       | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig  | 1=
          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.279-68-g70c301528eb3/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.279-68-g70c301528eb3
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      70c301528eb38312655d0017b33ecb0acd06d2c0 =



Test Regressions
---------------- =



platform         | arch | lab          | compiler | defconfig           | r=
egressions
-----------------+------+--------------+----------+---------------------+--=
----------
at91sam9g20ek    | arm  | lab-broonie  | gcc-10   | multi_v5_defconfig  | 1=
          =


  Details:     https://kernelci.org/test/plan/id/64299a64e9b2cfc02b62f779

  Results:     42 PASS, 9 FAIL, 1 SKIP
  Full config: multi_v5_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.279=
-68-g70c301528eb3/arm/multi_v5_defconfig/gcc-10/lab-broonie/baseline-at91sa=
m9g20ek.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.279=
-68-g70c301528eb3/arm/multi_v5_defconfig/gcc-10/lab-broonie/baseline-at91sa=
m9g20ek.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64299a64e9b2cfc02b62f7a9
        failing since 6 days (last pass: v4.19.279-25-g8270940878fa3, first=
 fail: v4.19.279-25-gc95d797f10041)

    2023-04-02T15:07:39.134227  + set +x
    2023-04-02T15:07:39.139400  <8><LAVA_SIGNAL_ENDRUN 0_dmesg 264761_1.5.2=
.4.1>
    2023-04-02T15:07:39.253797  / # #
    2023-04-02T15:07:39.356833  export SHELL=3D/bin/sh
    2023-04-02T15:07:39.357649  #
    2023-04-02T15:07:39.459629  / # export SHELL=3D/bin/sh. /lava-264761/en=
vironment
    2023-04-02T15:07:39.460423  =

    2023-04-02T15:07:39.562401  / # . /lava-264761/environment/lava-264761/=
bin/lava-test-runner /lava-264761/1
    2023-04-02T15:07:39.563901  =

    2023-04-02T15:07:39.570113  / # /lava-264761/bin/lava-test-runner /lava=
-264761/1 =

    ... (12 line(s) more)  =

 =



platform         | arch | lab          | compiler | defconfig           | r=
egressions
-----------------+------+--------------+----------+---------------------+--=
----------
beaglebone-black | arm  | lab-broonie  | gcc-10   | omap2plus_defconfig | 1=
          =


  Details:     https://kernelci.org/test/plan/id/6429990fbf064a203062f782

  Results:     41 PASS, 10 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.279=
-68-g70c301528eb3/arm/omap2plus_defconfig/gcc-10/lab-broonie/baseline-beagl=
ebone-black.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.279=
-68-g70c301528eb3/arm/omap2plus_defconfig/gcc-10/lab-broonie/baseline-beagl=
ebone-black.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6429990fbf064a203062f7b4
        new failure (last pass: v4.19.279-62-gd009556a422b)

    2023-04-02T15:01:53.466830  + set +x<8>[   17.204259] <LAVA_SIGNAL_ENDR=
UN 0_dmesg 264711_1.5.2.4.1>
    2023-04-02T15:01:53.470664  =

    2023-04-02T15:01:53.632116  / # #
    2023-04-02T15:01:53.748242  export SHELL=3D/bin/sh
    2023-04-02T15:01:53.753183  #
    2023-04-02T15:01:53.861848  / # export SHELL=3D/bin/sh. /lava-264711/en=
vironment
    2023-04-02T15:01:53.867342  =

    2023-04-02T15:01:53.976738  / # . /lava-264711/environment/lava-264711/=
bin/lava-test-runner /lava-264711/1
    2023-04-02T15:01:53.985260  =

    2023-04-02T15:01:53.988622  / # /lava-264711/bin/lava-test-runner /lava=
-264711/1 =

    ... (12 line(s) more)  =

 =



platform         | arch | lab          | compiler | defconfig           | r=
egressions
-----------------+------+--------------+----------+---------------------+--=
----------
cubietruck       | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig  | 1=
          =


  Details:     https://kernelci.org/test/plan/id/6429990cbf064a203062f774

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.279=
-68-g70c301528eb3/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubie=
truck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.279=
-68-g70c301528eb3/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubie=
truck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6429990cbf064a203062f779
        failing since 75 days (last pass: v4.19.269-9-gce7b59ec9d48, first =
fail: v4.19.269-521-g305d312d039a)

    2023-04-02T15:02:20.890002  <8>[    7.264884] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3464376_1.5.2.4.1>
    2023-04-02T15:02:20.998534  / # #
    2023-04-02T15:02:21.100064  export SHELL=3D/bin/sh
    2023-04-02T15:02:21.100454  #
    2023-04-02T15:02:21.201565  / # export SHELL=3D/bin/sh. /lava-3464376/e=
nvironment
    2023-04-02T15:02:21.201946  =

    2023-04-02T15:02:21.303064  / # . /lava-3464376/environment/lava-346437=
6/bin/lava-test-runner /lava-3464376/1
    2023-04-02T15:02:21.303653  =

    2023-04-02T15:02:21.308974  / # /lava-3464376/bin/lava-test-runner /lav=
a-3464376/1
    2023-04-02T15:02:21.393197  + export 'TESTRUN_ID=3D1_bootrr' =

    ... (11 line(s) more)  =

 =20
