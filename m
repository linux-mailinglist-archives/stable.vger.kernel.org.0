Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA2B44A62C0
	for <lists+stable@lfdr.de>; Tue,  1 Feb 2022 18:42:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241616AbiBARm3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Feb 2022 12:42:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241625AbiBARm2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Feb 2022 12:42:28 -0500
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1550C06173B
        for <stable@vger.kernel.org>; Tue,  1 Feb 2022 09:42:28 -0800 (PST)
Received: by mail-pg1-x52c.google.com with SMTP id h23so15945478pgk.11
        for <stable@vger.kernel.org>; Tue, 01 Feb 2022 09:42:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=vhbsaPXRN6qpaH3EcTlj1lw/CnHxtLDmESfLBYeglk4=;
        b=JiI+EQwQF/vGpxyGR7FNFez5SYbz8GUAZo+cQDbg0T7HyMMU3KdVLF9QlYLoPiA3O1
         rHgOJpMlf0yGkgfwiQN7AcFYsM7YwGe2QhzVgEPO/2n82ihgi2lS9rzfkClJ18LGoLru
         5YMAU0z7lnBX7f2BGI+Vaoni4c4WGUABWZdaMfMKVIcZwcY3ZGc7KXmx+uTIB1VICedH
         5xieFezgfwX9j/kt9x1/2/dRCKdHwNLjD/0W1AzSV368A9Hg/lCShXarsgneLdOHE4Ep
         FRnozFvbH6iSzXLTyQql/qyV9XpvYzJC7nTz3uhNlMeMUn6jyhkIRzNS3V8J9j35R/5b
         5jKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=vhbsaPXRN6qpaH3EcTlj1lw/CnHxtLDmESfLBYeglk4=;
        b=xLq3VxS/dFv0hjrlchDDR3rLOOe/I52dW6aHYBJ+TLuaCeKJhAfcbUAfXxdMqdvDbN
         2rzV7X1U0uvRpdQ/gLNSFhRh5yGnxL71ZLrAr1lS11l7Q5a+u6G0KEtPGqWm/PKGhhLy
         +ZAbnJul4fs20Qz5dsr9j9FsdyuhtM7pbZyc/LXLPO+inlVOUtiGs0mOPMXB6rm4TapK
         FV6hTG13W8lQE/LtkFQj0fCzoG6ecTEYevL88gBsvoUYWfUhNAQwN0+1rcQW9NknpJs8
         XsUF71h3r3UqtjIJS5mxj7yuzF6K7SXKRolaO4bjpdWXaUJs3c2evyGOLtQ9DLWd/Ch1
         rVRg==
X-Gm-Message-State: AOAM532Dwb4u+naNRdaSdlgQtmsRO7ajdAmM1AmRLp9VZ0bp6WAYaV+u
        1orIE1hhBNBPv5XiSmWW9sEk41mcsD27oU7m
X-Google-Smtp-Source: ABdhPJyZG21nlfoFoOb1m8IxFyKhbltCaZYe4GNSNdULuZ+mTOxj2+MdiD/ecW0qEPVnrhjGL8VutA==
X-Received: by 2002:a63:24a:: with SMTP id 71mr11888824pgc.300.1643737348089;
        Tue, 01 Feb 2022 09:42:28 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id u37sm8159391pga.2.2022.02.01.09.42.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Feb 2022 09:42:27 -0800 (PST)
Message-ID: <61f97103.1c69fb81.22ce.4a7f@mx.google.com>
Date:   Tue, 01 Feb 2022 09:42:27 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.4.301-21-g4b4eb3554fea
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/4.4
Subject: stable-rc/queue/4.4 baseline: 118 runs,
 2 regressions (v4.4.301-21-g4b4eb3554fea)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 baseline: 118 runs, 2 regressions (v4.4.301-21-g4b4eb35=
54fea)

Regressions Summary
-------------------

platform         | arch   | lab           | compiler | defconfig           =
| regressions
-----------------+--------+---------------+----------+---------------------=
+------------
panda            | arm    | lab-collabora | gcc-10   | omap2plus_defconfig =
| 1          =

qemu_x86_64-uefi | x86_64 | lab-collabora | gcc-10   | x86_64_defconfig    =
| 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.4/kern=
el/v4.4.301-21-g4b4eb3554fea/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.4
  Describe: v4.4.301-21-g4b4eb3554fea
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      4b4eb3554feaad045459f8fc34992e584c4349a3 =



Test Regressions
---------------- =



platform         | arch   | lab           | compiler | defconfig           =
| regressions
-----------------+--------+---------------+----------+---------------------=
+------------
panda            | arm    | lab-collabora | gcc-10   | omap2plus_defconfig =
| 1          =


  Details:     https://kernelci.org/test/plan/id/61f9399c8ebcf92f0b5d6f10

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.301-2=
1-g4b4eb3554fea/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.301-2=
1-g4b4eb3554fea/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61f9399c8ebcf92=
f0b5d6f16
        new failure (last pass: v4.4.301-21-gf1b3a01fec55)
        2 lines

    2022-02-01T13:45:44.168100  [   18.956115] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2022-02-01T13:45:44.219811  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/123
    2022-02-01T13:45:44.229104  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
25c [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1
    2022-02-01T13:45:44.250605  [   19.039184] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =



platform         | arch   | lab           | compiler | defconfig           =
| regressions
-----------------+--------+---------------+----------+---------------------=
+------------
qemu_x86_64-uefi | x86_64 | lab-collabora | gcc-10   | x86_64_defconfig    =
| 1          =


  Details:     https://kernelci.org/test/plan/id/61f948378da9d3f9e85d6efb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.301-2=
1-g4b4eb3554fea/x86_64/x86_64_defconfig/gcc-10/lab-collabora/baseline-qemu_=
x86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.301-2=
1-g4b4eb3554fea/x86_64/x86_64_defconfig/gcc-10/lab-collabora/baseline-qemu_=
x86_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61f948378da9d3f9e85d6=
efc
        new failure (last pass: v4.4.301-21-gf1b3a01fec55) =

 =20
