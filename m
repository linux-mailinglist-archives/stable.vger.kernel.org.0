Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7338F458FF3
	for <lists+stable@lfdr.de>; Mon, 22 Nov 2021 15:06:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231307AbhKVOJv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Nov 2021 09:09:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230322AbhKVOJv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Nov 2021 09:09:51 -0500
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD9A5C061574
        for <stable@vger.kernel.org>; Mon, 22 Nov 2021 06:06:44 -0800 (PST)
Received: by mail-pl1-x632.google.com with SMTP id b13so14207486plg.2
        for <stable@vger.kernel.org>; Mon, 22 Nov 2021 06:06:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=/rJ9V3Qk5dVJLQYJLiJAK2TN9oayPMadeu1IAKMgPoE=;
        b=qFSjb7IMINQR9tWitOL0dxIbLZTZKBAcR7Sd8CLdT0q8Xb+kw8zKTiSZrAg2o8++wJ
         nVs9nku06DvIa5KqfFptfW1i/c/Tw4lIDPTPR2TU5TtFb8P4n3RMGl2rmqnuya+zoL15
         AcbD9GVJpw7z6sk6NbC5663QJSOiLPvek9KM0/ejDrsNZ70xCKHt7Ojf37jp6UG4UGLW
         E4NTFSY0W6iimgx4rUaePQy053Y/l4ygHW27/Vyv7qoSWnnMTMtah9C4H9UE6l/SpbQT
         Y62hqqOke61KgO2Wu+KFsvowK7PtJH9au6ZUaj2+XAUhZCGjZahKinCfqjNBSnaZ7/Uq
         ruhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=/rJ9V3Qk5dVJLQYJLiJAK2TN9oayPMadeu1IAKMgPoE=;
        b=n5XuDS66C9Q6+Vo0iRJzaQVFbMU9vhrR2EVNoat5KiCjpuvrKTW0P14sP2wEykpWdK
         eOwZF0UM1f2wmd71o9DzGiztXWLcabpQ4lCCSjR4/vDnch7YDAMg9ew9QIOHjEwTg30a
         IvqgGoqdbWrNJ2TCsiZUhtDjpFpUrgjtutkXASGjwyEK/QRE1c2wlM6XJrDqzVXRUS4+
         hp979QV1ukltNvUEkjxuBecUSTg5O7F2JMoGD723I8w+DQMoBa3rug43gTWCn/o2GOvl
         B24kvHSSOCn0xpYafq+Z1krIqt8KQlXVWkHSeAQEdWDDzh2t0Ew8rFi1W6vlhMQl+yMA
         vfpg==
X-Gm-Message-State: AOAM5317XGlT71zdHeTOM5eGRHbz/Vbibx4hEXffit8UmJVkH4yyhJd6
        ub9IxxIdS2bQhOqNpBLWtAz0nx2VTitX+aGm
X-Google-Smtp-Source: ABdhPJxUhJYjoJBaKtJuKmmfQJc81j9OUydpRfkkngmq/cIYSLb/E6rXDcXAF3Z1fH0RMu01/z05+g==
X-Received: by 2002:a17:902:7b8d:b0:143:95e3:7dc0 with SMTP id w13-20020a1709027b8d00b0014395e37dc0mr109270064pll.21.1637590004192;
        Mon, 22 Nov 2021 06:06:44 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id v15sm9863202pfu.195.2021.11.22.06.06.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Nov 2021 06:06:43 -0800 (PST)
Message-ID: <619ba3f3.1c69fb81.fe046.b1fb@mx.google.com>
Date:   Mon, 22 Nov 2021 06:06:43 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.290-189-gad0477933ff47
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/4.9
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.9 baseline: 115 runs,
 2 regressions (v4.9.290-189-gad0477933ff47)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 115 runs, 2 regressions (v4.9.290-189-gad0477=
933ff47)

Regressions Summary
-------------------

platform    | arch   | lab           | compiler | defconfig           | reg=
ressions
------------+--------+---------------+----------+---------------------+----=
--------
panda       | arm    | lab-collabora | gcc-10   | omap2plus_defconfig | 1  =
        =

qemu_x86_64 | x86_64 | lab-broonie   | gcc-10   | x86_64_defconfig    | 1  =
        =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.290-189-gad0477933ff47/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.290-189-gad0477933ff47
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      ad0477933ff47fcd4299328e505aa3fc653f6c6c =



Test Regressions
---------------- =



platform    | arch   | lab           | compiler | defconfig           | reg=
ressions
------------+--------+---------------+----------+---------------------+----=
--------
panda       | arm    | lab-collabora | gcc-10   | omap2plus_defconfig | 1  =
        =


  Details:     https://kernelci.org/test/plan/id/619b6d7c9d50d87fefe5521f

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.290-1=
89-gad0477933ff47/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.290-1=
89-gad0477933ff47/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/619b6d7c9d50d87=
fefe55225
        failing since 1 day (last pass: v4.9.290-161-ge496b1c75ac2, first f=
ail: v4.9.290-161-g520a4edb46f8)
        2 lines

    2021-11-22T10:14:07.046478  [   20.017181] smsc95xx 3-1.1:1.0 eth0: reg=
ister 'smsc95xx' at usb-4a064c00.ehci-1.1, smsc95xx USB 2.0 Ethernet, b6:89=
:67:51:3f:04
    2021-11-22T10:14:07.052888  [   20.029815] usbcore: registered new inte=
rface driver smsc95xx
    2021-11-22T10:14:07.093870  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/125
    2021-11-22T10:14:07.103036  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
230 [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =



platform    | arch   | lab           | compiler | defconfig           | reg=
ressions
------------+--------+---------------+----------+---------------------+----=
--------
qemu_x86_64 | x86_64 | lab-broonie   | gcc-10   | x86_64_defconfig    | 1  =
        =


  Details:     https://kernelci.org/test/plan/id/619b6e8589e94a0611e551ec

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.290-1=
89-gad0477933ff47/x86_64/x86_64_defconfig/gcc-10/lab-broonie/baseline-qemu_=
x86_64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.290-1=
89-gad0477933ff47/x86_64/x86_64_defconfig/gcc-10/lab-broonie/baseline-qemu_=
x86_64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/619b6e8589e94a0611e55=
1ed
        new failure (last pass: v4.9.290-189-gf792aae152288) =

 =20
