Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CB3C381543
	for <lists+stable@lfdr.de>; Sat, 15 May 2021 04:48:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232372AbhEOCt0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 May 2021 22:49:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231473AbhEOCt0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 May 2021 22:49:26 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 302AEC06174A
        for <stable@vger.kernel.org>; Fri, 14 May 2021 19:48:13 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id b9-20020a17090a9909b029015cf9effaeaso2570776pjp.5
        for <stable@vger.kernel.org>; Fri, 14 May 2021 19:48:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Ttvq3+FSJy5j8OSyjI1+9nVHdKzYOoj74gOmzUHrDq4=;
        b=QXzgUvGmpsyFQvHr3T3Zrp2eL4DibD7dHt/N83NftT0A6w1gQC67sisN53LWTVZpDo
         fVXzSJHwK3OB129PxoEDtprRJio0JgLeIwrGqZHWeUuMHo4YINx28SWKJuy9hJXVCIjl
         qmFfYW6PpQRcothfE/VCvw8C5IumxM4NSpmhy0yrltObig3hxQPqxA64cAY4z85ciUCs
         pZyDuHGMNj0/qda3jnp2OlbwfLGUwFUR8oqv01Sytxf3Bcfbzi22sOn8rP7zdOqQXifZ
         I0AChtVYQeEMOEiDiC6EIWep+gMDfrfK/uTO3FvtrI4u1luGrAjX37H55fpQTh378kgk
         bEuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Ttvq3+FSJy5j8OSyjI1+9nVHdKzYOoj74gOmzUHrDq4=;
        b=Jp7+8OjVgArnoH4JiPZ4oOjAm6cGm+8hZoa/s3crz6Fc8OQsg9eQOKX8Gt1787otyJ
         4OERyGlWrdZVVgCBIMHh2XAN80B1/xl2Tbix8Mki5yoCekJF+4JrlUo2fBCjOGBHz/kk
         YMnfuRzF3rwXDzHvQy0tx3PDsNO4VZfdS4nzZGkmg8ZU0xjNruLXCr5+4aCp2n8fojbN
         CIJDkzLnGdIRGkakONOdxEmXmwMWTRdtgelahvv6J+llo03iHRbNZbkkAKbG+jGAtI37
         8JdmgDaTIvZvO0FkMDjgyppDPinBIV5RqTmetc97SWsDhvE78KI/GgKslWUqI7aVYWU2
         kwDA==
X-Gm-Message-State: AOAM533cYilAUTJIxKoQMEXYX6VSvoToWa6PRH/l06KHuIBtP2G31eOu
        auSA+8yFr/QwJlBvSPmBn+xS4nsied6mRDl6
X-Google-Smtp-Source: ABdhPJwFlYzdGhbkj1bHKUsJ8A05DV2D0F7ctErGn3jK53qtLF6EqRQMZNxsAyPzuQBXbs0SUGXMUQ==
X-Received: by 2002:a17:90a:a08c:: with SMTP id r12mr14310148pjp.204.1621046892416;
        Fri, 14 May 2021 19:48:12 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id j3sm5020713pfe.98.2021.05.14.19.48.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 May 2021 19:48:12 -0700 (PDT)
Message-ID: <609f366c.1c69fb81.95e91.20a2@mx.google.com>
Date:   Fri, 14 May 2021 19:48:12 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.10.37
X-Kernelci-Branch: linux-5.10.y
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-5.10.y baseline: 95 runs, 1 regressions (v5.10.37)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.10.y baseline: 95 runs, 1 regressions (v5.10.37)

Regressions Summary
-------------------

platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.10.y/ker=
nel/v5.10.37/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.10.y
  Describe: v5.10.37
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      e97bd1e03e6ef58ec47ee7f085f8c14ed6329cf7 =



Test Regressions
---------------- =



platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/609f002d6ec83337dab3afc9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.3=
7/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.3=
7/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/609f002d6ec83337dab3a=
fca
        new failure (last pass: v5.10.35-831-g77806d1ee43e1) =

 =20
