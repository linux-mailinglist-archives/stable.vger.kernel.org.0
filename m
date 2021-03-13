Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCE5F33A108
	for <lists+stable@lfdr.de>; Sat, 13 Mar 2021 21:29:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234384AbhCMU3P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 13 Mar 2021 15:29:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234573AbhCMU3D (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 13 Mar 2021 15:29:03 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 099CEC061574
        for <stable@vger.kernel.org>; Sat, 13 Mar 2021 12:29:03 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id j6-20020a17090adc86b02900cbfe6f2c96so12774783pjv.1
        for <stable@vger.kernel.org>; Sat, 13 Mar 2021 12:29:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=g8btROi6xK8uX3OQ8QoeNkr4aD0hgcp8qUf3edUPM3Y=;
        b=FTI7Z8M9ueuM0MHIqBvAlY781AB2cwV+zIIt3qs6LVCiL0jZ9PgoI+8vlEz8u+dudH
         lfMlZG1bkdS9kHcTwbe3SACczql7gvco94LMlkj/tvmt0UX5dEDbugoAqt8QZiltX2at
         iydNIe7+g+hpMjAtAlypncU2jKLU/WgFh5VNAFxomZqa9Q4Mk9o+6ACzkEB7Gtry6etW
         67ZZ92EV1n2RSSHpK2h0Oujkjf3KCDEjmQniNqvd02Y6hE8divljgT/RIHVEWTJe56xR
         5XUfHeW8n3W5Q+9rnuuZzL3kqG9Z6Nre0gSxNyCJEYXKz1wg5AjZFHzd1514GoEUzYq/
         KYdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=g8btROi6xK8uX3OQ8QoeNkr4aD0hgcp8qUf3edUPM3Y=;
        b=LBoCxKtza7X+1ErAb78Exat4d/vBQ2m0REuvDY7lQW7MR8MvQ0nfDGb1LFDSPHOCUf
         ARkJDfBxV9nlhCTmEScmIjOFX0MGhw8IsFb7LQH6MBncSIIgWrMBd1nalAalAcMc8CEZ
         KSRS3GRIiTz33S1yxOC0Ny8HIaa4TRvBGwWsY63zZqmQlSaUzyDS36PJEVFPvAFCvFZ+
         JtsEb3R0/w88dFsoUaN0Cf1Uo0pyftbK3txniwT5WK1RKMF2eTQQuM5k5TA2f5BA47zv
         GmKVkUVQhzro49jzkAJwgbbpuaucnHLTtHlRySYne5JnJk/PUnsX+owX2krp6dVyrh6q
         x5Kw==
X-Gm-Message-State: AOAM531sXffIrOH9NqhoDZbvLBfd6hxpo0ygOClALmdOOsfULsPnI1YN
        +KYDOPquxPQkxFb57x3AR3LvJDcKBwDZcA==
X-Google-Smtp-Source: ABdhPJxiT6IO1udQf2Mf+FQ6cawsstlUzijfZVVXkfujqo/A22qftwjxxfUUF+e1fMlcbez3XurqEQ==
X-Received: by 2002:a17:902:9b84:b029:e5:ee87:6840 with SMTP id y4-20020a1709029b84b02900e5ee876840mr4616060plp.82.1615667342460;
        Sat, 13 Mar 2021 12:29:02 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id v18sm9541251pfn.117.2021.03.13.12.29.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 13 Mar 2021 12:29:02 -0800 (PST)
Message-ID: <604d208e.1c69fb81.f165c.80c6@mx.google.com>
Date:   Sat, 13 Mar 2021 12:29:02 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.10.23-197-gee6d3eb9c27a6
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
Subject: stable-rc/queue/5.10 baseline: 122 runs,
 1 regressions (v5.10.23-197-gee6d3eb9c27a6)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 122 runs, 1 regressions (v5.10.23-197-gee6d3=
eb9c27a6)

Regressions Summary
-------------------

platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.23-197-gee6d3eb9c27a6/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.23-197-gee6d3eb9c27a6
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      ee6d3eb9c27a6e6924b44ad50801cb92461c3b4d =



Test Regressions
---------------- =



platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/604ceffb517fc187e8addcd2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.23-=
197-gee6d3eb9c27a6/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.23-=
197-gee6d3eb9c27a6/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/604ceffb517fc187e8add=
cd3
        failing since 1 day (last pass: v5.10.23-31-g559d8defe7bb8, first f=
ail: v5.10.23-37-ge21780881c24f) =

 =20
