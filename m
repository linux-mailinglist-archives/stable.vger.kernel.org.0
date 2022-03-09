Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB6FC4D26C5
	for <lists+stable@lfdr.de>; Wed,  9 Mar 2022 05:06:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231847AbiCID6R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Mar 2022 22:58:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231916AbiCID6Q (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Mar 2022 22:58:16 -0500
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E26D10E545
        for <stable@vger.kernel.org>; Tue,  8 Mar 2022 19:57:19 -0800 (PST)
Received: by mail-pf1-x42c.google.com with SMTP id s8so1126233pfk.12
        for <stable@vger.kernel.org>; Tue, 08 Mar 2022 19:57:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=bKXb6sO8RtrgxNPk+GxvBN/72M7x4b+4/YozzjPj5rM=;
        b=on4EwL13s7sMIPJmZE58MsPlw1/bqDxH0ak4j+HiavOMbWPFMiK93L7iW2P8XxwKg3
         t9N6JWbBecrdvhHyeVD3ajmllgTiEZTo5nafPEl4aDhKqTRLx6GibwytPaEBYddaS9IK
         F1G9GdgEDzf2sBkXiXOtR/X/guTtzk9KZ8ikdZx6Kpaln8zDL4wSZS0hLyd8M9qmNokt
         O+YiCUpHMBwSsoYJjKtCqNnYS6/WBm8hw/nxiReVxYIpDdMTod5yrM6+5GbrOk6R3W1M
         dVv7rH9TdXld0ge2ndnte1+lEVqiDD12YkzmD7xSUI3Sk+GunJ94C+mvThGdr/z+8WTG
         6G9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=bKXb6sO8RtrgxNPk+GxvBN/72M7x4b+4/YozzjPj5rM=;
        b=K8lya+rLM4sbJ+5PZTLpEFBGlg2flVzG8bhgFOeKp/aI5nnF0PPPnp23gn9QnXncuY
         vKS3IoKcQ0bdzxuN3qPp3Wr78ZVZrK6hGk623n9IJZgYJp/dotoXHs3B0s5X1dHcQgaA
         bAF3WsHogX1boS8BW7IjT6641KNe+4cekILBaaBlJ+Rzn9Ig6qZ25qbDYLbSdKMyUCKV
         5diLLe+kOaRm4r90QtmXoJ292OKLzRuRpccTk1mS79Hmfc0S1cjJeGm9ucKdRg08ZPnL
         hMihP4URZDtWQRIp7gWhAu0P3I001jdnN9gmOSmWjTeZk8gYhrcb+zFo0wPbmOgicVEk
         sJ9g==
X-Gm-Message-State: AOAM530mpFlU81ST36TIWKQM8TeMeiTL994uOOkSlZo6i/VRQya867HV
        0rBcrr+qeR5kjVgHcDXpItAkm+s4cnz7cuYOCvM=
X-Google-Smtp-Source: ABdhPJzMC5V1iMgicAfAAqslWsByjN0lpw8bZO/mrhn8tLC30ZwuLTd5//6Rk6BaT3fFDf3yp2qgYw==
X-Received: by 2002:a63:be0e:0:b0:363:e0be:613f with SMTP id l14-20020a63be0e000000b00363e0be613fmr16638001pgf.448.1646798238360;
        Tue, 08 Mar 2022 19:57:18 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id c18-20020a056a000ad200b004f0f9696578sm669433pfl.141.2022.03.08.19.57.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Mar 2022 19:57:17 -0800 (PST)
Message-ID: <6228259d.1c69fb81.538eb.2c13@mx.google.com>
Date:   Tue, 08 Mar 2022 19:57:17 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
X-Kernelci-Kernel: v5.10.104-43-g884fde05e832
Subject: stable-rc/queue/5.10 baseline: 93 runs,
 2 regressions (v5.10.104-43-g884fde05e832)
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

stable-rc/queue/5.10 baseline: 93 runs, 2 regressions (v5.10.104-43-g884fde=
05e832)

Regressions Summary
-------------------

platform                 | arch  | lab           | compiler | defconfig    =
              | regressions
-------------------------+-------+---------------+----------+--------------=
--------------+------------
imx6q-var-dt6customboard | arm   | lab-baylibre  | gcc-10   | multi_v7_defc=
onfig         | 1          =

rk3399-gru-kevin         | arm64 | lab-collabora | gcc-10   | defconfig+arm=
64-chromebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.104-43-g884fde05e832/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.104-43-g884fde05e832
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      884fde05e8326f8b8e25ed67b316f6b35b7029fb =



Test Regressions
---------------- =



platform                 | arch  | lab           | compiler | defconfig    =
              | regressions
-------------------------+-------+---------------+----------+--------------=
--------------+------------
imx6q-var-dt6customboard | arm   | lab-baylibre  | gcc-10   | multi_v7_defc=
onfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/6227ef60e41a060845c629de

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.104=
-43-g884fde05e832/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-imx6q=
-var-dt6customboard.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.104=
-43-g884fde05e832/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-imx6q=
-var-dt6customboard.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6227ef60e41a060845c62=
9df
        new failure (last pass: v5.10.103-105-gf074cce6ae0d) =

 =



platform                 | arch  | lab           | compiler | defconfig    =
              | regressions
-------------------------+-------+---------------+----------+--------------=
--------------+------------
rk3399-gru-kevin         | arm64 | lab-collabora | gcc-10   | defconfig+arm=
64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6227f0014e91eb5486c62993

  Results:     90 PASS, 2 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.104=
-43-g884fde05e832/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.104=
-43-g884fde05e832/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/6227f0014e91eb5486c629b9
        failing since 1 day (last pass: v5.10.103-56-ge5a40f18f4ce, first f=
ail: v5.10.103-105-gf074cce6ae0d)

    2022-03-09T00:08:09.289186  <8>[   32.943385] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s0-probed RESULT=3Dpass>
    2022-03-09T00:08:10.312463  /lava-5841909/1/../bin/lava-test-case   =

 =20
