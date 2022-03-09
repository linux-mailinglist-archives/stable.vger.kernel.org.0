Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EAC5D4D27C4
	for <lists+stable@lfdr.de>; Wed,  9 Mar 2022 05:07:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229454AbiCIEHd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Mar 2022 23:07:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbiCIEHc (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Mar 2022 23:07:32 -0500
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42EA515F35C
        for <stable@vger.kernel.org>; Tue,  8 Mar 2022 20:06:34 -0800 (PST)
Received: by mail-pf1-x435.google.com with SMTP id g1so1192795pfv.1
        for <stable@vger.kernel.org>; Tue, 08 Mar 2022 20:06:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=TScXq0qIXAJM8bK2tyhaKSKNUleKVO3V+x9Nw2c1Sms=;
        b=LSr0MTWPuBvIfRV4otzGMwiEfzfCuNsJR0Z4zKHKNQHezWBKQZN4R7aBP2QZUiW7Id
         MU8ISF1KXM+xp+KUpLrIBGlhKN8kl6X8S1td//fXol46g9NVppiQwhMqsr5R5aiYdXP2
         1U87EnmcE/mK8iAfK2tLY8j6gkqLikblpvbcPuQeaZ8TiDYAQ0HFXJpEkJ0BHwkv2T/z
         auCxiySaoeG+9wMXJBvO6HrB0tqKl/QMv6nTWT19dm7FsYIwC4ZRfmo2ElNhR+CmzWyH
         BXqOXN+shMcLBntwwur6rJJG/a1eaGXQkgYTVhz3q/PPxHjRiYk9XI93B0dxJ4duKRHo
         zUZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=TScXq0qIXAJM8bK2tyhaKSKNUleKVO3V+x9Nw2c1Sms=;
        b=jpQ5sAoPq95tn4o8Jx3s4VRjGK6DcxNPRCOjPZntz4lcbXC7n9d2qLRTML3cs96hm/
         k5M57eJVG/1AMWJVQF2Rhz+iokj1PXnJT3LCRYl3OeO/+stEz0GtocFraK9BNWyAf1Iz
         guQ2hAl6BEv5x6Wo9VaxnwU+z+n/hAqnqQ2LcSnQ+owYj09Co4nYhKFlr1K3wP2dNSi6
         0D4kZoDmFKb7qUuNXWyllPdTvDmyY8rai5JrITlqgcJ3w1mzO57/I2OxvhW0tVtqwca1
         va0Zmgg4PvZAjhRg2jwV4J+5P60sV4Zf3XVMJjFAyQz5VPk41RKFCCQlqtIOOXfbmoNC
         AjJA==
X-Gm-Message-State: AOAM532GpNrrOxv8RjS0m9dfdld5aD5V69Ef7WQu5x85BSnai2fLTAy6
        TnK1FrFLDOjfXLEeHM2Bto3MBXdRuysS6TKWcgA=
X-Google-Smtp-Source: ABdhPJyhI6HDs6mD+3RiD/9StaDqvQagF7h2krbSPzN+34n74Wu/Mr6asp9HFXBiL2LiQSzqwftStw==
X-Received: by 2002:a63:c1d:0:b0:365:7d16:f648 with SMTP id b29-20020a630c1d000000b003657d16f648mr17131790pgl.517.1646798793604;
        Tue, 08 Mar 2022 20:06:33 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id h16-20020a17090a055000b001bf5ad0e45esm605752pjf.43.2022.03.08.20.06.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Mar 2022 20:06:33 -0800 (PST)
Message-ID: <622827c9.1c69fb81.8cf15.25a0@mx.google.com>
Date:   Tue, 08 Mar 2022 20:06:33 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.4
X-Kernelci-Kernel: v5.4.183-18-ge53e4ce48616
Subject: stable-rc/queue/5.4 baseline: 43 runs,
 3 regressions (v5.4.183-18-ge53e4ce48616)
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

stable-rc/queue/5.4 baseline: 43 runs, 3 regressions (v5.4.183-18-ge53e4ce4=
8616)

Regressions Summary
-------------------

platform                 | arch  | lab           | compiler | defconfig    =
              | regressions
-------------------------+-------+---------------+----------+--------------=
--------------+------------
qemu_arm-virt-gicv2-uefi | arm   | lab-baylibre  | gcc-10   | multi_v7_defc=
onfig         | 1          =

qemu_arm-virt-gicv3-uefi | arm   | lab-baylibre  | gcc-10   | multi_v7_defc=
onfig         | 1          =

rk3399-gru-kevin         | arm64 | lab-collabora | gcc-10   | defconfig+arm=
64-chromebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.183-18-ge53e4ce48616/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.183-18-ge53e4ce48616
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      e53e4ce486167f8081d88b2008748b6112170bd4 =



Test Regressions
---------------- =



platform                 | arch  | lab           | compiler | defconfig    =
              | regressions
-------------------------+-------+---------------+----------+--------------=
--------------+------------
qemu_arm-virt-gicv2-uefi | arm   | lab-baylibre  | gcc-10   | multi_v7_defc=
onfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/6227f08e74b38af657c62970

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.183-1=
8-ge53e4ce48616/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.183-1=
8-ge53e4ce48616/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6227f08e74b38af657c62=
971
        failing since 83 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch  | lab           | compiler | defconfig    =
              | regressions
-------------------------+-------+---------------+----------+--------------=
--------------+------------
qemu_arm-virt-gicv3-uefi | arm   | lab-baylibre  | gcc-10   | multi_v7_defc=
onfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/6227f07822a3e2281dc62973

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.183-1=
8-ge53e4ce48616/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.183-1=
8-ge53e4ce48616/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6227f07822a3e2281dc62=
974
        failing since 83 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch  | lab           | compiler | defconfig    =
              | regressions
-------------------------+-------+---------------+----------+--------------=
--------------+------------
rk3399-gru-kevin         | arm64 | lab-collabora | gcc-10   | defconfig+arm=
64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6227f70b7969904967c6296f

  Results:     88 PASS, 2 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.183-1=
8-ge53e4ce48616/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/basel=
ine-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.183-1=
8-ge53e4ce48616/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/basel=
ine-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/6227f70c7969904967c62995
        failing since 3 days (last pass: v5.4.182-30-g45ccd59cc16f, first f=
ail: v5.4.182-53-ge31c0b084082)

    2022-03-09T00:38:21.578339  <8>[   30.362739] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s0-probed RESULT=3Dpass>
    2022-03-09T00:38:22.590873  /lava-5841943/1/../bin/lava-test-case   =

 =20
