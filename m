Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D27D7541FFC
	for <lists+stable@lfdr.de>; Wed,  8 Jun 2022 02:18:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1388479AbiFHAE5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 20:04:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1388670AbiFGWwL (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 18:52:11 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C27192C8597
        for <stable@vger.kernel.org>; Tue,  7 Jun 2022 12:46:07 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id bo5so16404443pfb.4
        for <stable@vger.kernel.org>; Tue, 07 Jun 2022 12:46:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=5cqyIOVjyKhSdVV0ZrkOiz/8G3fV4JxMSunIafe5Tmg=;
        b=l27NJh4LY4iZTTFbpRoy2cnFw5imi/eFH/qH994X9egqH+jcRc0xeKnsF8ih8Soluc
         jmn0DqC8hUxioRmV8Chf8E+3AmuPCeL72o4WxwBrFjNGQP7eOQIi1eqItXFLMY1U9ofJ
         GlKrX+EZhORNPdUpTJnr2R2pLFGfb3myiAjdTCG6ScHhN9z6p/NGAvsKcmVYMD9WOksU
         TPahuKovDVi1nXC7sacpErq5BLlAve3WJHPg1jgSbw/ShoHeCC+xW+4my62oXvohVu6L
         S0rhdj/p3pNLmgMxqrx+y9M9+McX18A8VP+pDiRal5aL5MlOU3TYMG4qpAaaAio4GhTv
         FZOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=5cqyIOVjyKhSdVV0ZrkOiz/8G3fV4JxMSunIafe5Tmg=;
        b=M5LLLAjN/E0eTkxAwnaGvdqVDsr67czSdriT5LIRuFuXE/1Tf7VCH3CDirfQxKN4XS
         wl8oik2Tx4UZTudQ6UuTZi6P5E7cdTZbUVw35avEJ8vimmcC92Nrok3fGk6dom+rP7sD
         3012zw//NZ2/76RdkWC3ekSfYtKlCupZsKQJX52jtzSRnJP3wZm36xE/dPu1saAfj8CJ
         s2CNrtEMKQIkyJTjJ/tAHPbn7L1OE5Mh9txoj5AIesNThsmpYbXwdSmEVFjI5VzIOjhb
         Yt6JtAnb8oDhLOLuSDPycCsUElz4NwB5uQqq+lAcudWRUg5v5S0B31y7c4ikbui4YUY3
         pu9g==
X-Gm-Message-State: AOAM531y7BoowDcgVluL4wU8MoS75o7X2rtXD7np6b3lzItMos5aoJ9m
        ZB9UFOxTDCdM1pOP/KNYduT0UtFEiz+NIFgwPY0=
X-Google-Smtp-Source: ABdhPJw6VIZRGXit9A2bkqeLYSnpoH2zGI2HpCD9Rlwh+7ADC50DozfjTOsDHfjJ9H7iMeUWBjpAuw==
X-Received: by 2002:a65:6cc9:0:b0:399:26da:29af with SMTP id g9-20020a656cc9000000b0039926da29afmr26737210pgw.489.1654631166921;
        Tue, 07 Jun 2022 12:46:06 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id kw3-20020a17090b220300b001e2f6c7b6f6sm12350882pjb.10.2022.06.07.12.46.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jun 2022 12:46:06 -0700 (PDT)
Message-ID: <629faafe.1c69fb81.e9ac3.b552@mx.google.com>
Date:   Tue, 07 Jun 2022 12:46:06 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.15.45-667-g6f48aa0f6b54d
X-Kernelci-Branch: queue/5.15
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.15 baseline: 157 runs,
 2 regressions (v5.15.45-667-g6f48aa0f6b54d)
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

stable-rc/queue/5.15 baseline: 157 runs, 2 regressions (v5.15.45-667-g6f48a=
a0f6b54d)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
jetson-tk1       | arm   | lab-baylibre  | gcc-10   | tegra_defconfig      =
      | 1          =

rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.45-667-g6f48aa0f6b54d/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.45-667-g6f48aa0f6b54d
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      6f48aa0f6b54d692e031f829501a69c0ea421fa6 =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
jetson-tk1       | arm   | lab-baylibre  | gcc-10   | tegra_defconfig      =
      | 1          =


  Details:     https://kernelci.org/test/plan/id/629faadc70163cf17aa39bcd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: tegra_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.45-=
667-g6f48aa0f6b54d/arm/tegra_defconfig/gcc-10/lab-baylibre/baseline-jetson-=
tk1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.45-=
667-g6f48aa0f6b54d/arm/tegra_defconfig/gcc-10/lab-baylibre/baseline-jetson-=
tk1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220603.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/629faadc70163cf17aa39=
bce
        failing since 14 days (last pass: v5.15.40-98-g6e388a6f5046, first =
fail: v5.15.41-132-gede7034a09d1) =

 =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/629f7b7bb99f49bf86a39c0e

  Results:     88 PASS, 4 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.45-=
667-g6f48aa0f6b54d/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/ba=
seline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.45-=
667-g6f48aa0f6b54d/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/ba=
seline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220603.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/629f7b7cb99f49bf86a39c30
        failing since 91 days (last pass: v5.15.26-42-gc89c0807b943, first =
fail: v5.15.26-257-g2b9a22cd5eb8)

    2022-06-07T16:23:16.573450  /lava-6564313/1/../bin/lava-test-case
    2022-06-07T16:23:16.584410  <8>[   33.448116] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s1-probed RESULT=3Dfail>   =

 =20
