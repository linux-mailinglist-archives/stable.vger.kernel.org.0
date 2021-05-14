Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4DAA3813ED
	for <lists+stable@lfdr.de>; Sat, 15 May 2021 00:50:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230462AbhENWv3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 May 2021 18:51:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230371AbhENWv2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 May 2021 18:51:28 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9A10C06174A
        for <stable@vger.kernel.org>; Fri, 14 May 2021 15:50:16 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id gm21so583741pjb.5
        for <stable@vger.kernel.org>; Fri, 14 May 2021 15:50:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=vvLTuOB3htbAVFnptot4PTXL2L7idxwc4zZhZbpGxsk=;
        b=G68kbibDUNK9VG7q1Hr+MN3c896Ffd935FqE9MC4SMXkqfiW6lnKP4xuP+hn6f4lw1
         35LpKOflr9Ojsk2mwsc7k9xiRwIoxwqnE3giRPinCr6I3/smmS7cm4Blf1YnTvIzeTHZ
         Drh95zXv6n3JLwounohguplFgdOrdvG38Gf+xRpr4yjcoF+qHoEwVIiBNi57DiAVHAcK
         TNKB4fihamS9KqDNhCv7Hf3NCHWawRLpI9F6yTMc3nnDT07BjsI3+uiwjSj3IoKxTezZ
         h4LAtR550PRMC9sixdKn/H2J38U4t6NSnSGPfZSPs5svlDBKwt+oirLrU4z0ZjakrgW6
         nz/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=vvLTuOB3htbAVFnptot4PTXL2L7idxwc4zZhZbpGxsk=;
        b=qedhkwrPwtb2yzs/QWOgH+FUVbf2T5rkNfagqQyOy1bsEe5OthcTlx4EvvvOqsBaCn
         64GS5IHfwwj91XdGSZKNXPJ78Jk3spFVRun6Mx0EhogjZ7tMMIvoNRmbRwLQIqNfR0HF
         K8HOlbkrNSO1PLTgU/XpjU6g039wg8doReALHV2rMAWne8Hu+AAllqtOOtQIo+MgXyTm
         OkpA3ZAl19SJIWD5qfZrIgT6vlDXULFneh3IXi2mIw760hHomJ7ZCiLGZBNNI9yITrQs
         AYAHTekWjTExYcmDzwmlHKvUJCHmWeeF/wvqrMWlKklsjb1kmcDFfqwB/SPf0R/okF7x
         rZsQ==
X-Gm-Message-State: AOAM5338FWJqLTvef+5FGs33t8G63ufevAMwOhnEs3kpN6VUC/atvEiv
        X2GVSecIJiT3u3D2a0h5J5CESMrLQXzOLeHY
X-Google-Smtp-Source: ABdhPJz9VM5KjrV3wdankkHX7O8UKIeBJt9KJLUGisUoMfHDGGlL64Jat3QSAXy7/bWAchV9NB9bWQ==
X-Received: by 2002:a17:902:8f81:b029:ef:9c88:2042 with SMTP id z1-20020a1709028f81b02900ef9c882042mr10218961plo.60.1621032616180;
        Fri, 14 May 2021 15:50:16 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id w14sm4975435pff.94.2021.05.14.15.50.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 May 2021 15:50:15 -0700 (PDT)
Message-ID: <609efea7.1c69fb81.d2b59.1c11@mx.google.com>
Date:   Fri, 14 May 2021 15:50:15 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.11.21-11-g31d2d8ce497c
X-Kernelci-Branch: queue/5.11
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.11 baseline: 132 runs,
 1 regressions (v5.11.21-11-g31d2d8ce497c)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.11 baseline: 132 runs, 1 regressions (v5.11.21-11-g31d2d8=
ce497c)

Regressions Summary
-------------------

platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.11/ker=
nel/v5.11.21-11-g31d2d8ce497c/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.11
  Describe: v5.11.21-11-g31d2d8ce497c
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      31d2d8ce497c7c72d79a32f16ddf2ffc444104b0 =



Test Regressions
---------------- =



platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/609ecc97f32de50c2ab3afbe

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.11/v5.11.21-=
11-g31d2d8ce497c/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.11/v5.11.21-=
11-g31d2d8ce497c/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/609ecc97f32de50c2ab3a=
fbf
        new failure (last pass: v5.11.19-941-g171a1cf2230e4) =

 =20
