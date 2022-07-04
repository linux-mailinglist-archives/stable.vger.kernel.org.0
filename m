Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A8C256592A
	for <lists+stable@lfdr.de>; Mon,  4 Jul 2022 17:01:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230174AbiGDPBG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jul 2022 11:01:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234328AbiGDPBF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Jul 2022 11:01:05 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6BE96344
        for <stable@vger.kernel.org>; Mon,  4 Jul 2022 08:01:04 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id w185so5471344pfb.4
        for <stable@vger.kernel.org>; Mon, 04 Jul 2022 08:01:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=6I3wAVRVLvsP7dBzn9GK6kOMRlGkoBeqnjxKL9qonqk=;
        b=lKMPC1vOkUGNx5EegJRVx6ww2uWWx7Ge9ABCNowRPfudLAOgDggSv9wDHkoRSLm2FE
         Ai2eWi4NwQ1goW1JifIaze6GTKBveIL29TirFntOgt9US/Uc5H2k5fNNJw2di+MZc2Hl
         bAhmJBG5shoapw3xtJE38XeeGCRZtbj0wc1z5bD0PdYsccuJR/fN1y08k4bLYWqj2WOJ
         wZ+GecI3ydih0sgtJ0MpnMJW2gQY7YCi2S1m0Gx7XMwsg6AGgam8eze4UVTT3xzvMfr2
         zjHXApuZPLpZZ/zAzeCU+puC3iKR9H4jit5lIRTf3NOaHgKDo8jxOMzIDSaI7qtM/sVz
         TGxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=6I3wAVRVLvsP7dBzn9GK6kOMRlGkoBeqnjxKL9qonqk=;
        b=316ThoNPuoR2cian+byHjpvvqNJtkrCGSBSPdyxWDyia1ygWs83bxE/OOF+qcKoSaz
         dCmnOHTI2oQ7oIgXPVwgkKXCMsoEmWElieu+azdLz6hYkdl+/5ZUViJTGK+M+j05VRXM
         45oxoitEa1utbj3Vmb7fTGXhoSsfPR/By7fv/PvsHOSMUkGhQ3Ud2A91YdiMApXIJs+c
         dH/TjkaaRVclpokBFzPpmE8SsQGu9QGrCpkWnD3XqPldSnbDCiKfQVVXrXouOFVAeSO0
         mhZbhnP6FWUmyDsIVj1x9R24T6frkydze6yA7fFRfIJEvY2wuVvH5hDBblVg8ohnwjby
         kvHg==
X-Gm-Message-State: AJIora83M+SnG62UlTeDn41kVoGtITVcE++Tcp4XRlY56SOcV34khIq0
        Pm8uEBG9e4ixWT64D2oJazkX8L8ed5c88atD
X-Google-Smtp-Source: AGRyM1uVpvHZQFxxSawiWtqFBbyNg9unwEbGlwnlbkRrhAES91odRF8HZ//96CEl4nEkk0rzRZTeLw==
X-Received: by 2002:a63:90c7:0:b0:40d:3c0d:33f4 with SMTP id a190-20020a6390c7000000b0040d3c0d33f4mr25461853pge.334.1656946864245;
        Mon, 04 Jul 2022 08:01:04 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id a14-20020aa795ae000000b005259d99ccffsm17515277pfk.8.2022.07.04.08.01.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Jul 2022 08:01:03 -0700 (PDT)
Message-ID: <62c300af.1c69fb81.1378.8fc6@mx.google.com>
Date:   Mon, 04 Jul 2022 08:01:03 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.15.51-43-gad3bd1f3e86e
X-Kernelci-Branch: queue/5.15
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.15 baseline: 160 runs,
 2 regressions (v5.15.51-43-gad3bd1f3e86e)
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

stable-rc/queue/5.15 baseline: 160 runs, 2 regressions (v5.15.51-43-gad3bd1=
f3e86e)

Regressions Summary
-------------------

platform   | arch | lab          | compiler | defconfig           | regress=
ions
-----------+------+--------------+----------+---------------------+--------=
----
beagle-xm  | arm  | lab-baylibre | gcc-10   | omap2plus_defconfig | 1      =
    =

jetson-tk1 | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig  | 1      =
    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.51-43-gad3bd1f3e86e/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.51-43-gad3bd1f3e86e
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      ad3bd1f3e86e426470830f9b8b21cf07e151a79f =



Test Regressions
---------------- =



platform   | arch | lab          | compiler | defconfig           | regress=
ions
-----------+------+--------------+----------+---------------------+--------=
----
beagle-xm  | arm  | lab-baylibre | gcc-10   | omap2plus_defconfig | 1      =
    =


  Details:     https://kernelci.org/test/plan/id/62c2cc01aaa998d0caa39c09

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.51-=
43-gad3bd1f3e86e/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagl=
e-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.51-=
43-gad3bd1f3e86e/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagl=
e-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220624.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62c2cc01aaa998d0caa39=
c0a
        failing since 95 days (last pass: v5.15.31-2-g57d4301e22c2, first f=
ail: v5.15.31-3-g4ae45332eb9c) =

 =



platform   | arch | lab          | compiler | defconfig           | regress=
ions
-----------+------+--------------+----------+---------------------+--------=
----
jetson-tk1 | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig  | 1      =
    =


  Details:     https://kernelci.org/test/plan/id/62c2ccdddb910e3a13a39bd7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.51-=
43-gad3bd1f3e86e/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-jetson=
-tk1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.51-=
43-gad3bd1f3e86e/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-jetson=
-tk1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220624.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62c2ccdddb910e3a13a39=
bd8
        failing since 23 days (last pass: v5.15.45-667-g99a55c4a9ecc0, firs=
t fail: v5.15.45-798-g69fa874c62551) =

 =20
