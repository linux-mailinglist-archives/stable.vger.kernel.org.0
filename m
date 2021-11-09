Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66F5944B4E2
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 22:44:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243356AbhKIVqy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Nov 2021 16:46:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239105AbhKIVqx (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Nov 2021 16:46:53 -0500
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28E98C061764
        for <stable@vger.kernel.org>; Tue,  9 Nov 2021 13:44:07 -0800 (PST)
Received: by mail-pg1-x534.google.com with SMTP id n23so321508pgh.8
        for <stable@vger.kernel.org>; Tue, 09 Nov 2021 13:44:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=hH5+3Tl62maPZ5S8Ad7ueKnn8MGHWX7mtQ3PX4fr3uI=;
        b=jkMeVyuIupRJv1cO4d0iY4P/CepvpvQZpqpVKL1yuMn8ghicfliUtdlc8aPjCkgyq1
         3ZdMc0DBOacdJaFJtrCxY1vyA86MGerK5jhGDp1aLnFnquawVWugAbZPfKe+BTApXDqp
         4FtYi/sxVNwRPpv/j0aFOFXUn2MZnYynwfHlmErCjLFxsNj8JEbHj3u2Wy8bu7yg2GuJ
         f5a0LvIZ9A7I32r2LmRONnz+t05cGDmRyWYA/vjrjiTajuAivJINGhB3emCX4Ajze33o
         R9yR/nOcjT2ztwgoPFp4e/e49u0+QPBuwZzjE0k4TqFIoSwbotZY4Z229WfNoqyHda7Y
         psqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=hH5+3Tl62maPZ5S8Ad7ueKnn8MGHWX7mtQ3PX4fr3uI=;
        b=0rvl2Ja4f6P7pP011+h2SRy6YXB//MWZRVQaBr1qIm6g+XUSCusdP1WMZnqJ2t0QxL
         6kEiVmFDzUnqcJpx6i00uJ15UZhAvdLYnY4kMsC36ASyMV+URf9v09y6iKq0nB98/vcg
         fem8bRWjqk4Y/X0G+X48wvrdf8xSe60JgEhTd4nJjutGHeQHrsATTGfLupzvHk1KgwLR
         Yx1OIMnODq07nJxh8bTjuB2QaLggEL/X9gm8xzlETsPE3KzudHxa7YbYix/Yf4eItJBS
         GqqE90+++AcJv5RYfIfvuDn2wpPICKLrZI2/znw7uEknRydksll/7fdxgBecAUN2xxKw
         o0aQ==
X-Gm-Message-State: AOAM532c3FNy+mge3NEyHhqr5IPI/ymT9zWm5hCjcoj2xp3gI0M0TA3g
        3249ntmWAVoUzl8FEX5yHMRLZQvkdk7xBHhJ
X-Google-Smtp-Source: ABdhPJw87MV//iMyVUZQeV5syOKp6yKtFtaXKJbayaCkezXLp9MES2awkNEGAjTaW7tWlwMwoOge/w==
X-Received: by 2002:a63:6bca:: with SMTP id g193mr8404478pgc.358.1636494246481;
        Tue, 09 Nov 2021 13:44:06 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id m184sm7084042pga.61.2021.11.09.13.44.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Nov 2021 13:44:06 -0800 (PST)
Message-ID: <618aeba6.1c69fb81.e86fd.48c7@mx.google.com>
Date:   Tue, 09 Nov 2021 13:44:06 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.14
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.14.254-13-gf0ce35059c8b
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.14 baseline: 170 runs,
 4 regressions (v4.14.254-13-gf0ce35059c8b)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 170 runs, 4 regressions (v4.14.254-13-gf0ce3=
5059c8b)

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

qemu_i386-uefi           | i386   | lab-collabora | gcc-10   | i386_defconf=
ig               | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.254-13-gf0ce35059c8b/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.254-13-gf0ce35059c8b
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      f0ce35059c8bbc36a33d41be20304a53d2b2edf9 =



Test Regressions
---------------- =



platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
n...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/618aaf8eae0b60652f3358f6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.254=
-13-gf0ce35059c8b/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-minnowboard-turbot-E3826.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.254=
-13-gf0ce35059c8b/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-minnowboard-turbot-E3826.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/618aaf8eae0b60652f335=
8f7
        new failure (last pass: v4.14.254-12-g923d11bd34b9) =

 =



platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
nfig             | 1          =


  Details:     https://kernelci.org/test/plan/id/618ab2e8c10b2b15373358f9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.254=
-13-gf0ce35059c8b/x86_64/x86_64_defconfig/gcc-10/lab-collabora/baseline-min=
nowboard-turbot-E3826.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.254=
-13-gf0ce35059c8b/x86_64/x86_64_defconfig/gcc-10/lab-collabora/baseline-min=
nowboard-turbot-E3826.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/618ab2e8c10b2b1537335=
8fa
        new failure (last pass: v4.14.254-12-gd0fa8635586f) =

 =



platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
panda                    | arm    | lab-collabora | gcc-10   | omap2plus_de=
fconfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/618ab41970ded70e533358f3

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.254=
-13-gf0ce35059c8b/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.254=
-13-gf0ce35059c8b/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/618ab41970ded70=
e533358f6
        new failure (last pass: v4.14.254-12-gd0fa8635586f)
        2 lines

    2021-11-09T17:46:47.636518  [   20.091278] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-11-09T17:46:47.679702  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/104
    2021-11-09T17:46:47.689118  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
d3c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =



platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
qemu_i386-uefi           | i386   | lab-collabora | gcc-10   | i386_defconf=
ig               | 1          =


  Details:     https://kernelci.org/test/plan/id/618ac8a7edebe1642d33590f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.254=
-13-gf0ce35059c8b/i386/i386_defconfig/gcc-10/lab-collabora/baseline-qemu_i3=
86-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.254=
-13-gf0ce35059c8b/i386/i386_defconfig/gcc-10/lab-collabora/baseline-qemu_i3=
86-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/618ac8a7edebe1642d335=
910
        new failure (last pass: v4.14.254-12-gd0fa8635586f) =

 =20
