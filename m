Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B413F44EE49
	for <lists+stable@lfdr.de>; Fri, 12 Nov 2021 22:02:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235693AbhKLVFT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Nov 2021 16:05:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232902AbhKLVFT (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 12 Nov 2021 16:05:19 -0500
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06939C061766
        for <stable@vger.kernel.org>; Fri, 12 Nov 2021 13:02:28 -0800 (PST)
Received: by mail-pf1-x434.google.com with SMTP id c4so9526205pfj.2
        for <stable@vger.kernel.org>; Fri, 12 Nov 2021 13:02:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=oFekFcVXBYvylBm3KH4v3JJAKMIlGYCO1BjlYq5b3xw=;
        b=Vx6ZA0HdLDQ7WdMkb36ENtKF6pySubaZUvtGZkwz5a1TpT3ioguwwVYDycxdCqRFP+
         lsASa784kWy6AAUFA8Rl6aTrgFzlmJP803n/d1sOLSJm5nz4Q1jXf1iwDCKGvmh/4HI3
         JrHz+ODa8R7AJElQdtgyCf8IVVXr4KtYGlKRk/1ymWDzb5fyFnWPTbQ3hnFXzafqr5mb
         sJDDza97k9hTm7ZK8NMblpud4rYxfnxp+3YXWfsH8fU97wcdsmArsFo7h5Ul/mBZHprh
         U8dQ/YX5CHb8DA7XipOVb0/fu+gXera+LuLf6FiY1lWSN4m0Pz1hl+PGZAjAu+HNvGDu
         Of5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=oFekFcVXBYvylBm3KH4v3JJAKMIlGYCO1BjlYq5b3xw=;
        b=LhCz7SSAcD2BxrFwYDzPo3fePb8X9DM1cOAZAF65tT8gKihBmxRvjTfaMrsoWII6Fu
         V9HFQP/4SafDkPu/e1GGC7H99BK8AdujWXUBdj5XbaBw9gIl17ZyO/xBMlUomxYbvNq5
         dIzFRYU/UA6HHQKMj0GAkXJ/z/euBCIxLvTrTSwi1Sm0x8mfH2R/eNhfFWm7exCEAyew
         I1irg8AadsAgf/ou1MOBTeWmaKAS/kU0Wa0n01DSZVwhfwzzB4CfWT6Y0VbjFyKw51EQ
         bTpfCDx9vkfC9sKPLIDBG28TeWU17PdGItHw9jhCdFa9I5qCc0fYbj91TLdyfTKwgVoF
         5osQ==
X-Gm-Message-State: AOAM532kaAUPtawx+pshViRv7slC/Cl9qkBlevtlFhb5q/M41oh8RvPM
        TuhMuDhmWvCfC8M7c8zZ+xsM+CnfO4HzeSfF
X-Google-Smtp-Source: ABdhPJwJy5PXugynU7lQ4efJHwIbOj5c3PhsM4vTUgcsfSBHXZZ8F6svZiGvurpM8c9NTXGS/cVy1Q==
X-Received: by 2002:a05:6a00:1504:b0:4a0:28a7:ced8 with SMTP id q4-20020a056a00150400b004a028a7ced8mr16532703pfu.30.1636750947388;
        Fri, 12 Nov 2021 13:02:27 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id e13sm5651902pgb.8.2021.11.12.13.02.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Nov 2021 13:02:27 -0800 (PST)
Message-ID: <618ed663.1c69fb81.839d2.1118@mx.google.com>
Date:   Fri, 12 Nov 2021 13:02:27 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable
X-Kernelci-Kernel: v4.14.255
X-Kernelci-Report-Type: test
Subject: stable/linux-4.14.y baseline: 148 runs, 2 regressions (v4.14.255)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.14.y baseline: 148 runs, 2 regressions (v4.14.255)

Regressions Summary
-------------------

platform          | arch | lab           | compiler | defconfig           |=
 regressions
------------------+------+---------------+----------+---------------------+=
------------
panda             | arm  | lab-collabora | gcc-10   | omap2plus_defconfig |=
 1          =

tegra124-nyan-big | arm  | lab-collabora | gcc-10   | multi_v7_defconfig  |=
 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-4.14.y/kernel=
/v4.14.255/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-4.14.y
  Describe: v4.14.255
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      5f9f3b0057d5c5782985784ba0159b05b4083055 =



Test Regressions
---------------- =



platform          | arch | lab           | compiler | defconfig           |=
 regressions
------------------+------+---------------+----------+---------------------+=
------------
panda             | arm  | lab-collabora | gcc-10   | omap2plus_defconfig |=
 1          =


  Details:     https://kernelci.org/test/plan/id/618e9e33b78ab2a1673358e5

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.14.y/v4.14.255/=
arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.14.y/v4.14.255/=
arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/618e9e33b78ab2a=
1673358e8
        new failure (last pass: v4.14.254)
        2 lines

    2021-11-12T17:02:29.213719  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/104
    2021-11-12T17:02:29.223035  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
d3c [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =



platform          | arch | lab           | compiler | defconfig           |=
 regressions
------------------+------+---------------+----------+---------------------+=
------------
tegra124-nyan-big | arm  | lab-collabora | gcc-10   | multi_v7_defconfig  |=
 1          =


  Details:     https://kernelci.org/test/plan/id/618eb41c81476d80ae3358f9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.14.y/v4.14.255/=
arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-tegra124-nyan-big.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.14.y/v4.14.255/=
arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-tegra124-nyan-big.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/618eb41c81476d80ae335=
8fa
        new failure (last pass: v4.14.254) =

 =20
