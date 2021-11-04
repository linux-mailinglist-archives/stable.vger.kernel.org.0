Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 809BD445C99
	for <lists+stable@lfdr.de>; Fri,  5 Nov 2021 00:19:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230373AbhKDXW0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Nov 2021 19:22:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229596AbhKDXWZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 4 Nov 2021 19:22:25 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55AA5C061714
        for <stable@vger.kernel.org>; Thu,  4 Nov 2021 16:19:47 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id r28so6784075pga.0
        for <stable@vger.kernel.org>; Thu, 04 Nov 2021 16:19:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=BLUBE9SHkVSDY1EYGtlWTU0CyY/ONBJ3/UTvptDSntE=;
        b=Ykz6cDyveEQJxehv07DJO3VPv+gUCrsw+LoQD0E+4QyNXLLSsUbOSpi1UiME55msqh
         CNRxR+DSMudukQKROJfHSeI7wcm0S5yPk7qm0xqGTm/mtTwIGKH59T8BirNSSO9RwSjc
         qyprn5rxOWafbPtqo5gCThm9ES3orzr3EoPnxXCgZPYjwOdqTlgHmYBT3+IEe4UuyvdK
         DrQvKx03mF6hg3VqsoR6YVBTrOyCXxafb7NDII/lX89E2yzPlPg0NmgaRPsKYDKnvit+
         w4RRx5i4JcGLIJThaHLO+ITzyp53zYBzltimYh6i90fi5ovw9Mg6tKkmUZh1K6Ht1/mi
         +m5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=BLUBE9SHkVSDY1EYGtlWTU0CyY/ONBJ3/UTvptDSntE=;
        b=er/TUVgIeYgpt6TO8Tt2aTQK9IEpp4iL4vCNxMsnbonoUMxtTxS2oL1uK8xllN5dJn
         0loD+C9vFq1vSeSS95pfuCLV3bc5XwLwFk2PK/jpmnSXaHdskcqDipENZFQIKwjnRv4i
         WdC/RWzsAUWqSnamih5IlTodVDUob8SpwsajhdCo6+F5dS/MbbAbs+iAivIT/tJ/vp5W
         +4XXxYzpqmVMKb4K0mUvuXnud2UZlR8WGHXTu/0agdA0CbKeaWbefYrm3TThJc6jAqDK
         31Y3pH3x2WToYRenlNRMPg7PrV23bWqGYs9UYIiOGXH79ayCAo41fJ/jozrBvoenckxa
         1Jvw==
X-Gm-Message-State: AOAM5320V6co9rvk+wXUiFeQSg46uBmhO5LPBz+lFNGMuo8IGlc/SlG/
        7m+Xuk7/tdmlkpRBeb7a9kcsUllIqoJt1lW7
X-Google-Smtp-Source: ABdhPJyMG/Q1o675BcmjuownsJeYVO4GfY68cmsaZTfBCGPMLEqHgCMDrnJrQJ6/rSiA45KrDFEGIw==
X-Received: by 2002:a65:5382:: with SMTP id x2mr41276722pgq.176.1636067986574;
        Thu, 04 Nov 2021 16:19:46 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id p14sm4779944pjl.32.2021.11.04.16.19.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Nov 2021 16:19:46 -0700 (PDT)
Message-ID: <61846a92.1c69fb81.59f79.fe85@mx.google.com>
Date:   Thu, 04 Nov 2021 16:19:46 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.14.254-8-g158dfc742cc7
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-4.14.y baseline: 122 runs,
 1 regressions (v4.14.254-8-g158dfc742cc7)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y baseline: 122 runs, 1 regressions (v4.14.254-8-g158d=
fc742cc7)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.14.y/ker=
nel/v4.14.254-8-g158dfc742cc7/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.14.y
  Describe: v4.14.254-8-g158dfc742cc7
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      158dfc742cc76f9b8e02f451001d3ccb1bc3f7fa =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/618437a27eb1e81dbd335979

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
54-8-g158dfc742cc7/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pa=
nda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
54-8-g158dfc742cc7/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pa=
nda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/618437a27eb1e81=
dbd33597c
        failing since 1 day (last pass: v4.14.253-26-g64fad352ab39, first f=
ail: v4.14.254)
        2 lines

    2021-11-04T19:42:04.591506  [   19.854858] smsc95xx 3-1.1:1.0 eth0: reg=
ister 'smsc95xx' at usb-4a064c00.ehci-1.1, smsc95xx USB 2.0 Ethernet, 8e:98=
:56:e5:c0:19
    2021-11-04T19:42:04.597712  [   19.868621] usbcore: registered new inte=
rface driver smsc95xx
    2021-11-04T19:42:04.625162  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/98
    2021-11-04T19:42:04.634469  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
d3c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
