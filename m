Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C8904134C5
	for <lists+stable@lfdr.de>; Tue, 21 Sep 2021 15:47:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233414AbhIUNtC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Sep 2021 09:49:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233099AbhIUNtC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Sep 2021 09:49:02 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FA2AC061574
        for <stable@vger.kernel.org>; Tue, 21 Sep 2021 06:47:34 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id p12-20020a17090adf8c00b0019c959bc795so2592804pjv.1
        for <stable@vger.kernel.org>; Tue, 21 Sep 2021 06:47:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Mq+YxOjMgKloxbdmkpMydBnwpKe6KegALdXhCxK0P/s=;
        b=V0Eoanso3BC8bUxKpQQdtv5Yz+H0n5aGy3YvRt6Ol7UBI6DArNRDa8HaNRZ2uiofQb
         OZnzKY7ksLC+QQdaZv8D73dem7ZeuU2JevD0O9OUEZAq4Hb/qTcU9hTdgD3PlMXkgFz6
         i7FLGvr9f7bbKey8YwYatD7AusUrowN7d0AzpER0S3Z/7xlWC8IFR2lmgqMJQxUNPB1x
         fugWPOrnGzHoUFUEGJ6DRULQ+os0BYu/LvTGWPN3te4GFlTeVcVWuBpHsPzLJFAtaFxG
         ff/Hvj/LwlgE5vpVfMtoQbJRwbAIan+5o3TlmWhpOPIvD6lh8/3e7oBbo1lG8VLYO3Ne
         e6ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Mq+YxOjMgKloxbdmkpMydBnwpKe6KegALdXhCxK0P/s=;
        b=x0tSVtnBA6PBhhQaL0S8QpCVH2t81+nr9WhmuEozBvAyFmooXmb4nBEb3WjMdtxLYs
         RLipuljA6Iy9h6nlkFY2qbT1HxJ3xf7BmqB0Qf5D3688laqMC1tn5QvcxqrNaQacNDSG
         jA0kEd12avZ3S9mPdqEY1qg0Nw20K4VU1xmsKyXRc9ye0lfoA0LI9n2WfRlNR1ldrfiT
         bK/PLg7nNVFQSJyr8dV3ITlaY30aCvmuA1H6duC+UGe80TShqYv/rEEz5BJL1EzEMu3B
         x7fCqtKCgEVqXAwMbIE7/v65oIWDFoSiIzRXddbsvP+XDpAjnz8KK5cmPKObZP+vrumV
         xQMw==
X-Gm-Message-State: AOAM533lxKFg6NsKCaO/WJN6K87vT26+vtcKEJonro8/6LJzUYSdBGb4
        +H2xg6KlTaQvm9a/DJAVEZTSsYfbpk6sKyND
X-Google-Smtp-Source: ABdhPJwWmTPGCtsgWJWydmpShRv9iGc3dgulSmXDRX3THr9jvc1/DCLPfgIwK1IXC41lkXKF4VSLzQ==
X-Received: by 2002:a17:90a:7848:: with SMTP id y8mr5310008pjl.229.1632232053245;
        Tue, 21 Sep 2021 06:47:33 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b10sm17374334pfl.220.2021.09.21.06.47.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Sep 2021 06:47:32 -0700 (PDT)
Message-ID: <6149e274.1c69fb81.5efc7.109e@mx.google.com>
Date:   Tue, 21 Sep 2021 06:47:32 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.13.19
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-5.13.y
Subject: stable/linux-5.13.y baseline: 177 runs, 2 regressions (v5.13.19)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.13.y baseline: 177 runs, 2 regressions (v5.13.19)

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


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.13.y/kernel=
/v5.13.19/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.13.y
  Describe: v5.13.19
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      f7eb8f60cadbedd31a2f39d8866b991b67434f2c =



Test Regressions
---------------- =



platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-8    | multi_v7_defconfig  | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/6149aeda980025de3399a32e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.13.y/v5.13.19/a=
rm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-beagle-xm.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.13.y/v5.13.19/a=
rm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-beagle-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6149aeda980025de3399a=
32f
        failing since 51 days (last pass: v5.13.6, first fail: v5.13.7) =

 =



platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/6149ade903b549cc6499a328

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.13.y/v5.13.19/a=
rm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle-xm.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.13.y/v5.13.19/a=
rm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6149ade903b549cc6499a=
329
        failing since 5 days (last pass: v5.13.16, first fail: v5.13.17) =

 =20
