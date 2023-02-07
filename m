Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E9C468E15C
	for <lists+stable@lfdr.de>; Tue,  7 Feb 2023 20:38:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229732AbjBGTiF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Feb 2023 14:38:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230274AbjBGTiE (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Feb 2023 14:38:04 -0500
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88B4FCA15
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 11:38:03 -0800 (PST)
Received: by mail-pl1-x62b.google.com with SMTP id e19so8852757plc.9
        for <stable@vger.kernel.org>; Tue, 07 Feb 2023 11:38:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=sIRU7HHJAvguoXC0L2ID4D5kRsbGNnFdLtzcEIuGwTQ=;
        b=7ksqPE85RL1iBvZCx8lGMva32y0QqbCiiyxQG2JGYurCUXzIXstgATUBHWV6UBeBOV
         y4/otBi6gj9E7P2qD3K/QKexUynPHsQfVakDpFk9EXg5q9etpLRzrPaCgyU/xZkKpnol
         +/Z5HaBl2HNDX6MgCzO4SPW4AmbIR+wH4gTbGs74eUgO8/UG3/1AqzEhOS7zWstP4+C0
         d/Jyrmil8XwBgNl/Y0NmAdHAeqxO1INnS+GJ4AGW4EHYs3YwEhylC3ahsHB1Hlg9cP9t
         dQan4I2yAlkYLw2ytBksf+qCNbbc1jkzju+H7Ek4Nq6jkYU61hg5RvGGwqjPKUmiWEps
         Z72g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=sIRU7HHJAvguoXC0L2ID4D5kRsbGNnFdLtzcEIuGwTQ=;
        b=u3Qe6NLarf/44udBDvePe99NPK5QFFMtxSuyUeUidBE6k5m+lp904uKCqjDt0x0lYV
         O2xhXKwhpRyDC985kJn8gBu4gPQ+54zKIjZ262u+6jB6BwZCXNbfK/DFBCw0MbM0B4WR
         IwO6dBmBgP15zh3gEcwXm9i5237iwzHwT9RcIyWUxqKy8LztfdQDtoP5VT3pO+xrATNm
         hbM1kGV1g8qAm/w6zfRJQd3CR0I5wl1DK1QhtiGicano7Gs61ti4QkDIt0KZm5gIAdSs
         nxTtuGGmoz/NfGJMVEdlf+A+ltoUqJ+hGimV4ZW1TvpyzX4cTtuOOPv2iQokW/8K+51X
         lWJg==
X-Gm-Message-State: AO0yUKVvKsRIpGgDYJ4+5k8II3aVioy7MGbQZORSt7POkUWg4Fxp+QI4
        nbOkUkW7IfvxhEKaQPNh0YiVPoCzRZadp/u8ZbzdDA==
X-Google-Smtp-Source: AK7set+Y4Hc24xf2tf2zk/KOBwu7fp59+xMnQG1kCX2ZG7J6rHj/CFqgtNPPtkxwVFQT8HndjSXzKw==
X-Received: by 2002:a05:6a20:8e08:b0:be:abb2:66ff with SMTP id y8-20020a056a208e0800b000beabb266ffmr5455170pzj.60.1675798682803;
        Tue, 07 Feb 2023 11:38:02 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id a22-20020aa78656000000b00582388bd80csm9585446pfo.83.2023.02.07.11.38.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Feb 2023 11:38:02 -0800 (PST)
Message-ID: <63e2a89a.a70a0220.e3d8.175d@mx.google.com>
Date:   Tue, 07 Feb 2023 11:38:02 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.10.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.10.166-100-ge9ce3cb0864d
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-5.10.y baseline: 173 runs,
 3 regressions (v5.10.166-100-ge9ce3cb0864d)
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

stable-rc/linux-5.10.y baseline: 173 runs, 3 regressions (v5.10.166-100-ge9=
ce3cb0864d)

Regressions Summary
-------------------

platform               | arch  | lab          | compiler | defconfig       =
   | regressions
-----------------------+-------+--------------+----------+-----------------=
---+------------
cubietruck             | arm   | lab-baylibre | gcc-10   | multi_v7_defconf=
ig | 1          =

sun50i-a64-pine64-plus | arm64 | lab-baylibre | gcc-10   | defconfig       =
   | 1          =

sun50i-a64-pine64-plus | arm64 | lab-broonie  | gcc-10   | defconfig       =
   | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.10.y/ker=
nel/v5.10.166-100-ge9ce3cb0864d/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.10.y
  Describe: v5.10.166-100-ge9ce3cb0864d
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      e9ce3cb0864d364496872cad97ba6af396372866 =



Test Regressions
---------------- =



platform               | arch  | lab          | compiler | defconfig       =
   | regressions
-----------------------+-------+--------------+----------+-----------------=
---+------------
cubietruck             | arm   | lab-baylibre | gcc-10   | multi_v7_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/63e272c7d63f27656b8c863e

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
66-100-ge9ce3cb0864d/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cu=
bietruck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
66-100-ge9ce3cb0864d/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cu=
bietruck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230203.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63e272c7d63f27656b8c8647
        failing since 20 days (last pass: v5.10.158-107-gd2432186ff47, firs=
t fail: v5.10.162-852-geeaac3cf2eb3)

    2023-02-07T15:48:11.814661  <8>[   11.086283] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3302465_1.5.2.4.1>
    2023-02-07T15:48:11.923564  / # #
    2023-02-07T15:48:12.026730  export SHELL=3D/bin/sh
    2023-02-07T15:48:12.027838  #
    2023-02-07T15:48:12.129854  / # export SHELL=3D/bin/sh. /lava-3302465/e=
nvironment
    2023-02-07T15:48:12.130862  =

    2023-02-07T15:48:12.131500  / # . /lava-3302465/environment<3>[   11.37=
1106] Bluetooth: hci0: command 0xfc18 tx timeout
    2023-02-07T15:48:12.233618  /lava-3302465/bin/lava-test-runner /lava-33=
