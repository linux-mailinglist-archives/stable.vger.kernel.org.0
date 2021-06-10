Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB22D3A33DA
	for <lists+stable@lfdr.de>; Thu, 10 Jun 2021 21:19:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230281AbhFJTVW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Jun 2021 15:21:22 -0400
Received: from mail-pj1-f53.google.com ([209.85.216.53]:38851 "EHLO
        mail-pj1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230217AbhFJTVV (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Jun 2021 15:21:21 -0400
Received: by mail-pj1-f53.google.com with SMTP id m13-20020a17090b068db02901656cc93a75so4349488pjz.3
        for <stable@vger.kernel.org>; Thu, 10 Jun 2021 12:19:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=tb+KHOyiVMXUY39PCFMxylMrmMk1pdo9yXPaAoPyvrg=;
        b=VIia0GRSmtQraN6Ti4aDf9UBaBiTc3YyCcVMeFND+PdJz29GfffEFfri1TdFVU0ti5
         lrLe7B9dPEpZHJ09EwdL14QR2lKjLQwsQFso3Bhl5CCaE8mnnOW5wjHnmDmeZ9KKK4bg
         rr3bou4iHl+GrCZhaXe8jishczTpTceS7vULo3Hn3C+WVehS9ufvCJEMxj8uW7gwpsG7
         XbZjrZm2W1+jTfK/0QQTHWNx1SmQPgu6ezIZqFDDLpfOS6tEDfdcGcwNA+scZmh6XBtJ
         R7/YoDj+qfno1xxmnkCxBxbqhIgfCgvMS60raUIYgfElZJIyQobxVHEY7mlXqxrlqCgK
         Tauw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=tb+KHOyiVMXUY39PCFMxylMrmMk1pdo9yXPaAoPyvrg=;
        b=sc9LFWZxMV5+leJyuEs0J585MGw/8dyIQ8itndoJ2yBGWftu81pXSkoSHc1apbLLVd
         y1CVhThGYbInlhTAdrSEbNaopBbceTm2fyQ+4vp6ql1aKmT7fL5WISyqF+6reLYol1VO
         7obsAEHy2eiLfinCFVNuEuK61BiF8mGEDlFGzgKhPssXGwWLC3FItp2Cgl9ghT13k+V5
         aBjgHiRipp8BI0GOsXZ0VtpN/FkBjQHsjl/8z1viZ92aaABf/Cludea4vgOa2XU2FStA
         gv+rOrMr1FdHu+D5S6qvIsfjBfbfA7sz28svCF+IMB6KRbNBnJQaWXEdnLSQrY7clqJ4
         B6Tw==
X-Gm-Message-State: AOAM53219WqOgK01e7GYMWycudb716svofR+w5WY1rUbH1rFUD3HRlFx
        9o/8hPnnTafmn4k/dhJmloWPXbsc+wlGY5kW
X-Google-Smtp-Source: ABdhPJymeCKGlya2W54we16Rn53SlmHTMRQgSJYor12J5jg0H+mEjBZXydmieTXfQteWOXG56hy8+A==
X-Received: by 2002:a17:902:8f8f:b029:107:810b:9ee5 with SMTP id z15-20020a1709028f8fb0290107810b9ee5mr280372plo.4.1623352690996;
        Thu, 10 Jun 2021 12:18:10 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id u8sm3500948pgg.51.2021.06.10.12.18.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Jun 2021 12:18:10 -0700 (PDT)
Message-ID: <60c26572.1c69fb81.39377.b2e5@mx.google.com>
Date:   Thu, 10 Jun 2021 12:18:10 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.10.43
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-5.10.y
Subject: stable/linux-5.10.y baseline: 175 runs, 1 regressions (v5.10.43)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.10.y baseline: 175 runs, 1 regressions (v5.10.43)

Regressions Summary
-------------------

platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.10.y/kernel=
/v5.10.43/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.10.y
  Describe: v5.10.43
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      951358a824f96be927ae50fad1e72e05bbb57b56 =



Test Regressions
---------------- =



platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/60c23274be7918333e0c0e07

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.43/a=
rm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.43/a=
rm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60c23274be7918333e0c0=
e08
        failing since 12 days (last pass: v5.10.40, first fail: v5.10.41) =

 =20
