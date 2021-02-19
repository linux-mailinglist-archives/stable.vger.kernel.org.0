Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 797AF31F441
	for <lists+stable@lfdr.de>; Fri, 19 Feb 2021 04:45:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229553AbhBSDoB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Feb 2021 22:44:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229535AbhBSDn7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Feb 2021 22:43:59 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90384C061574
        for <stable@vger.kernel.org>; Thu, 18 Feb 2021 19:43:19 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id fa16so2925655pjb.1
        for <stable@vger.kernel.org>; Thu, 18 Feb 2021 19:43:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=/TiJu+y1UPi2C8tFHsdHIhtL7B1vCRw22zkdyxqOjJs=;
        b=CrjhW4e5L1F9C/Y+Qra0DCsF0M8YUhEVOjghsHp8BjC1U3We+NWvb7W6h0uQmQnNLq
         sSUjA6RpxPJRsxTQmk2apYC/yvpXxcU1Ndu0vYVk+R2vCY+wmdeshRTwkvgsOziKfgyW
         ZSA/kF3IW/RkDcczNt/NNZi1JkMRbwiWCZdnoTl5A6sih39S0aSZiwX/eu9mOaoFecqC
         jxsrIBTNzXUfO9XwiFG8wt7LEPgrof/AtzA4fQNQyD1IgjkIS3C/YxF6jIonLk4bOsNt
         tacEvpA88iFfk/hXNWzjUElJP5hiIK3rEODk0AyF1UR56VNw1CsBzIHPpoI5UWK2cFXu
         NUSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=/TiJu+y1UPi2C8tFHsdHIhtL7B1vCRw22zkdyxqOjJs=;
        b=hqYeTi9GHLNR+4I8DZSCPGNw1XgNVTCNw4wbWzkIXLzj6uALP5bgDia9R3ijRCsfsH
         g/lsRZcpOKWpgxN3Jn4OA+cUJB4W4iuxoisTLXTQZlNt8Sq3po7LYVqe4zHKwIHUWxq9
         6+wwQG1G0kTL5p9v5se3hxCzMsAmrynIi6ij5jb+scVpyktBxWqO4GMPSAw/GELoVa9b
         C25HMH9O2dufleJ1UF+e1Exg3YI4rfvPmWv0rE4ZtLLI+WeUoKwnZu8R8wii10WxnSuI
         cBFQNqtOa/bC6Ma1mMIJE8zybwl2ul1O4zvjdfcaqGLcqcXzK/4sNYUirW/e9tnLe/n+
         ClMw==
X-Gm-Message-State: AOAM533+5NVNAMHezwt1+d4b0T8G0wHwh4MJjcMr27Im+fEl+dyJTNya
        dHkcu3csn574Oy6gmrgadSUUbxv6P/UixA==
X-Google-Smtp-Source: ABdhPJxAVwh7eTaRCL0DmpVAhw+r3wVQYFq2te1Q8b8wkrT2ZMADDqEycRQWYVvWVpsLidhuy4ddGw==
X-Received: by 2002:a17:902:b094:b029:e3:a2f:4681 with SMTP id p20-20020a170902b094b02900e30a2f4681mr7019710plr.69.1613706198841;
        Thu, 18 Feb 2021 19:43:18 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id h12sm7355243pgs.7.2021.02.18.19.43.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Feb 2021 19:43:18 -0800 (PST)
Message-ID: <602f33d6.1c69fb81.f6461.18e8@mx.google.com>
Date:   Thu, 18 Feb 2021 19:43:18 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.10.17-6-g4794fa0c53317
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
Subject: stable-rc/queue/5.10 baseline: 126 runs,
 1 regressions (v5.10.17-6-g4794fa0c53317)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 126 runs, 1 regressions (v5.10.17-6-g4794fa0=
c53317)

Regressions Summary
-------------------

platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.17-6-g4794fa0c53317/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.17-6-g4794fa0c53317
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      4794fa0c5331703fbe4fa6c80ffcb2f41ed2223b =



Test Regressions
---------------- =



platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/602f03c3a699034831addccf

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.17-=
6-g4794fa0c53317/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.17-=
6-g4794fa0c53317/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/602f03c3a699034831add=
cd0
        new failure (last pass: v5.10.17-5-gdb4f9910056b7) =

 =20
