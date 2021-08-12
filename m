Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11BFF3EADBD
	for <lists+stable@lfdr.de>; Fri, 13 Aug 2021 01:40:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232316AbhHLXlC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Aug 2021 19:41:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231838AbhHLXlB (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Aug 2021 19:41:01 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F79BC061756
        for <stable@vger.kernel.org>; Thu, 12 Aug 2021 16:40:36 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id fa24-20020a17090af0d8b0290178bfa69d97so13378094pjb.0
        for <stable@vger.kernel.org>; Thu, 12 Aug 2021 16:40:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=vdyBDOpDbc2rKYJqMNft886qGsM8Yl6eTNmmimAOP8U=;
        b=vG0l3etbHTs61BX7LOd1fXEItNjkQblXvPf39rYx5KjSf6bTZXg8paNUWMJPMCSG3B
         CbFJDvo0voVl9EZ1MZtB1mWYMKJ+ff1uusljgzQVdY8jfBGkpSddK5kyZ2yqmg+mQ4V7
         aLidKRpGkD8BUKfDL2LeOMv5/TZGnFvI5jy2hNN7FnjogI47CD8tAXVx3YPUz1hCl762
         QLv/0d+MV/esYJOjr2ScqosTrao9nEyF9QwV2Vj48EoQn7G41FXsf5ei6GEEVutkUwCn
         SPbK0cBIcVkJRrRNQzHuwNhRxenuwLibKQOE4ss7ikMA3Uenlbi/iJzmLsRrIhAx0mnU
         recg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=vdyBDOpDbc2rKYJqMNft886qGsM8Yl6eTNmmimAOP8U=;
        b=cjGUgE5EHxjAAu6Wjenw3TYtXPatAQqJKj/yUFx0s63eTtVmq07RhD0WiKJ5hDhdYr
         sKPuU6/TEzLeUaRUftcPLwgFGt0ZZnOXwQQ89qasE+53T17lLRFtJel0NBjY00NZV7qM
         AIlx4ztY03l0AF4gI4dZ9svDA17ZdC3D6xa1t8PuSyiXe/FR78rZpUwsvBOIuHwzPmXj
         N1hRACzHcs27RrHO7Sw1xFotuJVQ4gmdOKXzWPeMQd2hVUFBme+ODJSsByx4hE7sBfrM
         awqHQ0krTb8SRB+xTqsz09k1Thy7OrDlGjV1j4z3oSm9s0nBu0E3NZGqdiEch4e5udjc
         Vgug==
X-Gm-Message-State: AOAM530s7C1lBEtWknpaSW0VejHBvOhb5kERLo22SsM0ANIWXK+9NqQt
        /5tvRWrX95YgFSiUesh405y8cB9vXZZPjTsl
X-Google-Smtp-Source: ABdhPJwttbGYgV6hk5XZcBXbCz3SdWV+pAPNPrXw+99dqx6tBnaden7G2Aart3vfvQz0OWhC55cfYg==
X-Received: by 2002:a17:90a:940e:: with SMTP id r14mr18564995pjo.41.1628811635541;
        Thu, 12 Aug 2021 16:40:35 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id c136sm4663616pfc.53.2021.08.12.16.40.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Aug 2021 16:40:35 -0700 (PDT)
Message-ID: <6115b173.1c69fb81.c20c0.ddc0@mx.google.com>
Date:   Thu, 12 Aug 2021 16:40:35 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.13
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.13.9-176-gc85d412c71cc
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.13 baseline: 182 runs,
 1 regressions (v5.13.9-176-gc85d412c71cc)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.13 baseline: 182 runs, 1 regressions (v5.13.9-176-gc85d41=
2c71cc)

Regressions Summary
-------------------

platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.13/ker=
nel/v5.13.9-176-gc85d412c71cc/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.13
  Describe: v5.13.9-176-gc85d412c71cc
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      c85d412c71ccf43738cd9f0de7ea43cff68c48f5 =



Test Regressions
---------------- =



platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/61157ff51ecfaf5f77b1366e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.9-1=
76-gc85d412c71cc/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.9-1=
76-gc85d412c71cc/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61157ff51ecfaf5f77b13=
66f
        failing since 6 days (last pass: v5.13.8-33-gd8a5aa498511, first fa=
il: v5.13.8-35-ge21c26fae3e0) =

 =20
