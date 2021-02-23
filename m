Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0CBE323357
	for <lists+stable@lfdr.de>; Tue, 23 Feb 2021 22:37:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233166AbhBWVfG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Feb 2021 16:35:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233632AbhBWVfD (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Feb 2021 16:35:03 -0500
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36513C06174A
        for <stable@vger.kernel.org>; Tue, 23 Feb 2021 13:34:23 -0800 (PST)
Received: by mail-pf1-x42d.google.com with SMTP id z5so6468435pfe.3
        for <stable@vger.kernel.org>; Tue, 23 Feb 2021 13:34:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Q5MsQTWh9J6M7QPhAJapE9Iiy/WmZsW711OuL76dLyQ=;
        b=V4544aflqFFtV+JEpitEmpBHiEt2/rWKQgMbtVk8dF0i/lP+DNEZrNMRjAdMrBh36e
         7yXkx98ugDa29TSUQGDoc3hHE/iLRLLAlljfzMwV/GyLtYkeHEdLPWEzpqu/W6I6+PnP
         pbqRIgqf10XBZdyMmNVw/0t3SO9fWtNYtQVXflDm75K69RWf07r70j98P6pETZGA3cde
         v5WnCWRD/ksaMhDhynNzVEkhPvdP0r9Pje2k0Wb5vX1nFt7L6tMBK/t6XmnHPDaGnZnS
         fHkhABNg8IgFv2hXzyN7d5YJYCb52WAGFaq7+eYjP/dG5atcbhwC7ZBIwXOe95MLo3K5
         mBOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Q5MsQTWh9J6M7QPhAJapE9Iiy/WmZsW711OuL76dLyQ=;
        b=bs5vOL1dgNT6QR3QaBZpQQYTa+M/YkmVpVMgKqQvEtKdu7RhDw1/Fn6CpG248YdqYx
         BAYwxVkU8pmrw+/WFY5xqVariJnj+yLOS4+IZUQ6AvvJce8LezDPmyzeMdGQgemippNW
         rtBhgRPu7LU7quaLnJcwIvaKKJ13IffcJ1iAWVxArPHEER7uT7CY+Up6jSw9/ZNdGRXB
         1tzrkyvdaQhRzOD57yUC3IGzTHP4UONvmqXggLqNTo6OD/hMLynk7ODXUlWhFqIy6RFp
         ScqUaFb5K3fwSG5CTwDvEQxJQ5Cbl++cFrTJdnO3futMNqgyaZ6QW/2cvvmjjYDiS3RV
         O0Ag==
X-Gm-Message-State: AOAM530WlN/XIW8MiuiE+EzGKQx0F9mx8y5paS+gQDYIRtr7EfWrKZyd
        oADn3a1XjKXRSDDhF7tC341FkqGdV1v9LQ==
X-Google-Smtp-Source: ABdhPJzieYGMa6BkiilFCqmThkdVk64lQnrxc3KsvCnEJiACAxQLk1R0Vl9a7fQgUC2TP0enlQOR1w==
X-Received: by 2002:a63:1c13:: with SMTP id c19mr25116294pgc.359.1614116062663;
        Tue, 23 Feb 2021 13:34:22 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id x1sm12932441pgc.71.2021.02.23.13.34.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Feb 2021 13:34:22 -0800 (PST)
Message-ID: <603574de.1c69fb81.16918.a087@mx.google.com>
Date:   Tue, 23 Feb 2021 13:34:22 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.4.100
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-5.4.y
Subject: stable/linux-5.4.y baseline: 110 runs, 2 regressions (v5.4.100)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.4.y baseline: 110 runs, 2 regressions (v5.4.100)

Regressions Summary
-------------------

platform             | arch  | lab          | compiler | defconfig         =
| regressions
---------------------+-------+--------------+----------+-------------------=
+------------
bcm2837-rpi-3-b-32   | arm   | lab-baylibre | gcc-8    | bcm2835_defconfig =
| 1          =

hifive-unleashed-a00 | riscv | lab-baylibre | gcc-8    | defconfig         =
| 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.4.y/kernel/=
v5.4.100/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.4.y
  Describe: v5.4.100
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      fc944ddc0b4a019d4ece166909e65fa2a11c7e0e =



Test Regressions
---------------- =



platform             | arch  | lab          | compiler | defconfig         =
| regressions
---------------------+-------+--------------+----------+-------------------=
+------------
bcm2837-rpi-3-b-32   | arm   | lab-baylibre | gcc-8    | bcm2835_defconfig =
| 1          =


  Details:     https://kernelci.org/test/plan/id/60353c67cb46626a2caddcda

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.100/ar=
m/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b-32.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.100/ar=
m/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b-32.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60353c67cb46626a2cadd=
cdb
        new failure (last pass: v5.4.99) =

 =



platform             | arch  | lab          | compiler | defconfig         =
| regressions
---------------------+-------+--------------+----------+-------------------=
+------------
hifive-unleashed-a00 | riscv | lab-baylibre | gcc-8    | defconfig         =
| 1          =


  Details:     https://kernelci.org/test/plan/id/603539925b83d57a1faddcda

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (riscv64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.100/ri=
scv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleashed-a00.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.100/ri=
scv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleashed-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/riscv/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/603539925b83d57a1fadd=
cdb
        failing since 96 days (last pass: v5.4.77, first fail: v5.4.78) =

 =20
