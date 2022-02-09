Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 170F64AFB70
	for <lists+stable@lfdr.de>; Wed,  9 Feb 2022 19:47:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240605AbiBISrX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Feb 2022 13:47:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241148AbiBISqd (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Feb 2022 13:46:33 -0500
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89A37C03BFF2
        for <stable@vger.kernel.org>; Wed,  9 Feb 2022 10:43:47 -0800 (PST)
Received: by mail-pf1-x436.google.com with SMTP id x15so3398739pfr.5
        for <stable@vger.kernel.org>; Wed, 09 Feb 2022 10:43:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=XbIaaG8rvIMd5/OrBudn6xRjeqQwPwKuv5fgp01bZRI=;
        b=R90DpUqdTgX95MtCf9rsa5gyB5ccRxJJZNwpA6LHCHh7aaBTMfpnkwciHCVh9cYqLc
         bUxep6uXzdrWsPVsALncHAwzKAx2N9eh5qw/jGXKQGEe+BGXy1bObUC6RXybwVYRtoNq
         0aQr31jTCUS0Ctg/GGs0XHRO0m9MMehZM6dQI4qKedMo35BuL6x9JfuL+iS1hBLXPIDM
         +T04YKnpFxCDLO5UJNZvGSdHL+SOPuu/KYHe8+To+LzWWr+DGrxjRKIeuKXoVfreKR/Z
         vyFMxXrPWCZn7U//BbxyzzKcP9caUFKpfcB7oBsq7vm2P1bhtKy3vEkfrJW7r6K1eMbC
         zXBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=XbIaaG8rvIMd5/OrBudn6xRjeqQwPwKuv5fgp01bZRI=;
        b=XfZej481ovPgQNPbIZ+sQ1tJ+qXBignE+Zg13gBCo+vcRv6Z92JcyJ6rjfaa92F1/u
         85q4M+j+jfpdZMyakfUmNkqxVlf7T0TglQanm8hB7xt5IAsIis+MRgsUKIypNM9xt6V4
         fmPSazwppLW1byVoV9GtGGRq0kbbz0M/3UrFBkxeBNCtspQY0YY1+yV/q1ZM/GgNs3su
         AqDUK1Q3hIrVK8jG46CXa7+kl7AmFYcmvsGukE0I2A69Jz78HP4THx8oEnogZjdTxhsp
         oEKC7jCXYHRKExlAEBTN/3wWVbb5C/32U1tsrpFtVXkAZskpyIhKXFqhlrlH8IU9UNHx
         JA5g==
X-Gm-Message-State: AOAM532S4TsZ4nh5YSMIdEr/LllmQwBoJ6R+cn8kjgSDKBTdgkRRexzB
        /JRctdOgk9xkf6tYINmszogNJYT/yoIBY4RKPtc=
X-Google-Smtp-Source: ABdhPJxVqSSQNa1EbnUE6y7rn+7ET9G+Ek3M8YJ9B8ippFoDPgrAIvB4/kfsAyczcUe0KBflA/Dxvg==
X-Received: by 2002:a63:ed17:: with SMTP id d23mr2904368pgi.543.1644432218709;
        Wed, 09 Feb 2022 10:43:38 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id l21sm20805106pfu.120.2022.02.09.10.43.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Feb 2022 10:43:38 -0800 (PST)
Message-ID: <62040b5a.1c69fb81.bd18b.34b0@mx.google.com>
Date:   Wed, 09 Feb 2022 10:43:38 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.4
X-Kernelci-Kernel: v5.4.177-46-g8a38e8a8e400
Subject: stable-rc/queue/5.4 baseline: 82 runs,
 4 regressions (v5.4.177-46-g8a38e8a8e400)
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

stable-rc/queue/5.4 baseline: 82 runs, 4 regressions (v5.4.177-46-g8a38e8a8=
e400)

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
el/v5.4.177-46-g8a38e8a8e400/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.177-46-g8a38e8a8e400
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      8a38e8a8e4005ce4e86d289ba2ab54199144d2ed =



Test Regressions
---------------- =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv2-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6203cf7ddcbf9a1dc5c629b1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.177-4=
6-g8a38e8a8e400/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.177-4=
6-g8a38e8a8e400/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6203cf7ddcbf9a1dc5c62=
9b2
        failing since 55 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv2-uefi | arm  | lab-broonie  | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6203cfa0aecd1494f2c629cb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.177-4=
6-g8a38e8a8e400/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm=
-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.177-4=
6-g8a38e8a8e400/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm=
-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6203cfa0aecd1494f2c62=
9cc
        failing since 55 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv3-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6203cf7faecd1494f2c6296c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.177-4=
6-g8a38e8a8e400/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.177-4=
6-g8a38e8a8e400/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6203cf7faecd1494f2c62=
96d
        failing since 55 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv3-uefi | arm  | lab-broonie  | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6203cfa190616f41aec6299c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.177-4=
6-g8a38e8a8e400/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm=
-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.177-4=
6-g8a38e8a8e400/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm=
-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6203cfa190616f41aec62=
99d
        failing since 55 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =20
