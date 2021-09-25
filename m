Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2456418104
	for <lists+stable@lfdr.de>; Sat, 25 Sep 2021 12:28:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244320AbhIYK3s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 25 Sep 2021 06:29:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234922AbhIYK3r (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 25 Sep 2021 06:29:47 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45E86C061570
        for <stable@vger.kernel.org>; Sat, 25 Sep 2021 03:28:13 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id t4so8325117plo.0
        for <stable@vger.kernel.org>; Sat, 25 Sep 2021 03:28:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=g18OofYbzTzIglsRhKX/jg8oNYUWaj97mUztT8j7bwA=;
        b=V+rFj2eK4xO9LC1VVhdeoevu0dODlmJr1qV1NW4H/bGJG468GX3Ua+AfP9YWxpK7YS
         cwWv0oefZ2ZizRS5SbyQ03sRFwWQP3rcYrLDqAasO5a8KnpN47rLDF8cui4D5gF4z1qd
         y1gFAKZlkTnpaxIIrE6uCXiXpunWN0L+/r91Sjojk7xfaMwL9oH2wifThu4UySf6dGwY
         Qt+Nqpub1KcXoBFftHW8jgSz/8U97k4MpW//IagzicYAl/9tK3PvfjbLFQFLwPsbKkA4
         97kfWUko2++2vOnZCgxKYXvODsweKOJ6dEMApjrWP8Vrln6M/MCfx32T42n/RmK1daV1
         dWRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=g18OofYbzTzIglsRhKX/jg8oNYUWaj97mUztT8j7bwA=;
        b=3fK4MbQeFq64+d4pyRgNkl2FLvkQvSTwgeohhnG2O9IeLJG0ex5JrtoFMFLJIbq838
         911WWFaDewUGJy79LcGN9zkNUZ2GSVglUixsu1Ofpv/bJKV3GairpDHGjK/btxFJzf8G
         vAuE5EGxX3qBeCmevt2XgPOCgl4hIL+Q3++8nstmXQ+Rh0IuHfu5dmoefEIvIfiIs5zC
         YMHlA5lQBKc3bOb4AuMKwkeNMl0E7uMGHGB5L8pg81lQHmy1FoimreGJpm5dzVX3fCoZ
         OT/q4N9GwF2BvbI7xmkVm+IHOKpjFjHC1ZARYVX0UgYLzia0Pd1iJ3pvArMxKANtKoN8
         eOmA==
X-Gm-Message-State: AOAM5300tKCarSeno0HOFbHpBjt6P502704xXIaRVOVxKLHQFrTASWCQ
        6cc0BujBO8COkcPld8cHCgqvQAYVYgbYTklF
X-Google-Smtp-Source: ABdhPJwj+H7EUglUVE/7PB9317nv01YWrtVS9LHUhtWRtBkah9piPZMQ3hkQwIZCA4B1IPa9BfaAMQ==
X-Received: by 2002:a17:902:d70b:b0:13d:f465:9ef1 with SMTP id w11-20020a170902d70b00b0013df4659ef1mr5118447ply.44.1632565692558;
        Sat, 25 Sep 2021 03:28:12 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id s9sm11267162pfw.143.2021.09.25.03.28.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 Sep 2021 03:28:12 -0700 (PDT)
Message-ID: <614ef9bc.1c69fb81.a11a.3e20@mx.google.com>
Date:   Sat, 25 Sep 2021 03:28:12 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.4.284-23-g9f9187268629
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.4
Subject: stable-rc/queue/4.4 baseline: 48 runs,
 3 regressions (v4.4.284-23-g9f9187268629)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 baseline: 48 runs, 3 regressions (v4.4.284-23-g9f918726=
8629)

Regressions Summary
-------------------

platform  | arch | lab           | compiler | defconfig           | regress=
ions
----------+------+---------------+----------+---------------------+--------=
----
beagle-xm | arm  | lab-baylibre  | gcc-8    | omap2plus_defconfig | 2      =
    =

panda     | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 1      =
    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.4/kern=
el/v4.4.284-23-g9f9187268629/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.4
  Describe: v4.4.284-23-g9f9187268629
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      9f9187268629a14ea6b50d76e9321bb1f4941d2e =



Test Regressions
---------------- =



platform  | arch | lab           | compiler | defconfig           | regress=
ions
----------+------+---------------+----------+---------------------+--------=
----
beagle-xm | arm  | lab-baylibre  | gcc-8    | omap2plus_defconfig | 2      =
    =


  Details:     https://kernelci.org/test/plan/id/614ec73ce939b17e8f99a2e6

  Results:     3 PASS, 2 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.284-2=
3-g9f9187268629/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle-=
xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.284-2=
3-g9f9187268629/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle-=
xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.crit: https://kernelci.org/test/case/id/614ec73ce939b17e=
8f99a2ec
        new failure (last pass: v4.4.284-9-g002a7b8e43b1)
        1 lines

    2021-09-25T06:52:25.595136  / =

    2021-09-25T06:52:25.699134  # #
    2021-09-25T06:52:25.699741  =

    2021-09-25T06:52:25.801079  / # #export SHELL=3D/bin/sh
    2021-09-25T06:52:25.801613  =

    2021-09-25T06:52:25.903068  / # export SHELL=3D/bin/sh. /lava-885500/en=
vironment
    2021-09-25T06:52:25.903529  =

    2021-09-25T06:52:26.004796  / # . /lava-885500/environment/lava-885500/=
bin/lava-test-runner /lava-885500/0
    2021-09-25T06:52:26.006032  =

    2021-09-25T06:52:26.006899  / # /lava-885500/bin/lava-test-runner /lava=
-885500/0 =

    ... (8 line(s) more)  =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/614ec73ce939b17=
e8f99a2ee
        new failure (last pass: v4.4.284-9-g002a7b8e43b1)
        28 lines

    2021-09-25T06:52:26.465267  [   49.486816] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-09-25T06:52:26.528666  kern  :emerg : Internal error: Oops - BUG: =
0 [#1] SMP ARM
    2021-09-25T06:52:26.534597  kern  :emerg : Process udevd (pid: 108, sta=
ck limit =3D 0xcb948218)
    2021-09-25T06:52:26.538883  kern  :emerg : Stack: (0xcb949d10 to 0xcb94=
a000)
    2021-09-25T06:52:26.547070  kern  :emerg : 9d00:                       =
              bf02b83c bf010b84 cbaf6010 bf02b8c8   =

 =



platform  | arch | lab           | compiler | defconfig           | regress=
ions
----------+------+---------------+----------+---------------------+--------=
----
panda     | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 1      =
    =


  Details:     https://kernelci.org/test/plan/id/614ebc553eee1bc59b99a301

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.284-2=
3-g9f9187268629/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.284-2=
3-g9f9187268629/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/614ebc553eee1bc=
59b99a307
        new failure (last pass: v4.4.284-9-g002a7b8e43b1)
        2 lines

    2021-09-25T06:05:54.833890  [   19.735961] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-09-25T06:05:54.878632  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/114
    2021-09-25T06:05:54.887131  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
26c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
