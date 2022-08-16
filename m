Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 799975965D4
	for <lists+stable@lfdr.de>; Wed, 17 Aug 2022 01:02:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230378AbiHPXBs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 19:01:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237827AbiHPXB3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 19:01:29 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7953287680
        for <stable@vger.kernel.org>; Tue, 16 Aug 2022 16:01:28 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id t3so2649076ply.2
        for <stable@vger.kernel.org>; Tue, 16 Aug 2022 16:01:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc;
        bh=yJdFoEOq/2Gj+DHBPPnKzlFSo7D/mATOh/85Tk5Yd2Q=;
        b=auGKF/nxwFpg9Ag23ufG2Z0iby1R3AqDhVkH48wrKnXwAlHrNukgd1cCxRxNrKTJ3k
         /V8k9IWI0hq71Gw9+t/29mZjEkIAm0z4aU2TmMoJqvlmVeaq/wWNSP19CqChP75zjhg0
         yyCpmzf9gB2mEpZaSB90Il1Ms+pHnPEbP1fR8z8G1p3JMTLuUnr1aKi0UV8ICQAmP1tf
         jMt8a4UEhZTdQZlKl7gmvEoPrDh3ym0n4VBrYg9sm7lRegtyr/3LF6oPVcdCmRvLerG6
         RFSyZSA0Xi6RiT0VW2t7ZMsVHzdzd/kCd1pQlAm61VF4vS9ABI7Ze7eWEpsGZN87hLLi
         CXPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc;
        bh=yJdFoEOq/2Gj+DHBPPnKzlFSo7D/mATOh/85Tk5Yd2Q=;
        b=g7Da/yrX0ShOVOqeLTcoNPi9OKJoGTr6bA4e+IH/y5OD3GlHjtJ3q6YislePVNvsdT
         XF83R68PPa76m3Y0Q9ACdo0S14E4BxCEjEz1KMtfa39GMzRbwL9k8skcjmguFCddhKFO
         J0rxijQSYy3ahcpsvNqlRaVq0yzLnai4mI6U3EuoGRvyzmRJhFWgEsE2urnpJ+tdxEdK
         rA0TulQTUuWC0noAg9c0heFBwEcygAeVqwnzJfrjpqgtWEzIXSN4M04j1ZFeXR8ChOEt
         leyVXdoc1kl9qpDTFBQKkndoMzrd/H60x6/jrLcz4beYRoW1LK2zbDMsBNRtHbhRwS1G
         bPlQ==
X-Gm-Message-State: ACgBeo1hmPfCbLQBd2SJJ6M+orqEinHuDcjNAPCoqkMaXduM+aRXwrSw
        32UKgZNQJ4CRuqLzxAFJAMRo+EFQYFrGUkUp
X-Google-Smtp-Source: AA6agR6jUp7qgMB7jraAmdaY5yueKpz2m4eoG6pJRex5YRQopT1Yo7HtuYBTbWPWawHPCwAS4+GnyQ==
X-Received: by 2002:a17:90b:4d12:b0:1f7:a6d1:24c1 with SMTP id mw18-20020a17090b4d1200b001f7a6d124c1mr819491pjb.15.1660690887804;
        Tue, 16 Aug 2022 16:01:27 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id t7-20020a1709027fc700b0016d737bff00sm9590121plb.220.2022.08.16.16.01.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Aug 2022 16:01:27 -0700 (PDT)
Message-ID: <62fc21c7.170a0220.3ccd6.0cee@mx.google.com>
Date:   Tue, 16 Aug 2022 16:01:27 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.15
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.15.60-778-g48384f95eb4b6
Subject: stable-rc/queue/5.15 baseline: 152 runs,
 3 regressions (v5.15.60-778-g48384f95eb4b6)
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

stable-rc/queue/5.15 baseline: 152 runs, 3 regressions (v5.15.60-778-g48384=
f95eb4b6)

Regressions Summary
-------------------

platform           | arch | lab          | compiler | defconfig           |=
 regressions
-------------------+------+--------------+----------+---------------------+=
------------
bcm2835-rpi-b-rev2 | arm  | lab-broonie  | gcc-10   | bcm2835_defconfig   |=
 1          =

beagle-xm          | arm  | lab-baylibre | gcc-10   | omap2plus_defconfig |=
 1          =

panda              | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig  |=
 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.60-778-g48384f95eb4b6/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.60-778-g48384f95eb4b6
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      48384f95eb4b6b57724ac46de5126a86231c8d4c =



Test Regressions
---------------- =



platform           | arch | lab          | compiler | defconfig           |=
 regressions
-------------------+------+--------------+----------+---------------------+=
------------
bcm2835-rpi-b-rev2 | arm  | lab-broonie  | gcc-10   | bcm2835_defconfig   |=
 1          =


  Details:     https://kernelci.org/test/plan/id/62fbedd8b71fa8c61f355650

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.60-=
778-g48384f95eb4b6/arm/bcm2835_defconfig/gcc-10/lab-broonie/baseline-bcm283=
5-rpi-b-rev2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.60-=
778-g48384f95eb4b6/arm/bcm2835_defconfig/gcc-10/lab-broonie/baseline-bcm283=
5-rpi-b-rev2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fbedd8b71fa8c61f355=
651
        failing since 0 day (last pass: v5.15.59-9-g01206bfdee44a, first fa=
il: v5.15.60-777-g484e5dee10f8f) =

 =



platform           | arch | lab          | compiler | defconfig           |=
 regressions
-------------------+------+--------------+----------+---------------------+=
------------
beagle-xm          | arm  | lab-baylibre | gcc-10   | omap2plus_defconfig |=
 1          =


  Details:     https://kernelci.org/test/plan/id/62fbf038cd6a2d8c86355698

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.60-=
778-g48384f95eb4b6/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-bea=
gle-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.60-=
778-g48384f95eb4b6/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-bea=
gle-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fbf038cd6a2d8c86355=
699
        failing since 139 days (last pass: v5.15.31-2-g57d4301e22c2, first =
fail: v5.15.31-3-g4ae45332eb9c) =

 =



platform           | arch | lab          | compiler | defconfig           |=
 regressions
-------------------+------+--------------+----------+---------------------+=
------------
panda              | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig  |=
 1          =


  Details:     https://kernelci.org/test/plan/id/62fbf1bdb2eca672c2355655

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.60-=
778-g48384f95eb4b6/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.60-=
778-g48384f95eb4b6/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fbf1bdb2eca672c2355=
656
        failing since 0 day (last pass: v5.15.60-48-g789367af88749, first f=
ail: v5.15.60-779-ge1dae9850fdff) =

 =20
