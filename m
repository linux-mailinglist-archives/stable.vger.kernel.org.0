Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91BAE2A886E
	for <lists+stable@lfdr.de>; Thu,  5 Nov 2020 21:57:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731899AbgKEU5O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Nov 2020 15:57:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731060AbgKEU5O (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Nov 2020 15:57:14 -0500
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51518C0613CF
        for <stable@vger.kernel.org>; Thu,  5 Nov 2020 12:57:14 -0800 (PST)
Received: by mail-pg1-x532.google.com with SMTP id w4so2166771pgg.13
        for <stable@vger.kernel.org>; Thu, 05 Nov 2020 12:57:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=sQ6+lMuunqqse7hSFs9w0t7kSpSDzUMCZsazKqBFTnU=;
        b=e/J8sltYgso966p0cFgbA3EQFgS/meOGNZoqRXJMqZMutCJa7+m1SLr36kcMtzjt84
         GVLMCAVn5zjMEAU3pPmJEBb/BGHo8UVOYpM24KeQnxstYtapsdnXBu9Q//uFssgjBQNi
         aL3OT1AL4fFC8yDuRNLaw6e9J53T1IGE9NvpZBcVPjMnBLjORkJhBbswdrnCELwJsz0B
         XPFVGxr7//DZw0PQn7xb+WRAcnR15fGai6VSSYrXT4Xw4xKjiO5VsHFhT9dUK3FdTHSf
         TQPmCZY63F6Rqj/h8e5T7HfxPDdCtOArLK4e8RQ3KcnSctG5zhKuVmA6FOO305KMAbdZ
         05Gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=sQ6+lMuunqqse7hSFs9w0t7kSpSDzUMCZsazKqBFTnU=;
        b=N0XSuqjq9RPh320Rl+NRQHrqdJ69TmWdt2kTRPdYJOLAt7LibYQPn5e00RJbUj8N9S
         +pPIfo51fKye41T12HvzMSWQALFBDpTNrwrsJ2rfcHsF743rT1HFXH/R7HJtIIWYkWGB
         zpEiqlrjsVgyIcnq9Gk6r+hAnyAuCgsl+GOegdgzDMi+rkzYm9hQRIq4UrmCqClhxeSQ
         IlKsUsJnqlDw3NJ2Mvu1OI7zdb4OClgtZjE6a4xosRiKDqc3KLI+tJYX8NvdrltsmGDN
         uAUjNuCR+FdFbGcX5E0/+RRmDP5OcgKrakyT9WnwAuh+RubwrTA9C1ZLzblqgYNfp/Ht
         VSTA==
X-Gm-Message-State: AOAM531z1eYYaiYmt1f241T4J0R6i/L8PSze0hnccD4TMRnD0LxD5Ewd
        ANITm5TwiSvVDpW6PPiFcNLW8xDnsc/lMA==
X-Google-Smtp-Source: ABdhPJynClvGAeygT5aR8Z5/uCNymd3g+DREEWegV6k2d53o4gLQJkE5mnE0S7f/6KnvZ+EvcEVTdQ==
X-Received: by 2002:a17:90a:d518:: with SMTP id t24mr4074079pju.183.1604609833429;
        Thu, 05 Nov 2020 12:57:13 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id r6sm3616509pfh.166.2020.11.05.12.57.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Nov 2020 12:57:12 -0800 (PST)
Message-ID: <5fa46728.1c69fb81.948cd.6fdd@mx.google.com>
Date:   Thu, 05 Nov 2020 12:57:12 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Kernel: v5.4.75
Subject: stable/linux-5.4.y baseline: 217 runs, 4 regressions (v5.4.75)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.4.y baseline: 217 runs, 4 regressions (v5.4.75)

Regressions Summary
-------------------

platform              | arch | lab          | compiler | defconfig         =
  | regressions
----------------------+------+--------------+----------+-------------------=
--+------------
at91-sama5d4_xplained | arm  | lab-baylibre | gcc-8    | sama5_defconfig   =
  | 1          =

beagle-xm             | arm  | lab-baylibre | gcc-8    | omap2plus_defconfi=
g | 1          =

qemu_i386             | i386 | lab-baylibre | gcc-8    | i386_defconfig    =
  | 1          =

qemu_i386-uefi        | i386 | lab-baylibre | gcc-8    | i386_defconfig    =
  | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.4.y/kernel/=
v5.4.75/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.4.y
  Describe: v5.4.75
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      6e97ed6efa701db070da0054b055c085895aba86 =



Test Regressions
---------------- =



platform              | arch | lab          | compiler | defconfig         =
  | regressions
----------------------+------+--------------+----------+-------------------=
--+------------
at91-sama5d4_xplained | arm  | lab-baylibre | gcc-8    | sama5_defconfig   =
  | 1          =


  Details:     https://kernelci.org/test/plan/id/5fa4343cd9b2b4be6ddb8853

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sama5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.75/arm=
/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5d4_xplained.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.75/arm=
/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5d4_xplained.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fa4343cd9b2b4be6ddb8=
854
        failing since 140 days (last pass: v5.4.46, first fail: v5.4.47) =

 =



platform              | arch | lab          | compiler | defconfig         =
  | regressions
----------------------+------+--------------+----------+-------------------=
--+------------
beagle-xm             | arm  | lab-baylibre | gcc-8    | omap2plus_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/5fa43540574fabc631db8878

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.75/arm=
/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle-xm.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.75/arm=
/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fa43540574fabc631db8=
879
        new failure (last pass: v5.4.74) =

 =



platform              | arch | lab          | compiler | defconfig         =
  | regressions
----------------------+------+--------------+----------+-------------------=
--+------------
qemu_i386             | i386 | lab-baylibre | gcc-8    | i386_defconfig    =
  | 1          =


  Details:     https://kernelci.org/test/plan/id/5fa4320a780a89e028db886f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.75/i38=
6/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i386.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.75/i38=
6/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i386.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fa4320a780a89e028db8=
870
        new failure (last pass: v5.4.74) =

 =



platform              | arch | lab          | compiler | defconfig         =
  | regressions
----------------------+------+--------------+----------+-------------------=
--+------------
qemu_i386-uefi        | i386 | lab-baylibre | gcc-8    | i386_defconfig    =
  | 1          =


  Details:     https://kernelci.org/test/plan/id/5fa4320d780a89e028db887e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.75/i38=
6/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i386-uefi.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.75/i38=
6/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i386-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fa4320d780a89e028db8=
87f
        new failure (last pass: v5.4.74) =

 =20
