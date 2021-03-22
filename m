Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B7C23437EF
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 05:42:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229482AbhCVElg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 00:41:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbhCVElM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Mar 2021 00:41:12 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 301E8C061574
        for <stable@vger.kernel.org>; Sun, 21 Mar 2021 21:41:12 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id v8so5891825plz.10
        for <stable@vger.kernel.org>; Sun, 21 Mar 2021 21:41:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=gLsphPFkM7dlXP3rFEDOF+zGiIezRWKOMuwJlHttSy0=;
        b=KYJ6mdLgQBlLKADWHbcZMP7SdYakYeD+hPocnr6G6U9If+aLK+uZEzaWsfE/aLOHD9
         r5vjmt7WQgSyOV8yRQ3N8zk6eFoa6XbSlj7Icwrxz6run9muM9bDa+7qsuBz4SLl0KH6
         LbARzDHACm23Ys/DTIsp9JDssy1JI73ncTjFzZCFmxK0TwHgeppBTjW9H/kGwlINGy8r
         Tsl6HwEWSbn3Xh6K2BhZMwoDSOhmWE0MSAMRvDcO0cgc23w2V/ODZDWexMHJz9aH6Ldz
         WJK9FdbHB9gaSZoxteLEMB1Y3YpDuqUxnSdC3NOGWNnuNFrQ5rdnE7eWE4KaMBUEKGI0
         3K4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=gLsphPFkM7dlXP3rFEDOF+zGiIezRWKOMuwJlHttSy0=;
        b=NNNLXYQ+kyhpH/tsWV//7fYfmurSfZjgLRoAg2QQy/JeMVspC1Rtn3NQHN7qO0Y3qM
         VReZNHCEYIJKia+BrxYVCVvmMF4aOcKnAt5sMYU6lbmy7J+ae19zcXimgD53cHKB+Sg3
         Usv2hjkV0/D30b3KqPBx6uzD728XwkHm5IDzu3J0uoWNrYIUvbsdSZd0XWYHPX5bHvWV
         ND7vaUHDxF/jYhiUXwoLO3mSjlJOHyr+JTL2c/VxjWaFgx/iqUnr/kxMF/vEajjjAYIC
         hrwH415LYHnES0mwZH3CM1BCPWSuMZML1/h43wrQcZxiZSo7gFSn/9+ku3pJqgEu/3tz
         cvwg==
X-Gm-Message-State: AOAM5312bAk0EW/q5jbcmbeaW6RZP9Gwkt3OrTE16+qCJi57ZF+AkPEe
        gJKcNjsiygsCJVQLJQkbr955bhhq01bY/Q==
X-Google-Smtp-Source: ABdhPJx4RkPhe9ceksXEJ3vMbUY6W/IMtleHXi9Bcv/qUf2v+j8xAcOGKSkUq2l4bqKFHPWaulSAIA==
X-Received: by 2002:a17:90b:4c08:: with SMTP id na8mr11745021pjb.70.1616388071409;
        Sun, 21 Mar 2021 21:41:11 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id n9sm12025015pjq.38.2021.03.21.21.41.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Mar 2021 21:41:11 -0700 (PDT)
Message-ID: <60581fe7.1c69fb81.c5b6e.da66@mx.google.com>
Date:   Sun, 21 Mar 2021 21:41:11 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.4.107-31-g9851c74c22f0
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.4
Subject: stable-rc/queue/5.4 baseline: 187 runs,
 1 regressions (v5.4.107-31-g9851c74c22f0)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 187 runs, 1 regressions (v5.4.107-31-g9851c74=
c22f0)

Regressions Summary
-------------------

platform             | arch  | lab          | compiler | defconfig | regres=
sions
---------------------+-------+--------------+----------+-----------+-------=
-----
hifive-unleashed-a00 | riscv | lab-baylibre | gcc-8    | defconfig | 1     =
     =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.107-31-g9851c74c22f0/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.107-31-g9851c74c22f0
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      9851c74c22f0e34d265bd638322c4115f7697b78 =



Test Regressions
---------------- =



platform             | arch  | lab          | compiler | defconfig | regres=
sions
---------------------+-------+--------------+----------+-----------+-------=
-----
hifive-unleashed-a00 | riscv | lab-baylibre | gcc-8    | defconfig | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/6057e9f84150ebecc5addcdf

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (riscv64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.107-3=
1-g9851c74c22f0/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleashe=
d-a00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.107-3=
1-g9851c74c22f0/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleashe=
d-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/riscv/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6057e9f84150ebecc5add=
ce0
        failing since 121 days (last pass: v5.4.78-5-g843222460ebea, first =
fail: v5.4.78-13-g81acf0f7c6ec) =

 =20
