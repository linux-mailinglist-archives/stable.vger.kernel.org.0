Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF8BD505C09
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 17:54:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345925AbiDRP4y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 11:56:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345915AbiDRP4p (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 11:56:45 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 501DA6169
        for <stable@vger.kernel.org>; Mon, 18 Apr 2022 08:46:52 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id t184so6564220pgd.4
        for <stable@vger.kernel.org>; Mon, 18 Apr 2022 08:46:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=pqL83gyYh+Je67LQLLqPQpyDir2TK5996yeDvdGuh9c=;
        b=u/fORLk+PLCMtboLo3NLyyH8xd6o8ly+qttJm+UVke45qx1mlEhg0yk3lC0VNti5/j
         3DSkWhL6acVt5dLQxL1xqfDrsJL/TI0pIrZe4hoLb4aaIAqMtmtaQQ4C3P1ZVf1ZSBPg
         ft1PDH59sWVz9IBdi3xwjkibzZF6ak3+3Gz/E7V0qx4xGr8CfazNyrxb+kVAtRRdsA86
         C+eyYRkQwWLi975Y1LiZygbpzT6r3OGA6/c4BWg2H19c0XW90iLS1jrl38aOgmSAFg3s
         /jfvBcwhAmb2jybEWivuH6QoQEqomOOsNbVd0keYMIPky7ZnU+K2D7jbKXw9S3kzi6Ae
         GwNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=pqL83gyYh+Je67LQLLqPQpyDir2TK5996yeDvdGuh9c=;
        b=UqLl575y41cBt0svQPtHtmCPWxN5j17vEaFF9UzBz8adsbzduRm32z2mfvp0v0q3+W
         FU2f7a7okPNFKrNdFvi+T1l763vMM1LMoV3DSnL6Ol5TrUOMJ+NluioAny0YyrEEmohJ
         hSf4ryisKXaVh5G2n47kDK8WB11+DnVboanpYgE24Nig4enviy5R/6KOHCHw86RJuWak
         ESBCXPyEpfTQnVjuEjCwdaKw8qlsCriZW1zjk+YkCK1YiZKLODcV8Dst8gGnPd8dQ5wm
         rWain18LLyKbPFLxHy+13nkPK6QGF2hdbFi5am0WkPGofiRBNIpWO4IAlhLN7MWC/kpk
         CY6A==
X-Gm-Message-State: AOAM532tSIyEv+jhSvLdrILav4eJ/0kEynX7Bz7cHvDUI5Y8mIFOfiq2
        pvPCQ4ySrvrCaHldRE8UBA/G+TK6SwOFzIWu
X-Google-Smtp-Source: ABdhPJxdI/y0dUsSkn078e9t/nYu7MH2HKvvZg3HfeMsgh904FppltTT6sGEilVrZDeD/fajo4z9LQ==
X-Received: by 2002:a05:6a00:a12:b0:504:e93f:2dd9 with SMTP id p18-20020a056a000a1200b00504e93f2dd9mr13052568pfh.49.1650296811614;
        Mon, 18 Apr 2022 08:46:51 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id j22-20020a63e756000000b003a89ab73571sm6204060pgk.39.2022.04.18.08.46.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Apr 2022 08:46:51 -0700 (PDT)
Message-ID: <625d87eb.1c69fb81.b9208.d837@mx.google.com>
Date:   Mon, 18 Apr 2022 08:46:51 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.17
X-Kernelci-Kernel: v5.17.3-174-g4a7871df41c5e
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.17 baseline: 150 runs,
 2 regressions (v5.17.3-174-g4a7871df41c5e)
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

stable-rc/queue/5.17 baseline: 150 runs, 2 regressions (v5.17.3-174-g4a7871=
df41c5e)

Regressions Summary
-------------------

platform      | arch | lab         | compiler | defconfig          | regres=
sions
--------------+------+-------------+----------+--------------------+-------=
-----
at91sam9g20ek | arm  | lab-broonie | gcc-10   | at91_dt_defconfig  | 1     =
     =

at91sam9g20ek | arm  | lab-broonie | gcc-10   | multi_v5_defconfig | 1     =
     =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.17/ker=
nel/v5.17.3-174-g4a7871df41c5e/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.17
  Describe: v5.17.3-174-g4a7871df41c5e
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      4a7871df41c5e011655f5b256b23029669b45edc =



Test Regressions
---------------- =



platform      | arch | lab         | compiler | defconfig          | regres=
sions
--------------+------+-------------+----------+--------------------+-------=
-----
at91sam9g20ek | arm  | lab-broonie | gcc-10   | at91_dt_defconfig  | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/625d1b57895f903d77ae0697

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: at91_dt_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.17/v5.17.3-1=
74-g4a7871df41c5e/arm/at91_dt_defconfig/gcc-10/lab-broonie/baseline-at91sam=
9g20ek.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.17/v5.17.3-1=
74-g4a7871df41c5e/arm/at91_dt_defconfig/gcc-10/lab-broonie/baseline-at91sam=
9g20ek.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220401.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/625d1b57895f903d77ae0=
698
        failing since 3 days (last pass: v5.17.2-343-g74625fba2cc43, first =
fail: v5.17.3-7-g214113ee8b920) =

 =



platform      | arch | lab         | compiler | defconfig          | regres=
sions
--------------+------+-------------+----------+--------------------+-------=
-----
at91sam9g20ek | arm  | lab-broonie | gcc-10   | multi_v5_defconfig | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/625d1cab59048fd5a2ae06b7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v5_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.17/v5.17.3-1=
74-g4a7871df41c5e/arm/multi_v5_defconfig/gcc-10/lab-broonie/baseline-at91sa=
m9g20ek.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.17/v5.17.3-1=
74-g4a7871df41c5e/arm/multi_v5_defconfig/gcc-10/lab-broonie/baseline-at91sa=
m9g20ek.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220401.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/625d1cab59048fd5a2ae0=
6b8
        failing since 3 days (last pass: v5.17.2-339-g22fa848c25c53, first =
fail: v5.17.3-7-g214113ee8b920) =

 =20
