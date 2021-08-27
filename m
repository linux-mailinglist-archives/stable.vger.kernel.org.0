Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 450F73F9C31
	for <lists+stable@lfdr.de>; Fri, 27 Aug 2021 18:12:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245494AbhH0QMc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Aug 2021 12:12:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234391AbhH0QMc (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 Aug 2021 12:12:32 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E546C061757
        for <stable@vger.kernel.org>; Fri, 27 Aug 2021 09:11:43 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id fz10so4896647pjb.0
        for <stable@vger.kernel.org>; Fri, 27 Aug 2021 09:11:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=M+UKMdRIZdnUZ0GDall71O3RbENjtRUsJIMAXDd+j8Q=;
        b=DFa6tICpQKBrwycMsXivxOYoQoFYp2WjFvWCtLTcZf0kOeXNdrGukCi6l2cXRc3ps2
         asgAIgz5L3erU4RjSWjZ285HvqD9o9I9bcBKqgi9zoTSkJ7XYTQ28c/RJiRWM6K+Mipn
         iN+tI0Zd8Xfy+t9pEnLuj53zxIltBZ6EfTL4WuFtcS3n/5gGWCl5dbCzCZGsuzFMaKvP
         95/3KsiFyNEowHDaObdNumu0q9FnWHlYMndwU75fvAT8LERU64G7ozUgFa0qRVVY6PGh
         QbbMuf52FIdgjvAgwSu8G4qEnSGPWENPUVJhgRrt5CYef9NBv1vAE2eUSW/9KfgB60oy
         EmUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=M+UKMdRIZdnUZ0GDall71O3RbENjtRUsJIMAXDd+j8Q=;
        b=pExlGK1rKKWZ037puUgoJ8PlNXqBIlMY2hLfyBl/YnWwFGKE6ROTPXt8CxxYtQ3mJR
         XAdAXb6Sx+tZLGwqUU0zWNOYj0tVZGSj/na025gp8/Sz0XHNXZbeZAEs3tTn3aCGYQAj
         HVeDOBY2zE+NLT1slk7qMUM9w5uUoCYfeuQpOQ1CrTDe7D30W9hWmiI+E65g5C7Pwbn8
         KWDzJ6IsnBFBfsAlTZ1dI98SIBRqL0TSssxcfCtBxa+BIss0ogrxyMDPvXklsXpJjFD/
         OJyaX7G5QAPp6XTP1jLDZSD2dRfxRamiaAIpaUg1SUhunpKZucggmkn8ayBIkWyVwXF0
         kdlA==
X-Gm-Message-State: AOAM531GPGAOIwMRXS+lO3NFSDA0tlO6/fCdf8mAtjvaZA4MD0yPxYx3
        HHztk5oZD/hfohjXp8i1ZpNCcXVHUnRMuguS
X-Google-Smtp-Source: ABdhPJwudwsFooIu4SLyal/hW8qlxA9uF+PT9ydlv4kEJRn0W1UDolRQv8e3oqUTeBTNPMUYwuXpIw==
X-Received: by 2002:a17:902:db11:b0:138:7021:2caf with SMTP id m17-20020a170902db1100b0013870212cafmr9360345plx.26.1630080702392;
        Fri, 27 Aug 2021 09:11:42 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id z65sm11612732pjj.43.2021.08.27.09.11.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Aug 2021 09:11:42 -0700 (PDT)
Message-ID: <61290ebe.1c69fb81.9d721.d384@mx.google.com>
Date:   Fri, 27 Aug 2021 09:11:42 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.13
X-Kernelci-Kernel: v5.13.13-2-g4db03cfb5850
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.13 baseline: 155 runs,
 3 regressions (v5.13.13-2-g4db03cfb5850)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.13 baseline: 155 runs, 3 regressions (v5.13.13-2-g4db03cf=
b5850)

Regressions Summary
-------------------

platform           | arch | lab          | compiler | defconfig           |=
 regressions
-------------------+------+--------------+----------+---------------------+=
------------
bcm2837-rpi-3-b-32 | arm  | lab-baylibre | gcc-8    | bcm2835_defconfig   |=
 1          =

beagle-xm          | arm  | lab-baylibre | gcc-8    | multi_v7_defconfig  |=
 1          =

beagle-xm          | arm  | lab-baylibre | gcc-8    | omap2plus_defconfig |=
 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.13/ker=
nel/v5.13.13-2-g4db03cfb5850/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.13
  Describe: v5.13.13-2-g4db03cfb5850
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      4db03cfb58503ba1cf41885d8814e97d4dc1c6f3 =



Test Regressions
---------------- =



platform           | arch | lab          | compiler | defconfig           |=
 regressions
-------------------+------+--------------+----------+---------------------+=
------------
bcm2837-rpi-3-b-32 | arm  | lab-baylibre | gcc-8    | bcm2835_defconfig   |=
 1          =


  Details:     https://kernelci.org/test/plan/id/6128d68c12e14b35158e2c9f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.13-=
2-g4db03cfb5850/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837-r=
pi-3-b-32.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.13-=
2-g4db03cfb5850/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837-r=
pi-3-b-32.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6128d68c12e14b35158e2=
ca0
        failing since 0 day (last pass: v5.13.12-125-gf6c5dda713c6, first f=
ail: v5.13.12-125-g0bca906df054) =

 =



platform           | arch | lab          | compiler | defconfig           |=
 regressions
-------------------+------+--------------+----------+---------------------+=
------------
beagle-xm          | arm  | lab-baylibre | gcc-8    | multi_v7_defconfig  |=
 1          =


  Details:     https://kernelci.org/test/plan/id/6128dd07c4dc80fd938e2cac

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.13-=
2-g4db03cfb5850/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-beagle-x=
m.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.13-=
2-g4db03cfb5850/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-beagle-x=
m.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6128dd07c4dc80fd938e2=
cad
        failing since 1 day (last pass: v5.13.12-126-g61c83bccf008, first f=
ail: v5.13.12-125-gf6c5dda713c6) =

 =



platform           | arch | lab          | compiler | defconfig           |=
 regressions
-------------------+------+--------------+----------+---------------------+=
------------
beagle-xm          | arm  | lab-baylibre | gcc-8    | omap2plus_defconfig |=
 1          =


  Details:     https://kernelci.org/test/plan/id/6128db39755f11c4d08e2c8d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.13-=
2-g4db03cfb5850/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle-=
xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.13-=
2-g4db03cfb5850/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle-=
xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6128db39755f11c4d08e2=
c8e
        failing since 29 days (last pass: v5.13.5-224-g078d5e3a85db, first =
fail: v5.13.5-223-g3a7649e5ffb5) =

 =20
