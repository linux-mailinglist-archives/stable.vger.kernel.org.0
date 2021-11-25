Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B01145DAF9
	for <lists+stable@lfdr.de>; Thu, 25 Nov 2021 14:21:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355427AbhKYNYB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Nov 2021 08:24:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354973AbhKYNVx (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Nov 2021 08:21:53 -0500
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BC17C061758
        for <stable@vger.kernel.org>; Thu, 25 Nov 2021 05:16:11 -0800 (PST)
Received: by mail-pl1-x62c.google.com with SMTP id y7so4584237plp.0
        for <stable@vger.kernel.org>; Thu, 25 Nov 2021 05:16:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=zxpt8mO6Fs4ihKgowMxxbxiFV5jwwIBH7PDJQbQ4AYM=;
        b=jsYDVxgYeobdTAR8HpaSgMBU8UwSK3Yl3t/O+Iqq2wKHHp+r7tvl/O48PQZVb9UZKi
         3GKW12cTRUzBkeeNVG3tGPYpyfoWUXEIPQkBVHcDA6E0MMf4KQcvzZMA2Omd+zZkruZY
         xqaUNdZCF/1zrRHV9LEH1FQ5xUMLkeJFXlhlTsL8+/P9LSfhK9YR2p2X2fnepdBSwElB
         9B2TDyQwFIjrCpPVv+09av4JxZHJAQJwM13eNODDrzHMaFBqAgapARDk88nDUNiAEgGZ
         L+P3okvMf171vNK80+ueTIhkPxti5oLyW7JatF60idLqu177kL++0EssO9D3nhaFt5Hb
         qvrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=zxpt8mO6Fs4ihKgowMxxbxiFV5jwwIBH7PDJQbQ4AYM=;
        b=2mcDE41tITp+Qvx2zOKBc4BnZIQ894s1Ns6I5yhhXCWG8mn0/SOK2vd4SbHCXvvPd7
         90t/oPSlijA8Xf9R0ixHCi98/OkSidzz5pDAz3xoaAvWmFiqQ2nmsVFuK3ahEL/Ag8ly
         kSQRH9POBVPyLnKWpgUJTxK5wL2nP0nBsHhI4kvNJ4pqVVQBwqhGut7SSOK6/jciVUKU
         I0QWQ4HI2Ekb1r1x8ZxwwgGD+Pl15ZlURQkGcHwb5x+xvLUTPExpffcMuqyDaoP0ex0H
         8EXY89VqPa1o5leshj4XTDJq3parDC+bcZubVhBGtgJYzL5AtFkMZ3795llVZmgny6bY
         R94w==
X-Gm-Message-State: AOAM532JdJ/tyTWjs/IdfkxymYvG/QDU/J7hOChL9LnHhjQe0A5Tzz02
        bXHx4v4lrhUrtUH5CbCq3KRRLpInRQCrCqXjEW4=
X-Google-Smtp-Source: ABdhPJw5VW3Cir3C7AqJG/XO1jaVyNBzfRV57+rNKAGcdiZWBQxZ/P9+INgCImnnIJzNVJLc4wkkUA==
X-Received: by 2002:a17:90b:3887:: with SMTP id mu7mr6973307pjb.89.1637846170560;
        Thu, 25 Nov 2021 05:16:10 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id h22sm2447444pgl.79.2021.11.25.05.16.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Nov 2021 05:16:10 -0800 (PST)
Message-ID: <619f8c9a.1c69fb81.7d51c.65d2@mx.google.com>
Date:   Thu, 25 Nov 2021 05:16:10 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.10.81-153-gc68f60f1d94a
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/5.10
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.10 baseline: 170 runs,
 1 regressions (v5.10.81-153-gc68f60f1d94a)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 170 runs, 1 regressions (v5.10.81-153-gc68f6=
0f1d94a)

Regressions Summary
-------------------

platform         | arch | lab     | compiler | defconfig          | regress=
ions
-----------------+------+---------+----------+--------------------+--------=
----
beaglebone-black | arm  | lab-cip | gcc-10   | multi_v7_defconfig | 1      =
    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.81-153-gc68f60f1d94a/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.81-153-gc68f60f1d94a
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      c68f60f1d94abd092641e5d2f3637f2e013e15b9 =



Test Regressions
---------------- =



platform         | arch | lab     | compiler | defconfig          | regress=
ions
-----------------+------+---------+----------+--------------------+--------=
----
beaglebone-black | arm  | lab-cip | gcc-10   | multi_v7_defconfig | 1      =
    =


  Details:     https://kernelci.org/test/plan/id/619f55041c64778cc6f2f026

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.81-=
153-gc68f60f1d94a/arm/multi_v7_defconfig/gcc-10/lab-cip/baseline-beaglebone=
-black.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.81-=
153-gc68f60f1d94a/arm/multi_v7_defconfig/gcc-10/lab-cip/baseline-beaglebone=
-black.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/619f55041c64778cc6f2f=
027
        new failure (last pass: v5.10.81-154-g8dbefffb8451) =

 =20
