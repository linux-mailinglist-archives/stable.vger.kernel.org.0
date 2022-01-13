Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDDC048DF6F
	for <lists+stable@lfdr.de>; Thu, 13 Jan 2022 22:14:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234907AbiAMVMg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jan 2022 16:12:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229931AbiAMVMf (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Jan 2022 16:12:35 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02AAFC061574
        for <stable@vger.kernel.org>; Thu, 13 Jan 2022 13:12:35 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id a1-20020a17090a688100b001b3fd52338eso11167389pjd.1
        for <stable@vger.kernel.org>; Thu, 13 Jan 2022 13:12:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ILHS/r/TKnDj5kA+fuvEVzCn76hiMO64ReJuONQo3gA=;
        b=1x28mJaHyubZZX1K9e2/fU6n7oh5W+tGxDQ0WiTmHSDsPEzZMSU28ioOtZk9eLqCQm
         opFBessUo+fIWrKQqgwzZKLQeJLYJ/XO3CRQXyol+uHP0z0Apjht7XbuQxi9TCChn6P1
         Jq0VEmov8JZxAkAMsuUB6PfuDVnj9w1UAXSSCKxlEJm5Gbv39Z40otLylKNiIlOicXaY
         ZJbGfxgliXnnQuKBvw7ZTe/bomDjgKRZjXMfd3Qe0srxSq1njOAvhdSAqAzELUjYo936
         +9KH1kp9kqzocyymKw5uyNujG/JBmHL3dEcmSduT+0t3vhY+C7bV5q7LUezSCKd9U/Nw
         1JMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ILHS/r/TKnDj5kA+fuvEVzCn76hiMO64ReJuONQo3gA=;
        b=e0+6ZZ6hKdNHVKkjeNfsAY+5tzlYps+hBnUoBJTdGFba29k8pxWlJYQh8ACpuTrvP1
         j8sXwL9KwLWQM3+CbhcMokdgKMpFeZxVSOA4QOxM1+7NqExrxf9a8ZRXpFrrXHXm+JvV
         Klgpwm6gXSZeEzGZt3PcR44FHQAZTSCWnjBwJnUElCQ3zMLwPXNIm8yo1vlRF2yYbm2R
         x2X98/GfVg2SZyIqExBVDqJgG8tj1KsNKBraWf8Iej+oTwF7C7RJh1GcVyc5zIYPBlD1
         3f9Node38xoa3TUVgwGLKriGZ+roob8se1thRvOFNlbk86IxDwlC5MOpdhDfWPH5b+XF
         EfeQ==
X-Gm-Message-State: AOAM531Rgxe5Dm0jb/2PwC5kjB3WSGvphsRmxvb9aL2MLp+aIVUBa369
        eHco6yAuwWFvIxE3anV2y7RB4vq7x98agHkBt6o=
X-Google-Smtp-Source: ABdhPJxsHM1aIL7/CcB+NM76OeBOvoLW3QaHYfdUIslY5PleyB+3GzUl25QKu7YdoXlxjvxRf+299g==
X-Received: by 2002:a17:903:41c1:b0:14a:695a:f372 with SMTP id u1-20020a17090341c100b0014a695af372mr6439438ple.166.1642108354433;
        Thu, 13 Jan 2022 13:12:34 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id i35sm898543pgb.28.2022.01.13.13.12.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Jan 2022 13:12:34 -0800 (PST)
Message-ID: <61e095c2.1c69fb81.d0838.2956@mx.google.com>
Date:   Thu, 13 Jan 2022 13:12:34 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.9.297-4-gab32e4bdb13f
X-Kernelci-Branch: queue/4.9
Subject: stable-rc/queue/4.9 baseline: 146 runs,
 1 regressions (v4.9.297-4-gab32e4bdb13f)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 146 runs, 1 regressions (v4.9.297-4-gab32e4bd=
b13f)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.297-4-gab32e4bdb13f/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.297-4-gab32e4bdb13f
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      ab32e4bdb13fe993959d0951755affe53529c016 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61e05f86715996812fef6758

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.297-4=
-gab32e4bdb13f/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.297-4=
-gab32e4bdb13f/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61e05f867159968=
12fef675b
        failing since 2 days (last pass: v4.9.296-21-ga5ed12cbefc0, first f=
ail: v4.9.296-21-gd19aa36b7387)
        2 lines

    2022-01-13T17:20:53.228042  [   20.039764] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2022-01-13T17:20:53.267701  [   20.077301] smsc95xx 3-1.1:1.0 eth0: reg=
ister 'smsc95xx' at usb-4a064c00.ehci-1.1, smsc95xx USB 2.0 Ethernet, a2:1b=
:34:e7:f0:47
    2022-01-13T17:20:53.274859  [   20.091064] usbcore: registered new inte=
rface driver smsc95xx
    2022-01-13T17:20:53.304683  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/119
    2022-01-13T17:20:53.313165  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
230 [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
