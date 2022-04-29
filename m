Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7382E5158AD
	for <lists+stable@lfdr.de>; Sat, 30 Apr 2022 00:49:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381616AbiD2WxM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 Apr 2022 18:53:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381606AbiD2WxL (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 29 Apr 2022 18:53:11 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B167EAD136
        for <stable@vger.kernel.org>; Fri, 29 Apr 2022 15:49:52 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id u7so8316994plg.13
        for <stable@vger.kernel.org>; Fri, 29 Apr 2022 15:49:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Vc/c1ZGyu519pyzc9h5bjCWhKh0Xcya2h1sd4VYRcTs=;
        b=NXrCMOfW/c7Xs19dm60rHje/iBkL9BI7qI1trve+UwZNkL2mPI1NBbs6lb0ZL/mCKJ
         osAZ8XrZSldUjFT6q0j1cQJWj7OkEO91LB2/nmOaJdf0jgn/1eYhKYebAGCmKy1zMzOh
         V87N2cwccdNeBqN4CQcaOhTqjFZUNoLdKKlujS/Gblibu8hVIF268WU6dfA7ONnhL7+s
         28ZdSt76NtZSQGs20HFKK+esQRgH4VL48/xSVEhC77jb5NmnbQAUeudiL+wO4CsVWtwx
         /PkY6alhYKngRDrdh8iUZcRwKs+zqAEUiL7iZ+9h9HOeVUCXqqJZIjKdPusQ6TF/rM7A
         bHHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Vc/c1ZGyu519pyzc9h5bjCWhKh0Xcya2h1sd4VYRcTs=;
        b=x58v0rv8hHz17N56f9dgNrsuf4yw6zYiERoQnL62E4i78+4iczdtLgqbczr50CnYFT
         RMuqWMrr4fpAO7b/iWITt8WGa6j8E+/b8yp1azBpdY7Z69nt2MT21Z2J/fST81oJNgDO
         JdT96ilDtg7sTujRegP042zMk1lZPGXY6KqV/dxvaaDgjFwBOo2BUmlCgZtgVo7JtvQ/
         BUdPD7ShEMjiUjXd4wr2CWObApkN1h/96zDi9UUOWhJz/WFHbXpNUKXelVPLDkLdCvcr
         aIn1b8XjPcWeyHzQg5eIsIm2GhpIxZ3u7mZFP5ULfRmu9Mx5eC4ECVyMfNFDr/XzTGmk
         mEag==
X-Gm-Message-State: AOAM533P232/8gqqyjllPbxx7TiDXsQTyWoiQZB8NQYge0vlNEN6f4NM
        GRO+D8roVKVB4w3qHe1y3W8ai5ktNQqtm4gfnjY=
X-Google-Smtp-Source: ABdhPJx/bNQcmWzuQHfbkV8Q9Wx14uatNJ3Nu0ayHwsWo4J/r3gSnS8i+Wo3g8gC92o8QOLRI3RBEg==
X-Received: by 2002:a17:90b:4a09:b0:1d2:de49:9be8 with SMTP id kk9-20020a17090b4a0900b001d2de499be8mr6412817pjb.68.1651272591974;
        Fri, 29 Apr 2022 15:49:51 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id i13-20020aa78d8d000000b0050dc762814asm198601pfr.36.2022.04.29.15.49.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Apr 2022 15:49:51 -0700 (PDT)
Message-ID: <626c6b8f.1c69fb81.5d030.0b2d@mx.google.com>
Date:   Fri, 29 Apr 2022 15:49:51 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.15
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.15.36-33-gac4ad2a1b856
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.15 baseline: 71 runs,
 1 regressions (v5.15.36-33-gac4ad2a1b856)
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

stable-rc/queue/5.15 baseline: 71 runs, 1 regressions (v5.15.36-33-gac4ad2a=
1b856)

Regressions Summary
-------------------

platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.36-33-gac4ad2a1b856/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.36-33-gac4ad2a1b856
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      ac4ad2a1b85653cfd8fd08726c90d29fd37f94c7 =



Test Regressions
---------------- =



platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/626c388ffead5a91e4bf6028

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.36-=
33-gac4ad2a1b856/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagl=
e-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.36-=
33-gac4ad2a1b856/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagl=
e-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220422.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/626c388ffead5a91e4bf6=
029
        failing since 29 days (last pass: v5.15.31-2-g57d4301e22c2, first f=
ail: v5.15.31-3-g4ae45332eb9c) =

 =20
