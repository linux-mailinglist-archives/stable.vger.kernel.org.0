Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C246445D74
	for <lists+stable@lfdr.de>; Fri,  5 Nov 2021 02:45:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231543AbhKEBrr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Nov 2021 21:47:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231186AbhKEBrr (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 4 Nov 2021 21:47:47 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B07A3C061714
        for <stable@vger.kernel.org>; Thu,  4 Nov 2021 18:45:08 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id np3so2057653pjb.4
        for <stable@vger.kernel.org>; Thu, 04 Nov 2021 18:45:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=NDq9ksAah5z8G2XHhELD4kdrkFHlqQpZaC3SAJP6edI=;
        b=QOtu8Zy/UHgBZyScjeeJffaFcODhf88NxFlLPSvPiYcHvNhSzqCpLtxD+v7ly7ismB
         pBP0oZmwOpqS0mvAKnYcXDmq/LHGTujl+a2BqYKbiwz7CiXzxbh9olmYEfPEbCVLPQZt
         kEsht3jVOcpt689uP+EhhoiMsSLQCCE2D9piczAn2d+hawAqvZPYZ3nyuJishKFt50wp
         vNk4CQ4m/sUmKWtCVtwejRC85/YPRr/bP348rE0y8JIbsVbdgaxssFh/b+cpIvWyZ0kI
         5Pb2FDywsAZBIScpXsLWpAiJDDmkSmiYDIcagTmJYuRU9kdqTuI2jSePyL61655bpbeN
         HarA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=NDq9ksAah5z8G2XHhELD4kdrkFHlqQpZaC3SAJP6edI=;
        b=NVVNkIwehi4Ov7lzaWt+Vlet2dsWrhn9fPM4+lh8T/HlM74xs4mc0dZSDNa7NOsovj
         4eqjgtrfFNzQkpps299twCgAAxjNa2rAVRXorcyFtR6xkuemDw2s4WU0h93ptw+8nxMV
         jJzTZYGcu9CUe80aZ8ANk0E34/jyXG0XCvNNVpI/G3f476Hyz1WAlmDn972sdkmSVSt4
         6aIfNapCGUhPrN29MPTHeI8cr9cWZpgHKiSHZLaU7u23+qaCGMWt/1ZSHNqmmyzb58Zc
         Fle+wUGp93ljpC3csXM+zStTgDvfgNdmDViUWh3igJ81YqIxyH7gVn0el9KLk8KuQRZb
         aiIg==
X-Gm-Message-State: AOAM531T0NO9UuojFVoPnFQ46kh9lYk+DDwEIs/lKfApq8c5DRcjPOvM
        YiJbf35lWdrU0tQEFOrawUXWd78DWGBEkObF
X-Google-Smtp-Source: ABdhPJwYP70CnMo8E0Z3b8KXwTR0iwSITh7wFUPLDybzSBzobIpitM7Ggk+bTGXQt8Rtt5wKzDv6Aw==
X-Received: by 2002:a17:90a:e395:: with SMTP id b21mr25849111pjz.103.1636076708122;
        Thu, 04 Nov 2021 18:45:08 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id q10sm4682273pgn.31.2021.11.04.18.45.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Nov 2021 18:45:07 -0700 (PDT)
Message-ID: <61848ca3.1c69fb81.d64be.023b@mx.google.com>
Date:   Thu, 04 Nov 2021 18:45:07 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.15
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.15-12-g0f4d1afcebee
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.15 baseline: 140 runs,
 1 regressions (v5.15-12-g0f4d1afcebee)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.15 baseline: 140 runs, 1 regressions (v5.15-12-g0f4d1afce=
bee)

Regressions Summary
-------------------

platform                | arch  | lab        | compiler | defconfig | regre=
ssions
------------------------+-------+------------+----------+-----------+------=
------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe | gcc-10   | defconfig | 1    =
      =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15-12-g0f4d1afcebee/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15-12-g0f4d1afcebee
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      0f4d1afcebeec60e8dbfc78c05d607bc268e25df =



Test Regressions
---------------- =



platform                | arch  | lab        | compiler | defconfig | regre=
ssions
------------------------+-------+------------+----------+-----------+------=
------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe | gcc-10   | defconfig | 1    =
      =


  Details:     https://kernelci.org/test/plan/id/61845aa9481a176ef43358f9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15-12-=
g0f4d1afcebee/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-bananap=
i-m64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15-12-=
g0f4d1afcebee/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-bananap=
i-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61845aa9481a176ef4335=
8fa
        new failure (last pass: v5.15-12-g7601384ac4b3) =

 =20
