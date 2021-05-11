Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18EA1379E0E
	for <lists+stable@lfdr.de>; Tue, 11 May 2021 06:11:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229932AbhEKEMq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 May 2021 00:12:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbhEKEMo (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 May 2021 00:12:44 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 565DFC061574
        for <stable@vger.kernel.org>; Mon, 10 May 2021 21:11:38 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id c13so1698060pfv.4
        for <stable@vger.kernel.org>; Mon, 10 May 2021 21:11:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=BLzi3tPJaMaDel6vJBnVVt26jRiy7WMEM3dyfpOk+Bg=;
        b=GHS9oC+a4LdaaDvbK3uNjQGhDMceVY/8UBcTvVvguk1kq4rL0XSIF9x7r0GzWOXZfh
         LS3GZZVIzslS5at5fmLTJXpzo4FKVck5nB0KdLaPji/qNoDQAVICxRfPFK2FB8OORSEZ
         wVX5jrrak2VAivXGfBmn8CuWennSYxqsnyOWWHkiHRze+gxFDagEqkxfqn8of+4hODXK
         ZFK+vyfpfCcBiFofhCvOmb5yvvzNq7aiUn/VV5ZSX2JoeaYAPnH6P2H2GGxJc8DLJ6XE
         rO2yTjbcmUuX3qoAoDSV8YlM4IbtZrqixLAMjgmUpUluYirPSQs3nqCCxXcYxeCsd9rN
         5QDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=BLzi3tPJaMaDel6vJBnVVt26jRiy7WMEM3dyfpOk+Bg=;
        b=ptT4sFzqSwQeLYrh/RlncnhOV4q6zk5aaTbOb23aDy5p6MV2g+bp0lNt/XAXBNvL63
         nzdtHKv8JqWtBMdmcKqbQFzAu9KH3j2Fz2jYrcXPJSvDMr9dSUHH/IE7xtB3ajPqC0IZ
         nLNUhDdDyK8Qd/QiserxJNyDfBHXjs6vj8UIQB8RhDHCBGXS35Sv36VXpNQ1PVyMGkcu
         9M6CvVlvVtW7Z6/OGn8ESMbUdx19JyBhxaluCdIWbDNJx3f/rM1lzQxYB3Vze4Q6ve5c
         nnnfoe2AfNhk7S9hewBcSZsKG4skQX5t6nUqW2R1ooeDVJcKYqaxWm3pRbOLay29ykFF
         nFNQ==
X-Gm-Message-State: AOAM531myZMTSErN5mco5+rSK7uxiY93vunQWjRiGYpKmhs/XuKCXpfu
        vTDLq3zHrNh1xbjBXHnfBUaUKYs8KWPEdKpP
X-Google-Smtp-Source: ABdhPJysoStywJT5KE3cx458013hkAnb8iov5QDHlFIr9hwKLOhY5mmYXz2idcrJecLG5i3y065aGA==
X-Received: by 2002:a63:5602:: with SMTP id k2mr28004015pgb.127.1620706297349;
        Mon, 10 May 2021 21:11:37 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b7sm8491965pfa.98.2021.05.10.21.11.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 May 2021 21:11:37 -0700 (PDT)
Message-ID: <609a03f9.1c69fb81.3c52.ab9d@mx.google.com>
Date:   Mon, 10 May 2021 21:11:37 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.12.2-384-gb24e2ca092b86
X-Kernelci-Branch: queue/5.12
Subject: stable-rc/queue/5.12 baseline: 150 runs,
 1 regressions (v5.12.2-384-gb24e2ca092b86)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.12 baseline: 150 runs, 1 regressions (v5.12.2-384-gb24e2c=
a092b86)

Regressions Summary
-------------------

platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.12/ker=
nel/v5.12.2-384-gb24e2ca092b86/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.12
  Describe: v5.12.2-384-gb24e2ca092b86
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      b24e2ca092b86b680d4ee428be8164604ee2c28d =



Test Regressions
---------------- =



platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/6099cd5ec3f182aac16f5468

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.2-3=
84-gb24e2ca092b86/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.2-3=
84-gb24e2ca092b86/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6099cd5ec3f182aac16f5=
469
        new failure (last pass: v5.12.2-330-gdef67aff47f02) =

 =20
