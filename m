Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A4EF39D322
	for <lists+stable@lfdr.de>; Mon,  7 Jun 2021 04:47:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230183AbhFGCtr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Jun 2021 22:49:47 -0400
Received: from mail-pj1-f42.google.com ([209.85.216.42]:40866 "EHLO
        mail-pj1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230159AbhFGCtq (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 6 Jun 2021 22:49:46 -0400
Received: by mail-pj1-f42.google.com with SMTP id mp5-20020a17090b1905b029016dd057935fso2791023pjb.5
        for <stable@vger.kernel.org>; Sun, 06 Jun 2021 19:47:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=eK2vgTV8SOY5Q+hQGB24GGCS4r+wMBVk21Zc0e62ijU=;
        b=2A8DfMVs+K83VkkGGUXO5a3zOKrmOWHrx0J/wIXN011Zr5/vEGB+wZHLr0yqMN552w
         IcnW7SaXtYChKbiF8h6yK5HB4/2E1SyoEUdJgHCuxKssbcBEjAj2BwulbCVRkjypKtIK
         8SJlzv/fue8PyS6yAoMoLQyks9/H0jg7Ux2fqg2aN16YzVl7UgNYw0sXxvzpKxkPckuU
         wgc44K4mdx06mPrr42+5HQnK7hBNILErx94dMq5VPmjwLRmXk7KgGKhsU9345FM36tFU
         /7+Z7YTrieeEnZJMeUV0L5LsI/brC9JXQN5dr7HKaUJwebQbx5QhH4wF3zt/xUrxvqRN
         E+yA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=eK2vgTV8SOY5Q+hQGB24GGCS4r+wMBVk21Zc0e62ijU=;
        b=LmdE5nQN6VnBBv0ium8Nnee6svE3rKlJuLuqnzSZjrEMkfSmm1IcluE9BJBiPNyyll
         hsTRVze2Tj9eDXjyVtuh8eDCMk5mF7ybAT/70Gq+QK99PW3fYGoYXw0gWHwKYD1OWIGt
         d6cOmIlVUN4RTHRd1J5FjHeC58iSeFfoQADNEuaDfS1MTLhjrIQidxg1AqDyOp8/2JQc
         /gsP0IVR5dTK7oqBi3onHyW/tbiFdgF2kVkF1nsm7e73Y/7679fXYAShzI0xOuzXxd0x
         XYGgFkbrsXZFxbckoBOrHGvo1gKkR0P4rzzT1auX14bszMgvKy3OX/li7mEQxLKyXr5E
         mSRg==
X-Gm-Message-State: AOAM532VS5isfpwNE9dp9L6tr3DkbWsrzaClvHRI59/7EDzGDQC4EUI2
        37FW69Kk4587xHDLyWLPobd3ttdXzEb7W6X7
X-Google-Smtp-Source: ABdhPJyKKEzpxS9FZN6Ke5T7DU4tCnOOBeMEpq3HZwIr5FELx9Ph5ZL0vuvTAT7Y9dM6EvCacJyW8w==
X-Received: by 2002:a17:902:8c91:b029:ef:aa9a:af35 with SMTP id t17-20020a1709028c91b02900efaa9aaf35mr15837883plo.24.1623034000272;
        Sun, 06 Jun 2021 19:46:40 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id o3sm7190291pgh.22.2021.06.06.19.46.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Jun 2021 19:46:39 -0700 (PDT)
Message-ID: <60bd888f.1c69fb81.b08a5.7ad9@mx.google.com>
Date:   Sun, 06 Jun 2021 19:46:39 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.12.9-65-g3688c2cd39b3
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.12
Subject: stable-rc/queue/5.12 baseline: 201 runs,
 1 regressions (v5.12.9-65-g3688c2cd39b3)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.12 baseline: 201 runs, 1 regressions (v5.12.9-65-g3688c2c=
d39b3)

Regressions Summary
-------------------

platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.12/ker=
nel/v5.12.9-65-g3688c2cd39b3/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.12
  Describe: v5.12.9-65-g3688c2cd39b3
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      3688c2cd39b3e930080b08260612642913a4b141 =



Test Regressions
---------------- =



platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/60bd5400b66db65b580c0e59

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.9-6=
5-g3688c2cd39b3/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.9-6=
5-g3688c2cd39b3/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60bd5400b66db65b580c0=
e5a
        failing since 5 days (last pass: v5.12.7-304-g7ade597cd7c1, first f=
ail: v5.12.7-303-g89387db068ad) =

 =20
