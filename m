Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 167065E937E
	for <lists+stable@lfdr.de>; Sun, 25 Sep 2022 15:48:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231511AbiIYNsq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 25 Sep 2022 09:48:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231698AbiIYNsp (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 25 Sep 2022 09:48:45 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6DF22CE21
        for <stable@vger.kernel.org>; Sun, 25 Sep 2022 06:48:41 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id 129so2956780pgc.5
        for <stable@vger.kernel.org>; Sun, 25 Sep 2022 06:48:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date;
        bh=fpIbF6pbywZ8+FIAm++uThbONT1NKKtEpu0wb7tvsjU=;
        b=Ii1NjwAQ9iazfW3bLVcNPFU/idHv+SN10ZtnJ/FFBGBLE3lKzvUm6bFEa9Jz4cHI3W
         WA11tOQGdbY/yiAaj//APa0gwssZU4aYeODtHKWpiGrMHM7Na2MUjrQdSD7UfmZUnvT0
         1IqvIYLVA8joq9Iv5ATCHncyOG/eSSKW8ogIDxrddL46I/YP0RQaSAbXmzGoG6yx8CHf
         8S/Hwoo7sX5TFibu6GoGLlcFN/gJoELVwFp22k4QwkZu8Naa79QKWwcUFwk7E2V0bm9I
         UzLpQ22zK9xtE0tPOeX1cw0aRG3mPeUYpiRbfCt/ZISKGFfblx2unVyjxm+zD17mC2/E
         T8qA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date;
        bh=fpIbF6pbywZ8+FIAm++uThbONT1NKKtEpu0wb7tvsjU=;
        b=bOl0Wbbsp/CAD+fta9Y726v0C+OSDLlytBE9zDh9aO2Cd5N6voTTi5pVXZoCztokNE
         et0G39aW7UxPpb9UUOXapcr9rUwUv5sXDNFDpMytvHizWGdZyvHSa9QrHo9MerlB14n/
         B1M5qfN9P5UXPWl6akEk2GKpXoPZsDSkp4RSFxWx6MSEcoXd58RsDc2eYx1aBl01cyoq
         STV6GHBPrk2pCbi9w8rEP4yKnEy1k4yYM/+eTTXPZLJKZhaV2LFbyxdiIEkiPsW/uGVD
         hm4rq/xOGrdl/j4A4/Io9cej3VhwRjaPhyJCG7kJJZ3vPzxqBmOI2/KcSNTf455cfHFv
         FZJQ==
X-Gm-Message-State: ACrzQf3KCXBL6xCZo/+w1FCoXOZbE2c3FB5mHOCqqaYjynMSz9dvG0XI
        O3ErvBE1No4DE7Z5Fw59GDkNYoUZDUm00uDVt1I=
X-Google-Smtp-Source: AMsMyM56hXZ0a/1F6ozw4yJnAvC9ByW53Qq5YCy46dVRPKXRX7xyOGzW0fQFreHolx6EoWqmc+PQ1w==
X-Received: by 2002:aa7:9851:0:b0:53e:87eb:1ffa with SMTP id n17-20020aa79851000000b0053e87eb1ffamr18813958pfq.35.1664113721257;
        Sun, 25 Sep 2022 06:48:41 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id lw4-20020a17090b180400b001df264610c4sm18773952pjb.0.2022.09.25.06.48.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Sep 2022 06:48:40 -0700 (PDT)
Message-ID: <63305c38.170a0220.f1085.c989@mx.google.com>
Date:   Sun, 25 Sep 2022 06:48:40 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.4
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.4.214-98-g7f3b89bc1956
Subject: stable-rc/queue/5.4 baseline: 70 runs,
 1 regressions (v5.4.214-98-g7f3b89bc1956)
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

stable-rc/queue/5.4 baseline: 70 runs, 1 regressions (v5.4.214-98-g7f3b89bc=
1956)

Regressions Summary
-------------------

platform      | arch | lab         | compiler | defconfig         | regress=
ions
--------------+------+-------------+----------+-------------------+--------=
----
at91sam9g20ek | arm  | lab-broonie | gcc-10   | at91_dt_defconfig | 1      =
    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.214-98-g7f3b89bc1956/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.214-98-g7f3b89bc1956
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      7f3b89bc1956eb2eea20bcf6141deda66d31d911 =



Test Regressions
---------------- =



platform      | arch | lab         | compiler | defconfig         | regress=
ions
--------------+------+-------------+----------+-------------------+--------=
----
at91sam9g20ek | arm  | lab-broonie | gcc-10   | at91_dt_defconfig | 1      =
    =


  Details:     https://kernelci.org/test/plan/id/6330293780c4cd198a35564c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: at91_dt_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.214-9=
8-g7f3b89bc1956/arm/at91_dt_defconfig/gcc-10/lab-broonie/baseline-at91sam9g=
20ek.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.214-9=
8-g7f3b89bc1956/arm/at91_dt_defconfig/gcc-10/lab-broonie/baseline-at91sam9g=
20ek.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6330293780c4cd198a355=
64d
        new failure (last pass: v5.4.214-94-g7fe758819cc6) =

 =20
