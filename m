Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A9D26C3A48
	for <lists+stable@lfdr.de>; Tue, 21 Mar 2023 20:20:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229891AbjCUTUb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Mar 2023 15:20:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229833AbjCUTUa (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Mar 2023 15:20:30 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F23C69EF5
        for <stable@vger.kernel.org>; Tue, 21 Mar 2023 12:20:08 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id le6so17095958plb.12
        for <stable@vger.kernel.org>; Tue, 21 Mar 2023 12:20:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112; t=1679426408;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=8UX57Or8Ef4rlvKY6szTnrrZRPrRlyQR6HZrgIRHA0U=;
        b=oBO8GIIXV4fxpfISgYRT5qUez5OncGbGiv0SWa9O2eEOA41OgBLhTQxIF9NJGc92PO
         CpCSK1Lh8jCHcVWqnzOAAL6KrizRsbay8t3obI/vP5wk6aP3NWUBWJYLz7u+9Uz8qi3v
         A+CUa9A1ZCkYHWHcUo+znQuQZSLkaePpoSZKHCc9FfjOUkFwTxOyo6WzogP6J99LsaJA
         28RnxLnjBVuWKNSyNJ1gw4r0rSSvhhoZXfkR85fHOPRCMvYGHBYiWKSYuhEvFbHpefSF
         a+lok8lnDZVgHXViRLttJEwMKkkyYTDr+9uts1vuwjcrzkVG/d/SXMMub2a9n8kHrS4K
         nC2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679426408;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8UX57Or8Ef4rlvKY6szTnrrZRPrRlyQR6HZrgIRHA0U=;
        b=iJtpZ4acdt4zWYS+XlZUTAK1l8bd/swba9g7Lddj3s2MWZByUGxiM+UH1Ve54rq3i9
         D0K067/tIJWdqBFZNi1Y0C2EDle3FgW+Nw5Dop6T34XbkcnjdBI5GVsbzxz3+eKDZgGx
         +mlWCRp7j9fBZc8tAmwEO5levp/Mw8IQ0gF1k82Plxa8+7FmnxYpx0y+WAFtjuc+N6mT
         lD74Ve68Fi3v6Xx6TkL9xoVesfk8sI4itU2KX8+eI5xtcqzA9AcyFDPbHKlXFBW2DSYf
         nL3fyeR8sxQaab9ruXVrleaSgGAIBZx6iGAvpmP4goiRA2ggoMRUdHbKrcp/CCqB7zX9
         diFg==
X-Gm-Message-State: AO0yUKWPHkJVqFjyd2dDUVuyAeGFii60HymQkTMdSn24jU6rHJ+oBwNg
        V12nbS4Y0KisKOc8RzqHPoAkbyt5w77z9UwetXfN9A==
X-Google-Smtp-Source: AK7set8PoCCXNspK2P2SZ+naYjSADcyGJdJWPhyV+JGJwYcBAf6+aSVpoofOMz4Wv78tVRZfUY47wg==
X-Received: by 2002:a05:6a20:389e:b0:c7:717f:4863 with SMTP id n30-20020a056a20389e00b000c7717f4863mr2982052pzf.21.1679426408095;
        Tue, 21 Mar 2023 12:20:08 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id d10-20020a634f0a000000b0050f56964426sm6556330pgb.54.2023.03.21.12.20.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Mar 2023 12:20:07 -0700 (PDT)
Message-ID: <641a0367.630a0220.be3cb.a78e@mx.google.com>
Date:   Tue, 21 Mar 2023 12:20:07 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/6.1
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v6.1.20-197-g6abc98d706b8
Subject: stable-rc/queue/6.1 baseline: 175 runs,
 1 regressions (v6.1.20-197-g6abc98d706b8)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/6.1 baseline: 175 runs, 1 regressions (v6.1.20-197-g6abc98d=
706b8)

Regressions Summary
-------------------

platform           | arch | lab         | compiler | defconfig         | re=
gressions
-------------------+------+-------------+----------+-------------------+---=
---------
bcm2835-rpi-b-rev2 | arm  | lab-broonie | gcc-10   | bcm2835_defconfig | 1 =
         =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F6.1/kern=
el/v6.1.20-197-g6abc98d706b8/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/6.1
  Describe: v6.1.20-197-g6abc98d706b8
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      6abc98d706b82ef675d0e7fed96c4cb86cdd0d5e =



Test Regressions
---------------- =



platform           | arch | lab         | compiler | defconfig         | re=
gressions
-------------------+------+-------------+----------+-------------------+---=
---------
bcm2835-rpi-b-rev2 | arm  | lab-broonie | gcc-10   | bcm2835_defconfig | 1 =
         =


  Details:     https://kernelci.org/test/plan/id/6419d04e390e0065c99c9510

  Results:     50 PASS, 2 FAIL, 1 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.20-19=
7-g6abc98d706b8/arm/bcm2835_defconfig/gcc-10/lab-broonie/baseline-bcm2835-r=
pi-b-rev2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.20-19=
7-g6abc98d706b8/arm/bcm2835_defconfig/gcc-10/lab-broonie/baseline-bcm2835-r=
pi-b-rev2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6419d04e390e0065c99c9542
        failing since 1 day (last pass: v6.1.20-142-g50c2c02e4ebf, first fa=
il: v6.1.20-190-gfb3ddaa27aa7)

    2023-03-21T15:41:43.005054  + set +x
    2023-03-21T15:41:43.008901  <8>[   16.838554] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 200679_1.5.2.4.1>
    2023-03-21T15:41:43.124829  / # #
    2023-03-21T15:41:43.227584  export SHELL=3D/bin/sh
    2023-03-21T15:41:43.228193  #
    2023-03-21T15:41:43.330266  / # export SHELL=3D/bin/sh. /lava-200679/en=
vironment
    2023-03-21T15:41:43.330866  =

    2023-03-21T15:41:43.432758  / # . /lava-200679/environment/lava-200679/=
bin/lava-test-runner /lava-200679/1
    2023-03-21T15:41:43.433835  =

    2023-03-21T15:41:43.440435  / # /lava-200679/bin/lava-test-runner /lava=
-200679/1 =

    ... (14 line(s) more)  =

 =20
