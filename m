Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C7024643DA
	for <lists+stable@lfdr.de>; Wed,  1 Dec 2021 01:06:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240846AbhLAAKQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Nov 2021 19:10:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240807AbhLAAKK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Nov 2021 19:10:10 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B2C1C061574
        for <stable@vger.kernel.org>; Tue, 30 Nov 2021 16:06:50 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id y7so16283638plp.0
        for <stable@vger.kernel.org>; Tue, 30 Nov 2021 16:06:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=gdaa2v/XLJfWsb4R2Vx6QgYphyclcpZCbAiyc7ucN20=;
        b=JSbH8HHkuhvrSY92LAqZ38oLp4GHxbts5hqntApX3Ra8W/lgmX7sEJpW76jdzPFRxR
         7qjivwHn/GKTPeLrHlleI1WDr/g/0T+/sgsqOFRzzfh2gwPLWlwrK0LHWSFaQM6xjVHq
         KMQSfhWpnC2mcZPto2G70IIdgZ8y1FvstQO8CMjxGJz5OQHhX8WtPGu7/EmFecPpR0YH
         DQZanAtDLCCX5LT4du3cpUkL1r5o3PtjNTBrco3nghkIfxMcDlbdXu10OgnpX/j3CK78
         UD6AP2DPinppIhfuVtK/wt5au/iX95Eexgl0BxtVOiY3ncl4cFoh+4F6JDOA3J4UHgfP
         NpeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=gdaa2v/XLJfWsb4R2Vx6QgYphyclcpZCbAiyc7ucN20=;
        b=J6ptZLOWNV5u7yiX22+Zhka3qGu1AQNY9oN3A8C8ofiYu7wCDK6ZAM//e3gR7bpRSP
         u5w316btOUtIKhmR14CqGo/Ka40Fm4tRejzR0W/RmA9pfgVZovhcMHYsVaQ8JLC3w2ep
         kne3DeUjzCLWct8YRWqt3IZfzRIxXFzQ8iX08qESfTgIOL9UfsFuXXKlfZkP89JlefvQ
         esyD2Xxu0n+UU59LsOwiemdZ3keJdGqhFSbSYQtlt5fRdqrM/8XWgccDOcsrQ8yxfdfY
         1PYwoTOEL4PC1FrDg4aPofYOnp4894QU+4vxpUZwWVVEquzcE7yuD2NKH/9+w80JWfE7
         0gWw==
X-Gm-Message-State: AOAM532I9X7OuzKr36PooJrSXcQpkv5ImcvN+lhsIId3dORuTf6ybEET
        3YWHU9XwnvaHn1T1w+g6e6bLcRb6lWCNd2Be
X-Google-Smtp-Source: ABdhPJzAc6DhJ7KHfm75SPYhpVOuy3Hj50zlGUbXkDQUWZLnvf4KGmYdEPmAeoEoBSWWCN3M6tXOsQ==
X-Received: by 2002:a17:903:18d:b0:142:8ab:d11f with SMTP id z13-20020a170903018d00b0014208abd11fmr2977962plg.47.1638317209680;
        Tue, 30 Nov 2021 16:06:49 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id ne7sm3633479pjb.36.2021.11.30.16.06.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Nov 2021 16:06:49 -0800 (PST)
Message-ID: <61a6bc99.1c69fb81.8e90f.b73a@mx.google.com>
Date:   Tue, 30 Nov 2021 16:06:49 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.4
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.4.162-92-gf7e2719a07093
Subject: stable-rc/queue/5.4 baseline: 145 runs,
 1 regressions (v5.4.162-92-gf7e2719a07093)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 145 runs, 1 regressions (v5.4.162-92-gf7e2719=
a07093)

Regressions Summary
-------------------

platform                 | arch   | lab           | compiler | defconfig   =
     | regressions
-------------------------+--------+---------------+----------+-------------=
-----+------------
minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
nfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.162-92-gf7e2719a07093/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.162-92-gf7e2719a07093
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      f7e2719a07093ad2b6c16afce33180b85c3d279b =



Test Regressions
---------------- =



platform                 | arch   | lab           | compiler | defconfig   =
     | regressions
-------------------------+--------+---------------+----------+-------------=
-----+------------
minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/61a6862af68bcf7c1c18f6df

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.162-9=
2-gf7e2719a07093/x86_64/x86_64_defconfig/gcc-10/lab-collabora/baseline-minn=
owboard-turbot-E3826.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.162-9=
2-gf7e2719a07093/x86_64/x86_64_defconfig/gcc-10/lab-collabora/baseline-minn=
owboard-turbot-E3826.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61a6862bf68bcf7c1c18f=
6e0
        failing since 1 day (last pass: v5.4.161-100-g5c0e2c8610e1, first f=
ail: v5.4.162-92-g7262d8df3d015) =

 =20
