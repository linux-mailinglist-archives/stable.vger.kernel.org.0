Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9332735B0C2
	for <lists+stable@lfdr.de>; Sun, 11 Apr 2021 01:19:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234965AbhDJXTT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Apr 2021 19:19:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234874AbhDJXTT (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 10 Apr 2021 19:19:19 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDFBEC06138A
        for <stable@vger.kernel.org>; Sat, 10 Apr 2021 16:19:03 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id m18so2237546plc.13
        for <stable@vger.kernel.org>; Sat, 10 Apr 2021 16:19:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=kh4kOUEnvhoop7j0o5lYGiKDf20hyxPJZ04/9yhOWYs=;
        b=izro+3ngjPNUwIyhxk0sxX4G6kG92YSoNO3PUOiv9bcdS5bg8u6CGLnkr8Xkhg1i/V
         gcsWqFWTz3AYIFHabglfj6qNeCLa5a35graz1rLXl7HxyHx9UeJCYVnjzPTbqG6qszlW
         qVYkx/9L1fXP/wt3hqPKpiQPxK+zhuVSyT5KuYjt4GcsvWWAStz0/QVh9p8N5d/qoq9i
         SUw6u5ptT6uNvNJWoJlT5wl99bw+eZOAyqn2QltkGKX6X1Tw6Vz8l9WhZNlRSXGOKMXz
         /eRZY1pZJteu35iNyCvCjFJkqGufsG6RBTjdskIw1B6WZ4f/ZrSii+Slwzzu91vGYhE0
         5r+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=kh4kOUEnvhoop7j0o5lYGiKDf20hyxPJZ04/9yhOWYs=;
        b=lDzU2GWeDhsAi18UuxqrjLyPGBaRBACSpw05x2iYhgdrBjUJRi6AqozdNMnNROy9N8
         4hHGxtvo4oDqDBZfOQnbfuZ+x7X+uMQK4Sog38FaqWc2NDpGCXxIvUij60ASza1s0nSk
         llO4V17nWH+2D8tjbuj9BlQle6tPfrvrHFG5+aK8ahGAEqa4zc4Sayola4Po6E1UC44W
         xkT3AbOYijyQaa00L/e8hyqcpg6XfuiYqU1BoU/WLX5Jdq1Xeb8sSGPE3AZxxqun9NqK
         KGxWP3THcJ+HHBFk5FPPNuXLsRyJ+Kllglg/rcRvryQeGm1+r2GGnNO4NkBM+AySdHI4
         pc3g==
X-Gm-Message-State: AOAM532dWlWLmu/HrINYmEylnu+p+Kn3nR7LsNdDGO9g3SNfvAdywJlB
        ymnwxhMg1K4t13B50p+JG7Ck/T1w6N6nLDHF
X-Google-Smtp-Source: ABdhPJwTOf2KRAWAuKyJtwbPglwzgM+jn22+sYU4V1fL8jujkWnK7q3Qqv3gwsfXnxxAoIesQa5l8Q==
X-Received: by 2002:a17:902:5581:b029:ea:adba:db12 with SMTP id g1-20020a1709025581b02900eaadbadb12mr7932674pli.34.1618096743233;
        Sat, 10 Apr 2021 16:19:03 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id a3sm5418420pjq.36.2021.04.10.16.19.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Apr 2021 16:19:03 -0700 (PDT)
Message-ID: <60723267.1c69fb81.4de50.ceb7@mx.google.com>
Date:   Sat, 10 Apr 2021 16:19:03 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.10.29
X-Kernelci-Branch: linux-5.10.y
X-Kernelci-Tree: stable
Subject: stable/linux-5.10.y baseline: 157 runs, 1 regressions (v5.10.29)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.10.y baseline: 157 runs, 1 regressions (v5.10.29)

Regressions Summary
-------------------

platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.10.y/kernel=
/v5.10.29/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.10.y
  Describe: v5.10.29
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      d8cf82b410b4be8a1266c10d05453128bd40d03a =



Test Regressions
---------------- =



platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/6071fe53ae41d2e6eadac6df

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.29/a=
rm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.29/a=
rm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6071fe53ae41d2e6eadac=
6e0
        new failure (last pass: v5.10.28) =

 =20
