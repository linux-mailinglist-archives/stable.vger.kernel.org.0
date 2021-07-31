Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC4AA3DC613
	for <lists+stable@lfdr.de>; Sat, 31 Jul 2021 15:20:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232380AbhGaNUh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 31 Jul 2021 09:20:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230303AbhGaNUg (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 31 Jul 2021 09:20:36 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD9E7C06175F
        for <stable@vger.kernel.org>; Sat, 31 Jul 2021 06:20:30 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id m11so2178688plx.4
        for <stable@vger.kernel.org>; Sat, 31 Jul 2021 06:20:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=zIMYuPdwkf3oLzkuJBHcQIdSjJW2fB9dZa+++M0Q09o=;
        b=Oiyndn3/yqd0GRi6zOLljIoyTFQ5nl0TFaNGEdnX1t2m1lOyzZFCSqCOrsgY4+tdK6
         q9qFAwtp2oAyyQxGTpsH1gEndvXPS2PQRrrAKfy/XPFPHV9oGYepSX/URaqb61kxCiKe
         QExRO2f/Ggsj+ZzfPOv0t7COdrQAQPgZlZ5fOhi60xlsEOVpjNwl7dX+ftxNmq8A/rkf
         HiTwacCEr+81drwgdvBirM+nkz2HpBY7954D2YCHWEnx+uI1lNVNRUf9k4Cnhm7qmyZ0
         7CjWkDRHg0k8ziQTXa/m5Ul7r0DlMOQBFy7nJ+Oh7jueH6/xjKmUh+nFKBCE3PKjaxE2
         hVxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=zIMYuPdwkf3oLzkuJBHcQIdSjJW2fB9dZa+++M0Q09o=;
        b=XcwI0Ca6QyLtEF67wI/3tP9qhBzGQ/c37xV+7X46JInOXsn7E2DSD33BHVH2PcmDOr
         tWOecBZ1azOTQAHitmSwOmuaGyU1fWGIahVbeW9mr/l6sCB/q/jUCF3Ml7WROPUbWHTQ
         FiURYKqvXSlRqW+QJkhhkx5HeN5qxL88Siio4nTmLPGJZEHMuco8M+74vogw1NnBTn/e
         C3Mj9A7SqhzjHc3l44zKsab0zFdVcryyAUcJZkV6mnPfviPKAL6Bc3IgU3j0PPhiVU4v
         XLvd47Bzz+UzS/8dk08cbrizTw5gKp4T+Ebdv1ehsNJ9KTEr5UKyWrfrVKTolWgibPmt
         qqng==
X-Gm-Message-State: AOAM531thIgpTV6wb79sPFAQ0RdrdEjmhuTGfYNjud9iEdL6iGdhH3HV
        LPeaUoGw52b7vv4VTM9vInH1un+waDyvkE8Z
X-Google-Smtp-Source: ABdhPJzNsytHKJOZGdyG95tC6FvzHz2L+2sHtDm+gVH4CFnGuBXPsgIbhJDzGaBbExxiOQtqrP69SQ==
X-Received: by 2002:a62:2cce:0:b029:327:6418:abc7 with SMTP id s197-20020a622cce0000b02903276418abc7mr7568887pfs.27.1627737630147;
        Sat, 31 Jul 2021 06:20:30 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id h25sm5761781pfo.190.2021.07.31.06.20.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 31 Jul 2021 06:20:29 -0700 (PDT)
Message-ID: <61054e1d.1c69fb81.9f627.f5cb@mx.google.com>
Date:   Sat, 31 Jul 2021 06:20:29 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.10.y
X-Kernelci-Kernel: v5.10.55
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable
Subject: stable/linux-5.10.y baseline: 150 runs, 2 regressions (v5.10.55)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.10.y baseline: 150 runs, 2 regressions (v5.10.55)

Regressions Summary
-------------------

platform                | arch  | lab           | compiler | defconfig | re=
gressions
------------------------+-------+---------------+----------+-----------+---=
---------
hip07-d05               | arm64 | lab-collabora | gcc-8    | defconfig | 1 =
         =

sun50i-a64-bananapi-m64 | arm64 | lab-clabbe    | gcc-8    | defconfig | 1 =
         =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.10.y/kernel=
/v5.10.55/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.10.y
  Describe: v5.10.55
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      11fe69a17195cf58eff523f26f90de50660d0100 =



Test Regressions
---------------- =



platform                | arch  | lab           | compiler | defconfig | re=
gressions
------------------------+-------+---------------+----------+-----------+---=
---------
hip07-d05               | arm64 | lab-collabora | gcc-8    | defconfig | 1 =
         =


  Details:     https://kernelci.org/test/plan/id/61051ecbdd4728bef085f45a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.55/a=
rm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.55/a=
rm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61051ecbdd4728bef085f=
45b
        failing since 23 days (last pass: v5.10.46, first fail: v5.10.48) =

 =



platform                | arch  | lab           | compiler | defconfig | re=
gressions
------------------------+-------+---------------+----------+-----------+---=
---------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe    | gcc-8    | defconfig | 1 =
         =


  Details:     https://kernelci.org/test/plan/id/61051d5276e4bd5d1b85f48c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.55/a=
rm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-bananapi-m64.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.55/a=
rm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-bananapi-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61051d5276e4bd5d1b85f=
48d
        new failure (last pass: v5.10.54) =

 =20
