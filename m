Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D983F3A0A24
	for <lists+stable@lfdr.de>; Wed,  9 Jun 2021 04:42:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235787AbhFICo3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 22:44:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235783AbhFICo3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Jun 2021 22:44:29 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DD0EC061574
        for <stable@vger.kernel.org>; Tue,  8 Jun 2021 19:42:23 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id z26so17249004pfj.5
        for <stable@vger.kernel.org>; Tue, 08 Jun 2021 19:42:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=05Dps8dZ+T1O0bEMYjao6fyejQQPHioai2i2ZPqzP6Y=;
        b=UKgRF7octG30hksQfdYKSPvqCurwhxuy/gsG+nDAM1H8w5JrgrlFUpik0ts9fdlccS
         IECAo5UxtqCQehxHJshGh1o4tRBYIi6QA2e3FtLsjNF7Kn6xE7hdWXU3H31mEvy+1J6a
         9sb72zkRxSqvFmvMzN2KV/0cHhi5RcfrwwvCmmJqwZQPAN6nyLYIkAVDkfzcfvyHveJs
         Y5hOxw8d69idvuJpmGq6OWPNodXg9xXBjU9jFEES8HDkmIZhxxdeuRk3JlMryVZY2Vgv
         rtF4jHkX3O0DU2vY2N9lTqwzIIhXUEm3nMg0Xq1lI8odfzt5d/S80YcXMrxoeMxOCucl
         MPeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=05Dps8dZ+T1O0bEMYjao6fyejQQPHioai2i2ZPqzP6Y=;
        b=Mda2PdsOAxSQJPRYzSH2chRUZiqVxh+M7XqzgH1Qs5jYTfIoAmIeWEv3cTjye+43E0
         O7P1S/MLtZnF9pS3zG7asw7S0YiTsybTaYOvJmL/xekmVRAkg6Io1goTUZKo7ELVd85j
         wqpuwX6P0YqYjK6YUWwLKdrA2uuLy12hKiDJIQnqbvAVlLFDDpV6MRJ6kirW0yE2Yamo
         lBNmZEh4pDDrwJInAekHT3rv3UhK9u3ZU0WBfYzim2X+2V67CgaL/Qpsu8VtfMGOPPKp
         1KXE/CF953+SxrIKaEapOnFNB2itxQRPAdi5XybNksdKkzPQAqPA46IFdKDphQvK9iMt
         2QvQ==
X-Gm-Message-State: AOAM533oWothfveckTdKSWSCNmgfVa8nBf1MgzI/Q1k62lAvPzP/sQOv
        y5DGCNKXquL1jKnuYp2FTx2vibuiVz6AzrdB
X-Google-Smtp-Source: ABdhPJyIlMmbYMcz9dRElBPPi3CYY4MCytnph55xUKcMkicDjUsoRPiUCDYYQ/y7Dprpoe5T/4D5RA==
X-Received: by 2002:a62:a102:0:b029:2f4:a8e:cc44 with SMTP id b2-20020a62a1020000b02902f40a8ecc44mr441853pff.38.1623206542941;
        Tue, 08 Jun 2021 19:42:22 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id bo14sm3342591pjb.40.2021.06.08.19.42.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Jun 2021 19:42:22 -0700 (PDT)
Message-ID: <60c02a8e.1c69fb81.95fee.b871@mx.google.com>
Date:   Tue, 08 Jun 2021 19:42:22 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.193-58-gf8447ad057a5
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.19
Subject: stable-rc/queue/4.19 baseline: 72 runs,
 3 regressions (v4.19.193-58-gf8447ad057a5)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 72 runs, 3 regressions (v4.19.193-58-gf8447a=
d057a5)

Regressions Summary
-------------------

platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-baylibre | gcc-8    | versatile_defconfig=
 | 1          =

qemu_arm-versatilepb | arm  | lab-broonie  | gcc-8    | versatile_defconfig=
 | 1          =

qemu_arm-versatilepb | arm  | lab-cip      | gcc-8    | versatile_defconfig=
 | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.193-58-gf8447ad057a5/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.193-58-gf8447ad057a5
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      f8447ad057a5ba01ce97e6474289d14789dbfada =



Test Regressions
---------------- =



platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-baylibre | gcc-8    | versatile_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/60bff100e319a37cae0c0dff

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.193=
-58-gf8447ad057a5/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.193=
-58-gf8447ad057a5/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60bff100e319a37cae0c0=
e00
        failing since 207 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-broonie  | gcc-8    | versatile_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/60bff1620c02b24b6a0c0df5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.193=
-58-gf8447ad057a5/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.193=
-58-gf8447ad057a5/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60bff1620c02b24b6a0c0=
df6
        failing since 207 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-cip      | gcc-8    | versatile_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/60bff100af688060e30c0e02

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.193=
-58-gf8447ad057a5/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.193=
-58-gf8447ad057a5/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60bff100af688060e30c0=
e03
        failing since 207 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =20
