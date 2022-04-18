Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA3AB50519C
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 14:34:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234518AbiDRMfs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 08:35:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239095AbiDRMeT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 08:34:19 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6774220F7E
        for <stable@vger.kernel.org>; Mon, 18 Apr 2022 05:27:25 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id md20-20020a17090b23d400b001cb70ef790dso17116870pjb.5
        for <stable@vger.kernel.org>; Mon, 18 Apr 2022 05:27:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=DRYO/GpT7XQFzb5pdMCrbo3hEelaj+N4K+Hcxt4ctQ0=;
        b=mN3Yo0JCHD90jY3mcEVuu3XDfe7mQJBdiDSuZU2p6G9hZW/fcCn0+TGWZ3we8S4uDx
         bsXIDwwT5LZSQaiegouKM9ecIscgNNuaAwNr4kphptx5ZOakNBlmkgYwxlzet1uH60xo
         m+t8oBqQqnXPbVVknWDoGbvPgCQZ0H+ErVgkDygk2EO0T0v3uwQTf19mj3Y7hrJA56uE
         gjVjvbqW8tCaNJXCkgLE5/afRiJiROcvL0Ha3i6o7sgjZNaAkQu/k4MKSxYFrnP0QLJ7
         E8acNQDSxSMA8/WF0KPvBFTdPKkYyxbyu1nnDtgU3/zs2ZgjW/LzEtTQxU5c1LzDOuw2
         SkUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=DRYO/GpT7XQFzb5pdMCrbo3hEelaj+N4K+Hcxt4ctQ0=;
        b=LGEsoqj41lIwLhCI+fgeqGXisAMMkeh1hP/+ILb45Sy0iBmAyzjhyv4JYnaUVoRX7p
         Ni04uFZGf5QXOAeJmTeV50ybkkn0Z4t6DqQ5ZFm36rlifSrdubGnDIenXFjmxVAlgnJQ
         F+b4cFe4AMFgN08z/2F4l3CUNCqPSUoDf6QvpQouTMZ+7fGHJ7nxP3DH7svWTlR2YWdA
         nJ+IlIH/QzfqC0eqoLUApFPc6BRS7o1Hfa0JAXjvwDd2gxfD12POuguSIBi8GyYrbY5B
         2r6ItRwVZEI977OIZnQLOetfkqAaHVLtnVxM6V1EJf4a4Gl6pnIEOUZ5GPOBcuMlBKtG
         1G1Q==
X-Gm-Message-State: AOAM531oSauAIoOWSh7ZMaOcImIBnk97Js1osN/kfeSs0iEDKgm7NVYj
        LdoCT4vplVcWXGJr2D2R3AScPt5q+pBu7YNz
X-Google-Smtp-Source: ABdhPJz57lCe8cLHZVK8gG15pSdUC7N6CDy2eZpVZ9MHWviR6dn/myWsj114PXs2iwCsg02C9vwisA==
X-Received: by 2002:a17:902:e552:b0:156:9cdc:e6cf with SMTP id n18-20020a170902e55200b001569cdce6cfmr10799769plf.78.1650284840383;
        Mon, 18 Apr 2022 05:27:20 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id j13-20020a056a00130d00b004f1025a4361sm13406763pfu.202.2022.04.18.05.27.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Apr 2022 05:27:20 -0700 (PDT)
Message-ID: <625d5928.1c69fb81.e9bc3.e9e2@mx.google.com>
Date:   Mon, 18 Apr 2022 05:27:20 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.14
X-Kernelci-Kernel: v4.14.275-277-gda5c0b6bebbb1
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.14 baseline: 103 runs,
 1 regressions (v4.14.275-277-gda5c0b6bebbb1)
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

stable-rc/queue/4.14 baseline: 103 runs, 1 regressions (v4.14.275-277-gda5c=
0b6bebbb1)

Regressions Summary
-------------------

platform             | arch  | lab          | compiler | defconfig | regres=
sions
---------------------+-------+--------------+----------+-----------+-------=
-----
meson-gxl-s905d-p230 | arm64 | lab-baylibre | gcc-10   | defconfig | 1     =
     =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.275-277-gda5c0b6bebbb1/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.275-277-gda5c0b6bebbb1
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      da5c0b6bebbb169d4ee28cc561b4bb4ea48fdd53 =



Test Regressions
---------------- =



platform             | arch  | lab          | compiler | defconfig | regres=
sions
---------------------+-------+--------------+----------+-----------+-------=
-----
meson-gxl-s905d-p230 | arm64 | lab-baylibre | gcc-10   | defconfig | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/625d298ab512aece70ae0681

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.275=
-277-gda5c0b6bebbb1/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxl-=
s905d-p230.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.275=
-277-gda5c0b6bebbb1/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxl-=
s905d-p230.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220401.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/625d298ab512aece70ae0=
682
        failing since 12 days (last pass: v4.14.271-23-g28704797a540, first=
 fail: v4.14.275-206-gfa920f352ff15) =

 =20
