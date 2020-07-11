Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4359E21C1E1
	for <lists+stable@lfdr.de>; Sat, 11 Jul 2020 05:27:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726709AbgGKD1r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Jul 2020 23:27:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726707AbgGKD1r (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Jul 2020 23:27:47 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCD20C08C5DD
        for <stable@vger.kernel.org>; Fri, 10 Jul 2020 20:27:46 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id z5so3369964pgb.6
        for <stable@vger.kernel.org>; Fri, 10 Jul 2020 20:27:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=UKYj04MuH1gOMcUIolhG0u5e4TomQViGyTq+TUFYQQs=;
        b=Lpa5mKbQ6djGpzP+OTBQGmYS1w1tubCntlAfdtcu7PVTG801/1GHqPulbrKUgiuxSi
         0jMI2NMiGU/k0ERe2hhSd6VdoTAAcK35oioH5PKUe2sXz5lfZdZqLuMdDab0X9CU4XTc
         11SfxEqZSpmMkPvpfL+jsmHJCJ1qBI3pz31Rqiixdi32tsWygKA11BWZuVtsswOAdPEg
         fuXTJvOerjQRG0r7BfGavsGILvGaJZkLefCAUCoI1BGPjxWdFpbHypW2mmtMoVYySHQN
         9kEPm37IUrpaB5YlweB0rpkZBizmld0+0CEeoZEi/3Q5LBcTnc4szpXCcHHL/6LGCBMP
         WIZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=UKYj04MuH1gOMcUIolhG0u5e4TomQViGyTq+TUFYQQs=;
        b=YP9Jp26XNT2gUlILxqiVTdZ9SJJTbJbSS4QKp5DEXrOFbgINiza+HKtFtrCBhkoA/v
         tWIoXqY2mC1y9rJ6uUQSj28bz6FjTiCXvNW/R2wbes2MpbgMl38GN8UCtnDPMgBZ4qxf
         ZLbtAxaTvXEWDf5RPPFnBHL5S3lL/ubv+udiY0E9It9zvGV3Bdu5oBopIHcJHTzjLy7j
         3e7GOW5KFxIyMd3BQLP91VlRPUI5nINBGg5846uGLpaJTvfNgfsZDTSWNNX1EULFkslA
         xvb62pSDAF6G6Jr3mq65xOOi6KYRGYUATENjBVIrUHW7FY1lOaWAku+58fYUqP/uacmG
         ZSHg==
X-Gm-Message-State: AOAM532T3iHef4uxo+LXWYYsxqtVckWepPp4g3WP/HxbkP8iiPYDZ8Gj
        7h7ZgT0J94IF4q2lJarssIzmKlZZZ6A=
X-Google-Smtp-Source: ABdhPJxY27A4zoHB+ZPqqVZUYLFdfewgPba5bM6YkkFUvPLK8eWExzWDswCNTYn1RLDOHPZFkUz7wQ==
X-Received: by 2002:a65:5c88:: with SMTP id a8mr26637367pgt.215.1594438064850;
        Fri, 10 Jul 2020 20:27:44 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 191sm7069204pfw.150.2020.07.10.20.27.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jul 2020 20:27:44 -0700 (PDT)
Message-ID: <5f0931b0.1c69fb81.8d274.2638@mx.google.com>
Date:   Fri, 10 Jul 2020 20:27:44 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.188
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.14.y
Subject: stable-rc/linux-4.14.y baseline: 72 runs, 1 regressions (v4.14.188)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y baseline: 72 runs, 1 regressions (v4.14.188)

Regressions Summary
-------------------

platform        | arch  | lab          | compiler | defconfig | results
----------------+-------+--------------+----------+-----------+--------
meson-gxbb-p200 | arm64 | lab-baylibre | gcc-8    | defconfig | 0/1    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.14.y/ker=
nel/v4.14.188/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.14.y
  Describe: v4.14.188
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      56dfe6252c6823c486ce4b1a922d72abc7e3c6b1 =



Test Regressions
---------------- =



platform        | arch  | lab          | compiler | defconfig | results
----------------+-------+--------------+----------+-----------+--------
meson-gxbb-p200 | arm64 | lab-baylibre | gcc-8    | defconfig | 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f08f975ae00d04f6785bb1f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.1=
88/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-p200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.1=
88/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-p200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2019=
.02-11-g17e793fa4728/arm64/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f08f975ae00d04f6785b=
b20
      failing since 101 days (last pass: v4.14.172-114-g734382e2d26e, first=
 fail: v4.14.174-131-g234ce78cac23) =20
