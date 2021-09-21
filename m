Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 275B3413B39
	for <lists+stable@lfdr.de>; Tue, 21 Sep 2021 22:22:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233020AbhIUUYW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Sep 2021 16:24:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230348AbhIUUYW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Sep 2021 16:24:22 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFAC8C061574
        for <stable@vger.kernel.org>; Tue, 21 Sep 2021 13:22:53 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id n2so187309plk.12
        for <stable@vger.kernel.org>; Tue, 21 Sep 2021 13:22:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=haNGvfFv+xkufjzPxABBFaB4Xxw7eKQMKO76DCOL+wI=;
        b=4QQjB+Fp2+k2F3AcYo1fmCAN5izkZdES5u/ALz+NpH2B5KwJPJQye1Ht56OI+aBl6O
         UPncXdGy7CJiR/4BzwX83zzWQnpEMFmLZbz6cZBLP1Jd7H6CoGZdsEXQ/t6sUqk3A1/z
         PUcpqwmP3A6LFETG6QAIt6/ZFdukm2Ar9V3KyouL8V1dGTKQd2IRhQT7ImTKHpl5MwP0
         Du5T1TDnsVfzTXIJMeDF6pRG8J57PVW80uH6L5opvIvjI8GJmXj77Gn+t9Y3BA8LHgto
         zQTPeFr55sXHvEbvE+byVa31SU0+/zBAgCQha1sTyeEK3pWp1ijMwDLvHeabt5bPgxaO
         G2Ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=haNGvfFv+xkufjzPxABBFaB4Xxw7eKQMKO76DCOL+wI=;
        b=FW/jYFg5mEPAYung7eyAW611xiUaYAuBz5TBqohqhP6hCqP5S+vj6GsjPMLN8DveNe
         3nsq8SGIkMQ5SW7juu5d3ej1ttTwcbukiWq8sHF1UwF6yFvXV0dvV2O2SUo3Ot8cJemV
         VILVnFxUhZJNinjNg2YimarHA0v27jVBi5ETQUU1d/ZYwxzJNPYYCCwiFwYhbDFr/6Uy
         xPogkyqxo7o9D6cUof6sWKFVRvBCmn2VtqdlvEGXMBg2Z1xlO+nNH8I5a/jWeCgbHOXd
         Cp76D5i/gp6Xd7uvAwf/kGJWBSxOoBzQ9cpzPatewqfsIo0/OU22kQfFRS5yUDSBEhTA
         5e2A==
X-Gm-Message-State: AOAM5335XxCZ4XF4b8/o2jWLmtDdu9E2fQUUq9EG42jA9+V/1ulg7hrz
        6IPX3NNchbKRGb4NpJXtj3oG3TFxeIaQ8JZP
X-Google-Smtp-Source: ABdhPJzg1xrMJr8UWU+bYYM8yNn4c5Gk7ZWgshvJLcQUmYEpWIoAJlsHUTZFo14I6R9CCLP1us5pBg==
X-Received: by 2002:a17:90b:4a88:: with SMTP id lp8mr7167426pjb.159.1632255772988;
        Tue, 21 Sep 2021 13:22:52 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id d19sm37137pfn.102.2021.09.21.13.22.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Sep 2021 13:22:52 -0700 (PDT)
Message-ID: <614a3f1c.1c69fb81.286f.03c8@mx.google.com>
Date:   Tue, 21 Sep 2021 13:22:52 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.14.6-170-gb1e5cb6b8905
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.14
Subject: stable-rc/queue/5.14 baseline: 142 runs,
 2 regressions (v5.14.6-170-gb1e5cb6b8905)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.14 baseline: 142 runs, 2 regressions (v5.14.6-170-gb1e5cb=
6b8905)

Regressions Summary
-------------------

platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-8    | multi_v7_defconfig  | 1       =
   =

beagle-xm | arm  | lab-baylibre | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.14/ker=
nel/v5.14.6-170-gb1e5cb6b8905/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.14
  Describe: v5.14.6-170-gb1e5cb6b8905
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      b1e5cb6b8905356eb971128ae5fc39b35af51554 =



Test Regressions
---------------- =



platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-8    | multi_v7_defconfig  | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/614a0a2fd80dd1bed699a308

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.6-1=
70-gb1e5cb6b8905/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-beagle-=
xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.6-1=
70-gb1e5cb6b8905/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-beagle-=
xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/614a0a2fd80dd1bed699a=
309
        new failure (last pass: v5.14.4-395-ga49a6c3da2c6) =

 =



platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/614a09c89cca3d55f399a2e6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.6-1=
70-gb1e5cb6b8905/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle=
-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.6-1=
70-gb1e5cb6b8905/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle=
-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/614a09c89cca3d55f399a=
2e7
        failing since 5 days (last pass: v5.14.4-24-g6da4ee8977f4, first fa=
il: v5.14.4-73-gc291807495af) =

 =20
