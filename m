Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4274F322068
	for <lists+stable@lfdr.de>; Mon, 22 Feb 2021 20:45:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233339AbhBVTok (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Feb 2021 14:44:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232782AbhBVTog (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Feb 2021 14:44:36 -0500
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56BF2C061574
        for <stable@vger.kernel.org>; Mon, 22 Feb 2021 11:43:56 -0800 (PST)
Received: by mail-pf1-x436.google.com with SMTP id r5so1277926pfh.13
        for <stable@vger.kernel.org>; Mon, 22 Feb 2021 11:43:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=f1Jx7FHs7Eh1+lOKGaO1k2mo2IO9CdTk5RuKLK0UEXE=;
        b=faaHbdOokis2R6maiAusy4HWyNWXkxSA+L+m5FaP2lI5Ggoq8IJ1S1zRkDe613e7kw
         g5KzqcIaYxLINFDKffKgE+garwKHYXx5WUYXFj63qR6CXS0x4sMtLjCluGnHOeexeBoW
         J/eqHht073wJ6izc1QXeVB68cCxiuL9oHpwhKBiMqfDQ9manawm+//B5bR/T/wJ5SoU5
         XhkRKFGyZ6wXqG/qbtAvirQIPe+y4j073xp6UYv/caRQ8RS12rt7kihUTHxUX6sWes1a
         jYMqp+QNJ1+rQtY3P/dSobvtwmJAdIYnHkXB0jUpPQhwYhKI7WjEDSGtowVDZeAZQSlu
         XvcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=f1Jx7FHs7Eh1+lOKGaO1k2mo2IO9CdTk5RuKLK0UEXE=;
        b=FPKURpbEBi4/1VhIqA6zykNwwpzRlA/LpbzC+v0Ac8hfCXgu2ktvKYDcELJbbFPhdn
         RpNvHlCkOtp/52iGt4HCATB8Lj6g48Wcf+ofkMYp84M1RAyj2uOiyRv0DIEnsQL/m8GX
         zxNT2LkNkeNEZhabBhzGkjqGxcYQ+s4qKFiv4cRMqOjw19QsYE3tDgqy0CgxeUFSlzTY
         MYtLlybafZ2qR1x/RdyEjswSDNvGT74dzIit3z+8IFloDlKgmRnTcSOWSxwnUlvGNwOH
         mQ8UCcD6IeSh2YoJJvt3XoFHh6AczNm5oSbCj9dfxCO1S6j72Zzcusmb5PdChkRx9HxY
         3I1w==
X-Gm-Message-State: AOAM531nvKGdiI+qj8AEsZJCztXgd+PrOJFw1Ghr/e+RQNVpWTn0+xrK
        tBOKYE5IUsKj+c3ybrRFPh4+1kU1eJzR2A==
X-Google-Smtp-Source: ABdhPJyE/1kNGyZ92au4r80H15eWcLHrHXb4P4GcS50Gvtuejb9VDSitPiaicXxO17vw4n7tVMxhOA==
X-Received: by 2002:a63:f04b:: with SMTP id s11mr20872924pgj.352.1614023035563;
        Mon, 22 Feb 2021 11:43:55 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id k5sm214892pjl.50.2021.02.22.11.43.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Feb 2021 11:43:55 -0800 (PST)
Message-ID: <6034097b.1c69fb81.29a4b.0895@mx.google.com>
Date:   Mon, 22 Feb 2021 11:43:55 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.10.17-29-g17962b3a67b5
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
Subject: stable-rc/queue/5.10 baseline: 112 runs,
 1 regressions (v5.10.17-29-g17962b3a67b5)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 112 runs, 1 regressions (v5.10.17-29-g17962b=
3a67b5)

Regressions Summary
-------------------

platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.17-29-g17962b3a67b5/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.17-29-g17962b3a67b5
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      17962b3a67b503fa133e1af7ec3301155b4de5e3 =



Test Regressions
---------------- =



platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/6033d63f66b3bd3629addcb8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.17-=
29-g17962b3a67b5/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.17-=
29-g17962b3a67b5/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6033d63f66b3bd3629add=
cb9
        new failure (last pass: v5.10.17-29-g1b13e2554bc40) =

 =20
