Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0516453D262
	for <lists+stable@lfdr.de>; Fri,  3 Jun 2022 21:32:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344125AbiFCTc1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jun 2022 15:32:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344653AbiFCTcY (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Jun 2022 15:32:24 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6687E286CB
        for <stable@vger.kernel.org>; Fri,  3 Jun 2022 12:32:21 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id l20-20020a17090a409400b001dd2a9d555bso7864216pjg.0
        for <stable@vger.kernel.org>; Fri, 03 Jun 2022 12:32:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=e3W9j7Oy/9Dy2cTTHEf+Woq8IOC6m0+crckJIUjQw6I=;
        b=cQ52LCnP0mUtHzXTEKax2u1Sw5Ya84TQNmkFAb5IgmSV1L5bF5w4BM+RIl6OTjv+h7
         PaQpZLB65m5QWnhsZsnsYrylcwWS8iz62WBd5ATCYXI915PT+QWxQxz19I57UxTex2Fz
         EgdkoyfGR7VEj2drpPv4VjUE0bnUv2O0l1ymqlPFkSuxTAn9+vNrPWdf/iZBM5Jizb/F
         vI5QAPBZr4PKCUPJ+uCaySFkf+XUL6vrGWuOV9GscZXI3Ua5p/S5Lbs3K+FtsMrzfW21
         /6ex3WYiJcBPqO1kG3c5uw/wCGf8BNi9arV6wgNQI4iv9514opkXKd8GmoFXp492i0ES
         0mnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=e3W9j7Oy/9Dy2cTTHEf+Woq8IOC6m0+crckJIUjQw6I=;
        b=g5zzejYlK72jAOOYK/jjfntVoXRESE31ekQosPFOsq8Ih8IJdmJfyFsMu7XG6QdPAW
         Aub2xmU84InGegXiCjT+OFJXQNBNLghGPKu3ZbrKEqVk5+MQIuPt478B8lQkaxLZC/9O
         s3bQ/7HK2MfFpb6KqVuqLzCk6yFPsuLJFllAvTxlxuFgq/nqfk5HkFhy0GDinQYYegKO
         S6sIxWKuTcSBlaAs6zVUKD6UlPzEzG/0MDWd0pgt0EVfVaAGIKA3jId/5oCTgTEjjsc5
         xmReiKZZAi1SyNNMYWft9zK/RYSNTbdOgDdkyhX85T0AaRRjCOULCCANRyq/oTaC5kzK
         vM0g==
X-Gm-Message-State: AOAM5328pxu6SydNo77Zjp7niqEVfQvOqL+4ldfKCcQyQ8WdhZNLG9lp
        9uQIaFrM49W4bejpJYOWjbktehqTNnS0YCbg
X-Google-Smtp-Source: ABdhPJyPXvEGiozPij18cgSQlM8USNQRXygD+M/LVei/eWh/vXARyeSD5udUJ5ERDSQANyTIXxe8oA==
X-Received: by 2002:a17:90a:1d1:b0:1dd:220a:c433 with SMTP id 17-20020a17090a01d100b001dd220ac433mr12799145pjd.196.1654284740784;
        Fri, 03 Jun 2022 12:32:20 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y20-20020a170902d65400b00163cc9d6a04sm5841218plh.299.2022.06.03.12.32.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Jun 2022 12:32:20 -0700 (PDT)
Message-ID: <629a61c4.1c69fb81.dc55d.d293@mx.google.com>
Date:   Fri, 03 Jun 2022 12:32:20 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.19.245-15-gfda6e646184f3
X-Kernelci-Branch: queue/4.19
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.19 baseline: 40 runs,
 2 regressions (v4.19.245-15-gfda6e646184f3)
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

stable-rc/queue/4.19 baseline: 40 runs, 2 regressions (v4.19.245-15-gfda6e6=
46184f3)

Regressions Summary
-------------------

platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
tegra124-nyan-big | arm  | lab-collabora | gcc-10   | multi_v7_defconfig | =
1          =

tegra124-nyan-big | arm  | lab-collabora | gcc-10   | tegra_defconfig    | =
1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.245-15-gfda6e646184f3/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.245-15-gfda6e646184f3
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      fda6e646184f32d45c0cd5148bb2874d819b83ec =



Test Regressions
---------------- =



platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
tegra124-nyan-big | arm  | lab-collabora | gcc-10   | multi_v7_defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/629a3a4136d8f0dc21a39bd0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.245=
-15-gfda6e646184f3/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-teg=
ra124-nyan-big.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.245=
-15-gfda6e646184f3/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-teg=
ra124-nyan-big.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220527.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/629a3a4136d8f0dc21a39=
bd1
        failing since 3 days (last pass: v4.19.245-6-g6f74479c8fd4, first f=
ail: v4.19.245-10-g0d304d937b77) =

 =



platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
tegra124-nyan-big | arm  | lab-collabora | gcc-10   | tegra_defconfig    | =
1          =


  Details:     https://kernelci.org/test/plan/id/629a37814154f792a3a39bdb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: tegra_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.245=
-15-gfda6e646184f3/arm/tegra_defconfig/gcc-10/lab-collabora/baseline-tegra1=
24-nyan-big.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.245=
-15-gfda6e646184f3/arm/tegra_defconfig/gcc-10/lab-collabora/baseline-tegra1=
24-nyan-big.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220527.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/629a37814154f792a3a39=
bdc
        failing since 10 days (last pass: v4.19.243-32-ge0f9fe919ec9e, firs=
t fail: v4.19.244-44-g279b88d9359be) =

 =20
