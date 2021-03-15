Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6C7B33AC2F
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 08:27:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229828AbhCOH1F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 03:27:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229644AbhCOH0x (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Mar 2021 03:26:53 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1653DC061574
        for <stable@vger.kernel.org>; Mon, 15 Mar 2021 00:26:53 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id s21so8291326pjq.1
        for <stable@vger.kernel.org>; Mon, 15 Mar 2021 00:26:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=zMGS47GBWOYAL5eiZN90+8hgiY6W3NdcR2WoidhwhKg=;
        b=xmhO/pupgXZP6GjIiK6xRLCfPBwPRBVidQkJl7qhLYuCvwybjuIJpnxuV/rm60aqxQ
         AmXR+6+54Hpo8h9PjXT8JEOwLuyCDKYj6IDxBebot6BRmCVbsqmTSlo2PxUbcUY/u/1p
         Lx0EThcuL6e3n2IPUVKN4gzWkNeWyV0ICdjfVfu1g3IDOMQwBVfsfQYRQNZeRzexgAFP
         Tgdm+ehHLjA7g4klE89BlE/SMWsdbT6cCpAKxLrgUXWhIX252C9t+jstFpstIVnYKEJK
         0d7k1i0j2Tx5Z8s85a2x3s+JHGeUtDBQaFQYn6GJBt/rYEnOStBRlkrJJeNW/jj1YWfh
         r32Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=zMGS47GBWOYAL5eiZN90+8hgiY6W3NdcR2WoidhwhKg=;
        b=M3CmeJJ9pC/7Eq8WRdZvwj8gDB8c0LHzWdBs2yxjhqLHBxRff2BJ8/TkLp0aT1Iu9D
         +w3PwsRsmgV+PWYs4AmSJ5y+5qjsk9KXZQc74wth9c1gI/rHIcrZYyj49QPUzpUcFcol
         X5zaLm9hzKmyXuSNL8P2hI2t2JZQ8gBM0mBzM/ob/5t13ReMep7c3/zbhBdhPCNtmPqn
         w7NUO9o+ukgJrkrjoPHO6gCn+rLr26af7ekaSrcUHzasaqgCnE1Sqs+yQwLEp1Aubhcf
         A9JWiKqgsgn/4V7reCm72vr+rJf9LMwGkUEd9f7iXX+nCqLcupzMJf7CE9rFJ0FRmBPP
         lZZg==
X-Gm-Message-State: AOAM532DPDQm0YyzFfycZ0mkjOerVaX0eR0GgDlp8CWKOWcGRWdSa5ls
        u/7Ra0J0Z9gx2+LiOuJ6txDI20nNVi+Iaw==
X-Google-Smtp-Source: ABdhPJwGdpoR4scMcoJgkYclWYy/JFbI2c3XDXQNZsbqoD6HoAjZEBZysFHh3WYwDUNtKkK+Zy+MZA==
X-Received: by 2002:a17:902:aa87:b029:e5:e1fc:be6 with SMTP id d7-20020a170902aa87b02900e5e1fc0be6mr10868623plr.4.1615793212297;
        Mon, 15 Mar 2021 00:26:52 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id gw20sm9590127pjb.3.2021.03.15.00.26.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Mar 2021 00:26:51 -0700 (PDT)
Message-ID: <604f0c3b.1c69fb81.d91b5.75ed@mx.google.com>
Date:   Mon, 15 Mar 2021 00:26:51 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.4.261-60-gf1287cdd62df
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.4
Subject: stable-rc/queue/4.4 baseline: 80 runs,
 10 regressions (v4.4.261-60-gf1287cdd62df)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 baseline: 80 runs, 10 regressions (v4.4.261-60-gf1287cd=
d62df)

Regressions Summary
-------------------

platform            | arch | lab             | compiler | defconfig        =
   | regressions
--------------------+------+-----------------+----------+------------------=
---+------------
dove-cubox          | arm  | lab-pengutronix | gcc-8    | mvebu_v7_defconfi=
g  | 1          =

panda               | arm  | lab-collabora   | gcc-8    | omap2plus_defconf=
ig | 1          =

qemu_arm-virt-gicv2 | arm  | lab-broonie     | gcc-8    | multi_v7_defconfi=
g  | 1          =

qemu_arm-virt-gicv2 | arm  | lab-cip         | gcc-8    | multi_v7_defconfi=
g  | 1          =

qemu_arm-virt-gicv2 | arm  | lab-collabora   | gcc-8    | multi_v7_defconfi=
g  | 1          =

qemu_arm-virt-gicv2 | arm  | lab-linaro-lkft | gcc-8    | multi_v7_defconfi=
g  | 1          =

qemu_arm-virt-gicv3 | arm  | lab-broonie     | gcc-8    | multi_v7_defconfi=
g  | 1          =

qemu_arm-virt-gicv3 | arm  | lab-cip         | gcc-8    | multi_v7_defconfi=
g  | 1          =

qemu_arm-virt-gicv3 | arm  | lab-collabora   | gcc-8    | multi_v7_defconfi=
g  | 1          =

qemu_arm-virt-gicv3 | arm  | lab-linaro-lkft | gcc-8    | multi_v7_defconfi=
g  | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.4/kern=
el/v4.4.261-60-gf1287cdd62df/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.4
  Describe: v4.4.261-60-gf1287cdd62df
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      f1287cdd62df8fc1acefa7fde8383a35317f75d6 =



Test Regressions
---------------- =



platform            | arch | lab             | compiler | defconfig        =
   | regressions
--------------------+------+-----------------+----------+------------------=
---+------------
dove-cubox          | arm  | lab-pengutronix | gcc-8    | mvebu_v7_defconfi=
g  | 1          =


  Details:     https://kernelci.org/test/plan/id/604ed9f01c52cd263daddcbe

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: mvebu_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.261-6=
0-gf1287cdd62df/arm/mvebu_v7_defconfig/gcc-8/lab-pengutronix/baseline-dove-=
cubox.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.261-6=
0-gf1287cdd62df/arm/mvebu_v7_defconfig/gcc-8/lab-pengutronix/baseline-dove-=
cubox.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/604ed9f01c52cd263dadd=
cbf
        new failure (last pass: v4.4.261-57-g138a2a2eb950f) =

 =



platform            | arch | lab             | compiler | defconfig        =
   | regressions
--------------------+------+-----------------+----------+------------------=
---+------------
panda               | arm  | lab-collabora   | gcc-8    | omap2plus_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/604edb4616b749cba9addcde

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.261-6=
0-gf1287cdd62df/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.261-6=
0-gf1287cdd62df/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/604edb4616b749c=
ba9addce3
        failing since 2 days (last pass: v4.4.261-18-g7637372647e6, first f=
ail: v4.4.261-18-g7adf316e7123c)
        2 lines

    2021-03-15 03:57:54.713000+00:00  kern  :emerg : BUG: spinlock bad magi=
c on CPU#0, kworker/0:1/17
    2021-03-15 03:57:54.722000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xfffff26c [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =



platform            | arch | lab             | compiler | defconfig        =
   | regressions
--------------------+------+-----------------+----------+------------------=
---+------------
qemu_arm-virt-gicv2 | arm  | lab-broonie     | gcc-8    | multi_v7_defconfi=
g  | 1          =


  Details:     https://kernelci.org/test/plan/id/604edaa488a57a3ff5addcd1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.261-6=
0-gf1287cdd62df/arm/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-=
virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.261-6=
0-gf1287cdd62df/arm/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-=
virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/604edaa488a57a3ff5add=
cd2
        failing since 121 days (last pass: v4.4.243-18-gfc7e8c68369a, first=
 fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch | lab             | compiler | defconfig        =
   | regressions
--------------------+------+-----------------+----------+------------------=
---+------------
qemu_arm-virt-gicv2 | arm  | lab-cip         | gcc-8    | multi_v7_defconfi=
g  | 1          =


  Details:     https://kernelci.org/test/plan/id/604edb315164580136addcbf

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.261-6=
0-gf1287cdd62df/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-virt=
-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.261-6=
0-gf1287cdd62df/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-virt=
-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/604edb315164580136add=
cc0
        failing since 121 days (last pass: v4.4.243-18-gfc7e8c68369a, first=
 fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch | lab             | compiler | defconfig        =
   | regressions
--------------------+------+-----------------+----------+------------------=
---+------------
qemu_arm-virt-gicv2 | arm  | lab-collabora   | gcc-8    | multi_v7_defconfi=
g  | 1          =


  Details:     https://kernelci.org/test/plan/id/604eda80fad01ad21eaddcce

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.261-6=
0-gf1287cdd62df/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-qemu_ar=
m-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.261-6=
0-gf1287cdd62df/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-qemu_ar=
m-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/604eda80fad01ad21eadd=
ccf
        failing since 121 days (last pass: v4.4.243-18-gfc7e8c68369a, first=
 fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch | lab             | compiler | defconfig        =
   | regressions
--------------------+------+-----------------+----------+------------------=
---+------------
qemu_arm-virt-gicv2 | arm  | lab-linaro-lkft | gcc-8    | multi_v7_defconfi=
g  | 1          =


  Details:     https://kernelci.org/test/plan/id/604eda9d325457dcd3addcc1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.261-6=
0-gf1287cdd62df/arm/multi_v7_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_=
arm-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.261-6=
0-gf1287cdd62df/arm/multi_v7_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_=
arm-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/604eda9d325457dcd3add=
cc2
        failing since 121 days (last pass: v4.4.243-18-gfc7e8c68369a, first=
 fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch | lab             | compiler | defconfig        =
   | regressions
--------------------+------+-----------------+----------+------------------=
---+------------
qemu_arm-virt-gicv3 | arm  | lab-broonie     | gcc-8    | multi_v7_defconfi=
g  | 1          =


  Details:     https://kernelci.org/test/plan/id/604edaa3fc3e49cb6baddccd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.261-6=
0-gf1287cdd62df/arm/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-=
virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.261-6=
0-gf1287cdd62df/arm/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-=
virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/604edaa3fc3e49cb6badd=
cce
        failing since 121 days (last pass: v4.4.243-18-gfc7e8c68369a, first=
 fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch | lab             | compiler | defconfig        =
   | regressions
--------------------+------+-----------------+----------+------------------=
---+------------
qemu_arm-virt-gicv3 | arm  | lab-cip         | gcc-8    | multi_v7_defconfi=
g  | 1          =


  Details:     https://kernelci.org/test/plan/id/604eda9d88a57a3ff5addcc0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.261-6=
0-gf1287cdd62df/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-virt=
-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.261-6=
0-gf1287cdd62df/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-virt=
-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/604eda9d88a57a3ff5add=
cc1
        failing since 121 days (last pass: v4.4.243-18-gfc7e8c68369a, first=
 fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch | lab             | compiler | defconfig        =
   | regressions
--------------------+------+-----------------+----------+------------------=
---+------------
qemu_arm-virt-gicv3 | arm  | lab-collabora   | gcc-8    | multi_v7_defconfi=
g  | 1          =


  Details:     https://kernelci.org/test/plan/id/604eda83fad01ad21eaddcd3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.261-6=
0-gf1287cdd62df/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-qemu_ar=
m-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.261-6=
0-gf1287cdd62df/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-qemu_ar=
m-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/604eda83fad01ad21eadd=
cd4
        failing since 121 days (last pass: v4.4.243-18-gfc7e8c68369a, first=
 fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch | lab             | compiler | defconfig        =
   | regressions
--------------------+------+-----------------+----------+------------------=
---+------------
qemu_arm-virt-gicv3 | arm  | lab-linaro-lkft | gcc-8    | multi_v7_defconfi=
g  | 1          =


  Details:     https://kernelci.org/test/plan/id/604eda9c325457dcd3addcbe

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.261-6=
0-gf1287cdd62df/arm/multi_v7_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_=
arm-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.261-6=
0-gf1287cdd62df/arm/multi_v7_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_=
arm-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/604eda9c325457dcd3add=
cbf
        failing since 121 days (last pass: v4.4.243-18-gfc7e8c68369a, first=
 fail: v4.4.243-19-g71b6c961c7fe) =

 =20
