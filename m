Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE704418E0C
	for <lists+stable@lfdr.de>; Mon, 27 Sep 2021 05:54:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232535AbhI0Dzh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 26 Sep 2021 23:55:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232526AbhI0Dze (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 26 Sep 2021 23:55:34 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B550BC061570
        for <stable@vger.kernel.org>; Sun, 26 Sep 2021 20:53:57 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id k23so11492495pji.0
        for <stable@vger.kernel.org>; Sun, 26 Sep 2021 20:53:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ZhCp8J3lXx3kFJBlwKWoErkM/uS+MmShNLni/gZhTYM=;
        b=uaRQ6tOQJ0WubA23cLt5EB/rMJcynEz2WuRo5Eb29AzrCvQFULqnZyYQ2Ag+idgLJq
         7bCPmfVBceZN/qkR/7Mu3xJA6J/7tyCgnzYs62M8jE5DGEYT8xWWzg6rWFZP668DdaeF
         ue2GYRXZxoN9hO8I9PtC45SNTMIb5pBzqrnoZT9QrCBfotHo6NgygS0LZ4zeKWDPfGD4
         WPc3Kem9szyBYT5v+VqYPiUJMUbhkw/7fwr9tcZOrDQArc5ttKp462xEZhu6bitj0Npy
         Ln49hBdY2elYefDEUtulHlQ8Ecz1C7lDho64ey84C2eR+4D4KaZPchLsIHBIuBtJ8Kzd
         WKBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ZhCp8J3lXx3kFJBlwKWoErkM/uS+MmShNLni/gZhTYM=;
        b=MOHyCpz7vt4od6kVRjJNwC+my0OLpfjZ68nkkwoefVVYb5rdvZ9MtrWQu/AOr4+Hz7
         DSJJXOkIroCCV+4U1C0zGMdUWKr7EsgWVYPsqryhzRpUdLgH95x7y6fXFVGO4eFj5jVn
         FZmdOZesGN93tXHym5vwcq06kTVkW0idG7nq64HPHm5Up8E3zJITpX984MSTNtRj1y7T
         CnO17HlHAoBRA7sV8/R2ijowuyLARp0RFUr38Lilhg1RK2M/RE/kds3t3M+RPfKzjiMw
         En8x3rt9O1tEBKsM9zQzmnGcPZZjiFIaZUZNKfojOr0cumuMfK97/KZDGVBAeU0tZgv4
         jpnw==
X-Gm-Message-State: AOAM533FP0WR8Y/qIcaExn4MQbMtyYh9Tb/ujhxeGuzvpKsAP9Y2V61I
        qjR5Uo4yL2J7+ypa8BlAW2kaO2pTSRAsBYye
X-Google-Smtp-Source: ABdhPJzgLDb2jDx4Eq4B/aYOzZb031GmHlpV0f/UfZt2SO495t4BHhxAdvfqq6Jz7U1PSgxbEhJ3dg==
X-Received: by 2002:a17:90a:1942:: with SMTP id 2mr17325386pjh.36.1632714836913;
        Sun, 26 Sep 2021 20:53:56 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id g12sm18122315pja.28.2021.09.26.20.53.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Sep 2021 20:53:56 -0700 (PDT)
Message-ID: <61514054.1c69fb81.79f9.d07f@mx.google.com>
Date:   Sun, 26 Sep 2021 20:53:56 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.14.7-145-g9bda1b95c376
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.14
Subject: stable-rc/queue/5.14 baseline: 120 runs,
 1 regressions (v5.14.7-145-g9bda1b95c376)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.14 baseline: 120 runs, 1 regressions (v5.14.7-145-g9bda1b=
95c376)

Regressions Summary
-------------------

platform                | arch  | lab        | compiler | defconfig | regre=
ssions
------------------------+-------+------------+----------+-----------+------=
------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe | gcc-8    | defconfig | 1    =
      =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.14/ker=
nel/v5.14.7-145-g9bda1b95c376/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.14
  Describe: v5.14.7-145-g9bda1b95c376
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      9bda1b95c376492a8e8b1419b7c9efd17bf13f7b =



Test Regressions
---------------- =



platform                | arch  | lab        | compiler | defconfig | regre=
ssions
------------------------+-------+------------+----------+-----------+------=
------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe | gcc-8    | defconfig | 1    =
      =


  Details:     https://kernelci.org/test/plan/id/6151050aa954cba48c99a3ea

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.7-1=
45-g9bda1b95c376/arm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-banan=
api-m64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.7-1=
45-g9bda1b95c376/arm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-banan=
api-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6151050aa954cba48c99a=
3eb
        failing since 2 days (last pass: v5.14.7-3-g11f9723f1192, first fai=
l: v5.14.7-100-g3633965a8dc7) =

 =20
