Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6197A4186A7
	for <lists+stable@lfdr.de>; Sun, 26 Sep 2021 08:08:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229829AbhIZGKO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 26 Sep 2021 02:10:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229485AbhIZGKN (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 26 Sep 2021 02:10:13 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24AC9C061570
        for <stable@vger.kernel.org>; Sat, 25 Sep 2021 23:08:38 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id rm6-20020a17090b3ec600b0019ece2bdd20so1090453pjb.1
        for <stable@vger.kernel.org>; Sat, 25 Sep 2021 23:08:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=zOpXYr0VZRoUUU++ypD71rUY8VIEDRt6zuGnGlol4D0=;
        b=SX8rry8A1agR7v3t71IW/DewFLgmqhmPn/bvcXztjqrYtDASn1yDiy6mpHUmangFkt
         4HUAj8SjWlJODFMW+/cxVaLt1a+3hAWoDQT3X/wpGL9ALl8apCegNhbXpsFZQf3qxzR8
         E6LG8gntiL1v/IWwI+PSkLqe9pTUd3lQXbBiarw56/zapKohkR3JEgCvbV6MjwML3kvK
         JrAecC7SpE04jy77hrBFsYcr4qEmp+sa1BLzf7N9yyETcpEuKsFkKlqRiLy4wgrBQLdt
         xtYtjwjsTU/AjnL5hRodCeIRgX64dVjL4RDgq6d1Jc6zTWyAas82VEy/YbV8BlQWIh+N
         MVfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=zOpXYr0VZRoUUU++ypD71rUY8VIEDRt6zuGnGlol4D0=;
        b=K2Ytr+5sUkKLyma4f56Sjnt7Cq8Kt+obK+Sr32PjJCngFlpcrR2Ny/gh4CAciQ9/ci
         F6qrwjgrpCosUwKAvxBaDz5sb7ry97l2rgv0X+r4Q5QbEFFfieVwWKCM/3Dgxc2lJ3/Q
         bNhQ3DQvtcKH6ZpiqzWyGqbExFjzCLNRoPHU7ue9IAIc2xLISNuWqhwhpfHto7SBOsd8
         DGqXxvwRvdtOaPmWsYNt5KAGVsPpktPX51wOqC2HvI88iU3vHCGJPENdCR/CPI7earzc
         sMRTU3y+olggmrF8ByMQTP01gjdccbgxq+MD3G14DQzpEBhUa3518U8waYDj4TSiexzE
         jRWw==
X-Gm-Message-State: AOAM532zeARfNritZhuPZ49iZqKlFu4j8Rx174ibxucJ1YTWLP5H/a9l
        28Cl2vtVDJeaPUgS4YOlLrqoksgdY/pgGVHA
X-Google-Smtp-Source: ABdhPJxkikMJK36l8/FL1KO7qBOi9cvDkWlhPnIW0oa+TDDRyZ0G8WTzTcoe1G6BufxLNg+Hkc3qxQ==
X-Received: by 2002:a17:90a:c682:: with SMTP id n2mr6000441pjt.163.1632636517526;
        Sat, 25 Sep 2021 23:08:37 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id e24sm13074882pfn.8.2021.09.25.23.08.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 Sep 2021 23:08:37 -0700 (PDT)
Message-ID: <61500e65.1c69fb81.802c1.999d@mx.google.com>
Date:   Sat, 25 Sep 2021 23:08:37 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.283-25-g73e640213b94
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.9
Subject: stable-rc/queue/4.9 baseline: 41 runs,
 5 regressions (v4.9.283-25-g73e640213b94)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 41 runs, 5 regressions (v4.9.283-25-g73e64021=
3b94)

Regressions Summary
-------------------

platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.283-25-g73e640213b94/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.283-25-g73e640213b94
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      73e640213b94f0d61a86229670aeb3bb365fc009 =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/614fd8b4a15eaeca5e99a301

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.283-2=
5-g73e640213b94/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.283-2=
5-g73e640213b94/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/614fd8b4a15eaeca5e99a=
302
        failing since 316 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/614fd8baa15eaeca5e99a304

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.283-2=
5-g73e640213b94/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.283-2=
5-g73e640213b94/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/614fd8baa15eaeca5e99a=
305
        failing since 316 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/614fd8baa15eaeca5e99a307

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.283-2=
5-g73e640213b94/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.283-2=
5-g73e640213b94/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/614fd8baa15eaeca5e99a=
308
        failing since 316 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/614fd87e50fa98693499a2fa

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.283-2=
5-g73e640213b94/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.283-2=
5-g73e640213b94/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/614fd87e50fa98693499a=
2fb
        failing since 316 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/614fe7737a64781d6899a31c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.283-2=
5-g73e640213b94/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.283-2=
5-g73e640213b94/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/614fe7737a64781d6899a=
31d
        failing since 316 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =20
