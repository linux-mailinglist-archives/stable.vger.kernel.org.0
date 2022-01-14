Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9616848E2EF
	for <lists+stable@lfdr.de>; Fri, 14 Jan 2022 04:22:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236306AbiANDWi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jan 2022 22:22:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233629AbiANDWi (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Jan 2022 22:22:38 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C91B8C061574
        for <stable@vger.kernel.org>; Thu, 13 Jan 2022 19:22:37 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id u15so12217007ple.2
        for <stable@vger.kernel.org>; Thu, 13 Jan 2022 19:22:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=D2ovszvwPyHEUHBOnNCBPkNAoJWnRAQosk0tow7aAiI=;
        b=TF7z43qUwRzAUVgZthdnsaLSZjhuo9BF10QqG4vbfEhJUwdGI2QJ03Imqw27mtQv3N
         lpp573S/L77JZI/qOWztdx234YM9vRUVP4Zw8MfQf/Tcq1xKbN73ygCRJL8xj9zAabTb
         Axocczkv08WSBauPrmhAi90ht62hi220IlKmxKWDBqF1u9mSoVXkOtpNle5MbSVcHv5H
         /Zylw6vCa3+q65yCldM3/yWvtKRAu/Sr/fqYJbbXC9lpmpS0bVTOw9dikJBk3JWtlcms
         6cDLSjmqteP7VR5OUHRYRnIBdPCwS8rauK0E1fYAvZSh7g+1dCj+6puGYxTyEZttbiHD
         M4UQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=D2ovszvwPyHEUHBOnNCBPkNAoJWnRAQosk0tow7aAiI=;
        b=WJ0SgoxGtAibP9VeurUPib/M8nCIxj06mRSErKuJdUKTGRwKh4KvjCebB8Mc8MjMM0
         RxOKKYIfDf0l7mcdxMBLPKz2f5QLPJv1BEkBPGSyGskaNAN9E/VWN5jN9wNGoc8GwVQ0
         lUpIlNZCLiDVbsdFH1EvkiIh6pLE/pf92h2uOeKTB9xvkBimCwOhZdy3drbv1YNjTsqU
         PZvDlcOvA5jruQ6buHVi266qrN6wcyKEuxWVNzatPI1zeHLRnKqvArjawFeL7hDJFRFD
         PKVaAy/cm4PdS3WDVSWBpFXQheVHf9EICzYfTGpkSIgfsk60T2MzXxbDh3Ue7Ykw7GBm
         hgFw==
X-Gm-Message-State: AOAM530oE8QUSimn/GqUDsSLp+e3IjsWO9i30k41EU5xEKMAzayCAv3X
        CFyfsO2RKdPeNyIkNnjb2K7bw88/4hoZ/yv0fgc=
X-Google-Smtp-Source: ABdhPJw1xFn1uBTXLL+dp9e6oMf3Dj6eqZ1M9N56fHvEgxjJlSeWg/ScRDfO+M6H+6MSoYHejVqQ0w==
X-Received: by 2002:a17:902:e54f:b0:14a:1bbf:9cf0 with SMTP id n15-20020a170902e54f00b0014a1bbf9cf0mr7650466plf.158.1642130557055;
        Thu, 13 Jan 2022 19:22:37 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id p37sm4484529pfh.97.2022.01.13.19.22.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Jan 2022 19:22:36 -0800 (PST)
Message-ID: <61e0ec7c.1c69fb81.ca502.da87@mx.google.com>
Date:   Thu, 13 Jan 2022 19:22:36 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.15.14-38-g674c2698ca85
X-Kernelci-Branch: queue/5.15
Subject: stable-rc/queue/5.15 baseline: 161 runs,
 1 regressions (v5.15.14-38-g674c2698ca85)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.15 baseline: 161 runs, 1 regressions (v5.15.14-38-g674c26=
98ca85)

Regressions Summary
-------------------

platform                | arch  | lab        | compiler | defconfig | regre=
ssions
------------------------+-------+------------+----------+-----------+------=
------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe | gcc-10   | defconfig | 1    =
      =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.14-38-g674c2698ca85/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.14-38-g674c2698ca85
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      674c2698ca85323bf72e0fb7369eb3faefe2526a =



Test Regressions
---------------- =



platform                | arch  | lab        | compiler | defconfig | regre=
ssions
------------------------+-------+------------+----------+-----------+------=
------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe | gcc-10   | defconfig | 1    =
      =


  Details:     https://kernelci.org/test/plan/id/61e0bc9440ace8df9cef6755

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.14-=
38-g674c2698ca85/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-bana=
napi-m64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.14-=
38-g674c2698ca85/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-bana=
napi-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61e0bc9440ace8df9cef6=
756
        new failure (last pass: v5.15.14-30-g61a4fd6dbce8) =

 =20
