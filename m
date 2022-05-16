Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53D25528AFD
	for <lists+stable@lfdr.de>; Mon, 16 May 2022 18:49:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343860AbiEPQtQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 May 2022 12:49:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343894AbiEPQtA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 May 2022 12:49:00 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86EE03CA7C
        for <stable@vger.kernel.org>; Mon, 16 May 2022 09:48:52 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id qe3-20020a17090b4f8300b001dc24e4da73so66091pjb.1
        for <stable@vger.kernel.org>; Mon, 16 May 2022 09:48:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ym+5AZRo/l4/++lVTp9LRH9RT07E/9rKkJjcaCQ9eqM=;
        b=eBYbKg206fJv/O6BN7CU/XW/zTFhPYWnVOs3a1TrYlypQsgoj5yK5b2QUFBMpp6z78
         YvSEW/Ga30dFhpF30Lj2WqLhs/wVvr8uwf7gdwjpmM6pyARYrf/weGSFfP1v9nCwebXa
         ZtFWH1m29Yt3CfgdKke0RRj1Hru3wybNluXlSV5nnFmZNZsxnAFBrIc4FSqhLg3nYwg/
         Iq4oBVS2RtM/XmysFU4snk95C6waReUsW3QFTUlIdL2BrfU8Jp6ynpFDTyKIRZnAIx05
         9w4smEJvCX9SHY3ICoMLuOKtFKYmWrom2Nfc5GXUm/PW2oICi4S8361cLEJXF0sadfve
         7Xew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ym+5AZRo/l4/++lVTp9LRH9RT07E/9rKkJjcaCQ9eqM=;
        b=WS/gssTjzyLUm9tJiOGDsM6tms0V3hwFKrO62bzhv6C+CPV3TTY1fPu3dR8iLMoJgp
         G93XYIX4C4j7M5aWMb4D5ZNaqawa9rwjPSHsE2C/I7Alw4k5N6U3AMRklAID74lQrSzY
         C7bauB8hNp+XsBRjPtrjcKd+AHeUzOFn6BkHu1bdB1TPOeskjugYAwHoYifWLNcVcEnd
         RfJXT0dHlvGGeMvFv3wX/ar4GfbKaZ/TmL2T9t/ku/AL10ZJpYeutCf1SMJ7VY5f8Vjk
         rpMBpmr6PPqDuuThZEuLYkKXHkKN6U/J+JlVNz54nc2FCLBWKo322iE8pIpX6ELtnwaO
         o5Xg==
X-Gm-Message-State: AOAM532JX9eTKFcrOhhnkreYYzmrdx7HJuBdcn2gSwQdbdZCJbtgS25c
        J3GzJ+A76oX3lwDC7deYS/Zpec4i7Ws3rJwkg8E=
X-Google-Smtp-Source: ABdhPJxlyu6H92OCVaZUjou2Z09Txw9rUTVr1vNl5crKLTnB5wKjs1lCq9vULhKSgvaY1u4AXMh6cw==
X-Received: by 2002:a17:903:22ce:b0:15e:bd57:5bec with SMTP id y14-20020a17090322ce00b0015ebd575becmr18222017plg.114.1652719731891;
        Mon, 16 May 2022 09:48:51 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id q8-20020a170902eb8800b0015e8d4eb1f1sm7211506plg.59.2022.05.16.09.48.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 May 2022 09:48:51 -0700 (PDT)
Message-ID: <62828073.1c69fb81.73d41.1b83@mx.google.com>
Date:   Mon, 16 May 2022 09:48:51 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.15
X-Kernelci-Kernel: v5.15.40-98-g6e388a6f5046
Subject: stable-rc/queue/5.15 baseline: 105 runs,
 2 regressions (v5.15.40-98-g6e388a6f5046)
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

stable-rc/queue/5.15 baseline: 105 runs, 2 regressions (v5.15.40-98-g6e388a=
6f5046)

Regressions Summary
-------------------

platform      | arch | lab          | compiler | defconfig           | regr=
essions
--------------+------+--------------+----------+---------------------+-----=
-------
at91sam9g20ek | arm  | lab-broonie  | gcc-10   | multi_v5_defconfig  | 1   =
       =

beagle-xm     | arm  | lab-baylibre | gcc-10   | omap2plus_defconfig | 1   =
       =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.40-98-g6e388a6f5046/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.40-98-g6e388a6f5046
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      6e388a6f50460893522e8e0abe78ca6cf6b51aa5 =



Test Regressions
---------------- =



platform      | arch | lab          | compiler | defconfig           | regr=
essions
--------------+------+--------------+----------+---------------------+-----=
-------
at91sam9g20ek | arm  | lab-broonie  | gcc-10   | multi_v5_defconfig  | 1   =
       =


  Details:     https://kernelci.org/test/plan/id/62825206d68356b4188f571c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v5_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.40-=
98-g6e388a6f5046/arm/multi_v5_defconfig/gcc-10/lab-broonie/baseline-at91sam=
9g20ek.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.40-=
98-g6e388a6f5046/arm/multi_v5_defconfig/gcc-10/lab-broonie/baseline-at91sam=
9g20ek.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220513.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62825206d68356b4188f5=
71d
        new failure (last pass: v5.15.39-83-ge8ec14207c651) =

 =



platform      | arch | lab          | compiler | defconfig           | regr=
essions
--------------+------+--------------+----------+---------------------+-----=
-------
beagle-xm     | arm  | lab-baylibre | gcc-10   | omap2plus_defconfig | 1   =
       =


  Details:     https://kernelci.org/test/plan/id/62824c4ea0e9f159fa8f5747

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.40-=
98-g6e388a6f5046/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagl=
e-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.40-=
98-g6e388a6f5046/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagl=
e-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220513.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62824c4ea0e9f159fa8f5=
748
        failing since 46 days (last pass: v5.15.31-2-g57d4301e22c2, first f=
ail: v5.15.31-3-g4ae45332eb9c) =

 =20
