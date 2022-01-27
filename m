Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D98749E451
	for <lists+stable@lfdr.de>; Thu, 27 Jan 2022 15:12:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242262AbiA0OMr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Jan 2022 09:12:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242227AbiA0OMr (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Jan 2022 09:12:47 -0500
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67EDAC061714
        for <stable@vger.kernel.org>; Thu, 27 Jan 2022 06:12:47 -0800 (PST)
Received: by mail-pg1-x531.google.com with SMTP id p125so2379165pga.2
        for <stable@vger.kernel.org>; Thu, 27 Jan 2022 06:12:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=jQEsIeiZMEoIXOr+SJkCIrb/RcBdPsPpbFBV63utL0E=;
        b=1cnRMUlH+HPCq/iC6F/4jBK7R95ng+3IDGp6tzQsrtCcguUGvll88vDgsA20z+NhOD
         Rol+niyMML8oUTX2ubxZP6w0kEJs3P5U1lmbRl4ucQQzZD8DjyqTZB3F8P3Bu7fZ4Ihh
         jI14T9C3NZaDbKhZOCPgmfDOmsIzlwenGP03W/7Thd8B0NJukaZQsInXOSVu3sXcrGyj
         xx6exvtjsJZsVL38T2oUOAIA/7jnvKNgOxP+ucbeLnFbrm0YSwY3rctQnspxDT0w76Nz
         h1bpWvTAzlN/+iWfZx8VTrmCXRp5RnT6AdcgnNIzx2LWUf4Szm6AjBYc+IMT7VKko1F9
         e7aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=jQEsIeiZMEoIXOr+SJkCIrb/RcBdPsPpbFBV63utL0E=;
        b=1hYiQlCbOK85pQ/JB8s3rVVfVDgpb0hsE9PgTOZin0BosffzTBIUVnwaD/zQ96ph5l
         j/k/XY6vvCFyIAOMtYQ0hQNMPiZxi+pcaLdzL+6orXfo9eBNySxeC4aJpTEx/Y0vXoaU
         nko4XXSVb9aJyx0o8mnDvWkZJFWtGqSDq3rCzkpj2NyBhJjwCg4tRdJbUVpvoBosGFIM
         d5ZSY4E9AqE2qkn6I22ByTCfcAI/x6fRJUAPL/UJ+cjyfCZVx7ilXVlYaf2pqfA2xGlr
         o7ClnHZiOcQIM2lIy/oJMQD28H3/VyGpaTCB8J1/4yjo32kkahIXc1t2n66vCj4xDuXG
         5iBw==
X-Gm-Message-State: AOAM531Aw3wwjsUs607ftzyw29d0AP/NYQk/dcR5t4LMfzhx1jYfNSMw
        v/x8/BpShOgt+nSw7AHOBqM7jKV1Jih8mVIymDg=
X-Google-Smtp-Source: ABdhPJxQ1d4UcOcOIOGGTXmz7Md7YNkVncJfEFwMZqIVVZoV6wGZ1qVl/RqMos2EOkTNXeGJoflMqA==
X-Received: by 2002:a05:6a00:1d94:: with SMTP id z20mr3097623pfw.40.1643292766746;
        Thu, 27 Jan 2022 06:12:46 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id z25sm5758826pfg.129.2022.01.27.06.12.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Jan 2022 06:12:46 -0800 (PST)
Message-ID: <61f2a85e.1c69fb81.9c36.f3eb@mx.google.com>
Date:   Thu, 27 Jan 2022 06:12:46 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.4.300
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-4.4.y
Subject: stable/linux-4.4.y baseline: 151 runs, 4 regressions (v4.4.300)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.4.y baseline: 151 runs, 4 regressions (v4.4.300)

Regressions Summary
-------------------

platform    | arch | lab           | compiler | defconfig           | regre=
ssions
------------+------+---------------+----------+---------------------+------=
------
beagle-xm   | arm  | lab-baylibre  | gcc-10   | omap2plus_defconfig | 2    =
      =

i945gsex-qs | i386 | lab-clabbe    | gcc-10   | i386_defconfig      | 1    =
      =

panda       | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1    =
      =


  Details:  https://kernelci.org/test/job/stable/branch/linux-4.4.y/kernel/=
v4.4.300/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-4.4.y
  Describe: v4.4.300
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      000f45ee5487a051b36f17e9dd70433f902ee102 =



Test Regressions
---------------- =



platform    | arch | lab           | compiler | defconfig           | regre=
ssions
------------+------+---------------+----------+---------------------+------=
------
beagle-xm   | arm  | lab-baylibre  | gcc-10   | omap2plus_defconfig | 2    =
      =


  Details:     https://kernelci.org/test/plan/id/61f26defa81e3a1805abbd32

  Results:     3 PASS, 2 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.4.y/v4.4.300/ar=
m/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagle-xm.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.4.y/v4.4.300/ar=
m/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagle-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.crit: https://kernelci.org/test/case/id/61f26defa81e3a18=
05abbd38
        new failure (last pass: v4.4.298)
        1 lines

    2022-01-27T10:03:08.192488  / # =

    2022-01-27T10:03:08.193143  #
    2022-01-27T10:03:08.296348  / # #
    2022-01-27T10:03:08.296994  =

    2022-01-27T10:03:08.398333  / # #export SHELL=3D/bin/sh
    2022-01-27T10:03:08.398694  =

    2022-01-27T10:03:08.499814  / # export SHELL=3D/bin/sh. /lava-1456579/e=
nvironment
    2022-01-27T10:03:08.500134  =

    2022-01-27T10:03:08.601253  / # . /lava-1456579/environment/lava-145657=
9/bin/lava-test-runner /lava-1456579/0
    2022-01-27T10:03:08.602336   =

    ... (10 line(s) more)  =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61f26defa81e3a1=
805abbd3a
        new failure (last pass: v4.4.298)
        29 lines

    2022-01-27T10:03:09.117407  kern  :emerg : Internal error: Oops - BUG: =
0 [#1] SMP ARM
    2022-01-27T10:03:09.123194  kern  :emerg : Process udevd (pid: 109, sta=
ck limit =3D 0xcb95c218)
    2022-01-27T10:03:09.127471  kern  :emerg : Stack: (0xcb95dcf8 to 0xcb95=
e000)
    2022-01-27T10:03:09.135777  kern  :emerg : dce0:                       =
                                bf02bdc4 60000013   =

 =



platform    | arch | lab           | compiler | defconfig           | regre=
ssions
------------+------+---------------+----------+---------------------+------=
------
i945gsex-qs | i386 | lab-clabbe    | gcc-10   | i386_defconfig      | 1    =
      =


  Details:     https://kernelci.org/test/plan/id/61f26d2d5a01182c66abbd17

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.4.y/v4.4.300/i3=
86/i386_defconfig/gcc-10/lab-clabbe/baseline-i945gsex-qs.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.4.y/v4.4.300/i3=
86/i386_defconfig/gcc-10/lab-clabbe/baseline-i945gsex-qs.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61f26d2d5a01182c66abb=
d18
        new failure (last pass: v4.4.299) =

 =



platform    | arch | lab           | compiler | defconfig           | regre=
ssions
------------+------+---------------+----------+---------------------+------=
------
panda       | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1    =
      =


  Details:     https://kernelci.org/test/plan/id/61f26dd1380040b40dabbd26

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.4.y/v4.4.300/ar=
m/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.4.y/v4.4.300/ar=
m/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61f26dd1380040b=
40dabbd2c
        failing since 61 days (last pass: v4.4.292, first fail: v4.4.293)
        2 lines

    2022-01-27T10:02:38.279175  [   18.890960] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2022-01-27T10:02:38.322760  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/110
    2022-01-27T10:02:38.332157  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
25c [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =20
