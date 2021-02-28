Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14C203274AA
	for <lists+stable@lfdr.de>; Sun, 28 Feb 2021 22:43:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231308AbhB1Vny (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 28 Feb 2021 16:43:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231264AbhB1Vny (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 28 Feb 2021 16:43:54 -0500
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2DBFC06174A
        for <stable@vger.kernel.org>; Sun, 28 Feb 2021 13:43:13 -0800 (PST)
Received: by mail-pf1-x433.google.com with SMTP id w18so10178198pfu.9
        for <stable@vger.kernel.org>; Sun, 28 Feb 2021 13:43:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=FPJGs0QaaVselQN5Pb+oKRJgA8q64pLL5dFQiO90uFw=;
        b=X+zJ3/hoCznXeuVYA9VT3o+43rxCyRGKwP6ebKta46/VOB3Mm1hm7rHdByvMBqy47T
         UmrdLMCTWU3CKAmtwNzm2QVMGaLACgWHvn2VRqKvxRlhZx+J+KcisWoB6I+CSQudHFp0
         EeSDj2lvFbS/Ggum/7IO4YsgKUki11k0aRyh+qv5txs+8fZ2etCDUdMFiAoECgIyykki
         FW/CsCTvBL0qUh9gZAZy4/REfpb3IGnvuYvEa46uQ4Mlp2RCLQD9Nc9ZXARO1SLhYk9S
         3CRjg+IgyKh0tb1VXWJ9Q45yjp79t4/CWBxVJcFGjMRAqam14qCpfiRmK46qFMIqhpk/
         w2/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=FPJGs0QaaVselQN5Pb+oKRJgA8q64pLL5dFQiO90uFw=;
        b=TqQLPFfmdDfTG2seUemzD7rpE1R1BFqvZVfvo82E/15fLAZSeRVEDyN/9T3+V4WYvu
         8hQTAEaR+WcEH6YrG09LxH8v16tm5SnT0NcG0nMAv9g1Y0Poffo7Ukiz2LHNe0glNyXj
         IeY7tTZ/+pFHXxIacbMhvCLmgbAkxlAlQAMxFoWSGoCy5hUK6kfRjTuoA74gbDS0YZrT
         rhvNs+hzYTN5eXc3Gahw4H92GIsAqQ2dhnuA5gB/ZJw1YkkABs4W1zKfa36ioOt2xxc1
         kA2USiPeXTkBahaeCO6qxA4fAePuvZKvtGH9LxfQHxljIdv+OwCQSvCMWOKK0rMlIoPU
         iCDA==
X-Gm-Message-State: AOAM530xn0hMH7VGbrdFXPcIVtHn6yje7h6yh64fPGs4/6M8SOoKH8L8
        RDxNB+5GWCQaR7ZcDkw5GAhMMViMBFo2LQ==
X-Google-Smtp-Source: ABdhPJzOoJtv5sxc6sCFbtyCUnlWCm8evU77CRTFtHQIiO57neWiWWt8sHIgh0gM5b85Fp4uYoiYmg==
X-Received: by 2002:a65:5b43:: with SMTP id y3mr11352790pgr.415.1614548593166;
        Sun, 28 Feb 2021 13:43:13 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id o62sm13853554pga.43.2021.02.28.13.43.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Feb 2021 13:43:12 -0800 (PST)
Message-ID: <603c0e70.1c69fb81.1b788.041c@mx.google.com>
Date:   Sun, 28 Feb 2021 13:43:12 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.4.101-12-gcc28fe52aa265
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.4
Subject: stable-rc/queue/5.4 baseline: 109 runs,
 1 regressions (v5.4.101-12-gcc28fe52aa265)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 109 runs, 1 regressions (v5.4.101-12-gcc28fe5=
2aa265)

Regressions Summary
-------------------

platform             | arch  | lab          | compiler | defconfig | regres=
sions
---------------------+-------+--------------+----------+-----------+-------=
-----
hifive-unleashed-a00 | riscv | lab-baylibre | gcc-8    | defconfig | 1     =
     =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.101-12-gcc28fe52aa265/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.101-12-gcc28fe52aa265
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      cc28fe52aa26516fcfb27d5b1060e829e09bb00a =



Test Regressions
---------------- =



platform             | arch  | lab          | compiler | defconfig | regres=
sions
---------------------+-------+--------------+----------+-----------+-------=
-----
hifive-unleashed-a00 | riscv | lab-baylibre | gcc-8    | defconfig | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/603bd90c406ee11d02addcb8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (riscv64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.101-1=
2-gcc28fe52aa265/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleash=
ed-a00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.101-1=
2-gcc28fe52aa265/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleash=
ed-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/riscv/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/603bd90c406ee11d02add=
cb9
        failing since 100 days (last pass: v5.4.78-5-g843222460ebea, first =
fail: v5.4.78-13-g81acf0f7c6ec) =

 =20
