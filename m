Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6ACE2AA7EE
	for <lists+stable@lfdr.de>; Sat,  7 Nov 2020 21:46:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726915AbgKGUqW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 7 Nov 2020 15:46:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725836AbgKGUqW (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 7 Nov 2020 15:46:22 -0500
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73C84C0613CF
        for <stable@vger.kernel.org>; Sat,  7 Nov 2020 12:46:22 -0800 (PST)
Received: by mail-pf1-x436.google.com with SMTP id 10so4629902pfp.5
        for <stable@vger.kernel.org>; Sat, 07 Nov 2020 12:46:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=qOtkWazOOOwwQqt9nXel8ewTrz69c0hjXF6dr1kLBT4=;
        b=mk8Eq5PYZsw6TUclOvpJBD6GHNRlTvAVA7VfKmITPPXyLndWIam8/f35/wjt8IfcaE
         p+E6BQ6quymHGJxE/47xJCsI/NgfFeCtMNKEmHOaAixsNbdoeNcG5+MoSDvRlK5nOCCD
         qfVmkLjmnoYu+3O3mXyPgq/gSVml3k5gFHw6bPvupvoGEhO7zM/I/IUGzQGJ0jfwKg/C
         RqVveyJNnBJcGmJK9EiL/ObkePib17TT5kSKxzMxr4xTBjUaF2tTbDu9BZNznLyiSVmK
         lz5K1578JpMAi7e84pqmMV/2weEZ4EyZbFFLS6w+cnHDd7gL34J96ntseXmvRuhWDY76
         WHDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=qOtkWazOOOwwQqt9nXel8ewTrz69c0hjXF6dr1kLBT4=;
        b=kdQiLw12ZlSsUt+1wSPdTSPrF/VwgeupWM/nQFT6RVgvymx0T5J8u9dKUpWME7HUxz
         +6MXdz/Wpml79HZuEvpqMWhI+ymj95DdbRL8hRFA3lPVb3k1MkJUP58XCwi9Xm2KEjWY
         ya8GuWXCjoZAMOO8T18I1z8OLBWC4+/pCINfubelPE3qIdJdyUWnI9sksza89f5yXwxl
         nHvcXSoK5i2XNItyoSe+Bgy9Vs+M0JncLHDR+0lt9qGT3VzTMq6fBni1curhaE9iCpGD
         W7Whm3xeIFFNhOKbNx1gfDv6Sdz0uNE8FFFcGicJ4DYOKIqjV4Y3FtkRRpeHgQ4nlm2M
         D7Kw==
X-Gm-Message-State: AOAM532JVAixiB64NAECLip9UFLKJPsdOt5JH0T53QcvPnXMDsG08fra
        Hd9kI4KEGMp+iv9YZElZa1e1WQOK/hamLw==
X-Google-Smtp-Source: ABdhPJy84t9wtUWnjJtkmLmu0hb1kf91AALsQQ6bpOfEi/rdTHvmJtkCOtrAKHDF4xQ6wBSqzFqtaw==
X-Received: by 2002:a65:6493:: with SMTP id e19mr6801613pgv.276.1604781981653;
        Sat, 07 Nov 2020 12:46:21 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id d18sm5787112pgg.41.2020.11.07.12.46.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Nov 2020 12:46:21 -0800 (PST)
Message-ID: <5fa7079d.1c69fb81.3440a.ade2@mx.google.com>
Date:   Sat, 07 Nov 2020 12:46:21 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.19
X-Kernelci-Kernel: v4.19.155-41-gbc826516395a
Subject: stable-rc/queue/4.19 baseline: 191 runs,
 1 regressions (v4.19.155-41-gbc826516395a)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 191 runs, 1 regressions (v4.19.155-41-gbc826=
516395a)

Regressions Summary
-------------------

platform        | arch  | lab          | compiler | defconfig | regressions
----------------+-------+--------------+----------+-----------+------------
bcm2837-rpi-3-b | arm64 | lab-baylibre | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.155-41-gbc826516395a/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.155-41-gbc826516395a
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      bc826516395ae3ba890280cbe4c3f34c928308c5 =



Test Regressions
---------------- =



platform        | arch  | lab          | compiler | defconfig | regressions
----------------+-------+--------------+----------+-----------+------------
bcm2837-rpi-3-b | arm64 | lab-baylibre | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fa6d44994af6a6e52db8857

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.155=
-41-gbc826516395a/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3=
-b.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.155=
-41-gbc826516395a/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3=
-b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.dmesg.crit: https://kernelci.org/test/case/id/5fa6d44994af6a6e=
52db885a
        new failure (last pass: v4.19.155-11-g29eb72734450)
        1 lines

    2020-11-07 17:05:22.905000+00:00  Connected to bcm2837-rpi-3-b console =
[channel connected] (~$quit to exit)
    2020-11-07 17:05:22.905000+00:00  (user:khilman) is already connected
    2020-11-07 17:05:38.321000+00:00  =00
    2020-11-07 17:05:38.321000+00:00  =

    2020-11-07 17:05:38.337000+00:00  U-Boot 2018.11 (Dec 04 2018 - 10:54:3=
2 -0800)
    2020-11-07 17:05:38.337000+00:00  =

    2020-11-07 17:05:38.337000+00:00  DRAM:  948 MiB
    2020-11-07 17:05:38.353000+00:00  RPI 3 Model B (0xa02082)
    2020-11-07 17:05:38.445000+00:00  MMC:   mmc@7e202000: 0, sdhci@7e30000=
0: 1
    2020-11-07 17:05:38.477000+00:00  Loading Environment from FAT... *** W=
arning - bad CRC, using default environment =

    ... (371 line(s) more)  =

 =20
