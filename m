Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82AAF50E580
	for <lists+stable@lfdr.de>; Mon, 25 Apr 2022 18:22:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237107AbiDYQZY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Apr 2022 12:25:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236656AbiDYQZY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 Apr 2022 12:25:24 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9BC271A06
        for <stable@vger.kernel.org>; Mon, 25 Apr 2022 09:22:19 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id t13so1606834pfg.2
        for <stable@vger.kernel.org>; Mon, 25 Apr 2022 09:22:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=PqdMST9ihLPxfMD1GXRHSwQH+7j5Z8BHkJtaI97bKTM=;
        b=1YmuPH6afMsEqlYL2AyZJWHZ2hKDoxkNJ3yAvfXoyZBhD/A0f5CSYItqUbxx34c3fU
         Sh1yYbOQHMK1GkHTSvN655kXlvvLWK2qtXq9gHF6dpMJQv3I9wKKdYeEZabSpmWkR94G
         5oHE/wsn+aYIQoMDlyEEcrWz+v61KG0LKQz68PnbfXXMSp1nQRL+Eacn6H+2Nvi53rfr
         Kf+YVSjMboiHkDFOHspuFdAr0z8Q+gbr2yVcAKVuupA9ZGkzaYvamWhN0e6AiFuFzIcI
         3keiztbonzCK8pc2L2rE0WMF30tdVm09SoYTGfcIrZSKyXZ9+MZqKVJC2gNLFxhhfrWA
         msaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=PqdMST9ihLPxfMD1GXRHSwQH+7j5Z8BHkJtaI97bKTM=;
        b=qsxxk9IPbUmSg9IG39/cn4CF4dKUZpvEd26nAF2i8ZZmSlZunneqTkRq/AhidcZEt5
         RTMdfD51Pidmz2mElqFat0xb3g81QAQDDipTKTslkuPWgo+eHkmlF8YxlrP/K2xOEFf7
         OvxslsOFlmlpKrIveo09UICzgG0fSTp+1wGvn8yFuXQLvIsZR8EqI+Umh4OU1NSn78fi
         1LB0sC5jetq6TXJlTpFid2FMDbCaCQnvtzR4vzloaMecOGHA+GQo8E51LCBU2F1RtYgE
         8i2o39Kq1pHvzLA2eDR6KvAnSpH4VyrkVqos2bSk7dzrGh9JjtJMTCjJaLWbOdUznygb
         dg6w==
X-Gm-Message-State: AOAM531wGTK3We0uOzSqKuGrNo/6GRbF0ybbBb6DrDQgH3ccadx+9UHK
        QQOOUAj+ggxkWBvn5t1CP7knVu6L49W65Kwd8+s=
X-Google-Smtp-Source: ABdhPJwpnSSg3VEbhIEyNrVTxrynMZgx/R3aOEpGxEME7x42uNCZZu6Jl906zd10QqTDeretg3XcXg==
X-Received: by 2002:a63:82c3:0:b0:3ab:674:c5ce with SMTP id w186-20020a6382c3000000b003ab0674c5cemr8898596pgd.209.1650903739132;
        Mon, 25 Apr 2022 09:22:19 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id c11-20020a056a000acb00b004f35ee129bbsm13291229pfl.140.2022.04.25.09.22.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Apr 2022 09:22:18 -0700 (PDT)
Message-ID: <6266caba.1c69fb81.a3c0b.f1e6@mx.google.com>
Date:   Mon, 25 Apr 2022 09:22:18 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.15.35-119-g4fff198d225d
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.15
Subject: stable-rc/queue/5.15 baseline: 111 runs,
 2 regressions (v5.15.35-119-g4fff198d225d)
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

stable-rc/queue/5.15 baseline: 111 runs, 2 regressions (v5.15.35-119-g4fff1=
98d225d)

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.35-119-g4fff198d225d/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.35-119-g4fff198d225d
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      4fff198d225da41fb38f2e2cabfc880c9415e728 =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
beagle-xm        | arm   | lab-baylibre  | gcc-10   | omap2plus_defconfig  =
      | 1          =


  Details:     https://kernelci.org/test/plan/id/62669a774d9dae9f88ff9463

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.35-=
119-g4fff198d225d/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beag=
le-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.35-=
119-g4fff198d225d/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beag=
le-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220422.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62669a784d9dae9f88ff9=
464
        failing since 25 days (last pass: v5.15.31-2-g57d4301e22c2, first f=
ail: v5.15.31-3-g4ae45332eb9c) =

 =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6266987d9b014eb30cff94c1

  Results:     88 PASS, 4 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.35-=
119-g4fff198d225d/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.35-=
119-g4fff198d225d/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220422.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/6266987d9b014eb30cff94e7
        failing since 48 days (last pass: v5.15.26-42-gc89c0807b943, first =
fail: v5.15.26-257-g2b9a22cd5eb8)

    2022-04-25T12:47:44.113729  /lava-6170524/1/../bin/lava-test-case   =

 =20
