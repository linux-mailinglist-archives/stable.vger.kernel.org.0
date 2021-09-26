Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D551A418ADB
	for <lists+stable@lfdr.de>; Sun, 26 Sep 2021 21:59:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229932AbhIZUBb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 26 Sep 2021 16:01:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229894AbhIZUBb (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 26 Sep 2021 16:01:31 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E875C061570
        for <stable@vger.kernel.org>; Sun, 26 Sep 2021 12:59:54 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id g184so15728357pgc.6
        for <stable@vger.kernel.org>; Sun, 26 Sep 2021 12:59:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=IWTOPigb72pqiqPjsz339Exv76FUFU52fJukljddLcI=;
        b=uPddBj4vlU+tmj2eDzSP7ZblRfHgLEIn1GBIzlE4FByk5yfdMTXYhTNpzE8gjwVzWJ
         g6PN/1Vqpdly6SBxOTR7Bm4qkh+lYfoGHfGSvBVpo7Sg5LJac6vPwaSZFd2zX7lDIUnH
         ITiDDLiuT1ozAgdQgWc5jIEirqJulQYV4Hw1Mlo45W8TBGlWz/Ytt2YiAPc52+ldL1rd
         Er1RBCuCJMVyhERWB0y6a1AM9eDqBRHGxPMheY/ouXGZ5pfemmsFxpFUlCaUvNXhio/H
         f+MpjrdRFbPEGu3InAG1tZioqjRurcMv1zBvketBKAqncr/QjAVgBO2GfiMnpqFKYn4y
         Cq+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=IWTOPigb72pqiqPjsz339Exv76FUFU52fJukljddLcI=;
        b=rAFmr92XQqPRm+P5GAmhc/87Nee7WJ8Hiu4pCQ1Oi1zZ6uDnT/sJU5CvaO5uB3rQdx
         Aq6Q6l/KLYCazSh/YltCwWScgWfIdQDjUEbHeDwrjdCaBilr7BDcuEwYYGdKoRUyxQkN
         IZ3oicNV1cWGftnGRU0JLwYfNbM0I/ZtXBc2MaejNn0Y2Jw/Uh1YI1WK9dYSYbxqRWTu
         /+yKI3dqRkeYo6t3H38SdSbkiYeeXEl5OhiLUZLu2Z6AV4pEyZiQhkLVQ2h76sslxTmf
         OYcBYPhQu/mwxY2XSZimj1FxxKqGrriCT0qrW2rF+82JwCozxjWZBUH4l2tOCeGhGzOg
         eN2A==
X-Gm-Message-State: AOAM531D6YI4LJQka2P9ZWKq2VZZx8LBPwd7kAiYelHthMVGiagf42kU
        OlWz65BzdOTnkA0YpMuJItraWz9nuxU/2gqJ
X-Google-Smtp-Source: ABdhPJyc+ssBaRsXU+RsLgcCgDesxJ/NJYePMrLlQdLLkUEbWKoJ4LRV/EnXn2xbmBa6GyPBH8CoaQ==
X-Received: by 2002:a63:1e0e:: with SMTP id e14mr13434529pge.5.1632686393855;
        Sun, 26 Sep 2021 12:59:53 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id l142sm15176243pfd.87.2021.09.26.12.59.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Sep 2021 12:59:53 -0700 (PDT)
Message-ID: <6150d139.1c69fb81.81c59.148e@mx.google.com>
Date:   Sun, 26 Sep 2021 12:59:53 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.4.148-74-g7312d6dd38d8
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.4
Subject: stable-rc/queue/5.4 baseline: 51 runs,
 3 regressions (v5.4.148-74-g7312d6dd38d8)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 51 runs, 3 regressions (v5.4.148-74-g7312d6dd=
38d8)

Regressions Summary
-------------------

platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
rk3288-veyron-jaq | arm  | lab-collabora | gcc-8    | multi_v7_defconfig | =
3          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.148-74-g7312d6dd38d8/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.148-74-g7312d6dd38d8
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      7312d6dd38d8ee30f6b3085ff47cb0df7f2b6a88 =



Test Regressions
---------------- =



platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
rk3288-veyron-jaq | arm  | lab-collabora | gcc-8    | multi_v7_defconfig | =
3          =


  Details:     https://kernelci.org/test/plan/id/61509399959c257e7499a2f3

  Results:     67 PASS, 3 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.148-7=
4-g7312d6dd38d8/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-=
veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.148-7=
4-g7312d6dd38d8/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-=
veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/61509399959c257e7499a307
        failing since 103 days (last pass: v5.4.125-37-g7cda316475cf, first=
 fail: v5.4.125-84-g411d62eda127)

    2021-09-26T15:36:40.773261  /lava-4585503/1/../bin/lava-test-case
    2021-09-26T15:36:40.790470  <8>[   14.894182] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/61509399959c257e7499a31e
        failing since 103 days (last pass: v5.4.125-37-g7cda316475cf, first=
 fail: v5.4.125-84-g411d62eda127)

    2021-09-26T15:36:39.367457  /lava-4585503/1/../bin/lava-test-case<8>[  =
 13.469215] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Ddwmmc_rockchip-sdio0-probe=
d RESULT=3Dfail>
    2021-09-26T15:36:39.368096  =

    2021-09-26T15:36:39.368550  /lava-4585503/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/61509399959c257e7499a31f
        failing since 103 days (last pass: v5.4.125-37-g7cda316475cf, first=
 fail: v5.4.125-84-g411d62eda127)

    2021-09-26T15:36:38.329419  /lava-4585503/1/../bin/lava-test-case
    2021-09-26T15:36:38.335131  <8>[   12.449560] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =

 =20
