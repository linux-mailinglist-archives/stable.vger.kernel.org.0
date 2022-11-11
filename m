Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6DCF625149
	for <lists+stable@lfdr.de>; Fri, 11 Nov 2022 04:10:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231559AbiKKDKb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Nov 2022 22:10:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231451AbiKKDKb (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Nov 2022 22:10:31 -0500
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13A4D2EF42
        for <stable@vger.kernel.org>; Thu, 10 Nov 2022 19:10:30 -0800 (PST)
Received: by mail-pl1-x631.google.com with SMTP id v17so3230390plo.1
        for <stable@vger.kernel.org>; Thu, 10 Nov 2022 19:10:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=IQU1zYyhJYG8Fxz5muGdPptvoq1wTrD/pyri8+W0KfM=;
        b=quJSqG/djMJ777vSuMio59MSiXcUF0c2dB1UHZULZ3d4A4yEBWZtnzmQzd5Yt/iNYu
         t8HtTNWFsdg7FYCj1xFP5yGebIW8PEFSrz2JtrXtleQT4DZaJpfxk95iX8756Fdw1zf7
         D5uLzlyc+3HhDTQ6/2/P+aYThQ4vYuMSyWVOHdTzHccltqxZzI0cTRBp4avOpq8/B65P
         wN1JA37CEdlsnuicA+Y/UjjieABtQ5juOiD/xJpzQdvpNXU6wuYiNKyRpSJti23M6mOT
         bmZaomNJGq+N3lW+sa0Sj2zLysNAh4DHywTLAqPef86Xh6x6o4jjtFziEqDGoZ1XfIZ/
         lpgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=IQU1zYyhJYG8Fxz5muGdPptvoq1wTrD/pyri8+W0KfM=;
        b=NyQiPT6MMWsKgxQnCS5fXVp7THofhIjmQM3i/ROBgLp7lIevBFvh2+XWrsyu3HCBlH
         Z4EsN98qHOOPVhpmoiFriW7H7np64wvSZxOxagwPGRRA2yNsWxwlwsYt5jJaK2rG5i04
         5JXl6LeNCf8TQtGysbkovyz+DYveaON8rqvMtzAAnIzUUdn7vZfplNE188J+R94hbVjI
         9TypTeOjfBPD3j1zk/6ntAI6JvHSvQzWynBJ+5WHMOwroS8yw60iigGVjEgx7KepUEuB
         yWt392C9qVOovL25EvhMz9HAWKzBi+zSox2lyn7ZIbltN3NzeUgj9wg0qwDePxRt8CW2
         mC6w==
X-Gm-Message-State: ANoB5pml49rHrToAImnWsDab+X77UJyiy2KM9FBhe4Px+aAKpSM4Z+wH
        /NlQp0yh0idPVhWe+gF/X27xeZh7dLZ9iDHsLdo=
X-Google-Smtp-Source: AA0mqf5nF7kpXI1ZPmXtRI+8sqEr0yd6elC2KWlryU/KiutrftQ3+ALSKc8pc22LAeCnhqoGbit8Vw==
X-Received: by 2002:a17:902:b08d:b0:181:9900:18df with SMTP id p13-20020a170902b08d00b00181990018dfmr649611plr.70.1668136229416;
        Thu, 10 Nov 2022 19:10:29 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id p7-20020a170902780700b00187033cc287sm412701pll.190.2022.11.10.19.10.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Nov 2022 19:10:29 -0800 (PST)
Message-ID: <636dbd25.170a0220.907d8.0df6@mx.google.com>
Date:   Thu, 10 Nov 2022 19:10:29 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.15.77-144-ga31758880049
X-Kernelci-Branch: queue/5.15
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.15 baseline: 135 runs,
 2 regressions (v5.15.77-144-ga31758880049)
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

stable-rc/queue/5.15 baseline: 135 runs, 2 regressions (v5.15.77-144-ga3175=
8880049)

Regressions Summary
-------------------

platform    | arch | lab     | compiler | defconfig           | regressions
------------+------+---------+----------+---------------------+------------
imx7ulp-evk | arm  | lab-nxp | gcc-10   | imx_v6_v7_defconfig | 1          =

imx7ulp-evk | arm  | lab-nxp | gcc-10   | multi_v7_defconfig  | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.77-144-ga31758880049/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.77-144-ga31758880049
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      a317588800496b5412cd29c068db5426ad8984cd =



Test Regressions
---------------- =



platform    | arch | lab     | compiler | defconfig           | regressions
------------+------+---------+----------+---------------------+------------
imx7ulp-evk | arm  | lab-nxp | gcc-10   | imx_v6_v7_defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/636d89d68becfdda38e7db4f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.77-=
144-ga31758880049/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-e=
vk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.77-=
144-ga31758880049/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-e=
vk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221024.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/636d89d68becfdda38e7d=
b50
        failing since 46 days (last pass: v5.15.70-117-g5ae36aa8ead6e, firs=
t fail: v5.15.70-133-gbad831d5b9cf) =

 =



platform    | arch | lab     | compiler | defconfig           | regressions
------------+------+---------+----------+---------------------+------------
imx7ulp-evk | arm  | lab-nxp | gcc-10   | multi_v7_defconfig  | 1          =


  Details:     https://kernelci.org/test/plan/id/636d8c1a7467588fe0e7db87

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.77-=
144-ga31758880049/arm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-ev=
k.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.77-=
144-ga31758880049/arm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-ev=
k.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221024.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/636d8c1a7467588fe0e7d=
b88
        failing since 46 days (last pass: v5.15.69-44-g09c929d3da79, first =
fail: v5.15.70-123-gaf951c1b9b36) =

 =20
