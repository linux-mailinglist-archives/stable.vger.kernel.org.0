Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A27AE53ECA1
	for <lists+stable@lfdr.de>; Mon,  6 Jun 2022 19:10:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236421AbiFFMJV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Jun 2022 08:09:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236410AbiFFMJV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Jun 2022 08:09:21 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7603022BD5
        for <stable@vger.kernel.org>; Mon,  6 Jun 2022 05:09:19 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id 123so2374937pgb.5
        for <stable@vger.kernel.org>; Mon, 06 Jun 2022 05:09:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Y6KAUmPUSzzyiv1Gehi1+sXrZqTieQdrzQ8HrgWD8cs=;
        b=MkW7hTz9KcbUX8zhF8PVyAWp+jsVMoz1e46xpggrp7+iFNn8tWUHvtNQl2JWVnda8Z
         I8f2JDHeraQfC4p+RvflkRPTzo+rHKeDfoKYUD6EfJDsqAntYOJqTcp9K9yzY93CH7HD
         Do5bLs+Hi8KwftaVbjZJnz3S4Irq5/m/K6iInYeVrxsxQPrq7w0cZRPtM4YILwPNQ93I
         4iq3kmPma418LI12XZGAPFcZIOjmaOgOpR0CbV9aP//2+Ztg7DRlK+lufrn53pF3sZe4
         CImXObxMmTPLhrmJYy00GjehYLO5EK37ajxIeazbOzJKZ1nKe2cYSv2exOMdv2D8fd0o
         NiCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Y6KAUmPUSzzyiv1Gehi1+sXrZqTieQdrzQ8HrgWD8cs=;
        b=us6fTr/VKYoKXhxczsQcEEtMsmjnk6pFv5LN5vilWvVK8Y1TSThHQf5a+VBCHWToKT
         rLPorJno8hhvBoq9BHB/4Ug5BcTq4mK0b3NyRY4KfSUvhBJwHYB+fLCbdDe5ZfOlWxTs
         xEbB6uDPOHtUE/ACbFT12n+szEEDKNj/86B//iVQx693osq/d77lDMdMKxaOGvbVJApG
         eS5XIdjrVmknxWPxYyFmvqUy830wzpy1SwoumPVx1ARmlGHnYgn4PWSX0VBS+rFM+atu
         Z0SPXZkFsESPwfGgpQ+IRy1LDOkNua5YHAJtd2yS90Zddbb1U8ksDynzUrFW2ARFrCmd
         IoMw==
X-Gm-Message-State: AOAM531Izktt/gzzVDv4oqyeu8+3RtZLYL495czcs0RLrt6tnU9WvLbc
        GGhe2MybgTU/BEX8Acbu86AGCDuRlCnagHpM
X-Google-Smtp-Source: ABdhPJziMxE/1CdKqtKMJZn2mXrAVewyPfyEFhoL0r/C9GkBv9iuk9xN6nTHACk+VN1V3tcnqykQnQ==
X-Received: by 2002:a63:5d21:0:b0:3fa:387b:7b44 with SMTP id r33-20020a635d21000000b003fa387b7b44mr20980366pgb.48.1654517358795;
        Mon, 06 Jun 2022 05:09:18 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id gn1-20020a17090ac78100b001df82551cf2sm9662506pjb.44.2022.06.06.05.09.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jun 2022 05:09:18 -0700 (PDT)
Message-ID: <629dee6e.1c69fb81.75b1d.58e4@mx.google.com>
Date:   Mon, 06 Jun 2022 05:09:18 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.15.45
X-Kernelci-Branch: linux-5.15.y
X-Kernelci-Tree: stable
Subject: stable/linux-5.15.y baseline: 89 runs, 3 regressions (v5.15.45)
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

stable/linux-5.15.y baseline: 89 runs, 3 regressions (v5.15.45)

Regressions Summary
-------------------

platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
jetson-tk1        | arm  | lab-baylibre  | gcc-10   | tegra_defconfig    | =
1          =

tegra124-nyan-big | arm  | lab-collabora | gcc-10   | multi_v7_defconfig | =
1          =

tegra124-nyan-big | arm  | lab-collabora | gcc-10   | tegra_defconfig    | =
1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.15.y/kernel=
/v5.15.45/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.15.y
  Describe: v5.15.45
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      207ca688162d4d77129981a8b4352114b97a52b5 =



Test Regressions
---------------- =



platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
jetson-tk1        | arm  | lab-baylibre  | gcc-10   | tegra_defconfig    | =
1          =


  Details:     https://kernelci.org/test/plan/id/629db8aca01de7f2f0a39be1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: tegra_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.45/a=
rm/tegra_defconfig/gcc-10/lab-baylibre/baseline-jetson-tk1.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.45/a=
rm/tegra_defconfig/gcc-10/lab-baylibre/baseline-jetson-tk1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220527.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/629db8aca01de7f2f0a39=
be2
        failing since 11 days (last pass: v5.15.39, first fail: v5.15.42) =

 =



platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
tegra124-nyan-big | arm  | lab-collabora | gcc-10   | multi_v7_defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/629de86e78a046535fa39bcd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.45/a=
rm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-tegra124-nyan-big.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.45/a=
rm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-tegra124-nyan-big.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220527.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/629de86e78a046535fa39=
bce
        failing since 11 days (last pass: v5.15.41, first fail: v5.15.42) =

 =



platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
tegra124-nyan-big | arm  | lab-collabora | gcc-10   | tegra_defconfig    | =
1          =


  Details:     https://kernelci.org/test/plan/id/629dd455d42a89fd0ca39bcd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: tegra_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.45/a=
rm/tegra_defconfig/gcc-10/lab-collabora/baseline-tegra124-nyan-big.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.45/a=
rm/tegra_defconfig/gcc-10/lab-collabora/baseline-tegra124-nyan-big.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220527.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/629dd455d42a89fd0ca39=
bce
        new failure (last pass: v5.15.44) =

 =20
