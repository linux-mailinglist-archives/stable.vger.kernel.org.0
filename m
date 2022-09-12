Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6694E5B6330
	for <lists+stable@lfdr.de>; Mon, 12 Sep 2022 23:58:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230140AbiILV6N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Sep 2022 17:58:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230024AbiILV6K (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Sep 2022 17:58:10 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC0F44DB53
        for <stable@vger.kernel.org>; Mon, 12 Sep 2022 14:58:06 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id p18so9857284plr.8
        for <stable@vger.kernel.org>; Mon, 12 Sep 2022 14:58:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date;
        bh=QjUmXG61Kh+yK0Dsye7ZwrYo8Ld1zPyhGlRUOx3KvLk=;
        b=FP1R5+5coWMdAgwd/PyF8mYBzRLf1UPrNUHRYUBrcyFqP4FG9XlpdJyPgtJzI+al4r
         Y0ToSVY7HinOxXaGrK38ixnSX3rDWhPKIoDntOlP9jw6fyOi4w23keuXNJ8i6oEXHu6Y
         7j+Set2pvyRkB5wu4iFZKLOz/13+b6cgNIuxn+ZNutxvZFzxrn8gv3PR0hG5YF914Wiu
         NmtULS3zAGlQ0ZSH8xhRvknTNxJuzWniNo19Wy9VzJmEe8ZmjhFrpw5c6KdYk6wgyJGJ
         XiuOuGOexnwixH6V5RZTlOoZZAtPZskn8uWR/NLSmPfpN1RwjgMU6RiLo38mhk3MF0hz
         OPkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date;
        bh=QjUmXG61Kh+yK0Dsye7ZwrYo8Ld1zPyhGlRUOx3KvLk=;
        b=eImbuBhUnChuu/3URnXHU7ZpCO6JXWvhlnjtS1a95TkPAgVqa4AAOtETF88cMAKX8w
         4IUUSHf0w+et47em4bEDwN065MQLLGKf/KVqr/pp9uvGouobeH63/WbYYHPCWUp1uyIg
         Hxncvx0LkH/2YvCUwY6RCEfrv9qZdmZWRGPk1Kt/JoXqGteOURHFfJVd3ix7uXad10aJ
         v24VLsDtB/f2ZOH7MYBXlGtCWg/v8sMxhcjk/hrd5of0L6wbcsC+i0SxSobqpUIP6ASz
         74ZV7y92F+kxcXQ7vykH0Pb61ugSpEjjTOSVtiEoNZnp1Q+gyAt9pQqUfPYfeXmU+UPg
         Tx3g==
X-Gm-Message-State: ACgBeo2hJ1BRK1/FhkaAmxhnez5EqC1fU/Cl/rS6dJn9FOnZ4qPLtd6+
        N8Nu7GBOvSJvzK0Q/utiNzlXZiK37/DI2b0t8mM=
X-Google-Smtp-Source: AA6agR4NDMqekSVtFQFWmYlvblJCnKFPXPxxmQIXwrLINKGodqfaMY3yh+7wBkepEKz++lRC/T+73A==
X-Received: by 2002:a17:902:9a92:b0:178:2580:ce60 with SMTP id w18-20020a1709029a9200b001782580ce60mr11134114plp.80.1663019885961;
        Mon, 12 Sep 2022 14:58:05 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b9-20020a170902d40900b0016bedcced2fsm6571538ple.35.2022.09.12.14.58.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Sep 2022 14:58:05 -0700 (PDT)
Message-ID: <631fab6d.170a0220.724ea.b5bd@mx.google.com>
Date:   Mon, 12 Sep 2022 14:58:05 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.15
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.15.66-118-gf0924adc11b92
Subject: stable-rc/queue/5.15 baseline: 139 runs,
 1 regressions (v5.15.66-118-gf0924adc11b92)
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

stable-rc/queue/5.15 baseline: 139 runs, 1 regressions (v5.15.66-118-gf0924=
adc11b92)

Regressions Summary
-------------------

platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.66-118-gf0924adc11b92/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.66-118-gf0924adc11b92
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      f0924adc11b92ecfd6294c22887cc0cd1f515df4 =



Test Regressions
---------------- =



platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/631f78c8ed6b59c11b355642

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.66-=
118-gf0924adc11b92/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-bea=
gle-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.66-=
118-gf0924adc11b92/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-bea=
gle-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/631f78c8ed6b59c11b355=
643
        failing since 165 days (last pass: v5.15.31-2-g57d4301e22c2, first =
fail: v5.15.31-3-g4ae45332eb9c) =

 =20
