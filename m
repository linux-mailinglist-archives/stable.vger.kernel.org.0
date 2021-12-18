Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3A55479C59
	for <lists+stable@lfdr.de>; Sat, 18 Dec 2021 20:39:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234009AbhLRTjy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 18 Dec 2021 14:39:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230209AbhLRTjv (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 18 Dec 2021 14:39:51 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 938ACC061574
        for <stable@vger.kernel.org>; Sat, 18 Dec 2021 11:39:51 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id x15so4368020plg.1
        for <stable@vger.kernel.org>; Sat, 18 Dec 2021 11:39:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=6LC9dlG1pp+fYGpS7mZ59AU3QpYX3HerJyCIm50PTQs=;
        b=C5+bt7aZ62w/eYcgUusdJPC7Dl46dX7cUUUalA2zT/uGbW7MFpJOBssFzkmESxKv27
         9xl7Ee87jO1tMmSW5A7M9MFNQfoKqpPlsJIsOdLVBuGnHOgwfHZunkOuNIc7JApIpDeX
         6F4oJU0Zjo/iP+bTR9Qsml678f5/vnnnOBB6FFXOzI9yFBuIf99L+PwhXTQglTwLMx7f
         zt8k0cmvlNcwaxHCNZ81Iob259VZ3cxvJ4IXEAP+ZE6Bb4pQrQ3+uReAffcujGzRRL22
         vyZRJ1wp48LVXfsD55oI70474oIkK3SOPMOg1w7jG7mTFV0ilurUMx0UN3GMJvdedhbr
         UtwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=6LC9dlG1pp+fYGpS7mZ59AU3QpYX3HerJyCIm50PTQs=;
        b=Kt384bnbvLktreAP60kRa8EmbFkU0nLJpqGVrQkYqKmNV4/FHj9+MP57Et1bYMUTkm
         cktRHFqwaXj+upS2RrMLq9QdAcBcERPDdTZu/MqykQvBCqQKIMcWr/bad5NNvdSah+aY
         IkTwQv7ScPKYWRb7Kf1ytbQtoCkMgf+iBF80eNMH+THSsbIRmdndryhFpW5PBT/J/mkz
         p0vI+N6PzmyTVOOhNbnNc6PQdgXlN2SJ61X+FwyvyBrOYvrVYOmbsJWjnz0hDqA14h+T
         t3PhifPJyJEyMV+OiOOM0a0A6HdhSxCmbntGRTO+VBRRVcBVmUT8eJDu+5Q+qr/21MjN
         EHhg==
X-Gm-Message-State: AOAM533y+CH5Aw+NOm5cSXZqTAu4YCpAIe3hVxCX1UDWdNpON43WN0kA
        r0+n6cY74uwVIgu1LtMK8Zk/z+VgWgJZPOrd
X-Google-Smtp-Source: ABdhPJxlQVAbQ/DiGWaRrjuOj+5hOwMLwmLZOTXMipUMbczivPUmLMVe8kDY8BYv5Xq5GKw2wlI//Q==
X-Received: by 2002:a17:902:bd44:b0:148:a2f7:9d85 with SMTP id b4-20020a170902bd4400b00148a2f79d85mr9439925plx.164.1639856390965;
        Sat, 18 Dec 2021 11:39:50 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id a1sm14490813pfv.99.2021.12.18.11.39.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Dec 2021 11:39:50 -0800 (PST)
Message-ID: <61be3906.1c69fb81.41a4c.7775@mx.google.com>
Date:   Sat, 18 Dec 2021 11:39:50 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.4.295
X-Kernelci-Report-Type: test
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.4.y baseline: 153 runs, 3 regressions (v4.4.295)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y baseline: 153 runs, 3 regressions (v4.4.295)

Regressions Summary
-------------------

platform         | arch | lab          | compiler | defconfig           | r=
egressions
-----------------+------+--------------+----------+---------------------+--=
----------
beagle-xm        | arm  | lab-baylibre | gcc-10   | omap2plus_defconfig | 2=
          =

beaglebone-black | arm  | lab-cip      | gcc-10   | omap2plus_defconfig | 1=
          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.4.y/kern=
el/v4.4.295/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.4.y
  Describe: v4.4.295
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      87ae08ae6ba1f4d6ca8cb134899d87737700be15 =



Test Regressions
---------------- =



platform         | arch | lab          | compiler | defconfig           | r=
egressions
-----------------+------+--------------+----------+---------------------+--=
----------
beagle-xm        | arm  | lab-baylibre | gcc-10   | omap2plus_defconfig | 2=
          =


  Details:     https://kernelci.org/test/plan/id/61b9205e19f0c8415539713a

  Results:     3 PASS, 2 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.295=
/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagle-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.295=
/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagle-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.crit: https://kernelci.org/test/case/id/61b9205e19f0c841=
5539713d
        new failure (last pass: v4.4.295-6-g76eaee78184e)
        1 lines

    2021-12-18T15:46:08.024719  / # #
    2021-12-18T15:46:08.025371  =

    2021-12-18T15:46:08.128126  / # #
    2021-12-18T15:46:08.128589  =

    2021-12-18T15:46:08.229809  / # #export SHELL=3D/bin/sh
    2021-12-18T15:46:08.230166  =

    2021-12-18T15:46:08.331303  / # export SHELL=3D/bin/sh. /lava-1282261/e=
nvironment
    2021-12-18T15:46:08.331621  =

    2021-12-18T15:46:08.432816  / # . /lava-1282261/environment/lava-128226=
1/bin/lava-test-runner /lava-1282261/0
    2021-12-18T15:46:08.433747   =

    ... (9 line(s) more)  =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61b9205e19f0c84=
15539713f
        new failure (last pass: v4.4.295-6-g76eaee78184e)
        29 lines

    2021-12-18T15:46:08.894218  [   49.386535] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-12-18T15:46:08.959520  kern  :emerg : Internal error: Oops - BUG: =
0 [#1] SMP ARM
    2021-12-18T15:46:08.965244  kern  :emerg : Process udevd (pid: 114, sta=
ck limit =3D 0xcba3c218)
    2021-12-18T15:46:08.969397  kern  :emerg : Stack: (0xcba3dcf8 to 0xcba3=
e000)
    2021-12-18T15:46:08.977600  kern  :emerg : dce0:                       =
                                bf02bdc4 60000013
    2021-12-18T15:46:08.990640  kern  :emerg : dd00: bf02bdc8 c06a3ca4 0000=
0001 00[   49.479339] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Demerg RESULT=3Df=
ail UNITS=3Dlines MEASUREMENT=3D29>   =

 =



platform         | arch | lab          | compiler | defconfig           | r=
egressions
-----------------+------+--------------+----------+---------------------+--=
----------
beaglebone-black | arm  | lab-cip      | gcc-10   | omap2plus_defconfig | 1=
          =


  Details:     https://kernelci.org/test/plan/id/61b9208abff33a261b39713c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.295=
/arm/omap2plus_defconfig/gcc-10/lab-cip/baseline-beaglebone-black.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.295=
/arm/omap2plus_defconfig/gcc-10/lab-cip/baseline-beaglebone-black.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61b9208abff33a261b397=
13d
        new failure (last pass: v4.4.295-6-g76eaee78184e) =

 =20
