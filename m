Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B08A4621D39
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 20:52:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229712AbiKHTwX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 14:52:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229645AbiKHTwW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 14:52:22 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F2D065E6C
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 11:52:22 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id m6-20020a17090a5a4600b00212f8dffec9so14426868pji.0
        for <stable@vger.kernel.org>; Tue, 08 Nov 2022 11:52:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=Y+4e7lHEgE1brD3uGabtHloHHdNweEHs5Vxb/Ko4LeI=;
        b=h6ciKUd1+AOVdub3cbcNB+uRZKRkJLdZ104UJfX8xMrZi7AjyZdEYYzAlx4VHggHK4
         VSgdCqCuoaBKyqNa3wQH9yQEKca0cA/Q4utOT/88KXbsFkb34XbquihkfoS3Q+Dr5fa0
         vhzEIoZKXD9WxvGph0Uudyg75EUjEQf7W3X0q8v6SSR33HCYtNaYR2uq+rjF9tIYCfgb
         fWe8JM7UhqnBugq6sPu8N9VcPDUmDGd/vbEiPplTiySJdL+7XZFBBMs+tCGT8SZxaaoo
         ZeiAW7+XDSb7xNx3O5xjxvE/PtHO0bRTKTKi0LlzwBU9aPLVWseuVwS/9FRQQ7618MeL
         8y+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Y+4e7lHEgE1brD3uGabtHloHHdNweEHs5Vxb/Ko4LeI=;
        b=oMGzOSJkLW/MWA0ziiCK62jUUZVfTvVZWVvNMw9iinTVaq3hC9z7A9hipVOgh4f+ow
         lC6U06iVgJFTa/pG/IIagdhZChnIxTVTwYNrPxGWWULIRN/G560Sig8TuC9vdsbaNkYZ
         e4fbwwvAnYlrFOsJxzDpdw/rd67cnzsXEOvMKEdcATIj91vwX/Qh9SIeUux46DVdGh9I
         hF6u3Wk7qRzkHl8aRo3Ibvx6stA1t9QbhlcC6f9lFIvnMxBpI9XtMNJEA3TaMIodinhw
         cL6Rg6cgN4TMTuibNywRds+eCO/YWYMJo5xhtGNq9+Pe1U0Ert6LLZpJZhBVJzjzn5Jx
         Hzcg==
X-Gm-Message-State: ACrzQf2XhObCgTu8T6uLnVseiDqJr5XzUoTAVwoI67AN0ZJ638st0Hln
        vd8A6wqPV/aCNbxJfGwIWzI9pJ+t1/U/m6pX
X-Google-Smtp-Source: AMsMyM4EaleYPQoGXQej5xOcqCkINfU7LcJsF4Xep/DbxhKpuhNbYtaGNca0rOJv7hKB1baudTwv8A==
X-Received: by 2002:a17:902:ccc2:b0:178:29e1:899e with SMTP id z2-20020a170902ccc200b0017829e1899emr56868699ple.114.1667937141559;
        Tue, 08 Nov 2022 11:52:21 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id u7-20020a63ef07000000b004393c5a8006sm6149897pgh.75.2022.11.08.11.52.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Nov 2022 11:52:21 -0800 (PST)
Message-ID: <636ab375.630a0220.3c7a4.a817@mx.google.com>
Date:   Tue, 08 Nov 2022 11:52:21 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.10.153-119-g296919ad8f27
X-Kernelci-Branch: linux-5.10.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-5.10.y baseline: 78 runs,
 2 regressions (v5.10.153-119-g296919ad8f27)
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

stable-rc/linux-5.10.y baseline: 78 runs, 2 regressions (v5.10.153-119-g296=
919ad8f27)

Regressions Summary
-------------------

platform          | arch | lab          | compiler | defconfig           | =
regressions
------------------+------+--------------+----------+---------------------+-=
-----------
beagle-xm         | arm  | lab-baylibre | gcc-10   | omap2plus_defconfig | =
1          =

r8a7743-iwg20d-q7 | arm  | lab-cip      | gcc-10   | shmobile_defconfig  | =
1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.10.y/ker=
nel/v5.10.153-119-g296919ad8f27/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.10.y
  Describe: v5.10.153-119-g296919ad8f27
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      296919ad8f27fa545d0d75aed165240cd3eda695 =



Test Regressions
---------------- =



platform          | arch | lab          | compiler | defconfig           | =
regressions
------------------+------+--------------+----------+---------------------+-=
-----------
beagle-xm         | arm  | lab-baylibre | gcc-10   | omap2plus_defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/636a807818ef68a4e9e7db54

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
53-119-g296919ad8f27/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-b=
eagle-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
53-119-g296919ad8f27/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-b=
eagle-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221024.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/636a807818ef68a4e9e7d=
b55
        new failure (last pass: v5.10.149) =

 =



platform          | arch | lab          | compiler | defconfig           | =
regressions
------------------+------+--------------+----------+---------------------+-=
-----------
r8a7743-iwg20d-q7 | arm  | lab-cip      | gcc-10   | shmobile_defconfig  | =
1          =


  Details:     https://kernelci.org/test/plan/id/636a7dd17aa7344855e7db84

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: shmobile_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
53-119-g296919ad8f27/arm/shmobile_defconfig/gcc-10/lab-cip/baseline-r8a7743=
-iwg20d-q7.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
53-119-g296919ad8f27/arm/shmobile_defconfig/gcc-10/lab-cip/baseline-r8a7743=
-iwg20d-q7.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221024.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/636a7dd17aa7344855e7d=
b85
        failing since 9 days (last pass: v5.10.150-80-g04a0124fa82b5, first=
 fail: v5.10.152) =

 =20
