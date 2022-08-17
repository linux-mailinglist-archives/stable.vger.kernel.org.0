Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE65659786B
	for <lists+stable@lfdr.de>; Wed, 17 Aug 2022 23:00:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242057AbiHQU7W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Aug 2022 16:59:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242150AbiHQU7P (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 17 Aug 2022 16:59:15 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D0FFAB05A
        for <stable@vger.kernel.org>; Wed, 17 Aug 2022 13:59:14 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id h28so13028276pfq.11
        for <stable@vger.kernel.org>; Wed, 17 Aug 2022 13:59:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc;
        bh=MzW8fksQpwbGPq3aOm3fMcdYEeU2dgUwIvzZdu5+J7c=;
        b=jSimuqiTu5Jmg1QNepWrCIeymFG/5iIplOPvM3CIfvzzRSogxguwMvlzLHhmy1E0oP
         0UyKatSAseP7YtT8cPgJIA38daeqVZ+KCKb6Pn4X2s1vTS1HUCT/Jx4kMw3ZCyn9E+PQ
         4H64HyuKnw0skxoOU/ZS3Ps3z/ELB43xV1PpHByF1CSLbs6nGX/yccdqaphDT1wt3PDq
         GnKMHYdJ9evqWvG1UcGlgRhI78bd8pJrCZC0X5UJk1tdwhVgYpzQPP4XYKnELPLO49zu
         iUQ4QnYI+iXJYMxTb6uEZn5NOvWDAq/6ZDyB58f/ydDf2DtTeKp9e0DIw6XQcJL0qSqk
         Z+7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc;
        bh=MzW8fksQpwbGPq3aOm3fMcdYEeU2dgUwIvzZdu5+J7c=;
        b=pwOr69cfpFxkcq5nv1WBnA5m1jusZdv05F+EoLknW/luOaaCi6FcnPzQQWkijqPqmU
         UUMX0wFEQXfRNw2k0+RnHVxTaqEgFyzqD699RCC8VdsQhsE56A3BGA7euYSeSbcI3FfY
         4KCN4CkJpICOL2kprG6PeALb2AMn5nkG1+fAVi9XvDfcVV1F5Wk+A0wyEUehwODrfGd3
         Q7bcS/Efno0PocfTQ/PPyjb1hx5RvDISGKVNaBcDq+5TznrD4kTK79l8LC4BxoaJ/L3K
         LFWLGFh9GmmwSFYwXac49bBMZDOQttPx74ekEA65nL+UVnDI4v+GliIv+X0+YoQ761FI
         lEFQ==
X-Gm-Message-State: ACgBeo2/2AYYa/UfDyJ5x7nadNV+zxR9P24OiVObWjYXcCGnoYwbATPI
        0bt8pVb3ZLifjhqn11r+eQjLjjakBM0RqjYZ
X-Google-Smtp-Source: AA6agR7pTUR0GKP1EF/1fzwMdV46HklrE7JzkjMpwoFKEVuNEJcFlPI5kvR3F5dlQF1+DVDrhcIGkw==
X-Received: by 2002:a05:6a00:1a49:b0:528:6ea0:14e2 with SMTP id h9-20020a056a001a4900b005286ea014e2mr8554pfv.22.1660769953783;
        Wed, 17 Aug 2022 13:59:13 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id p16-20020a1709027ed000b0016c1e006b63sm372195plb.64.2022.08.17.13.59.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Aug 2022 13:59:13 -0700 (PDT)
Message-ID: <62fd56a1.170a0220.b21f7.1442@mx.google.com>
Date:   Wed, 17 Aug 2022 13:59:13 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.19.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.19.2
Subject: stable-rc/linux-5.19.y baseline: 113 runs, 1 regressions (v5.19.2)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.19.y baseline: 113 runs, 1 regressions (v5.19.2)

Regressions Summary
-------------------

platform          | arch  | lab           | compiler | defconfig | regressi=
ons
------------------+-------+---------------+----------+-----------+---------=
---
rk3399-rock-pi-4b | arm64 | lab-collabora | gcc-10   | defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.19.y/ker=
nel/v5.19.2/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.19.y
  Describe: v5.19.2
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      d49914ee4ec93d58d90a12275a814415c189059c =



Test Regressions
---------------- =



platform          | arch  | lab           | compiler | defconfig | regressi=
ons
------------------+-------+---------------+----------+-----------+---------=
---
rk3399-rock-pi-4b | arm64 | lab-collabora | gcc-10   | defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/62fd259a13ff35e45c35564d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.19.y/v5.19.2=
/arm64/defconfig/gcc-10/lab-collabora/baseline-rk3399-rock-pi-4b.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.19.y/v5.19.2=
/arm64/defconfig/gcc-10/lab-collabora/baseline-rk3399-rock-pi-4b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fd259a13ff35e45c355=
64e
        new failure (last pass: v5.19.1-1158-g6078b149fc3d1) =

 =20
