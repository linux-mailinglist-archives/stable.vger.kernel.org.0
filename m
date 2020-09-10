Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AC6A263B24
	for <lists+stable@lfdr.de>; Thu, 10 Sep 2020 05:00:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725773AbgIJDAL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Sep 2020 23:00:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726642AbgIJC75 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Sep 2020 22:59:57 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFB44C061573
        for <stable@vger.kernel.org>; Wed,  9 Sep 2020 19:59:55 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id m15so198533pls.8
        for <stable@vger.kernel.org>; Wed, 09 Sep 2020 19:59:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=oAqCymINykCSCVkRQnjDlby05kX/HOW6vxbjDCgsHVA=;
        b=KQGBGjgymJGErMrRuoCGH+Jp5CNmsRxsQXgwIplWDieulpiFtOskhEAX3+KRfoT+qK
         NfGF9NVi4T+XfiwEcsEctgqHrWQmyj4pZ4PTF9k6mWqEBp7OjR14h9VZvVZR6hlc1Mw3
         yEvEWxn6HeFLW7n8LAVSlCep+rLrOoMCbzkp9EneZGjkmi3ybmqnvx0FO8P3Aaaya3J1
         U83XGANULkrHUkCFTqUhl2S9Ltd4fWzJtwa0FdmcvrmTPAF1o1hASf37GQd4rFIDQaYl
         pQKzmwqotChJq4DfsmRWJBr+Cpp6CYRwTVC/tKWPb0TS1IbFhhEKYIrwfJWhCWdSJLSM
         7OlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=oAqCymINykCSCVkRQnjDlby05kX/HOW6vxbjDCgsHVA=;
        b=j4yR3rXd2EjzZ1/nEhYn8AdBqAWKClwra0dVgsZKh9VxlNKhN22vgVUe48/wb7qVUX
         ZovT34mMmO/LfMusXEaNcUTbwX+X0rCa1l34PczKeqZ9sIkITq1rwzIrQzUU89Sz4sFv
         38lHyiy94rvMYNx/dnG7qGoDZWJVrLOMdw769uQWXhEuoIiathPMxP9nhpMSUK/N44hd
         EfrLgTCWinxB6S+0U3xnwJDlOOr5GTnnMhc6qapvf+wk7uFSnOXQJMF47bvPPzomG2+F
         byJe1Q3uq06AFrN/TZaZ5QF6NpZYHUuA5gxXjvB8KcS3g8vUdH1qGJM8e94L79XGB/Yr
         +xrg==
X-Gm-Message-State: AOAM5302mMMYTIAjz0nh8zY9l88iWV6+xq6I+SywEAcT7Qa3GW29CyKr
        O/PL/V3IEEJvkhfeEtEaUeVGUfOpkdZxag==
X-Google-Smtp-Source: ABdhPJzc+PMTYskDQHAJCJIcY+rzJvodepcnfycQOOF9bKEirDEnNUEeIbZ3i6r+dpkzeLKKSqO28w==
X-Received: by 2002:a17:90b:1916:: with SMTP id mp22mr3128106pjb.132.1599706790931;
        Wed, 09 Sep 2020 19:59:50 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id a3sm4045117pfl.213.2020.09.09.19.59.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Sep 2020 19:59:50 -0700 (PDT)
Message-ID: <5f5996a6.1c69fb81.8fe00.c2ca@mx.google.com>
Date:   Wed, 09 Sep 2020 19:59:50 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.4.64
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-5.4.y baseline: 166 runs, 1 regressions (v5.4.64)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.4.y baseline: 166 runs, 1 regressions (v5.4.64)

Regressions Summary
-------------------

platform        | arch  | lab          | compiler | defconfig | results
----------------+-------+--------------+----------+-----------+--------
bcm2837-rpi-3-b | arm64 | lab-baylibre | gcc-8    | defconfig | 3/4    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.4.y/kern=
el/v5.4.64/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.4.y
  Describe: v5.4.64
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      6ffabce36fc83a88878cef43e8b29b0103e24709 =



Test Regressions
---------------- =



platform        | arch  | lab          | compiler | defconfig | results
----------------+-------+--------------+----------+-----------+--------
bcm2837-rpi-3-b | arm64 | lab-baylibre | gcc-8    | defconfig | 3/4    =


  Details:     https://kernelci.org/test/plan/id/5f5959e5afdcf8b481d35370

  Results:     3 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.64/=
arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.64/=
arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/arm64/baseline/rootfs.cpio.gz =


  * baseline.dmesg.crit: https://kernelci.org/test/case/id/5f5959e5afdcf8b4=
81d35372
      new failure (last pass: v5.4.63-130-gbe965cc6b079)
      1 lines

    2020-09-09 22:38:32.735000  Connected to bcm2837-rpi-3-b console [chann=
el connected] (~$quit to exit)
    2020-09-09 22:38:32.735000  (user:khilman) is already connected
    2020-09-09 22:38:48.238000  =00
    2020-09-09 22:38:48.239000  =

    2020-09-09 22:38:48.239000  U-Boot 2018.11 (Dec 04 2018 - 10:54:32 -080=
0)
    2020-09-09 22:38:48.239000  =

    2020-09-09 22:38:48.239000  DRAM:  948 MiB
    2020-09-09 22:38:48.254000  RPI 3 Model B (0xa02082)
    2020-09-09 22:38:48.341000  MMC:   mmc@7e202000: 0, sdhci@7e300000: 1
    2020-09-09 22:38:48.373000  Loading Environment from FAT... *** Warning=
 - bad CRC, using default environment
    ... (375 line(s) more)
      =20
