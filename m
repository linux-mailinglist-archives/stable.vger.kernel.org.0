Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1838255AB94
	for <lists+stable@lfdr.de>; Sat, 25 Jun 2022 18:30:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229516AbiFYQ3w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 25 Jun 2022 12:29:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229487AbiFYQ3w (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 25 Jun 2022 12:29:52 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63ECC11A11
        for <stable@vger.kernel.org>; Sat, 25 Jun 2022 09:29:51 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id 68so5153745pgb.10
        for <stable@vger.kernel.org>; Sat, 25 Jun 2022 09:29:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=7qNU28fbpJyBe3vSODEXRNwOkF3BbWME+JFsHoEkctk=;
        b=AJCIf5qJ6BTCQqmAuEjXpY9AEh3z/Im8z8ckqQCJyosw7kRekjGLurPm84Pi0dYHgk
         oS1bIB/NKBehI2vZf6VT9p8a6kP52b/eLfXiW1Crwe11UXb/giLpUnmU5bZAeh/EuxZK
         2yrjPY9ozOB++PmHNYGCzrcEo5CAisgMjthnyECH4VQi4E8xpJFhJA3K/lDeAZi6UJgm
         86DGWnMd7pBOp+SZEsjBY5MqUigqIdrk/MdyyLv4uTyjF7aVJEFucUnNtr3JH0VC5oW3
         ZvZrxDGV9ktjxLqkOqeXKG1wc2RX+20bDZBfguWz6tCQ2B396+upAGc9nw0PuqRZhCey
         rMwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=7qNU28fbpJyBe3vSODEXRNwOkF3BbWME+JFsHoEkctk=;
        b=OtVMybfOx/M9o5yD3SbuoO0EiH1KfRsXWVjU2KDbmkacQVSStWkLvNSZRw9itYxFD3
         IwLVXt9iU6DZ5lAc7wYJaMMZVvqx8gF9sbCcZaMQ9KPJ1y5ujrALCtBGMGNjvsO8/vIn
         sABY6Ta9wRG20orckQcZ4fCFGDXJF3icFjt4vR5VLQ8Q5Vvu8m8O9BqjSds2VXfGorEZ
         MHD9yZNeoa+g5pS+i8Se0W2J9czyTGhvfhtLvimzSNK75hlTLVVvCuDbHK3qc3R4Nj7X
         6bqv3bhYEo6a1UobLEtG68ja+70CMvurXE5lEAsFERW/pmBhGkUu04a+9MBXhnTLlOgu
         9L0g==
X-Gm-Message-State: AJIora9OwjsXpz73xMXrYtO2/clQUtQ5NykSaJdA9Y2iHkFWkOQFdDVa
        zDOCEI1Rr4o1d+oLVGkmzEJG+qdQ18YKoz5P
X-Google-Smtp-Source: AGRyM1sbSoSAZqNwrAMipSKoPfvlbiBu9oWPmWCQy0DI0+WPoK/gmVCrTINC+KkX8CIUTuYpyo8MKg==
X-Received: by 2002:a63:6b41:0:b0:3fe:22d6:e6aa with SMTP id g62-20020a636b41000000b003fe22d6e6aamr4123147pgc.249.1656174590705;
        Sat, 25 Jun 2022 09:29:50 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id v11-20020a1709028d8b00b001641a68f1c7sm3904879plo.273.2022.06.25.09.29.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 Jun 2022 09:29:50 -0700 (PDT)
Message-ID: <62b737fe.1c69fb81.53e3d.5693@mx.google.com>
Date:   Sat, 25 Jun 2022 09:29:50 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.18.5-154-g1fbbb68b1ca9
X-Kernelci-Branch: linux-5.18.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-5.18.y baseline: 150 runs,
 3 regressions (v5.18.5-154-g1fbbb68b1ca9)
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

stable-rc/linux-5.18.y baseline: 150 runs, 3 regressions (v5.18.5-154-g1fbb=
b68b1ca9)

Regressions Summary
-------------------

platform            | arch  | lab           | compiler | defconfig         =
 | regressions
--------------------+-------+---------------+----------+-------------------=
-+------------
jetson-tk1          | arm   | lab-baylibre  | gcc-10   | tegra_defconfig   =
 | 1          =

r8a77950-salvator-x | arm64 | lab-baylibre  | gcc-10   | defconfig         =
 | 1          =

tegra124-nyan-big   | arm   | lab-collabora | gcc-10   | multi_v7_defconfig=
 | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.18.y/ker=
nel/v5.18.5-154-g1fbbb68b1ca9/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.18.y
  Describe: v5.18.5-154-g1fbbb68b1ca9
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      1fbbb68b1ca97c9e8393fe69df86b23e79f81d05 =



Test Regressions
---------------- =



platform            | arch  | lab           | compiler | defconfig         =
 | regressions
--------------------+-------+---------------+----------+-------------------=
-+------------
jetson-tk1          | arm   | lab-baylibre  | gcc-10   | tegra_defconfig   =
 | 1          =


  Details:     https://kernelci.org/test/plan/id/62b700fb4c92cadc53a39c4f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: tegra_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.18.y/v5.18.5=
-154-g1fbbb68b1ca9/arm/tegra_defconfig/gcc-10/lab-baylibre/baseline-jetson-=
tk1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.18.y/v5.18.5=
-154-g1fbbb68b1ca9/arm/tegra_defconfig/gcc-10/lab-baylibre/baseline-jetson-=
tk1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220610.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62b700fb4c92cadc53a39=
c50
        failing since 11 days (last pass: v5.18.2-880-g09bf95a7c28a7, first=
 fail: v5.18.2-1220-gd5ac9cd9153f6) =

 =



platform            | arch  | lab           | compiler | defconfig         =
 | regressions
--------------------+-------+---------------+----------+-------------------=
-+------------
r8a77950-salvator-x | arm64 | lab-baylibre  | gcc-10   | defconfig         =
 | 1          =


  Details:     https://kernelci.org/test/plan/id/62b702253398aa06a5a39bf4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.18.y/v5.18.5=
-154-g1fbbb68b1ca9/arm64/defconfig/gcc-10/lab-baylibre/baseline-r8a77950-sa=
lvator-x.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.18.y/v5.18.5=
-154-g1fbbb68b1ca9/arm64/defconfig/gcc-10/lab-baylibre/baseline-r8a77950-sa=
lvator-x.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220610.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62b702253398aa06a5a39=
bf5
        new failure (last pass: v5.18.5-142-g1cf3647a86ad5) =

 =



platform            | arch  | lab           | compiler | defconfig         =
 | regressions
--------------------+-------+---------------+----------+-------------------=
-+------------
tegra124-nyan-big   | arm   | lab-collabora | gcc-10   | multi_v7_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/62b72d8b2a263cd1faa39bcf

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.18.y/v5.18.5=
-154-g1fbbb68b1ca9/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-teg=
ra124-nyan-big.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.18.y/v5.18.5=
-154-g1fbbb68b1ca9/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-teg=
ra124-nyan-big.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220610.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62b72d8b2a263cd1faa39=
bd0
        failing since 12 days (last pass: v5.18.2-880-g09bf95a7c28a7, first=
 fail: v5.18.2-1220-gd5ac9cd9153f6) =

 =20
