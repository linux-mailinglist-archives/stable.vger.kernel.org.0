Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3BFD456763
	for <lists+stable@lfdr.de>; Fri, 19 Nov 2021 02:19:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229915AbhKSBWU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Nov 2021 20:22:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229833AbhKSBWU (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Nov 2021 20:22:20 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74D07C061574
        for <stable@vger.kernel.org>; Thu, 18 Nov 2021 17:19:19 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id np6-20020a17090b4c4600b001a90b011e06so7404224pjb.5
        for <stable@vger.kernel.org>; Thu, 18 Nov 2021 17:19:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=VvsMPLZ06B15/xQQw0zrbDO3JDKg/szQp4uOlOyfjec=;
        b=OEJ9xAMY9Ogym/ziS0tr5MNkr+2sXfkdkw6HclvA88aImZ7kdWFHrMxMtf589Gc7XL
         qm9h/oon2+G/IPA8smojyVEnURciVz4MzA0MpiaU1/5ZqFG6lCa7RKvlrfPaBeR+O4vH
         NuzBki/Z6D0HcIUCfTzyNRtn8MOvQU0kZvv7b9xFNtSHci+8Eyou08eDYC9XHQMAuPb6
         A6wCuWsdYfzgJmo70OW5Og/A+iKcNvjIPLH3KQmemPdo3LmMQQstEgNps+Xz5sJQLyhb
         /8Kn9jFDi672bSL9OtuGgtwTiXU69ICdNRDRMDvpa/blE1j4pdgwZWEqlTrk+UWxyktc
         c1zA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=VvsMPLZ06B15/xQQw0zrbDO3JDKg/szQp4uOlOyfjec=;
        b=3itJBt5ZfHLNA9sHajr7qg0XIMsyPBw6zkDu9eUuzzXsVBCzEOB7YbPdKtkUaFb92m
         AxHzQ7ZIcsSFhmWUH9Hu8eZ+GYSRnkGmDdNTUQwy72aZB7rLZE1wEU2WxbtotyzOKEXO
         YhYSNmtS0H7RX3nNng3Q9Ip5XhFH6cz/nxXpl/eJtHcCdgUpXAmjcCfJlB26bZE5jCat
         FPgNOgLcLrmVO7A1bSYL+Pn/a7n7o3k4vBYe2+PufXgeZD8KQqrsmnOfAd5/BJfyS4vv
         dHCQl7u1VJPAgVSy4/vbAJnv5ZawFkkeMMG/u74+B0uAooKPvNd+5UN/sGWYzZy8w9PY
         NPPw==
X-Gm-Message-State: AOAM53335vgzLIe7HBTMeXA0EUJGdxHmzFXc1fVnnspe/Vlq0iwEPPnn
        7lupmZIX7icSrmEUSJHkWACUVTcL0f9yrsa4
X-Google-Smtp-Source: ABdhPJyVCVIcgapNcXPFwcLEeHbwzfWECNw5/fqGbeMVAQ0CeEMzRS6XFTfL0+D59b4+1Iu5Honh7w==
X-Received: by 2002:a17:90a:e395:: with SMTP id b21mr44529pjz.103.1637284758873;
        Thu, 18 Nov 2021 17:19:18 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id s2sm846030pfg.124.2021.11.18.17.19.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Nov 2021 17:19:18 -0800 (PST)
Message-ID: <6196fb96.1c69fb81.7d48d.448a@mx.google.com>
Date:   Thu, 18 Nov 2021 17:19:18 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.9.290
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.9.y
Subject: stable-rc/linux-4.9.y baseline: 148 runs, 2 regressions (v4.9.290)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y baseline: 148 runs, 2 regressions (v4.9.290)

Regressions Summary
-------------------

platform    | arch   | lab           | compiler | defconfig                =
    | regressions
------------+--------+---------------+----------+--------------------------=
----+------------
panda       | arm    | lab-collabora | gcc-10   | omap2plus_defconfig      =
    | 1          =

qemu_x86_64 | x86_64 | lab-broonie   | gcc-10   | x86_64_defcon...6-chromeb=
ook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.9.y/kern=
el/v4.9.290/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.9.y
  Describe: v4.9.290
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      ab95ef83dddbae37b60263e092d08d5cd2b0059e =



Test Regressions
---------------- =



platform    | arch   | lab           | compiler | defconfig                =
    | regressions
------------+--------+---------------+----------+--------------------------=
----+------------
panda       | arm    | lab-collabora | gcc-10   | omap2plus_defconfig      =
    | 1          =


  Details:     https://kernelci.org/test/plan/id/618faebb1160764876335906

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.290=
/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.290=
/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/618faebb1160764=
876335909
        new failure (last pass: v4.9.289-23-g6ecf94b5fd89)
        2 lines

    2021-11-18T21:07:00.258013  [   20.255096] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-11-18T21:07:00.304817  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/129
    2021-11-18T21:07:00.314190  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
230 [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =



platform    | arch   | lab           | compiler | defconfig                =
    | regressions
------------+--------+---------------+----------+--------------------------=
----+------------
qemu_x86_64 | x86_64 | lab-broonie   | gcc-10   | x86_64_defcon...6-chromeb=
ook | 1          =


  Details:     https://kernelci.org/test/plan/id/618fab494e1337b08e335918

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.290=
/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-broonie/baseline-qemu_x8=
6_64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.290=
/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-broonie/baseline-qemu_x8=
6_64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/618fab494e1337b08e335=
919
        new failure (last pass: v4.9.290-160-ga8041b640adb) =

 =20
