Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81CFB3AA747
	for <lists+stable@lfdr.de>; Thu, 17 Jun 2021 01:09:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234448AbhFPXL4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Jun 2021 19:11:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234350AbhFPXL4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Jun 2021 19:11:56 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3B37C061574
        for <stable@vger.kernel.org>; Wed, 16 Jun 2021 16:09:49 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id mj8-20020a17090b3688b029016ee34fc1b3so2748562pjb.0
        for <stable@vger.kernel.org>; Wed, 16 Jun 2021 16:09:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=JCTdAhnlQjpCcBMCaMWrElO22d2SbaHBJ+fGub5NCBI=;
        b=pgralIotWJvPbqSv6lxkUTtUQ5JzbQ+opdH3GtcxqrnQn2355OtBDDQbmMgDBb+8yi
         yr8YN32/dLlzQnj+mQvQBFplVHCb+L0h7UbImAF9zrHMG7gypHzMllQrY0mWqMZiAjjM
         bUB/nG2K+WGjkaZTMOPvtZNfNeApbtSDOSsxqWdrs6WI6Ct2ipLVfFHVo9DGrTp4+7uK
         sO2lPB3QuL9dsSaeQ3K3+VbviWWcs/CBey9Ct5GcYzIC+kCabrZD3uEdCp7HiVU8eqBT
         +WVK/NRjYADTTg5bQienPQZ3jgkYY7/XSHS8rEHsoL7pR5NVe5nZMG/c2vjEZFxXrgmS
         dSkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=JCTdAhnlQjpCcBMCaMWrElO22d2SbaHBJ+fGub5NCBI=;
        b=rfCFtXCUuKO7dFkbHzFtp6FBaXUUUgR+Z0LRKOUFRG5E2jpe7MUGui3SlA7LUwWDh+
         9mCPAvXGDqJjB4ZR0my5DA4RVh7oKAEGll1wyfbItec59BuA8f6q0zagDQ2yr/XVQryl
         k/TdsZfFca1yb+MwzgPXv0eV2DfwhwgNiNqQZxXha0gHSIlDAfTpRz5Mwqtu5zFKkJhq
         ag694lMNspJYO346l+AtKVELZnOQ9Tr/UW05gOskvoNN7rz1uKOiYNl3H3ToCsZsvYup
         Hb41Hg7HM64muirBLzuMDsTdl9CenfNSjP+n3O74wO+w8luX2g3fSQPQzQk3SagXoXeu
         cnlQ==
X-Gm-Message-State: AOAM530/nUoi7ZYi6Z0NkQ+ZdiMV3SmGOPjqqVgjts6nZTKW6Zz+rFCc
        xhAyuwdiwhFhww75QqLwoXpb2LRqTt/QMqZS
X-Google-Smtp-Source: ABdhPJxSsHAKtTMb5Ber84EV0Xy1LwMc6sgDclr+v7j9Un+HzLR0rjeLrQ/QzvCZo5QkXxQgWLUBDw==
X-Received: by 2002:a17:90b:4c8c:: with SMTP id my12mr2341799pjb.13.1623884989066;
        Wed, 16 Jun 2021 16:09:49 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id p24sm3199885pfh.17.2021.06.16.16.09.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Jun 2021 16:09:48 -0700 (PDT)
Message-ID: <60ca84bc.1c69fb81.aa508.995e@mx.google.com>
Date:   Wed, 16 Jun 2021 16:09:48 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.10.44-37-g06c9df4e43ff
X-Kernelci-Branch: queue/5.10
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.10 baseline: 85 runs,
 1 regressions (v5.10.44-37-g06c9df4e43ff)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 85 runs, 1 regressions (v5.10.44-37-g06c9df4=
e43ff)

Regressions Summary
-------------------

platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.44-37-g06c9df4e43ff/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.44-37-g06c9df4e43ff
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      06c9df4e43ff20d3907dd044b403ca28f8135a34 =



Test Regressions
---------------- =



platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/60ca546b62ab6bf40241327f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.44-=
37-g06c9df4e43ff/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.44-=
37-g06c9df4e43ff/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ca546b62ab6bf402413=
280
        new failure (last pass: v5.10.44-38-g409534680574) =

 =20
