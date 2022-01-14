Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90E5E48E3BE
	for <lists+stable@lfdr.de>; Fri, 14 Jan 2022 06:31:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229725AbiANFbT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Jan 2022 00:31:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbiANFbT (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Jan 2022 00:31:19 -0500
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C57FC061574
        for <stable@vger.kernel.org>; Thu, 13 Jan 2022 21:31:18 -0800 (PST)
Received: by mail-pl1-x632.google.com with SMTP id c6so3918011plh.6
        for <stable@vger.kernel.org>; Thu, 13 Jan 2022 21:31:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=GdPJVRcWvS71cYd2/e/tx9FsBBWVFT5p68ukBE4mDlM=;
        b=a/UanrHDTHO0xIdK0a224TwIn9xztxc3u5mYk0GG1xGbhDP2UzU4GmA6I9XeavBd8X
         lB+xmZLdDDVJglVwoWPDI7zWDHN9NN6UTxS4z5Rf2zGRymL+gHdgmzC1nF0ZVFezKe7i
         SojtEhTZSfCBh1HEyEbSnbalRionIJrp7GeSC3DS8ge2ng3C+HUGwSV0fKSvQ1SKl3Mq
         7T+xLWoaU27CzW9T+lhfXbvaw/HoTigbD5CC2MKE4NUSMj4R/9Cgjb+hV4aK6AysSgf+
         P5Kn8RDYWRSTu6VSvrBHo6mnk+6KNIN8TKUyjic/vUzw/hee4LaRRkBkt0v2SEEThe3E
         AWWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=GdPJVRcWvS71cYd2/e/tx9FsBBWVFT5p68ukBE4mDlM=;
        b=BQJ89l6pAxbFlECspF2lABEEgLJWbxT0sdyBAD0RfCuMH2YkFxFw/B+fBKj3LmxmuW
         QmsXMfDBIDgbuGuAS3DQm4lyu499j4ANyHlYzmzJhqJ1V8tUuTnpKzozTQ/00mFRkCb6
         L/LdJgHSso22+uEDQc2eyeQDwZF2yPpWUx0hoH6TLMD/9Hwu2fSSTMuDhW6oWz2CcrOv
         pnANZk8hr9zeoYG5wjGBIYrlz8AjtjYhDbLJiwn/nloh7PHF8qBLLeOg6aClo79wDnrB
         PZ0H1uVr8e3FhimJhGCCO7r33lENl8tA09z2d029u2XHmgmv6oGP+VvLUxuBgQ39a1y3
         wHEw==
X-Gm-Message-State: AOAM530l5mGpUGafZyqsBp/BIu9GZdONAH+1L260Ej7frQO4pZgV5Mni
        1Z+vH3jNLEiTPtgcgcsc5W1mHkR8ZpLrnTG9TN4=
X-Google-Smtp-Source: ABdhPJyt3hm88JPO9fFXUXbShRnx2VDG7w+0MDBn/FLxsYgKjiGksDdOTcd1QwVE8b5esdQYxLojMA==
X-Received: by 2002:a17:90b:38c9:: with SMTP id nn9mr18256003pjb.153.1642138277704;
        Thu, 13 Jan 2022 21:31:17 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id z16sm3604874pgi.89.2022.01.13.21.31.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Jan 2022 21:31:17 -0800 (PST)
Message-ID: <61e10aa5.1c69fb81.8a8ca.b3d5@mx.google.com>
Date:   Thu, 13 Jan 2022 21:31:17 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.4.299-7-g11683a1637bc
X-Kernelci-Branch: linux-4.4.y
Subject: stable-rc/linux-4.4.y baseline: 128 runs,
 1 regressions (v4.4.299-7-g11683a1637bc)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y baseline: 128 runs, 1 regressions (v4.4.299-7-g11683a=
1637bc)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.4.y/kern=
el/v4.4.299-7-g11683a1637bc/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.4.y
  Describe: v4.4.299-7-g11683a1637bc
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      11683a1637bc289c310a4a1890faee0278fc0897 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61e0d826e4cca08c88ef67e4

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.299=
-7-g11683a1637bc/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.299=
-7-g11683a1637bc/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61e0d826e4cca08=
c88ef67e7
        failing since 14 days (last pass: v4.4.296-18-gea28db322a98, first =
fail: v4.4.297)
        2 lines

    2022-01-14T01:55:29.307399  [   19.221405] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2022-01-14T01:55:29.357248  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, swapper/0/0
    2022-01-14T01:55:29.366702  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
25c [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =20
