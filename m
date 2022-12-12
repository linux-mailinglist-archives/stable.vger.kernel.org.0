Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9680649D72
	for <lists+stable@lfdr.de>; Mon, 12 Dec 2022 12:22:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231274AbiLLLWE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Dec 2022 06:22:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232047AbiLLLVj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Dec 2022 06:21:39 -0500
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B8406423
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 03:19:52 -0800 (PST)
Received: by mail-pl1-x635.google.com with SMTP id jl24so11725555plb.8
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 03:19:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=u+Co1bYcpWm5Xt9KjWssEz/qm6WUyfERvbcoBMaaTOs=;
        b=K1xmStyLdV0445JQQCv2NOW7pWSXfgYJeS5yY+JFCka7WWmGT7QLonG5QgtJgsIqe5
         MQWoRWLAa+eq1/YwROEAA01M5VCjp/rsBRO1lWXmGAg6Z3jH8bQRwpmGprueT3N9VrXu
         lldMBbOZVJniPrS3lH71J3jxnY+P5PJi+EpSxhnZVl6wAdy/MbOzqVd31Z8OBpLfT5FY
         wMMwcp1lvRsHfC3sAiPVadLydt8A3kl5C5MVUMjasd31cg4q6bLIDBzvIwUj0jHWg5SL
         T1sbsPjGAI5stzrv5bnNd95isV4V540uh+VluOhximqlDMVTJMSWSwLSMQ5u2FlB4Huj
         rliA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=u+Co1bYcpWm5Xt9KjWssEz/qm6WUyfERvbcoBMaaTOs=;
        b=E3pjNXIrz7+jEjxP7V1vzNuvu2L9Bx5WCz0XVEkcvN7ZpTs3ZDjCj1ddsGr2LDQhRi
         RxkwsHiw6EBdnj0d0WK0V6PRxEcrVr9XfAIxi1E+pOoS5h3Gh2ORD9+ufsInLoGVGQeE
         A1NoJ7cWVHObBLnfRb7qCfWuB2xxtC/o9yXyONz7Zl/aGX4qiE42beTiryk6Q1RKf5l2
         gBxzalOGXtMhDOraMF3KCPKT/JoQOOYUH4BTs60gj7034f0FRNhC+HndWtPVZlncUmN1
         k62FAdhbXDU0MbXfRVbk4s0JLkbKaUgnG9Qxo/x5xrT7SiDbY1eOl3qJIVl0sX8iFP40
         hgBA==
X-Gm-Message-State: ANoB5pmYm4sHM5akVEgpiI2ED03eiVTRYJYhXZdNjfecuMJRygiENhxl
        Mf4+g/Lyln389MNNFuEzsHUk/rTThMn4c/HpGuTqqQ==
X-Google-Smtp-Source: AA0mqf6nlQ+i4o7/BlDeQ6LMsk85Uazeb6jQntAKbrUGzkoOXpP0jX+uNDZxltm5VJbW9O7AoJf4fA==
X-Received: by 2002:a17:902:8b81:b0:185:441e:2d78 with SMTP id ay1-20020a1709028b8100b00185441e2d78mr14743438plb.15.1670843991508;
        Mon, 12 Dec 2022 03:19:51 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id i13-20020a170902c94d00b00186c54188b4sm6106729pla.240.2022.12.12.03.19.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Dec 2022 03:19:51 -0800 (PST)
Message-ID: <63970e57.170a0220.2df88.a3b4@mx.google.com>
Date:   Mon, 12 Dec 2022 03:19:51 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.15
X-Kernelci-Kernel: v5.15.82-123-ga18620558296
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.15 baseline: 164 runs,
 1 regressions (v5.15.82-123-ga18620558296)
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

stable-rc/queue/5.15 baseline: 164 runs, 1 regressions (v5.15.82-123-ga1862=
0558296)

Regressions Summary
-------------------

platform      | arch | lab         | compiler | defconfig         | regress=
ions
--------------+------+-------------+----------+-------------------+--------=
----
at91sam9g20ek | arm  | lab-broonie | gcc-10   | at91_dt_defconfig | 1      =
    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.82-123-ga18620558296/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.82-123-ga18620558296
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      a186205582966304683bacf8f2d4ea086361d071 =



Test Regressions
---------------- =



platform      | arch | lab         | compiler | defconfig         | regress=
ions
--------------+------+-------------+----------+-------------------+--------=
----
at91sam9g20ek | arm  | lab-broonie | gcc-10   | at91_dt_defconfig | 1      =
    =


  Details:     https://kernelci.org/test/plan/id/6396d7ce8086519e282abd41

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: at91_dt_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.82-=
123-ga18620558296/arm/at91_dt_defconfig/gcc-10/lab-broonie/baseline-at91sam=
9g20ek.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.82-=
123-ga18620558296/arm/at91_dt_defconfig/gcc-10/lab-broonie/baseline-at91sam=
9g20ek.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221125.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6396d7ce8086519e282ab=
d42
        new failure (last pass: v5.15.82-59-g9be27e947448) =

 =20
