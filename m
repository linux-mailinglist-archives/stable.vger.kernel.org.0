Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AEB825030DD
	for <lists+stable@lfdr.de>; Sat, 16 Apr 2022 01:09:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356211AbiDOVoe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Apr 2022 17:44:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356119AbiDOVoS (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Apr 2022 17:44:18 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D7CD48303
        for <stable@vger.kernel.org>; Fri, 15 Apr 2022 14:41:22 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id 125so8652715pgc.11
        for <stable@vger.kernel.org>; Fri, 15 Apr 2022 14:41:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=8Ko1m09jvFX1VuhHAMAgdg2w0rHdTcCDF3fJuy9YVw4=;
        b=EcGRYETVlP531DrZfj2e6lIzGN1dCtcQ3EyRpa3gnAnbGbM+7Gft/nDwL0fy/aaLZu
         wWxL1L+mOgWv5Xe2bKh6giXDeVPPZ+JpnUU4Q7qp78CS0BkWq3S6jcyV3QtqGRhNhxCn
         EDE2cpMdCH0TmoHgXSLbsZkYsiHJIRXJBMePmeHb7zJBVkDDOJhcK0ry6lNuJ0Izfu1g
         HU6sgYCaY7cbvCt71MMSRFGf2WUxi/iCjmOo+GAShnx47PvSzBxZXVfKDKp0BB9p6A88
         Eez0/7tlhMfsmhh7aYQzAeFzdCPu2yLAdUEGA8gAqRMfi+J6xjcdZOnsbPBRDg0qQJdH
         h/ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=8Ko1m09jvFX1VuhHAMAgdg2w0rHdTcCDF3fJuy9YVw4=;
        b=aLXAxiPhvTbFfuC7CdbDWLkth8wnM6W9Lrfd696F8PqKwHVDm64NTAqFsSUu+Pfz2n
         AGMNAKhZXu9DoKqTGMu7LZcRTnPF88PnmF6tsXzZT2cK/8ZYKVa7G70lN0513p6KPtPH
         wEBtI682sm+wqQsD2XVU6kMJYIIw3wOhcGulmif2Neurp4csnAXC+TT7W2OuqfhkmH7k
         cwV6NfLA/LhqGmeXk6bcZybkU1fu4dNipsg1h3/8MTmvQl9RUkkjZB6jn51UEF1Z4BGA
         kdHXha/kRqBzkEP7EvhID7TKpRL1TRkfA16dLcgamDEQK4oN4LGdPFzYxlreViAQL+Et
         zBnA==
X-Gm-Message-State: AOAM5331qSdEJx/EXXtWElZjJTxjLP1do5Mq1SSIwBUY/lgzSb0sTIdi
        lL0/s5JB4a6G3k/l8Na3f28M/GGA5kK7YO+x
X-Google-Smtp-Source: ABdhPJwv0HI7mZOU/8x6DXY0kGC64sIZZg+YoeRn104HhEmJRKWHqFLe27FdnOPVg1IzJCtS+u6TPQ==
X-Received: by 2002:a65:5b8c:0:b0:39e:293a:7787 with SMTP id i12-20020a655b8c000000b0039e293a7787mr696809pgr.461.1650058881594;
        Fri, 15 Apr 2022 14:41:21 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id m15-20020a638c0f000000b003827bfe1f5csm5185340pgd.7.2022.04.15.14.41.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Apr 2022 14:41:20 -0700 (PDT)
Message-ID: <6259e680.1c69fb81.aaf33.df5f@mx.google.com>
Date:   Fri, 15 Apr 2022 14:41:20 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.4
X-Kernelci-Kernel: v5.4.188-472-g2a5c061fe182a
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.4 baseline: 128 runs,
 4 regressions (v5.4.188-472-g2a5c061fe182a)
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

stable-rc/queue/5.4 baseline: 128 runs, 4 regressions (v5.4.188-472-g2a5c06=
1fe182a)

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
el/v5.4.188-472-g2a5c061fe182a/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.188-472-g2a5c061fe182a
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      2a5c061fe182a528845cc9d00b0201b89274fd72 =



Test Regressions
---------------- =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv2-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6259b5264465879bcfae06d7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.188-4=
72-g2a5c061fe182a/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_=
arm-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.188-4=
72-g2a5c061fe182a/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_=
arm-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220401.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6259b5264465879bcfae0=
6d8
        failing since 120 days (last pass: v5.4.165-9-g27d736c7bdee, first =
fail: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv2-uefi | arm  | lab-broonie  | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6259b512c0f8fc05fdae068f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.188-4=
72-g2a5c061fe182a/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_a=
rm-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.188-4=
72-g2a5c061fe182a/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_a=
rm-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220401.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6259b512c0f8fc05fdae0=
690
        failing since 120 days (last pass: v5.4.165-9-g27d736c7bdee, first =
fail: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv3-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6259b53cbc3e848d5eae067c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.188-4=
72-g2a5c061fe182a/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_=
arm-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.188-4=
72-g2a5c061fe182a/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_=
arm-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220401.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6259b53cbc3e848d5eae0=
67d
        failing since 120 days (last pass: v5.4.165-9-g27d736c7bdee, first =
fail: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv3-uefi | arm  | lab-broonie  | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6259b5134465879bcfae067c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.188-4=
72-g2a5c061fe182a/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_a=
rm-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.188-4=
72-g2a5c061fe182a/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_a=
rm-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220401.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6259b5134465879bcfae0=
67d
        failing since 120 days (last pass: v5.4.165-9-g27d736c7bdee, first =
fail: v5.4.165-18-ge938927511cb) =

 =20
