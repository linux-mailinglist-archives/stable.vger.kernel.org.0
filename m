Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 775A335FEA2
	for <lists+stable@lfdr.de>; Thu, 15 Apr 2021 01:52:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230133AbhDNXxD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Apr 2021 19:53:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229950AbhDNXxC (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Apr 2021 19:53:02 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB03AC061574
        for <stable@vger.kernel.org>; Wed, 14 Apr 2021 16:52:39 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id s14so6242677pjl.5
        for <stable@vger.kernel.org>; Wed, 14 Apr 2021 16:52:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ctBW8YjUMEiqp/EObqU79YfCg99wcFnQGkWVyK6wEIQ=;
        b=0mSjJbon9HiH8V2Rg4Xdxy55LPVSvq43YBtm5jq/fVAhviBvic71M3x3QqCO6qOxUX
         uHpOHbpfb/h1nuU1tykRnVEnqM5z4YBSUzE2ci4ZvQoZx9J/1skWBTIRDrNvv+UIYahk
         Q8NPb8SzFSelyErzyBRL2slhJDmDZJjTNzeDPvX6nXwo4C2bRfw9pkdOEVnzvDYasng9
         ROA9KVYp8lx8TmG/slOV1T+vb3K1zz9CB2yzkeEX7ZgNwSjAmaPhWr56eqUeTjKlNUrd
         aVPfP7ELf1Q2T4JlAJlBrOnL7KnqU0xy4fA73SdAkOwsyJekxWr3WgUaF9bw/65oiMWc
         4GRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ctBW8YjUMEiqp/EObqU79YfCg99wcFnQGkWVyK6wEIQ=;
        b=aFkVSPSzBqRUWJ7NTvaj5DmkwfNW7xiz/7Wd0nPuljpdjHSfQ/lLXE/j/P8Qtj/4xS
         GXt/F32xQcsY838CG/1MysAfkoydn2/4JOBYfDQWnW6/dSyXIE2OGXtZERg3+b+lxdc2
         VMXqEOhMfzmhiNP3Aa+XHf+ADcbQ7fUHMzwhQ9lXWNH0Gsp7QPNT341n/V3XTN0sTU0f
         FWwV57IcgPs05ewY4QILFmGlWKPaoaJ+vqrWTRYnLTJ0K/wuHwObOlYLp1vrzSGZ+Mtx
         Ylhxa9i01rCi5vVtyfxPyrHv1O+wBFh4d4GMgNicCduQL9FxnTv7d5WWtl6GPHQSd64N
         UbVQ==
X-Gm-Message-State: AOAM532PXypvyH5ycRH2cendCLwAAgDU3cWzR8ImhGXYr1+jJ/r9377e
        imd8MY0IEHsL213/4wVLMUlIAiYB5WK3dJOb
X-Google-Smtp-Source: ABdhPJy1Ff3hI5U/4VaeudX9VzlKgo2TwgK9MlV4whCtYPjj/Ztaj4S3aQ7TVnnsXUpCYaE6OvCl2g==
X-Received: by 2002:a17:90a:5d8f:: with SMTP id t15mr689523pji.28.1618444359086;
        Wed, 14 Apr 2021 16:52:39 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id hi5sm396482pjb.31.2021.04.14.16.52.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Apr 2021 16:52:38 -0700 (PDT)
Message-ID: <60778046.1c69fb81.5dc7d.1ebb@mx.google.com>
Date:   Wed, 14 Apr 2021 16:52:38 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.10.30-20-g6723c3f2e871e
X-Kernelci-Branch: queue/5.10
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.10 baseline: 161 runs,
 1 regressions (v5.10.30-20-g6723c3f2e871e)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 161 runs, 1 regressions (v5.10.30-20-g6723c3=
f2e871e)

Regressions Summary
-------------------

platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.30-20-g6723c3f2e871e/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.30-20-g6723c3f2e871e
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      6723c3f2e871ef03c50b5ed42cc90502b18edd22 =



Test Regressions
---------------- =



platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/60775131eafb7b4402dac6b1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.30-=
20-g6723c3f2e871e/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.30-=
20-g6723c3f2e871e/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60775131eafb7b4402dac=
6b2
        failing since 2 days (last pass: v5.10.29-90-g9311ebab1b30e, first =
fail: v5.10.29-93-g05a9d4973d3b9) =

 =20
