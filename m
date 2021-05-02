Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A509A370E20
	for <lists+stable@lfdr.de>; Sun,  2 May 2021 19:10:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231788AbhEBRLG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 2 May 2021 13:11:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230110AbhEBRLG (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 2 May 2021 13:11:06 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA9BEC06174A
        for <stable@vger.kernel.org>; Sun,  2 May 2021 10:10:14 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id ge1so1727327pjb.2
        for <stable@vger.kernel.org>; Sun, 02 May 2021 10:10:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Wk2D+B7TZ4Ke2K48tr4tqzPXguX750txWfb4csnT2iI=;
        b=BAzPK9a7ZeJzMGnsqrk1lSKCczn7iTVxKw+U84bUd+vzd2dJU5UTB8tCWZgKRokCRB
         aeVBgnuBjZMz9qWhhuWbAW6dRWnyd8TXoHTZGgSnDfRB+RzWAv6oFCyHWhkNoR7B4CSb
         oPYLmvygOM79i63L1NdEDOhGMQRrPjS/te6YxCUo74fasjYOpk+ITpSEz2IBbCt1+IBL
         UsEdG0ySH9Xry2RVwN9RKL85y+QGuMhKv6JUI5e1TT/+1s3sdxqXTqzQmF/FemEilA9K
         CJukdHvpqjvbK4REvV5LzzcEWN6utNguwbBvRFI0b762Tk5YkkQ43KGqTcgd+hjljgP2
         cxRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Wk2D+B7TZ4Ke2K48tr4tqzPXguX750txWfb4csnT2iI=;
        b=UdH3xS66YmG7/lpzIa268b1zHGw/qesBQIVlIcA/jcSX5PusSQ298TghTZxs4zbqDM
         vdLBcVKnTy+5lcr0/cx92xnebc4HITaviku3Zt1+4YtFI/ZebU536JJ3vXjuiR222WI3
         VUxFn22RFSfsoQXFuXG5BJ4Rwd/rRKdgEycvg344UBWGg729QRJeun3IQCmzcDg6SvM4
         oZU1UXmS+GZUqLBs5Ng+YknEhF1RHcJPk7EUDAZdMaNULFfDPLH/IYPuP9ufc5N0o4uM
         r7rTr9qJrPuig59rXIfkgvrorwdRGD/6r7sXCIHxUjbzewCFqNIzHb9pk8PFN9COZ0Sb
         fYbQ==
X-Gm-Message-State: AOAM5302U0vs0nmkwkVQmdBBm6wl6mWIX0YyLvdHx+0zwL+jW5BOZtXN
        CziRWf3wq3OnW6Ai76L/2znYdU5WyE8mVhXN
X-Google-Smtp-Source: ABdhPJzN/C+47ELJCLODNpGJ06oarpdcGJ1ko1iRdYho9oCidmeTzy4NeLdJ9PI7Ecudr5nXVc12xQ==
X-Received: by 2002:a17:90a:4dcf:: with SMTP id r15mr4945848pjl.78.1619975414012;
        Sun, 02 May 2021 10:10:14 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id t192sm1382370pfc.56.2021.05.02.10.10.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 02 May 2021 10:10:13 -0700 (PDT)
Message-ID: <608edcf5.1c69fb81.13b7d.3532@mx.google.com>
Date:   Sun, 02 May 2021 10:10:13 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.10.34
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-5.10.y
Subject: stable/linux-5.10.y baseline: 64 runs, 1 regressions (v5.10.34)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.10.y baseline: 64 runs, 1 regressions (v5.10.34)

Regressions Summary
-------------------

platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.10.y/kernel=
/v5.10.34/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.10.y
  Describe: v5.10.34
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      0aa66717f684f0280cc9bccf50f603e80d05495b =



Test Regressions
---------------- =



platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/608eadfc3de88f25c79b779a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.34/a=
rm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.34/a=
rm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/608eadfc3de88f25c79b7=
79b
        new failure (last pass: v5.10.33) =

 =20
