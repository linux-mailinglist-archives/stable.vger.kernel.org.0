Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 860FC581AA5
	for <lists+stable@lfdr.de>; Tue, 26 Jul 2022 22:02:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239511AbiGZUCD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Jul 2022 16:02:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230408AbiGZUCC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Jul 2022 16:02:02 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2717C33A37
        for <stable@vger.kernel.org>; Tue, 26 Jul 2022 13:02:02 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id f11-20020a17090a4a8b00b001f2f7e32d03so1649966pjh.0
        for <stable@vger.kernel.org>; Tue, 26 Jul 2022 13:02:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=3RUn2qSYJzMzWvv96q97+CEiG26dNanCrhfRGcP/dio=;
        b=Suslh+MPNneg3ZUIViIwjo3KNdExm7po8oKBEThCgi+tyZiVcuW/kIa7PGcDb62uTi
         UoM39C7zREEukcKM7xb8AzYA5EWKSntqNRbI64g6NHRPz25i7sNKtjbVYeJml0nR+Loq
         f+BjDPNzx80jbmlUDnPKpodqxp6qMyd0EGpqi08mzzajoTHG6hVLElNGAt/RfiBh3qNV
         3sBvuBTSXTWkKjZKuHIaom9NUeEJDCRKGFXcblGRo445qNwrWc/Nt9cYSh92Ji04D7eF
         eUXJRP85jnLofM6lIf3tRcqkc4OK5to2zkGKrDtCgPyKmbucoJ9OoH5HJhaM/AJVyAZa
         aEPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=3RUn2qSYJzMzWvv96q97+CEiG26dNanCrhfRGcP/dio=;
        b=fFJulahpOoQKeOpTzYFM4+ixx1ininjilabYDRQiQWaXX4EzJSpL9Zi/iAYP2MgWDc
         xoGZKaAxYAZTRXXvwPW6HOmwm3v/LyG9Y7VlkNq27Jk7Xs8axQRyvIpoicjHgdWyqM2o
         oeB5R7TtTZ9sSxO628t868bMJ2YcjCf67d0nAZxqmFRfQIgij2aNyuFSWUdcpE/RdhNu
         H6rSefc0pYPIA7y/03DNJtgAG7A9jPOq7DNX93dYk2rkwkr3mL2N41w4wlHwhGAvUWfm
         bBg22Ze5lkHtjBKxAbJ2uYwp6Oku4OevQLf6on5wuNTy0TX/UqoeruYVhVvGOySPriri
         mtvA==
X-Gm-Message-State: AJIora8zRGvzzm4xgJT8kaLse1CxkPv6IganuGZXE+nwYFWFS/ZaNoLt
        PNEzh03Erse+3gnEl2GLntQpgykaiqF3k7IE
X-Google-Smtp-Source: AGRyM1vB3CUf7NpPm8pHFi0GhTVffW7oOmQ+0hL4H2KGFPJA8sYj6kalR7uH7ojeY0DhXDKMpnKM/A==
X-Received: by 2002:a17:90b:380d:b0:1f2:ab67:af4c with SMTP id mq13-20020a17090b380d00b001f2ab67af4cmr817243pjb.48.1658865721544;
        Tue, 26 Jul 2022 13:02:01 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id v12-20020aa799cc000000b00528f9597fb3sm12069258pfi.197.2022.07.26.13.02.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Jul 2022 13:02:01 -0700 (PDT)
Message-ID: <62e04839.1c69fb81.733e7.32c4@mx.google.com>
Date:   Tue, 26 Jul 2022 13:02:01 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.18
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.18.14-150-g590d7faf5de56
Subject: stable-rc/queue/5.18 baseline: 121 runs,
 1 regressions (v5.18.14-150-g590d7faf5de56)
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

stable-rc/queue/5.18 baseline: 121 runs, 1 regressions (v5.18.14-150-g590d7=
faf5de56)

Regressions Summary
-------------------

platform           | arch | lab             | compiler | defconfig         =
 | regressions
-------------------+------+-----------------+----------+-------------------=
-+------------
imx6ul-pico-hobbit | arm  | lab-pengutronix | gcc-10   | multi_v7_defconfig=
 | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.18/ker=
nel/v5.18.14-150-g590d7faf5de56/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.18
  Describe: v5.18.14-150-g590d7faf5de56
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      590d7faf5de5648c7562aa9d1e97646e587b2cb1 =



Test Regressions
---------------- =



platform           | arch | lab             | compiler | defconfig         =
 | regressions
-------------------+------+-----------------+----------+-------------------=
-+------------
imx6ul-pico-hobbit | arm  | lab-pengutronix | gcc-10   | multi_v7_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/62e033ee0b0d51dc7cdaf068

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.14-=
150-g590d7faf5de56/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-i=
mx6ul-pico-hobbit.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.14-=
150-g590d7faf5de56/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-i=
mx6ul-pico-hobbit.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220718.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62e033ee0b0d51dc7cdaf=
069
        failing since 20 days (last pass: v5.18.9-96-g91cfa3d0b94d, first f=
ail: v5.18.9-102-ga6b8287ea0b9) =

 =20
