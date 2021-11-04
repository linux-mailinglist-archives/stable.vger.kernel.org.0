Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E11D44542A
	for <lists+stable@lfdr.de>; Thu,  4 Nov 2021 14:44:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230344AbhKDNqk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Nov 2021 09:46:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229869AbhKDNqk (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 4 Nov 2021 09:46:40 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56690C061714
        for <stable@vger.kernel.org>; Thu,  4 Nov 2021 06:44:02 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id p8so4118168pgh.11
        for <stable@vger.kernel.org>; Thu, 04 Nov 2021 06:44:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=VGGQ3/Ry0dl5/WN2AANBWP9GNIc2H9jU1OdzP/QgJV4=;
        b=6rXS/RT/t7wbYh50tbMuZc5+bR1KTFwfpj4lNpUe2jgnOaykudEuWvvRaENTbCV5km
         pHJj//pN+x5oYd0RWUxlBQz+d+Ab9fDfGsKiGeuXN/wO0tqWtUnbtukHBz2DUXXionLJ
         6qY2q1W9/Z/gzdRUuelh4aFfrP5ozL1yMh1/mr4YE6ZXg67cEOf2HReR/pyT+zGLDz3l
         6GYbq8YhL1XPqx6l3tmyqddsvjtYgPDb6MkjFOJB0lEfjINp1hw6Azie3RZ1RuYAqJKB
         /QRf9HAWCVvqhoYjZh+FQzXvqj35gxX94ERZGBGbjb59AF2ZAksNajqqsJavLXPidQVO
         stSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=VGGQ3/Ry0dl5/WN2AANBWP9GNIc2H9jU1OdzP/QgJV4=;
        b=HhApNzBWW1MkQ07Y+gMr+loWcp5a8ClbX08aE/eCfVNlfxL7K1UbzYpx0+h3IgqaI1
         ZWpNp7A3utXu2/CPgFUxqHTF6ReFE/bJ1CRo+2SkPVbAlvaTHbPwpvJDoXT+kggH3B+i
         F5eXYtSELt5YT2O1Q2gSKjWMUA34NmihwvZ31R7ddPLr42+SVwvLQAPAQIIg9vN2RbYd
         0Z5EbhkClXJwVwU49KaXJTcpmUaHVTi3s4j02fgZnLHJBas6kfzdQoJFjyi0/AHSJQXG
         nesQoS/uaBLkE6eAmsZ1/IPIiho5lgz1hEv9jQFtsralpo7SJHwLq1nc5dROADi18cAv
         t51g==
X-Gm-Message-State: AOAM532wcYUdrt2sZoQhBeUrI6Do0JomdStnHPL45lSMmyXpHrBuXvuo
        BUXBpW9CmR8oXqObFuIJs+AqdM1AGb23lgBM
X-Google-Smtp-Source: ABdhPJxNzkcrnfVwuHHm3aInjO//4HsJP1Td+C4s1MKy++sSwl+rcfinh+5XMCQX4jrPaD2DRA9rGg==
X-Received: by 2002:aa7:8d17:0:b0:44d:3593:2c1a with SMTP id j23-20020aa78d17000000b0044d35932c1amr52288012pfe.3.1636033441701;
        Thu, 04 Nov 2021 06:44:01 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y35sm5629515pfa.43.2021.11.04.06.44.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Nov 2021 06:44:01 -0700 (PDT)
Message-ID: <6183e3a1.1c69fb81.36a1.2126@mx.google.com>
Date:   Thu, 04 Nov 2021 06:44:01 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.4
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.4.291-2-gade48a790ccd
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.4 baseline: 102 runs,
 2 regressions (v4.4.291-2-gade48a790ccd)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 baseline: 102 runs, 2 regressions (v4.4.291-2-gade48a79=
0ccd)

Regressions Summary
-------------------

platform    | arch   | lab           | compiler | defconfig                =
    | regressions
------------+--------+---------------+----------+--------------------------=
----+------------
panda       | arm    | lab-collabora | gcc-10   | omap2plus_defconfig      =
    | 1          =

qemu_x86_64 | x86_64 | lab-collabora | gcc-10   | x86_64_defcon...6-chromeb=
ook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.4/kern=
el/v4.4.291-2-gade48a790ccd/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.4
  Describe: v4.4.291-2-gade48a790ccd
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      ade48a790ccd6d8dba66231065194c831b62a02a =



Test Regressions
---------------- =



platform    | arch   | lab           | compiler | defconfig                =
    | regressions
------------+--------+---------------+----------+--------------------------=
----+------------
panda       | arm    | lab-collabora | gcc-10   | omap2plus_defconfig      =
    | 1          =


  Details:     https://kernelci.org/test/plan/id/6183ad5042429cccef3358ef

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.291-2=
-gade48a790ccd/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.291-2=
-gade48a790ccd/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/6183ad5042429cc=
cef3358f2
        new failure (last pass: v4.4.291-1-g1f67e88441a0)
        2 lines

    2021-11-04T09:51:57.445576  [   19.007537] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-11-04T09:51:57.491918  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/122
    2021-11-04T09:51:57.500564  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
25c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0
    2021-11-04T09:51:57.516611  [   19.081390] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =



platform    | arch   | lab           | compiler | defconfig                =
    | regressions
------------+--------+---------------+----------+--------------------------=
----+------------
qemu_x86_64 | x86_64 | lab-collabora | gcc-10   | x86_64_defcon...6-chromeb=
ook | 1          =


  Details:     https://kernelci.org/test/plan/id/6183accfa3724179883358e7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.291-2=
-gade48a790ccd/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/=
baseline-qemu_x86_64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.291-2=
-gade48a790ccd/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/=
baseline-qemu_x86_64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6183accfa372417988335=
8e8
        new failure (last pass: v4.4.291-1-g1f67e88441a0) =

 =20
