Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C67FE3811E0
	for <lists+stable@lfdr.de>; Fri, 14 May 2021 22:35:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231380AbhENUgs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 May 2021 16:36:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229932AbhENUgp (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 May 2021 16:36:45 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22DD5C061574
        for <stable@vger.kernel.org>; Fri, 14 May 2021 13:35:34 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id l70so175726pga.1
        for <stable@vger.kernel.org>; Fri, 14 May 2021 13:35:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=jiKUSbeqWed+IIT9WmkGGB9zdypx/D6xpK6v5hZCneQ=;
        b=R/x2qldbR/P/1twZ4FdFWAAujupixqrhsMeyS9v9AqZB7FbCBj3ICgCdhnIR0Xvzem
         w7ZTuNbTMVDWliFOTDifUi9qj38BzCSMvBEMKPblxgfrg0lBLyAg5bNlJzEVyADUcKXk
         QTED1bxYKNcybahHxM98YqU3LU7zXZaLL+GvErLamWL5dEDc7MU4JjY63LIdO5eeNXUL
         TXwOYxnq4NdaUUK+lpt1ur2KOdmtAaY4UxHuV+dzu5YGTMVVnH8EC5INd66rkrFIoelS
         0v89eJOsvQ08JENpauZ/luA3jjf8e7AwW8zpNAPRvlLsspD+mzKrGAxI3VLBs11jLtYb
         0ORw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=jiKUSbeqWed+IIT9WmkGGB9zdypx/D6xpK6v5hZCneQ=;
        b=iPJ+If2LOjMotVyquhei/0NrZcJZI1si4KK8JBE5DPHRhXe6IfZSzVT+MLSGjUhJtc
         z70T7zBChwfhYZ0r68g8iS9KDGwyTHm4Fe49n7KARUpsL6PnWNfbZp23kRl5SbNYrA+S
         Tm1BtOkImB6a5dpO3ymHV0aqNdxnRFU0u/JTX1q9CbybYhbJxoWH6+yaNoPK4XfVGpGy
         ucyN6igUr7gLvqIBQDOvTaMSJCuqDxc4w5+5xfs0whUXZ5xSso0e79+29zM9+nbE7JZM
         bAUm7wgGRq4+phjP9qQ/WJQTJ+oxkFT8C2Wq3ZEdSk9l0xuS2fsaukg83WORDZ/uXEEo
         D04Q==
X-Gm-Message-State: AOAM531pPE4JOHjM16ReKQ2Aswk1se0E6HJnfeb/JzJYbrn0gUl/6oAq
        UoJDpkhGS3OeO7sM7JxKfOszHBhyKUdsPlqc
X-Google-Smtp-Source: ABdhPJxMsuMHH7+fdPmBdJjge1BNHt1LtXxk7roiwrOmcVlB84qTIBZNYuqzi6pmwHp2oVszYPG4oA==
X-Received: by 2002:a63:214b:: with SMTP id s11mr12655536pgm.423.1621024533532;
        Fri, 14 May 2021 13:35:33 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id t20sm4721515pgk.55.2021.05.14.13.35.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 May 2021 13:35:33 -0700 (PDT)
Message-ID: <609edf15.1c69fb81.80ba.0e99@mx.google.com>
Date:   Fri, 14 May 2021 13:35:33 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable
X-Kernelci-Kernel: v5.10.37
X-Kernelci-Branch: linux-5.10.y
X-Kernelci-Report-Type: test
Subject: stable/linux-5.10.y baseline: 133 runs, 1 regressions (v5.10.37)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.10.y baseline: 133 runs, 1 regressions (v5.10.37)

Regressions Summary
-------------------

platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.10.y/kernel=
/v5.10.37/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.10.y
  Describe: v5.10.37
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      e97bd1e03e6ef58ec47ee7f085f8c14ed6329cf7 =



Test Regressions
---------------- =



platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/609eaf0233188e987cb3afa3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.37/a=
rm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.37/a=
rm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/609eaf0233188e987cb3a=
fa4
        failing since 12 days (last pass: v5.10.33, first fail: v5.10.34) =

 =20
