Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C7464E7951
	for <lists+stable@lfdr.de>; Fri, 25 Mar 2022 17:51:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243818AbiCYQx2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Mar 2022 12:53:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241225AbiCYQx2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Mar 2022 12:53:28 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 324EBC12C2
        for <stable@vger.kernel.org>; Fri, 25 Mar 2022 09:51:54 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id e5so8650621pls.4
        for <stable@vger.kernel.org>; Fri, 25 Mar 2022 09:51:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=2OC32vrdlL1mw+md4tu4jMvfnorKto3fI0cPOT18nl0=;
        b=72fvoyWad70Ibf59u8V3E5sLFoCY00L+AqrbaKgc9mOTVfyCb0/riXzC43fT3IACaz
         tbHvkENpQ36vXnVQOhWlU1+m1g9p8nT9+ccorLRcTuScVTkRlV7IhSMXtC51v2GGeb+H
         CiSYoE7BfyZBaU4CrCyyTYAPbOsL5ChPEUG1ktq3nyFIC6fKTFAMVcbWt26t2WORn3cf
         owrvT2/4M401+j1kNZXx1QhuNFzVXYXdYFe0p8gT0W6rgUyz/naT7VDFG+QByuVuXK2W
         JjlVZpN2N3pGkoeBiVtRhWVDmnR1npWLVD4HY2Pow7tdUAil4fsC3nDPv7guDsOfaW3g
         U8wA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=2OC32vrdlL1mw+md4tu4jMvfnorKto3fI0cPOT18nl0=;
        b=Wpqoa53UJN/KiL3/0rEK1OUYZE5s47ZuvoWtiEYC8f13FODw7+2qsCP3Qq/MbNtiHP
         wDhvdyr/5nx+yiJGf78ugyFXS6uGnzUXVvYvtTjuPGyLoQbFj5M6i2XjQ/iyO3mqKaWH
         Ncxq23uDLtuIjuMnAB4xnKRTYmtvzsDH6BortIyaviQqf1kDlhKXRuUdea+xMmxdip5X
         F/gBEKC2A0+nj9EyI9kKrNXGAK7lTu4KMSDtAQZou1pHVM6blOll3RV2i1mdDlD4zz9o
         mycLtuq4F6piRnvMqozWSRfDAdcfmjnJwHXWME627tGUR+yLM1wDvdeaE3q45E4WZB3/
         NSdg==
X-Gm-Message-State: AOAM532fwqxSiXlsUiaBr1iCoaFIWmPbxHXe1oD93AviIf2hS1aNImoW
        r1hxaVWnb1WKKMiCjFR0aeQzA39ZSqvDgDy6YBM=
X-Google-Smtp-Source: ABdhPJxEd5SutqMKg5+nc0viQ8ivtA1/F5gFme5DAM7y80lb+WHDHHvKGwWojod2rctqIr31XJheUQ==
X-Received: by 2002:a17:902:d4c8:b0:154:2416:218b with SMTP id o8-20020a170902d4c800b001542416218bmr12708205plg.139.1648227113566;
        Fri, 25 Mar 2022 09:51:53 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id ot17-20020a17090b3b5100b001c746bfba10sm14765434pjb.35.2022.03.25.09.51.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Mar 2022 09:51:53 -0700 (PDT)
Message-ID: <623df329.1c69fb81.8c388.813e@mx.google.com>
Date:   Fri, 25 Mar 2022 09:51:53 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.19
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.19.236-4-gc2c5e0567619
Subject: stable-rc/queue/4.19 baseline: 60 runs,
 1 regressions (v4.19.236-4-gc2c5e0567619)
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

stable-rc/queue/4.19 baseline: 60 runs, 1 regressions (v4.19.236-4-gc2c5e05=
67619)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.236-4-gc2c5e0567619/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.236-4-gc2c5e0567619
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      c2c5e05676197bcddde6a1f6ab39ad3d2eb19172 =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/623cc7956531b27639772513

  Results:     83 PASS, 7 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.236=
-4-gc2c5e0567619/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/base=
line-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.236=
-4-gc2c5e0567619/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/base=
line-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/623cc7956531b27639772535
        failing since 18 days (last pass: v4.19.232-31-g5cf846953aa2, first=
 fail: v4.19.232-44-gfd65e02206f4)

    2022-03-24T19:33:22.746476  <8>[   35.942088] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s0-probed RESULT=3Dpass>
    2022-03-24T19:33:23.762075  /lava-5942156/1/../bin/lava-test-case   =

 =20
