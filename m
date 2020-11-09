Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBAF52AC332
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 19:07:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730062AbgKISHX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 13:07:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730011AbgKISHX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 Nov 2020 13:07:23 -0500
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DEEBC0613CF
        for <stable@vger.kernel.org>; Mon,  9 Nov 2020 10:07:23 -0800 (PST)
Received: by mail-pf1-x433.google.com with SMTP id e7so8871004pfn.12
        for <stable@vger.kernel.org>; Mon, 09 Nov 2020 10:07:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=/RM1F5KZ8VLerQ3Q85XOALIrVnkMHzQfZ4Aa4f05Ge4=;
        b=Y/AWgrk8kav5uOHDwInMDD5Q4eb2d/gn5KzI5bEjNMfNoW8y9ik0SXPTmAoGpKyjYq
         ig97NDqzNFF+/CgMcvk9beqv+yEA4/9NUiI0vwGs2EmfR9zDkiPZAodj8fNgCtHdjNYM
         CFORl0zOoFhrOIl37UKMUIpVcSobjONZA6+tyu5OzIQ4kanyozOMUiC/gHi55InL8SQL
         nU9orrYhz16gZyDMTL4pW1rATo3rzqUED3U2S5kTTc28+Tx3jpElOTO+JNgTax3adwqh
         E6+GoDOfgXBf3Yh94kqws29cpE/NQZzC0dBIWqXKb5ua5UKHdd1g4v5VA3X8ceUUES5R
         GyJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=/RM1F5KZ8VLerQ3Q85XOALIrVnkMHzQfZ4Aa4f05Ge4=;
        b=qxs7jANJk7ip+DC6KS5q3M3hL7r735QIO7cSOt4aPyunHGo66MiZXNm3MHGHUqTyyI
         osQCcYJOMDD0/oiluq5HOOFque3Z+CY77aIxhVUOwwbyIvBb/GF6i6EwWvmJ5faZTpsG
         QSljLtunH+/npTfWE0hWjQPVLyue5tk0daxPPvTn/AEqEuSt6Kh05KB+1Wb1nXCRc7+W
         4VA4DbBq8CUpXsl/mSKHlCs4K+UzbM6/6EEjtQ7+kB9R17z39qclIycUsyVqBIHx85CW
         K98RTNE8ixUQlSLce0sUmT/Gen1w0rFSjpf508tvn680qZWXxdkbtja+5cYDme4ZH4u4
         3+9A==
X-Gm-Message-State: AOAM532Q8GgILFi3ttCRx208EgIBqXuagloaSrH5hoKGCrPI0LiyGySE
        T8WQzzUULZJLMQPamGcc190r+ND0+f8BVw==
X-Google-Smtp-Source: ABdhPJxcJZlkf1V+9O1FtaBpD0wr/wFZzT0DBH1d4+bnsRfJnTD2mKLcRgH99UHxh21QUutZmY5c/A==
X-Received: by 2002:a17:90a:e615:: with SMTP id j21mr411225pjy.26.1604945242788;
        Mon, 09 Nov 2020 10:07:22 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id q16sm11455692pfj.117.2020.11.09.10.07.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Nov 2020 10:07:21 -0800 (PST)
Message-ID: <5fa98559.1c69fb81.887db.8983@mx.google.com>
Date:   Mon, 09 Nov 2020 10:07:21 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.8
X-Kernelci-Kernel: v5.8.18-26-g4c79ffd3cac10
Subject: stable-rc/queue/5.8 baseline: 150 runs,
 1 regressions (v5.8.18-26-g4c79ffd3cac10)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.8 baseline: 150 runs, 1 regressions (v5.8.18-26-g4c79ffd3=
cac10)

Regressions Summary
-------------------

platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.8/kern=
el/v5.8.18-26-g4c79ffd3cac10/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.8
  Describe: v5.8.18-26-g4c79ffd3cac10
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      4c79ffd3cac1060fdd346f77e386edeabe0be9b2 =



Test Regressions
---------------- =



platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fa951b62c45f25e20db8853

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.8/v5.8.18-26=
-g4c79ffd3cac10/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.8/v5.8.18-26=
-g4c79ffd3cac10/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fa951b62c45f25e20db8=
854
        failing since 0 day (last pass: v5.8.18-26-g2f46df01d254e, first fa=
il: v5.8.18-26-g1bfb85c48918) =

 =20
