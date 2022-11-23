Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2AD1B634FE6
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 07:00:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229479AbiKWGA0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 01:00:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229471AbiKWGAZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 01:00:25 -0500
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E545F2433
        for <stable@vger.kernel.org>; Tue, 22 Nov 2022 22:00:24 -0800 (PST)
Received: by mail-pl1-x62d.google.com with SMTP id io19so15732886plb.8
        for <stable@vger.kernel.org>; Tue, 22 Nov 2022 22:00:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=HbeVeRVMsuUDNb87tmOjAAb4ax21K9XCtzzebt3+b/c=;
        b=IA7jYCO+jsPTUKw6Ifl5XepPFq4dVmvv9SxyqFer/EaN23j8fOLw54OI5rQeyIdiOk
         egksHxjuzpXQf8tOpT6gNURFf0xsDnbTZsYdOutwZVhf7bDdStoh/aW35pJLhX7azYph
         MYoc4kxj3YE2JVrp2owdJZTaTyjLvvq7uPePv7GnetAmf38UyOku3KfZIr9Yg8giqLpi
         jCQE0OMPCfGSSIgwQByg313HTyNxHTO0IfxOjBDtpXPya2AtoK5NlpFeoeIAv1e9CJyz
         4r4d7nqpNrZ+ViaIvyDAgYH4AX9FAGedjsDnxlvWNLxiKKulpPbjN2wVdye1xbMgjzJu
         CJaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HbeVeRVMsuUDNb87tmOjAAb4ax21K9XCtzzebt3+b/c=;
        b=zJJMwa0ZL1A863U/y1eMoloB237R+QBobLMzXQ6UXq+cCeXmwO8z1JviTIRwid+C6c
         GL+xHZXJo1dHF7b50iAzx6i/IbgAjXKWHLKYjlOX5Ek1wnm0XV6e5t8RsEk/B52svW0d
         +ytZThFoLzzx4QPzHhq6ogfd3XjcYTJ/jfJxNcD0VLFg+PebymEC6Xu0UkAYRKvShlIV
         QFvftuz/6F28+kJ3X1cr04ubUq7ber2ulEOyV1ETdxhRGdxGEUC1fnNBesqdzrn1dhIQ
         r9yupTy4+Ho484oSMCMnjYHc55zAej2q+EzYo4aK4Kk+9FLXlVQZbBZn53KZZjX3Vazv
         +RrA==
X-Gm-Message-State: ANoB5pmdtqxBFVdM4xEeKbxFMRs0ZCltkBIHqo7CTjhgXhLHVtHJuw7g
        CjZfi7yTsKxQhDLuRZvzSCsiUHy8SuU+oWBAjLM=
X-Google-Smtp-Source: AA0mqf5MWFUAQFug64eKy+pP40JKpcNwiFhJm9ocjK1Y6ch2GY21o+RXI0ZSkMrNDr3HDqqQKY5nwA==
X-Received: by 2002:a17:902:ced1:b0:179:ee31:1527 with SMTP id d17-20020a170902ced100b00179ee311527mr20446358plg.138.1669183223504;
        Tue, 22 Nov 2022 22:00:23 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id d15-20020a63d70f000000b0047781f8ac17sm3868551pgg.77.2022.11.22.22.00.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Nov 2022 22:00:22 -0800 (PST)
Message-ID: <637db6f6.630a0220.324ee.68da@mx.google.com>
Date:   Tue, 22 Nov 2022 22:00:22 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.15
X-Kernelci-Kernel: v5.15.79-167-gdc4538c14814
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.15 baseline: 139 runs,
 2 regressions (v5.15.79-167-gdc4538c14814)
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

stable-rc/queue/5.15 baseline: 139 runs, 2 regressions (v5.15.79-167-gdc453=
8c14814)

Regressions Summary
-------------------

platform    | arch | lab     | compiler | defconfig           | regressions
------------+------+---------+----------+---------------------+------------
imx7ulp-evk | arm  | lab-nxp | gcc-10   | imx_v6_v7_defconfig | 1          =

imx7ulp-evk | arm  | lab-nxp | gcc-10   | multi_v7_defconfig  | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.79-167-gdc4538c14814/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.79-167-gdc4538c14814
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      dc4538c1481407b95cd29c58f82e6d6e25a4dd06 =



Test Regressions
---------------- =



platform    | arch | lab     | compiler | defconfig           | regressions
------------+------+---------+----------+---------------------+------------
imx7ulp-evk | arm  | lab-nxp | gcc-10   | imx_v6_v7_defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/637d84e8d8e9befeaf2abd24

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.79-=
167-gdc4538c14814/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-e=
vk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.79-=
167-gdc4538c14814/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-e=
vk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221107.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/637d84e8d8e9befeaf2ab=
d25
        failing since 58 days (last pass: v5.15.70-117-g5ae36aa8ead6e, firs=
t fail: v5.15.70-133-gbad831d5b9cf) =

 =



platform    | arch | lab     | compiler | defconfig           | regressions
------------+------+---------+----------+---------------------+------------
imx7ulp-evk | arm  | lab-nxp | gcc-10   | multi_v7_defconfig  | 1          =


  Details:     https://kernelci.org/test/plan/id/637d8998882a56a7152abd43

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.79-=
167-gdc4538c14814/arm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-ev=
k.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.79-=
167-gdc4538c14814/arm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-ev=
k.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221107.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/637d8998882a56a7152ab=
d44
        failing since 58 days (last pass: v5.15.69-44-g09c929d3da79, first =
fail: v5.15.70-123-gaf951c1b9b36) =

 =20
