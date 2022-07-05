Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 738455675E9
	for <lists+stable@lfdr.de>; Tue,  5 Jul 2022 19:41:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231331AbiGERlB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jul 2022 13:41:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233135AbiGERlA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jul 2022 13:41:00 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C163119006
        for <stable@vger.kernel.org>; Tue,  5 Jul 2022 10:40:59 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id 128so12125427pfv.12
        for <stable@vger.kernel.org>; Tue, 05 Jul 2022 10:40:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=PtIJc1V44i7iDoaFrvSomAJEobelVC17mDSBnJa/XI8=;
        b=k0lYFUTzr4bctLKA26lOthDvdiNNS+s3oaU2zwpZykuNXV3j2gpZjbvQZUzIMaP/NK
         K1q39nxfcxXBYz1f4LWUpczEjhy8kHENZbZPwp5OYtKMtGt8bbyrUimaU6rgeSVnUACg
         /U1c9UB3lKC+/kFz54iDZTmZaxeFFmBPeiAWJvnKzsXeMar2oigmeQsEtQvMpY8Dxgzd
         KTzTouQJgOWaRgA3+q28ylntCdb0m/td3f0RoQq0yzy4TekaE067vRfMfYFPWSDPukSP
         gZ3ejJOdanpz9LMDppvAYKsm7YiuFUDsLcaRkIuldlEDWGKlj0F00m08lt+Vg3/4mxC7
         Wekg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=PtIJc1V44i7iDoaFrvSomAJEobelVC17mDSBnJa/XI8=;
        b=NCHV6nL2XmA3p/j2TaGXwuLiDdyDNpcgCA4Fw1OfYvEIY+I0wH71KO2zKr5pMTlgHd
         a7GXO3aHNvS4dDdW9kHndbzi2TzNhmCSTcqczXSWis9UZRQ51sPsti4MWAdJk8aua48O
         71G0+wEY1hyKqsXL+vY8M9BNSXvmc6J8AMtI3HHvewWPDMdtNe9Ow1pULP4nBFUxDLr3
         5ofG+FGp1AHB544Sn8iw+Afa9v6B7Oq4U/iXri6naVC+whBfCavcfAUxI2sy+lCJQZJZ
         IWYQIGoZAjxC3i2r/I4b+yZ78u4C4xNEimWRwErKDHZk7qi/xUrsKkzaXhjv+RSoOET7
         wmDQ==
X-Gm-Message-State: AJIora+cynZHhqIe13EdOpUPybwUaPKRnoZYLDlDl9F2toBhFg4pXGJF
        NovInRAn/DkapKljyq0dMeZn8a1hWSyEyhek
X-Google-Smtp-Source: AGRyM1ukNDclC40QCxFk4Eo3H+rrODfgs0aEzQ30Jgcphn+fFVrBXK06XZNb4cqsrofOZ5J6C9NZPw==
X-Received: by 2002:a62:e919:0:b0:51e:7b6e:5a3b with SMTP id j25-20020a62e919000000b0051e7b6e5a3bmr41836614pfh.78.1657042858920;
        Tue, 05 Jul 2022 10:40:58 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id s9-20020a170902a50900b0016b7dd323e5sm18483859plq.127.2022.07.05.10.40.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Jul 2022 10:40:58 -0700 (PDT)
Message-ID: <62c477aa.1c69fb81.1a61a.ab00@mx.google.com>
Date:   Tue, 05 Jul 2022 10:40:58 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.15.52-99-gbcb9695d82c0
X-Kernelci-Branch: linux-5.15.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-5.15.y baseline: 172 runs,
 5 regressions (v5.15.52-99-gbcb9695d82c0)
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

stable-rc/linux-5.15.y baseline: 172 runs, 5 regressions (v5.15.52-99-gbcb9=
695d82c0)

Regressions Summary
-------------------

platform          | arch  | lab           | compiler | defconfig           =
       | regressions
------------------+-------+---------------+----------+---------------------=
-------+------------
jetson-tk1        | arm   | lab-baylibre  | gcc-10   | multi_v7_defconfig  =
       | 1          =

jetson-tk1        | arm   | lab-baylibre  | gcc-10   | tegra_defconfig     =
       | 1          =

rk3399-gru-kevin  | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chro=
mebook | 1          =

tegra124-nyan-big | arm   | lab-collabora | gcc-10   | multi_v7_defconfig  =
       | 1          =

