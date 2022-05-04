Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A854F519303
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 02:50:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244783AbiEDAyD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 May 2022 20:54:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244862AbiEDAyB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 May 2022 20:54:01 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E798713F64
        for <stable@vger.kernel.org>; Tue,  3 May 2022 17:50:26 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id m14-20020a17090a34ce00b001d5fe250e23so3395104pjf.3
        for <stable@vger.kernel.org>; Tue, 03 May 2022 17:50:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=NTI39wgtO4WgqUC55YtF27siiWuSxvBo5XittTd0/dY=;
        b=AtXHJPZdJqPI/cBC4UKTi8UJf1OqsRY15fWe8gCGGzup9xeT/kEU/OycClRxE2oD2V
         ePw90CqGyM8kCM1D4KO2R0+4hbYibnSwfDD4qC5soe9oT7SaDit8pNrJQPQug0lPIBDT
         tSONuVRHY2PKUmk6xwCOuJi4vkGtT2g/zcF3kDi1FLefbKRmYBWJZLD67qZ1pPJhLdm+
         0UqSdAW06/j0iCQhRhqNPs79hGRS27KxZH+u8yAiu7opkCqOVeyr+w9AgOCym5XJNeRa
         iaf514FckEj+0QTGhEpG5HlGmLhvz5aMfCPen5uImbFgVazSLX26Mk+fZUaqCK+CC+xL
         NJmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=NTI39wgtO4WgqUC55YtF27siiWuSxvBo5XittTd0/dY=;
        b=ohrxZEEI5KSFjS26MZYfe0sLnCVnjYbZM5SXmKGmM9yMSGudWgdE7flH3sHeCkXu9j
         kav4PsuuiJmOLy3lxJLPzhmH7Uvw/L1T8XfyPJ06altQ0hCBhC/YtbkXHhv99hNa0SSY
         fB9E3gPYzt26U1zMi2Fzi1yNUCIkXlWAm0aNKAuE8NXPR3EZK39QYOICfb8hAJDmeiYe
         rN7nOzQ3fPDUfJWyGjPbraqtAvTOtkk8JrjoNSwBwB9UiFZHCUfUrAl0IfeRa86FGU+/
         FAVlsDgse8qXZtZVcG82tqEn39RoRvuTF40HpFLhtYoWaKl2Ph5lHygD1100ar903jNS
         aptw==
X-Gm-Message-State: AOAM533TPE5n5KUsMF7avV/bzJ62Q9/l5jTl0J5LU+jpmm5jLJrvFCST
        9QAHVM6lZYEHsqlbOrqEbV7YG7VUXwGloqrQXNg=
X-Google-Smtp-Source: ABdhPJxvtYHe5HYmVhiUmDHXF6ILCoF8KXcg6AvbCJsX3tQD3OwOpbpsPuBnzr4Vq+44guBg52N+HA==
X-Received: by 2002:a17:903:2d0:b0:14d:8a8d:cb1 with SMTP id s16-20020a17090302d000b0014d8a8d0cb1mr19228243plk.50.1651625426084;
        Tue, 03 May 2022 17:50:26 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id x21-20020a1709027c1500b0015e8d4eb202sm6927936pll.76.2022.05.03.17.50.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 May 2022 17:50:25 -0700 (PDT)
Message-ID: <6271cdd1.1c69fb81.d4582.18da@mx.google.com>
Date:   Tue, 03 May 2022 17:50:25 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.4.191-82-gdf7386ca7c98
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/5.4
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.4 baseline: 89 runs,
 4 regressions (v5.4.191-82-gdf7386ca7c98)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 89 runs, 4 regressions (v5.4.191-82-gdf7386ca=
7c98)

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
el/v5.4.191-82-gdf7386ca7c98/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.191-82-gdf7386ca7c98
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      df7386ca7c981fd8ff7a87d986e4ee0adcbfd1e3 =



Test Regressions
---------------- =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv2-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/62713d45edf3dd0308dc7ba1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.191-8=
2-gdf7386ca7c98/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.191-8=
2-gdf7386ca7c98/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220428.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62713d45edf3dd0308dc7=
ba2
        failing since 138 days (last pass: v5.4.165-9-g27d736c7bdee, first =
fail: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv2-uefi | arm  | lab-broonie  | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/62713d504bdcecb848dc7b34

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.191-8=
2-gdf7386ca7c98/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm=
-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.191-8=
2-gdf7386ca7c98/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm=
-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220428.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62713d504bdcecb848dc7=
b35
        failing since 138 days (last pass: v5.4.165-9-g27d736c7bdee, first =
fail: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv3-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/62713d31edf3dd0308dc7b2a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.191-8=
2-gdf7386ca7c98/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.191-8=
2-gdf7386ca7c98/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220428.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62713d31edf3dd0308dc7=
b2b
        failing since 138 days (last pass: v5.4.165-9-g27d736c7bdee, first =
fail: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv3-uefi | arm  | lab-broonie  | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/62713d4e4bdcecb848dc7b2d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.191-8=
2-gdf7386ca7c98/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm=
-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.191-8=
2-gdf7386ca7c98/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm=
-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220428.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62713d4e4bdcecb848dc7=
b2e
        failing since 138 days (last pass: v5.4.165-9-g27d736c7bdee, first =
fail: v5.4.165-18-ge938927511cb) =

 =20
