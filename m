Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 427E7414F89
	for <lists+stable@lfdr.de>; Wed, 22 Sep 2021 20:02:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236837AbhIVSDu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Sep 2021 14:03:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236815AbhIVSDt (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Sep 2021 14:03:49 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98BD5C061574
        for <stable@vger.kernel.org>; Wed, 22 Sep 2021 11:02:19 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id bj3-20020a17090b088300b0019e6603fe89so1524755pjb.4
        for <stable@vger.kernel.org>; Wed, 22 Sep 2021 11:02:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=oaWJ83c08JaQVrEfc8fs4FBw0m9F7viqLkqTcd5aPQo=;
        b=RN2kokZk3ZKaZ9Fj3VUUpYwLVasHMfx2xXFMbNMXGBIauStAs//rKIvRldn9oysfkl
         TRWYzffM6nLBO9ImaI5641PUfCDPLx6viJvqV/uNduIChuMi50VZ2b+N+nKZmq+XAudN
         dGOHbOSOVC4O86Qa8EeCU/gYaOmwh3Apj1uTp7LknBF11p942CDNqVfDzwVb+YY8dqz9
         e2RxwNzIjjHtZ2Do09QKAlb0KuWiTiasPRLmITqVVAVFYGlK+7KzQQdzTOuxBcz2YtiN
         1/ZWSjmp9oAJ/qmSx+onSRwIoGikAT9Kxb43L77eRpd3/GNPSSyZilYuBd51YbUDlYnZ
         A7rA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=oaWJ83c08JaQVrEfc8fs4FBw0m9F7viqLkqTcd5aPQo=;
        b=3i86xbCZse2PFVdq0Oy9Rof6sjmN/vPMMAnJXzgjWT36Og89s6E4K6pmTbV0X7gZgW
         ML+qa4xVXah6KzX4qtrMrlRFwlPBiQz7bHaU6ZScBsheicTNXEaXa3apavVWGGN3o9iW
         EfctF5LPds22X3yQoZum0/tE/boPJijXwQRNlbnKEOf+0xnh/Lp7wqPgYS/1m5aboBie
         Kg2Jlogw9FjivUQr2AAP56dPLTndH0h9PptMhUGOnJXb0KXLOlhK63sYx8cu15Eyw1I7
         ou36D+R0P4z7NpqG9QYubu9vwHfLFI5bc7YsFNgYn+XkVFQ95UfBeIYopTNhkFaLRews
         imUQ==
X-Gm-Message-State: AOAM530/2KILZXIU5bIFyndJ2LFnj5NGwyd8tPncB5I20mBvX0Ss97wH
        6OcPULPVaFimm66HYVbCma0gQj/+liMP6x6U
X-Google-Smtp-Source: ABdhPJwkZXg4Fc9lKFtAE8ckZ5NuxndAFBnQcx5IQrk33DyV8Zp8a5zNn8bNuGUdv/E7tIK9oOURjg==
X-Received: by 2002:a17:90a:7301:: with SMTP id m1mr368299pjk.164.1632333738988;
        Wed, 22 Sep 2021 11:02:18 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y25sm3212274pfe.28.2021.09.22.11.02.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Sep 2021 11:02:18 -0700 (PDT)
Message-ID: <614b6faa.1c69fb81.f054c.860c@mx.google.com>
Date:   Wed, 22 Sep 2021 11:02:18 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.14.6-174-gc4109bf2a31f
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.14
Subject: stable-rc/queue/5.14 baseline: 124 runs,
 1 regressions (v5.14.6-174-gc4109bf2a31f)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.14 baseline: 124 runs, 1 regressions (v5.14.6-174-gc4109b=
f2a31f)

Regressions Summary
-------------------

platform  | arch | lab          | compiler | defconfig          | regressio=
ns
----------+------+--------------+----------+--------------------+----------=
--
beagle-xm | arm  | lab-baylibre | gcc-8    | multi_v7_defconfig | 1        =
  =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.14/ker=
nel/v5.14.6-174-gc4109bf2a31f/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.14
  Describe: v5.14.6-174-gc4109bf2a31f
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      c4109bf2a31fff3c508fb645aa8b396b9b4a5087 =



Test Regressions
---------------- =



platform  | arch | lab          | compiler | defconfig          | regressio=
ns
----------+------+--------------+----------+--------------------+----------=
--
beagle-xm | arm  | lab-baylibre | gcc-8    | multi_v7_defconfig | 1        =
  =


  Details:     https://kernelci.org/test/plan/id/614b390276719efee599a2e0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.6-1=
74-gc4109bf2a31f/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-beagle-=
xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.6-1=
74-gc4109bf2a31f/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-beagle-=
xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/614b390276719efee599a=
2e1
        failing since 0 day (last pass: v5.14.4-395-ga49a6c3da2c6, first fa=
il: v5.14.6-170-gb1e5cb6b8905) =

 =20
