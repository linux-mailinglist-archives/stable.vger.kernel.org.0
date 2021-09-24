Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4D60417E6E
	for <lists+stable@lfdr.de>; Sat, 25 Sep 2021 01:51:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232358AbhIXXx3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Sep 2021 19:53:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232123AbhIXXx2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Sep 2021 19:53:28 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E9DEC061571
        for <stable@vger.kernel.org>; Fri, 24 Sep 2021 16:51:55 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id lb1-20020a17090b4a4100b001993f863df2so8735445pjb.5
        for <stable@vger.kernel.org>; Fri, 24 Sep 2021 16:51:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=BhcOrKFN2BDv9Ck/8BJ0hfYxO8cb+G63jvtonRTSJdk=;
        b=g8qFFKbTLNwGmwplPiZYle9il/UboLLZ3nY4K+tUBsZu/kak80PgpSrJOefhbXuk32
         +yceyiOnxCsKn7fA9rDuDu4QcMYe37xQkhth4sY9AHToibCI9n8Hedex85UlcKopysq/
         z+1G2QL09jAFjGJ/vvUc36C3KYYCG32gKldGpdCHf3TZDOBbGGo7uhQ8AEFILEskqBIj
         zF62K8pCVNFu/EwYVGYEBIr1n53FUUGO1GNvK9tcUooCrTbC+L1DMR7K7iJKgsbZD6ku
         psqz511A5RZSvatZ30A3aMfj60AywKTH6WyzeeRYEde8iPZBbZ/WFnvoVMA99LoGkpyo
         b6OA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=BhcOrKFN2BDv9Ck/8BJ0hfYxO8cb+G63jvtonRTSJdk=;
        b=e3DR6ITqQjKdBibP6T973j2Bea6suxogshGAP0MgKsBgNuLolkhxu+E1gMgRuq9W1S
         BH/YfA0hKPl6h+aco9u51c8pFBHXKHA+l2R15SzVOHm49sniLfAexjcXhdMCtVjXrEX2
         7t7HBeGok7Cze7rZ7Cu8NDUyuCpWRvgG2ZORjRqek7j5eFNqtAgrjRarutes0dtc9dkK
         yggfIAFJopbf+6ZeffgG8uD8TQKdt7PSEIa4twKVPyXFLXQu93Z6ICsrMn8x/Gl69Rye
         vMhUK5YDbTmqqg9y5mBaMvoRYm4SnuQzGk6bptRBpPlzkonv/B43os7Fau0205cAWVmd
         EDYg==
X-Gm-Message-State: AOAM530fKSlW1K78l4h4GEcynEsW3X37KDn0nU+ul8ZjFogfSeswY8Xz
        EwaZwKHS+7aNLWZ6tciLX7co2Vt79CqYWbNa
X-Google-Smtp-Source: ABdhPJx1AIqPVZfLLXfTuBuiX1iUu7I1VfIQAjtWmstAsN/yDoTDgEpxgAdGKVrf7LB/d/YBcDXQDg==
X-Received: by 2002:a17:90b:150:: with SMTP id em16mr5218283pjb.63.1632527514351;
        Fri, 24 Sep 2021 16:51:54 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id r76sm10045051pfc.2.2021.09.24.16.51.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Sep 2021 16:51:54 -0700 (PDT)
Message-ID: <614e649a.1c69fb81.d2e86.f1a8@mx.google.com>
Date:   Fri, 24 Sep 2021 16:51:54 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.10.68-63-g964be936e732
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
Subject: stable-rc/queue/5.10 baseline: 79 runs,
 5 regressions (v5.10.68-63-g964be936e732)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 79 runs, 5 regressions (v5.10.68-63-g964be93=
6e732)

Regressions Summary
-------------------

platform                 | arch | lab           | compiler | defconfig     =
     | regressions
-------------------------+------+---------------+----------+---------------=
-----+------------
imx6q-var-dt6customboard | arm  | lab-baylibre  | gcc-8    | multi_v7_defco=
nfig | 2          =

rk3288-veyron-jaq        | arm  | lab-collabora | gcc-8    | multi_v7_defco=
nfig | 3          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.68-63-g964be936e732/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.68-63-g964be936e732
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      964be936e7327902cf883a8b9ac42db56a40dfe7 =



Test Regressions
---------------- =



platform                 | arch | lab           | compiler | defconfig     =
     | regressions
-------------------------+------+---------------+----------+---------------=
-----+------------
imx6q-var-dt6customboard | arm  | lab-baylibre  | gcc-8    | multi_v7_defco=
nfig | 2          =


  Details:     https://kernelci.org/test/plan/id/614e238fed36c2f92199a2ee

  Results:     4 PASS, 2 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.68-=
