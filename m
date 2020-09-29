Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 908FB27D7E6
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 22:19:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728664AbgI2UTB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 16:19:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727761AbgI2UTB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 29 Sep 2020 16:19:01 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76EEDC061755
        for <stable@vger.kernel.org>; Tue, 29 Sep 2020 13:19:01 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id o20so5766016pfp.11
        for <stable@vger.kernel.org>; Tue, 29 Sep 2020 13:19:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=t7zW6tkauoTTd3VG7KkofXzBM5YczZrm7u+LrwN8WwY=;
        b=qAKH7UfdAY5oZwkzb1kY8kw3oGLbL4Rbnti53kNIfkXmSaWYMwrI7DNDz1LNw8k8+l
         vW/VrlbeKekhCslBqweosS190eJ/RJOXUZ6eMg1prt3NRjnqUnZTV7tYrmD4QbkrbuMq
         9YXv5PfFIjP+9CCu+ugjh9aQYwOxBe2vKHaiWKEay7cNB222VlwgdxxOrlMLLAaf6K3F
         DWJKGZ4j4JP0cxu0iq5En4HKuSqEwOCtjJXwB5KwJjzjaMTsTJCN67X31+reNIguARtU
         5xzRptvVcR5iljxPYtPT+JIqxbMnDD2Crr44Q4cMV7LCRromUnvSyMvwzmNRamtIbBCY
         fveQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=t7zW6tkauoTTd3VG7KkofXzBM5YczZrm7u+LrwN8WwY=;
        b=GjZWw/3p2DII7T4yIbGyXrIfdGzMrYpVTJn7jGOE+t/XJAYb8unlRXxwYLwBj4Lh7b
         ND9tkKGNCWfnBqErvi3wHQPh6FR80xeNU859qGrVG7eyh0snIlrXoCyr39dHUXv5goCU
         mPNZtOhHTeBUyqEvQ9Og2fwpcRuxbfzMFuDfo9eEDLc4yrXnCCI1QcdmNVbRo7cC0AHp
         88W7lBOxJ2lhrGvXHQhoekxJcaeRrY/wnbHoSZlPKprf/KnaQ9R6zKQD+zm3dqmaRKAl
         TyYpfylEapmW51bKxpgQbiiP7UkmDpQ4HDTVNVT2Qq2oTOuwCjIm2FyYLCgHOa3UyyUt
         VSCQ==
X-Gm-Message-State: AOAM531LlybcLKWjebCCo7d5LoVpY4qdS6Sqyvw+tfiguRSc3lHUnbJV
        hcF2CpdBDRppfRhv4RfyPBoaRa0g0jfTEA==
X-Google-Smtp-Source: ABdhPJy2ceetls4ixUeo7hXdPmmIxTvtS0sOY/d9U2oAWBc5qAAZ8lo/4TRl1+VV7aORxCd0NzscOA==
X-Received: by 2002:a05:6a00:1507:b029:13e:d13d:a13c with SMTP id q7-20020a056a001507b029013ed13da13cmr5499095pfu.36.1601410740693;
        Tue, 29 Sep 2020 13:19:00 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id c201sm6681705pfb.216.2020.09.29.13.18.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Sep 2020 13:18:59 -0700 (PDT)
Message-ID: <5f7396b3.1c69fb81.6fc51.dda2@mx.google.com>
Date:   Tue, 29 Sep 2020 13:18:59 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.19.148-245-g78ef55ba27c3
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.19.y baseline: 143 runs,
 1 regressions (v4.19.148-245-g78ef55ba27c3)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y baseline: 143 runs, 1 regressions (v4.19.148-245-g78=
ef55ba27c3)

Regressions Summary
-------------------

platform              | arch | lab          | compiler | defconfig       | =
results
----------------------+------+--------------+----------+-----------------+-=
-------
at91-sama5d4_xplained | arm  | lab-baylibre | gcc-8    | sama5_defconfig | =
0/1    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.19.y/ker=
nel/v4.19.148-245-g78ef55ba27c3/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.19.y
  Describe: v4.19.148-245-g78ef55ba27c3
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      78ef55ba27c378ac3e6106230e18472fc48e6851 =



Test Regressions
---------------- =



platform              | arch | lab          | compiler | defconfig       | =
results
----------------------+------+--------------+----------+-----------------+-=
-------
at91-sama5d4_xplained | arm  | lab-baylibre | gcc-8    | sama5_defconfig | =
0/1    =


  Details:     https://kernelci.org/test/plan/id/5f7362d8292c98edd687717a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sama5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
48-245-g78ef55ba27c3/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-s=
ama5d4_xplained.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
48-245-g78ef55ba27c3/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-s=
ama5d4_xplained.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-2-g61393d279614/armel/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f7362d8292c98edd6877=
17b
      failing since 105 days (last pass: v4.19.126-55-gf6c346f2d42d, first =
fail: v4.19.126-113-gd694d4388e88)  =20
