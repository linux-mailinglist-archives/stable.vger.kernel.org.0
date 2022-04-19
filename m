Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8DE985077CB
	for <lists+stable@lfdr.de>; Tue, 19 Apr 2022 20:24:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356983AbiDSSZZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Apr 2022 14:25:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357677AbiDSSXk (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Apr 2022 14:23:40 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 163E244A29
        for <stable@vger.kernel.org>; Tue, 19 Apr 2022 11:16:47 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id md20-20020a17090b23d400b001cb70ef790dso2610502pjb.5
        for <stable@vger.kernel.org>; Tue, 19 Apr 2022 11:16:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=slpds5BEOLUXg5xQp9CrGvp5GyAh6MsJI8GdABDnfZU=;
        b=tcDT92fcZXruHpy5ajJViWUxv9MNSeZ18IwfxETOT/iZr+EiGjepBg3LT73ydk534C
         4HlPeCNyqLmUFflAOoKA+yfkW/U/QigPmQDBRgnVM7vcbLUVdAujJKUxeWc8k8LiCAqA
         iAu1GPQEiShHgETZOd9BfJMuV/k1N6RiWaHPqZbPhFvfdBxitg4kGJM6wjm7Y6iNW9lF
         cVEcK4v7kG+WLC9wm7MZF3OGFfd59cze8wS3hCW4l4vROFafY4aFg9uf9tbcGqGtKmMa
         IZGDlP3oY/yztVVCJ/CmWeyfgmReIQHCm02/rPTe/QJetk2SKDufq0rt2YrS4BPuInUn
         Y2cA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=slpds5BEOLUXg5xQp9CrGvp5GyAh6MsJI8GdABDnfZU=;
        b=envDmlrsj5aj/3fUT4Cyvk/Yg31bLji8B37bPLaUQrjfr0/bvMI5kf1uUCE019QAWG
         rMSy1kA4DOM4xz0KDXP4qCBgJZoz+4D7ackDb3Fuf6fcWGLeX43fU0R29GKg/DljqBpm
         hytbxe0h7HyW3cJvjvjPRTZgiM4jG69zmxn6Num7SpPDqYXdbTRQndrP79ABj5XGekdr
         R75FlRIyg8Kl4r1h/lfRsQIB3dBVPKvutd76GmeA0QhgwFQkspyQRV3vBasnXaIgt9xW
         jOOE4QEmvVzh2jsp42wOxVlhHeuWie/xuTPu2Rn5s8TWX5JbJnf/w+0HD3DwL/yt3kxe
         8qNA==
X-Gm-Message-State: AOAM531ozeReKQcyE0v6eeMt8XlE4x5GkfKeLPgQrsdkH2q3j8hqIXi7
        v4+z3aANlvSQIzfBqKRMhJyzrfujjPz73Fcs
X-Google-Smtp-Source: ABdhPJyZ8adpsvjh1Eqw0iMFH578eBDXCWRdwAimIIeQHkqj2lkjy6nVwLz/x9KPc83WB/4oVwk6Gw==
X-Received: by 2002:a17:903:22d2:b0:159:606:e620 with SMTP id y18-20020a17090322d200b001590606e620mr8864062plg.59.1650392206189;
        Tue, 19 Apr 2022 11:16:46 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id d8-20020a056a0024c800b0050a7505da43sm9520260pfv.16.2022.04.19.11.16.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Apr 2022 11:16:45 -0700 (PDT)
Message-ID: <625efc8d.1c69fb81.4a51.5023@mx.google.com>
Date:   Tue, 19 Apr 2022 11:16:45 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.15
X-Kernelci-Kernel: v5.15.34-188-g7f09f15af3c1
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.15 baseline: 90 runs,
 1 regressions (v5.15.34-188-g7f09f15af3c1)
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

stable-rc/queue/5.15 baseline: 90 runs, 1 regressions (v5.15.34-188-g7f09f1=
5af3c1)

Regressions Summary
-------------------

platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.34-188-g7f09f15af3c1/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.34-188-g7f09f15af3c1
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      7f09f15af3c13a970110e8944ab8b4801e33a37b =



Test Regressions
---------------- =



platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/625ec9b2161b646478ae0683

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.34-=
188-g7f09f15af3c1/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beag=
le-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.34-=
188-g7f09f15af3c1/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beag=
le-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220411.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/625ec9b2161b646478ae0=
684
        failing since 19 days (last pass: v5.15.31-2-g57d4301e22c2, first f=
ail: v5.15.31-3-g4ae45332eb9c) =

 =20