02465/1
    2023-02-07T15:48:12.235406  =

    2023-02-07T15:48:12.240461  / # /lava-3302465/bin/lava-test-runner /lav=
a-3302465/1 =

    ... (12 line(s) more)  =

 =



platform               | arch  | lab          | compiler | defconfig       =
   | regressions
-----------------------+-------+--------------+----------+-----------------=
---+------------
sun50i-a64-pine64-plus | arm64 | lab-baylibre | gcc-10   | defconfig       =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/63e2762cff683c19528c8645

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
66-100-ge9ce3cb0864d/arm64/defconfig/gcc-10/lab-baylibre/baseline-sun50i-a6=
4-pine64-plus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
66-100-ge9ce3cb0864d/arm64/defconfig/gcc-10/lab-baylibre/baseline-sun50i-a6=
4-pine64-plus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230203.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63e2762cff683c19528c864e
        failing since 8 days (last pass: v5.10.158-107-g6b6a42c25ed4, first=
 fail: v5.10.165-144-g930bc29c79c4)

    2023-02-07T16:02:40.348212  + set +x
    2023-02-07T16:02:40.352392  <8>[   17.064324] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3302553_1.5.2.4.1>
    2023-02-07T16:02:40.472542  / # #
    2023-02-07T16:02:40.578121  export SHELL=3D/bin/sh
    2023-02-07T16:02:40.579718  #
    2023-02-07T16:02:40.683092  / # export SHELL=3D/bin/sh. /lava-3302553/e=
nvironment
    2023-02-07T16:02:40.684629  =

    2023-02-07T16:02:40.788076  / # . /lava-3302553/environment/lava-330255=
3/bin/lava-test-runner /lava-3302553/1
    2023-02-07T16:02:40.790755  =

    2023-02-07T16:02:40.793989  / # /lava-3302553/bin/lava-test-runner /lav=
a-3302553/1 =

    ... (12 line(s) more)  =

 =



platform               | arch  | lab          | compiler | defconfig       =
   | regressions
-----------------------+-------+--------------+----------+-----------------=
---+------------
sun50i-a64-pine64-plus | arm64 | lab-broonie  | gcc-10   | defconfig       =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/63e27500df8798e2df8c863e

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
66-100-ge9ce3cb0864d/arm64/defconfig/gcc-10/lab-broonie/baseline-sun50i-a64=
-pine64-plus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
66-100-ge9ce3cb0864d/arm64/defconfig/gcc-10/lab-broonie/baseline-sun50i-a64=
-pine64-plus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230203.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63e27500df8798e2df8c8647
        failing since 8 days (last pass: v5.10.158-107-g6b6a42c25ed4, first=
 fail: v5.10.165-144-g930bc29c79c4)

    2023-02-07T15:57:40.557023  <8>[   17.154192] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 269943_1.5.2.4.1>
    2023-02-07T15:57:40.668669  / # #
    2023-02-07T15:57:40.771622  export SHELL=3D/bin/sh
    2023-02-07T15:57:40.772229  #
    2023-02-07T15:57:40.874273  / # export SHELL=3D/bin/sh. /lava-269943/en=
vironment
    2023-02-07T15:57:40.874870  =

    2023-02-07T15:57:40.976738  / # . /lava-269943/environment/lava-269943/=
bin/lava-test-runner /lava-269943/1
    2023-02-07T15:57:40.977775  =

    2023-02-07T15:57:40.981876  / # /lava-269943/bin/lava-test-runner /lava=
-269943/1
    2023-02-07T15:57:41.023515  + export 'TESTRUN_ID=3D1_bootrr' =

    ... (11 line(s) more)  =

 =20
