Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6C903A38D9
	for <lists+stable@lfdr.de>; Fri, 11 Jun 2021 02:33:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230236AbhFKAfs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Jun 2021 20:35:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229578AbhFKAfr (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Jun 2021 20:35:47 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7809C061574
        for <stable@vger.kernel.org>; Thu, 10 Jun 2021 17:33:37 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id g6so3015969pfq.1
        for <stable@vger.kernel.org>; Thu, 10 Jun 2021 17:33:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=OKfhaaVHYp3YkgDUXWk+QHmzDWk4Lu9SbZqwfvTwL74=;
        b=qbbkUBuzadJxeZo9PD86S/rA5vtuJouIYKtcwJxiXcAhrFk+LKni7so2alYX/qej+a
         3n+T4oImLDYSHMtI3aPYPNf2ExG5HHqzqouAI8nhdkoKbyi5QEXYIRk8se3KRc4QjtzY
         +6nOELCR5z/nFn2PTP6pDovTVkOIQKfTKoz914ta2+c3H9r9TulDdjKSc/CccFYOj5PM
         MCvCTcEtxwnL765kURJeYOxug3gF5aHlkVaOO2sqGhER2k/R9ipfB/Zirk+YNxCqUuiX
         SOn5SIJWs9OcIj1liRAJL0cCHmnEmKWQAAayr5oOeLa5plL+KDgCuMQ3vuuo8FZXzXvR
         RhLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=OKfhaaVHYp3YkgDUXWk+QHmzDWk4Lu9SbZqwfvTwL74=;
        b=NHIM43+kAgkN1xMNp9TSFpI1sOrvL1ZBjogojbJe5Ej5nrl0BHjrDtURSuMi2b6eB5
         NPtp+xLtD/y3Bqt+U3aImKEy9BtjaVuER7HcaP23P3y78v54kBUnnsfT8Z/2peUDDT1t
         xiwe9vw+7y6uLSunqHzFfoBA6gial+jnfrsZ7EK+9A1Z7J99ZfcYxN7uVwAc77cRoiJP
         ckh0xMlotXOKCpTtpkwvLakqzgQz7837oj29LZYMsGxiC68j36QNpHWmIVIqBFgEDTKA
         xbt5zYAFVA5veRhfr4rvNVrTjXtJajMMXIQmoX0IjIpDde2YZ8tjt/cTkYIhVymdhc0b
         pDBQ==
X-Gm-Message-State: AOAM531579spquj2Z6Zbx3Ify0AD0wYGTKisZWZ9ILTTeGYYoGUooh5c
        TC/Ce4zxSboD0I+TlXJzm16P1aHcMoF9XnFv
X-Google-Smtp-Source: ABdhPJyZTxc2BKM13CJqZODiQQnxnBnhnnRU3cgqlgUGCRnNJui3jwUR7oOMcjF7SIbg3wtL65bo0g==
X-Received: by 2002:a62:687:0:b029:2ef:be02:c346 with SMTP id 129-20020a6206870000b02902efbe02c346mr5544600pfg.51.1623371617244;
        Thu, 10 Jun 2021 17:33:37 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 20sm3224130pfi.170.2021.06.10.17.33.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Jun 2021 17:33:36 -0700 (PDT)
Message-ID: <60c2af60.1c69fb81.676ef.accb@mx.google.com>
Date:   Thu, 10 Jun 2021 17:33:36 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.10.43
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.10.y
Subject: stable-rc/linux-5.10.y baseline: 169 runs, 1 regressions (v5.10.43)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.10.y baseline: 169 runs, 1 regressions (v5.10.43)

Regressions Summary
-------------------

platform             | arch  | lab          | compiler | defconfig | regres=
sions
---------------------+-------+--------------+----------+-----------+-------=
-----
meson-gxl-s905d-p230 | arm64 | lab-baylibre | gcc-8    | defconfig | 1     =
     =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.10.y/ker=
nel/v5.10.43/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.10.y
  Describe: v5.10.43
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      951358a824f96be927ae50fad1e72e05bbb57b56 =



Test Regressions
---------------- =



platform             | arch  | lab          | compiler | defconfig | regres=
sions
---------------------+-------+--------------+----------+-----------+-------=
-----
meson-gxl-s905d-p230 | arm64 | lab-baylibre | gcc-8    | defconfig | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/60c28068e238e81c380c0e0c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.4=
3/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxl-s905d-p230.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.4=
3/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxl-s905d-p230.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60c28068e238e81c380c0=
e0d
        new failure (last pass: v5.10.42-138-gc108263eaf06) =

 =20
