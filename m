Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E10C50634D
	for <lists+stable@lfdr.de>; Tue, 19 Apr 2022 06:35:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234215AbiDSEiE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Apr 2022 00:38:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230042AbiDSEiD (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Apr 2022 00:38:03 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABE9027FFF
        for <stable@vger.kernel.org>; Mon, 18 Apr 2022 21:35:22 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id n8so14072484plh.1
        for <stable@vger.kernel.org>; Mon, 18 Apr 2022 21:35:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=zcsOo7ae4rgOnjSFoQaW/LUtiRXzVNOeKKmq4Ps6MDY=;
        b=N5I+POIIEZBpGwJg6ivjl7jm16QEni7s7sXCFg13kp8w02yAbKxEESqUKV2XJqdNeR
         QZw27Wt9YaPdCo8Alft3W/ElfJBFWDDQZhv3d0wN1DGGNSYS842biCZiFk4CGYec9KXI
         d0nvb1R8My5TmP6vyfWrL2uv2tX570hmed7d5RaWIQDdGSM5g9vCfN1Fjrxj4It2d4Qc
         WP6goTJn0ybKNZVibTYXVqmLbaOvqYUPtKRmaEBBiCAn9DCt9kin32rGdM3Xx6cLiPJM
         x2VsGRddrez62lezmgjhXdkEGVvIhsgf7hmkcTFGK3H1pplfxQ2VaTWKWyi8OheMqLQH
         GooQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=zcsOo7ae4rgOnjSFoQaW/LUtiRXzVNOeKKmq4Ps6MDY=;
        b=2U6SDdKaIgkTYDCi83JV4KMBuhVANq9E3nsuHDSNpynlKvxHr6e7eCPip3HLomMO+D
         2nuCFCQfa2/vd6ljBDD67A/8v+RaD+VLnzllJrWNel4/3Hqs0Gp7l9uCJsETNhcIJQh4
         FFLJF46g9xuT8ugUmSMxJRjKAKwJF00roL+sXjcKyb8dd9Yr9axHDY/78c4mSdrDEyMQ
         FWn14TEdArHuciJp2vXbWJPv+e6TVVIiJY7V90xJsfWhoHVfxUXwVwFJvKZwXbq6unFi
         yrmYarkJqJ8F2moXJC+qx62J7bIesypuoIL1nG+GfFyqojRlcJTdfsLGP3R3xIqssMCt
         LLgA==
X-Gm-Message-State: AOAM531dEiv1yQxpFvYFjWwlkEFuPEoddW6xkw9TpAnOWR+pbJiuZbay
        gTHcEGYB1SCdUuLY/vnLZEAPZybDMJByoTi6
X-Google-Smtp-Source: ABdhPJy/yiiJPz4W8G92c7tvfFFaWCO1u5vWg4W9RqsQ35lkfhu0kqO14jKSvoqaDI0jD7qRwNXZ+w==
X-Received: by 2002:a17:903:244b:b0:158:db5c:8fee with SMTP id l11-20020a170903244b00b00158db5c8feemr13743377pls.1.1650342922104;
        Mon, 18 Apr 2022 21:35:22 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id h18-20020a63c012000000b0039cc3c323f7sm14399247pgg.33.2022.04.18.21.35.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Apr 2022 21:35:21 -0700 (PDT)
Message-ID: <625e3c09.1c69fb81.bc234.3209@mx.google.com>
Date:   Mon, 18 Apr 2022 21:35:21 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.15.y
X-Kernelci-Kernel: v5.15.34-190-g4a9761edfcec9
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-5.15.y baseline: 140 runs,
 1 regressions (v5.15.34-190-g4a9761edfcec9)
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

stable-rc/linux-5.15.y baseline: 140 runs, 1 regressions (v5.15.34-190-g4a9=
761edfcec9)

Regressions Summary
-------------------

platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.15.y/ker=
nel/v5.15.34-190-g4a9761edfcec9/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.15.y
  Describe: v5.15.34-190-g4a9761edfcec9
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      4a9761edfcec9b095619311472fac014067f802d =



Test Regressions
---------------- =



platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/625e0c40ccc666e18bae067c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.3=
4-190-g4a9761edfcec9/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-b=
eagle-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.3=
4-190-g4a9761edfcec9/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-b=
eagle-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220411.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/625e0c40ccc666e18bae0=
67d
        failing since 88 days (last pass: v5.15.14-70-g9cb47c4d3cbf, first =
fail: v5.15.16) =

 =20
