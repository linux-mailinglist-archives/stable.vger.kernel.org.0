Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EC4F4016E1
	for <lists+stable@lfdr.de>; Mon,  6 Sep 2021 09:17:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239991AbhIFHQc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Sep 2021 03:16:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233040AbhIFHQb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Sep 2021 03:16:31 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FE98C061575
        for <stable@vger.kernel.org>; Mon,  6 Sep 2021 00:15:27 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id j10-20020a17090a94ca00b00181f17b7ef7so3716261pjw.2
        for <stable@vger.kernel.org>; Mon, 06 Sep 2021 00:15:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=im/brade/jhv0pVYyfdjx13uBqxYh1kpNNNYVCxnqqI=;
        b=RrsGRLS7NijFWpbwJnQN8l0c4k9OIHIxUvRQBfOP890jK+oAQKUfxT59zrzgiZqZAD
         snFi4E6dzs+keMRn0Z6y70UtYeUIxc2f1JtEVzE8GYqUPhEcyMEJrVbx+jhHUBgvFcmD
         fZsDQwmFMUd0MX5VhOgdJpuQZKM3CYH6QyUr/maiowMfu47o8z0Wp5KP2+sepDwNlKvA
         j6xdV6DFUNyh32zqoyyzG3+O1P5qcHSkMZfQGvtPzr/tn2TQ636CJW+U4I7alqexwHlH
         XECt5XK+K07E7MOnQyFKUo3RcEopqebOSwRuI41XGiZUweEaNHL7QeUGwTFvQpTNHGlx
         n51A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=im/brade/jhv0pVYyfdjx13uBqxYh1kpNNNYVCxnqqI=;
        b=cZWmQWHmVxEgews6mqtnMslvvPN0SnN+vCxPbM52+v91+M4/VlNR1DaTOvaPxHy2g+
         zN9GLKdW3VYLL7xgAhkIrbUEAIi0YoKIz3QMc5PpMKEl2bd7A463J48MPjql2tfBZ9on
         5kjJKY1oQNFcMqgaaSFtEa8BDmsmP3vVM4ikYeHHnAXNkIV1AR1dmZwSGBtVGh49AMSS
         SBW3/HaYujqVlpcsob7JjPHgxynGXTAN3iszGVE8HSJVK/sXmwVcrgs8rZ/0+OQB/JA0
         Zg6xrLbjzEkjr7m0W0PBik6Nxi5b8g5EOTg29T4CnobK70kx9RXGL4csEVw36mqJBvG2
         i5zg==
X-Gm-Message-State: AOAM530CVWaZmPGTL9HB9tPJi6VXxJ0mKVbtd946urei6m1YItWp1NU4
        YmGPqwlxAPwb9nK7Vb4E7a3he2PiQGCcc/qo
X-Google-Smtp-Source: ABdhPJxXw1r1zyTQNmwUsytFtSwExbcKdvYld61KIgP01kkbhPgoMnec7cxpPumA2WrOG+yYTGSQjg==
X-Received: by 2002:a17:90b:91:: with SMTP id bb17mr1246865pjb.232.1630912526883;
        Mon, 06 Sep 2021 00:15:26 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id a11sm7838055pgj.75.2021.09.06.00.15.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Sep 2021 00:15:26 -0700 (PDT)
Message-ID: <6135c00e.1c69fb81.82127.70b2@mx.google.com>
Date:   Mon, 06 Sep 2021 00:15:26 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.14.1-2-g1f34a835c69c
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.14
Subject: stable-rc/queue/5.14 baseline: 140 runs,
 1 regressions (v5.14.1-2-g1f34a835c69c)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.14 baseline: 140 runs, 1 regressions (v5.14.1-2-g1f34a835=
c69c)

Regressions Summary
-------------------

platform  | arch | lab          | compiler | defconfig          | regressio=
ns
----------+------+--------------+----------+--------------------+----------=
--
beagle-xm | arm  | lab-baylibre | gcc-8    | multi_v7_defconfig | 1        =
  =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.14/ker=
nel/v5.14.1-2-g1f34a835c69c/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.14
  Describe: v5.14.1-2-g1f34a835c69c
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      1f34a835c69c0523592e0afb3d59c4762b44c92a =



Test Regressions
---------------- =



platform  | arch | lab          | compiler | defconfig          | regressio=
ns
----------+------+--------------+----------+--------------------+----------=
--
beagle-xm | arm  | lab-baylibre | gcc-8    | multi_v7_defconfig | 1        =
  =


  Details:     https://kernelci.org/test/plan/id/61358d44a09d2b3612d59667

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.1-2=
-g1f34a835c69c/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-beagle-xm=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.1-2=
-g1f34a835c69c/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-beagle-xm=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61358d44a09d2b3612d59=
668
        new failure (last pass: v5.14.1-2-gbbf2e6a216c0) =

 =20
