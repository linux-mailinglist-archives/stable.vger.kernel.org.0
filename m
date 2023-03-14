Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28D096B88B8
	for <lists+stable@lfdr.de>; Tue, 14 Mar 2023 03:45:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229622AbjCNCp3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Mar 2023 22:45:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229633AbjCNCp2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Mar 2023 22:45:28 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0670C8B30A
        for <stable@vger.kernel.org>; Mon, 13 Mar 2023 19:45:27 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id cn6so1393651pjb.2
        for <stable@vger.kernel.org>; Mon, 13 Mar 2023 19:45:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112; t=1678761926;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=qRwBD68HQhL+tZCrQTrQjQfUYCgbHgGNBRmUxGj36WI=;
        b=YKXO6MgqQi12xCEHrsQIi+jC4R5Tt3ybfu5Byio9B1KTG4ZDAdiuwMpxIU5J6tZSSc
         wGA6uBMHuh/xTBvUujcBVFoSFYp7POupbSTPeU7zUAty9Dv2qQBe6b+DmXaF08LUSCkB
         s5COUeSi4+TfUjlgmqH/A8drdkIJMJHMEdFzYWefkQSK46zpzWbFQIMzkVfPLzUq7e1y
         97vPL+U5qEczQRgFKNRNdQcVFZgprim6BdrzE1dmcj0PipJtYBqpBrMOu02KdoWgz8l6
         eYpUBuOZT5tiF41/22JWas234I/xsL50DaWNXTpUm044uKOzf4xvl7sfMY46qyVIhu/9
         3Lag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678761926;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qRwBD68HQhL+tZCrQTrQjQfUYCgbHgGNBRmUxGj36WI=;
        b=cZqXlkkLJp0NGu9KN16rkLNEzLkIzR0lLlTXdbxMxto9My4zW+fXWY5aHykNt2VxJb
         tCSJrqrVhHYeNXPuO3REGkNjKgqJVG4wOm/k9HZZ3TosogPfqlZdnaYOOSRVhh/LmTYT
         jwxDE4lzKh+1nKLOG66o0PA471+IMU8t77vxzYedElrBDzHO6EDIa3IWQam+3bueEWem
         bE5Pm+ACaY2k54Zqgs0z850hZKtTGLm/El5pl+3NLmWTMuyLMQTs4piixD+gS3pwlNed
         sBvNUJNhmyugw6pXCRgB1GxpUPaO5Y8kgO3x/EiN6tBOBY7GwCxsI9QF/ICrSxtjppvB
         mBrQ==
X-Gm-Message-State: AO0yUKWTMco4UrKjTWusO0KNHdxgeN/CgJf3M0eK7s/OKKbpVTMA/94h
        /lm/dckFoyxi4G1g7RrE/ufOx0h9E8FmqmtK9sNOJw==
X-Google-Smtp-Source: AK7set83IYly32cH5/Zvt9wGJDZHh6pJ0+4z1xGP9c7WXkAZZrOke5XbnPDvNK3LmaC32WvodykUOA==
X-Received: by 2002:a17:90b:1b4a:b0:237:b5d4:c0df with SMTP id nv10-20020a17090b1b4a00b00237b5d4c0dfmr35936954pjb.6.1678761926209;
        Mon, 13 Mar 2023 19:45:26 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id t10-20020a17090ae50a00b00233d6547000sm509438pjy.54.2023.03.13.19.45.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Mar 2023 19:45:25 -0700 (PDT)
Message-ID: <640fdfc5.170a0220.e7ad5.1e69@mx.google.com>
Date:   Mon, 13 Mar 2023 19:45:25 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.10.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.10.173-4-g955623617f2f
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-5.10.y baseline: 187 runs,
 3 regressions (v5.10.173-4-g955623617f2f)
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

stable-rc/linux-5.10.y baseline: 187 runs, 3 regressions (v5.10.173-4-g9556=
23617f2f)

Regressions Summary
-------------------

platform          | arch  | lab           | compiler | defconfig           =
       | regressions
------------------+-------+---------------+----------+---------------------=
-------+------------
r8a7743-iwg20d-q7 | arm   | lab-cip       | gcc-10   | shmobile_defconfig  =
       | 1          =

rk3399-gru-kevin  | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chro=
mebook | 2          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.10.y/ker=
nel/v5.10.173-4-g955623617f2f/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.10.y
  Describe: v5.10.173-4-g955623617f2f
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      955623617f2f505ac08d0efda2bb50c1a52e2c96 =



Test Regressions
---------------- =



platform          | arch  | lab           | compiler | defconfig           =
       | regressions
------------------+-------+---------------+----------+---------------------=
-------+------------
r8a7743-iwg20d-q7 | arm   | lab-cip       | gcc-10   | shmobile_defconfig  =
       | 1          =


  Details:     https://kernelci.org/test/plan/id/640faac67864c4ec708c865d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: shmobile_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
73-4-g955623617f2f/arm/shmobile_defconfig/gcc-10/lab-cip/baseline-r8a7743-i=
wg20d-q7.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
73-4-g955623617f2f/arm/shmobile_defconfig/gcc-10/lab-cip/baseline-r8a7743-i=
wg20d-q7.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/640faac67864c4ec708c8=
65e
        new failure (last pass: v5.10.173) =

 =



platform          | arch  | lab           | compiler | defconfig           =
       | regressions
------------------+-------+---------------+----------+---------------------=
-------+------------
rk3399-gru-kevin  | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chro=
mebook | 2          =


  Details:     https://kernelci.org/test/plan/id/640fadbb4b8aca1bad8c863c

  Results:     84 PASS, 2 FAIL, 1 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
73-4-g955623617f2f/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/ba=
seline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
73-4-g955623617f2f/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/ba=
seline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-usb2phy1-probed: https://kernelci.org/test/cas=
e/id/640fadbb4b8aca1bad8c8646
        new failure (last pass: v5.10.173)

    2023-03-13T23:11:49.698351  /lava-9592130/1/../bin/lava-test-case

    2023-03-13T23:11:49.709015  <8>[   35.083672] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-usb2phy1-probed RESULT=3Dfail>
   =


  * baseline.bootrr.rockchip-usb2phy0-probed: https://kernelci.org/test/cas=
e/id/640fadbb4b8aca1bad8c8647
        new failure (last pass: v5.10.173)

    2023-03-13T23:11:47.635691  <8>[   33.008000] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-usb2phy-driver-present RESULT=3Dpass>

    2023-03-13T23:11:48.660505  /lava-9592130/1/../bin/lava-test-case

    2023-03-13T23:11:48.671606  <8>[   34.046283] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-usb2phy0-probed RESULT=3Dfail>
   =

 =20
