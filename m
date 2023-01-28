Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38E6A67F938
	for <lists+stable@lfdr.de>; Sat, 28 Jan 2023 16:37:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229841AbjA1PhQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 28 Jan 2023 10:37:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229811AbjA1PhP (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 28 Jan 2023 10:37:15 -0500
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB79E26593
        for <stable@vger.kernel.org>; Sat, 28 Jan 2023 07:37:14 -0800 (PST)
Received: by mail-pl1-x62f.google.com with SMTP id k13so7742170plg.0
        for <stable@vger.kernel.org>; Sat, 28 Jan 2023 07:37:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=oR+WXRefFykX7yoXDeLp6ow9T9EHNXE3qsLFOUKE8g4=;
        b=owobzo54EVFgcYt262rfXUkkH640HHukC/OuiWJCbc9dirUPCOkX19ha+vAHgbEmvc
         jvfVGVFBple4crfumDbg+MpycSn6LSrJL4QdvoC+FjqLN8A8uDH8EQAZ1Kn+6i0usBjp
         U4mKMDmSC2OzJorDqiCZ9csn/kxzD9VW+7QfRTx++hgX0cI9/D0vSXtMEIg6O5b60Hd/
         BoylEWxL1oZBdcN5DDABTZLz5WbFYrkPYWw/7yyIZ5FjGNeETMUGDRnqFrTtvhwSNt9o
         dSWOyfaxQC9WadfrztRuN2C1q5PM5f8OMNCHyjGLno/YYJac7uwlImw7nsVpb7tkgRzb
         oAMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=oR+WXRefFykX7yoXDeLp6ow9T9EHNXE3qsLFOUKE8g4=;
        b=FzqbRy2G2wwJVMa3aJ+sYhkZY9cvdnA7FiuyOY5mMilKDem4MMW69W2v+v9EbGwY5J
         Kfst9HcrKMODcWnUqChsBWsn+OEFwzvzBr3HR4k8CLdiBJRbh05Ec+vpYKaAEDrPabsa
         5HQgeP4ng3RV4avp/n/lRo3HrtTnODsrfbiu45X03KfZch+ZA/zPSMoAROG7F7HIJ3dt
         0ocbLXKngwH6NRJB2qUkXGp2/CC+QVTyIWUMNkAufHS0DVoeuVsaNHHDgbenxHpVcj+1
         sQyjdt86we9dNH+usWj3kTqRMmkDb9uDWg8UkWZyeGL8Anxizvn0U4k4RYBF22HBZv2H
         z5Xg==
X-Gm-Message-State: AO0yUKVFY1KBoJxmDJkuI3BI8MRq0cFIJv6Sy5hbfz7lXi0itPyhGvke
        vCNHzmSDc67Jp4hvbR9tqMOGMhpeBjQhXAfsTZ8=
X-Google-Smtp-Source: AK7set8hQC/JObroscAjG9IUapdyC0swX09zbVc77ZCtlz4wC2PnLmP6dzBpLKgZxVvEuoEp1yMAkw==
X-Received: by 2002:a05:6a20:4a27:b0:b6:a9ad:a07f with SMTP id fr39-20020a056a204a2700b000b6a9ada07fmr2689644pzb.27.1674920233934;
        Sat, 28 Jan 2023 07:37:13 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id e13-20020aa798cd000000b0058bc5f6426asm4393888pfm.169.2023.01.28.07.37.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 28 Jan 2023 07:37:13 -0800 (PST)
Message-ID: <63d54129.a70a0220.3d94a.6d2d@mx.google.com>
Date:   Sat, 28 Jan 2023 07:37:13 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.15
X-Kernelci-Kernel: v5.15.90-153-g2e09e110f9b2
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.15 baseline: 172 runs,
 4 regressions (v5.15.90-153-g2e09e110f9b2)
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

stable-rc/queue/5.15 baseline: 172 runs, 4 regressions (v5.15.90-153-g2e09e=
110f9b2)

Regressions Summary
-------------------

platform               | arch  | lab             | compiler | defconfig    =
      | regressions
-----------------------+-------+-----------------+----------+--------------=
------+------------
cubietruck             | arm   | lab-baylibre    | gcc-10   | multi_v7_defc=
onfig | 1          =

imx53-qsrb             | arm   | lab-pengutronix | gcc-10   | multi_v7_defc=
onfig | 1          =

sun50i-a64-pine64-plus | arm64 | lab-baylibre    | gcc-10   | defconfig    =
      | 1          =

sun50i-a64-pine64-plus | arm64 | lab-broonie     | gcc-10   | defconfig    =
      | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.90-153-g2e09e110f9b2/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.90-153-g2e09e110f9b2
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      2e09e110f9b2b625d5ab6b227fc0b7b78c0258c7 =



Test Regressions
---------------- =



platform               | arch  | lab             | compiler | defconfig    =
      | regressions
-----------------------+-------+-----------------+----------+--------------=
------+------------
cubietruck             | arm   | lab-baylibre    | gcc-10   | multi_v7_defc=
onfig | 1          =


  Details:     https://kernelci.org/test/plan/id/63d5108e8acc902b7b915eff

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.90-=
153-g2e09e110f9b2/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubie=
truck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.90-=
153-g2e09e110f9b2/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubie=
truck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63d5108e8acc902b7b915f04
        failing since 11 days (last pass: v5.15.82-123-gd03dbdba21ef, first=
 fail: v5.15.87-100-ge215d5ead661)

    2023-01-28T12:09:32.368958  <8>[    9.955834] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3233482_1.5.2.4.1>
    2023-01-28T12:09:32.476158  / # #
    2023-01-28T12:09:32.577667  export SHELL=3D/bin/sh
    2023-01-28T12:09:32.578401  #
    2023-01-28T12:09:32.680145  / # export SHELL=3D/bin/sh. /lava-3233482/e=
nvironment
    2023-01-28T12:09:32.680483  =

    2023-01-28T12:09:32.781791  / # . /lava-3233482/environment/lava-323348=
2/bin/lava-test-runner /lava-3233482/1
    2023-01-28T12:09:32.782665  =

    2023-01-28T12:09:32.787059  / # /lava-3233482/bin/lava-test-runner /lav=
a-3233482/1
    2023-01-28T12:09:32.845131  <3>[   10.433675] Bluetooth: hci0: command =
0x0c03 tx timeout =

    ... (12 line(s) more)  =

 =



platform               | arch  | lab             | compiler | defconfig    =
      | regressions
-----------------------+-------+-----------------+----------+--------------=
------+------------
imx53-qsrb             | arm   | lab-pengutronix | gcc-10   | multi_v7_defc=
onfig | 1          =


  Details:     https://kernelci.org/test/plan/id/63d50ff7f9f155f599915ee2

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.90-=
153-g2e09e110f9b2/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-im=
x53-qsrb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.90-=
153-g2e09e110f9b2/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-im=
x53-qsrb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63d50ff7f9f155f599915ee7
        failing since 1 day (last pass: v5.15.81-121-gcb14018a85f6, first f=
ail: v5.15.90-146-gbf7101723cc0)

    2023-01-28T12:06:57.577161  + set +x
    2023-01-28T12:06:57.577347  [    9.351515] <LAVA_SIGNAL_ENDRUN 0_dmesg =
890364_1.5.2.3.1>
    2023-01-28T12:06:57.684465  / # #
    2023-01-28T12:06:57.786369  export SHELL=3D/bin/sh
    2023-01-28T12:06:57.786943  #
    2023-01-28T12:06:57.888209  / # export SHELL=3D/bin/sh. /lava-890364/en=
vironment
    2023-01-28T12:06:57.888684  =

    2023-01-28T12:06:57.989919  / # . /lava-890364/environment/lava-890364/=
bin/lava-test-runner /lava-890364/1
    2023-01-28T12:06:57.990592  =

    2023-01-28T12:06:57.992983  / # /lava-890364/bin/lava-test-runner /lava=
-890364/1 =

    ... (12 line(s) more)  =

 =



platform               | arch  | lab             | compiler | defconfig    =
      | regressions
-----------------------+-------+-----------------+----------+--------------=
------+------------
sun50i-a64-pine64-plus | arm64 | lab-baylibre    | gcc-10   | defconfig    =
      | 1          =


  Details:     https://kernelci.org/test/plan/id/63d512e724ac76996b915ebc

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.90-=
153-g2e09e110f9b2/arm64/defconfig/gcc-10/lab-baylibre/baseline-sun50i-a64-p=
ine64-plus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.90-=
153-g2e09e110f9b2/arm64/defconfig/gcc-10/lab-baylibre/baseline-sun50i-a64-p=
ine64-plus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63d512e724ac76996b915ec1
        failing since 10 days (last pass: v5.15.82-123-gd03dbdba21ef, first=
 fail: v5.15.87-100-ge215d5ead661)

    2023-01-28T12:19:07.214822  <8>[   16.080315] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3233452_1.5.2.4.1>
    2023-01-28T12:19:07.343570  / # #
    2023-01-28T12:19:07.454252  export SHELL=3D/bin/sh
    2023-01-28T12:19:07.457063  #
    2023-01-28T12:19:07.563146  / # export SHELL=3D/bin/sh. /lava-3233452/e=
nvironment
    2023-01-28T12:19:07.566035  =

    2023-01-28T12:19:07.672504  / # . /lava-3233452/environment/lava-323345=
2/bin/lava-test-runner /lava-3233452/1
    2023-01-28T12:19:07.676836  =

    2023-01-28T12:19:07.679850  / # /lava-3233452/bin/lava-test-runner /lav=
a-3233452/1
    2023-01-28T12:19:07.726009  + export 'TESTRUN_ID=3D1_bootrr' =

    ... (11 line(s) more)  =

 =



platform               | arch  | lab             | compiler | defconfig    =
      | regressions
-----------------------+-------+-----------------+----------+--------------=
------+------------
sun50i-a64-pine64-plus | arm64 | lab-broonie     | gcc-10   | defconfig    =
      | 1          =


  Details:     https://kernelci.org/test/plan/id/63d50f00c80b4274aa915ebc

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.90-=
153-g2e09e110f9b2/arm64/defconfig/gcc-10/lab-broonie/baseline-sun50i-a64-pi=
ne64-plus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.90-=
153-g2e09e110f9b2/arm64/defconfig/gcc-10/lab-broonie/baseline-sun50i-a64-pi=
ne64-plus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63d50f00c80b4274aa915ec1
        failing since 10 days (last pass: v5.15.82-123-gd03dbdba21ef, first=
 fail: v5.15.87-100-ge215d5ead661)

    2023-01-28T12:03:02.316175  + set +x
    2023-01-28T12:03:02.320208  <8>[   16.041830] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 199144_1.5.2.4.1>
    2023-01-28T12:03:02.431303  / # #
    2023-01-28T12:03:02.533970  export SHELL=3D/bin/sh
    2023-01-28T12:03:02.534660  #
    2023-01-28T12:03:02.636240  / # export SHELL=3D/bin/sh. /lava-199144/en=
vironment
    2023-01-28T12:03:02.636919  =

    2023-01-28T12:03:02.738572  / # . /lava-199144/environment/lava-199144/=
bin/lava-test-runner /lava-199144/1
    2023-01-28T12:03:02.739527  =

    2023-01-28T12:03:02.743332  / # /lava-199144/bin/lava-test-runner /lava=
-199144/1 =

    ... (12 line(s) more)  =

 =20
