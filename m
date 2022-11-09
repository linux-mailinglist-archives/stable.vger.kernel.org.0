Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82E2C6220AD
	for <lists+stable@lfdr.de>; Wed,  9 Nov 2022 01:23:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229499AbiKIAXp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 19:23:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbiKIAXo (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 19:23:44 -0500
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B659F00E
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 16:23:44 -0800 (PST)
Received: by mail-pf1-x434.google.com with SMTP id k15so15245199pfg.2
        for <stable@vger.kernel.org>; Tue, 08 Nov 2022 16:23:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=48b9GF+7qC3DOBeRM1rDwYTEzB0aC1hdMRFgEPYE16k=;
        b=L2DG+MvFaX/SGyCq3p8IDhL+2NRLQ/81si86yf94eOOb2IbDrQtx0V2sLmjDISVK5/
         UP6wcoPyzaFLSIOBEm/4e9n6p2vRzDwQK+5k2TSjzVcldz0RJ993jNbTpQ2P8tf756M1
         wCVzBjz3nwtkvFC6UdAWRsX7V7WDKlz7T8Z1poh21vW41+saVvb7QGOeQfrWY3zZiUeo
         gr30BjNM+csCZyIMxq0YAiU34VWrIkcCWSPbAEMOVllI71cXwfKm1QEzH1rKUA2IU5qk
         LwaZiE4Iyzj27RnTRTXpnjvH7HnZrTKVeVGgVaEcRFsHNKdr/FmyeesADLY2QwlLHwug
         w5tQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=48b9GF+7qC3DOBeRM1rDwYTEzB0aC1hdMRFgEPYE16k=;
        b=atS5TKsxaZUwdt/DqzwQYZcC87oiexv7LXvDU6Y0WDfsZGUgpcOFMqo0M2ZavFpTdT
         1hXycxQdegmV28NQ/AOq2IOgFevbL0Jar4WxobJG1D5k/PZQmI9SDkpUHXiew9OCR29I
         kBeO2uHru4EzIUG86JyZEhi2Z+ARSQMV7TZjKputCdIh2cVl9+oJXeAM5old8xA4P4bS
         yMt8mgeRPrU7oRRzI7DPCICq9AP8C59VEpz4aBNrVr+JLf8TU71XT1PA8cuRVenH/RMk
         FkDzJvVojQu7RrH+Rw476mEv5kzgPOdqq3B/c6KrHn3s2pNUbyI2RMvOn1bIrjcYA/fP
         F1MA==
X-Gm-Message-State: ACrzQf31C+uz1PXwr396thS/E+wSa8pcvizxwZE4+T4MfWMAOB51f/Cy
        dapNdWwKHUPCex0FfvoP9yGI5hRdSA6mvhY2
X-Google-Smtp-Source: AA0mqf6096J6TJECrhO/Go2aHdH+ofQMICxYsviJX+wxPPIsLiSwa0Sf69XSk6XA90DCqcQopUKFmw==
X-Received: by 2002:a63:e58:0:b0:470:537b:d114 with SMTP id 24-20020a630e58000000b00470537bd114mr16556226pgo.169.1667953423337;
        Tue, 08 Nov 2022 16:23:43 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id g17-20020a635651000000b0046f7e1ca434sm6381340pgm.0.2022.11.08.16.23.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Nov 2022 16:23:42 -0800 (PST)
Message-ID: <636af30e.630a0220.67f00.a7b5@mx.google.com>
Date:   Tue, 08 Nov 2022 16:23:42 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.10.153-118-gdc575ec55159
X-Kernelci-Branch: queue/5.10
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.10 baseline: 89 runs,
 1 regressions (v5.10.153-118-gdc575ec55159)
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

stable-rc/queue/5.10 baseline: 89 runs, 1 regressions (v5.10.153-118-gdc575=
ec55159)

Regressions Summary
-------------------

platform              | arch | lab          | compiler | defconfig         =
 | regressions
----------------------+------+--------------+----------+-------------------=
-+------------
at91-sama5d4_xplained | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig=
 | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.153-118-gdc575ec55159/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.153-118-gdc575ec55159
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      dc575ec5515917c728515eb8c082513383e26edf =



Test Regressions
---------------- =



platform              | arch | lab          | compiler | defconfig         =
 | regressions
----------------------+------+--------------+----------+-------------------=
-+------------
at91-sama5d4_xplained | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/636ad0b0226d4c8ef0e7db73

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.153=
-118-gdc575ec55159/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-at91=
-sama5d4_xplained.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.153=
-118-gdc575ec55159/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-at91=
-sama5d4_xplained.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221024.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/636ad0b0226d4c8ef0e7d=
b74
        new failure (last pass: v5.10.149-461-g756677e6f67f) =

 =20
