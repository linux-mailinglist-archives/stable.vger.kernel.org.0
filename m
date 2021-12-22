Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57A7247D345
	for <lists+stable@lfdr.de>; Wed, 22 Dec 2021 14:57:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241027AbhLVN5N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Dec 2021 08:57:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240962AbhLVN5N (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Dec 2021 08:57:13 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9188AC061574
        for <stable@vger.kernel.org>; Wed, 22 Dec 2021 05:57:12 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id n15-20020a17090a160f00b001a75089daa3so5958777pja.1
        for <stable@vger.kernel.org>; Wed, 22 Dec 2021 05:57:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=mu06G/F3ek3CiGeSAKlup6w07IT4lsOKr62qfPAF0CA=;
        b=isFzKybaILdnUpIUmua6PqeoHxy0SB7ybNzG0tz8YEl1kTSSniU8xB4dAUWRPs7U69
         /gtilGQleQ9p5MiEj/kxNue6UWv/QP6yPXC/XGWje0vGBnzibKTL4X0G47nmMHHC2tg/
         y3AOP4VC9V/Q7hHzmbZ3M8yCyMEytfWJb4CHvc62xdPBfv1SuVU9QcA9mGSgcd+MJWbd
         iwaav/upE5axRuViSfq+veEywcWM4EpxY6l6c4XqyGhX3XypemVK5C6wk9FU3vZjn8iY
         2gI/gN4c6FZga1P5FobVnv787oUQvKCONi+IG5zKQM0tW99gyyb4VJB/XoBzf8uGtKjG
         23zQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=mu06G/F3ek3CiGeSAKlup6w07IT4lsOKr62qfPAF0CA=;
        b=MNEd3bRAOplZ+IJHJWVg53xPBwzRCIS4a4kRc6gUrb578X8P5ciafyvbedhb5S1MBr
         B7VrHTxi5HEuqBeirvmC/18cdfMG9m0KZDNZ3Alx0zvLQ+09X/qK/kvRsFOdv92vurKM
         r2T/9wo14D48AxVhgXS6trwMoWJNfOMLZZ07C5TmDhIdLj2iHg64NpbmsCcpBcMZXYlF
         uQ0CO6bESK1UIg7TkTmKWov3zfWuxVUmIzcSFvBrIGpkxXXtx7/jxz1MaPBa5MahNmkD
         d5EJ9brAPrWbQvn5rTJOFeaAd8MB0J8oiPmxDWLaVKKFSnxsrEQeytBwTAigp/Q1GyHM
         /tiA==
X-Gm-Message-State: AOAM531WMFPfVAJiWosZGpltCUGB4opLU1NdYWTupfFQX1TDLG0isrOb
        JpErehV1sxjU6CVoYLJG63fKjV5Ub9C20+aB
X-Google-Smtp-Source: ABdhPJzJ73WszI/BZQL27E2Wy/lousvZ5UT5WLWjHe1CLE4JuV26y7pxFsWrgvx2veKnooYhgCQ4mg==
X-Received: by 2002:a17:902:bf45:b0:148:a2f7:9d6c with SMTP id u5-20020a170902bf4500b00148a2f79d6cmr3026641pls.139.1640181431999;
        Wed, 22 Dec 2021 05:57:11 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id c7sm6027805pjs.17.2021.12.22.05.57.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Dec 2021 05:57:11 -0800 (PST)
Message-ID: <61c32eb7.1c69fb81.5385d.096f@mx.google.com>
Date:   Wed, 22 Dec 2021 05:57:11 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.293-31-gc9c5e13dcdc2
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/4.9
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.9 baseline: 146 runs,
 2 regressions (v4.9.293-31-gc9c5e13dcdc2)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 146 runs, 2 regressions (v4.9.293-31-gc9c5e13=
dcdc2)

Regressions Summary
-------------------

platform                 | arch   | lab           | compiler | defconfig   =
        | regressions
-------------------------+--------+---------------+----------+-------------=
--------+------------
minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
nfig    | 1          =

panda                    | arm    | lab-collabora | gcc-10   | omap2plus_de=
fconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.293-31-gc9c5e13dcdc2/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.293-31-gc9c5e13dcdc2
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      c9c5e13dcdc2227c41ad5245f5091d19f71a53d0 =



Test Regressions
---------------- =



platform                 | arch   | lab           | compiler | defconfig   =
        | regressions
-------------------------+--------+---------------+----------+-------------=
--------+------------
minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
nfig    | 1          =


  Details:     https://kernelci.org/test/plan/id/61c2f9556aa4883eb7397195

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.293-3=
1-gc9c5e13dcdc2/x86_64/x86_64_defconfig/gcc-10/lab-collabora/baseline-minno=
wboard-turbot-E3826.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.293-3=
1-gc9c5e13dcdc2/x86_64/x86_64_defconfig/gcc-10/lab-collabora/baseline-minno=
wboard-turbot-E3826.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61c2f9556aa4883eb7397=
196
        failing since 1 day (last pass: v4.9.293-15-g3fbbbaf0d213, first fa=
il: v4.9.293-31-g9d50eae56b67) =

 =



platform                 | arch   | lab           | compiler | defconfig   =
        | regressions
-------------------------+--------+---------------+----------+-------------=
--------+------------
panda                    | arm    | lab-collabora | gcc-10   | omap2plus_de=
fconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/61c2fc3d5c27651c4a39713b

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.293-3=
1-gc9c5e13dcdc2/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.293-3=
1-gc9c5e13dcdc2/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61c2fc3d5c27651=
c4a39713e
        failing since 5 days (last pass: v4.9.293-7-gd89b8545a1fa, first fa=
il: v4.9.293-7-g534f383585ec)
        2 lines

    2021-12-22T10:21:31.169509  [   20.196319] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-12-22T10:21:31.212268  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/122
    2021-12-22T10:21:31.221123  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
230 [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
