Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 577D8551816
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 14:03:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241751AbiFTMCk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 08:02:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241683AbiFTMCP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 08:02:15 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C5AC18379
        for <stable@vger.kernel.org>; Mon, 20 Jun 2022 05:02:12 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id o18so2484434plg.2
        for <stable@vger.kernel.org>; Mon, 20 Jun 2022 05:02:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=QL8Eq3g/rqqbM0tpZe4ZzmQJfeG8ox0banlsQwimkmo=;
        b=7wyVpoBNj0Ra1ybH4eTruk3/dfbpJUT+nPhrVjtoWJsL/eIdPNQ+0kngsCCyCgoPrz
         vebYgNP3Cm0yZUdPHU0ttOwKNvUpHLrPCdNYb126TP8bxAlqAj1Bn3h/zg9lYfk4ML5G
         3+HMVCCy0a/kKYsjf73aAYa5T+AgEzZkMuf7ZdtHn1eQLR7cVCVohDymApBh6LnQ7fin
         6o/hUG9cZW5bPliA/h8GTYTdcv5qEq3PKfSHrb/WIDoJtb/ZNNTjmRM5BziPlCxmoXK3
         AFORe4dMwERPl1seDVUcWNxrwd42dzlTfsXexOnWrLvm3/xhJG3RL4d/MSqvfWHzoNCX
         oryQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=QL8Eq3g/rqqbM0tpZe4ZzmQJfeG8ox0banlsQwimkmo=;
        b=jeEbqrpZcesiXqdi7yhWKvLOeM2pUyP6WqLunZkcLz/FfHuAy7YMopN+huBd46Nvzt
         wmlJfBxKBoDCDE5fETXCQSjfA7iffqclWL9MYz73dK4f9Gl3tHmZOMUj5fxVFhm0jrSy
         G6x1sLYS4OZKV0cEuQxeQp7OASHs63ilGNGrHoQHE/IBpH4IOe1nSJ15n2+UJaIp0qNQ
         MS0hzj6rRfLjN9YiFFxcM3lXHAd8p3RqFwOlZLh7sMyHs1h48dvbe1MHc65zBsG1HT/C
         MVDlS7M0j0IBV/gUOcWdr8qHfGeBYqkNDe3jxNRY2NEJu9NZrq/5G/88j13AYPY2Nf8c
         kJ0w==
X-Gm-Message-State: AJIora+i4l2lW8MYyVyKYm/ttLogSbU6fA/2uqH1SYNl6hgvc8uve/la
        Sv90R+F0b0WjcHsM+X1XxS3G5IgOTnYQncvfYrI=
X-Google-Smtp-Source: AGRyM1sce3mPfTEBdyhQJGmE7/Uo8LpwGHesS2e69W56lfSwW4bQFLaH6Y5hRwnc98GevllKfyH1jQ==
X-Received: by 2002:a17:90b:1b10:b0:1e8:2966:3232 with SMTP id nu16-20020a17090b1b1000b001e829663232mr37583509pjb.103.1655726531695;
        Mon, 20 Jun 2022 05:02:11 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id z4-20020a17090a66c400b001e345c579d5sm8065672pjl.26.2022.06.20.05.02.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jun 2022 05:02:11 -0700 (PDT)
Message-ID: <62b061c3.1c69fb81.bb786.b12d@mx.google.com>
Date:   Mon, 20 Jun 2022 05:02:11 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.18.5-99-gcf0cf9cc98a11
X-Kernelci-Branch: queue/5.18
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.18 baseline: 52 runs,
 1 regressions (v5.18.5-99-gcf0cf9cc98a11)
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

stable-rc/queue/5.18 baseline: 52 runs, 1 regressions (v5.18.5-99-gcf0cf9cc=
98a11)

Regressions Summary
-------------------

platform          | arch | lab           | compiler | defconfig       | reg=
ressions
------------------+------+---------------+----------+-----------------+----=
--------
tegra124-nyan-big | arm  | lab-collabora | gcc-10   | tegra_defconfig | 1  =
        =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.18/ker=
nel/v5.18.5-99-gcf0cf9cc98a11/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.18
  Describe: v5.18.5-99-gcf0cf9cc98a11
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      cf0cf9cc98a11e9ed5dae76061004ca902f106ef =



Test Regressions
---------------- =



platform          | arch | lab           | compiler | defconfig       | reg=
ressions
------------------+------+---------------+----------+-----------------+----=
--------
tegra124-nyan-big | arm  | lab-collabora | gcc-10   | tegra_defconfig | 1  =
        =


  Details:     https://kernelci.org/test/plan/id/62b028990fab107f72a39be0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: tegra_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.5-9=
9-gcf0cf9cc98a11/arm/tegra_defconfig/gcc-10/lab-collabora/baseline-tegra124=
-nyan-big.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.5-9=
9-gcf0cf9cc98a11/arm/tegra_defconfig/gcc-10/lab-collabora/baseline-tegra124=
-nyan-big.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220610.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62b028990fab107f72a39=
be1
        new failure (last pass: v5.18.5-51-g1c79ce42b8e0f) =

 =20
