Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19E1E2ADA50
	for <lists+stable@lfdr.de>; Tue, 10 Nov 2020 16:24:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731071AbgKJPYY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Nov 2020 10:24:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730786AbgKJPYX (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Nov 2020 10:24:23 -0500
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DB7CC0613CF
        for <stable@vger.kernel.org>; Tue, 10 Nov 2020 07:24:23 -0800 (PST)
Received: by mail-pf1-x433.google.com with SMTP id 10so11739839pfp.5
        for <stable@vger.kernel.org>; Tue, 10 Nov 2020 07:24:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=GXbYfLWMnHzsq3KKzGfao39PO5zrkkhuBb2pk6H8+eM=;
        b=G0DCntFClLGOuO/eV/eSB84vut6RPbIzq4aBfavShZIlgY3WX2V4z0F/g+EWI8XJup
         1fgSx5T1DwB7hzJSHzndy5JRdM/Mmu2nHkkOUWeOatzZNQvVIX3hZK/Bhj2iKgIBXg1B
         WZmjdbMEvtUxAA9/fbxQmqwHLVg2YsnaIYbWys8JpL2Wg/ECcJbuc952sK00oCvzNMPH
         izhOxGyH9cXmLmtfrLoPK+IqW4yx85PSs1ruZf7tvzPqGGW+KgSqA+JUssQcbD88U7a5
         kXWRvgb4rB1yD7N78HK9JFoHrk0BRRKF4+STGSqbWtjzekBxCJhWAsL6/7vddWZpRGZV
         DSzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=GXbYfLWMnHzsq3KKzGfao39PO5zrkkhuBb2pk6H8+eM=;
        b=oG/CRI6axOIhhUPbqtBZ44Dlj0JD2PenscRbcf0je4SLeEiSvVYxlYGWeeFX6Fs1at
         dJNjT1REYwm6pAbnGpYTdycbLEK+oaFoJNzgKLijAcE8rXE5OmYiGMMPKSvTtaBUNrq4
         uk6yf7HMAbzszcxKuo1Xb001GpEZikxVdRLjHt9jc2Fck35P1vknKCa1rEZeDH6sFmmQ
         g9cj26lACe0z94uWgCtL2ySuEetlzLoKcxLCqhNf+PefzgM0X7YQzQev5Hbt/POEaXBJ
         l7DCaIPh4NOCBgVC6im3UlzrpdDo40FQPIAIYf+Uqn7nc9y+OuRSiUcHySOhIoF43WLY
         LWcQ==
X-Gm-Message-State: AOAM533wArdqlOSFx3OzO0sI/7HJr5b1DIcQZtdMHMpLdEjmKGcq6GLb
        SihOvpJ0AGBgf1Y4a6f8skgU1ZGnjszNaA==
X-Google-Smtp-Source: ABdhPJx3fbsZjLG6TQFqWSkhCzaU+ThwBcl3povpFTwaTa5JlVi+/7pwOqEtmIRHc9x+fris28Erhw==
X-Received: by 2002:aa7:92c3:0:b029:163:d2d6:8db1 with SMTP id k3-20020aa792c30000b0290163d2d68db1mr19032654pfa.17.1605021862682;
        Tue, 10 Nov 2020 07:24:22 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id v196sm14784875pfc.34.2020.11.10.07.24.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Nov 2020 07:24:21 -0800 (PST)
Message-ID: <5faab0a5.1c69fb81.2afed.057d@mx.google.com>
Date:   Tue, 10 Nov 2020 07:24:21 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.4
X-Kernelci-Kernel: v5.4.75-85-gb7b9e5d4d607
Subject: stable-rc/queue/5.4 baseline: 205 runs,
 3 regressions (v5.4.75-85-gb7b9e5d4d607)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 205 runs, 3 regressions (v5.4.75-85-gb7b9e5d4=
d607)

Regressions Summary
-------------------

platform             | arch | lab          | compiler | defconfig          =
| regressions
---------------------+------+--------------+----------+--------------------=
+------------
bcm2837-rpi-3-b-32   | arm  | lab-baylibre | gcc-8    | bcm2835_defconfig  =
| 2          =

sun8i-h3-orangepi-pc | arm  | lab-clabbe   | gcc-8    | multi_v7_defconfig =
| 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.75-85-gb7b9e5d4d607/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.75-85-gb7b9e5d4d607
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      b7b9e5d4d607d038c6c84eb8b026b1ff65b32079 =



Test Regressions
---------------- =



platform             | arch | lab          | compiler | defconfig          =
| regressions
---------------------+------+--------------+----------+--------------------=
+------------
bcm2837-rpi-3-b-32   | arm  | lab-baylibre | gcc-8    | bcm2835_defconfig  =
| 2          =


  Details:     https://kernelci.org/test/plan/id/5faa7abec839376be3db8873

  Results:     3 PASS, 2 FAIL, 0 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.75-85=
-gb7b9e5d4d607/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rp=
i-3-b-32.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.75-85=
-gb7b9e5d4d607/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rp=
i-3-b-32.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.alert: https://kernelci.org/test/case/id/5faa7abec839376=
be3db8877
        new failure (last pass: v5.4.75-85-gaf478e97f172)
        4 lines

    2020-11-10 11:34:10.999000+00:00  kern  :alert : pgd =3D 6f1aa0ee
    2020-11-10 11:34:11+00:00  kern  :alert : [2b972a02] *pgd=3D00000000   =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5faa7abec839376=
be3db8878
        new failure (last pass: v5.4.75-85-gaf478e97f172)
        14 lines

    2020-11-10 11:34:11.002000+00:00  kern  :emerg : Process kworker/0:1H (=
pid: 49, stack limit =3D 0x9ba32e7e)
    2020-11-10 11:34:11.005000+00:00  kern  :emerg : Stack: (0xead33ed0 to =
0xead34000)
    2020-11-10 11:34:11.041000+00:00  kern  :emerg : 3ec0:                 =
                    c0d0e440 c0d04248 00000000 2b972912
    2020-11-10 11:34:11.042000+00:00  kern  :emerg : 3ee0: ead33f3c eacec68=
0 eace8cc0 c0d0c6b0 ef0d9500 00000000 00000000 eace8cc4
    2020-11-10 11:34:11.043000+00:00  kern  :emerg : 3f00: ead33f1c ead33f1=
0 c0592924 c0592404 ead33f54 ead33f20 c01356c0 c0592900
    2020-11-10 11:34:11.044000+00:00  kern  :emerg : 3f20: c0136198 c013b29=
c ead33f54 eacec680 eacec694 c0d0c6b0 c0d136a0 c0d0c254
    2020-11-10 11:34:11.045000+00:00  kern  :emerg : 3f40: c0d0c6c4 eace5d1=
8 ead33f7c ead33f58 c0135ce4 c0135544 eace5d00 eace59c0
    2020-11-10 11:34:11.084000+00:00  kern  :emerg : 3f60: ead32000 eacec68=
0 c0135abc ec509e98 ead33fac ead33f80 c013b264 c0135ac8
    2020-11-10 11:34:11.085000+00:00  kern  :emerg : 3f80: 00000001 eace59c=
0 c013b148 00000000 00000000 00000000 00000000 00000000
    2020-11-10 11:34:11.087000+00:00  kern  :emerg : 3fa0: 00000000 ead33fb=
0 c01010e8 c013b154 00000000 00000000 00000000 00000000 =

    ... (3 line(s) more)  =

 =



platform             | arch | lab          | compiler | defconfig          =
| regressions
---------------------+------+--------------+----------+--------------------=
+------------
sun8i-h3-orangepi-pc | arm  | lab-clabbe   | gcc-8    | multi_v7_defconfig =
| 1          =


  Details:     https://kernelci.org/test/plan/id/5faa80aaae958ab2e1db887c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.75-85=
-gb7b9e5d4d607/arm/multi_v7_defconfig/gcc-8/lab-clabbe/baseline-sun8i-h3-or=
angepi-pc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.75-85=
-gb7b9e5d4d607/arm/multi_v7_defconfig/gcc-8/lab-clabbe/baseline-sun8i-h3-or=
angepi-pc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5faa80aaae958ab2e1db8=
87d
        new failure (last pass: v5.4.75-85-gaf478e97f172) =

 =20
