Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81432569117
	for <lists+stable@lfdr.de>; Wed,  6 Jul 2022 19:50:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232642AbiGFRuS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Jul 2022 13:50:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232400AbiGFRuR (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Jul 2022 13:50:17 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB5C91DA49
        for <stable@vger.kernel.org>; Wed,  6 Jul 2022 10:50:16 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id o3-20020a17090a744300b001ef8f7f3dddso8015528pjk.3
        for <stable@vger.kernel.org>; Wed, 06 Jul 2022 10:50:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=pzgkCzXFdWVDXOqh7YF8CqEggEK/5nhzvPZGLUtfmNE=;
        b=NQgj+Kl7M8nwWOc0SSmPGfJHq6EMIlR4v4lTr0BKUUyg9vGDcJoOgkPEQwNt7jmtgZ
         9oXsW8maTH/dgPgDE4pSvX3aML89DaD79fGuovniB+cHiTcHZoNrBXJzYgyFXVc8GfZw
         Pqe/p+3h6SZsvo5g6mtQfzer7fHImBLLMwhPG6kAK+z+CZ7ZcapOLy4j8da3WufknCuP
         d8giWJG467lGwhQWNbpFpqsCatJf3/r4xI1/HhbcNfEuvHklGoMN0/HwbQaXmi+b/8mP
         3r9Q+M7pTRHfJBMHXbn7lPbvFp5d+6o8mveWvhWNx/H5IIOx3he9DOAQZNJsiGF7a0BF
         tqtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=pzgkCzXFdWVDXOqh7YF8CqEggEK/5nhzvPZGLUtfmNE=;
        b=WRwuWcUEiRl7aQorbHHd4gNEuVb5zFnyEdR+TmMWnBs7lhiN+RgvstCPROrdNMdEXo
         m9M1E9qVTZBEt87vZVLgmYX4MwWJzY8P/bRhlc5HMLCG58gYO87DIiHuIEP7VT3d2SWu
         bwQJq6pT4rs5DtLWaQVjE+4jRroWFGmht6x3m1GICBpibwmZEy2Fe1UpIOy4CeBJ4dfm
         kDPmXPxggrnNWH0c7TM84L948LRlItoSz3cnUZECMIPKjDCwWDI2v0F3DzpaT77UauBD
         WMynr8mTOARln+kqyQ270M3KkQyqn8hxiXINQAn+TKXcUCj3lpTU54kKJ7RllnqllPx6
         bmlw==
X-Gm-Message-State: AJIora9c2x+sRsB4bue9K8gGwylUbYE8l35KemcVTZ2qK0q/DF2FoY2R
        QGQKRdiTBDbPLwkxt2cR4KT2EEdOOQ5X8cqB
X-Google-Smtp-Source: AGRyM1tZlawmbEBQ85arCTaC0FSgRS7ldbeZKT5vieLXoHxDuIopRPHh+2zXu6w0qHcZXWDbROSiuQ==
X-Received: by 2002:a17:90b:1d8c:b0:1ed:54c3:dcca with SMTP id pf12-20020a17090b1d8c00b001ed54c3dccamr51410726pjb.126.1657129816312;
        Wed, 06 Jul 2022 10:50:16 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id j11-20020a170902da8b00b0016bff65d5cbsm2166026plx.194.2022.07.06.10.50.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Jul 2022 10:50:16 -0700 (PDT)
Message-ID: <62c5cb58.1c69fb81.a482f.3a1f@mx.google.com>
Date:   Wed, 06 Jul 2022 10:50:16 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.18.9-102-gd6cba0796551
X-Kernelci-Branch: queue/5.18
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.18 baseline: 128 runs,
 2 regressions (v5.18.9-102-gd6cba0796551)
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

stable-rc/queue/5.18 baseline: 128 runs, 2 regressions (v5.18.9-102-gd6cba0=
796551)

Regressions Summary
-------------------

platform           | arch | lab             | compiler | defconfig         =
 | regressions
-------------------+------+-----------------+----------+-------------------=
-+------------
imx6ul-pico-hobbit | arm  | lab-pengutronix | gcc-10   | multi_v7_defconfig=
 | 1          =

jetson-tk1         | arm  | lab-baylibre    | gcc-10   | multi_v7_defconfig=
 | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.18/ker=
nel/v5.18.9-102-gd6cba0796551/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.18
  Describe: v5.18.9-102-gd6cba0796551
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      d6cba0796551040ad0597a1ddde85e1830067c11 =



Test Regressions
---------------- =



platform           | arch | lab             | compiler | defconfig         =
 | regressions
-------------------+------+-----------------+----------+-------------------=
-+------------
imx6ul-pico-hobbit | arm  | lab-pengutronix | gcc-10   | multi_v7_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/62c59587692aaf1d89a39d02

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.9-1=
02-gd6cba0796551/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-imx=
6ul-pico-hobbit.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.9-1=
02-gd6cba0796551/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-imx=
6ul-pico-hobbit.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220624.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62c59587692aaf1d89a39=
d03
        failing since 0 day (last pass: v5.18.9-96-g91cfa3d0b94d, first fai=
l: v5.18.9-102-ga6b8287ea0b9) =

 =



platform           | arch | lab             | compiler | defconfig         =
 | regressions
-------------------+------+-----------------+----------+-------------------=
-+------------
jetson-tk1         | arm  | lab-baylibre    | gcc-10   | multi_v7_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/62c5949e16ddeb0feea39bdc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.9-1=
02-gd6cba0796551/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-jetson=
-tk1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.9-1=
02-gd6cba0796551/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-jetson=
-tk1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220624.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62c5949e16ddeb0feea39=
bdd
        failing since 1 day (last pass: v5.18.8-6-g365d872fd167, first fail=
: v5.18.9-96-g91cfa3d0b94d) =

 =20
