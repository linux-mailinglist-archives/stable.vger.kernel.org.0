Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E2E43266D5
	for <lists+stable@lfdr.de>; Fri, 26 Feb 2021 19:20:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230128AbhBZSSn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Feb 2021 13:18:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230012AbhBZSSm (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 26 Feb 2021 13:18:42 -0500
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E32BAC061574
        for <stable@vger.kernel.org>; Fri, 26 Feb 2021 10:18:01 -0800 (PST)
Received: by mail-pf1-x42e.google.com with SMTP id o188so131817pfg.2
        for <stable@vger.kernel.org>; Fri, 26 Feb 2021 10:18:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Zog09xatOA6RM7WGFgiUyFIaX12oN9apZEKYX+4qmZg=;
        b=JSwEauquALLHZhRMqTT5LFmOrDOTLYYAKMLgmSk6SMVWdGVMO42Y7es9OR/BjCXHnQ
         XXXHAzSSmZOtxnWIFOQdAJhOI0gth3DCR5BWToCSxtWyS+TUmtVzKk6hpP9carw8ByL2
         lmqRCpiinJA2aXRVQ/XqIPJD9q9mMuuR248krEihdxVoe8/M/I401hXje+lG5Gd/8pnw
         +PhT2kXS2Bv2J+eb8zcQoIEdSb2M+Igee0z0ncNs2ObvIM04a4VYWlwzPWQVv3b2FNuN
         T1gCuaF2w7+RGHDHxRPs7LgeXdRTuqZqlKwWqBXtVLQaF71T5YOG3/RbDI9vKH83BpcF
         gxNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Zog09xatOA6RM7WGFgiUyFIaX12oN9apZEKYX+4qmZg=;
        b=SOZGT5rOR/6thBlDod1sj143dIHB12cj8v6BU64/Q3tg8Q4hoUfLxdD8dPcGtDqKtb
         5Ro1FV0Gh/dPYXzGCOM0ZFxPrcjXgH80qyj3gPhUaHd6JZnvPs5ZkPK/J88Uc8E+Wt/4
         m7ncS4ZrhCK7ZG2a1W/2RN/UmT+gscag4z/eTAN4tRy7icDYLZQmaxsEG5EAZMyLJi26
         SB3Y1rYBgzWBUS1BJgc1GBG8Jw/jx/j+nPGUrlbfrdHWmQ2t8PCQAbTi5uQFA+ogwwXq
         KMF2dh/EI1jVMeY+4RBVJf3NzX2SEOpn54MwdXDcUOAnaL8sANxdHT/v3TaTG8xSVHcw
         3xww==
X-Gm-Message-State: AOAM533iiqPnG3tlFMrOSYnqS1gNWvZPTdrw0PFPnHQdFp6HXZI/zgMU
        I3vE+ujh2EzczLap3eC8iow5A14HOdr5Wg==
X-Google-Smtp-Source: ABdhPJzO9PQPhyVPCJoyVchkZ8+SU6Czyu2SJXi9S5qF4//737qgEgFgdrLOHQJ+IBDlUZRjjygWhw==
X-Received: by 2002:a63:5c66:: with SMTP id n38mr3961990pgm.1.1614363481252;
        Fri, 26 Feb 2021 10:18:01 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 140sm10334154pfv.83.2021.02.26.10.18.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Feb 2021 10:18:00 -0800 (PST)
Message-ID: <60393b58.1c69fb81.68d63.769c@mx.google.com>
Date:   Fri, 26 Feb 2021 10:18:00 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.222-8-g6815f667af2fe
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.14
Subject: stable-rc/queue/4.14 baseline: 62 runs,
 1 regressions (v4.14.222-8-g6815f667af2fe)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 62 runs, 1 regressions (v4.14.222-8-g6815f66=
7af2fe)

Regressions Summary
-------------------

platform       | arch  | lab          | compiler | defconfig | regressions
---------------+-------+--------------+----------+-----------+------------
meson-gxm-q200 | arm64 | lab-baylibre | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.222-8-g6815f667af2fe/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.222-8-g6815f667af2fe
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      6815f667af2fed68869230c7469571d4a45afc19 =



Test Regressions
---------------- =



platform       | arch  | lab          | compiler | defconfig | regressions
---------------+-------+--------------+----------+-----------+------------
meson-gxm-q200 | arm64 | lab-baylibre | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/60390ce00bd43606c0addcc8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.222=
-8-g6815f667af2fe/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q20=
0.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.222=
-8-g6815f667af2fe/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q20=
0.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60390ce00bd43606c0add=
cc9
        failing since 80 days (last pass: v4.14.210-20-gc32b9f7cbda7, first=
 fail: v4.14.210-20-g5ea7913395d3) =

 =20
