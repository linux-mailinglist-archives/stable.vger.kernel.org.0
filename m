Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0AD715292FB
	for <lists+stable@lfdr.de>; Mon, 16 May 2022 23:38:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347356AbiEPVi1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 May 2022 17:38:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235197AbiEPViX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 May 2022 17:38:23 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F005419B1
        for <stable@vger.kernel.org>; Mon, 16 May 2022 14:38:23 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id d25so15177783pfo.10
        for <stable@vger.kernel.org>; Mon, 16 May 2022 14:38:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=1+zNp3nZSwe9ZwgAuYbC+ZYnkoxZDWaEl1cNlhVQD78=;
        b=vmQdBglhBJCgs9KLCXp4xv95KkOBH4mez2IAZcjXAU5Sr2BGJMLI6lOAj5IQyNWDIV
         rh9aI7BMKS4M6//1yu9ajTERUdkvcVNYQzldhBjCS0JQ+vKouolV4frMq5SCjTVamLcH
         j7eJKqLw0jknusyVT1IfpSCa7vBVBoIJ6J7fdQCOA6qIOyXdkwFtSbIP9KGJrtuqBe65
         NFVx+uOZCuEkIhuX1be/KBvSMWxEyta9wVjrgWwV8k+6quG4iZng4NtwE2rvDNDeytte
         j41fDGHtYNUM0NAVcuw6fjCiJIwAJhdim26xVBh9NLkSed6EGLC1CJhEvf1OXjLjkdRu
         7/Qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=1+zNp3nZSwe9ZwgAuYbC+ZYnkoxZDWaEl1cNlhVQD78=;
        b=QugzqqrXn+A/ccbDLnoS9qOP7eyQqQdkVvZF/jY0APiU2jhreGLenkLSeTfBV4/yIV
         Yv2ewVdeNSSPym5IJuGluEzbSH1/bznyahtMe4kxHtISqlqFYfQQGNi4pFnQiWxoxzrh
         Fr8VmacolrHZt6PaU71mNg1JUaTDQLB1nMiuXl3NUYeUIwvL9H1j8rYB3JhxXGXI+NKd
         Dl3qcUPuIHmD8xqG7M9ZZexIYtSqKgefQRhTnE/Qc+r4k3+2RrwuzoOQ39cKmnqXnj5E
         gFaBe3fo9vb1RNtX2vYcSljYCvgZjSqzso1sRSc1Tnqf7X8FER+meUa/gNxdKFLXja5L
         LTtw==
X-Gm-Message-State: AOAM530cfmNt7F3HXMCW8n4kH+2xqerTPAy0wiWHEaDbzrsqAEbTX36W
        uOTlfswVo7E/KSno8G3QLD331Rbn1HYwIwzzCNc=
X-Google-Smtp-Source: ABdhPJxFTUxY5OItZfoKEqhINqsIZB/zXyuUi92kBhggODo5/0DwLZ6teVFJi/GPXRZZ+JV8vmhWfg==
X-Received: by 2002:a63:f205:0:b0:3f2:7e19:28bc with SMTP id v5-20020a63f205000000b003f27e1928bcmr3607222pgh.291.1652737102559;
        Mon, 16 May 2022 14:38:22 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id e11-20020a17090a9a8b00b001df4c27e5a5sm149942pjp.35.2022.05.16.14.38.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 May 2022 14:38:21 -0700 (PDT)
Message-ID: <6282c44d.1c69fb81.6a436.0a44@mx.google.com>
Date:   Mon, 16 May 2022 14:38:21 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.15.y
X-Kernelci-Kernel: v5.15.40-101-gcbfc4f42bd5f
Subject: stable-rc/linux-5.15.y baseline: 119 runs,
 2 regressions (v5.15.40-101-gcbfc4f42bd5f)
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

stable-rc/linux-5.15.y baseline: 119 runs, 2 regressions (v5.15.40-101-gcbf=
c4f42bd5f)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
beagle-xm        | arm   | lab-baylibre  | gcc-10   | omap2plus_defconfig  =
      | 1          =

rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.15.y/ker=
nel/v5.15.40-101-gcbfc4f42bd5f/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.15.y
  Describe: v5.15.40-101-gcbfc4f42bd5f
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      cbfc4f42bd5fbf033342ee467c5614254167e3a8 =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
beagle-xm        | arm   | lab-baylibre  | gcc-10   | omap2plus_defconfig  =
      | 1          =


  Details:     https://kernelci.org/test/plan/id/62829314eef5f0aa1d8f5743

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.4=
0-101-gcbfc4f42bd5f/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-be=
agle-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.4=
0-101-gcbfc4f42bd5f/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-be=
agle-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220513.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62829314eef5f0aa1d8f5=
744
        failing since 4 days (last pass: v5.15.37-259-gab77581473a3, first =
fail: v5.15.39) =

 =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62829ce26069e8f73f8f5718

  Results:     88 PASS, 4 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.4=
0-101-gcbfc4f42bd5f/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/b=
aseline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.4=
0-101-gcbfc4f42bd5f/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/b=
aseline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220513.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/62829ce26069e8f73f8f573a
        failing since 69 days (last pass: v5.15.26, first fail: v5.15.26-25=
8-g7b9aacd770fa)

    2022-05-16T18:49:45.178558  /lava-6393658/1/../bin/lava-test-case
    2022-05-16T18:49:45.189437  <8>[   33.326920] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s1-probed RESULT=3Dfail>   =

 =20
