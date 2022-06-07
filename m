Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 683BF53F52A
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 06:37:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229797AbiFGEhd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 00:37:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229773AbiFGEhb (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 00:37:31 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59DE62126A
        for <stable@vger.kernel.org>; Mon,  6 Jun 2022 21:37:29 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id mh16-20020a17090b4ad000b001e8313301f1so6964119pjb.1
        for <stable@vger.kernel.org>; Mon, 06 Jun 2022 21:37:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=voaWoWbyoU8gMiLHfXJjWyhBbZZ4m7/TQmGRAQ4AsYs=;
        b=0iJJj5xJUBhyhB+L/kJH+1cO87YEWjSd99oHbfd4gAWi+ICOy7dfTI58k/Krw1MU7h
         rWiTF2Gx30EOzNiQxd3oZUmxgdt0T5LGKyfXJmcxhKEiGsIns9+01ke2puslRDcI/XXE
         OfiR6zPDyEk49NnEPpYOtZqCc56J7ywxWCyiUmjoEJe8ZPQUQ8r9m/mJcm+F/ny4xIM5
         MVo4EgkfnbUzFrp/V5TtVV0tfUufT8XlL3tlKQ4oD8ETTT+jmReunIGFM3B9PxijZcVB
         B8ZXwAwtfqksYhK15WIp39ouAkAi2+yJkgDsj99SmjysWvwV94o3Qj+O5KaJIu4o8v/x
         dGRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=voaWoWbyoU8gMiLHfXJjWyhBbZZ4m7/TQmGRAQ4AsYs=;
        b=1geyN8z5jPGVZnL6vS5vc1nusoOcopCOPJU4EWAeR8MrBF9Pai/nNbu9KDNQrraWUN
         M+vBJgSBcr+lMGgbMwZzICK9K4Png8UUXSIdcSDNr5pILsosF9UsYNnDoCIExoPd1JIa
         TUjZkeHdCPGLhj2qBjhxXaF3jargwMmiV9Fg4NSG8oH8OCfHThYeOJuw9GNsMWGrIT7D
         u2MLJX77RM6mqktxo/GL5uyIU3yPbKkKAQiVPYslmsaI/mrQTd9K1jQGLR71j6igFpZM
         ytQq9eL5zWlRxAo4dZIlrO47LgIA2X7uzupk3Qr8FJG+mT3SQuSajakfeE65Pp6Ft9IN
         gerw==
X-Gm-Message-State: AOAM533b5g6jjAuezTcOGeAUYaDja5x+4nMXX40SYyAduOnOhAWgzn5t
        jlyViAQcqZeAnX+C+uxGeqO7x3nnHW5Jp7+A
X-Google-Smtp-Source: ABdhPJzQ5xkMhJhKXq6ziBxdOWCax6ZfDjzdV0SFKaVXwKAkkMEyvms/qBkP+wZ96loZ14UL5/5qZQ==
X-Received: by 2002:a17:902:b215:b0:165:7bdd:a9f1 with SMTP id t21-20020a170902b21500b001657bdda9f1mr27796116plr.41.1654576648577;
        Mon, 06 Jun 2022 21:37:28 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id ix9-20020a170902f80900b0016797c486e4sm256200plb.259.2022.06.06.21.37.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jun 2022 21:37:27 -0700 (PDT)
Message-ID: <629ed607.1c69fb81.137c0.0cfa@mx.google.com>
Date:   Mon, 06 Jun 2022 21:37:27 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.15.45-652-g938d073d082af
X-Kernelci-Branch: queue/5.15
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.15 baseline: 156 runs,
 4 regressions (v5.15.45-652-g938d073d082af)
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

stable-rc/queue/5.15 baseline: 156 runs, 4 regressions (v5.15.45-652-g938d0=
73d082af)

Regressions Summary
-------------------

platform            | arch  | lab           | compiler | defconfig         =
         | regressions
--------------------+-------+---------------+----------+-------------------=
---------+------------
r8a77950-salvator-x | arm64 | lab-baylibre  | gcc-10   | defconfig         =
         | 1          =

rk3288-veyron-jaq   | arm   | lab-collabora | gcc-10   | multi_v7_defconfig=
         | 1          =

rk3399-gru-kevin    | arm64 | lab-collabora | gcc-10   | defconfig+arm64-ch=
romebook | 1          =

tegra124-nyan-big   | arm   | lab-collabora | gcc-10   | tegra_defconfig   =
         | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.45-652-g938d073d082af/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.45-652-g938d073d082af
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      938d073d082afdc040999061269d2e1a86b10944 =



Test Regressions
---------------- =



platform            | arch  | lab           | compiler | defconfig         =
         | regressions
--------------------+-------+---------------+----------+-------------------=
---------+------------
r8a77950-salvator-x | arm64 | lab-baylibre  | gcc-10   | defconfig         =
         | 1          =


  Details:     https://kernelci.org/test/plan/id/629eb1e3a4af86a8fda39bcd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.45-=
652-g938d073d082af/arm64/defconfig/gcc-10/lab-baylibre/baseline-r8a77950-sa=
lvator-x.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.45-=
652-g938d073d082af/arm64/defconfig/gcc-10/lab-baylibre/baseline-r8a77950-sa=
lvator-x.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220603.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/629eb1e3a4af86a8fda39=
bce
        new failure (last pass: v5.15.43-154-g1ef22a290e0e) =

 =



platform            | arch  | lab           | compiler | defconfig         =
         | regressions
--------------------+-------+---------------+----------+-------------------=
---------+------------
rk3288-veyron-jaq   | arm   | lab-collabora | gcc-10   | multi_v7_defconfig=
         | 1          =


  Details:     https://kernelci.org/test/plan/id/629ecfa593f7bd2938a39bd0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.45-=
652-g938d073d082af/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-rk3=
288-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.45-=
652-g938d073d082af/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-rk3=
288-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220603.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/629ecfa593f7bd2938a39=
bd1
        new failure (last pass: v5.15.43-212-g8b5c4320ffac2) =

 =



platform            | arch  | lab           | compiler | defconfig         =
         | regressions
--------------------+-------+---------------+----------+-------------------=
---------+------------
rk3399-gru-kevin    | arm64 | lab-collabora | gcc-10   | defconfig+arm64-ch=
romebook | 1          =


  Details:     https://kernelci.org/test/plan/id/629e9f093379fa9923a39bfb

  Results:     88 PASS, 4 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.45-=
652-g938d073d082af/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/ba=
seline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.45-=
652-g938d073d082af/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/ba=
seline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220603.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/629e9f093379fa9923a39c1d
        failing since 91 days (last pass: v5.15.26-42-gc89c0807b943, first =
fail: v5.15.26-257-g2b9a22cd5eb8)

    2022-06-07T00:42:23.915240  <8>[   59.648268] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s0-probed RESULT=3Dpass>
    2022-06-07T00:42:24.938609  /lava-6556965/1/../bin/lava-test-case   =

 =



platform            | arch  | lab           | compiler | defconfig         =
         | regressions
--------------------+-------+---------------+----------+-------------------=
---------+------------
tegra124-nyan-big   | arm   | lab-collabora | gcc-10   | tegra_defconfig   =
         | 1          =


  Details:     https://kernelci.org/test/plan/id/629ec51e15953beaf2a39bf4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: tegra_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.45-=
652-g938d073d082af/arm/tegra_defconfig/gcc-10/lab-collabora/baseline-tegra1=
24-nyan-big.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.45-=
652-g938d073d082af/arm/tegra_defconfig/gcc-10/lab-collabora/baseline-tegra1=
24-nyan-big.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220603.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/629ec51e15953beaf2a39=
bf5
        failing since 13 days (last pass: v5.15.40-102-g526a14d366391, firs=
t fail: v5.15.41-132-gede7034a09d1) =

 =20
