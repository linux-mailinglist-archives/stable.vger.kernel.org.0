Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C68145B8CBD
	for <lists+stable@lfdr.de>; Wed, 14 Sep 2022 18:20:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229665AbiINQUN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Sep 2022 12:20:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229533AbiINQUM (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Sep 2022 12:20:12 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3AF075381
        for <stable@vger.kernel.org>; Wed, 14 Sep 2022 09:20:10 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id jm11so15600241plb.13
        for <stable@vger.kernel.org>; Wed, 14 Sep 2022 09:20:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date;
        bh=o3I9M00bSAohBZZGXiU2XNdmCfJaK9P8KzV2o3/lims=;
        b=ZzR0eVjnI09ZDP/EjefTTO+HhIE6INiACK8VvS+WbCXNCP0obw6Us+Pms/Ze8eaAR7
         7bP24YP0GQa8XdaUk/fUyS4r/mip3rllCtJLXL1O55oO44CmfDo9pw9EVjboTh4j/UUn
         lnrGkcnSjfjQi1EJH4n+tS0gaiV6c3tRlrdoZeUvi8MbIovBqWyueBovXp+JPMaWEGNT
         PW9MlJayzaOKM1PdiOWYWVEROq7A80BsCqOkI3Ve7TbdpDHNzWey3Dc/SETqj/1oDoV8
         1CsfxO+EKHJb6kusc4eb1thUTYpZtN36nKmrQ67jTi7lezXTqI7+6HnLQTsclXGj9h3Q
         C7XQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date;
        bh=o3I9M00bSAohBZZGXiU2XNdmCfJaK9P8KzV2o3/lims=;
        b=K+xatpzeOtReHrs8WeVlG92E+zYZCEAMk9x3EULc8otU3GDhU/TUXV8p3vzJ6FbduS
         vg+Nv7xf97HLmZWyLxpvv/xvKoXbAGOKSyhXmntqRwGLn49852X/220AdvlIOIAGOSMt
         a/3l+Ma8gDETaRwwh/xe6ISfOrqDX0Sx+a5xRYKFAMnCYOJBOTvTk1At3rZSvB/Z3afz
         dEDq0d3LYR5t4pf3iqAcaBXFYSJDD2PSu/o1bn4R7fqyQMDb5fShIFr4l+YwqgEpdKhH
         L+mNzQAgcnKZW96exBnamF0UTHgvrt9MOAF9P2wmmi7cIfpc2T5J2/K8kA1+zk/XBeeL
         ekxw==
X-Gm-Message-State: ACgBeo3r6osmjZ6L3LRQOo9P1sG0hjrZpaBX8xi8XMeP+w79lEl5NToF
        iHsKpwKG+f5czX57dEB9qmEmCcRc0vKgYtBYD6U=
X-Google-Smtp-Source: AA6agR71Yqx5lskvMHnoWYwtA6z+scRTiIaKIbX5kTOhTSxqcFcaO/LOgqSfU9mkZUs15BK8e53sQQ==
X-Received: by 2002:a17:902:bc84:b0:174:505b:2d67 with SMTP id bb4-20020a170902bc8400b00174505b2d67mr37156436plb.33.1663172410068;
        Wed, 14 Sep 2022 09:20:10 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id l7-20020a170903120700b0017312bfca95sm11071654plh.253.2022.09.14.09.20.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Sep 2022 09:20:09 -0700 (PDT)
Message-ID: <6321ff39.170a0220.c2974.2ffb@mx.google.com>
Date:   Wed, 14 Sep 2022 09:20:09 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.15
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.15.66-119-g781f01e9677c
Subject: stable-rc/queue/5.15 baseline: 147 runs,
 1 regressions (v5.15.66-119-g781f01e9677c)
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

stable-rc/queue/5.15 baseline: 147 runs, 1 regressions (v5.15.66-119-g781f0=
1e9677c)

Regressions Summary
-------------------

platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.66-119-g781f01e9677c/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.66-119-g781f01e9677c
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      781f01e9677c4a35c6bdc680f6da97cb0c43f7d8 =



Test Regressions
---------------- =



platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/6321bc9daa9a7f2e73355656

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.66-=
119-g781f01e9677c/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beag=
le-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.66-=
119-g781f01e9677c/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beag=
le-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6321bc9daa9a7f2e73355=
657
        failing since 167 days (last pass: v5.15.31-2-g57d4301e22c2, first =
fail: v5.15.31-3-g4ae45332eb9c) =

 =20
