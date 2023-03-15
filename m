Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11CE06BABB1
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 10:09:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231657AbjCOJJS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 05:09:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232018AbjCOJIt (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 05:08:49 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3312B2ED6F
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 02:08:23 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id k18-20020a17090a591200b0023d36e30cb5so1147464pji.1
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 02:08:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112; t=1678871302;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=XDFueozLsoTrC6P9pMsIN+1IxG4NVN66LiU0rn+AJ1c=;
        b=WQZHvh973XnbcIjzruxYsG05ME74sXb7kV9aJObCHxAbA/wI0ZamLRIKKcC76iZ4qw
         /1wqChOj9h9HW9b8iD2gTqCHerMBW6LlI6iiR/z1p5fj1SYJZmude6+Gs/LVvSEnt2UC
         s4Gu6z5twpzdO7ieEjwy/u87c1LtHM4BG+R5BUy7DBL4+ssUC/wabKNqm+daP/6i5ZF3
         u8+d3VZ35LxngRB8cMdEx41g3xe3La5bkOqEYTcwsa6p15nTxBCjGMWPLmkcKXIK0gst
         bVhDeOikV6xURI3t62Ta3j7f8er/IWS2qT+HjyIEgoICN8W3YOWA36KDpFPvxOke5Kh0
         pmEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678871302;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XDFueozLsoTrC6P9pMsIN+1IxG4NVN66LiU0rn+AJ1c=;
        b=E8cY+821l5ZnkzbPQ6sot3r3FxET7/RsCHwd0Hw99TiJsDIa1sv0pyZm6vwnr338gF
         WrBtddDKh4Zj2FIDsINIfElFauym0lVuCEfneuXpCqidhGOMI3x09wpXVAFDDp1tb7A/
         uJ5vDI2USYzB6OBRNPLpArVpfYK1aE1jyEaNx7H4BXNSUFaMA42roDbSjKJDqxD0apWA
         EfMIkJY4cA9H3BgcCWsHmmw3mHalgdtTYJHxbeH45ChS4vuoRuk54mXU0g8Thi+KVwj3
         MS/mHDjKl+ThmWbkLGytbDfNod2RNJz6Sh//unKPZ6a+uDrfO3SUvTg91/00ax1OgLn6
         97Fw==
X-Gm-Message-State: AO0yUKUEj1ITgLBiZ/us/yNJNGKAFR+kedlU12q/MMdN+R6SenfUfk8v
        9uuSwBWG0rlRvpcyUjjMVKDshAcDW7MiKKljqKwvtSS+
X-Google-Smtp-Source: AK7set/wbB0oKuWovlACuKZQHGSUhJ/05BAmdJcFnH6ZH7gsOOHt+KuT+7n+9oKYrAcCff+T5uizYg==
X-Received: by 2002:a17:902:f546:b0:19f:2fd5:10dd with SMTP id h6-20020a170902f54600b0019f2fd510ddmr2212098plf.24.1678871302443;
        Wed, 15 Mar 2023 02:08:22 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b12-20020a170902650c00b0019c3296844csm3078895plk.301.2023.03.15.02.08.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Mar 2023 02:08:22 -0700 (PDT)
Message-ID: <64118b06.170a0220.84cda.6eac@mx.google.com>
Date:   Wed, 15 Mar 2023 02:08:22 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/6.1
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v6.1.18-143-gc2c4957ff6bc2
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/6.1 baseline: 80 runs,
 1 regressions (v6.1.18-143-gc2c4957ff6bc2)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/6.1 baseline: 80 runs, 1 regressions (v6.1.18-143-gc2c4957f=
f6bc2)

Regressions Summary
-------------------

platform           | arch | lab         | compiler | defconfig         | re=
gressions
-------------------+------+-------------+----------+-------------------+---=
---------
bcm2835-rpi-b-rev2 | arm  | lab-broonie | gcc-10   | bcm2835_defconfig | 1 =
         =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F6.1/kern=
el/v6.1.18-143-gc2c4957ff6bc2/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/6.1
  Describe: v6.1.18-143-gc2c4957ff6bc2
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      c2c4957ff6bc23f410103b9bf65bcaf46666b8d8 =



Test Regressions
---------------- =



platform           | arch | lab         | compiler | defconfig         | re=
gressions
-------------------+------+-------------+----------+-------------------+---=
---------
bcm2835-rpi-b-rev2 | arm  | lab-broonie | gcc-10   | bcm2835_defconfig | 1 =
         =


  Details:     https://kernelci.org/test/plan/id/6411516d62201359d98c8635

  Results:     50 PASS, 2 FAIL, 1 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.18-14=
3-gc2c4957ff6bc2/arm/bcm2835_defconfig/gcc-10/lab-broonie/baseline-bcm2835-=
rpi-b-rev2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.18-14=
3-gc2c4957ff6bc2/arm/bcm2835_defconfig/gcc-10/lab-broonie/baseline-bcm2835-=
rpi-b-rev2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6411516d62201359d98c866b
        failing since 1 day (last pass: v6.1.17-200-g45d6ef55e66a7, first f=
ail: v6.1.18-120-g5af7213bd7fea)

    2023-03-15T05:02:12.895043  + set +x
    2023-03-15T05:02:12.898751  <8>[   16.756358] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 164805_1.5.2.4.1>
    2023-03-15T05:02:13.014184  / # #
    2023-03-15T05:02:13.116419  export SHELL=3D/bin/sh
    2023-03-15T05:02:13.116916  #
    2023-03-15T05:02:13.218428  / # export SHELL=3D/bin/sh. /lava-164805/en=
vironment
    2023-03-15T05:02:13.218874  =

    2023-03-15T05:02:13.320326  / # . /lava-164805/environment/lava-164805/=
bin/lava-test-runner /lava-164805/1
    2023-03-15T05:02:13.321299  =

    2023-03-15T05:02:13.327501  / # /lava-164805/bin/lava-test-runner /lava=
-164805/1 =

    ... (14 line(s) more)  =

 =20
