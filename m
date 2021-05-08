Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 673AD377127
	for <lists+stable@lfdr.de>; Sat,  8 May 2021 12:10:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229947AbhEHKLJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 8 May 2021 06:11:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229869AbhEHKLI (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 8 May 2021 06:11:08 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0804C061574
        for <stable@vger.kernel.org>; Sat,  8 May 2021 03:10:07 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id m12so9160175pgr.9
        for <stable@vger.kernel.org>; Sat, 08 May 2021 03:10:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=9x/zhynxnNF8oLB6JWT2VcTpJ27yMvl7ZGrSxaWcRO8=;
        b=fOYSMFMSSlLKeMCdvcpJljXXohMCtaCjukFhSvF9C1uAJqIMMovB/D3piXOwhIZmaI
         U19hWpRDgfw7FOR7j9QGyQMrjsU2hk9z4TSftLR6f0zcwiATZ9e9v3xz0HX1T8b65qgW
         xIC1o4YwzgrkZFKaTlqxMJ7lzYJ/U7Zio4GiD+BkdnQHGZp+MxYAhOb9YHn6+0hxWjHe
         bl5txxkEiT1FJ9r8dpn4Va9noBR5GkhaCERqgSTxfS+Bg3EmOrTZhM0+lmx9h89Tu0iU
         1nIBHyRsTWRZoCTY98q09NQqh0dhGSKOJRBmNXgDKVMGDm46JkZ5LrUwQNCusbVIvfi2
         i1Yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=9x/zhynxnNF8oLB6JWT2VcTpJ27yMvl7ZGrSxaWcRO8=;
        b=eIod54HJuOy1f8d/vUfZnEcgpFDbYdOlQIU7/boDrE1qeeZgZW0QSm95MPo2waGL6z
         FfUZ/9XVoj19gezSVWqARshnIclZcnHvsfoHJrcYL/dIDoYnwpAadzJIkrp6JXaIDkez
         NwurPZH+pZYp9l211GCGwEfdLNd77wtMd4Yce2afHj2vJ6CypnR61sAnOAfRXC4ikj8m
         /N3cV4QsU6Lw3UNyKQEg4Onv7dwGG6BaMPs80cZRmrWO9cCtfWhye8+9qhEyvzAGL+cu
         /6Wj/pUNUcobUiK85Hn+aYf0YrxpO5kF6KswftVYkNYsigzL5y+k0Kppvx60pGY66IQG
         hGdg==
X-Gm-Message-State: AOAM533S9Ohv6J1ku19ap7j/F9o8M6WQJOayZIkmPnZFT8HVDe+++tvh
        lLVMHPPeKZiloQcslrPWnjoD0/hBnNg2ku5S
X-Google-Smtp-Source: ABdhPJyTFsfvaFkhBLnGzWpJfkOHwkOfFJJ2e1Ov/rsoLXimxD525YjDH2ETrMybkHCeH+7f3bXaaA==
X-Received: by 2002:a63:1624:: with SMTP id w36mr14411123pgl.240.1620468606289;
        Sat, 08 May 2021 03:10:06 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id i10sm13853430pjj.16.2021.05.08.03.10.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 08 May 2021 03:10:05 -0700 (PDT)
Message-ID: <6096637d.1c69fb81.ceaa2.4679@mx.google.com>
Date:   Sat, 08 May 2021 03:10:05 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.11.19-242-g5725e07c6862
X-Kernelci-Branch: queue/5.11
Subject: stable-rc/queue/5.11 baseline: 147 runs,
 1 regressions (v5.11.19-242-g5725e07c6862)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.11 baseline: 147 runs, 1 regressions (v5.11.19-242-g5725e=
07c6862)

Regressions Summary
-------------------

platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.11/ker=
nel/v5.11.19-242-g5725e07c6862/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.11
  Describe: v5.11.19-242-g5725e07c6862
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      5725e07c686200760208580d13c99d6d006fd3b6 =



Test Regressions
---------------- =



platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/6096323216ca2bacbc6f548a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.11/v5.11.19-=
242-g5725e07c6862/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.11/v5.11.19-=
242-g5725e07c6862/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6096323216ca2bacbc6f5=
48b
        failing since 0 day (last pass: v5.11.18-29-g6c2ae64a2a728, first f=
ail: v5.11.18-30-g4232ce7a02cc) =

 =20
