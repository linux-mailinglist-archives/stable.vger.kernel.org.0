Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6FBB6C9A93
	for <lists+stable@lfdr.de>; Mon, 27 Mar 2023 06:37:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229829AbjC0Ehl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Mar 2023 00:37:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229619AbjC0Ehl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Mar 2023 00:37:41 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5AB44C31
        for <stable@vger.kernel.org>; Sun, 26 Mar 2023 21:37:39 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id f22so3099628plr.0
        for <stable@vger.kernel.org>; Sun, 26 Mar 2023 21:37:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112; t=1679891859;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=w6N5X/apMVm65GzsuVHV7LczEndbtGv77pDPnRfh1Uc=;
        b=xWYc8/1MXHz7CUIHAnODk+0Z0JWAidRLvOLUOB6B6iNf+sg4PAtwUu7W3xuMaUGDtf
         NQSye/E10YHBZHyf9zeXAVf4Wsf6qnQJ001H9xcODWCT7WsNxIgXfHJGxJVFxYNFCNHB
         vVqfTXYWgYYeZq6eVrnlB8E6WXpBZch7/11PCgj8PxsyAA2R2l8ep9EQnQ3Dg2Ttz3tn
         crYJRSOZErnJbcHgWq7RHeAS9VZH+u9chloZ1VWL34xAHMa0smR8T/TP8S2kksUntQyL
         zShSBh5g0uhKvwkZT2mMLD7FDAgCiwh05V68Kd7ql6Uq2VIVgDvG7oGt6+ubM6+Q+pyH
         UHOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679891859;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=w6N5X/apMVm65GzsuVHV7LczEndbtGv77pDPnRfh1Uc=;
        b=yF35D/Nb7NYFWPCgWfu+hGNVJtSUewwctfMHdRfCTRVEtC+GNmU449EC4P9nbMGeln
         23V8nXdldhJP1HdWMCIFbz1FD3ykdjO0SlBPeLNnhFVfunH3twjoD4bK/SRCr4D59dkr
         Oe1ZlTXLN+TJJhDAo724RpxWRoxwvOIFioO0sZNiMk2JpGxdnTExQ8DFuaYdkfX/8/my
         swDyf68RMS1cqe51tLpzf4Maz0XfjRIboyi68GURm1LyrsDUPldgDR0c8ChgxkbOsC6f
         CYMqU3sDsGNhDdny4gT5SXfOFCqDPsMNKX3eQzIefJCGZ2iAJnA7T3x9YO5v3Ywc3+CC
         P8sQ==
X-Gm-Message-State: AAQBX9cpyu6IsDBlI+g6SsDUqDBst0/dN09LuZyhevrcSAISfioe2vIo
        94vQETTkSSVDy6aCwkus5KdoKUs4okDzigfNpYk=
X-Google-Smtp-Source: AKy350Yo/XR3joYY3KKtY6ddn373Q60lGV6Q8CaGW1eP7EfrhugFXCrIsve3Rd/IxIkDyq4zBaJstA==
X-Received: by 2002:a17:902:6b82:b0:1a1:bb4e:4eb8 with SMTP id p2-20020a1709026b8200b001a1bb4e4eb8mr9925762plk.62.1679891858935;
        Sun, 26 Mar 2023 21:37:38 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id jm2-20020a17090304c200b001a04d27ee92sm13017126plb.241.2023.03.26.21.37.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Mar 2023 21:37:38 -0700 (PDT)
Message-ID: <64211d92.170a0220.ed213.9120@mx.google.com>
Date:   Sun, 26 Mar 2023 21:37:38 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.10
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.10.176-58-g9f598d291eba3
Subject: stable-rc/queue/5.10 baseline: 128 runs,
 4 regressions (v5.10.176-58-g9f598d291eba3)
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

stable-rc/queue/5.10 baseline: 128 runs, 4 regressions (v5.10.176-58-g9f598=
d291eba3)

Regressions Summary
-------------------

platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
cubietruck                   | arm   | lab-baylibre  | gcc-10   | multi_v7_=
defconfig         | 1          =

rk3399-gru-kevin             | arm64 | lab-collabora | gcc-10   | defconfig=
+arm64-chromebook | 2          =

sun8i-h3-libretech-all-h3-cc | arm   | lab-baylibre  | gcc-10   | multi_v7_=
defconfig         | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.176-58-g9f598d291eba3/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.176-58-g9f598d291eba3
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      9f598d291eba357f4d4021679edc87177bde0779 =



