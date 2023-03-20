Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2FE26C099E
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 05:25:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229562AbjCTEZ3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 00:25:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbjCTEZ2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 00:25:28 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 027182D45
        for <stable@vger.kernel.org>; Sun, 19 Mar 2023 21:25:27 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id mp3-20020a17090b190300b0023fcc8ce113so125304pjb.4
        for <stable@vger.kernel.org>; Sun, 19 Mar 2023 21:25:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112; t=1679286326;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=+CbTLNPl5RJuziYYaFRYlvNi7GmZU2ctDNXjuaW/IPY=;
        b=ds0aCuIRoBccbifYXqHoweaxVT+89dzPHwrJiivQ4SXRH/R95MpWggXpgtdFmV+w/I
         woe2yQkNqXKkz4fFIlVQZMu88l7xGZRfDvWb9Grzu+JQFSwyejLVOo/URVPgG0y+3Lie
         OZfeWVHBG5QAuoLXtaw8IjAXPkX1YginKuhhVDyv+qydZJYlZ/ztZEKtaDEZSNcQfNIc
         DrEERM2PfNvkTlJ7t2/Q7q95ay0utszX1JhgxsQaz0JIeUQgUYfMJmS9fLGO0EiM5njs
         8l3mHG3uv/yeiQ96VSRv3H5NGX1cPfzjxc4il5YIbAsFs7SacNMyqP9hIoShEwJmyeIy
         6PKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679286326;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+CbTLNPl5RJuziYYaFRYlvNi7GmZU2ctDNXjuaW/IPY=;
        b=3YJldq6UwN3Cz7WuO3VteYLihx7SGjVBNDTfTIYOg22pR1QFiEtVcRjbfBNyErFCvV
         V01ctADyCsZ0HvR3gsFPcEOCN3GJpH6oaGg9eXkn9L29lBWBvOGmhnYyKfr9yPpCVETQ
         kPELsTUZS3tt7iS5gKuTgEBeCZ4oigqjBRxUPql0Ama2M3HiVaIArjL7PKPq8yT9t2dG
         wGnwDNPIPtnoAA0K4LLNpW8PUk70M1qGXjuHxepND68sHl54phftRwnU608ElmnxG5Nj
         ttQDxARS0+K1GxWf8/YOIJkmuxm8ylb/8ICgtiZ+BnJVeyKidtXF83w9RbGaSZzDJbT8
         2p6A==
X-Gm-Message-State: AO0yUKXXvxzVYLYmGmt9HAI/IfK32p9aPbhp6vqOaKNcSn2qgJGIWZHR
        GsNFE1QsSalT0+afmA6m8mluaEyZHOv4W0X3LHw=
X-Google-Smtp-Source: AK7set+Es1J81OwQK1MtF+7CgNpbBWNchcAOrZptwdABK5dv85YryL+tZJuFdcPsVa87eg3wT6G3nA==
X-Received: by 2002:a17:903:310a:b0:1a1:78e6:d600 with SMTP id w10-20020a170903310a00b001a178e6d600mr12154222plc.10.1679286326282;
        Sun, 19 Mar 2023 21:25:26 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b11-20020a170902bd4b00b0019e60c645b1sm5482594plx.305.2023.03.19.21.25.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Mar 2023 21:25:25 -0700 (PDT)
Message-ID: <6417e035.170a0220.af53c.9031@mx.google.com>
Date:   Sun, 19 Mar 2023 21:25:25 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/6.1
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v6.1.20-115-g3429cbf2d9cb
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/6.1 baseline: 134 runs,
 2 regressions (v6.1.20-115-g3429cbf2d9cb)
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

stable-rc/queue/6.1 baseline: 134 runs, 2 regressions (v6.1.20-115-g3429cbf=
2d9cb)

Regressions Summary
-------------------

platform           | arch | lab           | compiler | defconfig         | =
regressions
-------------------+------+---------------+----------+-------------------+-=
-----------
bcm2835-rpi-b-rev2 | arm  | lab-broonie   | gcc-10   | bcm2835_defconfig | =
1          =

tegra124-nyan-big  | arm  | lab-collabora | gcc-10   | tegra_defconfig   | =
1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F6.1/kern=
el/v6.1.20-115-g3429cbf2d9cb/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/6.1
  Describe: v6.1.20-115-g3429cbf2d9cb
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      3429cbf2d9cb9f4bd6187d0640f0716b60a78603 =



Test Regressions
---------------- =



platform           | arch | lab           | compiler | defconfig         | =
regressions
-------------------+------+---------------+----------+-------------------+-=
-----------
bcm2835-rpi-b-rev2 | arm  | lab-broonie   | gcc-10   | bcm2835_defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/6417a6817b820202e18c8663

  Results:     50 PASS, 2 FAIL, 1 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.20-11=
5-g3429cbf2d9cb/arm/bcm2835_defconfig/gcc-10/lab-broonie/baseline-bcm2835-r=
pi-b-rev2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.20-11=
5-g3429cbf2d9cb/arm/bcm2835_defconfig/gcc-10/lab-broonie/baseline-bcm2835-r=
pi-b-rev2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6417a6817b820202e18c869a
        failing since 2 days (last pass: v6.1.18-144-g88546018fee83, first =
fail: v6.1.19-139-g6d04fa2f2978)

    2023-03-20T00:18:48.915610  + set +x
    2023-03-20T00:18:48.919147  <8>[   18.132154] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 189522_1.5.2.4.1>
    2023-03-20T00:18:49.036025  / # #
    2023-03-20T00:18:49.138668  export SHELL=3D/bin/sh
    2023-03-20T00:18:49.139251  #
    2023-03-20T00:18:49.241240  / # export SHELL=3D/bin/sh. /lava-189522/en=
vironment
    2023-03-20T00:18:49.242162  =

    2023-03-20T00:18:49.344491  / # . /lava-189522/environment/lava-189522/=
bin/lava-test-runner /lava-189522/1
    2023-03-20T00:18:49.345671  =

    2023-03-20T00:18:49.351519  / # /lava-189522/bin/lava-test-runner /lava=
-189522/1 =

    ... (14 line(s) more)  =

 =



platform           | arch | lab           | compiler | defconfig         | =
regressions
-------------------+------+---------------+----------+-------------------+-=
-----------
tegra124-nyan-big  | arm  | lab-collabora | gcc-10   | tegra_defconfig   | =
1          =


  Details:     https://kernelci.org/test/plan/id/6417a988d405e7ae418c8655

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: tegra_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.20-11=
5-g3429cbf2d9cb/arm/tegra_defconfig/gcc-10/lab-collabora/baseline-tegra124-=
nyan-big.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.20-11=
5-g3429cbf2d9cb/arm/tegra_defconfig/gcc-10/lab-collabora/baseline-tegra124-=
nyan-big.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6417a988d405e7ae418c8=
656
        new failure (last pass: v6.1.20-92-g2d61a6c64e31) =

 =20
