Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2EAA474592
	for <lists+stable@lfdr.de>; Tue, 14 Dec 2021 15:51:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232812AbhLNOvK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Dec 2021 09:51:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232807AbhLNOvJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Dec 2021 09:51:09 -0500
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E0F0C061574
        for <stable@vger.kernel.org>; Tue, 14 Dec 2021 06:51:08 -0800 (PST)
Received: by mail-pl1-x62d.google.com with SMTP id u11so13720863plf.3
        for <stable@vger.kernel.org>; Tue, 14 Dec 2021 06:51:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=J5HUEuOwFdNZmbkmz/pZS44fXGD/IN8SbBE7cKJCnnY=;
        b=PnJQ7EAuokhj+HXyzWAmwZ8UOsRIzvp/06ohdHkyu9r3MaGQ8zdfWtq54itUCVe2rT
         GF6N8Ee0C5dkoB0IUd2y7gDwiORTQ7bRU1LoAKIKGraJ0fpAVLl2Bw6NsFQaiNVV+4DT
         4xYUckaFBKLH+K4wz+fFdo8EJBJ7WqXOuAOCmaX+Td6Vtje6hm14c51Bbf/mVPVF8fGr
         05cry7N5ug4I5G+QRUgMdlviNgrqdGTroiXV+xI5yNApIG4KfPZDuU7w0RShTB0n3Z69
         goinvp6mp1ITN9PvHf8sELfJbXE3CrMdkzl7iFbzr15DyHBrXUkceW0xR0RFXECHcqYc
         DVyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=J5HUEuOwFdNZmbkmz/pZS44fXGD/IN8SbBE7cKJCnnY=;
        b=j3Zae/btPMs1wnVEylsmErq0qKZTRH8lJ0CIBlRWwdmmH23UJJtYCUBQH6TkjtCPUv
         qVrFftjE2i44nLeEENHghd5jD/n8s0nI9x+vnR2S4h77+u9CFoXoaIqh5uOm6J32i6PB
         CMwfarZi490Fi+yxjNJ71zrOwqXBqA+IEJaRt6bqzGhn9VuGoBdLfQ1C77ImAZga0WTI
         et9oVmziyy7s2zmi8QsmzQSO09oERnwKMKcjRgWcZLwvQjo0OWAhXRLoeLRoTpvOW2rE
         0g2+462ZcjXdLJ8vVIhFUW+03PL5CdwPa8KXDDqTeTUtr3bd2b8ZbJSpAbK7Wk+DTGbZ
         9FIg==
X-Gm-Message-State: AOAM5330/jnFq0etUHXLEp6ytzo4rK3hrreIYkwRgB0YNjSfZxqWR3Yr
        v052HcnSEF90p51Y+mWI2/NDy/J1Y+aS6YCG
X-Google-Smtp-Source: ABdhPJxDcvhnN4Sn5m12oMRPkJYfcXYgDe4feIaZQYWgVgOePQfe4p14AdTzLwMFQh/TanScmBfR/Q==
X-Received: by 2002:a17:902:ecca:b0:141:e920:3b71 with SMTP id a10-20020a170902ecca00b00141e9203b71mr5859023plh.10.1639493467668;
        Tue, 14 Dec 2021 06:51:07 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id p17sm115221pfh.86.2021.12.14.06.51.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Dec 2021 06:51:07 -0800 (PST)
Message-ID: <61b8af5b.1c69fb81.93b2e.051a@mx.google.com>
Date:   Tue, 14 Dec 2021 06:51:07 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.257-53-g615e5af3a40e
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/4.14
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.14 baseline: 121 runs,
 3 regressions (v4.14.257-53-g615e5af3a40e)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 121 runs, 3 regressions (v4.14.257-53-g615e5=
af3a40e)

Regressions Summary
-------------------

platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
n...6-chromebook | 1          =

minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
nfig             | 1          =

panda                    | arm    | lab-collabora | gcc-10   | omap2plus_de=
fconfig          | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.257-53-g615e5af3a40e/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.257-53-g615e5af3a40e
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      615e5af3a40e27da73d03ee1402ec93a30429726 =



Test Regressions
---------------- =



platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
n...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/61b878d6fdf3f2482639712c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.257=
-53-g615e5af3a40e/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-minnowboard-turbot-E3826.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.257=
-53-g615e5af3a40e/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-minnowboard-turbot-E3826.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61b878d6fdf3f24826397=
12d
        new failure (last pass: v4.14.257-33-gcf9830f3ce18) =

 =



platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
nfig             | 1          =


  Details:     https://kernelci.org/test/plan/id/61b87a67d3ef4637cf39711f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.257=
-53-g615e5af3a40e/x86_64/x86_64_defconfig/gcc-10/lab-collabora/baseline-min=
nowboard-turbot-E3826.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.257=
-53-g615e5af3a40e/x86_64/x86_64_defconfig/gcc-10/lab-collabora/baseline-min=
nowboard-turbot-E3826.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61b87a67d3ef4637cf397=
120
        failing since 0 day (last pass: v4.14.257-33-gcf9830f3ce18, first f=
ail: v4.14.257-53-gbe1979ab4cd9) =

 =



platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
panda                    | arm    | lab-collabora | gcc-10   | omap2plus_de=
fconfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/61b877a68ea6d90a4839717c

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.257=
-53-g615e5af3a40e/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.257=
-53-g615e5af3a40e/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61b877a68ea6d90=
a4839717f
        failing since 0 day (last pass: v4.14.257-33-gcf9830f3ce18, first f=
ail: v4.14.257-53-gbe1979ab4cd9)
        2 lines

    2021-12-14T10:53:17.537057  [   27.997650] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-12-14T10:53:17.581024  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/93
    2021-12-14T10:53:17.590349  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
d3c [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1
    2021-12-14T10:53:17.603755  [   28.065216] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =20
