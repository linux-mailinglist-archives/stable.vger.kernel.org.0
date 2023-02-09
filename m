Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3CB2691033
	for <lists+stable@lfdr.de>; Thu,  9 Feb 2023 19:18:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229583AbjBISSM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Feb 2023 13:18:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229839AbjBISSL (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Feb 2023 13:18:11 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A3841BCB
        for <stable@vger.kernel.org>; Thu,  9 Feb 2023 10:18:10 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id f15-20020a17090ac28f00b00230a32f0c9eso3159515pjt.4
        for <stable@vger.kernel.org>; Thu, 09 Feb 2023 10:18:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=s+ojUlnOQMP5bHhPET77z3p9TsIOFplE4F+PKNo7ciY=;
        b=REV6FJ5a4rt1z4UqWylazkrtF/ahrlMU51eDq4KUuHmzgxL/QAbCGILweGk6vUhFFh
         rMIfBIif9fUInNLTqkQ7JHPCedI36ZwKohe8+SWDeLXlh11k3M0TcUL+WVaK/A+n+vPz
         gFzECJXIX7wKX1yTt4f/dg6Em0SlrVRGNC3FI5nvrt4xNRITx5aiiwDUYQD+VYHVycjv
         jOGnygelaL3BypJ0l0gYygOeIv+KD0u5YEgVCAvbhufoK5BD6BLlAlAF75azaB9PyazF
         JxqoOPb6IQ5ZAUi2EJLpJ/oufjMF+R/+TY9uqAIBjw3xpURhWZpAn1aERdseoyXROxI+
         444w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=s+ojUlnOQMP5bHhPET77z3p9TsIOFplE4F+PKNo7ciY=;
        b=xUMX3SSYVmiDEW2t89pp44kbRXI3cwSxfdVQxVuETfXpjhq2MouKGoq8WlIFMhj4L4
         BTL59xDQ3IV2rVcrmMIMO05JhiOnBCW/gyq+8LPmgnyNJafBwqsFnS47zqivJ11Cfoia
         K+l5jhHb8VsNND/sKjC2NS19MpY8GJv70+Ie+jlciexeyKVC1QUtqktERsO2ckhhj8o5
         Vu7gIvZq8K34YlILv+yXX5s1hS1Yp2OrKSk/NWd8se9UGY6wkHZeYbrUq+VwdOhkqUSA
         li2QKMvQlJ6ChtW5iyyD0HimWIgdH1LAv3BVXZNMehNz0RrZHlZXrE4+hpNgLsXszuFP
         FswQ==
X-Gm-Message-State: AO0yUKUDHhzOZjPd2vBIWBRWPIsg2EDZLDSJRfP1CKtgUqC0VgqGOVpw
        jl1beCj9lydoiJnir6T8/YQx+xhv8bS2SMkEc9Tl6g==
X-Google-Smtp-Source: AK7set+3bDDQdnHwihfzsujqtJVPO7en6SaJd9DGQhsrg1yCWe8NXVWJhZpL5gWfBhc+B0rjLP2rHA==
X-Received: by 2002:a17:90b:384e:b0:230:f169:ebbc with SMTP id nl14-20020a17090b384e00b00230f169ebbcmr6321429pjb.47.1675966689743;
        Thu, 09 Feb 2023 10:18:09 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id gb7-20020a17090b060700b0021904307a53sm1704466pjb.19.2023.02.09.10.18.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Feb 2023 10:18:09 -0800 (PST)
Message-ID: <63e538e1.170a0220.19210.3236@mx.google.com>
Date:   Thu, 09 Feb 2023 10:18:09 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.10.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.10.167
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-5.10.y baseline: 157 runs, 2 regressions (v5.10.167)
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

stable-rc/linux-5.10.y baseline: 157 runs, 2 regressions (v5.10.167)

Regressions Summary
-------------------

platform          | arch | lab          | compiler | defconfig          | r=
egressions
------------------+------+--------------+----------+--------------------+--=
----------
cubietruck        | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig | 1=
          =

r8a7743-iwg20d-q7 | arm  | lab-cip      | gcc-10   | shmobile_defconfig | 1=
          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.10.y/ker=
nel/v5.10.167/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.10.y
  Describe: v5.10.167
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      a5acb54d4066f27e9707af9d93f047f542d5ad88 =



Test Regressions
---------------- =



platform          | arch | lab          | compiler | defconfig          | r=
egressions
------------------+------+--------------+----------+--------------------+--=
----------
cubietruck        | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig | 1=
          =


  Details:     https://kernelci.org/test/plan/id/63e5065ac0fe7963b38c864d

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
67/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubietruck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
67/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubietruck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230203.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63e5065ac0fe7963b38c8656
        failing since 22 days (last pass: v5.10.158-107-gd2432186ff47, firs=
t fail: v5.10.162-852-geeaac3cf2eb3)

    2023-02-09T14:42:04.981873  <8>[   11.020059] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3313409_1.5.2.4.1>
    2023-02-09T14:42:05.091595  / # #
    2023-02-09T14:42:05.194529  export SHELL=3D/bin/sh
    2023-02-09T14:42:05.195406  #
    2023-02-09T14:42:05.297349  / # export SHELL=3D/bin/sh. /lava-3313409/e=
nvironment
    2023-02-09T14:42:05.298512  =

    2023-02-09T14:42:05.400729  / # . /lava-3313409/environment/lava-331340=
9/bin/lava-test-runner /lava-3313409/1
    2023-02-09T14:42:05.402504  =

    2023-02-09T14:42:05.402985  / # <3>[   11.371177] Bluetooth: hci0: comm=
and 0x0c03 tx timeout
    2023-02-09T14:42:05.406812  /lava-3313409/bin/lava-test-runner /lava-33=
13409/1 =

    ... (12 line(s) more)  =

 =



platform          | arch | lab          | compiler | defconfig          | r=
egressions
------------------+------+--------------+----------+--------------------+--=
----------
r8a7743-iwg20d-q7 | arm  | lab-cip      | gcc-10   | shmobile_defconfig | 1=
          =


  Details:     https://kernelci.org/test/plan/id/63e506d1ce7bdffa998c8657

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: shmobile_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
67/arm/shmobile_defconfig/gcc-10/lab-cip/baseline-r8a7743-iwg20d-q7.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
67/arm/shmobile_defconfig/gcc-10/lab-cip/baseline-r8a7743-iwg20d-q7.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230203.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63e506d1ce7bdffa998c8=
658
        new failure (last pass: v5.10.166-100-ge9ce3cb0864d) =

 =20
