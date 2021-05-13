Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6ACA37F128
	for <lists+stable@lfdr.de>; Thu, 13 May 2021 04:10:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230009AbhEMCLc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 22:11:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229630AbhEMCLb (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 May 2021 22:11:31 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20C6FC061574
        for <stable@vger.kernel.org>; Wed, 12 May 2021 19:10:22 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id a5so13240287pfa.11
        for <stable@vger.kernel.org>; Wed, 12 May 2021 19:10:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=CHdiBubHO3HAOe7js9F5yjq57Ri2UnP2shsReekk6aE=;
        b=UWykNYSBI+pGEtFx8nwuTkRdB8zxYL1HgncgVGyAGYZ7fpAbYu2+l/eGLrfBZqV0C1
         Iy7vsUjDIdjGnwsUVNCF/78chqA3UcnqK3sMRsR7d3To2yFm5j9lxk/qQtVzND4GNRmy
         36GxWcsK/fKAemyqy4nq+heYbpCZ0Kh7x8VkhPpIBwXYDEP19XF2MSNyQXP9Pr0/+Se3
         Iswr9WdP+TmPSqas+VBcbsvoBiaYSCzwRDozEf7VVP8JIJMDJr+yNYb2nVcMNqrR9PC6
         P2aFhYCRrhNSZ6TenymLKbuS1NCFJSe08p5Us6jrxdp6oV4Ro6g5TsvdvJrD+/8yV7RI
         URpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=CHdiBubHO3HAOe7js9F5yjq57Ri2UnP2shsReekk6aE=;
        b=aNtJNViq6apUwjJ1z13bi52woiUJl3yvAI9ZnqCzks76U7KDg5uXjM42Aw3Lenymfc
         G4D+1F/BrU8kihq7p+Vz9fdwtRquFQBpAqJqLU0glS7ZoBDXtKmYqMpIW/qihn2qOXSN
         ikIqxf5k0txf61XV8kOxaA4L0RZSC97GAhJyCYUZpCTi0qzOfuJCO1+SWbR9BKbRAIZ1
         AR/yuUpd+yJfsCbkjs6uocrxEeTTMweV/Mqkx7q1GL/4In7StZKAHCAkZp2NBcHlxDN5
         6tJNILfx9QyKYPsWb8MnNeHOeeWGwolKHpJ/wEZ/u1Mvg6sf1EawfVwrd9vBLTqSKz46
         nxqg==
X-Gm-Message-State: AOAM531Op03rJEHDWUCpTNAbNoCPQxynI91RNPd/JUgrRq9GQHWGWnfo
        dIWKggvP/PX8eYzJWZ4Tga4n2xJabmNq+SiW
X-Google-Smtp-Source: ABdhPJyvAlli8Qg0PMDlyTjsHf3y91EHrW+57bLawLgmlusLJQLGABuSzjDr326+N8D7XwGLP2Ct4g==
X-Received: by 2002:a17:90a:448c:: with SMTP id t12mr5655384pjg.142.1620871821512;
        Wed, 12 May 2021 19:10:21 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id j79sm823537pfd.184.2021.05.12.19.10.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 May 2021 19:10:21 -0700 (PDT)
Message-ID: <609c8a8d.1c69fb81.637b8.418c@mx.google.com>
Date:   Wed, 12 May 2021 19:10:21 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.10.35-828-g0b8d555c15bfa
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
Subject: stable-rc/queue/5.10 baseline: 162 runs,
 1 regressions (v5.10.35-828-g0b8d555c15bfa)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 162 runs, 1 regressions (v5.10.35-828-g0b8d5=
55c15bfa)

Regressions Summary
-------------------

platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.35-828-g0b8d555c15bfa/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.35-828-g0b8d555c15bfa
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      0b8d555c15bfaf1a2de186e3977d27b131d9b3de =



Test Regressions
---------------- =



platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/609c552b14f9f04cd0199288

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.35-=
828-g0b8d555c15bfa/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.35-=
828-g0b8d555c15bfa/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/609c552b14f9f04cd0199=
289
        failing since 0 day (last pass: v5.10.35-410-g9dbd9e48e4099, first =
fail: v5.10.35-830-g80be48bc51024) =

 =20
