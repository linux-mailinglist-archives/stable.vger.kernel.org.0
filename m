Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19A8E590811
	for <lists+stable@lfdr.de>; Thu, 11 Aug 2022 23:31:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234910AbiHKVbA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Aug 2022 17:31:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236170AbiHKVa7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Aug 2022 17:30:59 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C04BC9D8E9
        for <stable@vger.kernel.org>; Thu, 11 Aug 2022 14:30:58 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id 73so18164367pgb.9
        for <stable@vger.kernel.org>; Thu, 11 Aug 2022 14:30:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc;
        bh=pGhxUkkabtaT9Sd4CCI39lt26qsT6Rv/tHn5c/8xdzM=;
        b=zKAZ7hO+lVwE6+bAiwMS4YqNzfGTYKFd51O/Kn9XzQhMkJ6QbAx1pC+EHpT+UxaEhg
         TxRqcGH9ZRznv37UCllU7UQQmpM8rGegtOvA3TYa9AdKNmObop5lODZMCtwHjiCoxvIn
         xM4LKk6m+Tq1Z0781y5Cp3xlwBCMSPrsk8/isoqQM2TkMes0Wo5mfCxzgLyFdwptMCM3
         y0ZFsvh+pxEAFElpW5gkzu4Q4VtMkXVVFWTWDmm6tBWvr64pRsSXB7JKhTx9xCGka1Oq
         bAHa+o6IlZic3qb/NnH/cxNTOuZhWXPxQ8B9cjkVj9WcsACo6kYdwi05h5XCu+d8RZkG
         a5jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc;
        bh=pGhxUkkabtaT9Sd4CCI39lt26qsT6Rv/tHn5c/8xdzM=;
        b=AT5yvwhJQnxlULV9VJhnvQvIeYaByPN30HAubHBLYmNLTmaEYaSf7OkqbLhE955uhE
         CoK3NcZNM4XOCtEiNqFGe5CRNbtDK0a2s5Pk0KtCTPAWIhih+eHWjVHUeg12ZQ28m0cX
         u/7u6znSaVaTax8CV/Dgjakf+TjwVS7bRQe4ygce2PH2FemhmeE4IYC/E0iuCFdUc9X8
         e1RJPZD0dBVrFJ5HdccrnH4myi0HjS+aAFBJbzDnvbvd9VFa35rt6XIOoVKU02E46Am1
         QdegkgYoisGgY7hNemJOj6omg6zBOsguVWd+6A4WrrN3adWz/8+fySFooGPw85FAlSTK
         lncQ==
X-Gm-Message-State: ACgBeo2AAkCJqM1VLdG5medNmd62idaJaEHA9D7tRim3CvlVwTTBFL9u
        99p7dehIhv7NRphtBtjPUW7+EKQE+4ywzZZDaM4=
X-Google-Smtp-Source: AA6agR66dD8bAkNS76t3BVw7Z4QZGsPsYF+G4hYDRuPwC0tsPNTgFdkw5qeDJdZc2gyPl5/KsiOThg==
X-Received: by 2002:a63:d0:0:b0:411:f92b:8e6c with SMTP id 199-20020a6300d0000000b00411f92b8e6cmr714797pga.108.1660253458140;
        Thu, 11 Aug 2022 14:30:58 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id x23-20020aa78f17000000b005252a06750esm139821pfr.182.2022.08.11.14.30.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Aug 2022 14:30:57 -0700 (PDT)
Message-ID: <62f57511.a70a0220.78e39.05b3@mx.google.com>
Date:   Thu, 11 Aug 2022 14:30:57 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.15
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.15.60-22-gaa26185c2c1ff
Subject: stable-rc/queue/5.15 baseline: 161 runs,
 1 regressions (v5.15.60-22-gaa26185c2c1ff)
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

stable-rc/queue/5.15 baseline: 161 runs, 1 regressions (v5.15.60-22-gaa2618=
5c2c1ff)

Regressions Summary
-------------------

platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.60-22-gaa26185c2c1ff/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.60-22-gaa26185c2c1ff
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      aa26185c2c1ff858e1af1930a5d473f172af6cd9 =



Test Regressions
---------------- =



platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/62f543edfe65386a07daf068

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.60-=
22-gaa26185c2c1ff/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beag=
le-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.60-=
22-gaa26185c2c1ff/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beag=
le-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62f543edfe65386a07daf=
069
        failing since 133 days (last pass: v5.15.31-2-g57d4301e22c2, first =
fail: v5.15.31-3-g4ae45332eb9c) =

 =20
