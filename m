Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AFE025A03B
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 22:54:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726791AbgIAUyb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 16:54:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726091AbgIAUy2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Sep 2020 16:54:28 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75083C061244
        for <stable@vger.kernel.org>; Tue,  1 Sep 2020 13:54:28 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id h2so1167042plr.0
        for <stable@vger.kernel.org>; Tue, 01 Sep 2020 13:54:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=otACn4bB+dRjjgCAnUH602dYHU7gVMhhz3sZSHZ9zH8=;
        b=aj2FegAxIsh5mneBbioa3un2/idyz3AdOPsHXSEx3uiNm0CD2ktCvn5mUYUrFfVy0b
         3ioeuoUjIbr6jinrhS4aihRcdehO0j9wNbftU903+4V1O9vB8zzO06LNalCHwU0dnWUD
         U/K0RY1T2WZ8mKZyNqG/wYEPIvaOVQKhKXSyQ88Qtk5LYLWs6nvWiMk9oAG0aZ79aETa
         5QdNWLleGbvBLJmm2Nmb06qVQkXFc/RUY5E0Wk1B0LEd41coZwv/I1uSpDUjW0gAuE16
         ieA7zWhLiVlH8x7okiFb/AOw8K5SAmPMdtgXmLxlEiDr2RcfwZ3WuLax1y4CKtUtd5yP
         1uaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=otACn4bB+dRjjgCAnUH602dYHU7gVMhhz3sZSHZ9zH8=;
        b=WiGtt59NBdqLf5bbYATLh+VVQu02ZJtasAEmdZ64i9zRTZCkUT6esx822f2X8T/Lac
         vIY9YXbCvK8XdV6oh9u9KLsc8kTxCAovaMwGeUGd4qMDiTPN6UqmS49+tWe8dhi4f0N9
         QTd56HJpJn5cS5o7d6obM2/Gm/BHcXzNOiGRIIjx7NYcZLSz9Hm4IQzXqqZRMA/HpmSu
         CtBv7bntftZ6U6XagGpPyNDxDzYhKTm8PY63FY+eFDu1SQBRU09zL+pGY3Ewz5zW+bds
         Rjf8xwufhdT7PpuJvAMAk0rl3EnoX3IgAmUUW84dqAYcT/O0+mvAR1q6CRyJ/odVZhLn
         jn2w==
X-Gm-Message-State: AOAM53278e9P4VJDjKRGP/1YvjRl5yCO7usO3KPLoxAAgTgjRvi2+Kp/
        mklrpB19OOdMv7B5S56zlUVuclNrnmf/Cw==
X-Google-Smtp-Source: ABdhPJzvfBSJY1zex9NcjovHaybSaFy0+SDjUmkgLEEJRIDOOMKy1eh4YqDYIPiQQTwHqr0vzWhfpA==
X-Received: by 2002:a17:90a:134a:: with SMTP id y10mr3221525pjf.222.1598993667040;
        Tue, 01 Sep 2020 13:54:27 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id ih11sm2353509pjb.51.2020.09.01.13.54.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Sep 2020 13:54:26 -0700 (PDT)
Message-ID: <5f4eb502.1c69fb81.173a.4d32@mx.google.com>
Date:   Tue, 01 Sep 2020 13:54:26 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.14.195-92-g54fa008d06cd
Subject: stable-rc/linux-4.14.y baseline: 138 runs,
 1 regressions (v4.14.195-92-g54fa008d06cd)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y baseline: 138 runs, 1 regressions (v4.14.195-92-g54f=
a008d06cd)

Regressions Summary
-------------------

platform  | arch | lab         | compiler | defconfig      | results
----------+------+-------------+----------+----------------+--------
qemu_i386 | i386 | lab-broonie | gcc-8    | i386_defconfig | 0/1    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.14.y/ker=
nel/v4.14.195-92-g54fa008d06cd/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.14.y
  Describe: v4.14.195-92-g54fa008d06cd
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      54fa008d06cd73d42acafb918a6ae005eaef4875 =



Test Regressions
---------------- =



platform  | arch | lab         | compiler | defconfig      | results
----------+------+-------------+----------+----------------+--------
qemu_i386 | i386 | lab-broonie | gcc-8    | i386_defconfig | 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f4e85fa2e8a615110081118

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.1=
95-92-g54fa008d06cd/i386/i386_defconfig/gcc-8/lab-broonie/baseline-qemu_i38=
6.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.1=
95-92-g54fa008d06cd/i386/i386_defconfig/gcc-8/lab-broonie/baseline-qemu_i38=
6.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/x86/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f4e85fa2e8a615110081=
119
      new failure (last pass: v4.14.195-88-gcfcce49a9167)  =20
