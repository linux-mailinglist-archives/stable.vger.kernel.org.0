Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64EBE3182E1
	for <lists+stable@lfdr.de>; Thu, 11 Feb 2021 02:05:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230385AbhBKBDY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Feb 2021 20:03:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230110AbhBKBDY (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Feb 2021 20:03:24 -0500
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFA2CC061786
        for <stable@vger.kernel.org>; Wed, 10 Feb 2021 17:02:43 -0800 (PST)
Received: by mail-pl1-x629.google.com with SMTP id a24so353331plm.11
        for <stable@vger.kernel.org>; Wed, 10 Feb 2021 17:02:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Eb3ryQ34fBQDVAVJRuDazmirgQHSjLqFO9tflTRkD5M=;
        b=mDKMajxKn1ifzcTjNemICbvgx23fd7libp3EMJzI2hUAIG/MWfadyVnCXH+8T9j0iH
         oauT7ASb+qkNMEyP2q2y89eOvMP5YLl3pR3SVt/cWu/DvbxfqgLyo7hcPEkCBLbXiZKL
         sRYdYe99Bj2vyEH3ViHXIEPcc/hXnXbciwOid2J/plXbzUJbr8iRveXW1Yw4mp+bLA78
         3QDoBDfCqg9ac26a5sWv80N3QiF6AUwNYlv/j4IvllOuGzgmshIrlMdSK54DPLB+7MSF
         YvVRIS7l54m3qa4EqkOM6LG6xYHZGHna7DfWBt4OCALjnuZHEQx2vzzE1kekkyKXocNZ
         6BFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Eb3ryQ34fBQDVAVJRuDazmirgQHSjLqFO9tflTRkD5M=;
        b=YA2JxwytfgXhh1uQdvShYHH/sj7VIUoBsbb7xKz04ORgvK0Q7+0bDZvrS8hNws4pYd
         348v+FTQ7jWaiacxNjmKVYK7TgUKXJ/z+X0lQv6f6CAN75piR7ZFAcYAm3IXODnG8AX2
         Njxr/gS9YDnSJoeLr3WhUlXWzszRqg5Y/4xl6BtocYlqZ0IV//XIdu7wGdmlVi0RwZnE
         2+ahbu4tjLr/lhWsf42hDDa2p8+LqTB2Vz3ScaC7vnvg2GgXAz5U+HqOlOx4dLS8woNc
         yjPBDl98J60CdBBdkZp4IGxVbbISkHpHk4XQrEpQJmgI1hev4T9zJqQKpV71vF06sGTp
         s6oA==
X-Gm-Message-State: AOAM531P6e/jHHechFt2RdVQ3PLSlU3doL6cn5DBURBIqFlyomXzEzRp
        hYKFBtwgRm//NtxTlZ3aE0pgYfnmqsf7yw==
X-Google-Smtp-Source: ABdhPJyVChlQzny+m05USiTBsz8Mxn7I7U7T7oHvz+Gv0S3+SChe89L7Io4BkfjlhLJkN9orOfbeuQ==
X-Received: by 2002:a17:902:8501:b029:e2:ebb4:6e77 with SMTP id bj1-20020a1709028501b02900e2ebb46e77mr5299325plb.43.1613005362548;
        Wed, 10 Feb 2021 17:02:42 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id z125sm3930765pgz.45.2021.02.10.17.02.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Feb 2021 17:02:42 -0800 (PST)
Message-ID: <60248232.1c69fb81.40b88.97ff@mx.google.com>
Date:   Wed, 10 Feb 2021 17:02:42 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.9.257-12-g43f72a47dfce5
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.9
Subject: stable-rc/queue/4.9 baseline: 41 runs,
 1 regressions (v4.9.257-12-g43f72a47dfce5)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 41 runs, 1 regressions (v4.9.257-12-g43f72a47=
dfce5)

Regressions Summary
-------------------

platform             | arch | lab        | compiler | defconfig       | reg=
ressions
---------------------+------+------------+----------+-----------------+----=
--------
sun8i-h3-orangepi-pc | arm  | lab-clabbe | gcc-8    | sunxi_defconfig | 1  =
        =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.257-12-g43f72a47dfce5/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.257-12-g43f72a47dfce5
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      43f72a47dfce5b6da1d6a911618015816f27f859 =



Test Regressions
---------------- =



platform             | arch | lab        | compiler | defconfig       | reg=
ressions
---------------------+------+------------+----------+-----------------+----=
--------
sun8i-h3-orangepi-pc | arm  | lab-clabbe | gcc-8    | sunxi_defconfig | 1  =
        =


  Details:     https://kernelci.org/test/plan/id/60244f95f7277d39cc3abe83

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.257-1=
2-g43f72a47dfce5/arm/sunxi_defconfig/gcc-8/lab-clabbe/baseline-sun8i-h3-ora=
ngepi-pc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.257-1=
2-g43f72a47dfce5/arm/sunxi_defconfig/gcc-8/lab-clabbe/baseline-sun8i-h3-ora=
ngepi-pc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60244f95f7277d39cc3ab=
e84
        new failure (last pass: v4.9.256-47-g343972be0e1d) =

 =20
