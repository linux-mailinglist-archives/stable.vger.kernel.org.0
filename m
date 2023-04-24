Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19AC96ED60C
	for <lists+stable@lfdr.de>; Mon, 24 Apr 2023 22:19:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232071AbjDXUTJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Apr 2023 16:19:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231939AbjDXUTI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Apr 2023 16:19:08 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16F734EDE
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 13:19:07 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id d9443c01a7336-1a8097c1ccfso54074125ad.1
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 13:19:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20221208.gappssmtp.com; s=20221208; t=1682367546; x=1684959546;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=Wki8tbRVYdtwJCWl86i2D/5ob5U6v+K7o3kLKS15N78=;
        b=ueJ68usV6MY7GxMwj/CTtNd9eNUT11pja5y4XYUW89jXC/eKKLGJmPTRg8ewSrE1qv
         2+U30Xfld15O9wVQled+H96Mj2p5GZoDmNEX7J31gaMO37hxUkI1d+BCFLdGTknGH5lU
         p6FqQuGVFcosaiPSQiH/xHtqkVfV0YHMYYZhz6XCpF2yibBDNbob9YZY1WrXFdQ5/ysw
         DeNfrpg814BufvHo7UnTiJoelWK7GXmQIfCtpk2uNlQYP2JHV2eJz/Uh5MoQrDQ0BP3I
         Nzhcg0gLhPQ0nEI3nR1LCPGwpmxWQ4Y7ZUODt40/dxkM5QcUzqmkFd6Cdnw6fSsJBklB
         UHwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682367546; x=1684959546;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Wki8tbRVYdtwJCWl86i2D/5ob5U6v+K7o3kLKS15N78=;
        b=lArujl9osKdrCRWcbAEoXi7+vPGL2uXEni35vB0ej2LHQw8pjRaDBayX/WK7trnFua
         WMMSw+dBvFM/z9HvYRB1gx/gvPJXqqxAmVuqJqAq3/78K+PzruJpghBgYRsGdwKD5L4t
         qSDhj2J8L5GA5ER36peaal8Zu/KAzJF1hGEkdVpEdD5ErZL5YTLiLCpcYxPZwIKYJOwN
         0DKxPM4pTBqLtXuFTVUevVK4d80ZWMfAbW6kGeGsXbuhdZKi+7+QY01asDg7vUOQ+nf2
         L2eCJ+dXSgEX+veXzx0r8sWujJ+4v3uXWdSih/RDm6WTAeG+XAxFBhMcljnzLEVbqZdH
         xyJw==
X-Gm-Message-State: AC+VfDy32FmD15kcXHCYq5soevbdmt3hOznDBN1SW0NzhKX3XfppY4fQ
        j0vXa/aNwwRsroH5g92PpPZ1UtFJqgGJpGGgd1SXlw==
X-Google-Smtp-Source: ACHHUZ5Tx/SAOaO9yYTh9xL2wEcaRxYYiVG6wA3A66/KAUGk+iG9xz5f2W/HWnv2tgpK/9bDLIQIeQ==
X-Received: by 2002:a17:902:c949:b0:1a9:8907:ae3d with SMTP id i9-20020a170902c94900b001a98907ae3dmr739455pla.30.1682367546086;
        Mon, 24 Apr 2023 13:19:06 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id bg12-20020a1709028e8c00b001a9567dc731sm4303381plb.24.2023.04.24.13.19.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Apr 2023 13:19:05 -0700 (PDT)
Message-ID: <6446e439.170a0220.9215c.8596@mx.google.com>
Date:   Mon, 24 Apr 2023 13:19:05 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.10.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.10.176-363-g1ef2000b94cb2
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-5.10.y baseline: 140 runs,
 6 regressions (v5.10.176-363-g1ef2000b94cb2)
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

stable-rc/linux-5.10.y baseline: 140 runs, 6 regressions (v5.10.176-363-g1e=
f2000b94cb2)

Regressions Summary
-------------------

platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
cubietruck                   | arm    | lab-baylibre  | gcc-10   | multi_v7=
_defconfig           | 1          =

hp-x360-12b-c...4020-octopus | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

hp-x360-14-G1-sona           | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

r8a7743-iwg20d-q7            | arm    | lab-cip       | gcc-10   | shmobile=
_defconfig           | 1          =

rk3399-gru-kevin             | arm64  | lab-collabora | gcc-10   | defconfi=
g+arm64-chromebook   | 2          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.10.y/ker=
nel/v5.10.176-363-g1ef2000b94cb2/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.10.y
  Describe: v5.10.176-363-g1ef2000b94cb2
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      1ef2000b94cb2a0bc4a1e822fd21885e80d65646 =



Test Regressions
---------------- =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
cubietruck                   | arm    | lab-baylibre  | gcc-10   | multi_v7=
_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/6446b2a4ff4dafd5a22e860e

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
76-363-g1ef2000b94cb2/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-c=
ubietruck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
76-363-g1ef2000b94cb2/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-c=
ubietruck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6446b2a4ff4dafd5a22e8613
        failing since 96 days (last pass: v5.10.158-107-gd2432186ff47, firs=
t fail: v5.10.162-852-geeaac3cf2eb3)

    2023-04-24T16:47:12.727770  <8>[   11.098644] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3527824_1.5.2.4.1>
    2023-04-24T16:47:12.837431  / # #
    2023-04-24T16:47:12.940333  export SHELL=3D/bin/sh
    2023-04-24T16:47:12.940813  #
    2023-04-24T16:47:13.042040  / # export SHELL=3D/bin/sh. /lava-3527824/e=
