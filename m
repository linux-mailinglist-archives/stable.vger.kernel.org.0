Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 309C3474DE7
	for <lists+stable@lfdr.de>; Tue, 14 Dec 2021 23:28:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233660AbhLNW2l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Dec 2021 17:28:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229577AbhLNW2k (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Dec 2021 17:28:40 -0500
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55065C061574
        for <stable@vger.kernel.org>; Tue, 14 Dec 2021 14:28:40 -0800 (PST)
Received: by mail-pg1-x534.google.com with SMTP id 200so9616414pgg.3
        for <stable@vger.kernel.org>; Tue, 14 Dec 2021 14:28:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=HWYmWEj6OSqYUdQn97Pmt3FBOEUVVXl06Y+VRtJdpt8=;
        b=npmJD06VFCCOMX92o2toSNVPD/S/KeoPMTVd5YfBZltC4pQOCwoLACov0m01OUiNPu
         5mHBSFp/ja8S5B+zaiQkK4Ez7oAaNuGqosI2u5JEZ6A+S8taQFXbyPsaxVdZMzTnTfMV
         M5z546gEApibHDCZbjgOpOsSltiaXuyLj2ZPkhdvnyVuwnmyYZPmdAg4ElsWWmXxokiZ
         yZnutHqRNSfDpUn8x7eUUHPG/7XzVyg+WEEioDnWopnDR9Rp1vvqtBx1TJTAn/0FqR2q
         iVV5aYWkqHAe9fQsEs2G75oKBwyul8PNeeg6QxsSsch1ZoW/tmZv9uq5M4D1fS5p70Au
         xdVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=HWYmWEj6OSqYUdQn97Pmt3FBOEUVVXl06Y+VRtJdpt8=;
        b=FI9g1MlbGtehBeArfWzGDNliM7Yn5Fx7mFOJ1UWQa/Wgqd3l2+PL8AkgDTnrsHPPK9
         zsC7NoHeu5BC9mjREcIEvFcoERT1jQpF+ovZ3RJL8bGbCyGWqi6C5iPkCvJlDXd4x4Gx
         k5F+Od6JbmbGCVdSXjlYmt5oQoXGRVBOnMUaV7g/eFKfola/acX4kAQbfoO+Fgbqqhq3
         8mv1cCheYYkH0n0BnEhy3TNI02SRxHZdza1sbWs/ZSVHfvzdWq02lR/VFMY0oZrNonBO
         cAzHY5aAY/3nZ+ZIYVmw1x8Av3PH3R4NKlv++kV2+rYr8VN0HKXyJlKYmSRak56btBOb
         m1NA==
X-Gm-Message-State: AOAM531DeFgqKnNLpZZK/bU5W0c2WpPpKHqRpoQpfy+yVEkJC3UISS0+
        n189oUvqt3URvxk4CoVA7tCKPYOKc1XpRiib
X-Google-Smtp-Source: ABdhPJwzx+t16+DqcurR6q7Oyva/31+Dr+RAzKWjTsiTBzIpgs9kG9pcw9yCaPrtEo12TCszF9hxVA==
X-Received: by 2002:a63:8f05:: with SMTP id n5mr5431453pgd.606.1639520919696;
        Tue, 14 Dec 2021 14:28:39 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b6sm93556pfm.170.2021.12.14.14.28.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Dec 2021 14:28:39 -0800 (PST)
Message-ID: <61b91a97.1c69fb81.358f8.076e@mx.google.com>
Date:   Tue, 14 Dec 2021 14:28:39 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.258-1-ga8ff4246ddd9
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/4.14
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.14 baseline: 121 runs,
 2 regressions (v4.14.258-1-ga8ff4246ddd9)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 121 runs, 2 regressions (v4.14.258-1-ga8ff42=
46ddd9)

Regressions Summary
-------------------

platform                 | arch   | lab           | compiler | defconfig   =
        | regressions
-------------------------+--------+---------------+----------+-------------=
--------+------------
minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
nfig    | 1          =

panda                    | arm    | lab-collabora | gcc-10   | omap2plus_de=
fconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.258-1-ga8ff4246ddd9/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.258-1-ga8ff4246ddd9
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      a8ff4246ddd9084afc0b2a12fa84fd6456ac064d =



Test Regressions
---------------- =



platform                 | arch   | lab           | compiler | defconfig   =
        | regressions
-------------------------+--------+---------------+----------+-------------=
--------+------------
minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
nfig    | 1          =


  Details:     https://kernelci.org/test/plan/id/61b8dee341773bae74397149

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.258=
-1-ga8ff4246ddd9/x86_64/x86_64_defconfig/gcc-10/lab-collabora/baseline-minn=
owboard-turbot-E3826.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.258=
-1-ga8ff4246ddd9/x86_64/x86_64_defconfig/gcc-10/lab-collabora/baseline-minn=
owboard-turbot-E3826.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61b8dee341773bae74397=
14a
        failing since 1 day (last pass: v4.14.257-33-gcf9830f3ce18, first f=
ail: v4.14.257-53-gbe1979ab4cd9) =

 =



platform                 | arch   | lab           | compiler | defconfig   =
        | regressions
-------------------------+--------+---------------+----------+-------------=
--------+------------
panda                    | arm    | lab-collabora | gcc-10   | omap2plus_de=
fconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/61b8df577fff23b81d397145

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.258=
-1-ga8ff4246ddd9/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.258=
-1-ga8ff4246ddd9/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61b8df577fff23b=
81d397148
        failing since 1 day (last pass: v4.14.257-33-gcf9830f3ce18, first f=
ail: v4.14.257-53-gbe1979ab4cd9)
        2 lines

    2021-12-14T18:15:36.697993  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/106
    2021-12-14T18:15:36.707497  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
d3c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
