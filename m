Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09FEB48E16E
	for <lists+stable@lfdr.de>; Fri, 14 Jan 2022 01:20:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238364AbiANAUQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jan 2022 19:20:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232240AbiANAUP (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Jan 2022 19:20:15 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3F6EC061574
        for <stable@vger.kernel.org>; Thu, 13 Jan 2022 16:20:15 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id l16-20020a17090a409000b001b2e9628c9cso12597015pjg.4
        for <stable@vger.kernel.org>; Thu, 13 Jan 2022 16:20:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=99KYTpGrscNjobCZbIvOGhB+DdeJCwr/1Czl8yAELKU=;
        b=qoDkt0un+XbT5DfIdy0fQZnz4hzDHpPsRxPxr30/h8h8km8eWOMwb8R5Khs/Dva42o
         OsMMRtUemXUmjA+DylDS6Vmp4Y0quCE62Fn484kRAIkeqwRdzhv1MUCiFCT8ax3vV3Tl
         pLIxsGqNQn/7jJoizH/EVANxtuQZOvR0/cYbfMy+wF/fCYfqD0Fl0uD2i+j+bnCKoPvI
         msdw7B1q2TKXZ3kq4BPUyajFnWFu2foPDIAqxxfwBQ/JSe+rZndYW+QFmr1NTEtA3fIm
         y0l5eUSvRC0TEtf5LujXXpVB1rtZUhryOkEEZE3K3O+p5qY/Q4Z5QNMp5nbn9iGmfBZu
         c6tA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=99KYTpGrscNjobCZbIvOGhB+DdeJCwr/1Czl8yAELKU=;
        b=URUIuKMP+FYuZKOhlYELKAtU08TVG2ycS3/G/boI1DkRZVCoSmAdl7GzvkMbN2fkM6
         h2O6vg86SIrcXPRXo4kApRago7BGf9zH1YH+Ehv2N+RxotBkWCsFRJ7hdQX0AQobr5jv
         YL7Z+8lDVdudJEFeZH9NiE8cz19XmjMhK68fMeC5utWZlPMmufjQClp/ZUhMHvvOaotB
         LgSUcEJL+AHBTCMRshLzPa6se5HdDOV/ckMvmeTG9VQZB+grxeDgQHcHS2FoG7wOSYQP
         yq3lbf1/ZFB1ADd6GZalO/zKE5KBTMc8JU7EydFluaDva0qUegR38nEp5FcRAdEAuPwv
         bjdw==
X-Gm-Message-State: AOAM531fEqIHYr3c7FK1RAyAhQNo757rcc6fDWPTsCW0Yzn/gn7pMHI4
        c+5xMGIISbZ2VEF3/LUW+NxOMLXwDChjaZr6Mkc=
X-Google-Smtp-Source: ABdhPJywyDqJXMzFt9lMVg6eqi5jn25JMkKTsqKhv+jyPlaeTquvqWHFfcRU7o7S+9CbqGnFhPGWig==
X-Received: by 2002:a17:90b:4c0d:: with SMTP id na13mr11508683pjb.92.1642119614802;
        Thu, 13 Jan 2022 16:20:14 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id h13sm3168185pgq.63.2022.01.13.16.20.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Jan 2022 16:20:14 -0800 (PST)
Message-ID: <61e0c1be.1c69fb81.5497d.93aa@mx.google.com>
Date:   Thu, 13 Jan 2022 16:20:14 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.4.299-6-g9a2aedb7dcf3
X-Kernelci-Branch: queue/4.4
Subject: stable-rc/queue/4.4 baseline: 102 runs,
 2 regressions (v4.4.299-6-g9a2aedb7dcf3)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 baseline: 102 runs, 2 regressions (v4.4.299-6-g9a2aedb7=
dcf3)

Regressions Summary
-------------------

platform         | arch   | lab           | compiler | defconfig           =
         | regressions
-----------------+--------+---------------+----------+---------------------=
---------+------------
panda            | arm    | lab-collabora | gcc-10   | omap2plus_defconfig =
         | 1          =

qemu_x86_64-uefi | x86_64 | lab-collabora | gcc-10   | x86_64_defcon...6-ch=
romebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.4/kern=
el/v4.4.299-6-g9a2aedb7dcf3/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.4
  Describe: v4.4.299-6-g9a2aedb7dcf3
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      9a2aedb7dcf3df12df30ebbcc1b0015019b03ad0 =



Test Regressions
---------------- =



platform         | arch   | lab           | compiler | defconfig           =
         | regressions
-----------------+--------+---------------+----------+---------------------=
---------+------------
panda            | arm    | lab-collabora | gcc-10   | omap2plus_defconfig =
         | 1          =


  Details:     https://kernelci.org/test/plan/id/61e08d4451a9d0d5bdef6745

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.299-6=
-g9a2aedb7dcf3/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.299-6=
-g9a2aedb7dcf3/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61e08d4451a9d0d=
5bdef674a
        failing since 23 days (last pass: v4.4.295-12-gd8298cd08f0d, first =
fail: v4.4.295-23-gcec9bc2aa5d3)
        2 lines

    2022-01-13T20:36:00.152484  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/110
    2022-01-13T20:36:00.161208  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
25c [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1
    2022-01-13T20:36:00.181691  [   18.919250] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =



platform         | arch   | lab           | compiler | defconfig           =
         | regressions
-----------------+--------+---------------+----------+---------------------=
---------+------------
qemu_x86_64-uefi | x86_64 | lab-collabora | gcc-10   | x86_64_defcon...6-ch=
romebook | 1          =


  Details:     https://kernelci.org/test/plan/id/61e08bab5cb41575d3ef6776

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.299-6=
-g9a2aedb7dcf3/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/=
baseline-qemu_x86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.299-6=
-g9a2aedb7dcf3/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/=
baseline-qemu_x86_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61e08bab5cb41575d3ef6=
777
        new failure (last pass: v4.4.299-3-gc3f2df517d8f) =

 =20
