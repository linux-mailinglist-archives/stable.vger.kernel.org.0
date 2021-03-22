Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12B91344971
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 16:43:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230179AbhCVPmj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 11:42:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230166AbhCVPmT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Mar 2021 11:42:19 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FF6AC061574
        for <stable@vger.kernel.org>; Mon, 22 Mar 2021 08:42:19 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id mz6-20020a17090b3786b02900c16cb41d63so8750654pjb.2
        for <stable@vger.kernel.org>; Mon, 22 Mar 2021 08:42:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Mec9Rz7/5Fngyt/PuouCRuoAUCy6h4USqRadG/lUR74=;
        b=AMKNvCEFiyEAxCcTpYLMXgUSJDskoIqHQRKq+edDaZEc6MkkaG4BWH1+d0DV0qj8yw
         0smwfpkbNjW5BwcGILyhsQ/jIiz5RTxuPaE6GcWQoHXRi5PRwQxoWhIthfui/1N6tZVj
         IJGJqEWKAfyVzz98kV7Ne+/+YjhinT7RhNdK7tGTzNh7qMgtM/dilBzMGqJ8GGvEIKcp
         4YMIUMRThOniMJpGwzyPk7cvkWpRwlYNQ2rgDq9kZajj+4yfVuIbX0OjjPcekUuU3y0D
         j4uexkCjZ4eB3jTx/PgcGbWrPzRyM/RoRBQBlgaE/esH5+kweqYBW+kOM54+ymMXlwVx
         X28A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Mec9Rz7/5Fngyt/PuouCRuoAUCy6h4USqRadG/lUR74=;
        b=qrzpnkD4ueBGBgWAeyLyk40/Yi61WjmRDwTJHMixFiXy1579Uk5xELGZLPHK2xvFPP
         jRsXAtatOSHD9y8POnHRY7VjQOv08+Xj99F2nzXOQlTodY4MlfPMeWM1agv1mBAd3So4
         CQM05OF4RCkeIfRcR7bLacleS6XzrviKBXI8kmutqe3qQjzbOn2OAF7hMupJAe+BNgTO
         GBNMviAmQOuEP2+LSbFHalmPBJASvcFhQm2Oj/xqVvOcqhCCaVT6AhQAdqNq12492+Fr
         Z7EawYKA1t8jNOA0Q1jk5Dw4F35Xr+kE8E831Stk/LRolsn60BSbB4IqphVnCutlrg9i
         SE5A==
X-Gm-Message-State: AOAM531YI5c1bKMyKYkIdaoATLXye2ASDkbq8B8M9YSmD6RIwU09H3Wc
        5mVrekEA2HkKNzLnCiPT38JNM2knsp5vCg==
X-Google-Smtp-Source: ABdhPJw1NnR3mqFK1k4uMv6/CPNLxBAHaJnXrJRlIh/a4JSRGCdzu+5PYnyrOPV35AT0oVwR4DXNZA==
X-Received: by 2002:a17:90a:fa0b:: with SMTP id cm11mr13109pjb.140.1616427738869;
        Mon, 22 Mar 2021 08:42:18 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id w2sm13352040pgh.54.2021.03.22.08.42.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Mar 2021 08:42:18 -0700 (PDT)
Message-ID: <6058bada.1c69fb81.726a9.0583@mx.google.com>
Date:   Mon, 22 Mar 2021 08:42:18 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.4.107-60-gd246f550d196e
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.4
Subject: stable-rc/queue/5.4 baseline: 174 runs,
 1 regressions (v5.4.107-60-gd246f550d196e)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 174 runs, 1 regressions (v5.4.107-60-gd246f55=
0d196e)

Regressions Summary
-------------------

platform             | arch  | lab          | compiler | defconfig | regres=
sions
---------------------+-------+--------------+----------+-----------+-------=
-----
meson-gxl-s905d-p230 | arm64 | lab-baylibre | gcc-8    | defconfig | 1     =
     =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.107-60-gd246f550d196e/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.107-60-gd246f550d196e
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      d246f550d196e15f60cbc8cfa4b331b6c83f8f98 =



Test Regressions
---------------- =



platform             | arch  | lab          | compiler | defconfig | regres=
sions
---------------------+-------+--------------+----------+-----------+-------=
-----
meson-gxl-s905d-p230 | arm64 | lab-baylibre | gcc-8    | defconfig | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/60588ea6a2dabefa28addcb7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.107-6=
0-gd246f550d196e/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxl-s905=
d-p230.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.107-6=
0-gd246f550d196e/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxl-s905=
d-p230.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60588ea6a2dabefa28add=
cb8
        new failure (last pass: v5.4.107-33-g5c67202ee407b) =

 =20
