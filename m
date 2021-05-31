Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E69F39685B
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 21:28:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231201AbhEaTab (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 15:30:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230308AbhEaTaa (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 May 2021 15:30:30 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97698C061574
        for <stable@vger.kernel.org>; Mon, 31 May 2021 12:28:50 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id o17-20020a17090a9f91b029015cef5b3c50so110340pjp.4
        for <stable@vger.kernel.org>; Mon, 31 May 2021 12:28:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=6MRpmcsflPs8BMYXJvs40FMKV8hHbg16MyhsZCI2jbE=;
        b=puPwFfWCxx1MWx3nm8r4K0HAr2OruSOv+RM+zRTvxVElcs4yoNq4/kzk0wKyBJJNPA
         xgnL+mQWPuJ2S3GKjefnHve/q6FFBE1ykuuknmPsZoLIJB9HuJd7PWSxCRyVHfdCqo2r
         dBSoGHnxhBQlRZB/6eHaJ0Suu0hjhrSrCFC7rWFDfwqLbkYzKPlH0TFhv/3kdIcA6zqE
         IV9PhAR62emmGO0kJstedgaVrB9B3vz5romiMDkKsG3PnyS+Yyngs4cO+RYPJf7BGjK+
         1Y++4yhCNiC5dvSzA9p2yYF/kzSB2FJbnCYgVefbtrTu4sXI6BLJgxfIvIIQ9rvHdset
         X/XQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=6MRpmcsflPs8BMYXJvs40FMKV8hHbg16MyhsZCI2jbE=;
        b=NFhlSzUNOMi3rFgv2r5vRTid1PgFTAhrSOqHhB0tJzdwTmEY86YqaRnObRtwXwmKvD
         yUQiGb3JI+h7ehHh7esE8cAgI6BKiGV3uchni8v+ia3MEWV6Zs+po0iiCfIgjwdKjjz+
         zW30a+QCgxJzNPvuVwHRdtce2tI5GPuzTpvApx6UDrtqFwQzxWjFcUgJsfN0NLzG5PW2
         BtUwIx0/SBJTjAeKejTdX1ZOFKLtbyjqZBzJgpJURaHjEE0+P3SnNHBrNagycY5YjJGV
         PZzG29wNfSyqtgyPoUplhx5Q6DHX3PJTrxol4D6c84NKTxLU4nPAQifF5pRmUJ5sNpRa
         FpOA==
X-Gm-Message-State: AOAM5321GUoGvcWYJW44WdU2N2p9i2fgfphQtSEN4PQfuXVdDSnp17Gp
        4+0xKQ6B7i3cb84adLpqDIR7l4MMpkQlkJsN
X-Google-Smtp-Source: ABdhPJwnUMKjJxwWl/NVSCMPLxK7vwWRYSTXwNIQPjO9fir/2mO3e7rg3dDtYXdSd6H1TpMVZFo47Q==
X-Received: by 2002:a17:90a:b885:: with SMTP id o5mr638636pjr.91.1622489329876;
        Mon, 31 May 2021 12:28:49 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id r4sm11098781pff.197.2021.05.31.12.28.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 May 2021 12:28:49 -0700 (PDT)
Message-ID: <60b538f1.1c69fb81.aad35.371d@mx.google.com>
Date:   Mon, 31 May 2021 12:28:49 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.10.40-262-ge442e564efd9
X-Kernelci-Branch: queue/5.10
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.10 baseline: 157 runs,
 1 regressions (v5.10.40-262-ge442e564efd9)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 157 runs, 1 regressions (v5.10.40-262-ge442e=
564efd9)

Regressions Summary
-------------------

platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.40-262-ge442e564efd9/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.40-262-ge442e564efd9
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      e442e564efd92594cafaea3987b46e8069108bd0 =



Test Regressions
---------------- =



platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/60b5039c9df0e060c9b3afb8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.40-=
262-ge442e564efd9/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.40-=
262-ge442e564efd9/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60b5039c9df0e060c9b3a=
fb9
        failing since 0 day (last pass: v5.10.40-98-gef1477410758, first fa=
il: v5.10.40-139-g2cb2acbbafd8) =

 =20
