Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1A7B483B49
	for <lists+stable@lfdr.de>; Tue,  4 Jan 2022 05:28:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232719AbiADE2D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jan 2022 23:28:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231536AbiADE2C (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Jan 2022 23:28:02 -0500
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDADAC061761
        for <stable@vger.kernel.org>; Mon,  3 Jan 2022 20:28:02 -0800 (PST)
Received: by mail-pg1-x52a.google.com with SMTP id g2so31650164pgo.9
        for <stable@vger.kernel.org>; Mon, 03 Jan 2022 20:28:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=3KPDRi7yON8zg5jUTM74rV7QQ1pn66FkWZSq9mk/FBM=;
        b=eqmF05sCOlG7vVfNrgmCSEZCtA8t73XfkRZg26m+e+DkfGtlITebA3z6E2ShsM+arv
         aWQLl/UVv1aakVnaWugmcOLot0J9WdqwkoCcCLFYjk0tfQIXd1r4FrwcpjT5QfzbkhF2
         Std1LYClXa2nRjPLJaNOWk0flxOmsJMSAOblLA74V0eLcyiElgr//PbC6cDf5pKzkAMn
         Vb+3vdIgoQN/4rnMAwu3My5jk8wzXzlcC4WLSIDS2TJm8Am5W4vkMEyYsMVnZxgCLLOY
         FgsEFtE0V3TRjGtdn68TkpneP2EYPt0n3Q8Zl/VbmpDUCVH40/RMu6eROC1aSHT9DIqR
         wUgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=3KPDRi7yON8zg5jUTM74rV7QQ1pn66FkWZSq9mk/FBM=;
        b=5v/2G7jKYqtzF0FkGy3dXV11bB7LW+vCWuWLp0dpNN90Ufd0teVsje6zKBvvll+otm
         zjKpxlFTmfBi3YAIojmuU/aX2/e4oXqmJqVVmHov8kBFCcxo7I6wqzxLkgzy23KpJvk8
         TWE8OCkjywzr4yOuMwxn2NexCQl/59jjOjP+T0HWMDBBPtrqIiTYpZr9ahiS8r+aT0qK
         Yap96HCk5Nv0/M9pulLgNY/ShBOMMGl6GWV1qenTzJru+RoRUzhuH9kmKd7EvRcyrZi0
         h1SU/YhYhVopkQGEzjHnDk9NFdeVZ07fLS2yKeOCIWiCQ50g8vd0+uRSB0JnZnuwxu2q
         AvYQ==
X-Gm-Message-State: AOAM5302S1aaqwKzLH/pQFtxL8CXQ0xOVnvp0RRbpo6aDfqTKnmB+078
        AShiXT0zEq7fVkNBXSxorP+uHQRZF09LjfFF
X-Google-Smtp-Source: ABdhPJylQeR5dfv/qTgCbZOpokTpzFSjR4Kw7uCeXDb6TTm9EbieKxxhl9OUn62Ct7OQsnAm+xknpg==
X-Received: by 2002:a05:6a00:cd0:b0:4bb:45f7:e032 with SMTP id b16-20020a056a000cd000b004bb45f7e032mr49679692pfv.38.1641270482208;
        Mon, 03 Jan 2022 20:28:02 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y129sm5003625pfy.164.2022.01.03.20.28.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Jan 2022 20:28:01 -0800 (PST)
Message-ID: <61d3ccd1.1c69fb81.e0e3c.c9c4@mx.google.com>
Date:   Mon, 03 Jan 2022 20:28:01 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.4.297-11-gc31fae21c063
X-Kernelci-Branch: queue/4.4
Subject: stable-rc/queue/4.4 baseline: 97 runs,
 3 regressions (v4.4.297-11-gc31fae21c063)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 baseline: 97 runs, 3 regressions (v4.4.297-11-gc31fae21=
c063)

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.4/kern=
el/v4.4.297-11-gc31fae21c063/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.4
  Describe: v4.4.297-11-gc31fae21c063
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      c31fae21c063bf2eab7722b17f70c3c59b0634db =



Test Regressions
---------------- =



platform  | arch | lab           | compiler | defconfig           | regress=
ions
----------+------+---------------+----------+---------------------+--------=
----
beagle-xm | arm  | lab-baylibre  | gcc-10   | omap2plus_defconfig | 2      =
    =


  Details:     https://kernelci.org/test/plan/id/61d399538735112257ef6790

  Results:     3 PASS, 2 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.297-1=
1-gc31fae21c063/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagle=
-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.297-1=
1-gc31fae21c063/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagle=
-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.crit: https://kernelci.org/test/case/id/61d3995387351122=
57ef6793
        new failure (last pass: v4.4.297-3-gc457fc40e7af)
        1 lines

    2022-01-04T00:48:01.999277  / #
    2022-01-04T00:48:02.102208  #
    2022-01-04T00:48:02.102689   =

    2022-01-04T00:48:02.203946  / # #export SHELL=3D/bin/sh
    2022-01-04T00:48:02.204236  =

    2022-01-04T00:48:02.305337  / # export SHELL=3D/bin/sh. /lava-1344262/e=
nvironment
    2022-01-04T00:48:02.305638  =

    2022-01-04T00:48:02.406792  / # . /lava-1344262/environment/lava-134426=
2/bin/lava-test-runner /lava-1344262/0
    2022-01-04T00:48:02.407739  =

    2022-01-04T00:48:02.408768  / # /lava-1344262/bin/lava-test-runner /lav=
a-1344262/0 =

    ... (9 line(s) more)  =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61d399538735112=
257ef6795
        new failure (last pass: v4.4.297-3-gc457fc40e7af)
        29 lines

    2022-01-04T00:48:02.922400  kern  :emerg : Internal error: Oops - BUG: =
0 [#1] SMP ARM
    2022-01-04T00:48:02.928293  kern  :emerg : Process udevd (pid: 108, sta=
ck limit =3D 0xcb922218)
    2022-01-04T00:48:02.933212  kern  :emerg : Stack: (0xcb923cf8 to 0xcb92=
4000)
    2022-01-04T00:48:02.941576  kern  :emerg : 3ce0:                       =
                                bf02bdc4 60000013   =

 =



platform  | arch | lab           | compiler | defconfig           | regress=
ions
----------+------+---------------+----------+---------------------+--------=
----
panda     | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1      =
    =


  Details:     https://kernelci.org/test/plan/id/61d397ce49663c7aa2ef675d

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.297-1=
1-gc31fae21c063/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.297-1=
1-gc31fae21c063/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61d397ce49663c7=
aa2ef6760
        failing since 14 days (last pass: v4.4.295-12-gd8298cd08f0d, first =
fail: v4.4.295-23-gcec9bc2aa5d3)
        2 lines

    2022-01-04T00:41:31.419014  [   19.450134] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2022-01-04T00:41:31.462642  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/115
    2022-01-04T00:41:31.471578  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
25c [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =20
