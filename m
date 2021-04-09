Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 033FD359D35
	for <lists+stable@lfdr.de>; Fri,  9 Apr 2021 13:21:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233865AbhDILVq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Apr 2021 07:21:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233528AbhDILVq (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 9 Apr 2021 07:21:46 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36752C061760
        for <stable@vger.kernel.org>; Fri,  9 Apr 2021 04:21:33 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id j6-20020a17090adc86b02900cbfe6f2c96so3036101pjv.1
        for <stable@vger.kernel.org>; Fri, 09 Apr 2021 04:21:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=TXwev8ogGMAEblP7Cu2zoaOsWIwe3javNA9Ke7QgT6s=;
        b=RKNjguELoB48XZiL9/xOdgmS/dFjgHUsWY04QAdGFf7G9vIk1+Fgf/lsTeR1jnZwif
         KE0qIo/u51Mz5UeiXy6IJu/KXwOcPeq/uS5MDvOiaHOs7OM76NU6Fjh72iJ6wDUUxdke
         rEe/bPnD5vo1xdwcePHQRb687ZwP8aGLplf38UHLNTMObGZLQV3yt4pzY9iIeZ7BEofZ
         MoVBEiokztcuOlOBcF4sSCbX1OO38qAgXP1qNBuAx8fqaXx0Malumk6Hn73ZMLJqivzI
         H2637QPOkij+wcI9vjcnWszydHsJs2AF+KwUt8WuztYzS25tKm6bfSiYsj4Y0oYJCpfi
         /iww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=TXwev8ogGMAEblP7Cu2zoaOsWIwe3javNA9Ke7QgT6s=;
        b=KobGZRvfqveOd1Q9rBFRc4UuslgG098SQTzv+LFLB5VVrIAFqicIfOvrDTYfKsW/FM
         uRbZ9RTtjRow2sMga5N9cex7lAcYXiUDY5Eaksr9L8LBbRP2nrl1oPXnJpEcUBCpTXsY
         LsGbLNhPvZvyIuvQnrL4Xtkh7y6VtXAgag3CzcjmvTQPLrpS/ch1XdyKlu69PJMfycQL
         l+X0xzkh+omOZj/YAMoD/4aePOKyKr8nw4xtX8yi3HRtkC8ev/QKMIev/tXYNQpH9qlz
         YrAWz2c25Ta91BfaOjDb4VMisVpWS2pvDzdnNB6yjZA7ZJOiXr2A3xbCNqSwK5zRD3Z9
         DjWw==
X-Gm-Message-State: AOAM530PdIaRS0nzq+EpdMkPRiqNxlxqezl1TODgwAm97x8SnDeT9MXL
        oLZmNWgR8KOT2rJAGQfuIoBFKn+Ay9tZ9Mrl
X-Google-Smtp-Source: ABdhPJxWgCxHJ711lrkj8lblKXAWc9dssFHFNK70AGFhF8vgbjCLblIUyJFeVUh5b4ie4qlHkz1nXw==
X-Received: by 2002:a17:902:6a87:b029:e6:6a3d:29e8 with SMTP id n7-20020a1709026a87b02900e66a3d29e8mr12122797plk.10.1617967292669;
        Fri, 09 Apr 2021 04:21:32 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id z192sm2307802pgz.94.2021.04.09.04.21.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Apr 2021 04:21:32 -0700 (PDT)
Message-ID: <607038bc.1c69fb81.43eed.606e@mx.google.com>
Date:   Fri, 09 Apr 2021 04:21:32 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.4.110-20-gae5d3904fce24
X-Kernelci-Branch: queue/5.4
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.4 baseline: 166 runs,
 1 regressions (v5.4.110-20-gae5d3904fce24)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 166 runs, 1 regressions (v5.4.110-20-gae5d390=
4fce24)

Regressions Summary
-------------------

platform         | arch | lab     | compiler | defconfig           | regres=
sions
-----------------+------+---------+----------+---------------------+-------=
-----
beaglebone-black | arm  | lab-cip | gcc-8    | omap2plus_defconfig | 1     =
     =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.110-20-gae5d3904fce24/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.110-20-gae5d3904fce24
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      ae5d3904fce242af1c8906ccc50641540b40a759 =



Test Regressions
---------------- =



platform         | arch | lab     | compiler | defconfig           | regres=
sions
-----------------+------+---------+----------+---------------------+-------=
-----
beaglebone-black | arm  | lab-cip | gcc-8    | omap2plus_defconfig | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/6070070c65b0091689dac6be

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.110-2=
0-gae5d3904fce24/arm/omap2plus_defconfig/gcc-8/lab-cip/baseline-beaglebone-=
black.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.110-2=
0-gae5d3904fce24/arm/omap2plus_defconfig/gcc-8/lab-cip/baseline-beaglebone-=
black.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6070070c65b0091689dac=
6bf
        new failure (last pass: v5.4.109-39-gf6a310964649) =

 =20
