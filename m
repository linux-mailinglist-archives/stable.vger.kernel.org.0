Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B5995B57F4
	for <lists+stable@lfdr.de>; Mon, 12 Sep 2022 12:13:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229701AbiILKND (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Sep 2022 06:13:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229762AbiILKNC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Sep 2022 06:13:02 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0A2722B0B
        for <stable@vger.kernel.org>; Mon, 12 Sep 2022 03:13:01 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id fs14so7520010pjb.5
        for <stable@vger.kernel.org>; Mon, 12 Sep 2022 03:13:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date;
        bh=X0rZ/caq4AK/byV874ODRbcAO5Q95Kbk0h1n7PDeakc=;
        b=ceIOrX8KNqV17nFnUPBK1duoZFW6mlg+2IhprOCT/++Kn9shJ4Se6HWMIFR56te9vH
         01Lrbp+cbavj0jAk6cssZ1k2QQFPwWJpwMqiiiVP7qPzwwg7lAYvaYOSnBTFqYAE4nHp
         2uBpxagNsXpynRbAQhTpUmGHnqPeYUTgkZzv1nwrugWLVrZLNcs6ZQdT04zTq4BC9D5M
         bNQskRpcLjutUWbxo0Fuubrcp3F0LRsuVPMBL8997IxqiM2NUXjMGtCxvV6i3IAj2Ylq
         gFEUGkJ1VgezQP99lbtjOMrZPOvp1MF7v8SwDck4yrQHst66ZSpFMEBFiJ58krGXrsJT
         Uaeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date;
        bh=X0rZ/caq4AK/byV874ODRbcAO5Q95Kbk0h1n7PDeakc=;
        b=W34XhOC2Pky88WiFpdf7qV4xmgAQzo1FpqwTZEGkOPUDoGl8ONmKY0VMq5tZhjaLLv
         zusndHIivwR46sQ3boRIHMoIj4v36UJSHXlqzBAzAZMLO2krupDN61RiamHTWvbY4vox
         nWG2Nnp/8g5sICa3qgzF8TC64oLbzSvVPSkWSB+goCycph0ECxxEraTC1/glmfIL0gKo
         ehLI23b8MmdRi3xwDxBAzwtCw715x+unhzW+fWw7Bu74fGist2jJ3hKnauvkHTMub9FR
         IQ1KsK0I/2Ml8X9E0sb/mlSQXHBrJCucvvRhEgYdoB/qF93RmId4kikQRWD8zDd6UIUF
         5N9Q==
X-Gm-Message-State: ACgBeo3lAUxu1XCTUZxKV+LV/8NdqFjXb5mJ033tA8+G1VanYUDWcSNT
        4nzBx7O1/A/3P4qQls0C+eLJekJu0omwWdSTxUA=
X-Google-Smtp-Source: AA6agR5Cya3ehh2aOlgRCZfF7w94MAhxk7Kpz7zlDwfKebYKmJTEmwCBpEycfTnhAU553+6cS1veoQ==
X-Received: by 2002:a17:903:291:b0:172:ba83:71a8 with SMTP id j17-20020a170903029100b00172ba8371a8mr26745816plr.65.1662977581374;
        Mon, 12 Sep 2022 03:13:01 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b1-20020a170902d50100b0017550eaa3eesm5603800plg.71.2022.09.12.03.13.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Sep 2022 03:13:01 -0700 (PDT)
Message-ID: <631f062d.170a0220.51657.8b6b@mx.google.com>
Date:   Mon, 12 Sep 2022 03:13:01 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.9.327
Subject: stable-rc/linux-4.9.y baseline: 40 runs, 1 regressions (v4.9.327)
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

stable-rc/linux-4.9.y baseline: 40 runs, 1 regressions (v4.9.327)

Regressions Summary
-------------------

platform      | arch | lab         | compiler | defconfig         | regress=
ions
--------------+------+-------------+----------+-------------------+--------=
----
at91sam9g20ek | arm  | lab-broonie | gcc-10   | at91_dt_defconfig | 1      =
    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.9.y/kern=
el/v4.9.327/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.9.y
  Describe: v4.9.327
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      66dd212d9c3b996c5978ffdbf8075e6ad52016bc =



Test Regressions
---------------- =



platform      | arch | lab         | compiler | defconfig         | regress=
ions
--------------+------+-------------+----------+-------------------+--------=
----
at91sam9g20ek | arm  | lab-broonie | gcc-10   | at91_dt_defconfig | 1      =
    =


  Details:     https://kernelci.org/test/plan/id/6319de939be0ec1f52355642

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: at91_dt_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.327=
/arm/at91_dt_defconfig/gcc-10/lab-broonie/baseline-at91sam9g20ek.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.327=
/arm/at91_dt_defconfig/gcc-10/lab-broonie/baseline-at91sam9g20ek.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6319de939be0ec1f52355=
643
        new failure (last pass: v4.9.326-32-g24fc65df6e8a8) =

 =20
