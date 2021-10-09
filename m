Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 016EC427D35
	for <lists+stable@lfdr.de>; Sat,  9 Oct 2021 22:05:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229804AbhJIUH0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 9 Oct 2021 16:07:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230003AbhJIUH0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 9 Oct 2021 16:07:26 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDDB2C061570
        for <stable@vger.kernel.org>; Sat,  9 Oct 2021 13:05:28 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id i65so8163247pfe.12
        for <stable@vger.kernel.org>; Sat, 09 Oct 2021 13:05:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=6WAwUGTtb1M76EJ11ZQqCh9ebIu2eRmuxUKxr67UTZg=;
        b=1W4QEvmPt2D7al8YxMPFucBg/xt/1T1lQZbcR7TfymkXvd7wJ+hHICpZfiaTo/TVHK
         ImdMFB8koJDd04VXPwGb31UQgHkWEpB5/O/9f498xzvORRDTSqwH9s7tn+R+7AoWXOdw
         xGfeVkZFGmPgzLB9ICD9L0QZ1lAWnMjow5W6ZUxdWwtAXDinzt+8jgqLnGOgRFQVbW2+
         4OIgDk5tNpQGa3FfefWIUQRZdZuhvTpSYeaFoBHCXHxx8zvxUN8UkGefvMnmXLh2EaAH
         x2zg9LKIOxE+si5qsSTdfE/HXXV/IKeDAco+5doD6BWUO8a8VLeaxU8Qul9mfWKKcI9J
         DhkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=6WAwUGTtb1M76EJ11ZQqCh9ebIu2eRmuxUKxr67UTZg=;
        b=gen+I/2S7k4sXN8JUWb527PrJUI7HnXGFX7+fYEK3H0nrGSbsaXJVNEtMLlcfQ7FPC
         BHYyNc9OUpzxfvWUp/OF2j9JimIUic9e+Bhh+x90w3oYQek95hjsT2ntPhhbVEEMdLrq
         zSbKTIDzEbBHsAAlE/RqTXkEyfGgHnmnkti+mgmk4fQsbMQxBimKCXe8wpa+L8IZ4E2W
         uCT50jeJCFRAX/HMbiHQjK11fmSK0/SN5XfYw6b8A5cEk/rjXHQ0tQFx43VtRNKgStO3
         MBHZKprlUKQ3Puv9sduuZSEZ0qwWrqE0wH1bwuPU82rgqCqAGVSbpTbPGMEL7pMsCjXX
         9kbw==
X-Gm-Message-State: AOAM531W3dzVIF3XNBgHBV+ZA+UD8vbFqDeVjuPqCsBDBF8z1a/42rD8
        vJQJB1ZmVRo+hgPaZZyw0V5ccGkgUKFH5Gb7
X-Google-Smtp-Source: ABdhPJwcsNq2buHTFnQcY8JY/QC2L/6r+dNMvve45Z8askMv72REXnAn2XV2oWEvoxBXsV0AQ8K2aQ==
X-Received: by 2002:a63:4d20:: with SMTP id a32mr11081145pgb.247.1633809928045;
        Sat, 09 Oct 2021 13:05:28 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y203sm3052702pfc.0.2021.10.09.13.05.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 09 Oct 2021 13:05:27 -0700 (PDT)
Message-ID: <6161f607.1c69fb81.8266b.8a74@mx.google.com>
Date:   Sat, 09 Oct 2021 13:05:27 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.286-6-gbd0bea7e3e6a
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.9
Subject: stable-rc/queue/4.9 baseline: 102 runs,
 5 regressions (v4.9.286-6-gbd0bea7e3e6a)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 102 runs, 5 regressions (v4.9.286-6-gbd0bea7e=
3e6a)

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

qemu_i386-uefi       | i386 | lab-broonie   | gcc-8    | i386_defconfig    =
  | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.286-6-gbd0bea7e3e6a/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.286-6-gbd0bea7e3e6a
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      bd0bea7e3e6a60228ee96355c0cc0a4121a164ba =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6161b9152e948cdecd99a2db

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.286-6=
-gbd0bea7e3e6a/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.286-6=
-gbd0bea7e3e6a/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6161b9152e948cdecd99a=
2dc
        failing since 329 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6161b91d2e948cdecd99a2e7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.286-6=
-gbd0bea7e3e6a/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-=
versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.286-6=
-gbd0bea7e3e6a/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-=
versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6161b91d2e948cdecd99a=
2e8
        failing since 329 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6161b90025f615a60299a2e2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.286-6=
-gbd0bea7e3e6a/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-vers=
atilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.286-6=
-gbd0bea7e3e6a/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-vers=
atilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6161b90025f615a60299a=
2e3
        failing since 329 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6161b8b8682d543c7c99a2f7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.286-6=
-gbd0bea7e3e6a/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.286-6=
-gbd0bea7e3e6a/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6161b8b9682d543c7c99a=
2f8
        failing since 329 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_i386-uefi       | i386 | lab-broonie   | gcc-8    | i386_defconfig    =
  | 1          =


  Details:     https://kernelci.org/test/plan/id/6161b9facf24da75cb99a3f2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.286-6=
-gbd0bea7e3e6a/i386/i386_defconfig/gcc-8/lab-broonie/baseline-qemu_i386-uef=
i.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.286-6=
-gbd0bea7e3e6a/i386/i386_defconfig/gcc-8/lab-broonie/baseline-qemu_i386-uef=
i.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6161b9facf24da75cb99a=
3f3
        new failure (last pass: v4.9.285-8-gae5c7d8cd6c7) =

 =20
