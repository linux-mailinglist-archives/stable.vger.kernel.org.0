Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE2BD45471A
	for <lists+stable@lfdr.de>; Wed, 17 Nov 2021 14:23:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237295AbhKQNY5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Nov 2021 08:24:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232163AbhKQNY5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 17 Nov 2021 08:24:57 -0500
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7E08C061570
        for <stable@vger.kernel.org>; Wed, 17 Nov 2021 05:21:58 -0800 (PST)
Received: by mail-pl1-x62c.google.com with SMTP id y7so2206469plp.0
        for <stable@vger.kernel.org>; Wed, 17 Nov 2021 05:21:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=SuORaKSdBJffakVqsCnHYubtMkjWuYvnV1hLvZYELrc=;
        b=kmOGMeFIi4G7k0y11CBYRpeFIzwF/krtJucn30ojLk5WUaT7v0hM+ghMJNt5RFZg6/
         q0u906+NSk95Bg62GBT7sFfuwAn/ury/mGj0pBG2pxs96ByHmYuJISEqY+OMRW2H3cKM
         Z53SpeiUOzsWsk2Ibvu6/rUtYdavXSl//gj/3hmuqH0jCMIRY898mAtv07SuwOe3MdEo
         xTcohSryFcRkSZKze1SqV26zWMUmP0GDS2tGsbw9JNRdUXxP+I+rZoVZSc6JhYA/lZ8I
         0FsECRwgPhVDE4eoChkutTRIcHU7weUgDPm8/6qFb1i3UhGcYqmVti6YTVgwzrvm88dI
         L67w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=SuORaKSdBJffakVqsCnHYubtMkjWuYvnV1hLvZYELrc=;
        b=Sv3LrbhNDQVttovxS8ILOKHqpsHXxZ2zaO3hsP3hk4WEPgCyyx7INVsobF3QY25XZS
         IOx5MEO/ChbsYIdNbnml0WEW9Rdy3AbHHtARMDiTS0qSrZc9IPF5LJrxT0oABNDsLF1Q
         W/ZA/RIbZnQBiPxbfuLuZXnHVxtoq9pSHGT5tjek/ARMMNxBkHd0Yq48T1DHO473VJ67
         goz0mQjFJCb+8j79FbEH6HunRM2Y6YFGelwVXa7WOxQJV6lqE0bSpTNOkzmoEi2TDPUQ
         4Dzr5Fc+TRG7swnc+tFTyRanUpq0VU7dPHVCFXUvj1HJzjZibGD050WbqQSHljjdDnzL
         wFiQ==
X-Gm-Message-State: AOAM533kHhFRJgHQ6IR3+rsIZR34m6h3hSfN52KRKw8HdLtb1BYQ30XB
        aJawj5NNLvmlDPKZ1uokvr49eQVrP3UkeMez
X-Google-Smtp-Source: ABdhPJzPxTjfw/hLJfx6uO9gKN1ggQjxK9YwPrYA8uR+CFZiMqcA+T8Vx8xifIZwKBROgdIPb9jWVA==
X-Received: by 2002:a17:903:22c5:b0:142:3100:65af with SMTP id y5-20020a17090322c500b00142310065afmr56356870plg.83.1637155318223;
        Wed, 17 Nov 2021 05:21:58 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id v25sm5966262pfg.175.2021.11.17.05.21.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Nov 2021 05:21:57 -0800 (PST)
Message-ID: <619501f5.1c69fb81.67151.fe08@mx.google.com>
Date:   Wed, 17 Nov 2021 05:21:57 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.14
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.14.18-857-g84b711efd17f
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.14 baseline: 147 runs,
 1 regressions (v5.14.18-857-g84b711efd17f)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.14 baseline: 147 runs, 1 regressions (v5.14.18-857-g84b71=
1efd17f)

Regressions Summary
-------------------

platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.14/ker=
nel/v5.14.18-857-g84b711efd17f/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.14
  Describe: v5.14.18-857-g84b711efd17f
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      84b711efd17f9effc97ba1cbccf27cb168db762e =



Test Regressions
---------------- =



platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/6194cc9b09e5ee98553358e4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.18-=
857-g84b711efd17f/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beag=
le-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.18-=
857-g84b711efd17f/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beag=
le-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6194cc9b09e5ee9855335=
8e5
        failing since 23 days (last pass: v5.14.14-64-gb66eb77f69e4, first =
fail: v5.14.14-124-g710e5bbf51e3) =

 =20
