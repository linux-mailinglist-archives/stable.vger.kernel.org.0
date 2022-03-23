Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B13134E58AA
	for <lists+stable@lfdr.de>; Wed, 23 Mar 2022 19:48:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242590AbiCWStl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Mar 2022 14:49:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344012AbiCWSti (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Mar 2022 14:49:38 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6849465A0
        for <stable@vger.kernel.org>; Wed, 23 Mar 2022 11:48:08 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id c23so2430065plo.0
        for <stable@vger.kernel.org>; Wed, 23 Mar 2022 11:48:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=5ZoVQHT7+gS/u0XCQLDscDyeoa1k2d3imcE/tZo6hoc=;
        b=e+9I2G5cXgmszvvDHrQd2WzxuiIgZkxDlb4h+4rfw5GV/mK3kp/JEJZ9pD/VrnmwyV
         k7WH4ilYc2oUPL83rVEx3K99bhlXS12qWV34OhngAlw2RWb/XY9NA7QchMrsz4IdAtZy
         C9wYI9FemU785scJLfFMT6jWp/L1itD1IviZj7gOOhSmrQwzkD12IUCC4S/iXlNS489S
         3QQDafOfTxee8dTvNYQ7jkkbsQPF0eqp5csyaVN4MT8rKhESof9AVc22CzeIhKd7KmUO
         hpF2tXhketBfRbgGqDcX9Smx0sR3hk42wKNNdJy5zOWgFvh+fmwSMBUbVCNPjojjkEy/
         mHSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=5ZoVQHT7+gS/u0XCQLDscDyeoa1k2d3imcE/tZo6hoc=;
        b=K+wgMUxgqlkkfTavu+xbfB2a7F2LMfYGDuO2/5ZajbyiABw1tQeTjRMlomCHz2KBvn
         cUmjFbEA/f5BXlnYavDLzM3FUfW0RzCsIC5lq/6ReQ65Ux6I8/mM5fnwzMp1UtdQhSPr
         4fvTiynE7ZVPB/pxG10CuxoTdmzDoZQCHJtQcAYx1FzSaFtu3hi1Cgr4RlbjukEFK4sy
         ienawe/qSOPdUfyvkwv004urTFeci51i3F0thxpJiG/7Y6tyqgRiXLlbqKFDgJYQpBwh
         +gGDuTftq8aw2GB4SgcNCyphVdfiCnrx6X75L0ttkXEZnh3yp6jDsA4wyRs8Sgoc8tow
         50Jw==
X-Gm-Message-State: AOAM5305EaTnbjFQWVU3s0OAYpHKTZB8UcXkp3JbPrwA4XotMsnqTGfQ
        KjPAnByLeb9Kmrfif7LhAJBlVrhKeSVp+pBG6Dc=
X-Google-Smtp-Source: ABdhPJy81P//k2wipbaRGeRjpxpfQZgPJZvwvjKsW3Nd76kfLHAnK5l1nX1szCDTmjAYOwcz6GoNww==
X-Received: by 2002:a17:902:e9c2:b0:153:c185:c7b1 with SMTP id 2-20020a170902e9c200b00153c185c7b1mr1441824plk.92.1648061287758;
        Wed, 23 Mar 2022 11:48:07 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id k17-20020a056a00135100b004fa9df39517sm606120pfu.198.2022.03.23.11.48.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Mar 2022 11:48:07 -0700 (PDT)
Message-ID: <623b6b67.1c69fb81.67287.23c3@mx.google.com>
Date:   Wed, 23 Mar 2022 11:48:07 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.10.y
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.10.108
Subject: stable-rc/linux-5.10.y baseline: 91 runs, 2 regressions (v5.10.108)
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

stable-rc/linux-5.10.y baseline: 91 runs, 2 regressions (v5.10.108)

Regressions Summary
-------------------

platform                | arch  | lab           | compiler | defconfig     =
             | regressions
------------------------+-------+---------------+----------+---------------=
-------------+------------
rk3399-gru-kevin        | arm64 | lab-collabora | gcc-10   | defconfig+arm6=
4-chromebook | 1          =

sun50i-a64-bananapi-m64 | arm64 | lab-clabbe    | gcc-10   | defconfig     =
             | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.10.y/ker=
nel/v5.10.108/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.10.y
  Describe: v5.10.108
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      9940314ebfc61cb7bc7fca4a0deed2f27fdefd11 =



Test Regressions
---------------- =



platform                | arch  | lab           | compiler | defconfig     =
             | regressions
------------------------+-------+---------------+----------+---------------=
-------------+------------
rk3399-gru-kevin        | arm64 | lab-collabora | gcc-10   | defconfig+arm6=
4-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/623b39daaec11f93c2bd9184

  Results:     90 PASS, 2 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
08/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gr=
u-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
08/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gr=
u-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/623b39dbaec11f93c2bd91a6
        failing since 15 days (last pass: v5.10.103, first fail: v5.10.103-=
106-g79bd6348914c)

    2022-03-23T15:16:21.845244  <8>[   33.407022] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s0-probed RESULT=3Dpass>
    2022-03-23T15:16:22.866511  /lava-5933073/1/../bin/lava-test-case   =

 =



platform                | arch  | lab           | compiler | defconfig     =
             | regressions
------------------------+-------+---------------+----------+---------------=
-------------+------------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe    | gcc-10   | defconfig     =
             | 1          =


  Details:     https://kernelci.org/test/plan/id/623b3b49999cb68cf9bd91c1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
08/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-bananapi-m64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
08/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-bananapi-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/623b3b49999cb68cf9bd9=
1c2
        new failure (last pass: v5.10.105-72-g1ef0e2b31490) =

 =20
