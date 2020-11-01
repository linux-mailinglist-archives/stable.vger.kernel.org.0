Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 891B02A211D
	for <lists+stable@lfdr.de>; Sun,  1 Nov 2020 20:29:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726845AbgKAT3l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 1 Nov 2020 14:29:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726791AbgKAT3l (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 1 Nov 2020 14:29:41 -0500
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04B43C0617A6
        for <stable@vger.kernel.org>; Sun,  1 Nov 2020 11:29:40 -0800 (PST)
Received: by mail-pg1-x52f.google.com with SMTP id r10so8896532pgb.10
        for <stable@vger.kernel.org>; Sun, 01 Nov 2020 11:29:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Su2merhJuhXEt/jlr3NCwyhJ5App+O2FpyGOiIfNlhs=;
        b=Aa/s+FexXb+1gxhvVOMPLPG8dcW22z39OC/13V5gqOmbFDUR93AuONz5A9pKvY4Ki7
         eZwdioYxa8RAyCm6wKTxuiBJWAPgC/hvYFqxz5nrUziOn40XqiMD2Dw7zURP5A6RbHuj
         3AXd20E3QvbO1BoZxsfiOYLR/eb0VOHHX6fnxED0Occ4U9UEvExHlYiCVrNVq8U2D3ci
         3tITaGawaFdzzM+zbTUOIt3sTq7+8XldwzvrTAQMA42SJ2uf8umWE3/pBSJiMyJOtZUO
         1ZuPKCjmvw5lnCp1UBF3PB0HVrTx/TkQK+mGO0ts97BiajlDduyoZQqpyaZFNp+6T4Aa
         fnZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Su2merhJuhXEt/jlr3NCwyhJ5App+O2FpyGOiIfNlhs=;
        b=qOzwqY24jjnxHnvbE69IWewJbKg4Mb6xcTP9LC7t11o4ruIPpwq5ZEwfLWsI8ixjt2
         sBaW5ouncgd8Da51/ok76bkD8T6zmXNZxAsSt5xxH3I4q4WC96nVHHTNcX9S8E+PLSzZ
         FWlAbCLfGTrUlmrFBGy0J9jllPuKiZbnynRXADMR14tIq5e9tLgtVw8kWfu4TOgPqXBZ
         A1WKJv6ljQm2nazIrgu4f65Y9rHmGZT+xV+UZ8GRZwNPTsXJGEJka55ZCbT66J1/kZme
         zX21FtjI2Zq+9odDS2JH7mbGZCxhGs91FlKGKcIW6IVPiR3LkNr2ntVQlm8PmwahzX/8
         q4Yg==
X-Gm-Message-State: AOAM533iK16ltqxbFa1IwybDjWqVZnqppwRT17V2JwnWcY83woJDatca
        O3r7sNkV5DisJ/onySe88QfA2iagRj3YSw==
X-Google-Smtp-Source: ABdhPJxwVe5/mi6/B5jnixwk157wximnsocPEua3xLZ0n/jUYtooolOh2p1RoQnYwAm23oPSGUtlYg==
X-Received: by 2002:a63:7f49:: with SMTP id p9mr10576016pgn.185.1604258980155;
        Sun, 01 Nov 2020 11:29:40 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id lf11sm9306802pjb.57.2020.11.01.11.29.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Nov 2020 11:29:39 -0800 (PST)
Message-ID: <5f9f0ca3.1c69fb81.333bf.a32a@mx.google.com>
Date:   Sun, 01 Nov 2020 11:29:39 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.8.18
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Branch: linux-5.8.y
Subject: stable-rc/linux-5.8.y baseline: 202 runs, 2 regressions (v5.8.18)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.8.y baseline: 202 runs, 2 regressions (v5.8.18)

Regressions Summary
-------------------

platform        | arch  | lab          | compiler | defconfig          | re=
gressions
----------------+-------+--------------+----------+--------------------+---=
---------
imx8mp-evk      | arm64 | lab-nxp      | gcc-8    | defconfig          | 1 =
         =

stm32mp157c-dk2 | arm   | lab-baylibre | gcc-8    | multi_v7_defconfig | 1 =
         =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.8.y/kern=
el/v5.8.18/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.8.y
  Describe: v5.8.18
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      ab435ce49bd1d02e33dfec24f76955dc1196970b =



Test Regressions
---------------- =



platform        | arch  | lab          | compiler | defconfig          | re=
gressions
----------------+-------+--------------+----------+--------------------+---=
---------
imx8mp-evk      | arm64 | lab-nxp      | gcc-8    | defconfig          | 1 =
         =


  Details:     https://kernelci.org/test/plan/id/5f9ed529de935612083fe7de

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.8.y/v5.8.18/=
arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.8.y/v5.8.18/=
arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5f9ed529de935612083fe=
7df
        new failure (last pass: v5.8.17) =

 =



platform        | arch  | lab          | compiler | defconfig          | re=
gressions
----------------+-------+--------------+----------+--------------------+---=
---------
stm32mp157c-dk2 | arm   | lab-baylibre | gcc-8    | multi_v7_defconfig | 1 =
         =


  Details:     https://kernelci.org/test/plan/id/5f9ed6b5dd74507ac83fe7db

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.8.y/v5.8.18/=
arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-stm32mp157c-dk2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.8.y/v5.8.18/=
arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-stm32mp157c-dk2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5f9ed6b5dd74507ac83fe=
7dc
        failing since 4 days (last pass: v5.8.16-79-g7b491c4b6b5a, first fa=
il: v5.8.16-634-g5be39e9f29ce) =

 =20
