Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4202E32AE9F
	for <lists+stable@lfdr.de>; Wed,  3 Mar 2021 03:58:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234067AbhCBX5a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Mar 2021 18:57:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380153AbhCBBsp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Mar 2021 20:48:45 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3021AC061788
        for <stable@vger.kernel.org>; Mon,  1 Mar 2021 17:48:04 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id t9so823822pjl.5
        for <stable@vger.kernel.org>; Mon, 01 Mar 2021 17:48:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=MNwwmXwuo2i9mrJl7OwDtRCQ+KLQT20Yj9SR4blJEl8=;
        b=ac1MeXRvboo9/hYuY9/jJpjCyK0VZC/RmXbP6s7Z6k6czcEvJKVmL7V7wIkwsxi0xW
         dQvpnBBvtOMQeR1aaQZgc/4v7ONLvZRdEvKQtVhcTerr4CyoBfxQWnNBGEdCvdLPCZMH
         106j5vnhNbvxcFGQtFvKHQtxpRNc043Q4qiQoeUAKYOeef0d0PEYNQWOp//9A8+AuHIe
         7VVtwS16lT7xjE5RzxRi/oyJMYSG6/pwCk0NBo8jz4hM0GUo1VErd+fCnG0+bGpMLRuq
         VmHjXxD8eSqMNBE6MJ/QIqyY/odVxN77k5zlVowG2Nhdn5M+5EAFsQnGPvdmXZAl/y2o
         Q0zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=MNwwmXwuo2i9mrJl7OwDtRCQ+KLQT20Yj9SR4blJEl8=;
        b=kSOKf2t1CRbQzurFMmxunrApnH+lq4DsxUyoGyf+k70eJYk7/mwqt4NAtvlZgOf681
         KOzgO2pTsvNASHXyjCXrF/TsdRriDkkdfXlwBwkmDQeQTrGWSUB/CT348P+DcgVeVqwu
         WvNyyFgsc5t7PHVElsHxkMwU5c6y7aKUy1f8gv+Qf7EXjJ+XjDHk07S8icWE493BZFAE
         Xogp7PdaxXAJO6xJKgs45aKjgJYcFerdH9qKjNK7/w9iql4cAgPCa0YfzRIZJAr9YL1m
         JBNNZnTqsVIltl0WGEvD/NPro5qe4McWqRbAyyYci5D4RCNBaaN0+hMyrRsGFGK0/T3Y
         VbFw==
X-Gm-Message-State: AOAM530c22H6o6gx7xLQw/qegM+UjFHgHlIiV88O2YVlaxKzbUBFgnlY
        J33p47swodg6hg0ErAmHNSHvTAanb4kgmg==
X-Google-Smtp-Source: ABdhPJzRPC0ugKaerf0J03aHFdFIYmqmyjQOrIqG43J/nBVOtk9hCj0tG+RrFGlte4n8AmLcv/m2XQ==
X-Received: by 2002:a17:90a:6c22:: with SMTP id x31mr1807466pjj.213.1614649683606;
        Mon, 01 Mar 2021 17:48:03 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id p8sm18384606pff.79.2021.03.01.17.48.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Mar 2021 17:48:03 -0800 (PST)
Message-ID: <603d9953.1c69fb81.4541e.bf46@mx.google.com>
Date:   Mon, 01 Mar 2021 17:48:03 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.10.19-662-g92929e15cdc0
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.10.y
Subject: stable-rc/linux-5.10.y baseline: 171 runs,
 1 regressions (v5.10.19-662-g92929e15cdc0)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.10.y baseline: 171 runs, 1 regressions (v5.10.19-662-g929=
29e15cdc0)

Regressions Summary
-------------------

platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.10.y/ker=
nel/v5.10.19-662-g92929e15cdc0/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.10.y
  Describe: v5.10.19-662-g92929e15cdc0
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      92929e15cdc088938051b73538d9d4d60844f9d4 =



Test Regressions
---------------- =



platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/603d69ec2924db6b9baddcb1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
9-662-g92929e15cdc0/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
9-662-g92929e15cdc0/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/603d69ec2924db6b9badd=
cb2
        new failure (last pass: v5.10.19-21-g9b79602baf17) =

 =20
