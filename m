Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DB716BEBB6
	for <lists+stable@lfdr.de>; Fri, 17 Mar 2023 15:49:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230136AbjCQOtS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Mar 2023 10:49:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230309AbjCQOtS (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Mar 2023 10:49:18 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03F965BA7
        for <stable@vger.kernel.org>; Fri, 17 Mar 2023 07:49:17 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id fd25so3272717pfb.1
        for <stable@vger.kernel.org>; Fri, 17 Mar 2023 07:49:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112; t=1679064556;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=ztfKsr05xBWehTEe1WrSaLXfZ1IN+p1Sw9MxMCPeRso=;
        b=kp8jGwYJBHkS6eL68TXS3BbEqvAzKa+OWRVdSinZtCYSnIupcSNBfvoEdRfDNc5vN3
         VEQNNMEVdzyj0XiP5v0+F3ma8US8DM4kJnfYQ/WCGK8e9Prrg21P6nOEG69Lqxx1a6RH
         OaLjJGHqjcWQs04s9uQ5u7pPB/847GlBKumuGyJr352hsmC3EMkKs8WJnVNGU3fOy+QO
         dGyYwvVo0jo9smVBEYTRmlj5V8Km6mMnxDTBoMDJE9/p/kLIovpRmHW2l7372yryXuZs
         PWKY4orAv+90/v6LFFxOVn4ZvmfXUoGhUBBZjpTObiQUd6AayRqJlX2udH85E0SOcK3u
         f1MA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679064556;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ztfKsr05xBWehTEe1WrSaLXfZ1IN+p1Sw9MxMCPeRso=;
        b=E2hIMeSJ521oXunmpWp7z9nWXeXv0XHlGK7R/PE5aNevjZhv+uuiMunpVh0Ad2OUTq
         C8A+xa9u0oyGiZLFGNkHVfrQgUiw8it28lnilODeDruRswwK1SQKRp4ED/qv16F47WHd
         FXseRPQgi+7/2wN/TZ5D7AjbHXWV2fjQkRj5IIA23QbsIQ62RbNLQFfa9430l+sNw5NN
         DyrwIVodDjKEdE64vX/VPtia/lTXPhsUqTgMwSUyyqCm5ur6R+WzUkP+8F03IttUrUgI
         5k0jFFqOOdd6t5A7Krr/ChHKmQs1xIdLBFKmu+KavS/S+asN2dvi6ZE+HQzpFaFOvhsX
         Diow==
X-Gm-Message-State: AO0yUKUpjfVkZG1b2vJL2dmPTbHFZzFu9gUy3LvBbDic2ZYkyF0ZFklL
        olr/NHGtiDSt8DsAESxLIP191/sguGsp/gtG9Ho3PQ==
X-Google-Smtp-Source: AK7set/BS4f6urq6ZBrR/xyrCMflbd+NgoFH6R6PEKNuzBjAWxb4V5hh1UattwDcEDvPSDIeGcBsuA==
X-Received: by 2002:a62:1bc7:0:b0:625:c7f8:bf8e with SMTP id b190-20020a621bc7000000b00625c7f8bf8emr6746523pfb.34.1679064556220;
        Fri, 17 Mar 2023 07:49:16 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id g11-20020a62e30b000000b005ac419804d5sm1710046pfh.98.2023.03.17.07.49.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Mar 2023 07:49:15 -0700 (PDT)
Message-ID: <64147deb.620a0220.a73f7.34b1@mx.google.com>
Date:   Fri, 17 Mar 2023 07:49:15 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-6.1.y
X-Kernelci-Tree: stable
X-Kernelci-Kernel: v6.1.20
X-Kernelci-Report-Type: test
Subject: stable/linux-6.1.y baseline: 171 runs, 1 regressions (v6.1.20)
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

stable/linux-6.1.y baseline: 171 runs, 1 regressions (v6.1.20)

Regressions Summary
-------------------

platform           | arch | lab         | compiler | defconfig         | re=
gressions
-------------------+------+-------------+----------+-------------------+---=
---------
bcm2835-rpi-b-rev2 | arm  | lab-broonie | gcc-10   | bcm2835_defconfig | 1 =
         =


  Details:  https://kernelci.org/test/job/stable/branch/linux-6.1.y/kernel/=
v6.1.20/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-6.1.y
  Describe: v6.1.20
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      7eaef76fbc4621ced374c85dbc000dd80dc681d7 =



Test Regressions
---------------- =



platform           | arch | lab         | compiler | defconfig         | re=
gressions
-------------------+------+-------------+----------+-------------------+---=
---------
bcm2835-rpi-b-rev2 | arm  | lab-broonie | gcc-10   | bcm2835_defconfig | 1 =
         =


  Details:     https://kernelci.org/test/plan/id/64144a4cdde46312118c865f

  Results:     50 PASS, 2 FAIL, 1 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-6.1.y/v6.1.20/arm=
/bcm2835_defconfig/gcc-10/lab-broonie/baseline-bcm2835-rpi-b-rev2.txt
  HTML log:    https://storage.kernelci.org//stable/linux-6.1.y/v6.1.20/arm=
/bcm2835_defconfig/gcc-10/lab-broonie/baseline-bcm2835-rpi-b-rev2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64144a4cdde46312118c8696
        new failure (last pass: v6.1.19)

    2023-03-17T11:08:41.323969  + set +x
    2023-03-17T11:08:41.327840  <8>[   16.437632] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 177668_1.5.2.4.1>
    2023-03-17T11:08:41.444341  / # #
    2023-03-17T11:08:41.547159  export SHELL=3D/bin/sh
    2023-03-17T11:08:41.547847  #
    2023-03-17T11:08:41.649984  / # export SHELL=3D/bin/sh. /lava-177668/en=
vironment
    2023-03-17T11:08:41.650689  =

    2023-03-17T11:08:41.752646  / # . /lava-177668/environment/lava-177668/=
bin/lava-test-runner /lava-177668/1
    2023-03-17T11:08:41.753721  =

    2023-03-17T11:08:41.760439  / # /lava-177668/bin/lava-test-runner /lava=
-177668/1 =

    ... (14 line(s) more)  =

 =20
