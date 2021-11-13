Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6295044F4DF
	for <lists+stable@lfdr.de>; Sat, 13 Nov 2021 20:26:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235918AbhKMT3q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 13 Nov 2021 14:29:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233692AbhKMT3p (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 13 Nov 2021 14:29:45 -0500
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20CA6C061766
        for <stable@vger.kernel.org>; Sat, 13 Nov 2021 11:26:53 -0800 (PST)
Received: by mail-pl1-x634.google.com with SMTP id m24so1138966pls.10
        for <stable@vger.kernel.org>; Sat, 13 Nov 2021 11:26:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=10sX94XxlP+q6OZ9N5iIw+lHoas7Nv2B3JUtpKL+Ex8=;
        b=INQMRnkEr2SEk+BErrgFeiVuIJdzKLVcgMN8Sjo2OU2zN1ZNTrfLTo8qZt6e93+j9K
         NdEPBFrkzRcd4Nl/zjlmA9+Lp+v4gKixWYXZDnpoQ7rgKXTbwVz5OP1rCOIoJUoD/oTc
         Uc82HeD36eJGfi5J4i7UYG+tgIm/0ML/RWS5gpej67FR/7RuEOvO17JFLnNSCEb8z9fP
         VctThBVk+GJnPKLDG47BRrh/snuC8uMVxo7E+N4s/Mf5tf9k0L/4ZMfk4rtXZyZn0btm
         zA2TFztW/tMNHP2/Zf9iv8G1BR4/c7rbPV4HSn9oFqHsCqhmYwxX8+CsFxnx3dcE39Cg
         /ZmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=10sX94XxlP+q6OZ9N5iIw+lHoas7Nv2B3JUtpKL+Ex8=;
        b=ZX6pxOKrUYImbtKz21C8alD13MkpudqYVjZV3+p5fHCTWPYvpgQuMPO5kN+oBBrybT
         Fn2D/eSqv1ErddMcvJygb5+vtFyLNl7VIYq66D75gSjCj524UdDu3dhhdYBt3BmKuYrd
         69r+/hyU4Cza9AhavR10ed29n6q4jcVCzEItspW0qbVmacMDpXDC+RzMyJkWzwipUqqQ
         Rhx8Mx09Yn467zV70VCCBiNuzdLn8oxossexZ4rKM4hc9eUi9qC0N/KKtAK/KF7CGArs
         8dliq3XyaEYSdIzx6/rWfNjB/Nd2SD12hO4X5vzvVXaDvnJX7qUHvm/oXl+RlK71x4HZ
         woxQ==
X-Gm-Message-State: AOAM5328yLECi8/1x9IQha8fCvwZz38KXKDJ4CHoIr6VzbBzTJ+LYLAK
        +M66hYQfJsA7W9FPjp61B8rGvqyRtRNzUqTe
X-Google-Smtp-Source: ABdhPJzPOLBbpqxY8KZwvMY2RIoQVoof9bVLLN+85rQdjPuU0RsRK9JlXfCJg1HAHKvItVdJAR/nkw==
X-Received: by 2002:a17:903:2288:b0:141:e76d:1b16 with SMTP id b8-20020a170903228800b00141e76d1b16mr19183163plh.21.1636831612431;
        Sat, 13 Nov 2021 11:26:52 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id t4sm10446644pfj.166.2021.11.13.11.26.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 13 Nov 2021 11:26:52 -0800 (PST)
Message-ID: <6190117c.1c69fb81.95f7c.cdcb@mx.google.com>
Date:   Sat, 13 Nov 2021 11:26:52 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.14
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.14.18-136-g1cdf1d1a9a04
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.14 baseline: 203 runs,
 1 regressions (v5.14.18-136-g1cdf1d1a9a04)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.14 baseline: 203 runs, 1 regressions (v5.14.18-136-g1cdf1=
d1a9a04)

Regressions Summary
-------------------

platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.14/ker=
nel/v5.14.18-136-g1cdf1d1a9a04/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.14
  Describe: v5.14.18-136-g1cdf1d1a9a04
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      1cdf1d1a9a04f90c46d5e523c8cb35d29d2e7183 =



Test Regressions
---------------- =



platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/618fd983fffd19e1333358ef

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.18-=
136-g1cdf1d1a9a04/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beag=
le-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.18-=
136-g1cdf1d1a9a04/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beag=
le-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/618fd983fffd19e133335=
8f0
        failing since 20 days (last pass: v5.14.14-64-gb66eb77f69e4, first =
fail: v5.14.14-124-g710e5bbf51e3) =

 =20
