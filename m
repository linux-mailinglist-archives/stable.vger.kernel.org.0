Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5A8F32D4E8
	for <lists+stable@lfdr.de>; Thu,  4 Mar 2021 15:07:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238930AbhCDOGn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Mar 2021 09:06:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238879AbhCDOGW (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 4 Mar 2021 09:06:22 -0500
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5141AC06175F
        for <stable@vger.kernel.org>; Thu,  4 Mar 2021 06:05:42 -0800 (PST)
Received: by mail-pg1-x52e.google.com with SMTP id x29so10722972pgk.6
        for <stable@vger.kernel.org>; Thu, 04 Mar 2021 06:05:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=s2ZsMCS+WbPjFzb/rWihpxbEFvh7MgLmuoK1a7YNgok=;
        b=pWunUodbFf6ADvCqRkG2fDTSsSNxrI4TqpUl+daPBkOQ+XxOvESu+1u29Foa/j65tU
         bQ6qIrHq935AF+dJr6qWzUHsbfmqdWABpQkzwuB0PmVoHlVXM/GpR1bT/n9JJX2OZCEa
         U9IknEWhBHq6NAU9eAdvSiOTQyh4XQhCnfa+v7/Y1R/ElJPdXG/soCAasBMvjbVvRXl3
         /RYyxQk5tOaFpCYMJV627sdVobDo6CKgeMAgZlKP2z5DDq1t9W6AvMj0JgxckpV0Hl6u
         WlMqwwy2NL3zJEeZrXtn/R4CYAItiJrL+XSZV32t3HTcVHi/x8zGWJchX6BAXnJDmIqw
         Cpfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=s2ZsMCS+WbPjFzb/rWihpxbEFvh7MgLmuoK1a7YNgok=;
        b=BfHB5suuZjJp6jy1FXUp2LFBFcQbcM3veFUropgP0QMN9RuKRd8ncBlTL9NI6QzCs/
         lTEG8R2lnsa9V9VVsymI8TKmXnIBDQ0p/yPsSwFqNEdOQf/nXbnZskO/twD6EbH4PJnV
         boGMySsVniLZ0cNhkuZGezYYpHPskyK2BKUnMhiEpUs8G5PZOv45djEG7m5XWYANSXIA
         x4yCGxrG90ymyOa34FaXCx7LK/zfK59b20pjtlQzbvwLIPj8N8qJL22hAhQscD79afAV
         nk4/14WNWFMQ3ZL5RK+fDeebXVw/iypZb5nnHfAA5P140zNKCAZgHqwr+fH20SbBp7gb
         RyrA==
X-Gm-Message-State: AOAM530RlWNdEa3RzNxt94kaHav2AWczaheadw0w6IUdbnslLtmH2CuN
        aYaVtA4nyhNOVst76T+qBLQLW839WxNaq4hg
X-Google-Smtp-Source: ABdhPJzco0Gbykd+ULVduVQKCN0K58F9RxQ3pta0D+f+CBAipqvUgQvnh9iu3sNO38YRo3A+d6f2bQ==
X-Received: by 2002:a62:7b0b:0:b029:1ef:1999:1d57 with SMTP id w11-20020a627b0b0000b02901ef19991d57mr3749470pfc.19.1614866741751;
        Thu, 04 Mar 2021 06:05:41 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id d11sm10280023pjz.47.2021.03.04.06.05.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Mar 2021 06:05:41 -0800 (PST)
Message-ID: <6040e935.1c69fb81.5bc2c.6c6b@mx.google.com>
Date:   Thu, 04 Mar 2021 06:05:41 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.10.19-656-ga3c8a24e1f5e3
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
Subject: stable-rc/queue/5.10 baseline: 180 runs,
 1 regressions (v5.10.19-656-ga3c8a24e1f5e3)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 180 runs, 1 regressions (v5.10.19-656-ga3c8a=
24e1f5e3)

Regressions Summary
-------------------

platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.19-656-ga3c8a24e1f5e3/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.19-656-ga3c8a24e1f5e3
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      a3c8a24e1f5e377d1165a1e9ebf0ba237f0c529b =



Test Regressions
---------------- =



platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/6040b9dd6becfb1529addcd5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.19-=
656-ga3c8a24e1f5e3/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.19-=
656-ga3c8a24e1f5e3/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6040b9dd6becfb1529add=
cd6
        failing since 0 day (last pass: v5.10.19-655-g2acc6a4ae931, first f=
ail: v5.10.19-656-gd3a7334586025) =

 =20
