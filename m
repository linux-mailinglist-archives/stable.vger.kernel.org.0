Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B27583254E7
	for <lists+stable@lfdr.de>; Thu, 25 Feb 2021 18:54:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232926AbhBYRyg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Feb 2021 12:54:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233207AbhBYRyE (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Feb 2021 12:54:04 -0500
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 645DBC061574
        for <stable@vger.kernel.org>; Thu, 25 Feb 2021 09:53:23 -0800 (PST)
Received: by mail-pf1-x434.google.com with SMTP id z5so4121080pfe.3
        for <stable@vger.kernel.org>; Thu, 25 Feb 2021 09:53:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=6V6QUFmIHozcExEOUUCJu84dcf6Uy0PeqeV03Xf1m9E=;
        b=Pfz/mGnkJb6qu3dKOEjADssdGHF+8+YkJu3Ia2znm8kx9Icvm0uDtNUYgEzYPYkuVo
         Ik6cimRxulcS6Bi9zn0asrTaH0ur5Kq6XBgIT3P3Cqhly9uDvqCFot4PXtfllSJL8Ane
         uqTe6FNq6fZPrV6ofkpyt4e7A/6F3Xfhjq5Z5G/vsoL++5x/2iBxbaJJxZjEqY75A02n
         0f+EI7jsH7CtF8CR6KWKpy24+LYoCggbfhMpkTHXP6E98Xb/YVr0EwaHGCKQ4w1n8pRe
         nd+kmV2DHrnVtAHfOFUuQ5s66WB8WvNyrVAREVuuJG74IX2yj7nHcIGULwmkXWPXb+RE
         qSYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=6V6QUFmIHozcExEOUUCJu84dcf6Uy0PeqeV03Xf1m9E=;
        b=AjCuVEW2nRWiXNhOv4wZbj90UCrUASmT0k5nF8EI9RbO/nL2U+ZJSOZVQUjK0s+NOA
         7h3cff7TN46c9Ydb77g4U2QCpns3G3PxRS7QJ4H/O6N9HItmitzoiLCtjx8WM2HMfj/V
         D7odH/VV0fZLyg7tuLhXngr4VnpTbSMdT1Q2O0Uv/DWgmxvo4eU5hjUSuomTec1fKrrr
         9Rdznbr1MwBtaC/JlyVk8vEvBfVaK1SjNu+9Rux4sHOtllgJFn5UdNNxP76r0FqdJErO
         3WA0PDVcc4QYWqNbn9apJhu1KnjQafOWIIYsoZ5fFIePvA4Jn1YtyNUbEuzvo2Xtq2mm
         4DKg==
X-Gm-Message-State: AOAM531JiWAeL4TjoXL74/eZLgfm6iYrPM4EbJj4V5AOI6CAdJIsSRPB
        4TnJtKIzO2GT9IUCbySL+JY1eWoMYkTkFw==
X-Google-Smtp-Source: ABdhPJyiNftWWjnr7bYUgfLsAZIYijFzfLKaxT13crrT7j//dcm9d2bXyHsU6UNXSpP4LwxmFeG8jA==
X-Received: by 2002:aa7:90c4:0:b029:1ed:2937:a9aa with SMTP id k4-20020aa790c40000b02901ed2937a9aamr4417041pfk.8.1614275602730;
        Thu, 25 Feb 2021 09:53:22 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id c8sm6717145pjv.18.2021.02.25.09.53.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Feb 2021 09:53:22 -0800 (PST)
Message-ID: <6037e412.1c69fb81.c0cd0.e282@mx.google.com>
Date:   Thu, 25 Feb 2021 09:53:22 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.10.18-24-g6ffb943c0e01
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.10.y
Subject: stable-rc/linux-5.10.y baseline: 107 runs,
 1 regressions (v5.10.18-24-g6ffb943c0e01)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.10.y baseline: 107 runs, 1 regressions (v5.10.18-24-g6ffb=
943c0e01)

Regressions Summary
-------------------

platform        | arch  | lab          | compiler | defconfig | regressions
----------------+-------+--------------+----------+-----------+------------
meson-gxbb-p200 | arm64 | lab-baylibre | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.10.y/ker=
nel/v5.10.18-24-g6ffb943c0e01/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.10.y
  Describe: v5.10.18-24-g6ffb943c0e01
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      6ffb943c0e01d843a06842f9a7bcfc008e10a6d2 =



Test Regressions
---------------- =



platform        | arch  | lab          | compiler | defconfig | regressions
----------------+-------+--------------+----------+-----------+------------
meson-gxbb-p200 | arm64 | lab-baylibre | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/6037ac979bbf8d8ee2addcb4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
8-24-g6ffb943c0e01/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-p=
200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
8-24-g6ffb943c0e01/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-p=
200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6037ac979bbf8d8ee2add=
cb5
        new failure (last pass: v5.10.18) =

 =20
