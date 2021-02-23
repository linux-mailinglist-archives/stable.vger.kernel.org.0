Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00644323052
	for <lists+stable@lfdr.de>; Tue, 23 Feb 2021 19:11:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233083AbhBWSLk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Feb 2021 13:11:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232810AbhBWSLi (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Feb 2021 13:11:38 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C281BC061574
        for <stable@vger.kernel.org>; Tue, 23 Feb 2021 10:10:58 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id ba1so10334794plb.1
        for <stable@vger.kernel.org>; Tue, 23 Feb 2021 10:10:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=rIKV1B4c+A7en7e6Iyjh2udkL0DyBhSu+43SJDXAB9g=;
        b=HxK9Wbq8lyD1Gn8iL1WbZxvgpOIU4vD7MwaqyzxVvLKL7AO3zYC97hP8302p+mFxuL
         fs/mN72sN4dMzk880njnETssa+keFMk3WVsG5DEyKlubZTzPsIwZzTLKaCnhyVF8rhk7
         vuXMzfxfS5fYdW6CqR43KUpPmvBt/rzvPCPfpmLWvRHJIkvNzXTx+rP5Jh7EhoVQkiWa
         oYp2eFqjj9KCysgzDvd28gUrNf6C1j0ksnCiYoVtHgGsZQbN/ylUBabVNxZE1Jivt3re
         mnnK2xzEpjRXmdxWV2h/LmPo7h48KP0rEcb1OY2saYfJ95YmNbqfigLTB6a2KwJH136i
         QCbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=rIKV1B4c+A7en7e6Iyjh2udkL0DyBhSu+43SJDXAB9g=;
        b=tyQrYpwQU8QHo0jyvnUS5oVPYirv/B7UrK5vs0YQ91D0lZ8nlEtUyckXcWUHbMLIGP
         eY1YHfdtQ8hM94gIGo2ySGEWAuH+QIuV2lEiBbHgXfhUrLFwSr0ujapx6yp4xJekHkGN
         cdGWQMA8xCNmWHaHRNRFe0z5IxT05CLpbqk/A9I95xOipaLl5/LV/MJRggIGgbaeZZub
         g/L2LVwYk2N5Il/v1rit8PJbbpuo7BqsL96aZp3KoAk34Qpugkr2AxpVsvclbFhwLAZn
         odH4DaAe84dYJRIN5jleMgDJmksm4gFC8iBFRVrJbmxCP5tsHttK1Lb568kMdSS/GLk2
         nOfw==
X-Gm-Message-State: AOAM531KZ6hjQXdSplt4LmURLKpobc/34eiZCSY7E+9SQLHKgmApA+xd
        r//sDd7FtxztndY0WQzFh1vUa5mK9XNvLg==
X-Google-Smtp-Source: ABdhPJzs8dX4T5pUwhEez+XJfdZ8em7wSgxHCxL59HTQXC7GILSyuVfQlU7bVjohOPMXdPMY7xWYKw==
X-Received: by 2002:a17:90a:cb93:: with SMTP id a19mr24544131pju.129.1614103858234;
        Tue, 23 Feb 2021 10:10:58 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id o67sm6937736pfd.109.2021.02.23.10.10.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Feb 2021 10:10:58 -0800 (PST)
Message-ID: <60354532.1c69fb81.4fe4c.ccdf@mx.google.com>
Date:   Tue, 23 Feb 2021 10:10:58 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.258
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-4.9.y
Subject: stable/linux-4.9.y baseline: 52 runs, 1 regressions (v4.9.258)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.9.y baseline: 52 runs, 1 regressions (v4.9.258)

Regressions Summary
-------------------

platform           | arch  | lab          | compiler | defconfig | regressi=
ons
-------------------+-------+--------------+----------+-----------+---------=
---
r8a7795-salvator-x | arm64 | lab-baylibre | gcc-8    | defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable/branch/linux-4.9.y/kernel/=
v4.9.258/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-4.9.y
  Describe: v4.9.258
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      5b1d078507bd33ebf6c2083fa363cf5832809c19 =



Test Regressions
---------------- =



platform           | arch  | lab          | compiler | defconfig | regressi=
ons
-------------------+-------+--------------+----------+-----------+---------=
---
r8a7795-salvator-x | arm64 | lab-baylibre | gcc-8    | defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/60350a96c3c2e1216daddcd6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.9.y/v4.9.258/ar=
m64/defconfig/gcc-8/lab-baylibre/baseline-r8a7795-salvator-x.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.9.y/v4.9.258/ar=
m64/defconfig/gcc-8/lab-baylibre/baseline-r8a7795-salvator-x.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60350a96c3c2e1216dadd=
cd7
        failing since 96 days (last pass: v4.9.243, first fail: v4.9.244) =

 =20
