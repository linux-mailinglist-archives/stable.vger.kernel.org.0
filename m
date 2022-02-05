Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 887084AAC62
	for <lists+stable@lfdr.de>; Sat,  5 Feb 2022 21:03:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240626AbiBEUD4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 5 Feb 2022 15:03:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230206AbiBEUD4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 5 Feb 2022 15:03:56 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1E93C061348
        for <stable@vger.kernel.org>; Sat,  5 Feb 2022 12:03:54 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id z14-20020a17090ab10e00b001b6175d4040so16397321pjq.0
        for <stable@vger.kernel.org>; Sat, 05 Feb 2022 12:03:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=aC5H62JHAMjk/0znTY9VHDGJULUOOmZbQMPF/xoHMLI=;
        b=Aphah7FVhVtwfuFUEHt6y64Bjyjg0d/cV7d5Jn9LiBM+gK9HJbvL2nDrnUVQo3w26S
         6pbhHulLoLPsnXH/x+wg51G9d1y76l0pOfm1+xtOv7J6L0O4Jg4tOCEAoU9DOsWxcY8W
         75VeZau6oTFXarQPliS2ARel8hrD5QwfPXcF6COcDW3S5TiU+TZehK7+AQIQ78yLEjyl
         zGhq51x3AKt4Wq+6WoTocviFGC8HFr0eAgF5ptXCzkg6H4+pp3fhgpBAUGCmSF9uD24U
         TGoc98iv7F0HKW2m4LO3oaoZ/lM/+IcJCIwY7Ob/PLNRTcoA+GfIZwwVEdu+/eBI7bLq
         k+3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=aC5H62JHAMjk/0znTY9VHDGJULUOOmZbQMPF/xoHMLI=;
        b=MwwZYO+ErAXb1vPocFc5et9QGtj71ANIi85/ocR22oO9VVhDw6jZAoVh02WAxQwZJF
         piBqjkWGXOyLwQkOAD9Ov/d5/N/9QnqV4FuP3dpOgT6oQbTPCCed1YYZuo1W/nkwjXte
         wItsDjkxBIYt3WkMKcJjSIDcNYlnA3J3fl+/rq5BDmiPMX9xb6pC+1vo4B/Suklxttrx
         k4G1beEuYKlHY+TIeAcARA9/U2SIY54LXZTMztCPvuOZm8o2fyFnqPWpnlKDY1Ubw2Z1
         6W03d2rQxQr+oH66h9TWDjHcfesv4Mb9tht79tIAQxPAztSXEu+e2eQCJNVkYY7xuadz
         xPug==
X-Gm-Message-State: AOAM530CWTEnL/MPv9FUPdOBNEUoUBjs+auI3eu66OvA8LZwQumFUSbN
        iw0jdLIBFYCF3hbTj20jWXdCdRx7bQ9CRfIc
X-Google-Smtp-Source: ABdhPJzY3576NRUtGUPFFsa8nYWZOyVKPjegETLq6EPg4h2YLS7YAjUC0G8/RpYq+f0CV+cr14BFBg==
X-Received: by 2002:a17:90b:3148:: with SMTP id ip8mr5819061pjb.106.1644091433945;
        Sat, 05 Feb 2022 12:03:53 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id s32sm1393131pfw.80.2022.02.05.12.03.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Feb 2022 12:03:53 -0800 (PST)
Message-ID: <61fed829.1c69fb81.c43ef.2e9e@mx.google.com>
Date:   Sat, 05 Feb 2022 12:03:53 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.16.6
X-Kernelci-Tree: stable
X-Kernelci-Report-Type: test
X-Kernelci-Branch: linux-5.16.y
Subject: stable/linux-5.16.y baseline: 161 runs, 2 regressions (v5.16.6)
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

stable/linux-5.16.y baseline: 161 runs, 2 regressions (v5.16.6)

Regressions Summary
-------------------

platform                | arch  | lab          | compiler | defconfig | reg=
ressions
------------------------+-------+--------------+----------+-----------+----=
--------
r8a77950-salvator-x     | arm64 | lab-baylibre | gcc-10   | defconfig | 1  =
        =

sun50i-a64-bananapi-m64 | arm64 | lab-clabbe   | gcc-10   | defconfig | 1  =
        =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.16.y/kernel=
/v5.16.6/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.16.y
  Describe: v5.16.6
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      20e6a329f12d6f8862602eaf5e74544a768c0723 =



Test Regressions
---------------- =



platform                | arch  | lab          | compiler | defconfig | reg=
ressions
------------------------+-------+--------------+----------+-----------+----=
--------
r8a77950-salvator-x     | arm64 | lab-baylibre | gcc-10   | defconfig | 1  =
        =


  Details:     https://kernelci.org/test/plan/id/61fea20fd19fefd4875d6eeb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.16.y/v5.16.6/ar=
m64/defconfig/gcc-10/lab-baylibre/baseline-r8a77950-salvator-x.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.16.y/v5.16.6/ar=
m64/defconfig/gcc-10/lab-baylibre/baseline-r8a77950-salvator-x.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61fea20fd19fefd4875d6=
eec
        new failure (last pass: v5.16.5) =

 =



platform                | arch  | lab          | compiler | defconfig | reg=
ressions
------------------------+-------+--------------+----------+-----------+----=
--------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe   | gcc-10   | defconfig | 1  =
        =


  Details:     https://kernelci.org/test/plan/id/61fea22cba9b9ab19d5d6eec

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.16.y/v5.16.6/ar=
m64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-bananapi-m64.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.16.y/v5.16.6/ar=
m64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-bananapi-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61fea22cba9b9ab19d5d6=
eed
        new failure (last pass: v5.16.2) =

 =20
