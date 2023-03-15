Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75C756BB7A9
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 16:26:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231716AbjCOP0D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 11:26:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231466AbjCOP0D (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 11:26:03 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16E2315C96
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 08:26:01 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id j3-20020a17090adc8300b0023d09aea4a6so2194132pjv.5
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 08:26:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112; t=1678893960;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=bqLbQG63fWszZgD6hrTlvR6r840hbh4wc3xlInsNUa8=;
        b=EiLLyth6C3hBSWFMCiSl6pMmQMMH5IwN6x9tXpMxwMTfn9AM2mEGhtKDqVFdYRtc69
         wM8eI+8ZP3JkRgwn4vR8aty3YQ96cpmafqVUaZvmRKJmlQn5RRmoqw2ZCxsbWIqfoeA0
         SwUplR9jnHQZ7gayfbeq2VZK6qFLQs4hJVexzBIOxFLtdaBOEY2pd8MmeiI5HYL/fzLt
         JcNjjgc6NF7GsZlRRm1S+ySd3aPDuCCZsghU4INAG0d1DMeBZkXCgBOb8iR3ZbnaH+Uy
         u2uWrSUKTC+TUgKyVkJHvn73vqgsFkYKLdfJL5rSEGfYOHcFWLeVP/cbBBFFUSZ1uq8e
         8TEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678893960;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bqLbQG63fWszZgD6hrTlvR6r840hbh4wc3xlInsNUa8=;
        b=aB+M4qeKAx1PljGraa91CVVtmUNqaNYA+VteMgy1o8gnT5QyfqtPgU8qZolkK9tpAL
         1J0r+4jl3hWHnIq5ofiDKLzhyhSv12SfuCDZFeFFjIz5/WXX9+kJaSK03Wmb+13swDxn
         ejQtUoDb3oN3/bi9x6sSIpr5aAFQsBGMQaitafjfSaRg5N890Y/seYQALff6dLQ7IMdE
         v5dIeeco2vCdMZ2bnCU5y8yARD8spfEOjFaIq67prXc24mcK51Th/pU3R7Uf8iJSrNS/
         Ea2rDcjpSBDUUSbd01EoAKdaIcbvjkziFUJjJj1qya4Yv2+kymZyi5keUQxTHtBGt6ul
         0xOw==
X-Gm-Message-State: AO0yUKVVuEuz0d3AvUAPyR9yRTRlFtu0V4tu9DezP0XicopdtjBo4K5n
        6hw7BfvCoEc7ZCLt3mr+fX0cqZEvCXnnbGZEcRv1EdWO
X-Google-Smtp-Source: AK7set/qq1BMjqf/+4eP7iWsJd4c13h8RX9SL4XiTyzbDZfoBVk3vsXce/g8oUrVJQTIXQlfehhD8g==
X-Received: by 2002:a17:90b:38c3:b0:233:ebf8:424f with SMTP id nn3-20020a17090b38c300b00233ebf8424fmr311669pjb.0.1678893960075;
        Wed, 15 Mar 2023 08:26:00 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id iy18-20020a170903131200b001a045f45d49sm3746508plb.281.2023.03.15.08.25.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Mar 2023 08:25:59 -0700 (PDT)
Message-ID: <6411e387.170a0220.47fbb.892d@mx.google.com>
Date:   Wed, 15 Mar 2023 08:25:59 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.276-47-gcb91edfa52f0
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-4.19.y baseline: 63 runs,
 3 regressions (v4.19.276-47-gcb91edfa52f0)
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

stable-rc/linux-4.19.y baseline: 63 runs, 3 regressions (v4.19.276-47-gcb91=
edfa52f0)

Regressions Summary
-------------------

platform          | arch | lab         | compiler | defconfig           | r=
egressions
------------------+------+-------------+----------+---------------------+--=
----------
beaglebone-black  | arm  | lab-broonie | gcc-10   | omap2plus_defconfig | 1=
          =

beaglebone-black  | arm  | lab-cip     | gcc-10   | omap2plus_defconfig | 1=
          =

r8a7743-iwg20d-q7 | arm  | lab-cip     | gcc-10   | shmobile_defconfig  | 1=
          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.19.y/ker=
nel/v4.19.276-47-gcb91edfa52f0/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.19.y
  Describe: v4.19.276-47-gcb91edfa52f0
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      cb91edfa52f0b1a9fca6342d158744cd1d673a57 =



Test Regressions
---------------- =



platform          | arch | lab         | compiler | defconfig           | r=
egressions
------------------+------+-------------+----------+---------------------+--=
----------
beaglebone-black  | arm  | lab-broonie | gcc-10   | omap2plus_defconfig | 1=
          =


  Details:     https://kernelci.org/test/plan/id/6411afa1ad94da13458c8630

  Results:     41 PASS, 10 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
76-47-gcb91edfa52f0/arm/omap2plus_defconfig/gcc-10/lab-broonie/baseline-bea=
glebone-black.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
76-47-gcb91edfa52f0/arm/omap2plus_defconfig/gcc-10/lab-broonie/baseline-bea=
glebone-black.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6411afa1ad94da13458c8660
        new failure (last pass: v4.19.276-4-g4f95ee925a2b)

    2023-03-15T11:44:00.908628  + set +x<8>[   18.462874] <LAVA_SIGNAL_ENDR=
UN 0_dmesg 166854_1.5.2.4.1>
    2023-03-15T11:44:00.909150  =

    2023-03-15T11:44:01.020805  / # #
    2023-03-15T11:44:01.123280  export SHELL=3D/bin/sh
    2023-03-15T11:44:01.124002  #
    2023-03-15T11:44:01.226292  / # export SHELL=3D/bin/sh. /lava-166854/en=
vironment
    2023-03-15T11:44:01.227011  =

    2023-03-15T11:44:01.328932  / # . /lava-166854/environment/lava-166854/=
bin/lava-test-runner /lava-166854/1
    2023-03-15T11:44:01.330118  =

    2023-03-15T11:44:01.334103  / # /lava-166854/bin/lava-test-runner /lava=
-166854/1 =

    ... (12 line(s) more)  =

 =



platform          | arch | lab         | compiler | defconfig           | r=
egressions
------------------+------+-------------+----------+---------------------+--=
----------
beaglebone-black  | arm  | lab-cip     | gcc-10   | omap2plus_defconfig | 1=
          =


  Details:     https://kernelci.org/test/plan/id/6411af5581dd2f43dd8c86a7

  Results:     41 PASS, 10 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
76-47-gcb91edfa52f0/arm/omap2plus_defconfig/gcc-10/lab-cip/baseline-beagleb=
one-black.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
76-47-gcb91edfa52f0/arm/omap2plus_defconfig/gcc-10/lab-cip/baseline-beagleb=
one-black.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6411af5581dd2f43dd8c86ae
        new failure (last pass: v4.19.276-4-g4f95ee925a2b)

    2023-03-15T11:42:40.284598  + set +x<8>[   11.683461] <LAVA_SIGNAL_ENDR=
UN 0_dmesg 876176_1.5.2.4.1>
    2023-03-15T11:42:40.284904  =

    2023-03-15T11:42:40.395805  / # #
    2023-03-15T11:42:40.497702  export SHELL=3D/bin/sh
    2023-03-15T11:42:40.498179  #
    2023-03-15T11:42:40.599564  / # export SHELL=3D/bin/sh. /lava-876176/en=
vironment
    2023-03-15T11:42:40.600042  =

    2023-03-15T11:42:40.701447  / # . /lava-876176/environment/lava-876176/=
bin/lava-test-runner /lava-876176/1
    2023-03-15T11:42:40.702260  =

    2023-03-15T11:42:40.704477  / # /lava-876176/bin/lava-test-runner /lava=
-876176/1 =

    ... (12 line(s) more)  =

 =



platform          | arch | lab         | compiler | defconfig           | r=
egressions
------------------+------+-------------+----------+---------------------+--=
----------
r8a7743-iwg20d-q7 | arm  | lab-cip     | gcc-10   | shmobile_defconfig  | 1=
          =


  Details:     https://kernelci.org/test/plan/id/6411b2a017bd3351bf8c8641

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: shmobile_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
76-47-gcb91edfa52f0/arm/shmobile_defconfig/gcc-10/lab-cip/baseline-r8a7743-=
iwg20d-q7.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
76-47-gcb91edfa52f0/arm/shmobile_defconfig/gcc-10/lab-cip/baseline-r8a7743-=
iwg20d-q7.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6411b2a017bd3351bf8c8=
642
        new failure (last pass: v4.19.276-4-g4f95ee925a2b) =

 =20
