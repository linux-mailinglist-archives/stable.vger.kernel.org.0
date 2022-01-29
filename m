Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06DE74A31CF
	for <lists+stable@lfdr.de>; Sat, 29 Jan 2022 21:24:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349701AbiA2UYz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 29 Jan 2022 15:24:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234289AbiA2UYz (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 29 Jan 2022 15:24:55 -0500
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36A1EC061714
        for <stable@vger.kernel.org>; Sat, 29 Jan 2022 12:24:55 -0800 (PST)
Received: by mail-pg1-x534.google.com with SMTP id z131so8364589pgz.12
        for <stable@vger.kernel.org>; Sat, 29 Jan 2022 12:24:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=7KCYDJxojnCpjPXxAvju0tkad9fl7cK8JExAtTNQTSg=;
        b=Z8rlM1NzYUkjW3SyD0pXY7d+ql0BYxelNBzHm3dP/1Yl+fXs4L0mU37uGEbox87lK0
         +nMOO3K1xaN1G63lRUzwtCrv60gG5VJYnxj/GX3oVwpJ6loRG/8l/Hm98Y63pWXYWri7
         7CMLkqCHDilr6EpcjsuaMkaPdp4CyrOR/s84eish/o63XxIm4rzRzPb50gJSxGcOrLUp
         u7Yo8BYg6r4MVDiIM1uF+UoCNUoYT56oJiOUbHxx38dVRWsyA6anPTj3PzaTnWEHD2Sp
         mIfM0A0g1Q5Lq/hmwEYApX0jJCAsJFf6iC69TMLftWDBnZqc7PE7ptb9boevJUsrQ6E+
         L5YQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=7KCYDJxojnCpjPXxAvju0tkad9fl7cK8JExAtTNQTSg=;
        b=Ve67rvT6WtharbtY8BxyWlY7+hDHawMoPq7lln0yZTTMfooQYnZ6m9fLjUo+IERHlT
         uDn2N1HFP1GU9X2cJ4MF1EK7zXsfmXM4GTWkS4AIaD46gB3JxQzT9/My2EV0/4wNvNjR
         LqewDq0h5v4i/qRKtHDrU0jWgE4d0F8uo8eUkuS/+uDPrWA3TErudhhhwDgWufCqafHo
         t/vTfEjrHBVO/4znU8mbkPrCfSb65nH9JryKjDbYEQmYpjiWglnSPPkOuxBLXSQuL1SR
         QeOcNR78IZsSGoK5dBYmOs7WwmCYnNncjVLxk7ngBCBbU+zCvFhpQC6mzOzDlEZJNCIy
         E6jQ==
X-Gm-Message-State: AOAM533KiRVv2N7vlgT1zyNOY/FyPOu3MXzELWr2MUKZ6uboIB5JUyJp
        82wZ9THlAEgXXYi2x0U32AY2nrV/SHYpz1V7
X-Google-Smtp-Source: ABdhPJwlAN4oH325No7aD2408lLGVrE8f0tvSwkDt1+gxiUKdbIjJoVCmmTeC1TOVl32nxaAMDCSoQ==
X-Received: by 2002:a05:6a00:885:: with SMTP id q5mr608955pfj.6.1643487894558;
        Sat, 29 Jan 2022 12:24:54 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id q140sm25635239pgq.7.2022.01.29.12.24.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 29 Jan 2022 12:24:54 -0800 (PST)
Message-ID: <61f5a296.1c69fb81.ae63d.6975@mx.google.com>
Date:   Sat, 29 Jan 2022 12:24:54 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.15.18
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.15.y
Subject: stable-rc/linux-5.15.y baseline: 137 runs, 1 regressions (v5.15.18)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.15.y baseline: 137 runs, 1 regressions (v5.15.18)

Regressions Summary
-------------------

platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.15.y/ker=
nel/v5.15.18/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.15.y
  Describe: v5.15.18
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      9c43548a7fb8220b13b0ff980989b44f37d54138 =



Test Regressions
---------------- =



platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61f56d8b861ae60c40abbd2d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
8/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagle-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
8/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagle-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61f56d8b861ae60c40abb=
d2e
        failing since 8 days (last pass: v5.15.14-70-g9cb47c4d3cbf, first f=
ail: v5.15.16) =

 =20
