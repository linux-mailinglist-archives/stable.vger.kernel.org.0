Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A76C339288
	for <lists+stable@lfdr.de>; Fri, 12 Mar 2021 16:57:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232043AbhCLP5W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Mar 2021 10:57:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232037AbhCLP4v (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 12 Mar 2021 10:56:51 -0500
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1593C061574
        for <stable@vger.kernel.org>; Fri, 12 Mar 2021 07:56:51 -0800 (PST)
Received: by mail-pl1-x635.google.com with SMTP id z5so12126243plg.3
        for <stable@vger.kernel.org>; Fri, 12 Mar 2021 07:56:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=M6AjWg4BqKPQtm/AI6kLrLcbVSeh3L6zrYqCf2LhGBA=;
        b=0n+9Pni3HQmNZ/GG/4WACVO8VpBzFTrSb78EUL+1a0JE+imTaOPdps1jM/PLXLm1IP
         WE31UdHnZjKWQkA2d3fEf06xMSpvsTZYQchuu3YFMt/di8SykgG0OexlLILcmQyegu7r
         f5/I9vjpqC+2ZdSbyeoYO5JuRpA+H7EuH4kiUrf/2yFriCkDDa2U79bcRpLLCLb5Kfxj
         ixNLh4ha39F2zpAPHeqvHkldZ0ezlmPxhXskzEmE89A7tTWaUtDjAjfbzsFForZQyXqV
         T0zaL0dF3p+N1z2UX4hsuVcA7HJgf8PKRHkkcnKSm7/b7jnlQFVi/scYTxVXXexQekH/
         yB2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=M6AjWg4BqKPQtm/AI6kLrLcbVSeh3L6zrYqCf2LhGBA=;
        b=Dp96NqgUmwJRhDr4g4p4YBdRlqp7I9u+yz5qNMSVDmWbB/3jEmhhBrGTRcZhdoefZ2
         1H/vBEjyyfG4W/b78LQ0KcYrXjayATSBXS8v8U4ZK/coEPaORzcIKtlUWSqBoE0XffOq
         ys4bWN3LPfp/GpnfwzmLTfNGKrE1uCj+7eVGh4EbZGMQ3KKNTFQhK6DNPTgeWYMqCuqT
         CtLt0kU3J25Jm2AbxE/csRPNjHT9esSRjueM1fv+0/CV/SMpoavRnwr+1/zZ5lgT+XXu
         M0rCz/N3XlAVb33gQWgl5utFhjRsfG2Wt0Om6gcYt7xt/+sFZnoRbNQKIbC0lMrd3EXa
         Etwg==
X-Gm-Message-State: AOAM530yRq7jnGNmYO4SsGKuwiyXkvLlacdqDDoacrnWv3gMgYx55WWH
        s5Czw37e78d4mXT4Q/reyAkFcuMplRawNw==
X-Google-Smtp-Source: ABdhPJwdd6RgpKMy1RsvTozO8ruN/Zk7v3zUT6bFG6XF4Zj4SNHzVXVFpyoGLE0K+iAMhX4a7wRykg==
X-Received: by 2002:a17:90a:3809:: with SMTP id w9mr14508380pjb.79.1615564611094;
        Fri, 12 Mar 2021 07:56:51 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id j35sm6204173pgj.45.2021.03.12.07.56.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Mar 2021 07:56:50 -0800 (PST)
Message-ID: <604b8f42.1c69fb81.5660b.033f@mx.google.com>
Date:   Fri, 12 Mar 2021 07:56:50 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.10.23-37-ge21780881c24f
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
Subject: stable-rc/queue/5.10 baseline: 103 runs,
 1 regressions (v5.10.23-37-ge21780881c24f)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 103 runs, 1 regressions (v5.10.23-37-ge21780=
881c24f)

Regressions Summary
-------------------

platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.23-37-ge21780881c24f/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.23-37-ge21780881c24f
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      e21780881c24f9150d9c7495e0d5979024568858 =



Test Regressions
---------------- =



platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/604b57ae0d0ee094dfaddccc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.23-=
37-ge21780881c24f/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.23-=
37-ge21780881c24f/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/604b57ae0d0ee094dfadd=
ccd
        new failure (last pass: v5.10.23-31-g559d8defe7bb8) =

 =20
