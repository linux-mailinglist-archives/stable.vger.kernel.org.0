Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11DEF3253AF
	for <lists+stable@lfdr.de>; Thu, 25 Feb 2021 17:41:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232929AbhBYQkh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Feb 2021 11:40:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232923AbhBYQkd (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Feb 2021 11:40:33 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9553DC061574
        for <stable@vger.kernel.org>; Thu, 25 Feb 2021 08:39:52 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id t9so3828370pjl.5
        for <stable@vger.kernel.org>; Thu, 25 Feb 2021 08:39:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=8i62jWMA5vmQBcvdVG6hRADQwzksr3YPYRnSYllbytk=;
        b=uSilRByq8nkareR4IqlVh9lO5NzaxFcoPKiMJkXc8c7vY9q2WRCHKuNK2wg2mPu910
         m6WU+KBt9LRNRMXclGhXyya1II8fNK0dqyhHsHxuFKPDkJcs4jaO2e0L4ccJw0J3MJ8G
         MbNjjztGB/5arAqQF0vehO+T35HLZa8Yw/rdfNPj3jbh4CC6Z9IZ+VZ8kglvGYJGaSce
         Ibef89YSFqoy1VWBY4InllbXRPBf0AgndpRHw1MI5b/l7HJWcEv+wGjn7TtiVfaeE/C9
         LfiTyUEumn78vfY/uXIw20KBK+aVI0DP87XvsJ3nWy3ggVOsAJk0kQ4kyJqjPFBHSPEd
         d3sQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=8i62jWMA5vmQBcvdVG6hRADQwzksr3YPYRnSYllbytk=;
        b=VNJLeoDJGUOp3y93JdnPby2cEgR6QiT0Dryd8mEkaQ+ci6ja7/lt+ub/bwQDDsjDkq
         DOkLOqZJPxsks3TP5EDmqM+QxHlMijesHzVrGPv5IJ1iIH3G2Iucd4AKfV+c2Fzn0IZe
         LNSTA3tqZKkl2vQ/oI0RLa4p2fSFBHEQ7a43zwcKqk83swrmh8vpbkjM6aD1CsexlXqB
         05/CdEq2/6gA1SK8XxqyYCW982Wd2LfO7G70utlRSz3l6gveYs38irZMf+s8spS1gMNT
         6zgkWaaAhQcyDVYlXOD3NHP26Y6EkReGeayy3DjZ6qWJEdfKf7U9FOk6lrWv2qR1Z+fI
         2e3A==
X-Gm-Message-State: AOAM530D2SjioTZm5gAjcjiBbYFH60qwGL5xUfXr1QV58oR45Dpu8FXi
        14QNL9sP81gCn/p7oJrT4U3tMJiqGmR+9w==
X-Google-Smtp-Source: ABdhPJz2DCVMJGYTcj2psZkR1sBWb6z0KUnsu2JofD3b9+J2hMBq2dsG+7UCGHFhvD5aYI0efKo3QQ==
X-Received: by 2002:a17:902:b212:b029:df:ec2e:6a1f with SMTP id t18-20020a170902b212b02900dfec2e6a1fmr3801704plr.24.1614271191988;
        Thu, 25 Feb 2021 08:39:51 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id r15sm7012776pfh.97.2021.02.25.08.39.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Feb 2021 08:39:51 -0800 (PST)
Message-ID: <6037d2d7.1c69fb81.453c1.f17d@mx.google.com>
Date:   Thu, 25 Feb 2021 08:39:51 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.222-8-g501fe90c361cf
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.14.y
Subject: stable-rc/linux-4.14.y baseline: 64 runs,
 2 regressions (v4.14.222-8-g501fe90c361cf)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y baseline: 64 runs, 2 regressions (v4.14.222-8-g501fe=
90c361cf)

Regressions Summary
-------------------

platform        | arch  | lab          | compiler | defconfig | regressions
----------------+-------+--------------+----------+-----------+------------
meson-gxbb-p200 | arm64 | lab-baylibre | gcc-8    | defconfig | 1          =

meson-gxm-q200  | arm64 | lab-baylibre | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.14.y/ker=
nel/v4.14.222-8-g501fe90c361cf/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.14.y
  Describe: v4.14.222-8-g501fe90c361cf
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      501fe90c361cfb86207ff5bea032fd7ba729c716 =



Test Regressions
---------------- =



platform        | arch  | lab          | compiler | defconfig | regressions
----------------+-------+--------------+----------+-----------+------------
meson-gxbb-p200 | arm64 | lab-baylibre | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/6037a078c6effdf873addcc2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
22-8-g501fe90c361cf/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-=
p200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
22-8-g501fe90c361cf/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-=
p200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6037a078c6effdf873add=
cc3
        failing since 331 days (last pass: v4.14.172-114-g734382e2d26e, fir=
st fail: v4.14.174-131-g234ce78cac23) =

 =



platform        | arch  | lab          | compiler | defconfig | regressions
----------------+-------+--------------+----------+-----------+------------
meson-gxm-q200  | arm64 | lab-baylibre | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/6037a5479ab0ae8501addcb4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
22-8-g501fe90c361cf/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q=
200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
22-8-g501fe90c361cf/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q=
200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6037a5479ab0ae8501add=
cb5
        failing since 14 days (last pass: v4.14.220-31-gc7c1196add208, firs=
t fail: v4.14.221) =

 =20
