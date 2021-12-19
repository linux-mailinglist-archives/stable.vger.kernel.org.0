Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AE0447A014
	for <lists+stable@lfdr.de>; Sun, 19 Dec 2021 10:49:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235507AbhLSJtE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 19 Dec 2021 04:49:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229585AbhLSJtE (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 19 Dec 2021 04:49:04 -0500
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D418C061574
        for <stable@vger.kernel.org>; Sun, 19 Dec 2021 01:49:04 -0800 (PST)
Received: by mail-pl1-x633.google.com with SMTP id c6so5696104plg.3
        for <stable@vger.kernel.org>; Sun, 19 Dec 2021 01:49:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=0tW7pSD1b9BjkgJIzt1sC3g+0W9ziZ5nFib4825WODk=;
        b=3xhFqVhvvl/hiBqjUqLDt0uXWHSAFQternLzvjBJnh/JKaAQkb8JNVe+e/FTficK3w
         UUjWjp63+r/cvtDyxdrJpkgccvWAZEkYU6BHLMMD3KEBenvtXS7GS6E+KOLLYcAPmowz
         x51qZ4Zo2DagJjo/yzckZuIGkB6OF/Vtbg77rd7Ys8lKBekbv8nZtlZ+rKRJMbSCWsFP
         5PNKTR3v6bWIw2B0sLFtPTiimdJMQs8bjFoZ8tREDGS4+p/WUjUjhq8ho5Vv2q4ksEU2
         h+ESMbe7ATEXuLXgkHAmESEpyf6s5XbUnNm+pzJ79nmywqhJwkPqLlngw8gmvzt62PeQ
         nyAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=0tW7pSD1b9BjkgJIzt1sC3g+0W9ziZ5nFib4825WODk=;
        b=2XGR9/sqEePHwf3h+TB5mFuvdJki58FxpjfqdWfYOGcD0kHIc6yK4Rr1FIU0qqsfii
         ttAqXP0B/dHis5dxkxar8EtO3UbwX8fYBWNZA3+0c9BX9RboOhj/23m9JfMMp/PeKwXy
         ZL1O/0zqn2Aovp7FTrhTeyJgEjQwoYMEzbBLrhHW77Uqjty1z/iVbaQQmpWvpVIDDlvR
         Qjq/w9zu+ao+xDFSi+ZTeFYgNn6q9OEZ7PHrMDrOfAnslKjSdpH3jLq9USbwqZQCRzuM
         cvxvTIrNPEr90znNTGhE7cG5KgeUC5Q328BXZ5w4k92fmqlH2i+mtw5/3WlrXDq6VDEm
         Tohw==
X-Gm-Message-State: AOAM530O0yetPtx8a6I+9KFRjnvYKfhi6VEAxVsChtn1OIE4MRv3WMwM
        L4CJ+HMGum11MThICm0lsAvcj/cl4Jf2KSSb
X-Google-Smtp-Source: ABdhPJwskZtFRsZcUedKt4ITXJCzPN9u5AED0nZ5SURx5GiUNCwScc8/lqmU5ARF6KskVhFtIvh5ww==
X-Received: by 2002:a17:90a:5d8e:: with SMTP id t14mr22035004pji.95.1639907343552;
        Sun, 19 Dec 2021 01:49:03 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id o7sm13976120pjf.33.2021.12.19.01.49.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Dec 2021 01:49:03 -0800 (PST)
Message-ID: <61bf000f.1c69fb81.207a.652b@mx.google.com>
Date:   Sun, 19 Dec 2021 01:49:03 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.10.87-63-g1b969379182f
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/5.10
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.10 baseline: 197 runs,
 1 regressions (v5.10.87-63-g1b969379182f)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 197 runs, 1 regressions (v5.10.87-63-g1b9693=
79182f)

Regressions Summary
-------------------

platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
n...6-chromebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.87-63-g1b969379182f/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.87-63-g1b969379182f
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      1b969379182f637b7667fd680e580c24e9d04722 =



Test Regressions
---------------- =



platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
n...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/61bec6f09500a5e15e39713a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.87-=
63-g1b969379182f/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabor=
a/baseline-minnowboard-turbot-E3826.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.87-=
63-g1b969379182f/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabor=
a/baseline-minnowboard-turbot-E3826.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61bec6f09500a5e15e397=
13b
        new failure (last pass: v5.10.85-33-g115cc53743f7) =

 =20
