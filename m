Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 427F7517BA0
	for <lists+stable@lfdr.de>; Tue,  3 May 2022 03:20:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229476AbiECBWb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 May 2022 21:22:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbiECBWa (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 May 2022 21:22:30 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC941326D8
        for <stable@vger.kernel.org>; Mon,  2 May 2022 18:18:59 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id j70so2021807pge.1
        for <stable@vger.kernel.org>; Mon, 02 May 2022 18:18:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=a8tn+WeOIwrJYCuYGoCqDRu97tlbTutqsbQ2qXbOX2o=;
        b=izp9uL+9sbgsk8zOK6bSwyGEo1jxpY8ppDTDlE7eVx3pXvyYPLeh88FOPCOpOADWvy
         0We1bbPx78nLTXOAyzEj2NL5sTiuAuXu0Qw7VQT78/im/2RQiBguSqjxv744p2zZDRUn
         aPlTlWr6e6dtXuovwe/a5n5cyK/myNaGUOxN6mhKh5NNAWix6RagENICN0JNXsWdi+T/
         Zba8bC2qyf9MOwgyHEsgvqzaubH71S2ueK/TP/xVQmyODNrnueuuVs/eu8GSp9Mjc6DS
         G/7ZGQa7RRjE/YFw1Jo7mDo9QjAtKUIFa7r3g+zovVzGqG5NdG5xpOLSckJ+bhX6rtH3
         9JuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=a8tn+WeOIwrJYCuYGoCqDRu97tlbTutqsbQ2qXbOX2o=;
        b=vnz/LuNlueVt5ZMejVyQ8AF9GJRKCvvLVDayqHuXundJY9MC4c601nmMnhcFb3eQTw
         KHs3ioTUmrzw+H4ysDYZM85jO1LUGXcayKdBKx7nfPLto3ZpueQ4pfJ6Tb/Q7+LF1/H4
         4LDSyfu4qUeJD0rGUZKGRptnLufuDycAkJDJIM3G/6U/M7TL8TaEymu7fwlEGYNXP1Nu
         X5WGj4u9uTvPPrWPeMgHeM2vTSXaFvEGWmoL7KNbfQUYzzvdeZSYEu/3MJ9MJaB4HVdp
         oNsf8hg0xf2aC6esUJrAYLOuvmPJBCtZ2dcWbk7tPwjjmb00XvIZyNPKnJEbtYO24WkD
         smUQ==
X-Gm-Message-State: AOAM531DPFDGg5VLr3QzsMKZbzp12uR4oGHDy4+acQVyGU0RpEHvWTg8
        GlvudsZrR27D/vIQebTy15aNvu7HW8yAHHDZQKg=
X-Google-Smtp-Source: ABdhPJyjlUEUURhcZQdkO3Eju7JvCZOSxRvTYMPc6zKNhoA7Oi+mzod/4MApjE1MrrWZzN1FWSHCQQ==
X-Received: by 2002:a65:410a:0:b0:399:38b9:8ba with SMTP id w10-20020a65410a000000b0039938b908bamr11740612pgp.526.1651540739329;
        Mon, 02 May 2022 18:18:59 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id k1-20020a17090ac50100b001cd4989ff62sm320300pjt.41.2022.05.02.18.18.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 May 2022 18:18:58 -0700 (PDT)
Message-ID: <62708302.1c69fb81.55704.1275@mx.google.com>
Date:   Mon, 02 May 2022 18:18:58 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.17.5-197-gdb224daa1cd6
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/5.17
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.17 baseline: 130 runs,
 2 regressions (v5.17.5-197-gdb224daa1cd6)
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

stable-rc/queue/5.17 baseline: 130 runs, 2 regressions (v5.17.5-197-gdb224d=
aa1cd6)

Regressions Summary
-------------------

platform          | arch | lab          | compiler | defconfig           | =
regressions
------------------+------+--------------+----------+---------------------+-=
-----------
am57xx-beagle-x15 | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig  | =
1          =

am57xx-beagle-x15 | arm  | lab-baylibre | gcc-10   | omap2plus_defconfig | =
1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.17/ker=
nel/v5.17.5-197-gdb224daa1cd6/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.17
  Describe: v5.17.5-197-gdb224daa1cd6
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      db224daa1cd655c5882a795bb0c5e982091df0d8 =



Test Regressions
---------------- =



platform          | arch | lab          | compiler | defconfig           | =
regressions
------------------+------+--------------+----------+---------------------+-=
-----------
am57xx-beagle-x15 | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig  | =
1          =


  Details:     https://kernelci.org/test/plan/id/62704e00769aff35d5dc7b22

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.17/v5.17.5-1=
97-gdb224daa1cd6/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-am57xx=
-beagle-x15.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.17/v5.17.5-1=
97-gdb224daa1cd6/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-am57xx=
-beagle-x15.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220428.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62704e00769aff35d5dc7=
b23
        new failure (last pass: v5.17.3-7-g363c8c6fd7ed5) =

 =



platform          | arch | lab          | compiler | defconfig           | =
regressions
------------------+------+--------------+----------+---------------------+-=
-----------
am57xx-beagle-x15 | arm  | lab-baylibre | gcc-10   | omap2plus_defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/627051fdbdd79ded53dc7b31

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.17/v5.17.5-1=
97-gdb224daa1cd6/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-am57x=
x-beagle-x15.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.17/v5.17.5-1=
97-gdb224daa1cd6/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-am57x=
x-beagle-x15.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220428.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/627051fdbdd79ded53dc7=
b32
        new failure (last pass: v5.17.5-1-geddd8f1a8d35) =

 =20
