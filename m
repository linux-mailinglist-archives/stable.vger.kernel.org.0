Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA197481E74
	for <lists+stable@lfdr.de>; Thu, 30 Dec 2021 18:13:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241432AbhL3RN6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Dec 2021 12:13:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240162AbhL3RN6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Dec 2021 12:13:58 -0500
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09B5FC061574
        for <stable@vger.kernel.org>; Thu, 30 Dec 2021 09:13:58 -0800 (PST)
Received: by mail-pl1-x631.google.com with SMTP id c3so5423863pls.5
        for <stable@vger.kernel.org>; Thu, 30 Dec 2021 09:13:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=+s9yrbMnacqJjfB+NEMV3jP2WrjA5Filj4mqoySRzoo=;
        b=RJ76F/LZVGYFzYjSmolNH2Lfx60mDjuGYyftBSSPCwTlo7x7ZB+RUFFuEx71W9PPCd
         j5QpaI4a27eR3euI4V3Vpj0VjRuuGoazbnrw2uXHtH93rI17tKxptt2zaaXWm7YJXMSC
         YCNh9bGPiVnKUL19mMycH4m68WRSqKKFEuSSKWfLD7M6We1Imc0xh7nR/EftfodcNjGB
         roXGtrhXLMCPCVozdoFUt/ynT4uDpVxdzz6CqgX5W5nfBxyC2JuVCA8ruGHy1bZ2OKWX
         4Rg0JkeVrA29nd9cL+H/WaRGQgr0uq4BYVSSrG+yPfSPTc2KNGuXPcbUUy+0uYdY2zrE
         4gPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=+s9yrbMnacqJjfB+NEMV3jP2WrjA5Filj4mqoySRzoo=;
        b=FDRKgw1g45Bte8cbJZZlbfSeLo6GCcnUChuOrIHIp51XsAHNP6/9ufl9f4mj2bbDtB
         5TKLS3EhAU+REvejzx2UZlKX0mmXANZSd3yA2/HsKkyUMKSVnEeQI6e98a4RxSBk5vPP
         ox3/t/po9C+y02SE1JhTRoHaEPguDPeQAIcWAl7pdDn3JVQWM620I/RaJppq5eehQ+mL
         0qFabqSV9heiLKPwM6/s/uAg2bbgzaojjlth2GMiIzoEvmktOinj+1OAiWN31+xWU0xm
         8k9AuBcw2IFvxTEhW+5nNfnzW2TGBPWNxpPvCKHK9iwnE1uBgzuHTCuz501LAIw9OqRq
         5OIQ==
X-Gm-Message-State: AOAM531js4HgcJeykxfX2/cCBkNt2P/C7aeNkul/x0x3qrCT1Mb4wBMt
        k7wF56jWuol/8PU/Vg4rIxYk/aHKp+Zz/6X5
X-Google-Smtp-Source: ABdhPJyFmO0F0NRFtZr4PLup28y9M1jkwCU364cQk8qDhyDrrTCUvfOxC/6l2pGJ5xeVmyBZFpaYTw==
X-Received: by 2002:a17:903:244f:b0:149:873:e17c with SMTP id l15-20020a170903244f00b001490873e17cmr31562122pls.133.1640884437283;
        Thu, 30 Dec 2021 09:13:57 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id p1sm18568047pgj.46.2021.12.30.09.13.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Dec 2021 09:13:57 -0800 (PST)
Message-ID: <61cde8d5.1c69fb81.baf8.422b@mx.google.com>
Date:   Thu, 30 Dec 2021 09:13:57 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.9.295-4-g4275a80ba6b5
X-Kernelci-Branch: queue/4.9
Subject: stable-rc/queue/4.9 baseline: 91 runs,
 1 regressions (v4.9.295-4-g4275a80ba6b5)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 91 runs, 1 regressions (v4.9.295-4-g4275a80ba=
6b5)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.295-4-g4275a80ba6b5/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.295-4-g4275a80ba6b5
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      4275a80ba6b5c7658dcc6fbd99deb2ba0602aa4a =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61cdb4e2ac871f66f1ef673d

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.295-4=
-g4275a80ba6b5/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.295-4=
-g4275a80ba6b5/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61cdb4e2ac871f6=
6f1ef6740
        failing since 2 days (last pass: v4.9.294-8-gdf4b9763cd1e, first fa=
il: v4.9.294-18-gaa81ab4e03f9)
        2 lines

    2021-12-30T13:32:01.510714  [   21.068145] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-12-30T13:32:01.560981  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/121
    2021-12-30T13:32:01.570177  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
230 [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
