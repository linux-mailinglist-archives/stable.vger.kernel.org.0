Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0C5E39379A
	for <lists+stable@lfdr.de>; Thu, 27 May 2021 22:51:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229918AbhE0UxQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 May 2021 16:53:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229835AbhE0UxP (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 May 2021 16:53:15 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 873C1C061574
        for <stable@vger.kernel.org>; Thu, 27 May 2021 13:51:41 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id h12so544427plf.11
        for <stable@vger.kernel.org>; Thu, 27 May 2021 13:51:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Ci7tGcbFDsY2yODSlrlJmBxuUWbyqHwBqqjpwO9ij88=;
        b=rPSFEmHshT+b3phkylkp6ZLponmbmT4xD9BmbQs5G1HTirI3Z8NLbq2Kdqvvo2mETe
         Sh96cfIYYldLMuz2kaMPyB7lJXbJnMsUqnxBatd+vL+DCe4GFEDFtgn5AGzUg0s0euFT
         VeNXvugPd87wYXzVfjumIMi2KwQ4z3HwVwuFIOcNzIlQGPy4LynkBwoQgL/Uth3EwBel
         4T4HFZEG1QdBEnOVvDnYIqf2h2SH9gO6tfSRXthLBlCs3TCeH4xGjD0c6uC5qqIGuiIu
         r2kwBZNiYuUyTUcSIhcKntZox9Po9QJ71x5bzr2zuT2+ub8hzdpGEhbgagubjxuqA1RD
         2fQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Ci7tGcbFDsY2yODSlrlJmBxuUWbyqHwBqqjpwO9ij88=;
        b=CIhMnRcN1eUl2WqWTz6mAXY4NEcOu9SRB75SLJrOjb0Wwv53p7e0Yyr/vY83jFDGOv
         mw0ft6iblL/HaSaJ9s2+CrodWkIDMMARO3SPXWHKmnXfumLriupG4y/9g+sHeueIm/fB
         3bcsOSSIbbAqrh89kGQIAIv0TM6pI6s+zg+E8spqkk3G2GvQ8gSEv4a5d78hP7KaSeBw
         nLi7pKvITvusUYu5gTJsl0WF2yVXsdgNlg3bkjusE8dU/b60qDPlhpoO70kZZNZHZ7JA
         6zcngIK06ZWnXY/PdNKYftMQ7Bg5he1wX4StMIr5jD8ilAuFjkdmLSjFpDgm3mWDCsLI
         IKHA==
X-Gm-Message-State: AOAM530f6jhpK6fFCiYLKpTIhBymRnTcmchRDLPwdxiqFynlB8kQCSY6
        uxN52fQAUnVeCb+qt5M2W4vt2Eg1MPR+QQ==
X-Google-Smtp-Source: ABdhPJzjuRchmBYL+hfPzBvPvpn2CKn+wIi7cUJWJGqq71Dws3xn9ktakk69OCUM4fzD2qYgQzX83g==
X-Received: by 2002:a17:90a:f503:: with SMTP id cs3mr317748pjb.157.1622148700879;
        Thu, 27 May 2021 13:51:40 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id n23sm2648587pff.93.2021.05.27.13.51.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 May 2021 13:51:39 -0700 (PDT)
Message-ID: <60b0065b.1c69fb81.6f8f0.999e@mx.google.com>
Date:   Thu, 27 May 2021 13:51:39 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.12.7-8-g6fc814b4a8b3
X-Kernelci-Branch: linux-5.12.y
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-5.12.y baseline: 117 runs,
 1 regressions (v5.12.7-8-g6fc814b4a8b3)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.12.y baseline: 117 runs, 1 regressions (v5.12.7-8-g6fc814=
b4a8b3)

Regressions Summary
-------------------

platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.12.y/ker=
nel/v5.12.7-8-g6fc814b4a8b3/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.12.y
  Describe: v5.12.7-8-g6fc814b4a8b3
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      6fc814b4a8b359a7a3231350692901f00e9d179b =



Test Regressions
---------------- =



platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/60afcc37160f9f19e3b3afb2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.12.y/v5.12.7=
-8-g6fc814b4a8b3/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.12.y/v5.12.7=
-8-g6fc814b4a8b3/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60afcc37160f9f19e3b3a=
fb3
        new failure (last pass: v5.12.7) =

 =20
