Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99D714A3291
	for <lists+stable@lfdr.de>; Sun, 30 Jan 2022 00:09:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240982AbiA2XJJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 29 Jan 2022 18:09:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238951AbiA2XJJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 29 Jan 2022 18:09:09 -0500
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C37CBC061714
        for <stable@vger.kernel.org>; Sat, 29 Jan 2022 15:09:08 -0800 (PST)
Received: by mail-pf1-x430.google.com with SMTP id d187so9460582pfa.10
        for <stable@vger.kernel.org>; Sat, 29 Jan 2022 15:09:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=bhwcHpMNBucjg77uc5j740BeSRETkT00t/hIx8AMFCw=;
        b=ixlKU+iEqTMIZXdE5rshjx8rHQfwiDPYawvaby6f8J70+H6GzlTzlKbDspgR2vPPok
         vMuyTKH8Z/jspDcYTj2dn76PxZjJnn0D5eqTCwmn0laOKrZ5CWLSbULv6Rx8IAOaamY+
         0zry2ZjT9pomhSduuBRXCGY7uFs8LGgBIgzXTgq7XnJZMZ1jUwHewyJypLce3bZ88GIJ
         JohC5Ugm85xZ3H6OsSTsVoO5Gbk5uEW8zZOkbnS7yJNnkC8CXvkeI24faM12fpNoYYV5
         a4OamyjuRIZNqKmmfvzjy65M1vwTE2+fflcinZ9KLaHydY3k1bm0c3u7rZ/VvtIzEkzL
         cMpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=bhwcHpMNBucjg77uc5j740BeSRETkT00t/hIx8AMFCw=;
        b=axZiJC9vKg7ro+ItT3NjZUoWic/zeU5U7jIRKuxPugHFxl4hTr9Nh1FkFcCzKE2oDv
         62evI81ekEc2Wm/QyGapScOP0OjhWl8MsFCh0lUJDFzGR34OZNOMd6fLjZK9rIObQYh3
         5iw36TbPY+tF/vbL5dYJm/nOMeijmT2XeTH+WhS46PjewPty30SnOq2a8YogRwXqOT+7
         h908THfmnc3vAKF2BmUHTCAHDOfnsBqTcfhekOX/V6ootYEo0z891VCbORoOWxiWsr5Y
         yCHzApGnbpvqBqUjTsP6g7f3BayV3a5XdzHsgfvNSScFemQZdEfqQhOdeecokjaM9FuU
         B/Eg==
X-Gm-Message-State: AOAM532tey/EMqwyP/LsuaAjI5dStXBBWS4j64Gu10ubHcNaHapL19bZ
        H+IypJbk/U35W4NYz4LrnAMctqOWhW9dXqnM
X-Google-Smtp-Source: ABdhPJz2gF7Gh1LhicwM8wWJCCS8bFgWptWh/zQ0NHbu8rXoPRvnsWomUYs54Or8mQy6uNDqiHFIzQ==
X-Received: by 2002:a05:6a00:1709:: with SMTP id h9mr13904082pfc.23.1643497748063;
        Sat, 29 Jan 2022 15:09:08 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id mz23sm6114791pjb.2.2022.01.29.15.09.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 29 Jan 2022 15:09:07 -0800 (PST)
Message-ID: <61f5c913.1c69fb81.e3341.054e@mx.google.com>
Date:   Sat, 29 Jan 2022 15:09:07 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.4.175-23-g12efc326986fa
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.4
Subject: stable-rc/queue/5.4 baseline: 126 runs,
 4 regressions (v5.4.175-23-g12efc326986fa)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 126 runs, 4 regressions (v5.4.175-23-g12efc32=
6986fa)

Regressions Summary
-------------------

platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv2-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =

qemu_arm-virt-gicv2-uefi | arm  | lab-broonie  | gcc-10   | multi_v7_defcon=
fig | 1          =

qemu_arm-virt-gicv3-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =

qemu_arm-virt-gicv3-uefi | arm  | lab-broonie  | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.175-23-g12efc326986fa/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.175-23-g12efc326986fa
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      12efc326986fa02835b2e574d595d90b7bd44b21 =



Test Regressions
---------------- =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv2-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61f58faf80142d47bdabbd20

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.175-2=
3-g12efc326986fa/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_a=
rm-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.175-2=
3-g12efc326986fa/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_a=
rm-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61f58faf80142d47bdabb=
d21
        failing since 44 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv2-uefi | arm  | lab-broonie  | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61f58fb180142d47bdabbd24

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.175-2=
3-g12efc326986fa/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_ar=
m-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.175-2=
3-g12efc326986fa/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_ar=
m-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61f58fb180142d47bdabb=
d25
        failing since 44 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv3-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61f58f851e8803eea5abbd21

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.175-2=
3-g12efc326986fa/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_a=
rm-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.175-2=
3-g12efc326986fa/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_a=
rm-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61f58f851e8803eea5abb=
d22
        failing since 44 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv3-uefi | arm  | lab-broonie  | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61f58f9c1e8803eea5abbd31

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.175-2=
3-g12efc326986fa/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_ar=
m-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.175-2=
3-g12efc326986fa/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_ar=
m-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61f58f9c1e8803eea5abb=
d32
        failing since 44 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =20
