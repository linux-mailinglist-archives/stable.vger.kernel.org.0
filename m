Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27D7724C0C7
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 16:43:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726754AbgHTOne (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 10:43:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726792AbgHTOnd (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Aug 2020 10:43:33 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA264C061385
        for <stable@vger.kernel.org>; Thu, 20 Aug 2020 07:43:33 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id k18so1131598pfp.7
        for <stable@vger.kernel.org>; Thu, 20 Aug 2020 07:43:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=5CagyNqgzCh2Mmh2ecDGbW6wMClGK8JKQwRtDBTrZx4=;
        b=wR5poXPsY5HtrRZCBMNnjjh04VHzNPYVvXQ9EXBx/oRcKYY8sDAKuL9gvcd0hUj0mG
         bPxWNIRqbJxy5KYh73Qjj9TedPVhOEiLBr5YSYQjsl6Z4HFl/duHoHHExEaK3eyKV40B
         TNEumbRDN9wbVOoLa/brj6oUV7SUvhb4II0bADw+JExbnZ16ZJo2Z6fvoFG/ixuW4geI
         r8aDrTvh0D+ikgBw2Xvrk8KI0lmOLgQN3mhQ1igz06+xYx5qxhPiyXaWZXGmc/CPxD1o
         KQFiWUSy/qAvwzjECO0wohNrmMmFbpMrhuh6ybgSKbuRhi51ue6oQNceOSanZ8HiiJ0z
         siXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=5CagyNqgzCh2Mmh2ecDGbW6wMClGK8JKQwRtDBTrZx4=;
        b=baDH/b3g9psAQ9GiFSz3pxl5yRC2CeddyvRocW71n2i9LsHz+sMTjvTejs4lR4tEL8
         7Olr7CZSl/r4kgZgl39+BEDqUGVwsH5/pN4wOiF29m4/OJ7L5G/JUkmZie3ozNCV5vzM
         wW6lCEd76r469NHrWtLY9x3kHkR/QmlcM2dhRVIgX2jF7bTzMrJyUAD8UpR+DzLd7tgn
         PX3xYDwLO9yX8nLiKXVdjoPIFmThIQpx99GaNPocb3wZJNE2nUWQjSMcghCcC7KjhFpj
         odhTtxBvEvkmNXrGWnkIy2PIKcw9t96E/9DP8FCyuaA0WqTco+cDSwSjDifriAE0EuyK
         56lA==
X-Gm-Message-State: AOAM531Tc6YMpPxf+Guo7po2H9sBSwSG4yX+lzdR9s9sP7WB+Dzqx4Wm
        dTYyJfPoGkW4s4bk1g3DkFw8RANdOuzOaw==
X-Google-Smtp-Source: ABdhPJxX7hBR4EVZDE9giDnIxfmHJhhplPMtSsi0qr17Id5TzVHwQr2Glp9HOtzTXQduSGu51ACHMw==
X-Received: by 2002:a05:6a00:7c8:: with SMTP id n8mr2477650pfu.123.1597934611858;
        Thu, 20 Aug 2020 07:43:31 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y29sm3165901pfr.11.2020.08.20.07.43.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Aug 2020 07:43:30 -0700 (PDT)
Message-ID: <5f3e8c12.1c69fb81.3f29b.7a84@mx.google.com>
Date:   Thu, 20 Aug 2020 07:43:30 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.14.193-229-g39a6b11467dd
X-Kernelci-Branch: linux-4.14.y
Subject: stable-rc/linux-4.14.y baseline: 107 runs,
 1 regressions (v4.14.193-229-g39a6b11467dd)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y baseline: 107 runs, 1 regressions (v4.14.193-229-g39=
a6b11467dd)

Regressions Summary
-------------------

platform              | arch | lab          | compiler | defconfig       | =
results
----------------------+------+--------------+----------+-----------------+-=
-------
at91-sama5d4_xplained | arm  | lab-baylibre | gcc-8    | sama5_defconfig | =
0/1    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.14.y/ker=
nel/v4.14.193-229-g39a6b11467dd/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.14.y
  Describe: v4.14.193-229-g39a6b11467dd
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      39a6b11467dd33be04b750760057f0205d0c01fb =



Test Regressions
---------------- =



platform              | arch | lab          | compiler | defconfig       | =
results
----------------------+------+--------------+----------+-----------------+-=
-------
at91-sama5d4_xplained | arm  | lab-baylibre | gcc-8    | sama5_defconfig | =
0/1    =


  Details:     https://kernelci.org/test/plan/id/5f3e590e89424a4bbcd99a44

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sama5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.1=
93-229-g39a6b11467dd/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-s=
ama5d4_xplained.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.1=
93-229-g39a6b11467dd/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-s=
ama5d4_xplained.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/armel/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f3e590e89424a4bbcd99=
a45
      failing since 26 days (last pass: v4.14.188-126-g5b1e982af0f8, first =
fail: v4.14.189)  =20
