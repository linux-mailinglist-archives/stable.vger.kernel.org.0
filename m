Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0731446D6F1
	for <lists+stable@lfdr.de>; Wed,  8 Dec 2021 16:25:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233560AbhLHP3A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Dec 2021 10:29:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbhLHP27 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Dec 2021 10:28:59 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E4D3C061746
        for <stable@vger.kernel.org>; Wed,  8 Dec 2021 07:25:27 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id w33-20020a17090a6ba400b001a722a06212so4248279pjj.0
        for <stable@vger.kernel.org>; Wed, 08 Dec 2021 07:25:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=2adysnTQAnFJVMPvzmSrwtU/zLThJnby329HGLDBhcs=;
        b=ntu1mr2shA/gnV6JmQNRyqZ/7IEF7+YexE9k0ulm+VKTfXHI9rHY8CZi/9WkB7ofpT
         SSJUsP6JbaoxXhjeQ41CGxtw5Rm9s4M6I1eqVcXdtqXVeNvbQgr1rF9X7KAFAXgQ8QGM
         oIE+WeUOPGvsdjZ5LivgoM6HsB2kZZJcVex9W1f7zBbS0oUt7ZWOmfp+JjsA/uJF+ndU
         2zYp1mViZmSUoL4kC6vuBAlYeiLoNPkNVg7QDkKrxbUK9fYFZp9rNJBNuNmsxbnLjD3l
         iPzPhwtrribJpIhZ8YMjr642G+PKCFWT7O7dMQpH74brdooSu00nwhJ5hSB6YlS6evV9
         lWhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=2adysnTQAnFJVMPvzmSrwtU/zLThJnby329HGLDBhcs=;
        b=O3TEcmRnDt/N2eS1hCDKZqjhKLwdVoo+FuLq5ntq7m1Z4+r+6e/cO+ou/iIG3a2r7e
         bYEPzbZTY+5/Sa5NRq/5aFj8ihA+YWzkhYpRT2kMA93rlmRq1KJRLYqweM6Z+2kOMaOA
         eiVZ1Q+iwjkAUXhCXH6CWBd6YioFFaLVhmdpZcn8gfm3YVieJRlLH2uCq2jxcF6QjMle
         6xZ9agRNGCI3C9jS8R4vCL5sLuWPD1U6DuUHbBwxYPeA+IHJ51r97g+obnVTK3Nr0Vgm
         N/mVmZNbAV8LnJP1nF5bD2Cm+9NfdzZcQ53ZPsUygE8Kxz5YXNGngjbajr3e2Am487lN
         wYGw==
X-Gm-Message-State: AOAM531BSCzV6tTgrqaZYWA0NeLkYAosDtG3YbcOK3XZtw9s7Npv1bd4
        cyGVz9+1nBxHisZP22NKKY5CPMGvpw4AteUM
X-Google-Smtp-Source: ABdhPJyCf2FWQtHtNiP6bxu+v3q2imudZ3vwWko/Znph6MpoYtS4kyuk+g4XshCXd0qBxYzDZijlyA==
X-Received: by 2002:a17:90a:c403:: with SMTP id i3mr8286592pjt.203.1638977126790;
        Wed, 08 Dec 2021 07:25:26 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id p17sm4299166pfh.86.2021.12.08.07.25.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Dec 2021 07:25:26 -0800 (PST)
Message-ID: <61b0ce66.1c69fb81.6d4eb.ba09@mx.google.com>
Date:   Wed, 08 Dec 2021 07:25:26 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Tree: stable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.4.294
Subject: stable/linux-4.4.y baseline: 133 runs, 3 regressions (v4.4.294)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.4.y baseline: 133 runs, 3 regressions (v4.4.294)

Regressions Summary
-------------------

platform  | arch | lab           | compiler | defconfig           | regress=
ions
----------+------+---------------+----------+---------------------+--------=
----
beagle-xm | arm  | lab-baylibre  | gcc-10   | omap2plus_defconfig | 2      =
    =

panda     | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1      =
    =


  Details:  https://kernelci.org/test/job/stable/branch/linux-4.4.y/kernel/=
v4.4.294/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-4.4.y
  Describe: v4.4.294
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      90b74a039f807b3ff911d886afe2645c4522542d =



Test Regressions
---------------- =



platform  | arch | lab           | compiler | defconfig           | regress=
ions
----------+------+---------------+----------+---------------------+--------=
----
beagle-xm | arm  | lab-baylibre  | gcc-10   | omap2plus_defconfig | 2      =
    =


  Details:     https://kernelci.org/test/plan/id/61b09daf3e487f4f5f1a949f

  Results:     3 PASS, 2 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.4.y/v4.4.294/ar=
m/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagle-xm.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.4.y/v4.4.294/ar=
m/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagle-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.crit: https://kernelci.org/test/case/id/61b09daf3e487f4f=
5f1a94a2
        new failure (last pass: v4.4.293)
        1 lines

    2021-12-08T11:57:16.846850  / # =

    2021-12-08T11:57:16.847579  #
    2021-12-08T11:57:16.950863  / # #
    2021-12-08T11:57:16.951381  =

    2021-12-08T11:57:17.052564  / # #export SHELL=3D/bin/sh
    2021-12-08T11:57:17.053006  =

    2021-12-08T11:57:17.154151  / # export SHELL=3D/bin/sh. /lava-1209009/e=
nvironment
    2021-12-08T11:57:17.154646  =

    2021-12-08T11:57:17.255754  / # . /lava-1209009/environment/lava-120900=
9/bin/lava-test-runner /lava-1209009/0
    2021-12-08T11:57:17.256870   =

    ... (10 line(s) more)  =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61b09daf3e487f4=
f5f1a94a4
        new failure (last pass: v4.4.293)
        29 lines

    2021-12-08T11:57:17.720049  [   49.380767] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-12-08T11:57:17.772133  kern  :emerg : Internal error: Oops - BUG: =
0 [#1] SMP ARM
    2021-12-08T11:57:17.778002  kern  :emerg : Process udevd (pid: 105, sta=
ck limit =3D 0xcb8f0218)
    2021-12-08T11:57:17.782427  kern  :emerg : Stack: (0xcb8f1cf8 to 0xcb8f=
2000)
    2021-12-08T11:57:17.790500  kern  :emerg : 1ce0:                       =
                                bf02bdc4 60000013
    2021-12-08T11:57:17.803512  kern  :emerg : 1d00: bf02bdc8 c06a38e4 0000=
0001 00[   49.460906] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Demerg RESULT=3Df=
ail UNITS=3Dlines MEASUREMENT=3D29>   =

 =



platform  | arch | lab           | compiler | defconfig           | regress=
ions
----------+------+---------------+----------+---------------------+--------=
----
panda     | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1      =
    =


  Details:     https://kernelci.org/test/plan/id/61b09d993e487f4f5f1a9483

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.4.y/v4.4.294/ar=
m/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.4.y/v4.4.294/ar=
m/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61b09d993e487f4=
f5f1a9486
        failing since 11 days (last pass: v4.4.292, first fail: v4.4.293)
        2 lines

    2021-12-08T11:56:53.873538  [   18.997406] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-12-08T11:56:53.921225  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/117
    2021-12-08T11:56:53.930974  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
25c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
