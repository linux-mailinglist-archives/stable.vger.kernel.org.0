Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30269678237
	for <lists+stable@lfdr.de>; Mon, 23 Jan 2023 17:51:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232201AbjAWQvu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Jan 2023 11:51:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232658AbjAWQvt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 Jan 2023 11:51:49 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA6102CC51
        for <stable@vger.kernel.org>; Mon, 23 Jan 2023 08:51:47 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id z1-20020a17090a66c100b00226f05b9595so11585556pjl.0
        for <stable@vger.kernel.org>; Mon, 23 Jan 2023 08:51:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=QuuvSBefDzyhhbQ1Qc2eBt6Q73enXDsYaafsMmsdVpM=;
        b=bRJlziFsmFnBiZkAOCEBxiKAmrw+qM524oC72MDK+bnOtlCkEOBjpd94bYBnNgo9Kc
         trRY3lfvM15wfhK2k6XnbifKEryMT8H9xF3jn6E4vWJSEB1ttPKQ2vfyMlBAQkJFpHXI
         I7mlzTnykTzjScNPUmcawZiUp37VJTkJIb0dXwT2kZG9xcKv4u8f1ukSxC4P1woNrasJ
         oOqJ9mhv+oBrJjprv/cMo/H9sz0RSWjekWvf8h2woEx6HJUaajcpQAthgg7rzk85BeWK
         ig3olMyKxMkC4/wLcOe4cSz68cnkvH7mSlHg/XgU/hEGUFJKefZDHjeWAvGaM/wyh5OQ
         zgNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QuuvSBefDzyhhbQ1Qc2eBt6Q73enXDsYaafsMmsdVpM=;
        b=4R6s+Mb7iOz8Kd84FAbq8udEKsZGBdvODUrPbcg8f9b3XWzHPxaLu2lBuSwsdjFZKG
         +7iZn7/FdDgV/Y64VvYzRxHQm4KD/DwGbzd0U01429ZBXI1zDglAGrw7DlQ8RNqDuJFP
         /mwTV+KtePIWWp1fWn/eLA7vjaZI3wdpfHjlszx9w9Evymdq/NrnGmJnDDeXPrnhzS0M
         aX2wr4liQKBFTjXZTRRhNRVxBlAiAh87dEYmqUNBkHFW033BEiC6HUjlEzj0b6R5daBm
         v+c0b3aD6dBz+edmydwjRf48Uwd6Xy/mv0etvEVa0fQZ+ot/8wcE+cO0/BWo/+GLN9kK
         4Vbg==
X-Gm-Message-State: AFqh2kpswh8s0bcnLwcU13G4/ptsh6VxhxNnSUNvqWIF7kEzEeIG00qL
        QMgnEcmAQ/nzq31F8sMdEm5yCTrA+ufGIwMYTGQ=
X-Google-Smtp-Source: AMrXdXt8E0+iRPnD4VYeOyLM7dhc63ZrZbF67OM81v05ATzMYdrdjtZExkCV9dC7ThrRqLRM9Q4k0Q==
X-Received: by 2002:a05:6a20:7b1b:b0:b8:7c95:de84 with SMTP id s27-20020a056a207b1b00b000b87c95de84mr22088535pzh.33.1674492707111;
        Mon, 23 Jan 2023 08:51:47 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id q11-20020a65494b000000b0047850cecbdesm27508781pgs.69.2023.01.23.08.51.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Jan 2023 08:51:46 -0800 (PST)
Message-ID: <63cebb22.650a0220.3a980.b43c@mx.google.com>
Date:   Mon, 23 Jan 2023 08:51:46 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.15.y
X-Kernelci-Kernel: v5.15.87-219-g60931c95bb6d
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-5.15.y baseline: 162 runs,
 2 regressions (v5.15.87-219-g60931c95bb6d)
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

stable-rc/linux-5.15.y baseline: 162 runs, 2 regressions (v5.15.87-219-g609=
31c95bb6d)

Regressions Summary
-------------------

platform                | arch  | lab          | compiler | defconfig      =
    | regressions
------------------------+-------+--------------+----------+----------------=
----+------------
cubietruck              | arm   | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =

sun50i-a64-bananapi-m64 | arm64 | lab-clabbe   | gcc-10   | defconfig      =
    | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.15.y/ker=
nel/v5.15.87-219-g60931c95bb6d/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.15.y
  Describe: v5.15.87-219-g60931c95bb6d
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      60931c95bb6db9ce421e75a907a245f828c11243 =



Test Regressions
---------------- =



platform                | arch  | lab          | compiler | defconfig      =
    | regressions
------------------------+-------+--------------+----------+----------------=
----+------------
cubietruck              | arm   | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/63ce88dea6e397f657915ebc

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.8=
7-219-g60931c95bb6d/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cub=
ietruck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.8=
7-219-g60931c95bb6d/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cub=
ietruck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230114.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63ce88dea6e397f657915ec1
        failing since 6 days (last pass: v5.15.82-124-gd731c63c25d1, first =
fail: v5.15.87-101-g5bcc318cb4cd)

    2023-01-23T13:17:03.226021  + set +x<8>[    9.965230] <LAVA_SIGNAL_ENDR=
UN 0_dmesg 3190371_1.5.2.4.1>
    2023-01-23T13:17:03.226790  =

    2023-01-23T13:17:03.336383  / # #
    2023-01-23T13:17:03.439978  export SHELL=3D/bin/sh
    2023-01-23T13:17:03.443171  #
    2023-01-23T13:17:03.545677  / # export SHELL=3D/bin/sh. /lava-3190371/e=
nvironment
    2023-01-23T13:17:03.546758  <3>[   10.193664] Bluetooth: hci0: command =
0xfc18 tx timeout
    2023-01-23T13:17:03.547374  =

    2023-01-23T13:17:03.649655  / # . /lava-3190371/environment/lava-319037=
1/bin/lava-test-runner /lava-3190371/1
    2023-01-23T13:17:03.651390   =

    ... (13 line(s) more)  =

 =



platform                | arch  | lab          | compiler | defconfig      =
    | regressions
------------------------+-------+--------------+----------+----------------=
----+------------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe   | gcc-10   | defconfig      =
    | 1          =


  Details:     https://kernelci.org/test/plan/id/63ce8a76e71ff4b910915ec5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.8=
7-219-g60931c95bb6d/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-b=
ananapi-m64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.8=
7-219-g60931c95bb6d/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-b=
ananapi-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230114.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63ce8a76e71ff4b910915=
ec6
        new failure (last pass: v5.15.87-219-g1f28d5a208cc) =

 =20