63-g964be936e732/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-imx6q-v=
ar-dt6customboard.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.68-=
63-g964be936e732/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-imx6q-v=
ar-dt6customboard.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.alert: https://kernelci.org/test/case/id/614e238fed36c2f=
92199a2f5
        new failure (last pass: v5.10.68-62-g5f146c9b42a5)
        4 lines

    2021-09-24T19:14:11.113504  kern  :alert : 8<--- cut here ---
    2021-09-24T19:14:11.144471  kern  :alert : Unable to handle kernel NULL=
 pointer dereference at virtual address 00000313
    2021-09-24T19:14:11.145982  kern  :alert : pgd =3D (ptrval)<8>[   39.46=
8933] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Dalert RESULT=3Dfail UNITS=3Dline=
s MEASUREMENT=3D4>
    2021-09-24T19:14:11.146314  =

    2021-09-24T19:14:11.146573  kern  :alert : [00000313] *pgd=3D00000000   =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/614e238fed36c2f=
92199a2f6
        new failure (last pass: v5.10.68-62-g5f146c9b42a5)
        47 lines

    2021-09-24T19:14:11.203462  kern  :emerg : Internal error: Oops: 17 [#1=
] SMP ARM
    2021-09-24T19:14:11.203760  kern  :emerg : Process kworker/0:4 (pid: 54=
, stack limit =3D 0x(ptrval))
    2021-09-24T19:14:11.204022  kern  :emerg : Stack: (0xc2405d50 to 0xc240=
6000)
    2021-09-24T19:14:11.204526  kern  :emerg : 5d40:                       =
              c34325b0 c34325b4 c3432400 c3432414
    2021-09-24T19:14:11.204789  kern  :emerg : 5d60: c144af4c c09c7614 c240=
4000 ef86b5c0 8020000b c3432400 000002f3 b792ec88
    2021-09-24T19:14:11.205037  kern  :emerg : 5d80: c19c788c c2001d80 c39a=
d000 ef86b5a0 c09d4f44 c144af4c c19c7870 b792ec88
    2021-09-24T19:14:11.246594  kern  :emerg : 5da0: c19c788c c39ae2c0 c39b=
1f80 c3432400 c3432414 c144af4c c19c7870 0000000c
    2021-09-24T19:14:11.246892  kern  :emerg : 5dc0: c19c788c c09d4f14 c144=
8c74 00000000 c343240c c3432400 fffffdfb c2298c10
    2021-09-24T19:14:11.247412  kern  :emerg : 5de0: c3b037c0 c09aac5c c343=
2400 bf048000 fffffdfb bf044138 c39b0ec0 c3429b08
    2021-09-24T19:14:11.247677  kern  :emerg : 5e00: 00000120 c3af00c0 c3b0=
37c0 c0a04a90 c39b0ec0 c39b0ec0 00000040 c39b0ec0 =

    ... (34 line(s) more)  =

 =



platform                 | arch | lab           | compiler | defconfig     =
     | regressions
-------------------------+------+---------------+----------+---------------=
-----+------------
rk3288-veyron-jaq        | arm  | lab-collabora | gcc-8    | multi_v7_defco=
nfig | 3          =


  Details:     https://kernelci.org/test/plan/id/614e2f11947ac2b93599a30e

  Results:     67 PASS, 3 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.68-=
63-g964be936e732/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288=
-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.68-=
63-g964be936e732/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288=
-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/614e2f11947ac2b93599a322
        failing since 101 days (last pass: v5.10.43-44-g253317604975, first=
 fail: v5.10.43-130-g87b5f83f722c)

    2021-09-24T20:03:18.047956  /lava-4580400/1/../bin/lava-test-case<8>[  =
 13.277018] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Drockchip-iodomain-grf-prob=
ed RESULT=3Dfail>
    2021-09-24T20:03:18.048531  =

    2021-09-24T20:03:18.048953  /lava-4580400/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/614e2f11947ac2b93599a337
        failing since 101 days (last pass: v5.10.43-44-g253317604975, first=
 fail: v5.10.43-130-g87b5f83f722c)

    2021-09-24T20:03:16.604206  /lava-4580400/1/../bin/lava-test-case
    2021-09-24T20:03:16.622184  <8>[   11.850736] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/614e2f11947ac2b93599a338
        failing since 101 days (last pass: v5.10.43-44-g253317604975, first=
 fail: v5.10.43-130-g87b5f83f722c)

    2021-09-24T20:03:15.591069  /lava-4580400/1/../bin/lava-test-case<8>[  =
 10.831107] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Ddwmmc_rockchip-sdmmc-probe=
d RESULT=3Dfail>
    2021-09-24T20:03:15.591599     =

 =20
