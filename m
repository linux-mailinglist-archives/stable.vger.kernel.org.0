Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44D8043A7F2
	for <lists+stable@lfdr.de>; Tue, 26 Oct 2021 00:59:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233837AbhJYXBY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 19:01:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233747AbhJYXBT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 Oct 2021 19:01:19 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8150CC061745
        for <stable@vger.kernel.org>; Mon, 25 Oct 2021 15:58:48 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id s24so4951765plp.0
        for <stable@vger.kernel.org>; Mon, 25 Oct 2021 15:58:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=NmUqDiOtvhXteh50SZQXw7vA1L3j8I8a87Ll1PAHCQE=;
        b=qxdzkIqne4UHFLn5tM0ansS1fGAPDiDs2u1JTvYP0I3RGHqQuK8HLjomgYdK0P2d4G
         D0PB+L0E/Pkfb3UJjYLVcD+C9LXUNKeNIIOtnEcKtrsRdLHXQAbsleLgThQ4koma6yiY
         x0wuoXTZwe5zkSarMfmTZT5Vs95lteB69YSROLuiRj6Ka4kaBwFoEHnC0LCWZASiC/6S
         D0YO7HMQTFidEIddDqGQ7EY1Onr6nU1DxtGL9KfZGX82X32Ux1TdGOGZu/ihX4eiZXUn
         qEDLKmb5NFSSyxgqHq1imbNV2UvGf2pSKHTxPsduksvkuWMkPz1/TLAVL3RjwvYxMY+5
         ZWkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=NmUqDiOtvhXteh50SZQXw7vA1L3j8I8a87Ll1PAHCQE=;
        b=Yg3E1eUoh/R/9OBJIH06LrLOPP1fGWOz5LPuQJi/Z5rar27KNzavtB08bha99wpYIB
         8BZTWJPe4IIs2moKpCqzeEXX9pPNqME56n5lVD2tk2PlD/uSnn1D4Fxv4W+Lh8lGt3oE
         1Vv2Ej/USSDO79n2c5n8Xs/QE27fQ3aNHZbdHenYLninjd9Gppjk+q05Ou8LhWQo7phs
         Jt5u/f7dLBsT3V7rsIJCzgtVhD6U0iihYnX/UH5rk1rq1UsJLlaM11Lv1CvUYyMFNsnt
         yyEDhWTboZWrp+zA1xvKjNsMSYzt79Ren7/+7iNOXzWC8N/MEAjy6ycUUJFaz1z3b/l4
         V82g==
X-Gm-Message-State: AOAM533YoCZ4YozLtiDrhdltn7WVCkPyhkYbQLfshGu03fzIGcsP7MjA
        ifMYW7ic6V+l0VCrFx9dSy0u9V47t21KYUWU
X-Google-Smtp-Source: ABdhPJzDJO1N5THREMyn7nQyIjt9UarDbYYOLA6Yv5/9uCVam1wIdDcj3TDXq/CmTUodaSx4jTfrGw==
X-Received: by 2002:a17:90a:3e84:: with SMTP id k4mr6962847pjc.45.1635202727958;
        Mon, 25 Oct 2021 15:58:47 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id i7sm11960655pgk.85.2021.10.25.15.58.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Oct 2021 15:58:47 -0700 (PDT)
Message-ID: <617736a7.1c69fb81.74fc3.f7f5@mx.google.com>
Date:   Mon, 25 Oct 2021 15:58:47 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.9
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.9.287-49-ge3d4a1132be4
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.9 baseline: 89 runs,
 1 regressions (v4.9.287-49-ge3d4a1132be4)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 89 runs, 1 regressions (v4.9.287-49-ge3d4a113=
2be4)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.287-49-ge3d4a1132be4/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.287-49-ge3d4a1132be4
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      e3d4a1132be41e23131bb0b7b8906c3dad4727ec =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/617705b6cdd8c8e9a33358f7

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.287-4=
9-ge3d4a1132be4/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.287-4=
9-ge3d4a1132be4/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/617705b7cdd8c8e=
9a33358fa
        new failure (last pass: v4.9.287-46-gb1ffea87433c)
        2 lines

    2021-10-25T19:29:41.530668  [   20.152832] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-10-25T19:29:41.553498  [   20.172882] smsc95xx 3-1.1:1.0 eth0: reg=
ister 'smsc95xx' at usb-4a064c00.ehci-1.1, smsc95xx USB 2.0 Ethernet, 22:d7=
:13:06:0c:3f
    2021-10-25T19:29:41.559874  [   20.185485] usbcore: registered new inte=
rface driver smsc95xx
    2021-10-25T19:29:41.600546  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/118
    2021-10-25T19:29:41.609920  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
230 [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1
    2021-10-25T19:29:41.625822  [   20.247711] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =20
