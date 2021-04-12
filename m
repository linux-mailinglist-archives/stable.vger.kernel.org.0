Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 632B835C644
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 14:30:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238331AbhDLMaz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 08:30:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239082AbhDLMay (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Apr 2021 08:30:54 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 224E1C061574
        for <stable@vger.kernel.org>; Mon, 12 Apr 2021 05:30:37 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id e8-20020a17090a7288b029014e51f5a6baso1721081pjg.2
        for <stable@vger.kernel.org>; Mon, 12 Apr 2021 05:30:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=RtLSU4YoxfOUu+744IZUHXgnNHAczD2GxXN2FWFJHcQ=;
        b=GD8ZHehVFlRlBbXEuOqecYdDg5SbY9vZetclgUmRdSs+Bw8Y172UkFjnqAg9dvWE1I
         7p4CkfntQ535w81als+lDz1BaZPEOvfgeNXRw9FDS3USsoTwvDKYB+WqbhkkPE7PPli/
         jF3Unc2+g+k2rAcXwab0tF+YggCua/iZsPjIQ9/SeEGX29XWnDCK2FQpldAf2MY0MRLk
         9PuCxY+0gsnu3wiQIpe5jSZ1kQ6MOgLSDuvXyRVWPnk9Am4uM9uVLhrJAMjw1NJjq4H7
         mhYIU3LI+F5LP3subYV/ymPSR96An8ZfVv0KTKEmELqjgeFWPuIaoRP8GBLo15ibWs/6
         mvCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=RtLSU4YoxfOUu+744IZUHXgnNHAczD2GxXN2FWFJHcQ=;
        b=FSMtlmsAn+hGA9qn24ra3KB2/8rWtpRp7YSlMETzvU9tNuYzurLFYSuIKzpBUN588J
         ZKpJcEAQ+SfEPogimNPJaiGCiKE4xgomrC/3Or9qO0yHnsJ69ZNCXVbTHipOSQioV+8V
         CX5FTQFrrNDoIAXAq7njESBITvOCtvBttc4S4j+OhE30pHxY/ckkrEp8SiJWCxvuqjW1
         1hUsJ3Bze9PLQKRJoxHVGEBnMkg2D6/bxrH3z5Rh2y7fbIEvsh7RGkYNyrBzeFFZlUVO
         LCKcXrJkMUG4/xP9qVOnn8h7B3tOumO6Nm4lQkhyc6n6zxm7UEGnd6Xdj7lNbMhmp5RX
         hILg==
X-Gm-Message-State: AOAM531sv1+R6LCrLfo3QPa2cxUAJdQEJGokrXlN0+5teAR7RTMe/9+a
        rGJpL8xDpKzKYzCa9uCOmJ6pwDK7by1KUXv1
X-Google-Smtp-Source: ABdhPJyC9ecQ34PIVAW7YAVKfhhHYIER2tXU+go+GeC/pq816zg3Pg33kR9NgSFB+IBd+6Xwq8FSlw==
X-Received: by 2002:a17:902:ce8c:b029:e9:72c2:a8bf with SMTP id f12-20020a170902ce8cb02900e972c2a8bfmr24641269plg.38.1618230636486;
        Mon, 12 Apr 2021 05:30:36 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id q2sm7301154pgk.75.2021.04.12.05.30.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Apr 2021 05:30:36 -0700 (PDT)
Message-ID: <60743d6c.1c69fb81.16034.f63b@mx.google.com>
Date:   Mon, 12 Apr 2021 05:30:36 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.14.230-58-g25bd7e2a3beb4
X-Kernelci-Branch: queue/4.14
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.14 baseline: 103 runs,
 4 regressions (v4.14.230-58-g25bd7e2a3beb4)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 103 runs, 4 regressions (v4.14.230-58-g25bd7=
e2a3beb4)

Regressions Summary
-------------------

platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
hip07-d05            | arm64 | lab-collabora | gcc-8    | defconfig        =
   | 1          =

qemu_arm-versatilepb | arm   | lab-baylibre  | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-cip       | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-collabora | gcc-8    | versatile_defconf=
ig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.230-58-g25bd7e2a3beb4/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.230-58-g25bd7e2a3beb4
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      25bd7e2a3beb44959c5c5a114bf04c49e2e6c870 =



Test Regressions
---------------- =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
hip07-d05            | arm64 | lab-collabora | gcc-8    | defconfig        =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/607409ae81413d39bbdac6b1

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.230=
-58-g25bd7e2a3beb4/arm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.t=
xt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.230=
-58-g25bd7e2a3beb4/arm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/607409ae81413d39bbdac=
6b2
        new failure (last pass: v4.14.230-37-gbf0a382a8fae7) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-baylibre  | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/607405975606a35a99dac6f3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.230=
-58-g25bd7e2a3beb4/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.230=
-58-g25bd7e2a3beb4/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/607405975606a35a99dac=
6f4
        failing since 149 days (last pass: v4.14.206-21-g787a7a3ca16c, firs=
t fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-cip       | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/607405985606a35a99dac6f6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.230=
-58-g25bd7e2a3beb4/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.230=
-58-g25bd7e2a3beb4/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/607405985606a35a99dac=
6f7
        failing since 149 days (last pass: v4.14.206-21-g787a7a3ca16c, firs=
t fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-collabora | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/607405408d9550f141dac6d6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.230=
-58-g25bd7e2a3beb4/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.230=
-58-g25bd7e2a3beb4/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/607405408d9550f141dac=
6d7
        failing since 149 days (last pass: v4.14.206-21-g787a7a3ca16c, firs=
t fail: v4.14.206-22-ga949bf40fb01) =

 =20
