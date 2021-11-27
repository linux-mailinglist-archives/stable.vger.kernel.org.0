Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F12C45F760
	for <lists+stable@lfdr.de>; Sat, 27 Nov 2021 01:10:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343677AbhK0AOA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Nov 2021 19:14:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245704AbhK0AL7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 26 Nov 2021 19:11:59 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46A3AC06175B
        for <stable@vger.kernel.org>; Fri, 26 Nov 2021 16:07:39 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id n15-20020a17090a160f00b001a75089daa3so10823800pja.1
        for <stable@vger.kernel.org>; Fri, 26 Nov 2021 16:07:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=VyprX4t5isYIDWYspbncKnuXK3sNp2Bjw1gYpO26ACU=;
        b=gp//KJzStaFBLpWSBQxL/nQ3KmVeUXl0PEkUfMOFafN20V00FVeEVs7v5Zif1VKFpS
         jo3dnwtXCFxFLc5lDR25ee/8VJMeUzhFuTjuYAV6UE1yuj4A/cd0o7nDP78QKqsVogK6
         J0yNwoDlJT6J2WdW6d48U/o5riFocUTyUB5M3LIgEdBcxZOwAc3xUlxEVm2pm0BIELjI
         z+CggUDEY6oLpUpigjIqbCANLX6mqRcBFokM0/g2RWwFLIUKTCrKzRpNa+pOwfGOMQbn
         zYHu/A3zkC0YFI4H2/5iiAILMjExQo4Ra/8i63LOmyiJEmZPGtLlYY6MOCqZQGoYTxF6
         zirQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=VyprX4t5isYIDWYspbncKnuXK3sNp2Bjw1gYpO26ACU=;
        b=6pZgf+8JtI3Paqnu944X3Ku+n78ZdIUDdeJ75SOnV9FEJrpSSIffEPEd5awZXPsZ5C
         /P5OGlgFJUEnQYCyRrItlZzXhypRQmtxDGNo+B6X2x2o1KNvTkMgNVga7ToQ3SS/MIOR
         pscQ9Pnuj3shoPiw4uuPFzBJ1iof7sVGKV/aT7QzDrGKTtLXPCDrjxGJ+keyVBcRa7c4
         3V4Wvwdpllkz4j+3adKxC/+WKwIz8xJ77YDsr+HCibQfzRZE59EXJH9gKDDKgNTCd8Qc
         bQnFNHBpg3zWFPe+XA9RJ9uESrNPFal8oD9XG/kF0KYc6oInAJHiwjvbooB+Zjy7Z3KQ
         wSnQ==
X-Gm-Message-State: AOAM5302r9QMLylxniathZ+Y5Y9DZP93CUPEjpbwxHTNE/4zB8xEEdtB
        ze27+65KfKl0pBzqAoqvSrTVJMnQCkxm/dPv
X-Google-Smtp-Source: ABdhPJwhqyEnvMnboWWg7KY7wBfP0OT7cbZuJRPvre8cNbDIr0b+PL3zTlzWY247N1qCvGKHvetcqA==
X-Received: by 2002:a17:902:76c6:b0:142:644e:e9a with SMTP id j6-20020a17090276c600b00142644e0e9amr41935797plt.6.1637971658698;
        Fri, 26 Nov 2021 16:07:38 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id t3sm6908014pfj.207.2021.11.26.16.07.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Nov 2021 16:07:38 -0800 (PST)
Message-ID: <61a176ca.1c69fb81.1bc14.2f98@mx.google.com>
Date:   Fri, 26 Nov 2021 16:07:38 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.10.y
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.10.82
Subject: stable-rc/linux-5.10.y baseline: 167 runs, 1 regressions (v5.10.82)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.10.y baseline: 167 runs, 1 regressions (v5.10.82)

Regressions Summary
-------------------

platform            | arch  | lab          | compiler | defconfig | regress=
ions
--------------------+-------+--------------+----------+-----------+--------=
----
r8a77950-salvator-x | arm64 | lab-baylibre | gcc-10   | defconfig | 1      =
    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.10.y/ker=
nel/v5.10.82/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.10.y
  Describe: v5.10.82
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      d5259a9ba6993a843278203323902bc0c049097e =



Test Regressions
---------------- =



platform            | arch  | lab          | compiler | defconfig | regress=
ions
--------------------+-------+--------------+----------+-----------+--------=
----
r8a77950-salvator-x | arm64 | lab-baylibre | gcc-10   | defconfig | 1      =
    =


  Details:     https://kernelci.org/test/plan/id/61a1400fe4200ad24318f6ec

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.8=
2/arm64/defconfig/gcc-10/lab-baylibre/baseline-r8a77950-salvator-x.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.8=
2/arm64/defconfig/gcc-10/lab-baylibre/baseline-r8a77950-salvator-x.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61a1400fe4200ad24318f=
6ed
        new failure (last pass: v5.10.81-154-gc7ee3713feb5) =

 =20
