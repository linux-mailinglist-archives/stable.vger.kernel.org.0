Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E210C226E98
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 20:57:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729792AbgGTS5Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 14:57:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729203AbgGTS5X (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jul 2020 14:57:23 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60A63C061794
        for <stable@vger.kernel.org>; Mon, 20 Jul 2020 11:57:23 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id l6so9088456plt.7
        for <stable@vger.kernel.org>; Mon, 20 Jul 2020 11:57:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Ba+gcfIeLFu5fsfoIwSFAhkbgHqUVCS60ZUCIphsPGo=;
        b=Bte0fdNXMRVkexF7nGWTr8qaOWMxJ+YWU7F80cOXqLnk4kgIvOJUPjrkCC05Zl3xEI
         /vP5XDbMmgNMqQo648kZ6UTa77uwVOQ/vnOUZ1Gvml6gq/q4Nl+DjyLByuZ8sHkjaUoX
         +JZhjrwVq/KBG5shy1HecrqTcetaS7F/Hrn+DM2tkCFPEJ4tsREk04tjjaRAzJG0x4WL
         v8NODCtHItLk+GCmUCL+E0zfnojSzu2lXCLqNMTiXCMCWg/gyRtzuzzuzYseXHdw3Pyh
         WZ+f7qOLmEv8SiawZ8RenxjhPyaXHY31CC9Z3V5ACaj0dg7hRIJKBhfPLt9cX6i5WVYL
         jsPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Ba+gcfIeLFu5fsfoIwSFAhkbgHqUVCS60ZUCIphsPGo=;
        b=baTZS/3vLCrCcw4xpr36PXx8/5YI7J29YPlnF19qOFTU78cRoUyIGShuDbYtKOatz2
         4QJY6Qr8x0rG2PYwvVnQYjKFL8HwYKug+ryj43lKt4kpA2IQDp3L/qmiVur9kUbYPfaV
         GBvFvk43jSg03HdeMV7nuW3PR/Qhr5M/+xxGS9eYulXjaubAPJz5IqjlilA+7y5n05xC
         IALjW23V1z3620ojSGWNx7cPaa5CaNRgDg7OfUzcj6nWyPEGh71j+r0d4On7c73l41m+
         WNMPZkIZgBs/NQzGlKx0etyOYxQV7rkJalvyrkRRB/2i7IL1kpK1z51Y7RX3yfnCYcH3
         VQ6g==
X-Gm-Message-State: AOAM531tN+bOva1ApPNUw+PA7uqW9oNK9du6VJvdbBkgNy1cv2J+yLal
        cP9+L5SJr3tmAtSv3oB7SsORZcVTBvY=
X-Google-Smtp-Source: ABdhPJwAuczB2WKxXs1aU1RxhVzaY0tHbvMqvj6F554nj1/91CCgErJH0Uap+utMTN4lyQNaX/PM+A==
X-Received: by 2002:a17:902:8d98:: with SMTP id v24mr19325665plo.301.1595271442632;
        Mon, 20 Jul 2020 11:57:22 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id e16sm18036681pff.180.2020.07.20.11.57.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jul 2020 11:57:21 -0700 (PDT)
Message-ID: <5f15e911.1c69fb81.bcb17.addd@mx.google.com>
Date:   Mon, 20 Jul 2020 11:57:21 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.4.230-59-g9cd3125d70c0
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.4.y
Subject: stable-rc/linux-4.4.y baseline: 49 runs,
 2 regressions (v4.4.230-59-g9cd3125d70c0)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y baseline: 49 runs, 2 regressions (v4.4.230-59-g9cd312=
5d70c0)

Regressions Summary
-------------------

platform        | arch | lab          | compiler | defconfig           | re=
sults
----------------+------+--------------+----------+---------------------+---=
-----
omap3-beagle-xm | arm  | lab-baylibre | gcc-8    | omap2plus_defconfig | 2/=
5    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.4.y/kern=
el/v4.4.230-59-g9cd3125d70c0/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.4.y
  Describe: v4.4.230-59-g9cd3125d70c0
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      9cd3125d70c02db6ad2a0d89a1de2c24be0826f6 =



Test Regressions
---------------- =



platform        | arch | lab          | compiler | defconfig           | re=
sults
----------------+------+--------------+----------+---------------------+---=
-----
omap3-beagle-xm | arm  | lab-baylibre | gcc-8    | omap2plus_defconfig | 2/=
5    =


  Details:     https://kernelci.org/test/plan/id/5f15b319a3d50018ab85bb18

  Results:     2 PASS, 2 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.230=
-59-g9cd3125d70c0/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-omap3=
-beagle-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.230=
-59-g9cd3125d70c0/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-omap3=
-beagle-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/armel/baseline/rootfs.cpio.gz =


  * baseline.dmesg.crit: https://kernelci.org/test/case/id/5f15b319a3d50018=
ab85bb1b
      new failure (last pass: v4.4.230)
      1 lines* baseline.dmesg.emerg: https://kernelci.org/test/case/id/5f15=
b319a3d50018ab85bb1d
      new failure (last pass: v4.4.230)
      28 lines =20
