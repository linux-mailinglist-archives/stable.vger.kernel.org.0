Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8A993815AB
	for <lists+stable@lfdr.de>; Sat, 15 May 2021 06:07:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230014AbhEOEIq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 15 May 2021 00:08:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbhEOEIq (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 15 May 2021 00:08:46 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEDE1C06174A
        for <stable@vger.kernel.org>; Fri, 14 May 2021 21:07:32 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id t11so854501pjm.0
        for <stable@vger.kernel.org>; Fri, 14 May 2021 21:07:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=1kixGnBpBn8SM/wum0cgclrpcZ45J0WIDKRPufb/XC8=;
        b=eNOqoFmxXvAgknhfx7A/3g5UZoUiWy8u1no3wNveV+3+hNvj2pu0fBqK7n1NyilJ6p
         cyzApZK+UooORjoDA6fmEboLVKAIsk4tbpfOUk5dIM+KWthwfBKWTQmF5yCQ52G4XoaN
         0SW0L7AGGipGM/5GaE+1pz06zZu+y8+JMXbuBKjtcSTrl5c6LO70/ZnsrZuQUHqHrMUw
         6bq4vxdWCdEBy7si20kJjvIY3eNrFhfvN9d3/sKwrKP+/E/bAp8T5Z8H14vej+ayKare
         qlafxD5E8Ye9yEZlXgq2Skhm9uV5EcralKlkiq1UYbLjKP1NDGH7lFSjHgkhDrpc1/Mg
         HwdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=1kixGnBpBn8SM/wum0cgclrpcZ45J0WIDKRPufb/XC8=;
        b=i8IEtJ29tyT8trcnbfoKCcoKrxc89vx3os9rsWAe4Gv43wN+3YZBPfgfazwKmcfoDA
         jt6qacH2hLgSxBPhfKKBka9/BoeQnsYUsTG3J76N9IxqUJ1hdEPnjUCwTqpq7Z4iOity
         XXxwHbLLqlJ0sx0K6f9FKVIaalkNq/NdE8XhxU+iXbDYnI4I+V7aG/R5tUfLGMQ+6iAb
         MprNOjNLojVpsMVMXfFjJrWbEwxCN3kLc8GWLK52Lh6saHe92w70h3JL41WkuUHt9Z0Z
         QT8B/NG0QcAmdw8wExHhJ6pMyYj7W+k+0cCHWDOAgCgxvEl0lYkn3mb34rEP1t+AjCu+
         5jZA==
X-Gm-Message-State: AOAM533+8mx4dEavD+Hv3DUP2NYfH8IvpstLIeLELgqzRkCXi+6g2GV1
        Wpnc8esIlHI8MGce65z33XS+0yLWx6i4UnzL
X-Google-Smtp-Source: ABdhPJxZYU6AgQFbuWwha71s3QzS1m3Sr+2PaCqXuNryxUslCc1b/NsmF9jMnEC4pHddLfTxKuy55Q==
X-Received: by 2002:a17:902:dacf:b029:ee:ac0e:d0fe with SMTP id q15-20020a170902dacfb02900eeac0ed0femr49157827plx.30.1621051652211;
        Fri, 14 May 2021 21:07:32 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 67sm1962288pfw.83.2021.05.14.21.07.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 May 2021 21:07:31 -0700 (PDT)
Message-ID: <609f4903.1c69fb81.e237c.7155@mx.google.com>
Date:   Fri, 14 May 2021 21:07:31 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.12.4
X-Kernelci-Branch: linux-5.12.y
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-5.12.y baseline: 127 runs, 1 regressions (v5.12.4)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.12.y baseline: 127 runs, 1 regressions (v5.12.4)

Regressions Summary
-------------------

platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.12.y/ker=
nel/v5.12.4/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.12.y
  Describe: v5.12.4
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      4bcf3b752d59b1ef839afcc4b1c0731652ef40d6 =



Test Regressions
---------------- =



platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/609f1663784eca23adb3afad

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.12.y/v5.12.4=
/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.12.y/v5.12.4=
/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/609f1663784eca23adb3a=
fae
        new failure (last pass: v5.12.2-1062-g6c1612b793001) =

 =20
