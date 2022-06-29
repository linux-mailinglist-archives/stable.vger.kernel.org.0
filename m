Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D387156074D
	for <lists+stable@lfdr.de>; Wed, 29 Jun 2022 19:22:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229902AbiF2RWe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Jun 2022 13:22:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231908AbiF2RWa (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 Jun 2022 13:22:30 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 855B33D492
        for <stable@vger.kernel.org>; Wed, 29 Jun 2022 10:22:29 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id a11-20020a17090acb8b00b001eca0041455so1365620pju.1
        for <stable@vger.kernel.org>; Wed, 29 Jun 2022 10:22:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=HH0NNBb7YKuLVrX3QmD6xqbsjy85RT9hYJ9FsvVpbqo=;
        b=bKLH+1waCvVblrJv/i1UHuf4tn2TPho/T8EEPUiFG2+B2nbJ3552iCt5xYUpbtufTO
         uuFW0G13QkOk/8PAZst+4/2AdTbREmN6F06carQbI7XFmdetSadG1zNXwbng0Se8SVdg
         JwGB+nbZyDQ3YmS67xNl3prebe2z9dZauELkB2SLodZrPKoEGfJXc+xqnLXALSggturs
         13i5L/Gwli4YJRWWmLvx7mXdiNZMCc9JJH5jyrtjz6WBKoi2D7KzIiI12Uk10RJqZStG
         J/1vLLGwn71bBSId0dXUjKCJpCjUYOiNmtQ6oE7/Q/URGBV5qBHDE/9lgxpYXuW5jazb
         YyEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=HH0NNBb7YKuLVrX3QmD6xqbsjy85RT9hYJ9FsvVpbqo=;
        b=EFDsuJw30o3F93fsPTpEWsWfHWFLmGbBVK2t0yjPxFKkMSC+MdHtkeuArYfF43L+X0
         lwdspopzq5mB+8bCCKv0bzRlzEJb2J78wrkKIrWjQ7eIw0dkdCu3ToaclOyYbpEA5Z4o
         quAb5swYakq1suaR9QXoGxSfBF/9MgexKvWOkuhL/wfTO8Hq0wg0chPI/TPWAKGTmVX1
         p6WItYWVxXlbiVqJxuP+82mcOLelEujok1GgscOz1GjJnJm7eCwnvULCweaKumSnrclP
         CYE4lgGvIHzc4+c8EUOW0PV4TkvG+3rzmEwVTNhdx1WqnF+Gc/hE/xjw/ZrA5Vx/2zbm
         dcDA==
X-Gm-Message-State: AJIora9VWPCg20YxrFlXubVFIYk0ogORqUs5VoSul+4j7FK37qfW0rvB
        xVcdIdWbDTHey/u6qy1DiobsieeopAqkv3/7iPs=
X-Google-Smtp-Source: AGRyM1sbSEtiNrsuHFZYQKHVa9w7aVmgr0purYWMKLge2oigKNEewAXArpUThZcYD5J8poXiKqW5Cw==
X-Received: by 2002:a17:902:f543:b0:16a:54c6:78d0 with SMTP id h3-20020a170902f54300b0016a54c678d0mr10105991plf.28.1656523348876;
        Wed, 29 Jun 2022 10:22:28 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id u2-20020a170902714200b0016a522915e5sm11693162plm.83.2022.06.29.10.22.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jun 2022 10:22:28 -0700 (PDT)
Message-ID: <62bc8a54.1c69fb81.f3c93.0fe9@mx.google.com>
Date:   Wed, 29 Jun 2022 10:22:28 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.15.51
X-Kernelci-Branch: linux-5.15.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-5.15.y baseline: 117 runs, 3 regressions (v5.15.51)
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

stable-rc/linux-5.15.y baseline: 117 runs, 3 regressions (v5.15.51)

Regressions Summary
-------------------

platform          | arch  | lab           | compiler | defconfig           =
       | regressions
------------------+-------+---------------+----------+---------------------=
-------+------------
jetson-tk1        | arm   | lab-baylibre  | gcc-10   | tegra_defconfig     =
       | 1          =

rk3399-gru-kevin  | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chro=
mebook | 1          =

tegra124-nyan-big | arm   | lab-collabora | gcc-10   | tegra_defconfig     =
       | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.15.y/ker=
nel/v5.15.51/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.15.y
  Describe: v5.15.51
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      37238449af786e1be06f193ab54a60a39a776826 =



Test Regressions
---------------- =



platform          | arch  | lab           | compiler | defconfig           =
       | regressions
------------------+-------+---------------+----------+---------------------=
-------+------------
jetson-tk1        | arm   | lab-baylibre  | gcc-10   | tegra_defconfig     =
       | 1          =


  Details:     https://kernelci.org/test/plan/id/62bc510f0f67b0c986a39bf5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: tegra_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.5=
1/arm/tegra_defconfig/gcc-10/lab-baylibre/baseline-jetson-tk1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.5=
1/arm/tegra_defconfig/gcc-10/lab-baylibre/baseline-jetson-tk1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220624.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62bc510f0f67b0c986a39=
bf6
        new failure (last pass: v5.15.50-136-g2c21dc5c2cb6) =

 =



platform          | arch  | lab           | compiler | defconfig           =
       | regressions
------------------+-------+---------------+----------+---------------------=
-------+------------
rk3399-gru-kevin  | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chro=
mebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62bc52a9e19c6578b6a39bf4

  Results:     88 PASS, 4 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.5=
1/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gru=
-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.5=
1/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gru=
-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220624.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/62bc52a9e19c6578b6a39c1a
        failing since 113 days (last pass: v5.15.26, first fail: v5.15.26-2=
58-g7b9aacd770fa)

    2022-06-29T13:24:37.894122  <8>[   32.541892] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s0-probed RESULT=3Dpass>
    2022-06-29T13:24:38.917438  /lava-6707567/1/../bin/lava-test-case
    2022-06-29T13:24:38.928433  <8>[   33.576700] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s1-probed RESULT=3Dfail>   =

 =



platform          | arch  | lab           | compiler | defconfig           =
       | regressions
------------------+-------+---------------+----------+---------------------=
-------+------------
tegra124-nyan-big | arm   | lab-collabora | gcc-10   | tegra_defconfig     =
       | 1          =


  Details:     https://kernelci.org/test/plan/id/62bc6d482103313d85a39bd2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: tegra_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.5=
1/arm/tegra_defconfig/gcc-10/lab-collabora/baseline-tegra124-nyan-big.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.5=
1/arm/tegra_defconfig/gcc-10/lab-collabora/baseline-tegra124-nyan-big.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220624.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62bc6d482103313d85a39=
bd3
        failing since 34 days (last pass: v5.15.41-133-g03faf123d8c8, first=
 fail: v5.15.42) =

 =20
