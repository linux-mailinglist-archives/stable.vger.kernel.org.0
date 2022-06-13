Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4067F5487AD
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 17:59:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379859AbiFMNvg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 09:51:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378217AbiFMNt4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 09:49:56 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 778552A41F
        for <stable@vger.kernel.org>; Mon, 13 Jun 2022 04:33:22 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id u2so5504102pfc.2
        for <stable@vger.kernel.org>; Mon, 13 Jun 2022 04:33:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ux7OwHLkwL7qB/cLkWx/wAi+FxAM5oiLPTr3bW+WGlg=;
        b=KBhtM+F/ss49amdwSa8ea8kGz+IHOCpM+1fMFhMynkR4R+z171ML/P6d6Qrks2DQ7o
         eXBccwrR4sAvfrZ/SZ5dkt04FQhrn2DYAeJx0qA4VB9LznoBNtGe/9j2toEMWLXaCq15
         TJVIbhvG9wM8XKL3C6lhDbEli6WIZmBBD5OdKKaYt7NtxSWcbugSWjeD1KWByMRZK/Jm
         5M6pUcR+OQrbSprIYpVvn1P2ySeD0ukHhg5r7wIOLZDd3qUgLd4yogamzPf+XUbii2m/
         DDhInFw+m3vdOJoGQ2inXHsVC6+Bg/N97nL5oqF1kc5TyO7xlsJsP+oXBT9BdAlV/oZx
         yq3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ux7OwHLkwL7qB/cLkWx/wAi+FxAM5oiLPTr3bW+WGlg=;
        b=LnMOYEs2lzEQUPGyTFnQVxsUJE59/XRWyvEo2SNnN03wMQPgxPHDWBrT4Cgu4CCqsA
         XrSc4zoQVuT709z6GLPhHUZRG4hxYluCzWNDwM6Tsi75lVLeVU6Fwgh23OOGzftNUv8L
         b+1Mw4N6ca4b8SwI4LpcGJA5Y8bmGrPT3FA1L4EINN4KCOXXjDAPRHgQFsAuflfxNIG6
         APJhNZva+1pxFBXUQ0TAdHHVzQia7bU86urW1AzoCh3Fx1Y6HtULXUp0KehawOQoFmzs
         KLRIodpUn7tuCCxnerh8v1Bl/rzoUnV5q3LmuJgbVkh1R6NYx53f1pwnLYA6EalIWDzl
         +qtw==
X-Gm-Message-State: AOAM530iHINWobGRWUKSLv4wVSZ6BxC+zwczmoi0/h2Gi0RZPNHhQz1A
        SyRE5dtXrCSHsw0zifk3aLMvCTPoz3luXqGKVHE=
X-Google-Smtp-Source: ABdhPJypH7wEU/sGjdsroadFvnATOcTycqSLhzt3ertnFAstCYfB1tW0Ll4LSJl+wAapW6GTZ5jFEQ==
X-Received: by 2002:a05:6a00:1344:b0:51b:e3b5:54e2 with SMTP id k4-20020a056a00134400b0051be3b554e2mr51836039pfu.6.1655120001360;
        Mon, 13 Jun 2022 04:33:21 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id q5-20020a170902c74500b001638a171558sm4848602plq.202.2022.06.13.04.33.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jun 2022 04:33:21 -0700 (PDT)
Message-ID: <62a72081.1c69fb81.50396.587c@mx.google.com>
Date:   Mon, 13 Jun 2022 04:33:21 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.15.45-882-gf1e18052eb978
X-Kernelci-Branch: queue/5.15
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.15 baseline: 131 runs,
 3 regressions (v5.15.45-882-gf1e18052eb978)
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

stable-rc/queue/5.15 baseline: 131 runs, 3 regressions (v5.15.45-882-gf1e18=
052eb978)

Regressions Summary
-------------------

platform                | arch  | lab           | compiler | defconfig     =
             | regressions
------------------------+-------+---------------+----------+---------------=
-------------+------------
jetson-tk1              | arm   | lab-baylibre  | gcc-10   | tegra_defconfi=
g            | 1          =

rk3399-gru-kevin        | arm64 | lab-collabora | gcc-10   | defconfig+arm6=
4-chromebook | 1          =

sun50i-a64-bananapi-m64 | arm64 | lab-clabbe    | gcc-10   | defconfig     =
             | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.45-882-gf1e18052eb978/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.45-882-gf1e18052eb978
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      f1e18052eb978d29bf558cb21d25c40480060f76 =



Test Regressions
---------------- =



platform                | arch  | lab           | compiler | defconfig     =
             | regressions
------------------------+-------+---------------+----------+---------------=
-------------+------------
jetson-tk1              | arm   | lab-baylibre  | gcc-10   | tegra_defconfi=
g            | 1          =


  Details:     https://kernelci.org/test/plan/id/62a6e9bbef450051c5a39bd1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: tegra_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.45-=
882-gf1e18052eb978/arm/tegra_defconfig/gcc-10/lab-baylibre/baseline-jetson-=
tk1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.45-=
882-gf1e18052eb978/arm/tegra_defconfig/gcc-10/lab-baylibre/baseline-jetson-=
tk1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220610.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62a6e9bbef450051c5a39=
bd2
        failing since 0 day (last pass: v5.15.45-833-g04983d84c84ee, first =
fail: v5.15.45-880-g694575c32c9b2) =

 =



platform                | arch  | lab           | compiler | defconfig     =
             | regressions
------------------------+-------+---------------+----------+---------------=
-------------+------------
rk3399-gru-kevin        | arm64 | lab-collabora | gcc-10   | defconfig+arm6=
4-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62a6e9ea31d812e844a39bce

  Results:     88 PASS, 4 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.45-=
882-gf1e18052eb978/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/ba=
seline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.45-=
882-gf1e18052eb978/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/ba=
seline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220610.1/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/62a6e9ea31d812e844a39bf0
        failing since 97 days (last pass: v5.15.26-42-gc89c0807b943, first =
fail: v5.15.26-257-g2b9a22cd5eb8)

    2022-06-13T07:40:11.368420  /lava-6603231/1/../bin/lava-test-case
    2022-06-13T07:40:11.379910  <8>[   33.723353] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s1-probed RESULT=3Dfail>   =

 =



platform                | arch  | lab           | compiler | defconfig     =
             | regressions
------------------------+-------+---------------+----------+---------------=
-------------+------------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe    | gcc-10   | defconfig     =
             | 1          =


  Details:     https://kernelci.org/test/plan/id/62a6eb0c486feb67b5a39bf4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.45-=
882-gf1e18052eb978/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-ba=
nanapi-m64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.45-=
882-gf1e18052eb978/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-ba=
nanapi-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220610.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62a6eb0c486feb67b5a39=
bf5
        new failure (last pass: v5.15.45-880-g694575c32c9b2) =

 =20
