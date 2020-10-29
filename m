Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56DC629F3A0
	for <lists+stable@lfdr.de>; Thu, 29 Oct 2020 18:51:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727067AbgJ2Rvl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Oct 2020 13:51:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727051AbgJ2Rvk (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Oct 2020 13:51:40 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7F80C0613CF
        for <stable@vger.kernel.org>; Thu, 29 Oct 2020 10:51:39 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id o129so2981155pfb.1
        for <stable@vger.kernel.org>; Thu, 29 Oct 2020 10:51:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=WcRmS7SKuCYT+oeURtIqVK1u3/Azt4Es5FX6kTFAPKI=;
        b=J6R/yi+5e1wM+cHKF7LCF0zD3LAJIPfNh0SmKahwIx7CpdoB3OOjY6nEjUSJE51Prl
         U4xF02Pq2T8teKluOcFrYC7Wwx9IiEct+q+nDGkA84stHVNEbhRDTgRmRFKTUh2uy+8L
         0zN8u0H3HkdtxqVkREMxonJCh6jaZMPqOwr6FNDQdPIXpnaY/brQ/OusirMEnmb+IOrZ
         yfXcwYSUI/RA8280ijXoDB2ayLROuC9a5Bt70IBDRDTjOBN17hwAM6Kqc+9dJwYP0t67
         wWsuyJtq40I+Et7sQRm8pB0C3e7guJNCQrRyRywuEVq6UNA+Xm6ung/Emye2K9Kc6bxo
         V+/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=WcRmS7SKuCYT+oeURtIqVK1u3/Azt4Es5FX6kTFAPKI=;
        b=Aw11k1+HTvnsuFlGULmVg3tIZjG4Jy+YbIBdrr/1vGPwF3Q1bElse6WqjUAxBQ9Juh
         VBo/snFIVHIPrEUh0B0nBi49zYYCM3Ki4Zs+WeRSKUhD+lByJkqpN0/lLilhQZ32yCSK
         7QJYh6HG7ArG46j8cncZxK/O5SrD4RJpFDlp0s9sZz3T18hS2kqCNZaiJMaRzTfJEcK+
         l9OL0We1nUCsFmp/5c2ZprybiPlFReVadKFYwPq/696Fd3UZ1UMvVgYC7iQyCd27xgRJ
         dNWMHq36p+zvHOCJJ39QQfDmDBVB+taV/JlePnUV+817wZoxMC0b+fjX1wVtvJNDIfBW
         nT9w==
X-Gm-Message-State: AOAM5313s2NRJaTlI3Miy+/4ovPZXz09adltwXVg4w/bHYcTEpoxDcuE
        oF+niuQy3WhAs7MHOrPXNWD4TMRD3/nRJQ==
X-Google-Smtp-Source: ABdhPJxKDgAZD1Ln69+Maad+Y6t+T1xS1EkqufBSR2yajnQNQRQRE26n7zNoR244XnStKhnW3vIQdA==
X-Received: by 2002:a63:ef51:: with SMTP id c17mr4993626pgk.36.1603993898822;
        Thu, 29 Oct 2020 10:51:38 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id r187sm3709735pfc.137.2020.10.29.10.51.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Oct 2020 10:51:37 -0700 (PDT)
Message-ID: <5f9b0129.1c69fb81.a58d8.89c1@mx.google.com>
Date:   Thu, 29 Oct 2020 10:51:37 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.8.16-658-gc32c23a5a4dd
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.8
Subject: stable-rc/queue/5.8 baseline: 204 runs,
 1 regressions (v5.8.16-658-gc32c23a5a4dd)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.8 baseline: 204 runs, 1 regressions (v5.8.16-658-gc32c23a=
5a4dd)

Regressions Summary
-------------------

platform        | arch | lab          | compiler | defconfig          | reg=
ressions
----------------+------+--------------+----------+--------------------+----=
--------
stm32mp157c-dk2 | arm  | lab-baylibre | gcc-8    | multi_v7_defconfig | 1  =
        =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.8/kern=
el/v5.8.16-658-gc32c23a5a4dd/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.8
  Describe: v5.8.16-658-gc32c23a5a4dd
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      c32c23a5a4dd9f72a18cbcc12d64a3451402294d =



Test Regressions
---------------- =



platform        | arch | lab          | compiler | defconfig          | reg=
ressions
----------------+------+--------------+----------+--------------------+----=
--------
stm32mp157c-dk2 | arm  | lab-baylibre | gcc-8    | multi_v7_defconfig | 1  =
        =


  Details:     https://kernelci.org/test/plan/id/5f9ac91f8ca6a109a8381047

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.8/v5.8.16-65=
8-gc32c23a5a4dd/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-stm32mp1=
57c-dk2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.8/v5.8.16-65=
8-gc32c23a5a4dd/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-stm32mp1=
57c-dk2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5f9ac91f8ca6a109a8381=
048
        failing since 3 days (last pass: v5.8.16-78-g480e444094c4, first fa=
il: v5.8.16-626-g41d0d5713799) =

 =20
