Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD19139D37D
	for <lists+stable@lfdr.de>; Mon,  7 Jun 2021 05:30:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230225AbhFGDcE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Jun 2021 23:32:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230127AbhFGDcC (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 6 Jun 2021 23:32:02 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70793C06178B
        for <stable@vger.kernel.org>; Sun,  6 Jun 2021 20:29:55 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id fy24-20020a17090b0218b029016c5a59021fso4488087pjb.0
        for <stable@vger.kernel.org>; Sun, 06 Jun 2021 20:29:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=e8WsA9vm92Q9PRI86W+GkcASm1m0PPN2oLH5YXM5QiA=;
        b=K4pu5UqsXmf0UyzKuzdKogGz9Nm/BET7hfRWm9syhkynR0sOadJZSpBndpe8b8fs35
         /T/YTLlYbKRbB3PdTtqM/Y6+DDV7BTSHHmgCNR/8xeMr7e8zVex1kHhbqpgMwhLCyyRI
         x+68yKakSFyb1Pck+Sm8MklKAQcF/lRYOD+tk10pdU7PCEoT7svAPAaGmiJPeTsaii6C
         J5VPM/hxG/b77uT0Xtk/PJx8LIRbXmW5CCIE4oXvyyMhcPDTIvNOcnksLLMhbX+IqfBM
         WurU9yzGEKECiZ9jEPUmqzgaCu23CN5PBaBws7WQ5qFHiD39wXh4J1L9izX3FsQR760Y
         GinA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=e8WsA9vm92Q9PRI86W+GkcASm1m0PPN2oLH5YXM5QiA=;
        b=n1paq4DW7qAO6PsvmMIvNJ0bVt+mHm4v3K4YG2gRIBF3Rs69hfhY49N/7LsfnNmHT3
         HYudDpHN10Nx4K+9tAo2nnlSk+jMGy+Wb/UCxYeGTMds/+JcthvGhgoOAOSAx+Hi27wB
         se4z8k4xCf4Sc4m8anDA3Q8sjZaDJa3P8JuXwzLLmgH114tZRo96Xbk9qRNPqHdcQ9nU
         22LfnfgtLFZevmMw4hbhn0m4jhkQNrFvlMWv3v2TOk+ZMq18B+tptmjn/FXemfpKbBm3
         /28UfgsLi3UyCEJAtpFhMDcWrSioTXwiwxMzr5020n4slkg/vBGYxrhKaJKI3JolIRG4
         DyCg==
X-Gm-Message-State: AOAM533F+/1xdYTNmQhpFvkcG9ABnmhyW468xmEZ9HqLD7cnGM2NiChN
        aPYuVKm53Qm11f/zgGOv5YHDOG3VAUH/xX2P
X-Google-Smtp-Source: ABdhPJxGXe43OhV9dj7n4W0bvjJuoCk0/59ibIETMAW0Nc5jKCHD1a5FWdJzfZ6sVcCs879m9H9O1g==
X-Received: by 2002:a17:902:e551:b029:103:c082:ba with SMTP id n17-20020a170902e551b0290103c08200bamr15818711plf.3.1623036594754;
        Sun, 06 Jun 2021 20:29:54 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id d14sm10260985pjc.56.2021.06.06.20.29.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Jun 2021 20:29:54 -0700 (PDT)
Message-ID: <60bd92b2.1c69fb81.13161.0d51@mx.google.com>
Date:   Sun, 06 Jun 2021 20:29:54 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.10.42-68-gbf77ca472c45
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
Subject: stable-rc/queue/5.10 baseline: 199 runs,
 1 regressions (v5.10.42-68-gbf77ca472c45)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 199 runs, 1 regressions (v5.10.42-68-gbf77ca=
472c45)

Regressions Summary
-------------------

platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.42-68-gbf77ca472c45/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.42-68-gbf77ca472c45
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      bf77ca472c455430bfc69ca092bc04445e844c63 =



Test Regressions
---------------- =



platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/60bd610dcd695b0f340c0e2b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.42-=
68-gbf77ca472c45/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.42-=
68-gbf77ca472c45/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60bd610dcd695b0f340c0=
e2c
        failing since 3 days (last pass: v5.10.40-261-g8e56f01eb8e7, first =
fail: v5.10.41-251-g1360515527f5) =

 =20