tegra124-nyan-big | arm   | lab-collabora | gcc-10   | tegra_defconfig     =
       | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.15.y/ker=
nel/v5.15.52-99-gbcb9695d82c0/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.15.y
  Describe: v5.15.52-99-gbcb9695d82c0
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      bcb9695d82c0c96cd7ee1714e1652f06b1b4099b =



Test Regressions
---------------- =



platform          | arch  | lab           | compiler | defconfig           =
       | regressions
------------------+-------+---------------+----------+---------------------=
-------+------------
jetson-tk1        | arm   | lab-baylibre  | gcc-10   | multi_v7_defconfig  =
       | 1          =


  Details:     https://kernelci.org/test/plan/id/62c455cee8f6d512e7a39bcd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.5=
2-99-gbcb9695d82c0/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-jets=
on-tk1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.5=
2-99-gbcb9695d82c0/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-jets=
on-tk1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220624.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62c455cee8f6d512e7a39=
bce
        failing since 7 days (last pass: v5.15.48-116-gadd0aacf730e, first =
fail: v5.15.50-136-g2c21dc5c2cb6) =

 =



platform          | arch  | lab           | compiler | defconfig           =
       | regressions
------------------+-------+---------------+----------+---------------------=
-------+------------
jetson-tk1        | arm   | lab-baylibre  | gcc-10   | tegra_defconfig     =
       | 1          =


  Details:     https://kernelci.org/test/plan/id/62c45415287a9d63dca39bf5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: tegra_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.5=
2-99-gbcb9695d82c0/arm/tegra_defconfig/gcc-10/lab-baylibre/baseline-jetson-=
tk1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.5=
2-99-gbcb9695d82c0/arm/tegra_defconfig/gcc-10/lab-baylibre/baseline-jetson-=
tk1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220624.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62c45415287a9d63dca39=
bf6
        new failure (last pass: v5.15.52) =

 =



platform          | arch  | lab           | compiler | defconfig           =
       | regressions
------------------+-------+---------------+----------+---------------------=
-------+------------
rk3399-gru-kevin  | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chro=
mebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62c441b54a8cd03508a39be7

  Results:     88 PASS, 4 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.5=
2-99-gbcb9695d82c0/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/ba=
seline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.5=
2-99-gbcb9695d82c0/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/ba=
seline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220624.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/62c441b64a8cd03508a39c09
        failing since 119 days (last pass: v5.15.26, first fail: v5.15.26-2=
58-g7b9aacd770fa)

    2022-07-05T13:50:23.662582  <8>[   32.709040] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s0-probed RESULT=3Dpass>
    2022-07-05T13:50:24.685998  /lava-6754597/1/../bin/lava-test-case
    2022-07-05T13:50:24.696719  <8>[   33.743279] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s1-probed RESULT=3Dfail>   =

 =



platform          | arch  | lab           | compiler | defconfig           =
       | regressions
------------------+-------+---------------+----------+---------------------=
-------+------------
tegra124-nyan-big | arm   | lab-collabora | gcc-10   | multi_v7_defconfig  =
       | 1          =


  Details:     https://kernelci.org/test/plan/id/62c4678570de720a09a39bcd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.5=
2-99-gbcb9695d82c0/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-teg=
ra124-nyan-big.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.5=
2-99-gbcb9695d82c0/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-teg=
ra124-nyan-big.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220624.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62c4678570de720a09a39=
bce
        failing since 40 days (last pass: v5.15.41-133-g03faf123d8c8, first=
 fail: v5.15.42) =

 =



platform          | arch  | lab           | compiler | defconfig           =
       | regressions
------------------+-------+---------------+----------+---------------------=
-------+------------
tegra124-nyan-big | arm   | lab-collabora | gcc-10   | tegra_defconfig     =
       | 1          =


  Details:     https://kernelci.org/test/plan/id/62c45e8f25ffad230aa39bfd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: tegra_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.5=
2-99-gbcb9695d82c0/arm/tegra_defconfig/gcc-10/lab-collabora/baseline-tegra1=
24-nyan-big.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.5=
2-99-gbcb9695d82c0/arm/tegra_defconfig/gcc-10/lab-collabora/baseline-tegra1=
24-nyan-big.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220624.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62c45e8f25ffad230aa39=
bfe
        failing since 40 days (last pass: v5.15.41-133-g03faf123d8c8, first=
 fail: v5.15.42) =

 =20
