Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01C776D3D4F
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 08:27:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231426AbjDCG1J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 02:27:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231592AbjDCG0z (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 02:26:55 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 510FDE053
        for <stable@vger.kernel.org>; Sun,  2 Apr 2023 23:26:39 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id l9-20020a17090a3f0900b0023d32684e7fso12968629pjc.1
        for <stable@vger.kernel.org>; Sun, 02 Apr 2023 23:26:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112; t=1680503198;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=zYccP5eS8gM5AeVzXlecaQ9/sVzAas1mU1ovKL2PX+E=;
        b=PAoO/6/tbLLOD32IJ/49PPp53hPghh22qGeQhqf2WLF5AOFU7A136m0s+SHkkAqjPV
         umnqcnB5Prw+nwzQ4VXbWMN8yeE/4alKZjm+T3YpHW4yKSIYcYg/i6ccKyWFCophK1zE
         IiQlRWOg3+24dJJJHfVvmrghSa4YdXq51mABTBtP0bybnE4uCtn4pNKLrypkj9vSrfGE
         LvygYhKrqCtwrWe+7/4QS2Upo7LVsFk3idKh0JDAXHWVeHNqcrQ5EywwGrN1LnI06DNR
         gt5CkSEz1MxVfTPpwp5imCbElQymAKAlWLHPAVWXR/GHQcmMgHrgXyOaeIhkcMS21rTZ
         ggIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680503198;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zYccP5eS8gM5AeVzXlecaQ9/sVzAas1mU1ovKL2PX+E=;
        b=fJ7GokqIN4doeb8Xrx6nTt9CNvEaWIX0fbJe3QHCB84xCt7gf5qUTs+Sxo+oSQ1VNJ
         b7hNkq+pGKfygAgsy5/Z/81wVJxz6h0c144yLKl4oLP+ZzGrQstx/+sAOOzGfLi75hZ9
         h0031DqorlmfWtn9sVmDMjLkbkQ9KBMIklzgj5aHOjUvQJ+nq4pG08YdvvoI4Kiajain
         PlSWpAbchbKpDjiyxKhNCpp3BPsIeWAqV/VLUkan4O/qULLhg9G1IyEgHDMvaN/CJ3Ob
         YvFT8TobvQIZJen2BOpnuMjsxfBoq1JWUos5H8rdTWQiTbViFRDrRlDzt8UkZt95mjaq
         FWmw==
X-Gm-Message-State: AAQBX9e0xB1wUsuwaTT4VW1whlKGXJbJ5qQSnnmbx5lZDbkUDhUaqd9R
        K/g8M6NQlymLxn2SwQ3NnbVa/I9NqrIHb6Pa4nI=
X-Google-Smtp-Source: AKy350Y7FVwHyJ1kihEwSJ13PUCzJtVTjbcsw5u3f5L2wnQvfZ6sIq6SYuFtbCgLvPSjVZkLwg+CEA==
X-Received: by 2002:a17:90b:3148:b0:23b:49ad:a350 with SMTP id ip8-20020a17090b314800b0023b49ada350mr39189874pjb.9.1680503198586;
        Sun, 02 Apr 2023 23:26:38 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id s1-20020a17090ae68100b0023d0290afbdsm9046756pjy.4.2023.04.02.23.26.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 02 Apr 2023 23:26:38 -0700 (PDT)
Message-ID: <642a719e.170a0220.df458.2188@mx.google.com>
Date:   Sun, 02 Apr 2023 23:26:38 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.19
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.19.279-68-g4af903d14171
Subject: stable-rc/queue/4.19 baseline: 105 runs,
 2 regressions (v4.19.279-68-g4af903d14171)
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

stable-rc/queue/4.19 baseline: 105 runs, 2 regressions (v4.19.279-68-g4af90=
3d14171)

Regressions Summary
-------------------

platform      | arch | lab          | compiler | defconfig          | regre=
ssions
--------------+------+--------------+----------+--------------------+------=
------
at91sam9g20ek | arm  | lab-broonie  | gcc-10   | multi_v5_defconfig | 1    =
      =

cubietruck    | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig | 1    =
      =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.279-68-g4af903d14171/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.279-68-g4af903d14171
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      4af903d141714113239039c5c7eece526b297ff3 =



Test Regressions
---------------- =



platform      | arch | lab          | compiler | defconfig          | regre=
ssions
--------------+------+--------------+----------+--------------------+------=
------
at91sam9g20ek | arm  | lab-broonie  | gcc-10   | multi_v5_defconfig | 1    =
      =


  Details:     https://kernelci.org/test/plan/id/642a3d110eef8ed97962f770

  Results:     42 PASS, 9 FAIL, 1 SKIP
  Full config: multi_v5_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.279=
-68-g4af903d14171/arm/multi_v5_defconfig/gcc-10/lab-broonie/baseline-at91sa=
m9g20ek.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.279=
-68-g4af903d14171/arm/multi_v5_defconfig/gcc-10/lab-broonie/baseline-at91sa=
m9g20ek.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642a3d110eef8ed97962f79f
        failing since 6 days (last pass: v4.19.279-25-g8270940878fa3, first=
 fail: v4.19.279-25-gc95d797f10041)

    2023-04-03T02:41:44.286000  + set +x
    2023-04-03T02:41:44.291227  <8><LAVA_SIGNAL_ENDRUN 0_dmesg 267342_1.5.2=
.4.1>
    2023-04-03T02:41:44.404671  / # #
    2023-04-03T02:41:44.507801  export SHELL=3D/bin/sh
    2023-04-03T02:41:44.508638  #
    2023-04-03T02:41:44.610611  / # export SHELL=3D/bin/sh. /lava-267342/en=
vironment
    2023-04-03T02:41:44.611428  =

    2023-04-03T02:41:44.713455  / # . /lava-267342/environment/lava-267342/=
bin/lava-test-runner /lava-267342/1
    2023-04-03T02:41:44.714820  =

    2023-04-03T02:41:44.721269  / # /lava-267342/bin/lava-test-runner /lava=
-267342/1 =

    ... (12 line(s) more)  =

 =



platform      | arch | lab          | compiler | defconfig          | regre=
ssions
--------------+------+--------------+----------+--------------------+------=
------
cubietruck    | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig | 1    =
      =


  Details:     https://kernelci.org/test/plan/id/642a40c758c67e098662f792

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.279=
-68-g4af903d14171/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubie=
truck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.279=
-68-g4af903d14171/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubie=
truck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642a40c758c67e098662f797
        failing since 75 days (last pass: v4.19.269-9-gce7b59ec9d48, first =
fail: v4.19.269-521-g305d312d039a)

    2023-04-03T02:58:06.456811  <8>[    7.283647] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3466238_1.5.2.4.1>
    2023-04-03T02:58:06.566088  / # #
    2023-04-03T02:58:06.669406  export SHELL=3D/bin/sh
    2023-04-03T02:58:06.670439  #
    2023-04-03T02:58:06.772378  / # export SHELL=3D/bin/sh. /lava-3466238/e=
nvironment
    2023-04-03T02:58:06.773036  =

    2023-04-03T02:58:06.874866  / # . /lava-3466238/environment/lava-346623=
8/bin/lava-test-runner /lava-3466238/1
    2023-04-03T02:58:06.876066  =

    2023-04-03T02:58:06.885225  / # /lava-3466238/bin/lava-test-runner /lav=
a-3466238/1
    2023-04-03T02:58:06.959758  + export 'TESTRUN_ID=3D1_bootrr' =

    ... (11 line(s) more)  =

 =20
