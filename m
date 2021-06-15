Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 295593A8771
	for <lists+stable@lfdr.de>; Tue, 15 Jun 2021 19:21:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230075AbhFORXo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Jun 2021 13:23:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229895AbhFORXo (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Jun 2021 13:23:44 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7AA2C061574
        for <stable@vger.kernel.org>; Tue, 15 Jun 2021 10:21:39 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id 11so8807492plk.12
        for <stable@vger.kernel.org>; Tue, 15 Jun 2021 10:21:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Z1BCbgCXTI0B8/9TAHongs/SAmydvyawhLd/M71Dl0Q=;
        b=OnlZ5Pr3E4r8ED2kA3nMdHHbjoq5ofpxt4LBRL3ZkBu/SSQZOg6FTkeoDSiZvD78Be
         MwJK/lT1bl+Zi/X+L/AOtIZB5WZDOGbzW9o82ZFPOChBKhGH4OXClgczPlSsYTcBiMGW
         MvqzdHbA8nbNNutGNye6W0Kog1dItB8rVLvgTvNy9+pQvmoHYmz+lEF74n/bam2GJjeq
         QPPG0gvFlWm78HK0Vm0Fz66WZZQKF4ae4+I0rfBEe9fZnBKB4yH6qW7YytBmfusW4Ph+
         Z2sXPdQjdF33TdQ072823bXRyVbdJwS8CkhePh5uVkcK7Y+/OoqkDalL8c0wtwOAk6pM
         bdfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Z1BCbgCXTI0B8/9TAHongs/SAmydvyawhLd/M71Dl0Q=;
        b=X9UsvFpsLvJFvdxCpcbJu3dGDUHRlTP8BLexFWCAFDiKGFWPCCz21JhjMNMYgRLytM
         cbJ94rTvcsbIaze/5UjzE3fLlCoqMaVFDd/iXSuKsaiJ/nGXJMRJDjhGy8SukEJSGhhM
         D+FrrT2qcFpCGHrDGn4Lw4Md1eM0Divcxzot6fPbxDmfEayljlJee1hCLZhqpnRtou6X
         xYcgUO3ycZPo6/WBOLTAMyIH6Q4f6p5KsptxFv0jVxxnsfMPJRGva/HQNXs0pYh+bppw
         FpBVDRXiPQZt9SbTvqwWnv1jQtQSLW4dldX6rzSe+GfwuACtKZ/SWcIzka3A1qUXKlps
         BrmQ==
X-Gm-Message-State: AOAM533dZucMjUrT/FgpadThSnu0UWjVy3uYjBPe4CJjv7XJ1vHuR+4z
        tA8J4p1R55SUbt5BLMZrGYY1lSEOcI8+ew==
X-Google-Smtp-Source: ABdhPJxjcJZcmzIV+9imwI1HHNBro256M4DQRyO96p1e016iCQXXCJjRo1V8z/L5gMhhFiFojwoiZA==
X-Received: by 2002:a17:902:8645:b029:fd:25ef:3df7 with SMTP id y5-20020a1709028645b02900fd25ef3df7mr5315348plt.48.1623777699223;
        Tue, 15 Jun 2021 10:21:39 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id l201sm16110925pfd.183.2021.06.15.10.21.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Jun 2021 10:21:38 -0700 (PDT)
Message-ID: <60c8e1a2.1c69fb81.6b7f8.dcd6@mx.google.com>
Date:   Tue, 15 Jun 2021 10:21:38 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.14.236-49-g4a48b118c459
X-Kernelci-Branch: queue/4.14
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.14 baseline: 144 runs,
 1 regressions (v4.14.236-49-g4a48b118c459)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 144 runs, 1 regressions (v4.14.236-49-g4a48b=
118c459)

Regressions Summary
-------------------

platform       | arch  | lab          | compiler | defconfig | regressions
---------------+-------+--------------+----------+-----------+------------
meson-gxm-q200 | arm64 | lab-baylibre | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.236-49-g4a48b118c459/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.236-49-g4a48b118c459
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      4a48b118c45984439aca260065b784e4581ffb37 =



Test Regressions
---------------- =



platform       | arch  | lab          | compiler | defconfig | regressions
---------------+-------+--------------+----------+-----------+------------
meson-gxm-q200 | arm64 | lab-baylibre | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/60c8ae44408bc83d20413277

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.236=
-49-g4a48b118c459/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q20=
0.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.236=
-49-g4a48b118c459/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q20=
0.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60c8ae44408bc83d20413=
278
        failing since 106 days (last pass: v4.14.222-11-g13b8482a0f700, fir=
st fail: v4.14.222-120-gdc8887cba23e) =

 =20