nvironment
    2023-04-24T16:47:13.042814  =

    2023-04-24T16:47:13.144624  / # . /lava-3527824/environment/lava-352782=
4/bin/lava-test-runner /lava-3527824/1
    2023-04-24T16:47:13.145972  =

    2023-04-24T16:47:13.146349  / # <3>[   11.451505] Bluetooth: hci0: comm=
and 0xfc18 tx timeout
    2023-04-24T16:47:13.150702  /lava-3527824/bin/lava-test-runner /lava-35=
27824/1 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-12b-c...4020-octopus | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6446b165840b9bda5e2e85ed

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
76-363-g1ef2000b94cb2/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-col=
labora/baseline-hp-x360-12b-ca0010nr-n4020-octopus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
76-363-g1ef2000b94cb2/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-col=
labora/baseline-hp-x360-12b-ca0010nr-n4020-octopus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6446b165840b9bda5e2e85f2
        failing since 26 days (last pass: v5.10.176, first fail: v5.10.176-=
105-g18265b240021)

    2023-04-24T16:42:03.163696  + set +x

    2023-04-24T16:42:03.169560  <8>[   10.989996] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10106248_1.4.2.3.1>

    2023-04-24T16:42:03.274192  / # #

    2023-04-24T16:42:03.374835  export SHELL=3D/bin/sh

    2023-04-24T16:42:03.375040  #

    2023-04-24T16:42:03.475549  / # export SHELL=3D/bin/sh. /lava-10106248/=
environment

    2023-04-24T16:42:03.475759  =


    2023-04-24T16:42:03.576312  / # . /lava-10106248/environment/lava-10106=
248/bin/lava-test-runner /lava-10106248/1

    2023-04-24T16:42:03.576654  =


    2023-04-24T16:42:03.581330  / # /lava-10106248/bin/lava-test-runner /la=
va-10106248/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-14-G1-sona           | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6446b177f60c42672e2e8648

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
76-363-g1ef2000b94cb2/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-col=
labora/baseline-hp-x360-14-G1-sona.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
76-363-g1ef2000b94cb2/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-col=
labora/baseline-hp-x360-14-G1-sona.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6446b177f60c42672e2e864d
        failing since 26 days (last pass: v5.10.176, first fail: v5.10.176-=
105-g18265b240021)

    2023-04-24T16:42:19.504306  + set +x

    2023-04-24T16:42:19.511210  <8>[   13.341848] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10106290_1.4.2.3.1>

    2023-04-24T16:42:19.619310  / # #

    2023-04-24T16:42:19.721941  export SHELL=3D/bin/sh

    2023-04-24T16:42:19.722726  #

    2023-04-24T16:42:19.824353  / # export SHELL=3D/bin/sh. /lava-10106290/=
environment

    2023-04-24T16:42:19.825137  =


    2023-04-24T16:42:19.926815  / # . /lava-10106290/environment/lava-10106=
290/bin/lava-test-runner /lava-10106290/1

    2023-04-24T16:42:19.928091  =


    2023-04-24T16:42:19.934064  / # /lava-10106290/bin/lava-test-runner /la=
va-10106290/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
r8a7743-iwg20d-q7            | arm    | lab-cip       | gcc-10   | shmobile=
_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/6446afad04424427972e8639

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: shmobile_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
76-363-g1ef2000b94cb2/arm/shmobile_defconfig/gcc-10/lab-cip/baseline-r8a774=
3-iwg20d-q7.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
76-363-g1ef2000b94cb2/arm/shmobile_defconfig/gcc-10/lab-cip/baseline-r8a774=
3-iwg20d-q7.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6446afad04424427972e8=
63a
        failing since 32 days (last pass: v5.10.175-100-g1686e1df6521, firs=
t fail: v5.10.176) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
rk3399-gru-kevin             | arm64  | lab-collabora | gcc-10   | defconfi=
g+arm64-chromebook   | 2          =


  Details:     https://kernelci.org/test/plan/id/6446b3be29ab88221b2e8616

  Results:     84 PASS, 2 FAIL, 1 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
76-363-g1ef2000b94cb2/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora=
/baseline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
76-363-g1ef2000b94cb2/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora=
/baseline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-usb2phy1-probed: https://kernelci.org/test/cas=
e/id/6446b3be29ab88221b2e861c
        failing since 41 days (last pass: v5.10.173, first fail: v5.10.173-=
4-g955623617f2f)

    2023-04-24T16:51:59.247637  /lava-10106356/1/../bin/lava-test-case

    2023-04-24T16:51:59.258783  <8>[   35.034572] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-usb2phy1-probed RESULT=3Dfail>
   =


  * baseline.bootrr.rockchip-usb2phy0-probed: https://kernelci.org/test/cas=
e/id/6446b3be29ab88221b2e861d
        failing since 41 days (last pass: v5.10.173, first fail: v5.10.173-=
4-g955623617f2f)

    2023-04-24T16:51:58.209599  /lava-10106356/1/../bin/lava-test-case

    2023-04-24T16:51:58.220876  <8>[   33.997436] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-usb2phy0-probed RESULT=3Dfail>
   =

 =20
