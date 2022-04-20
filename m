Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 219EA50895C
	for <lists+stable@lfdr.de>; Wed, 20 Apr 2022 15:30:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379105AbiDTNcs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Apr 2022 09:32:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354157AbiDTNcq (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 Apr 2022 09:32:46 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDEFF2188
        for <stable@vger.kernel.org>; Wed, 20 Apr 2022 06:29:59 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id b7so1789593plh.2
        for <stable@vger.kernel.org>; Wed, 20 Apr 2022 06:29:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=qNiIFeofs3nCUaXP1vPkyCm6inJgjZAzx00HV0mvSs8=;
        b=GfUomD1432wGayRHQIjCwVQ+ayck4VZr9TLA97kYOzfIEw1Od3alLc8xxJbbNVzMPv
         Y9UW9QfeShidN7+Ue2Q86Jsu37fVfVum2uJNshMgP7/ykoGPAaUurUCAOgeEEmAlDNAd
         YcpS/f7Hj9djZX7sHQK2yKtaC0qozCOGCCTAmHH6izZFTwQNoSoagmisoTQR30LYZB0s
         twFnuXQl+sygL60ax/blcnoNH/XE0VgRmvwt1OgUxPIx8YuOy3UAHkX8VBfyyvC+nOxQ
         UWgN07c0cal+Twa1ddRDx9kOzqzxOYAwQKIF9m47MQpeAdQOqDoP4i2m3fFSf3enyikF
         5h2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=qNiIFeofs3nCUaXP1vPkyCm6inJgjZAzx00HV0mvSs8=;
        b=c0d07+IrkgcQJftAurEwrz1S8pdjHtMrBDo21UIZe+0v1B52envwc65LOh/DOKuPC8
         O7mHNLlEmoglfxipMvum4jZnFinuY4uoL3Bzw48irBunFf20/pwmz0DnLkj3D72G5FXA
         XRXiR6cfQIVdW/aLL0wBEAPQaDWe85lJAcEuTkTzokDN6gmX2hiu9eGDJPTkqH+ykafA
         eGSa/lSZMk1UhJvA4Ql1qlVassrUSzx01CD2DsdjjsRWzyCDr3c3pT1k3fvrgu6UOViB
         QcUjDfB2TqDwSBPGeMt3l2+gMX0SgdSS0jvDP20/bAb3RCRWrxIRv/JaUVcTAqiQXlkQ
         FwTw==
X-Gm-Message-State: AOAM531gxhsS6hDR4YID9nCqGjsytbWJ+oqUcVBaM68alRSV/iAmhXHa
        3O1vCkX5BqtzYNeJojBDj5u6mGEc4SkHOqRT
X-Google-Smtp-Source: ABdhPJyEpVAX9Iox5YMZPXsBpkM99HVIoFBsBeF3B7i/MlhD1WaR4hd+Ai0Zl4BQD7JK9x5V4OFFPw==
X-Received: by 2002:a17:902:ca85:b0:158:e8e0:373 with SMTP id v5-20020a170902ca8500b00158e8e00373mr19948950pld.85.1650461399160;
        Wed, 20 Apr 2022 06:29:59 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id k10-20020a056a00168a00b004f7e2a550ccsm21091381pfc.78.2022.04.20.06.29.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Apr 2022 06:29:58 -0700 (PDT)
Message-ID: <62600ad6.1c69fb81.ba455.0df5@mx.google.com>
Date:   Wed, 20 Apr 2022 06:29:58 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.14
X-Kernelci-Kernel: v4.14.275-284-gaffa61742bba
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.14 baseline: 96 runs,
 3 regressions (v4.14.275-284-gaffa61742bba)
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

stable-rc/queue/4.14 baseline: 96 runs, 3 regressions (v4.14.275-284-gaffa6=
1742bba)

Regressions Summary
-------------------

platform                     | arch  | lab          | compiler | defconfig =
         | regressions
-----------------------------+-------+--------------+----------+-----------=
---------+------------
meson-gxl-s905d-p230         | arm64 | lab-baylibre | gcc-10   | defconfig =
         | 1          =

meson-gxl-s905x-libretech-cc | arm64 | lab-broonie  | gcc-10   | defconfig =
         | 1          =

meson8b-odroidc1             | arm   | lab-baylibre | gcc-10   | multi_v7_d=
efconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.275-284-gaffa61742bba/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.275-284-gaffa61742bba
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      affa61742bbaa15f4396f45f53f1d7d36e2afcec =



Test Regressions
---------------- =



platform                     | arch  | lab          | compiler | defconfig =
         | regressions
-----------------------------+-------+--------------+----------+-----------=
---------+------------
meson-gxl-s905d-p230         | arm64 | lab-baylibre | gcc-10   | defconfig =
         | 1          =


  Details:     https://kernelci.org/test/plan/id/625fd930f67e24d539ae0691

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.275=
-284-gaffa61742bba/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxl-s=
905d-p230.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.275=
-284-gaffa61742bba/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxl-s=
905d-p230.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220411.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/625fd930f67e24d539ae0=
692
        failing since 14 days (last pass: v4.14.271-23-g28704797a540, first=
 fail: v4.14.275-206-gfa920f352ff15) =

 =



platform                     | arch  | lab          | compiler | defconfig =
         | regressions
-----------------------------+-------+--------------+----------+-----------=
---------+------------
meson-gxl-s905x-libretech-cc | arm64 | lab-broonie  | gcc-10   | defconfig =
         | 1          =


  Details:     https://kernelci.org/test/plan/id/625fd8b55e6039907eae068b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.275=
-284-gaffa61742bba/arm64/defconfig/gcc-10/lab-broonie/baseline-meson-gxl-s9=
05x-libretech-cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.275=
-284-gaffa61742bba/arm64/defconfig/gcc-10/lab-broonie/baseline-meson-gxl-s9=
05x-libretech-cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220411.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/625fd8b55e6039907eae0=
68c
        failing since 1 day (last pass: v4.14.275-277-gda5c0b6bebbb1, first=
 fail: v4.14.275-284-gdf8ec5b4383b9) =

 =



platform                     | arch  | lab          | compiler | defconfig =
         | regressions
-----------------------------+-------+--------------+----------+-----------=
---------+------------
meson8b-odroidc1             | arm   | lab-baylibre | gcc-10   | multi_v7_d=
efconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/625fd939c623e0647cae06cd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.275=
-284-gaffa61742bba/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-meso=
n8b-odroidc1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.275=
-284-gaffa61742bba/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-meso=
n8b-odroidc1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220411.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/625fd939c623e0647cae0=
6ce
        failing since 66 days (last pass: v4.14.266-18-g18b83990eba9, first=
 fail: v4.14.266-28-g7d44cfe0255d) =

 =20
