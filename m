Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE0F650DFD1
	for <lists+stable@lfdr.de>; Mon, 25 Apr 2022 14:21:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233065AbiDYMYP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Apr 2022 08:24:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229631AbiDYMYN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 Apr 2022 08:24:13 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 246762AC44
        for <stable@vger.kernel.org>; Mon, 25 Apr 2022 05:21:09 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id 15so4911875pgf.4
        for <stable@vger.kernel.org>; Mon, 25 Apr 2022 05:21:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=RcdhWn2dIQBOK1qkushcT8DLkQxMCNDrhpJ0wG8EnoY=;
        b=EPgGJj6vmCcDW/bCKuTU/He5Fa8dVGZ9b30gkcdonyV4B3JwrZ/5LXwvhpHFw46Y+2
         PYj0t1bXQkfwLRb3OOdMg8m1m0aQ9tmfsRHKmEZ/4uRfZc/VMexumM16WSMcJh2Mzw6G
         r6okwJeC3oQbQmHkPR7Rc3grp0yOzhGN5K9meAs1o3Osq4JL10oQccPJ8PjdvJmDz4gI
         kFPySmDj6tlbI8DFbBs9STEKj7iqASPu7CcFf3qu4qkJKB1+A33YM78ajt61bGFCWsOX
         JrS7r4yeWLeOnO2uPlair/khcbMRbLvGoRxRa6daudkOjd7IGDZ7AXY1ZEfHEGga1SdD
         84cQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=RcdhWn2dIQBOK1qkushcT8DLkQxMCNDrhpJ0wG8EnoY=;
        b=GRw5owJijqjyq9nNIJBtm2+GEnmvSsz3+J4O+RKsmInVA1fSO4jQjYcILDn/agVMoh
         qoD1MR5kCcGmocn6EHB+qGbg0p0mrqv8PnChHi4e/qXLZT4XCqV7s3dFuYcpXsAdaieY
         OvNQVYUCXpBj+nErCkmBtw5pp1rimN1NYyf+pspNAvwSFry3yHfMQd6fKM8Tq7mS1TmL
         Qy1NIspQy70b+6O04g6nT0cqgZ2fJZtWgYXrETY+DHYzHAiyp5obzxkOVZD1vHsdXZ2K
         27mV4XlgvDCtVpQOfUnx8Em5Iyg7DWYOOZZkK4HlOsnZLbbgXGaBzNr5wEdtYVcGG+FY
         Z8Nw==
X-Gm-Message-State: AOAM532Ml9V5pnU99pv8HAN8sc89sgk/AyQykpEqSgo5X4U5JIR+L5cR
        ruzJtQKMeWsca3nOew6OlecwoVS0pT38q/7kwcY=
X-Google-Smtp-Source: ABdhPJyrBHDYTUEwecz13G197WC8IHl1YgMG+IEMVeK4wOxdeW5D4NM/3MS3kI6aa1pkTE/r2ZVPhw==
X-Received: by 2002:a63:e70f:0:b0:380:d919:beb with SMTP id b15-20020a63e70f000000b00380d9190bebmr14957751pgi.58.1650889268526;
        Mon, 25 Apr 2022 05:21:08 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id r13-20020a635d0d000000b003aa482388dbsm9770455pgb.9.2022.04.25.05.21.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Apr 2022 05:21:08 -0700 (PDT)
Message-ID: <62669234.1c69fb81.21111.74b7@mx.google.com>
Date:   Mon, 25 Apr 2022 05:21:08 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.276-7-g98c239d62b95
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.14
Subject: stable-rc/queue/4.14 baseline: 50 runs,
 1 regressions (v4.14.276-7-g98c239d62b95)
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

stable-rc/queue/4.14 baseline: 50 runs, 1 regressions (v4.14.276-7-g98c239d=
62b95)

Regressions Summary
-------------------

platform                     | arch  | lab         | compiler | defconfig |=
 regressions
-----------------------------+-------+-------------+----------+-----------+=
------------
meson-gxl-s905x-libretech-cc | arm64 | lab-broonie | gcc-10   | defconfig |=
 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.276-7-g98c239d62b95/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.276-7-g98c239d62b95
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      98c239d62b95ab44dd05dea79b2d06668eec543a =



Test Regressions
---------------- =



platform                     | arch  | lab         | compiler | defconfig |=
 regressions
-----------------------------+-------+-------------+----------+-----------+=
------------
meson-gxl-s905x-libretech-cc | arm64 | lab-broonie | gcc-10   | defconfig |=
 1          =


  Details:     https://kernelci.org/test/plan/id/6262df009d1a09e354ff9491

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.276=
-7-g98c239d62b95/arm64/defconfig/gcc-10/lab-broonie/baseline-meson-gxl-s905=
x-libretech-cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.276=
-7-g98c239d62b95/arm64/defconfig/gcc-10/lab-broonie/baseline-meson-gxl-s905=
x-libretech-cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220411.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6262df009d1a09e354ff9=
492
        failing since 3 days (last pass: v4.14.275-277-gda5c0b6bebbb1, firs=
t fail: v4.14.275-284-gdf8ec5b4383b9) =

 =20
