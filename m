Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B0C04F5B90
	for <lists+stable@lfdr.de>; Wed,  6 Apr 2022 12:43:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343970AbiDFJrA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Apr 2022 05:47:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230499AbiDFJpb (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Apr 2022 05:45:31 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BF4D2D4BFD
        for <stable@vger.kernel.org>; Tue,  5 Apr 2022 23:21:29 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id s8so1558082pfk.12
        for <stable@vger.kernel.org>; Tue, 05 Apr 2022 23:21:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=OfyT+g/V1YyxY4uHlhAS5taoFDiFOfI5ji0k8kBl2VA=;
        b=DhElyTw7lnwDoJGxIyKav4sL70WHPYjnTxAW6l3DHI6vOFwPUm4CJ2kWT1EP6lEzsE
         3HoRYDC8UFZplT+JxJQrDynuzcYhqUCNI5nloYt9IjNAe18VbOYpE1TBU278ZnpXMdw4
         4ROi1yq6SmuL593uZHtKAF5GUivAm7sHjbxy2FlFt5h+LYatvJXZLsa7+AdfnKHmuKVQ
         IOY/xX2JHCjXSId52VI24DAYKKiJmVZg4QYJa9Me9lNQLq4TEbcr7Ue/hsFB0tvSH9wf
         O4b8laDriNnI31ten8h/TFgqT/sm6KmPcVj2gij8gDdTleewrlhY1OHia3L2Bx4ljW82
         D3RA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=OfyT+g/V1YyxY4uHlhAS5taoFDiFOfI5ji0k8kBl2VA=;
        b=eeJ3oLR5BbuNPJMT8sRyDoxcsmlOvgcSfX7Lptgbl5+Y8LFbhVOWqyeEYwfwO3T2hr
         +20Ug3pVqeRy7cufq7RTfS3Lfp0MKciHFV/MxGhANVos52qesxb8artSUMaTbmFv9ozj
         /b4TFwiWyIquaN1cumamxxQcBMTRu3ZqxyNBWIw5A7P/U0cmQFizuGtxDqgoZsyG/Rnc
         PU4w3SKpsKm/3M1Lc6rcaodRF0ioC+32Du+qVzrgFbalfbEn51/DcuP9XFcFKTClUnHn
         oVI5nEp7/rtwpNCVeIB1wyk5Co0NXLpSfznv212Sm8xJc7+1jzA1OdbFPYbmOmoc1GJR
         aa8g==
X-Gm-Message-State: AOAM5331D1cnlkf4mA4mXc1mJlEwUdehK8MmWUIEfosxV2FXSQn6nQVv
        3Gu5q7Z6PB7n2Ra8AaikaMWwAPncPcjxJH/8JhE=
X-Google-Smtp-Source: ABdhPJxmCwcU9yUBunZn4aBqEdbNsAn17todBoUQUmu6yGkSYBoeOD2WlW19IGZraxJzOGcAcTfvGw==
X-Received: by 2002:a63:5712:0:b0:399:28f1:3c76 with SMTP id l18-20020a635712000000b0039928f13c76mr5972091pgb.129.1649226088619;
        Tue, 05 Apr 2022 23:21:28 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id v22-20020a056a00149600b004fb34a7b500sm18150371pfu.203.2022.04.05.23.21.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Apr 2022 23:21:28 -0700 (PDT)
Message-ID: <624d3168.1c69fb81.5b1bc.0c6a@mx.google.com>
Date:   Tue, 05 Apr 2022 23:21:28 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.16
X-Kernelci-Kernel: v5.16.18-1016-g8de50cd02f41
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.16 baseline: 27 runs,
 2 regressions (v5.16.18-1016-g8de50cd02f41)
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

stable-rc/queue/5.16 baseline: 27 runs, 2 regressions (v5.16.18-1016-g8de50=
cd02f41)

Regressions Summary
-------------------

platform             | arch   | lab           | compiler | defconfig       =
             | regressions
---------------------+--------+---------------+----------+-----------------=
-------------+------------
hp-x360-14-G1-sona   | x86_64 | lab-collabora | gcc-10   | x86_64_defcon...=
6-chromebook | 1          =

meson-gxl-s905d-p230 | arm64  | lab-baylibre  | gcc-10   | defconfig       =
             | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.16/ker=
nel/v5.16.18-1016-g8de50cd02f41/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.16
  Describe: v5.16.18-1016-g8de50cd02f41
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      8de50cd02f413a5d86b6545dbd6d721598c41638 =



Test Regressions
---------------- =



platform             | arch   | lab           | compiler | defconfig       =
             | regressions
---------------------+--------+---------------+----------+-----------------=
-------------+------------
hp-x360-14-G1-sona   | x86_64 | lab-collabora | gcc-10   | x86_64_defcon...=
6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/624d0212cab66218a8ae06ba

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.16/v5.16.18-=
1016-g8de50cd02f41/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-14-G1-sona.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.16/v5.16.18-=
1016-g8de50cd02f41/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-14-G1-sona.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220401.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/624d0212cab66218a8ae0=
6bb
        new failure (last pass: v5.16.18-1017-g8271dc6b9d2e) =

 =



platform             | arch   | lab           | compiler | defconfig       =
             | regressions
---------------------+--------+---------------+----------+-----------------=
-------------+------------
meson-gxl-s905d-p230 | arm64  | lab-baylibre  | gcc-10   | defconfig       =
             | 1          =


  Details:     https://kernelci.org/test/plan/id/624cff39807f24b8aaae06ab

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.16/v5.16.18-=
1016-g8de50cd02f41/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxl-s=
905d-p230.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.16/v5.16.18-=
1016-g8de50cd02f41/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxl-s=
905d-p230.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220401.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/624cff39807f24b8aaae0=
6ac
        new failure (last pass: v5.16.14-112-gba4f1fffbebe) =

 =20
