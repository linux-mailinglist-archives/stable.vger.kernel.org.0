Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B2E767258B
	for <lists+stable@lfdr.de>; Wed, 18 Jan 2023 18:52:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229980AbjARRwg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Jan 2023 12:52:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230033AbjARRwe (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 Jan 2023 12:52:34 -0500
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F049949545
        for <stable@vger.kernel.org>; Wed, 18 Jan 2023 09:52:31 -0800 (PST)
Received: by mail-pl1-x62b.google.com with SMTP id g23so22061971plq.12
        for <stable@vger.kernel.org>; Wed, 18 Jan 2023 09:52:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=u4lN6OffmC+LrbO+X/VFnDEGOMGA7lFDR99uqXaIc9g=;
        b=VJ/o8X3lHfXhd3e9Z07mxPtY3jrWS4hcbKtWs42+6vaHdkVgCf7q4DKE1U99kzSx8X
         QIjYrPNH5Ozu0d+L2vUxvD0Vqfv/8xocxvkXcF46O1c7FRYj0x6KwX8MI7dkepPRzWPC
         bXxOS6xP4RgYl7w4M4ytyYk0tUJf0vGPurpKbjuMto17kCG5CHz6L8GCrfxWWIwZBOCF
         bwFfGynNfW2Q9k0ZTQNK2zj02fhUZkt1BhjESMBdy8LBqFTgPfvtLyU4/m812TA1qvO4
         wffMfYRxmh0YY6IC0uk/YawkLwsTFWN6QVvgRDikuNLRqzPpW7HiYs/ldr/THo+/VGG/
         Gd3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=u4lN6OffmC+LrbO+X/VFnDEGOMGA7lFDR99uqXaIc9g=;
        b=12h2E+ENJoyEX4Qr9jknNuitP5UcoYc4tMtGxALPxWhXQ5nqQ0bYqjbQxgUjUmZPu5
         uPTVtAB4fs5DRXQ9CXNDTiRf7voEeeLPtOHNrcWIs81TSNdSKwBLt1Rv/5127WzD3Ba1
         FEXIOtIxeEEvL13LzRrd6BvpcEe8oBxdF3UkmLYzgeit7/6xYIQybROSOBwgiAlUuNxu
         pFIJuRSmzQCRbcb07UDBrt/69x0gy5lm9Qlf/UoiNeXH0qBlUx0io6uqw8VgXOYXb99k
         CLAoPPTHKGiGrARByXaSUqJQze688zjZQzcKANrAx7fYs97kLeYyE2IDCiAifTZA7QN0
         1Ehg==
X-Gm-Message-State: AFqh2kqMOa/OblzZdP1nRk82tYClUxKdSVwLgCONaGAIM/KCSNnqFTt+
        RR2uLlPWqGn7e5Vm+MYday18G0ZMk6fvIYYryuIR+Q==
X-Google-Smtp-Source: AMrXdXswVSk+j3orpK7roRHjlWUd9wfvBIpSi0yfq1eqIV2usIDD6AhI1IX6bo3ry303Y7HlixDBUw==
X-Received: by 2002:a17:902:a614:b0:192:fe0a:11c8 with SMTP id u20-20020a170902a61400b00192fe0a11c8mr8114949plq.46.1674064351261;
        Wed, 18 Jan 2023 09:52:31 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id q1-20020a170902dac100b0019141c79b1dsm23399902plx.254.2023.01.18.09.52.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Jan 2023 09:52:30 -0800 (PST)
Message-ID: <63c831de.170a0220.6b235.6166@mx.google.com>
Date:   Wed, 18 Jan 2023 09:52:30 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.15
X-Kernelci-Kernel: v5.15.87-100-g6099ba8f8712
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.15 baseline: 167 runs,
 2 regressions (v5.15.87-100-g6099ba8f8712)
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

stable-rc/queue/5.15 baseline: 167 runs, 2 regressions (v5.15.87-100-g6099b=
a8f8712)

Regressions Summary
-------------------

platform              | arch | lab          | compiler | defconfig         =
 | regressions
----------------------+------+--------------+----------+-------------------=
-+------------
at91-sama5d4_xplained | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig=
 | 1          =

cubietruck            | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig=
 | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.87-100-g6099ba8f8712/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.87-100-g6099ba8f8712
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      6099ba8f87126ef0f15b6422837392b999db4ff2 =



Test Regressions
---------------- =



platform              | arch | lab          | compiler | defconfig         =
 | regressions
----------------------+------+--------------+----------+-------------------=
-+------------
at91-sama5d4_xplained | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/63c801e88cbec6c9e6915ed0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.87-=
100-g6099ba8f8712/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-at91-=
sama5d4_xplained.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.87-=
100-g6099ba8f8712/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-at91-=
sama5d4_xplained.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230114.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63c801e88cbec6c9e6915=
ed1
        new failure (last pass: v5.15.87-100-g8dfbf622429a) =

 =



platform              | arch | lab          | compiler | defconfig         =
 | regressions
----------------------+------+--------------+----------+-------------------=
-+------------
cubietruck            | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/63c8305430bee20ed3915ed0

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.87-=
100-g6099ba8f8712/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubie=
truck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.87-=
100-g6099ba8f8712/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubie=
truck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230114.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63c8305430bee20ed3915ed5
        failing since 1 day (last pass: v5.15.82-123-gd03dbdba21ef, first f=
ail: v5.15.87-100-ge215d5ead661)

    2023-01-18T17:45:15.545072  <8>[    9.858341] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3158197_1.5.2.4.1>
    2023-01-18T17:45:15.651691  / # #
    2023-01-18T17:45:15.753309  export SHELL=3D/bin/sh
    2023-01-18T17:45:15.753756  #
    2023-01-18T17:45:15.854978  / # export SHELL=3D/bin/sh. /lava-3158197/e=
nvironment
    2023-01-18T17:45:15.855418  =

    2023-01-18T17:45:15.956705  / # . /lava-3158197/environment/lava-315819=
7/bin/lava-test-runner /lava-3158197/1
    2023-01-18T17:45:15.957408  =

    2023-01-18T17:45:15.962136  / # /lava-3158197/bin/lava-test-runner /lav=
a-3158197/1
    2023-01-18T17:45:16.050124  + export 'TESTRUN_ID=3D1_bootrr' =

    ... (11 line(s) more)  =

 =20
