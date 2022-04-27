Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 056B2510FDD
	for <lists+stable@lfdr.de>; Wed, 27 Apr 2022 06:17:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351644AbiD0EUo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Apr 2022 00:20:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232216AbiD0EUn (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Apr 2022 00:20:43 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A43E82DAAA
        for <stable@vger.kernel.org>; Tue, 26 Apr 2022 21:17:33 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id j8so529810pll.11
        for <stable@vger.kernel.org>; Tue, 26 Apr 2022 21:17:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=mnAJkSLYFjWCkZnpnzIrtmA+Diy9mtBV+Bba7jCswOA=;
        b=EB2nCU/9FEtRFigJs1NGGWAscXi3eQhohTQlXI906KMm8ylipByQgHJp5/GHYbFM/6
         rXUNbDIHANjxZ32xPJ6iYKoejEh4oAbG/99pG/Ja0YVL3qtKzbPz4bzSbIG1sG0s1W69
         HrBOZtnrXhpDPmnEcVs1JAv7iS5G5CYx9R+Obu3EdUjd7SO7FoMUgd/lJYvIemAI0G7o
         Q4hhQLvKgXqFmCPzzEgb8EQkhUwYbNXsT0VZow4I+I2Sb6EIoWnlzb7/sK9NLbcipNex
         qXqZlDHeM19Tp/Og1I/IJw9s33bUHqLZWaNpRjB1X4C+JXp6b//JeOa1uxbjqem/sxl1
         /5JQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=mnAJkSLYFjWCkZnpnzIrtmA+Diy9mtBV+Bba7jCswOA=;
        b=5/JEg7aR0/wwKCg5cSU7GvkJAwW/xqR8cWOwP5hbdfMrDEIsa+dSVuCwRaLEw24Qhe
         M3rHEQUpSAiEEmzgT653xarfN5hZaL9dK4n3kM9WrAXuAPr1hWMfLk2s3TOywmDoVXeC
         RUoffnzb+F9kfFNTCoSKES+Og3eHQNQ0NhSANX4zxibn8LT4SPjm/xYlXqZcF07RccCc
         kIOqQ4cXtJwPgAFEDFlPFGWspCCPmKjWVinlaODgfJktg2osoWy8Tz6wu4jBrtSPnBpD
         xGb36OAtc6JU832ncyhYfVSFKPKsPxmnjwNF5cPLCgdH8iHwO3dI2yKs94g4PkDIWi3N
         I4jg==
X-Gm-Message-State: AOAM531s6qDQ77nPq3pQX8GkD+AsrVycx0ylvdEorg4QAYFlBipOI1+Y
        6TLJbyBt2crLDDKNnz3cApX1TLHcgZn/9f8oanw=
X-Google-Smtp-Source: ABdhPJxu1Edihndz4dPWiWhdN9GnksAz9LgTdgelHHVFqDurfo4NZsy6wF+DyaZL7Yv+ZQe7+seBkA==
X-Received: by 2002:a17:90b:4f8d:b0:1d9:7a0f:92f2 with SMTP id qe13-20020a17090b4f8d00b001d97a0f92f2mr15082193pjb.203.1651033053023;
        Tue, 26 Apr 2022 21:17:33 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id w8-20020a17090a380800b001d7d8b33121sm695182pjb.5.2022.04.26.21.17.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Apr 2022 21:17:32 -0700 (PDT)
Message-ID: <6268c3dc.1c69fb81.704bf.23e5@mx.google.com>
Date:   Tue, 26 Apr 2022 21:17:32 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.10.112-86-g1d7a19c2d43a6
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
Subject: stable-rc/queue/5.10 baseline: 95 runs,
 2 regressions (v5.10.112-86-g1d7a19c2d43a6)
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

stable-rc/queue/5.10 baseline: 95 runs, 2 regressions (v5.10.112-86-g1d7a19=
c2d43a6)

Regressions Summary
-------------------

platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
meson-g12b-a311d-khadas-vim3 | arm64 | lab-collabora | gcc-10   | defconfig=
                  | 1          =

rk3399-gru-kevin             | arm64 | lab-collabora | gcc-10   | defconfig=
+arm64-chromebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.112-86-g1d7a19c2d43a6/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.112-86-g1d7a19c2d43a6
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      1d7a19c2d43a677615c1b312a5dc5eed46817221 =



Test Regressions
---------------- =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
meson-g12b-a311d-khadas-vim3 | arm64 | lab-collabora | gcc-10   | defconfig=
                  | 1          =


  Details:     https://kernelci.org/test/plan/id/626890755b0742de72ff946a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.112=
-86-g1d7a19c2d43a6/arm64/defconfig/gcc-10/lab-collabora/baseline-meson-g12b=
-a311d-khadas-vim3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.112=
-86-g1d7a19c2d43a6/arm64/defconfig/gcc-10/lab-collabora/baseline-meson-g12b=
-a311d-khadas-vim3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220422.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/626890755b0742de72ff9=
46b
        new failure (last pass: v5.10.112-86-gee8f27e9c0bc3) =

 =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
rk3399-gru-kevin             | arm64 | lab-collabora | gcc-10   | defconfig=
+arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62688e30477684a366ff9463

  Results:     90 PASS, 2 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.112=
-86-g1d7a19c2d43a6/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/ba=
seline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.112=
-86-g1d7a19c2d43a6/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/ba=
seline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220422.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/62688e30477684a366ff9489
        failing since 50 days (last pass: v5.10.103-56-ge5a40f18f4ce, first=
 fail: v5.10.103-105-gf074cce6ae0d)

    2022-04-27T00:28:21.567133  <8>[   33.068173] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s0-probed RESULT=3Dpass>
    2022-04-27T00:28:22.593599  /lava-6184613/1/../bin/lava-test-case   =

 =20
