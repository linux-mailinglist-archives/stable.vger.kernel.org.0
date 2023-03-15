Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9533D6BBBF5
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 19:21:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232588AbjCOSU6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 14:20:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232541AbjCOSUb (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 14:20:31 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D89594A67
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 11:19:54 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id nn12so19809398pjb.5
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 11:19:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112; t=1678904388;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=sY9pDLFCYs18WqRjBKLodS7ZpLmSexF8s9NnXRsdxTU=;
        b=cvHFfUBsyziFLOb5+waNx/4Wt8WS1QnzTY349o1SonxUuM2P1NqFxIqwOnJCRxyzH5
         u21WvhH4C3lPmVe4eXVOf4UbTQvH4Ec65EcEGVDB4ZEIxF1KpA/e20/RO+c4gdRiE5g4
         sMSchtySg9a/yr3Wqskb0kGAAiW//53yXSK+dUGVBcgiIPB6z8vh59C9zYd0BIUiRQGT
         qAtSKmRfeGAEfWftqkdZMPGJGP8eBmfy9gGCHoBpwsQEd7L73ua7ajbvFv85mPdvzX5m
         UTu/N2bZ1LERdPD/9J7GPkdnIMo3rJx52ca3uH9OfosbkUOUZbdPfVH6TKxIDtCYCgRa
         tJ9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678904388;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=sY9pDLFCYs18WqRjBKLodS7ZpLmSexF8s9NnXRsdxTU=;
        b=A46G9svV+L//mHxQZY7KOsSANRcX1UP3AFPrPs0roThkBQT7jT3F0DkS2vNf8mz6L1
         KBKSGsA3nmNcb8O5QDcReDxFRMmCF+Rlnt2sfbQhSwmeEXqhIyh4RApDiyhBud3UrPN2
         MWrFul/7D7CsPG62HCWHZBQt6heSewi/vNZJStovac0OSrigZh+lOEsXVarRj7IfFDQI
         TmLCD+KOQggGo546dAfuDOl7+Z2o9117hBpwZtRFtNEoIgn16I7ARZ1t2x0zczloRr96
         tMorAG/0IFM0TcPsWVQ2XSGUXhIRmoJtpwq7oV+2+3DYx4usxsCNYCf3erBz6cRbHpah
         WjMw==
X-Gm-Message-State: AO0yUKVEQ5CtsFUQgwNBZLJIU2MOl6Mlqj1rZg7N+OQSBbLKPtohmOgC
        0x7vALxYJ7PRsYgTKs71iLrY0G1FFmgkja9y9DZiFwai
X-Google-Smtp-Source: AK7set/ByKE2+ox/ZSl51cxiHYmPhvMdk1MkP4vyXLhHnNDtPA3dHqoc82YSH0Bt2YbnAYTInVTfVw==
X-Received: by 2002:a17:902:f98b:b0:19c:da7f:a234 with SMTP id ky11-20020a170902f98b00b0019cda7fa234mr263300plb.67.1678904387871;
        Wed, 15 Mar 2023 11:19:47 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id e9-20020a170902cf4900b0019c92f56983sm3965675plg.120.2023.03.15.11.19.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Mar 2023 11:19:47 -0700 (PDT)
Message-ID: <64120c43.170a0220.d3ed1.9a24@mx.google.com>
Date:   Wed, 15 Mar 2023 11:19:47 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.276-44-g7cfb8ee7c98ea
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-4.19.y baseline: 61 runs,
 2 regressions (v4.19.276-44-g7cfb8ee7c98ea)
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

stable-rc/linux-4.19.y baseline: 61 runs, 2 regressions (v4.19.276-44-g7cfb=
8ee7c98ea)

Regressions Summary
-------------------

platform          | arch | lab     | compiler | defconfig           | regre=
ssions
------------------+------+---------+----------+---------------------+------=
------
beaglebone-black  | arm  | lab-cip | gcc-10   | omap2plus_defconfig | 1    =
      =

r8a7743-iwg20d-q7 | arm  | lab-cip | gcc-10   | shmobile_defconfig  | 1    =
      =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.19.y/ker=
nel/v4.19.276-44-g7cfb8ee7c98ea/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.19.y
  Describe: v4.19.276-44-g7cfb8ee7c98ea
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      7cfb8ee7c98ea035f7e87a68fde7f4c223c7c593 =



Test Regressions
---------------- =



platform          | arch | lab     | compiler | defconfig           | regre=
ssions
------------------+------+---------+----------+---------------------+------=
------
beaglebone-black  | arm  | lab-cip | gcc-10   | omap2plus_defconfig | 1    =
      =


  Details:     https://kernelci.org/test/plan/id/6411e29694f436682f8c8634

  Results:     41 PASS, 10 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
76-44-g7cfb8ee7c98ea/arm/omap2plus_defconfig/gcc-10/lab-cip/baseline-beagle=
bone-black.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
76-44-g7cfb8ee7c98ea/arm/omap2plus_defconfig/gcc-10/lab-cip/baseline-beagle=
bone-black.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6411e29694f436682f8c863b
        failing since 0 day (last pass: v4.19.276-4-g4f95ee925a2b, first fa=
il: v4.19.276-47-gcb91edfa52f0)

    2023-03-15T15:21:20.929282  + set +x<8>[   11.665784] <LAVA_SIGNAL_ENDR=
UN 0_dmesg 876368_1.5.2.4.1>
    2023-03-15T15:21:20.929597  =

    2023-03-15T15:21:21.041146  / # #
    2023-03-15T15:21:21.143035  export SHELL=3D/bin/sh
    2023-03-15T15:21:21.143551  #
    2023-03-15T15:21:21.244951  / # export SHELL=3D/bin/sh. /lava-876368/en=
vironment
    2023-03-15T15:21:21.245417  =

    2023-03-15T15:21:21.346863  / # . /lava-876368/environment/lava-876368/=
bin/lava-test-runner /lava-876368/1
    2023-03-15T15:21:21.347677  =

    2023-03-15T15:21:21.349840  / # /lava-876368/bin/lava-test-runner /lava=
-876368/1 =

    ... (12 line(s) more)  =

 =



platform          | arch | lab     | compiler | defconfig           | regre=
ssions
------------------+------+---------+----------+---------------------+------=
------
r8a7743-iwg20d-q7 | arm  | lab-cip | gcc-10   | shmobile_defconfig  | 1    =
      =


  Details:     https://kernelci.org/test/plan/id/6411d7628c63781bfd8c8651

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: shmobile_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
76-44-g7cfb8ee7c98ea/arm/shmobile_defconfig/gcc-10/lab-cip/baseline-r8a7743=
-iwg20d-q7.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
76-44-g7cfb8ee7c98ea/arm/shmobile_defconfig/gcc-10/lab-cip/baseline-r8a7743=
-iwg20d-q7.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6411d7628c63781bfd8c8=
652
        failing since 0 day (last pass: v4.19.276-4-g4f95ee925a2b, first fa=
il: v4.19.276-47-gcb91edfa52f0) =

 =20
