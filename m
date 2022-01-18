Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1FFC4927DE
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 14:59:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243276AbiARN7W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Jan 2022 08:59:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238263AbiARN7W (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Jan 2022 08:59:22 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 691CCC061574
        for <stable@vger.kernel.org>; Tue, 18 Jan 2022 05:59:22 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id b1-20020a17090a990100b001b14bd47532so2920218pjp.0
        for <stable@vger.kernel.org>; Tue, 18 Jan 2022 05:59:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=jOzPiYunDT8d/IX05xREg1PISwL+QJvfqDxyBE1sjDU=;
        b=qThkDutQPZEo97t0TeMR6wDYUY53HTQFXZPjnkjhJ1IEeBLAqyVyT2elVgBCGWS/+d
         VbPQLR+6zcK78D6+eaY0PLva1q6oqrxfXXYzWEHItT7bMDheUARynicUxX9vSuYmEFCM
         b+xihI50737UqhL8YbDbYJqW5eqbm+eBYouVMmLG+USXBoocnLJDaJuA1maspFaQWz/H
         Y0zdodwyF/ngoD/89a6GuXysJRbcowoCIFEahb56d7XSRS1+PS2jBt8W2cFD04XShqHr
         Om6tPfM4GhHYnjPIpXLmBrrpTG00iqF0kjzoMgXbh2UsB4XTQFnITVsz3Q0MbQ0/o3mP
         FNjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=jOzPiYunDT8d/IX05xREg1PISwL+QJvfqDxyBE1sjDU=;
        b=sR+mgsTru9I80NQRQp01KGSlceL13CU7fCbNSTvMPC2+/lH+tm0QEhvjypVcDFrszU
         fmI5jxO+MRHGik0OYWWg76eZUxAIcdn4ENRLbb5GoqGPEXIJ5QgMXC7MjYe2LoV8BrFH
         y++fNdOKjJgLK/iDnZalI0FpoM5vCyjfu+cdILwnjH62rgMdpFu9p+/E0EEKBIjSOpYy
         lgd7zi3hQ656RC4kkbUN/lv+8/aIdN2dKj5q96uJ9IB/UjVL6opuD6vUkleeMi8+3ryC
         03Z4mM9LP0BN2NTT+lVDpgjM8csWlDF+aq2L9kwXYvuQ73TjnXv1jOsdSr05K5t4a6RP
         /4CQ==
X-Gm-Message-State: AOAM5319R7sVpy01Jj9pC7ymBE1F/WghHPYcvW62r8p9xzrLxSmErGUm
        EbxZyEbM5IX6ml28JHxe8mggjB7PYHcc1um9
X-Google-Smtp-Source: ABdhPJz8Y1YwfeSqLp3ySCBun9vtgrf8NBO8n02FGxQFCgAtJIQj6GkiZBxaaAfyZojEf0jBKgjoWQ==
X-Received: by 2002:a17:902:7597:b0:14a:b4c8:23ce with SMTP id j23-20020a170902759700b0014ab4c823cemr11149694pll.170.1642514361672;
        Tue, 18 Jan 2022 05:59:21 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id c6sm18103730pfv.62.2022.01.18.05.59.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Jan 2022 05:59:21 -0800 (PST)
Message-ID: <61e6c7b9.1c69fb81.f2941.fcab@mx.google.com>
Date:   Tue, 18 Jan 2022 05:59:21 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.15.14-56-gf6404f051850
X-Kernelci-Branch: queue/5.15
Subject: stable-rc/queue/5.15 baseline: 172 runs,
 1 regressions (v5.15.14-56-gf6404f051850)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.15 baseline: 172 runs, 1 regressions (v5.15.14-56-gf6404f=
051850)

Regressions Summary
-------------------

platform        | arch  | lab          | compiler | defconfig | regressions
----------------+-------+--------------+----------+-----------+------------
meson-gxbb-p200 | arm64 | lab-baylibre | gcc-10   | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.14-56-gf6404f051850/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.14-56-gf6404f051850
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      f6404f051850d9962d5638160c4b981f7debcec4 =



Test Regressions
---------------- =



platform        | arch  | lab          | compiler | defconfig | regressions
----------------+-------+--------------+----------+-----------+------------
meson-gxbb-p200 | arm64 | lab-baylibre | gcc-10   | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/61e6944b849135a3a0ef673f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.14-=
56-gf6404f051850/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxbb-p2=
00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.14-=
56-gf6404f051850/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxbb-p2=
00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220115.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61e6944b849135a3a0ef6=
740
        new failure (last pass: v5.15.14-42-gf775278b8bfb) =

 =20
