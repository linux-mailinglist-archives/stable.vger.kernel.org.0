Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AA4745677E
	for <lists+stable@lfdr.de>; Fri, 19 Nov 2021 02:35:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231403AbhKSBi4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Nov 2021 20:38:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229754AbhKSBi4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Nov 2021 20:38:56 -0500
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBB66C061574
        for <stable@vger.kernel.org>; Thu, 18 Nov 2021 17:35:55 -0800 (PST)
Received: by mail-pg1-x52d.google.com with SMTP id r5so7174604pgi.6
        for <stable@vger.kernel.org>; Thu, 18 Nov 2021 17:35:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=E3qy8ZgEWojrmm4jpzgd5Z7UwFDoiaWsfINqVfMqUko=;
        b=huZ5pGIEtqPCNMzB+l4JFs+fHU68Q0Y9vCXOhLR8WT5CjC8SdzMcENi1RwYB3bgV0j
         PEwgQl3V0Sx3O+a2LYvbEdsICbLDZ4bt/PtcvN+IwZHpy89/4Dd5N3yAWi0Nr/assQer
         8Pb3Fh0NjCzhPe8ZfU3hBCj7jfFh5C5cXrknJ0I136Dx9scYd27ZLtuoC9XKrqwPDJxz
         qN3w1QgYXRvlCROheTWFlv5UWHkPO0Rw/MD0xAY+FNHxuElhcuo/0uF3SqoxSH/HP1Np
         ajvkQMCzneb8Tx+gupbbNHHocCqJW4N49ebeyYXcHZ+XE9QVVoMLk97iGltFL5jJ2Sqk
         2ahg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=E3qy8ZgEWojrmm4jpzgd5Z7UwFDoiaWsfINqVfMqUko=;
        b=fUZjjyIO2AGPySPKZs5OrC9b73jZG8C2iMEZ8i0C3twRFU+OAdc4sZACUXRrDUhtHz
         pReXuKG0Wocl+3nzLOzh6bE78LvR84gFP5cbTVmMkVVYH9fyPECMXQ614p6yLkRFHiLc
         FviTGHVionjfVB5K1IIe9+jmg7tNtEnYJS9UCyNdsmHyRfvKeEoAdTPm3ra2AeYdd5Bt
         VpRPWlP3wo8pzk/UF0u2KQj6v/PLkZefbtMUB7HsyeluK1lAol/QGBAJYDVRcCFibNhS
         Ppio4EmffGBKidkMwaonY9ubnxc0S9CkWnPHp20MIAxRI5wQ/j5T65jP5GOSeP3YlbrY
         qApA==
X-Gm-Message-State: AOAM532aEyKWJn4RPerO2/DENdOYqwkMs2K4QkyWntym8n6Vg1ErGc5u
        6+9YLxSe+J83+7S2fI5opc4kRIvRhVAnxtnA
X-Google-Smtp-Source: ABdhPJwUfHkuWVFCLDODXzaImtw0HXrZH8t69Pm1ls0NYz9K/FpwneRq/ay7Q97inmDB3uS6IxDCNA==
X-Received: by 2002:aa7:8198:0:b0:44b:e191:7058 with SMTP id g24-20020aa78198000000b0044be1917058mr19656794pfi.39.1637285755079;
        Thu, 18 Nov 2021 17:35:55 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id d24sm808392pfn.62.2021.11.18.17.35.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Nov 2021 17:35:54 -0800 (PST)
Message-ID: <6196ff7a.1c69fb81.4c804.40ac@mx.google.com>
Date:   Thu, 18 Nov 2021 17:35:54 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.14.255
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.14.y
Subject: stable-rc/linux-4.14.y baseline: 163 runs, 2 regressions (v4.14.255)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y baseline: 163 runs, 2 regressions (v4.14.255)

Regressions Summary
-------------------

platform  | arch | lab           | compiler | defconfig           | regress=
ions
----------+------+---------------+----------+---------------------+--------=
----
beagle-xm | arm  | lab-baylibre  | gcc-10   | omap2plus_defconfig | 1      =
    =

panda     | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1      =
    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.14.y/ker=
nel/v4.14.255/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.14.y
  Describe: v4.14.255
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      5f9f3b0057d5c5782985784ba0159b05b4083055 =



Test Regressions
---------------- =



platform  | arch | lab           | compiler | defconfig           | regress=
ions
----------+------+---------------+----------+---------------------+--------=
----
beagle-xm | arm  | lab-baylibre  | gcc-10   | omap2plus_defconfig | 1      =
    =


  Details:     https://kernelci.org/test/plan/id/618f9e169171338eb73358ec

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
55/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagle-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
55/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagle-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/618f9e169171338eb7335=
8ed
        new failure (last pass: v4.14.255-200-g9ac4e6b250bf) =

 =



platform  | arch | lab           | compiler | defconfig           | regress=
ions
----------+------+---------------+----------+---------------------+--------=
----
panda     | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1      =
    =


  Details:     https://kernelci.org/test/plan/id/618f9e149171338eb73358dc

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
55/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
55/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/618f9e149171338=
eb73358e0
        failing since 5 days (last pass: v4.14.255, first fail: v4.14.255-5=
4-gb6f4d599e1d3)
        2 lines

    2021-11-18T21:29:25.070480  [   20.070861] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-11-18T21:29:25.112227  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/104
    2021-11-18T21:29:25.121453  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
d3c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
