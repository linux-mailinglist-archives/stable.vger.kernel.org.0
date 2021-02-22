Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2CCF32216C
	for <lists+stable@lfdr.de>; Mon, 22 Feb 2021 22:31:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231867AbhBVVbU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Feb 2021 16:31:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229961AbhBVVbR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Feb 2021 16:31:17 -0500
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 982D8C061574
        for <stable@vger.kernel.org>; Mon, 22 Feb 2021 13:30:31 -0800 (PST)
Received: by mail-pl1-x62b.google.com with SMTP id f8so8554362plg.5
        for <stable@vger.kernel.org>; Mon, 22 Feb 2021 13:30:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=toXUbkmaskDVPMuwWUkyDd/9fDNUEIzpmBAGqTbsTs4=;
        b=pacg5hpL++rSxtpoFOW+QfPOysPSrDQY2wP4a1A3PRdTa9M8rnf5Faw3yS+Lpqpz8w
         zc5VVSFCFyL1WqJKGTNXul1wQRcWzjkkbsAm5rkNHKQBZUl/sUgK8ttjdhXEm0CXu8He
         PovkE4+ICIwspboo90ALNxMkFLOKm68MJA/R8ixhxanttVUMNqfHtcoJ44+9TUBmI3OM
         qm257f5bnfU3Ps+HwXZQB4l1DOPY88kBfxaC7Q9tt+u+TiaP9CKXscoUTv2eQbee08Ne
         9dfMTZoF2SLN8o+ewuAXUeQ9zQU5wPkYjRknSRcY1Kt9bz3dwb5bIPTVINZIfeKcjprP
         k8Iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=toXUbkmaskDVPMuwWUkyDd/9fDNUEIzpmBAGqTbsTs4=;
        b=G7DngjBbHMfmwrUNDS5oIpIwTfS/Hx46NN3+a4NofgXOndzMcEKmLib4JPZSq8ZBBA
         8vHOmwI9G8DFWdCCqbUxHweU5UUNQRhwl403hrsD+YL3EXm/NErfBg7sSAs/wv4nueMP
         EfpfHixFYmRLHq3HhLNnVL/QB0AP3ZhLSmJnnb07mkSDCI/v/+N1itZAkd+wdO1+2jzQ
         Clx3gmtX8rjzw89Z7xKm5yTIOWyGuNPRW/lWlG7dFZ7LdefWV9vsUdY2FTk3t42LP54e
         yVNqOpgup6Yq1NWv6Ud7cnhKDnllceQiZFWtkPeaKLvnyxxjt+ru2nk5hpcm+IpHq0/J
         pFbg==
X-Gm-Message-State: AOAM533JHBnyiXhlR/QrbxnJNvEm9XrV5bqkGzP63g4Y+hz3d9I19Pxk
        i2eLOhj3tfplBd+r/yKMWNAUQdUf/QxuDA==
X-Google-Smtp-Source: ABdhPJz4xFnBnkKwFcQY9mexkO/CqnH3WmYeeU6VrB7no/KG6QBZsRQU88A9bKFjDGGWNY+mgjfZJA==
X-Received: by 2002:a17:90a:bd03:: with SMTP id y3mr21209973pjr.14.1614029431083;
        Mon, 22 Feb 2021 13:30:31 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id h23sm20032601pfn.118.2021.02.22.13.30.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Feb 2021 13:30:30 -0800 (PST)
Message-ID: <60342276.1c69fb81.2806f.adcb@mx.google.com>
Date:   Mon, 22 Feb 2021 13:30:30 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.257-50-gf0cf73f13b397
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.9.y
Subject: stable-rc/linux-4.9.y baseline: 42 runs,
 1 regressions (v4.9.257-50-gf0cf73f13b397)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y baseline: 42 runs, 1 regressions (v4.9.257-50-gf0cf73=
f13b397)

Regressions Summary
-------------------

platform           | arch  | lab          | compiler | defconfig | regressi=
ons
-------------------+-------+--------------+----------+-----------+---------=
---
r8a7795-salvator-x | arm64 | lab-baylibre | gcc-8    | defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.9.y/kern=
el/v4.9.257-50-gf0cf73f13b397/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.9.y
  Describe: v4.9.257-50-gf0cf73f13b397
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      f0cf73f13b3979117e50a90dc884d48c1738105a =



Test Regressions
---------------- =



platform           | arch  | lab          | compiler | defconfig | regressi=
ons
-------------------+-------+--------------+----------+-----------+---------=
---
r8a7795-salvator-x | arm64 | lab-baylibre | gcc-8    | defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/6033e739dc04979199addcbb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.257=
-50-gf0cf73f13b397/arm64/defconfig/gcc-8/lab-baylibre/baseline-r8a7795-salv=
ator-x.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.257=
-50-gf0cf73f13b397/arm64/defconfig/gcc-8/lab-baylibre/baseline-r8a7795-salv=
ator-x.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6033e739dc04979199add=
cbc
        failing since 96 days (last pass: v4.9.243-17-g9c24315b745a0, first=
 fail: v4.9.243-79-gd3e70b39d31a) =

 =20
