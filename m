Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86F4B310EEA
	for <lists+stable@lfdr.de>; Fri,  5 Feb 2021 18:42:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233379AbhBEP6O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Feb 2021 10:58:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233419AbhBEPz6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 5 Feb 2021 10:55:58 -0500
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16449C061574
        for <stable@vger.kernel.org>; Fri,  5 Feb 2021 09:37:09 -0800 (PST)
Received: by mail-pl1-x62a.google.com with SMTP id b8so3909229plh.12
        for <stable@vger.kernel.org>; Fri, 05 Feb 2021 09:37:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=GHHuOVvjpPhTsQy6firSGbAho/YcIUfF4p6wc1mHTno=;
        b=PzzTYsM0DBQthmMP4PAOo3tG2jlM+OHbQBvjOFmATnIiNVBnZc2S+8MQtDmjj5ANBv
         6Jw859ab+jndf05fZS5GSeNz76rq86N5sYf0ADusgZl+bJU37MmAXpAFrR8W/M7bZrhc
         erA2uXYMNtFrtClq05woX0rFVfB5302DRpZIi2rWYMuixxU79R7ej/Z0fgZP+78AcgGt
         gc+ZkaY/iuL0rufdNhgPFEYArg8I4Yjseb/Kr6JL7wgRzbMk1wgaJnz9sKBcodLvLpOE
         cSJmSno7s2vgJpbm4L69VIfzpV68uR9weys0QwLQWnQa7IjbLuDPXeB6P/ej1evBiHX8
         EfGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=GHHuOVvjpPhTsQy6firSGbAho/YcIUfF4p6wc1mHTno=;
        b=XVZ8YMl7no3ZuTsldLKKCFLM7u5UX4iGW1q6MOi35iqZPAS6JNsH87ygXKSL/uY2iP
         bjvyPI/Gt5+9Gzc5sP9urTO19vVJ4itLARd98YI9FfW6C+479LgD6KcpXcWIJM8hzvvq
         xxUxBVMmv7nvLln9YYPlmaGKZQ1y20TbzWCs9ruoBlVFKpYeKaxcSaZ3/RB+FYwCPY49
         taiQd+t+thkYUm2Z8OIV7aQZSfs4PmqC3d8EWQ8a+YxW5ywdcMhZPQD09SkKgcPrKVUn
         Ea8Dm7IKDqzEiU2Qwik2PY8DY0+9TaBOt9147EZAsgO63RFEul7HIv7psur7hIjb4R1s
         TTFA==
X-Gm-Message-State: AOAM530RhMoA2EA3T+EBGvT3QWgKQ+oPLuVoVn/LgDTUrCy1Kb7nOPhP
        BjHscApSxC+5+iBEGPf45NtpHZJDnUayqg==
X-Google-Smtp-Source: ABdhPJyePFRuu8DScseRgSo9KBBHFZz7bN2/F8m9EiYP0wsZMx4sOTxNDlRMJWN+V4IcMtwNVqfylA==
X-Received: by 2002:a17:90a:46cb:: with SMTP id x11mr5193138pjg.124.1612546628272;
        Fri, 05 Feb 2021 09:37:08 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id p2sm9625707pjj.0.2021.02.05.09.37.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Feb 2021 09:37:07 -0800 (PST)
Message-ID: <601d8243.1c69fb81.4cc65.4b34@mx.google.com>
Date:   Fri, 05 Feb 2021 09:37:07 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.9.255-13-g9357627a52d98
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.9
Subject: stable-rc/queue/4.9 baseline: 100 runs,
 4 regressions (v4.9.255-13-g9357627a52d98)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 100 runs, 4 regressions (v4.9.255-13-g9357627=
a52d98)

Regressions Summary
-------------------

platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.255-13-g9357627a52d98/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.255-13-g9357627a52d98
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      9357627a52d982c41cd08f0128de5fcc563470e5 =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/601d4f0cb3d3d79b233abed9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.255-1=
3-g9357627a52d98/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.255-1=
3-g9357627a52d98/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/601d4f0cb3d3d79b233ab=
eda
        failing since 83 days (last pass: v4.9.243-16-gd8d67e375b0a, first =
fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/601d501836199528d03abe8d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.255-1=
3-g9357627a52d98/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.255-1=
3-g9357627a52d98/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/601d501836199528d03ab=
e8e
        failing since 83 days (last pass: v4.9.243-16-gd8d67e375b0a, first =
fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/601d4f1d6d41f3c8813abea7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.255-1=
3-g9357627a52d98/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.255-1=
3-g9357627a52d98/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/601d4f1d6d41f3c8813ab=
ea8
        failing since 83 days (last pass: v4.9.243-16-gd8d67e375b0a, first =
fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/601d4ec9fb246a2d293abe95

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.255-1=
3-g9357627a52d98/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.255-1=
3-g9357627a52d98/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/601d4ec9fb246a2d293ab=
e96
        failing since 83 days (last pass: v4.9.243-16-gd8d67e375b0a, first =
fail: v4.9.243-25-ga01fe8e99a22) =

 =20
