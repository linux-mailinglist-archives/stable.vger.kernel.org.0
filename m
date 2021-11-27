Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20FFD4600F0
	for <lists+stable@lfdr.de>; Sat, 27 Nov 2021 19:35:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355899AbhK0SiN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 27 Nov 2021 13:38:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243805AbhK0SgM (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 27 Nov 2021 13:36:12 -0500
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48E3CC061574
        for <stable@vger.kernel.org>; Sat, 27 Nov 2021 10:32:58 -0800 (PST)
Received: by mail-pl1-x629.google.com with SMTP id q17so8862768plr.11
        for <stable@vger.kernel.org>; Sat, 27 Nov 2021 10:32:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=WZTN+tlAaEkjTfSyqePfTgMj8uAQNzaRDSB5aB0Cskg=;
        b=A2lIZH3shmPeu5reOFEOBK0h3KYq5xaKgw8r0hY3TGLPWUpxcJ/or3cKjteEKTbORT
         CwcPUhZwGL8sE0FPHCdjYOChVeiFykd0uEFQS74ZOVEHq2ySX2jSyFgbcmrljdQrzCxF
         Xadts5uhPmSrAKu/C915/jN1cukL1iaAbTKP2EUGSAWFcy5McQA+Jzi4YqVEGWghqjGe
         R4z9uJAQdBjbKiah0cI/UuajREVHUAvOrGr5s3p4yOlArqxugAR9YvVua3efV7fI6Kf0
         Nx5OOhJkSRHSNTz9H9cwjwiAZpTNXfjpK3dNu/cAiW4EYjJzK4FNkB1TJ+/aTC/97MbN
         KzxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=WZTN+tlAaEkjTfSyqePfTgMj8uAQNzaRDSB5aB0Cskg=;
        b=l8jB7qUJ8mrpOyI411VXlyyVfXPr5EgxC5qKLrXMYGtzhezUNlZgDZrCUOnrcJcbWr
         dK/GmslWcUh9daApxlYWj+KnKvxx4Twd60kO7NtUCJEFQ3KB1A2RFiQ4wB3ho+qOSS2H
         5ZSDsSbQ9ZCDDcQ7a82b8RFW6T5gnTefiPxeZxGYKJXD3Efu0T6KFmfawizrU7ESaHcH
         L1OfvPzqWYeWLdnP2LvHRohdaX2a1/vCOc3DPqIs/UX9hdo73QTIMwzq3uixQGOHkXn+
         XdT0Ztoy4XtnVcYao4ynlCa+p44C2S5dHj4aPwcty0AJ6PRnvLsHdR/58zaShEXJj4T+
         PRqQ==
X-Gm-Message-State: AOAM530vq/UfSDYVDP82KXwLzcsUb9be9qF5saBW89KV9rwzLC7jADNa
        kC9w3KAxQbfNPakjhYzQeVoT7S6mUGonA4lA
X-Google-Smtp-Source: ABdhPJy14/Yc04q+AzXeqVU5rNXC8WBNe23wM7Ynh9B76hHLp060oa1EazTF1cuLqkZtKtcsPAaJXA==
X-Received: by 2002:a17:90a:e012:: with SMTP id u18mr25369753pjy.103.1638037977656;
        Sat, 27 Nov 2021 10:32:57 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id i193sm11058691pfe.87.2021.11.27.10.32.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 27 Nov 2021 10:32:57 -0800 (PST)
Message-ID: <61a279d9.1c69fb81.d81b9.e8aa@mx.google.com>
Date:   Sat, 27 Nov 2021 10:32:57 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.9
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.9.291-9-g3fa2182ee75a6
Subject: stable-rc/queue/4.9 baseline: 121 runs,
 2 regressions (v4.9.291-9-g3fa2182ee75a6)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 121 runs, 2 regressions (v4.9.291-9-g3fa2182e=
e75a6)

Regressions Summary
-------------------

platform        | arch  | lab           | compiler | defconfig           | =
regressions
----------------+-------+---------------+----------+---------------------+-=
-----------
meson-gxbb-p200 | arm64 | lab-baylibre  | gcc-10   | defconfig           | =
1          =

panda           | arm   | lab-collabora | gcc-10   | omap2plus_defconfig | =
1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.291-9-g3fa2182ee75a6/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.291-9-g3fa2182ee75a6
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      3fa2182ee75a6ebc9cf787ff8bae813e4bd3bd32 =



Test Regressions
---------------- =



platform        | arch  | lab           | compiler | defconfig           | =
regressions
----------------+-------+---------------+----------+---------------------+-=
-----------
meson-gxbb-p200 | arm64 | lab-baylibre  | gcc-10   | defconfig           | =
1          =


  Details:     https://kernelci.org/test/plan/id/61a23dc020ef88beef18f6dd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.291-9=
-g3fa2182ee75a6/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxbb-p20=
0.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.291-9=
-g3fa2182ee75a6/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxbb-p20=
0.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61a23dc020ef88beef18f=
6de
        new failure (last pass: v4.9.290-204-gda1217dd458b) =

 =



platform        | arch  | lab           | compiler | defconfig           | =
regressions
----------------+-------+---------------+----------+---------------------+-=
-----------
panda           | arm   | lab-collabora | gcc-10   | omap2plus_defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/61a23c328816720e9218f6e9

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.291-9=
-g3fa2182ee75a6/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.291-9=
-g3fa2182ee75a6/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61a23c328816720=
e9218f6ef
        failing since 2 days (last pass: v4.9.290-204-g18a1d655aad4b, first=
 fail: v4.9.290-206-ga3cd15a38615)
        2 lines

    2021-11-27T14:09:34.953516  [   20.155822] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-11-27T14:09:34.992311  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/124
    2021-11-27T14:09:35.001217  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
230 [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0
    2021-11-27T14:09:35.014233  [   20.216705] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =20