Test Regressions
---------------- =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
cubietruck                   | arm   | lab-baylibre  | gcc-10   | multi_v7_=
defconfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/6420e67c64141339179c957b

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-58-g9f598d291eba3/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubi=
etruck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-58-g9f598d291eba3/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubi=
etruck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6420e67c64141339179c9584
        failing since 59 days (last pass: v5.10.165-76-g5c2e982fcf18, first=
 fail: v5.10.165-77-g4600242c13ed)

    2023-03-27T00:42:26.241274  <8>[   11.019896] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3447394_1.5.2.4.1>
    2023-03-27T00:42:26.354345  / # #
    2023-03-27T00:42:26.458358  export SHELL=3D/bin/sh
    2023-03-27T00:42:26.459270  #
    2023-03-27T00:42:26.561257  / # export SHELL=3D/bin/sh. /lava-3447394/e=
nvironment
    2023-03-27T00:42:26.562187  =

    2023-03-27T00:42:26.664577  / # . /lava-3447394/environment/lava-344739=
4/bin/lava-test-runner /lava-3447394/1
    2023-03-27T00:42:26.666701  =

    2023-03-27T00:42:26.671649  / # /lava-3447394/bin/lava-test-runner /lav=
a-3447394/1
    2023-03-27T00:42:26.759630  + export 'TESTRUN_ID=3D1_bootrr' =

    ... (11 line(s) more)  =

 =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
rk3399-gru-kevin             | arm64 | lab-collabora | gcc-10   | defconfig=
+arm64-chromebook | 2          =


  Details:     https://kernelci.org/test/plan/id/6420e67b64141339179c9520

  Results:     84 PASS, 2 FAIL, 1 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-58-g9f598d291eba3/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/ba=
seline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-58-g9f598d291eba3/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/ba=
seline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-usb2phy1-probed: https://kernelci.org/test/cas=
e/id/6420e67b64141339179c952a
        failing since 12 days (last pass: v5.10.172-529-g06956b9e9396, firs=
t fail: v5.10.173-69-gfcbe6bd469ed)

    2023-03-27T00:42:22.059476  /lava-9780077/1/../bin/lava-test-case
   =


  * baseline.bootrr.rockchip-usb2phy0-probed: https://kernelci.org/test/cas=
e/id/6420e67b64141339179c952b
        failing since 12 days (last pass: v5.10.172-529-g06956b9e9396, firs=
t fail: v5.10.173-69-gfcbe6bd469ed)

    2023-03-27T00:42:19.996807  <8>[   59.942738] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-usb2phy-driver-present RESULT=3Dpass>

    2023-03-27T00:42:21.023265  /lava-9780077/1/../bin/lava-test-case

    2023-03-27T00:42:21.033890  <8>[   60.980618] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-usb2phy0-probed RESULT=3Dfail>
   =

 =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
sun8i-h3-libretech-all-h3-cc | arm   | lab-baylibre  | gcc-10   | multi_v7_=
defconfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/6420e60305099c8f639c955f

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-58-g9f598d291eba3/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-sun8=
i-h3-libretech-all-h3-cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.176=
-58-g9f598d291eba3/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-sun8=
i-h3-libretech-all-h3-cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6420e60405099c8f639c9568
        failing since 53 days (last pass: v5.10.165-139-gefb57ce0f880, firs=
t fail: v5.10.165-149-ge30e8271d674)

    2023-03-27T00:40:20.667459  / # #
    2023-03-27T00:40:20.769314  export SHELL=3D/bin/sh
    2023-03-27T00:40:20.769783  #
    2023-03-27T00:40:20.871215  / # export SHELL=3D/bin/sh. /lava-3447381/e=
nvironment
    2023-03-27T00:40:20.871607  =

    2023-03-27T00:40:20.973030  / # . /lava-3447381/environment/lava-344738=
1/bin/lava-test-runner /lava-3447381/1
    2023-03-27T00:40:20.973701  =

    2023-03-27T00:40:20.977885  / # /lava-3447381/bin/lava-test-runner /lav=
a-3447381/1
    2023-03-27T00:40:21.042065  + export 'TESTRUN_ID=3D1_bootrr'
    2023-03-27T00:40:21.089741  + cd /lava-3447381/1/tests/1_bootrr =

    ... (10 line(s) more)  =

 =20
