Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21016572995
	for <lists+stable@lfdr.de>; Wed, 13 Jul 2022 01:01:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230507AbiGLXBC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jul 2022 19:01:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232397AbiGLXBB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Jul 2022 19:01:01 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 085AD64E2B
        for <stable@vger.kernel.org>; Tue, 12 Jul 2022 16:01:00 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id l124so8705763pfl.8
        for <stable@vger.kernel.org>; Tue, 12 Jul 2022 16:01:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=G6TTYaBvb5I/MOk/6FzxfqXC8TwhnxFPhr55HnSLTD8=;
        b=cVDCRmbqQg1AUTXg0HekDJ8mxlKA7QqcZwYtaRClJW8SySJnsfpZ85gav6QNsmm+XU
         Ss5g3e69/kokyWISqFB+m4HmaJznDrQ8H3nFXqteSHDThPGxv7hEMZcsKReXVEBWsvKP
         8lglAhhqmwtP5J1cf9sSB1vgBmHkspis13ntQXvIloHhHd9z3rduncqshwNmULXpDMoI
         XhWjJCW+zWKffOTzJc1qbNc9k0zu2sBtC18vRtvTYumV5tFqTWmwoouODoYpW2ee5wds
         Dz8itThLPp1hFzLIvXBLxhREFBLdqp+ctzJ9uNM6pJfJMKX7Kc3qD1qxnDv+8fNNFQzI
         gAcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=G6TTYaBvb5I/MOk/6FzxfqXC8TwhnxFPhr55HnSLTD8=;
        b=1uK6HCVe+QFp58rKj7piQ88enMVucHOYL090+x4CAYIlvwuti+fRaQ/sQcdwUKl7LT
         6pt34Xzkvqda9Y6r8H8pkY8dfPXO9GgmyLny55BIhO9Bz7ju/Dviw3DWSCIuOd6wN2NX
         RD5J4j5c9IeM7sSrTCNHxuJnFQwCFtcQK+1Ki5MrzTESEaJyt5JfYTfSLl7vnCgUc/qA
         yGV62+agMVrXMvYTEnSmmA1hxezTM+98+FFFVhr5s8v41TnP6kggPn7qTSbcIGXVb29N
         i2DdeWp+dcs3/wVguXJq/J8uk4M7BrLVitI8itG9pYrDJL3C+9MfUy9lckOWpEVxLjvR
         nh3Q==
X-Gm-Message-State: AJIora/bL5Gmqw4l04d/d4hVfXn75bUqLaFAHke/49kTrbKcjFj0j3K3
        o43aXXHq1BRw6XJS/6/IOwrCrZSdY2OYs3x1
X-Google-Smtp-Source: AGRyM1u9zA6MB05JL8S7KNtiukRD+fwHzejrYbFUDJ6sw60njHFrucBKkbwrnxr/JtecMLOQviduQw==
X-Received: by 2002:a05:6a00:815:b0:52a:dea8:269b with SMTP id m21-20020a056a00081500b0052adea8269bmr445616pfk.66.1657666859243;
        Tue, 12 Jul 2022 16:00:59 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id v68-20020a622f47000000b005254344bf48sm7362734pfv.5.2022.07.12.16.00.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Jul 2022 16:00:58 -0700 (PDT)
Message-ID: <62cdfd2a.1c69fb81.483ef.b205@mx.google.com>
Date:   Tue, 12 Jul 2022 16:00:58 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.9.323
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Tree: stable
Subject: stable/linux-4.9.y baseline: 59 runs, 2 regressions (v4.9.323)
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

stable/linux-4.9.y baseline: 59 runs, 2 regressions (v4.9.323)

Regressions Summary
-------------------

platform      | arch | lab          | compiler | defconfig          | regre=
ssions
--------------+------+--------------+----------+--------------------+------=
------
at91sam9g20ek | arm  | lab-broonie  | gcc-10   | multi_v5_defconfig | 1    =
      =

jetson-tk1    | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig | 1    =
      =


  Details:  https://kernelci.org/test/job/stable/branch/linux-4.9.y/kernel/=
v4.9.323/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-4.9.y
  Describe: v4.9.323
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      dadca36da71766becf9553b5f54fcfa5ba5fa4b0 =



Test Regressions
---------------- =



platform      | arch | lab          | compiler | defconfig          | regre=
ssions
--------------+------+--------------+----------+--------------------+------=
------
at91sam9g20ek | arm  | lab-broonie  | gcc-10   | multi_v5_defconfig | 1    =
      =


  Details:     https://kernelci.org/test/plan/id/62cdca25d0e2eb22e0a39c0d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v5_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.9.y/v4.9.323/ar=
m/multi_v5_defconfig/gcc-10/lab-broonie/baseline-at91sam9g20ek.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.9.y/v4.9.323/ar=
m/multi_v5_defconfig/gcc-10/lab-broonie/baseline-at91sam9g20ek.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220708.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62cdca25d0e2eb22e0a39=
c0e
        new failure (last pass: v4.9.319) =

 =



platform      | arch | lab          | compiler | defconfig          | regre=
ssions
--------------+------+--------------+----------+--------------------+------=
------
jetson-tk1    | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig | 1    =
      =


  Details:     https://kernelci.org/test/plan/id/62cdcaa6f2bbcbb971a39be8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.9.y/v4.9.323/ar=
m/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-jetson-tk1.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.9.y/v4.9.323/ar=
m/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-jetson-tk1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220708.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62cdcaa6f2bbcbb971a39=
be9
        failing since 36 days (last pass: v4.9.314, first fail: v4.9.317) =

 =20
