Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1943A34B969
	for <lists+stable@lfdr.de>; Sat, 27 Mar 2021 22:11:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230114AbhC0VK7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 27 Mar 2021 17:10:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230015AbhC0VKq (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 27 Mar 2021 17:10:46 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68B9BC0613B1
        for <stable@vger.kernel.org>; Sat, 27 Mar 2021 14:10:46 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id x126so7216068pfc.13
        for <stable@vger.kernel.org>; Sat, 27 Mar 2021 14:10:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=wkeP8BuHuPyB/6bMhJJ3tchL2+2pLObTzcqAGxTAyG4=;
        b=FMGHIMyd6YL/4pf34Np8Zvskb08na7XoYi565sX1Sf7TTrN8zyTcKWSbYXrtUqiYpr
         Q37TM4h9gqkObv/1zLzw7HMTz7ak+vk5RGXz85uPEKstRVl7vxvoaAsGdM0Ha/uo7+UT
         5tz+S+w3rggG+fHgl6/9FcYfDPABY8ya1vkV1sLEY9AOyXRfdY8YiEH6yrQhJ6gGyg61
         Uj9ZdnAIb4juPDVAAUhqdGWSE81h9k07aTL3WAEbKeepf4mSTj8zWO68dMpsXHMAYALQ
         2a9RwOxNYHjk1Jg2nl20nzIduWP4rU5XDDz0cbNxn4CeCdwMGhjpuJ0WqmROUadRzo3r
         dHHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=wkeP8BuHuPyB/6bMhJJ3tchL2+2pLObTzcqAGxTAyG4=;
        b=SBHR69boqHGNu7wyyKvesoh2VMoNJVEnaja1omub8DQ59WudQwbaE5re2FEB5xEbHq
         fLzdm06r1eziPdR1ouWVS+s6mpZJk2+iyAXXvTokuXciyB6bWLpVnZ5PKvvdT0j6FnBS
         RuH1rbGHMWuFHhcxFwW8RqAd6tM1l+CMNtvFObNKQHsp37qhRd7+IL8ur+UbyPoxQK3N
         NNVtAYKo1u6mLJgQaUy+177H7Qe5dvpXGEHUyNrNQMnZt2CSj4xJzgPfbG/NuAbMorKb
         jHND36ZX3kaIuPbgFCIkgBKrUBHs0ZyUnVIq6P0cBiWJ/W0BEnkDuem7w2dwwC+6z66w
         4Z7w==
X-Gm-Message-State: AOAM5314CfKk7i5AJW2aZ7ghHSzzcDhWM8vKsfLH3XHpMdBCMvW2oq74
        zduuviUEOaEbzamiSbPucs2YqiIuy9KcGQ==
X-Google-Smtp-Source: ABdhPJzdq5MIdiYTKpFfE35Soq9iQUkdo8AaSnK/4GxLZl+1bVlH9AUYZp4QSxSxQpSXl2umCgCRDw==
X-Received: by 2002:aa7:93af:0:b029:1ef:1bb9:b1a1 with SMTP id x15-20020aa793af0000b02901ef1bb9b1a1mr19163901pff.49.1616879445856;
        Sat, 27 Mar 2021 14:10:45 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id v9sm13578542pfc.108.2021.03.27.14.10.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 27 Mar 2021 14:10:45 -0700 (PDT)
Message-ID: <605f9f55.1c69fb81.604f4.1c86@mx.google.com>
Date:   Sat, 27 Mar 2021 14:10:45 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.10.26-90-ge291d8cd10776
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
Subject: stable-rc/queue/5.10 baseline: 123 runs,
 1 regressions (v5.10.26-90-ge291d8cd10776)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 123 runs, 1 regressions (v5.10.26-90-ge291d8=
cd10776)

Regressions Summary
-------------------

platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.26-90-ge291d8cd10776/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.26-90-ge291d8cd10776
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      e291d8cd1077697cfb7d740c550f1a3e4aa60b8d =



Test Regressions
---------------- =



platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/605f66a50147e9e008af02c3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.26-=
90-ge291d8cd10776/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.26-=
90-ge291d8cd10776/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/605f66a50147e9e008af0=
2c4
        failing since 1 day (last pass: v5.10.26-56-g525a07fb82ba, first fa=
il: v5.10.26-61-gc7b7b08c4bb5) =

 =20
