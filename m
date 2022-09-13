Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B487E5B7BD2
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 22:00:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229989AbiIMT7w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 15:59:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229994AbiIMT7E (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 15:59:04 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A55E786FC
        for <stable@vger.kernel.org>; Tue, 13 Sep 2022 12:58:50 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id t65so12335724pgt.2
        for <stable@vger.kernel.org>; Tue, 13 Sep 2022 12:58:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date;
        bh=HzAQt3DGbDPsvlwJ7O3jtBTQiSahaBI47xWU6kdYcSc=;
        b=TxbvwMG0SurPwzMJzxZObM/mFupeYyVB8ehcKVvivorfLJeCLHt1oqDiEE0BcV1t1D
         o+5LYbH4bU/Kuxy/ZaAqpZs4bdNZSUTxqPWsJ6D5aLdZwIs8H9dYN8hG6jsrQJfxmgdx
         iaaaE3MMZNFHn7peVOTmEEwUdMWM0svVZ8VAWlJkH4ti2b+T2PZkbeJwVJNdAK7wi/YL
         9QZHTCpLy6o4UG6OUMEWCg6PfGd9gihbA94Rsw955bZWHar+FdISpDxmEDSNYiGNVchJ
         38u189r/Mnl5pVsvJ25FeZbyuZE33FM7pYrNp6ekPw5CcVO5wwETNQQdqE3eRXsfC0k1
         IHPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date;
        bh=HzAQt3DGbDPsvlwJ7O3jtBTQiSahaBI47xWU6kdYcSc=;
        b=eSMiMPkpX6nCWRJIvHUcJrGr+G122kbi4UNvASq4sdqeqHRKLRRA8qMC21Ll1q4o82
         Yyx+U3S0OaONWKgKlX5okgPS6uhO3M3RNiA3PH67AvWClnCiamDw44ohNITOOoQ6ViGl
         ElKjwOlL6d9N6/vKPM5wFYFJnvKYlBzd819qt8mo/ctlxquBrrQj6IlEmw26vnACOUNh
         zPd0k6+jUG+ITg8NxRAR0pm2jCGg9lFJGUel8vvzNLO5Qhqetu8ZRzYq4hTcaUYiEYct
         TO8Qs7G82KyEySs/SQJjuHKqDe+aHN7xipBJv42/SASKwkN1kWoGdDZ/sPXyPgfCxE9v
         Kucw==
X-Gm-Message-State: ACgBeo3TQxIAWRbG4+jbW+bYKGQvs09cOvSwIy707iKoMRTj25c4fGaT
        ZDdq7bZy7zzp4GAHsxm71WQ7nhKA/QUAeevnBLA=
X-Google-Smtp-Source: AA6agR6tPK4SW5vxQWhD49joH6T4hkIYGnungEitrxmUu3jeYoV6XS57khvnwRpDCGnFaJsLiSw/fA==
X-Received: by 2002:a05:6a00:26d1:b0:53e:1d86:bead with SMTP id p17-20020a056a0026d100b0053e1d86beadmr34500317pfw.26.1663099129132;
        Tue, 13 Sep 2022 12:58:49 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id i7-20020a170902c94700b001728ac8af94sm8926162pla.248.2022.09.13.12.58.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Sep 2022 12:58:48 -0700 (PDT)
Message-ID: <6320e0f8.170a0220.6360f.f7a1@mx.google.com>
Date:   Tue, 13 Sep 2022 12:58:48 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.15
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.15.66-121-gb3f0d61067d1e
Subject: stable-rc/queue/5.15 baseline: 173 runs,
 1 regressions (v5.15.66-121-gb3f0d61067d1e)
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

stable-rc/queue/5.15 baseline: 173 runs, 1 regressions (v5.15.66-121-gb3f0d=
61067d1e)

Regressions Summary
-------------------

platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.66-121-gb3f0d61067d1e/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.66-121-gb3f0d61067d1e
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      b3f0d61067d1eb1fd43964666efb988a46c0f7ce =



Test Regressions
---------------- =



platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/6320b132d62ccf14d635567b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.66-=
121-gb3f0d61067d1e/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-bea=
gle-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.66-=
121-gb3f0d61067d1e/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-bea=
gle-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6320b132d62ccf14d6355=
67c
        failing since 166 days (last pass: v5.15.31-2-g57d4301e22c2, first =
fail: v5.15.31-3-g4ae45332eb9c) =

 =20
