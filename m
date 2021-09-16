Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E10A40D799
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 12:41:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235623AbhIPKms (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 06:42:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235570AbhIPKms (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Sep 2021 06:42:48 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86629C061574
        for <stable@vger.kernel.org>; Thu, 16 Sep 2021 03:41:26 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id t1so5761159pgv.3
        for <stable@vger.kernel.org>; Thu, 16 Sep 2021 03:41:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ycwq8+30tB5ctR2/HDwzHBF9BstFNNQQL2o8JRXDSQM=;
        b=Afl7aCHWuRpGsrXr3zuH3s3M0k6+Yy6JzAYHcUpGHIoE8BapvpNstdx6Y2Be4Z7koW
         ZbdoUfAU/t03J1GGgGXhM5PgDNnQGPMdoWSRs7sVMvKl5jJ/CZV/EADbmLsKNKl/xQuT
         U6JLtnH8qVGd+PjUJ9jHQOZsrRQel5YS+G62BurcLAPxkatB78fqha8J5wqk0uSQ6J/Q
         Iv/t45HrkpP0sveAhKWaJccRgIcj4rq11JcgkzEAEPVPFZvgp8SZD8INMtD0/NW56rXm
         Wxrwru0eKPHDLS9899wmpG5s7TFqHf3U1RmnsIabAqemuhx/G4aONgf6kFy9CZKoPfhN
         py1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ycwq8+30tB5ctR2/HDwzHBF9BstFNNQQL2o8JRXDSQM=;
        b=ZpmqBXZ5vlzDVxYKcF2SJ7GSOVE9ct15YRxGfp5SqE60wqGkfaQj4X8WDrc+xDy2Oe
         43qyn5Trmj1ToACCil6kwS3h4tc6VNLO8E4mn0ErzwyTRQioPuKrVIf7y63OSpv2YF8T
         btJzJLqOSZY08WiG7neLctVQE8LxKuL6wW7Awg9oYC03NBmNXBrExgNl427WPjqYEn7B
         VcBKSvSxInZzZeCUCrxF82upGlQBvIrBvhGwKsapiYD05eABhP0ZTnNtaBrlWx2keQYz
         wYyy2Jtq+CS47Lb6GgAkJm19hBekU2amGB5RZQH1eQRJzyNU+816Wj38WiZzfpH0aQgK
         TzgQ==
X-Gm-Message-State: AOAM5302lz8uJ3jq00astlyE63wM+WPEcEjtH86HNlwkl/+iZmcPDnhI
        SylHuR2a6Iy5kTns94CZJh0m1+tfSK6l4tyRjyM=
X-Google-Smtp-Source: ABdhPJwfSMIk9MUIzAE/QJhrYe8zts9R36HWxy+us2FjyvBsouDOdmpgoJrQy5tzEolzDg9jltP4bA==
X-Received: by 2002:a63:65c5:: with SMTP id z188mr4358540pgb.35.1631788886012;
        Thu, 16 Sep 2021 03:41:26 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id w30sm1932735pjj.30.2021.09.16.03.41.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Sep 2021 03:41:25 -0700 (PDT)
Message-ID: <61431f55.1c69fb81.5af23.610d@mx.google.com>
Date:   Thu, 16 Sep 2021 03:41:25 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.13.17-349-g6b59c9139e8e
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.13
Subject: stable-rc/queue/5.13 baseline: 76 runs,
 1 regressions (v5.13.17-349-g6b59c9139e8e)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.13 baseline: 76 runs, 1 regressions (v5.13.17-349-g6b59c9=
139e8e)

Regressions Summary
-------------------

platform                | arch  | lab        | compiler | defconfig | regre=
ssions
------------------------+-------+------------+----------+-----------+------=
------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe | gcc-8    | defconfig | 1    =
      =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.13/ker=
nel/v5.13.17-349-g6b59c9139e8e/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.13
  Describe: v5.13.17-349-g6b59c9139e8e
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      6b59c9139e8eb0a2e737904949a52089f7a45268 =



Test Regressions
---------------- =



platform                | arch  | lab        | compiler | defconfig | regre=
ssions
------------------------+-------+------------+----------+-----------+------=
------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe | gcc-8    | defconfig | 1    =
      =


  Details:     https://kernelci.org/test/plan/id/6142e7a9be96851dff99a2dd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.17-=
349-g6b59c9139e8e/arm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-bana=
napi-m64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.17-=
349-g6b59c9139e8e/arm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-bana=
napi-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6142e7a9be96851dff99a=
2de
        failing since 2 days (last pass: v5.13.16-263-g6cdb0b2e1c97, first =
fail: v5.13.16-300-gcec7fe49ccd1) =

 =20
