Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03C6F487FD4
	for <lists+stable@lfdr.de>; Sat,  8 Jan 2022 01:07:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229733AbiAHAHe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Jan 2022 19:07:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229703AbiAHAHe (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 7 Jan 2022 19:07:34 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3036C061574
        for <stable@vger.kernel.org>; Fri,  7 Jan 2022 16:07:33 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id p14so6241849plf.3
        for <stable@vger.kernel.org>; Fri, 07 Jan 2022 16:07:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=+9d8eBRM+SsfR3/jh1dpZkJ44DkktmcrrKvIooLh0cA=;
        b=CwZyWd5XfFoS4PkDplFCGPNZ8aSEEkErN2syZc/mK/QPYuZY1FFBe75RvmARoJB9UC
         m3E3Pkzhzf3Zav23QNwIMnH0hZJJM8DtYyfiOaUo1GSEtqhkiAJGl/mlKkEHzoSqOl3d
         whDQDa3RhMSPTY3Auk7M9529NPKiCin+F1zkHlVLohHUNO2WIkMvmFLUB0jIcdq1bCoS
         WQE+SnLEVVm+ZbY6+9+yZmwXVP20ljRxY2rJK0Hee3DqDcrGELXA/BQ5k6h/c5WnADBz
         ZxVwEzPOIkh9RaIF4C3AIcx8Y/eDQUFqqf6dwRRchqkq/nQ3yM6qq4YVBwmXf3i4lFDg
         ZvHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=+9d8eBRM+SsfR3/jh1dpZkJ44DkktmcrrKvIooLh0cA=;
        b=hvZkW9VWNq8iHghxj0lKQcxifrqUzYhAHy3Vtq4J2iS4bLH+BFK95e8uyrr7Dz2O2h
         bmdJZTKU+Wf8UzrvVk9FUpC8WFhysIRw3xbEXxmxVaD7t4k/I9sBPcNETnBofZSxAvSZ
         AuSnu9ATHSMhrQDbhNFcaP6kwjW368L/deHnU6l65DX8SkQSXg+nuiqJ9yaYk1H3b8Op
         Yji6egPT44+ReAPhMSSNlDdeGjtPFdnHsg4Ysadx+KgtngfR/wCn3dI6KXf2Skx1zfEX
         TU5QzIWmu/Bi9UoYJIvm5TS1F/2B3a/1k8L0enApl2+0LPzHAeDE6uAW4wUNpaFdOeNT
         RFrg==
X-Gm-Message-State: AOAM531cThNxYBapKsNB2R/QPfs+04+R7EiYO6YBIRJcSpmrZJK6Jgzy
        ub30Wc/jLBLVWYiEcbswLa7jQVvKmv2qloJK
X-Google-Smtp-Source: ABdhPJzMmAhfTpXK+oP8Xc2zvSRylvY4QvfrSmCYzPIQPJJgh4qvwfyPJTyzBGAjb6YeMk2KKzgXrg==
X-Received: by 2002:a17:902:b48a:b0:149:5454:193e with SMTP id y10-20020a170902b48a00b001495454193emr62590540plr.131.1641600453190;
        Fri, 07 Jan 2022 16:07:33 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id h19sm65966pfh.112.2022.01.07.16.07.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Jan 2022 16:07:32 -0800 (PST)
Message-ID: <61d8d5c4.1c69fb81.8699a.053c@mx.google.com>
Date:   Fri, 07 Jan 2022 16:07:32 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.10.90-25-g1e147306777a
X-Kernelci-Branch: queue/5.10
Subject: stable-rc/queue/5.10 baseline: 180 runs,
 1 regressions (v5.10.90-25-g1e147306777a)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 180 runs, 1 regressions (v5.10.90-25-g1e1473=
06777a)

Regressions Summary
-------------------

platform                | arch  | lab        | compiler | defconfig | regre=
ssions
------------------------+-------+------------+----------+-----------+------=
------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe | gcc-10   | defconfig | 1    =
      =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.90-25-g1e147306777a/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.90-25-g1e147306777a
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      1e147306777a8a42b317e5e7cede4ee417c35e20 =



Test Regressions
---------------- =



platform                | arch  | lab        | compiler | defconfig | regre=
ssions
------------------------+-------+------------+----------+-----------+------=
------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe | gcc-10   | defconfig | 1    =
      =


  Details:     https://kernelci.org/test/plan/id/61d8a3cc1d4a4de321ef675b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.90-=
25-g1e147306777a/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-bana=
napi-m64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.90-=
25-g1e147306777a/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-bana=
napi-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61d8a3cc1d4a4de321ef6=
75c
        new failure (last pass: v5.10.90-5-g7575d2506fb1) =

 =20
