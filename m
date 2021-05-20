Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09163389EB1
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 09:12:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229536AbhETHNT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 03:13:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229534AbhETHNT (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 May 2021 03:13:19 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB2D0C061574
        for <stable@vger.kernel.org>; Thu, 20 May 2021 00:11:57 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id h20-20020a17090aa894b029015db8f3969eso4152937pjq.3
        for <stable@vger.kernel.org>; Thu, 20 May 2021 00:11:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=aqdpsCGi9hrVdosv4JxV1YV6ST8uYI8NnqvqxwcfhtE=;
        b=JSbImtJidTzqRg34zmfZSOTOXMHkm2D9wVseQh33dA9yZ1eU6tPvUs5qUS/GE2wMv9
         hLmoUn4dQ/jTXa2xDTImrfPDFhStS+TGG04qyUZma+oMURgpwUVyzS016sj/Bk+4x70X
         yntzCQN3efvysDiW5i3usg3/2fAak5IMW0kGAJdgVs2pnovBu590GgwSFzzwPgfWS7DV
         rOxmHeI0RybYqZ865xjZpOgfFL3yfOp0SmSuhPxU12CmGDgFyuDdroWcjEwjra1rn1Qa
         UBgMmKpzeWZRekscMAsgG0CmwZKdGj3avJSRUYPmfgPELkGd2MoAUen1dU3mILZKkPGS
         92yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=aqdpsCGi9hrVdosv4JxV1YV6ST8uYI8NnqvqxwcfhtE=;
        b=kvR1pIZdBMZFFI8m7bMQ8XwreDRPPXchrIwQ+qvtg5jnI1v1pcLIX+HzO+xaPMRCzD
         SG+oEemVD8AuZst8JrU822gYnFB7iw0YZbopG3ZUP2ABDhPF5UZ5eSBmDl+IUA3s+bbn
         849/i0MjeNbzSGEh+L8FxXqretoZF/jB1icWGaRScjli0DsHcEw5wCn7tHFREeDspztt
         Q+PXkMbW+un6aP8YzgqQaY6iwbXLMBmXXwdbR1Ye6uMIIZdtXrWzRaPg3iUlByyFQJ78
         /y8DqZfFtKGCqJ+tZiwSKhvyY0rJgz8kgEDFt+LXMfC1S47botK+Z/xCJmUVQayL5o2c
         0hbw==
X-Gm-Message-State: AOAM531/sucV/h6JEd93Q4a4vVKPA6SgyALWvZMpWlcMwLmMFCSkJmvg
        OHRxruMVdDrb+YzZ8tayECx2ELfTRM66itrj
X-Google-Smtp-Source: ABdhPJyKYwju/CH1sDM30JfPHyhBblKSLPEQ6JlLeRyt4cEaC4uPJOIixw7qrc+E63ceOg13Q7FDOg==
X-Received: by 2002:a17:902:7683:b029:ec:a434:1921 with SMTP id m3-20020a1709027683b02900eca4341921mr4166150pll.67.1621494717111;
        Thu, 20 May 2021 00:11:57 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id q24sm1226325pgk.32.2021.05.20.00.11.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 May 2021 00:11:56 -0700 (PDT)
Message-ID: <60a60bbc.1c69fb81.10778.52a6@mx.google.com>
Date:   Thu, 20 May 2021 00:11:56 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.12.5-41-g47eb87359033
X-Kernelci-Branch: queue/5.12
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.12 baseline: 174 runs,
 2 regressions (v5.12.5-41-g47eb87359033)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.12 baseline: 174 runs, 2 regressions (v5.12.5-41-g47eb873=
59033)

Regressions Summary
-------------------

platform                 | arch  | lab     | compiler | defconfig | regress=
ions
-------------------------+-------+---------+----------+-----------+--------=
----
imx8mp-evk               | arm64 | lab-nxp | gcc-8    | defconfig | 1      =
    =

r8a774a1-hihope-rzg2m-ex | arm64 | lab-cip | gcc-8    | defconfig | 1      =
    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.12/ker=
nel/v5.12.5-41-g47eb87359033/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.12
  Describe: v5.12.5-41-g47eb87359033
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      47eb8735903379c8a1d07b4093d10e9cb494b970 =



Test Regressions
---------------- =



platform                 | arch  | lab     | compiler | defconfig | regress=
ions
-------------------------+-------+---------+----------+-----------+--------=
----
imx8mp-evk               | arm64 | lab-nxp | gcc-8    | defconfig | 1      =
    =


  Details:     https://kernelci.org/test/plan/id/60a5dc0ff7a758f828b3afc5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.5-4=
1-g47eb87359033/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.5-4=
1-g47eb87359033/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60a5dc0ff7a758f828b3a=
fc6
        failing since 0 day (last pass: v5.12.4-363-g893c8b1b923f, first fa=
il: v5.12.5-5-gd7347eee5d7b) =

 =



platform                 | arch  | lab     | compiler | defconfig | regress=
ions
-------------------------+-------+---------+----------+-----------+--------=
----
r8a774a1-hihope-rzg2m-ex | arm64 | lab-cip | gcc-8    | defconfig | 1      =
    =


  Details:     https://kernelci.org/test/plan/id/60a5dbcb8dcd00dd68b3afd4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.5-4=
1-g47eb87359033/arm64/defconfig/gcc-8/lab-cip/baseline-r8a774a1-hihope-rzg2=
m-ex.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.5-4=
1-g47eb87359033/arm64/defconfig/gcc-8/lab-cip/baseline-r8a774a1-hihope-rzg2=
m-ex.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60a5dbcb8dcd00dd68b3a=
fd5
        new failure (last pass: v5.12.5-5-gd7347eee5d7b) =

 =20
