Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2851415058
	for <lists+stable@lfdr.de>; Wed, 22 Sep 2021 21:07:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237156AbhIVTJX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Sep 2021 15:09:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236431AbhIVTJX (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Sep 2021 15:09:23 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23B3EC061574
        for <stable@vger.kernel.org>; Wed, 22 Sep 2021 12:07:53 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id k24so3729621pgh.8
        for <stable@vger.kernel.org>; Wed, 22 Sep 2021 12:07:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=GQQ+uMxW1h0uvsHfnQP2C301FVKtgVedD0Z1u2nm7N4=;
        b=T5A9wmytqbMT2ECk0BFoUnR7G7LJts+O7TsTT5n8vjP7q84+BfPI8NJn8BHdQz07hw
         k/G1iJKJuOBoCX4cns79RpIukZK4KjdGrEb35E6MFWn5IbOupocopQdK6gjRKbXhEZqf
         m9VpaQxQ1GqlQvlp76eQeVe4L274WFIPIR+sQ8KYSaHz7h6Im/Dp3c9e+X9iGT4j71sC
         ehryh50yZdafYWp8SWUvjgPlwGXDSxBJrH6T8CSfWIOmXM0oa/TrrYupQLz6x/vrE+NZ
         afFE2ppTkMcnQ+DJWNsJZkdzKBWP4bVgUsjNEW/8XTQ8rzWqRo2ySesAolrjPci7IQT8
         wDxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=GQQ+uMxW1h0uvsHfnQP2C301FVKtgVedD0Z1u2nm7N4=;
        b=u1d6RaY78SrKYiQDQ5DLziL9UIBnH9+iC5oE1X58qqHUdB5fDTM9H3EWJYXKpJjMdc
         bTaQvCfX9AHvL8qoRQL0uNie3GsFakFwgroVWDYWvDRtx5d85F6P6N8Kirc76pd8xDLc
         eaqcr8xUAM/iYNt6DGE5G8OKsvATSAOPztLk/h4lHq+8vzVUxCzIRbUENWI8q5jzyHVP
         PjUx1PJANabLVUI+M0YuT+iLYTy+Zn92lc3qNzj9JCZkc7nbXPVcR1bibayHYLnFw2Vo
         RlIwoBUb+g0wtvreembbrfx42jAVh8PRs3bptkrUvXNnpBE73+NC2CY5JgHRayW3mUOq
         jGJw==
X-Gm-Message-State: AOAM5305Udbwug01kASmEHH9/8FDeKJCjplvyiGEn9vR1H81hlq30Kax
        wZODTQijoG7xFaqceY7LorS4pdAHcLAZlI0A
X-Google-Smtp-Source: ABdhPJycIKmbB9lSS+9q4MfxGO/4rqmh7ifxN7TswaQEBLHMaLhU2MYrTo6QGzlbh1ed5Iuvjj0KGw==
X-Received: by 2002:aa7:9a01:0:b0:444:d6b1:352d with SMTP id w1-20020aa79a01000000b00444d6b1352dmr652899pfj.45.1632337672502;
        Wed, 22 Sep 2021 12:07:52 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id u24sm3492255pfm.27.2021.09.22.12.07.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Sep 2021 12:07:52 -0700 (PDT)
Message-ID: <614b7f08.1c69fb81.404ef.9aa7@mx.google.com>
Date:   Wed, 22 Sep 2021 12:07:52 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.14.7
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-5.14.y
Subject: stable/linux-5.14.y baseline: 139 runs, 2 regressions (v5.14.7)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.14.y baseline: 139 runs, 2 regressions (v5.14.7)

Regressions Summary
-------------------

platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-8    | multi_v7_defconfig  | 1       =
   =

beagle-xm | arm  | lab-baylibre | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.14.y/kernel=
/v5.14.7/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.14.y
  Describe: v5.14.7
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      56c0ace445bd3aad9b2bee1e9d54cffe37f22205 =



Test Regressions
---------------- =



platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-8    | multi_v7_defconfig  | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/614b49835d4a53703399a2e8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.14.y/v5.14.7/ar=
m/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-beagle-xm.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.14.y/v5.14.7/ar=
m/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-beagle-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/614b49835d4a53703399a=
2e9
        failing since 10 days (last pass: v5.14.2, first fail: v5.14.3) =

 =



platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/614b47c9f6375184f199a2e1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.14.y/v5.14.7/ar=
m/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle-xm.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.14.y/v5.14.7/ar=
m/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/614b47c9f6375184f199a=
2e2
        failing since 10 days (last pass: v5.14.2, first fail: v5.14.3) =

 =20
