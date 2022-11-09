Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31B44622BE9
	for <lists+stable@lfdr.de>; Wed,  9 Nov 2022 13:51:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229651AbiKIMvc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Nov 2022 07:51:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbiKIMvb (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Nov 2022 07:51:31 -0500
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0663826499
        for <stable@vger.kernel.org>; Wed,  9 Nov 2022 04:51:30 -0800 (PST)
Received: by mail-pf1-x429.google.com with SMTP id q9so16596495pfg.5
        for <stable@vger.kernel.org>; Wed, 09 Nov 2022 04:51:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=1oXl1uIRVr0lK880smcSiDUE510BqfcCV8VvzBWIr+c=;
        b=VOfmkB9uDcVQBbuzooOjb98w648T/X3/wkp3oOo4vJAzEzd+3bSUaC+zAmAaXb0Ok1
         ZAS8ZoV8aBp2YM4PxQXo45iYRL0c6ZrNGl5ZuIgjyjsi6NxINNScgIkQCOzVX6/09AoP
         hZlQcGoZMN4Ga12Bh+z6pRsO6Up/7jZ5GzDy+o8/3WtKlsVKDkxKdMWmgFUNmgldK5yd
         pNL1v3TCb4/9MvTPOce8xOCeyBm6y4SrcYPgeLeXZdNlAlA5qBUPuPcivu2L283tJ+dH
         ZOSQg+rcJuOQHOYzmdl6yeeZvLnbmTXhFHdrCykHsQ6jltO0MQla6V6Adc1PbtuyI9XG
         4hLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1oXl1uIRVr0lK880smcSiDUE510BqfcCV8VvzBWIr+c=;
        b=yOoOGnKiF2XAc8PS5Klq3ezDCZayyf3xHYs7bzFOzz7leBHd6Hc4vY5ymBu9fbhIbH
         r3QMgrZDBGJ/ODk+cWhaJOhlFA84L1nPFLl6u5+9xfE1lcXNKy13+P51RQzPpTBRXHVH
         qx5yYmMoPEtRIDir6mRvBivxMQmolndnDxnet32lHFwM1eyB0UKXvF620YIPmGHaJmfx
         zuMdFUfGWs4L5lYnh0OB2rJzoQ078z8F6KHR4rircvLu/J3/EmPnzAulHXpF+HI2A/0y
         VyFUVL4hmha8KYfMIo+yTyqwgW0tshhrbwuPFeKxTP3s0HHXTcHQuCKg2d1/dKyYE6t1
         1mNw==
X-Gm-Message-State: ACrzQf27NUx1Tt8y7HZYUGEpM6CPrW3Eq4TgzXMqN8FcwpMcZi4YN0ai
        mruaKWx9t9GUm1rsYQIg9v65OxugMaSFog==
X-Google-Smtp-Source: AMsMyM7PkzQetvBGbzYyg6N7nFOtdKBw8y4t/CHovDpov6Lddp8icvAEKyjGaqzGGG8LXq/yU5F+Yg==
X-Received: by 2002:a63:4f09:0:b0:440:4706:2299 with SMTP id d9-20020a634f09000000b0044047062299mr52802461pgb.115.1667998289379;
        Wed, 09 Nov 2022 04:51:29 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id d18-20020a170902aa9200b00186a2274382sm8962416plr.76.2022.11.09.04.51.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Nov 2022 04:51:29 -0800 (PST)
Message-ID: <636ba251.170a0220.6a80e.effe@mx.google.com>
Date:   Wed, 09 Nov 2022 04:51:29 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.10.153-118-g69a0227f6bd6
X-Kernelci-Branch: linux-5.10.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-5.10.y baseline: 157 runs,
 1 regressions (v5.10.153-118-g69a0227f6bd6)
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

stable-rc/linux-5.10.y baseline: 157 runs, 1 regressions (v5.10.153-118-g69=
a0227f6bd6)

Regressions Summary
-------------------

platform          | arch | lab     | compiler | defconfig          | regres=
sions
------------------+------+---------+----------+--------------------+-------=
-----
r8a7743-iwg20d-q7 | arm  | lab-cip | gcc-10   | shmobile_defconfig | 1     =
     =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.10.y/ker=
nel/v5.10.153-118-g69a0227f6bd6/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.10.y
  Describe: v5.10.153-118-g69a0227f6bd6
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      69a0227f6bd671ba8efa071c58d9f127932e25f2 =



Test Regressions
---------------- =



platform          | arch | lab     | compiler | defconfig          | regres=
sions
------------------+------+---------+----------+--------------------+-------=
-----
r8a7743-iwg20d-q7 | arm  | lab-cip | gcc-10   | shmobile_defconfig | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/636b69ec75df7ddb61e7db54

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: shmobile_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
53-118-g69a0227f6bd6/arm/shmobile_defconfig/gcc-10/lab-cip/baseline-r8a7743=
-iwg20d-q7.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
53-118-g69a0227f6bd6/arm/shmobile_defconfig/gcc-10/lab-cip/baseline-r8a7743=
-iwg20d-q7.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221024.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/636b69ec75df7ddb61e7d=
b55
        failing since 9 days (last pass: v5.10.150-80-g04a0124fa82b5, first=
 fail: v5.10.152) =

 =20
