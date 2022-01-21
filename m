Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC97B49663A
	for <lists+stable@lfdr.de>; Fri, 21 Jan 2022 21:11:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231951AbiAUULo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Jan 2022 15:11:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231717AbiAUULn (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 21 Jan 2022 15:11:43 -0500
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABBEFC06173B
        for <stable@vger.kernel.org>; Fri, 21 Jan 2022 12:11:43 -0800 (PST)
Received: by mail-pl1-x634.google.com with SMTP id n8so9622683plc.3
        for <stable@vger.kernel.org>; Fri, 21 Jan 2022 12:11:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=XVlUaiGDS5+kBE433kXQo+qVar4OTc2VqBJPrQX2nbE=;
        b=ID5+PqLdgc+mEbb8Jdau85LbUkE9/TeUZdGFIl8xuSHEe0ZLcwLYsZd+zKGwBApjH8
         i8TpBZRRk079j6Pqbm4c9u4zFLCAZ6mYNvh6HeQUKxpi1HTMjJTOXc7T+iWFp/fOvggn
         EUbaKQqIbAy13WFa5F2ycjgwKzW6Rm2wOEYyDaIOdFFJ8hERzWxueS6CJvE0SghdvvDb
         H77uYQO5LFFPRQzSZKxp4wZUdO4ORjWsYR/pCSDKsvlCUbITbW0pVumIKudVf9hjENCu
         cOLquBrKTz+/nsaHpSgVwJCesNldXn8UZ0kzbwUFum/BfmM1NokFYx7MUSmhnYUl5CNA
         +cRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=XVlUaiGDS5+kBE433kXQo+qVar4OTc2VqBJPrQX2nbE=;
        b=DiAGfh0fQXr56q0o03W3QieFolIbs1bDYqf6TmJQw4EebUoGHz4LhyIyhtx27IQd+u
         YS9h9KixSUqzbx4ytIGVLCyHgFX/l4FztGsC+4cvQUvfEYi02svZlLhGkUsy0qd7Yk+s
         6PHBQ4fi8p1Q/10u/TexYir7KoReO81cuIeufZorJF9EmVUAPCigk1E3xgtgqdkOlesP
         EJpZcHjrtZyrpaVpaGz4Y/rBOdabvkN2k+yeXG6knifx5PU6VG3R825dlYio03ko728y
         jPHJ1CT1c8qJ5egIVAI+POziBgmDQk+C/wlBYP4v7CUpOCUSFE8PAmO/DVsccW/VlfmM
         Ggsw==
X-Gm-Message-State: AOAM5319pOqTrsU0hPhyqx0EbwbJYMMtdZgXWGD3xMc2TsJLZnSXiYM7
        Fb+53dxvJQXWwwK4DefNVedQchMXtuq0rO7V
X-Google-Smtp-Source: ABdhPJzk2/c97dN9+UCuU+pN1uhv17+afQAWXsryGkw+md0qQOGI9Pbi3yw+gFnEJi2z1cw5zeVIAw==
X-Received: by 2002:a17:90a:ead6:: with SMTP id ev22mr2351434pjb.10.1642795902214;
        Fri, 21 Jan 2022 12:11:42 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id r11sm8082832pff.81.2022.01.21.12.11.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Jan 2022 12:11:41 -0800 (PST)
Message-ID: <61eb137d.1c69fb81.b238e.7267@mx.google.com>
Date:   Fri, 21 Jan 2022 12:11:41 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.14.262-15-g1464c5d2671d
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.14
Subject: stable-rc/queue/4.14 baseline: 155 runs,
 1 regressions (v4.14.262-15-g1464c5d2671d)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 155 runs, 1 regressions (v4.14.262-15-g1464c=
5d2671d)

Regressions Summary
-------------------

platform        | arch  | lab     | compiler | defconfig | regressions
----------------+-------+---------+----------+-----------+------------
fsl-ls2088a-rdb | arm64 | lab-nxp | gcc-10   | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.262-15-g1464c5d2671d/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.262-15-g1464c5d2671d
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      1464c5d2671d6afe0a94211f1c5d932550d91980 =



Test Regressions
---------------- =



platform        | arch  | lab     | compiler | defconfig | regressions
----------------+-------+---------+----------+-----------+------------
fsl-ls2088a-rdb | arm64 | lab-nxp | gcc-10   | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/61eadca6af3a00d34aabbd2c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.262=
-15-g1464c5d2671d/arm64/defconfig/gcc-10/lab-nxp/baseline-fsl-ls2088a-rdb.t=
xt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.262=
-15-g1464c5d2671d/arm64/defconfig/gcc-10/lab-nxp/baseline-fsl-ls2088a-rdb.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220115.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61eadca6af3a00d34aabb=
d2d
        new failure (last pass: v4.14.262-15-gc015d06920ca) =

 =20
