Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9267736A2D9
	for <lists+stable@lfdr.de>; Sat, 24 Apr 2021 21:48:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234081AbhDXTsg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 24 Apr 2021 15:48:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232546AbhDXTsf (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 24 Apr 2021 15:48:35 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6F62C061574
        for <stable@vger.kernel.org>; Sat, 24 Apr 2021 12:47:55 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id y22-20020a17090a8b16b0290150ae1a6d2bso3056550pjn.0
        for <stable@vger.kernel.org>; Sat, 24 Apr 2021 12:47:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=RtOb4NULWaZCqV+PsDBGATBHEtfwXMdavxcRqrgrOuM=;
        b=DDl93n0q51H2oMa1yJHgEpm5kCZO6OoVp6nLtr1zHAMEgrmazJEPRipaxEsBLEJ1+Q
         fjrsuLw/nBfQ8gyIaFDuewrnOzlJ//wa+38qmo9w+wrhq4Q44V9SLocm+ua5LnA5V/PY
         k9hjZeNrKxHg8AszeV3atSqQ47ADIJC7ZigRldY/76FD8dYUHM/isvAAy95AvrTTBWqY
         ToHNoIkUOUCZ3Ew9QMUhrGRuEMmzL27ZMujCd0uIxP3meDlt7WU3K2Rzbm+FitHtPwoI
         l9QFKN98fN+4HphRULsUFiBRQeIbdCRSKmQw3NyLbdrkLW57r0la48FE6q0nnzgafTIk
         6c0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=RtOb4NULWaZCqV+PsDBGATBHEtfwXMdavxcRqrgrOuM=;
        b=tfMW+EPVjsZAYZ3ajR4uVfEhHTjkt2Lfb64Cspu8qdvNCutPnpuex2DLjv4n0G0Pf/
         6tbkLZC7OhRr1qJML3xSt0pMJFD0UQvEVh/q0t47VLdkYwXdRfXzXz6N6aI9K447PmPW
         UOiBvFW5yqciTMCSq3UQVoBdQwmSl0M7JVHbnMYYCEKOBicyYnu8XhFlJwymeKUS4WHp
         t0qHABRIw1XIx3fmEUf02bOums2+huACls15/GLlevxMDUpc1J1zSxXAzqoTX0WqbCuy
         Pa+tzvD0CkeA1Cc19dJugb8+f8mhcKK/UZzdGYvBERFOKbHzZYlMgYIx7ESwdQ6t0hQB
         BYDA==
X-Gm-Message-State: AOAM531bJW0+xQKyD6XOE+2Cl7cKiIyagxk5zz7vl3vNpI/bmBFZXUIs
        IIDecj5x2dDMBncavXJBfb4q1+HjAPJup+tp
X-Google-Smtp-Source: ABdhPJxdHK4B2Cb3vIxayPXk/fYEan1ZHojwggsf1mPZRmwWDBXzTEeY6meBbUBANog8jJdqmIUg1Q==
X-Received: by 2002:a17:902:d482:b029:ec:9091:d099 with SMTP id c2-20020a170902d482b02900ec9091d099mr9973353plg.34.1619293675126;
        Sat, 24 Apr 2021 12:47:55 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id j23sm7397845pfh.179.2021.04.24.12.47.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 24 Apr 2021 12:47:54 -0700 (PDT)
Message-ID: <608475ea.1c69fb81.3071.6192@mx.google.com>
Date:   Sat, 24 Apr 2021 12:47:54 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.4.114-1-g48c1f0d8683b
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.4
Subject: stable-rc/queue/5.4 baseline: 172 runs,
 1 regressions (v5.4.114-1-g48c1f0d8683b)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 172 runs, 1 regressions (v5.4.114-1-g48c1f0d8=
683b)

Regressions Summary
-------------------

platform           | arch | lab          | compiler | defconfig         | r=
egressions
-------------------+------+--------------+----------+-------------------+--=
----------
bcm2837-rpi-3-b-32 | arm  | lab-baylibre | gcc-8    | bcm2835_defconfig | 1=
          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.114-1-g48c1f0d8683b/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.114-1-g48c1f0d8683b
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      48c1f0d8683bef31c417e47ec5de8cb5640692cb =



Test Regressions
---------------- =



platform           | arch | lab          | compiler | defconfig         | r=
egressions
-------------------+------+--------------+----------+-------------------+--=
----------
bcm2837-rpi-3-b-32 | arm  | lab-baylibre | gcc-8    | bcm2835_defconfig | 1=
          =


  Details:     https://kernelci.org/test/plan/id/608442ecfbb234a2c29b779d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.114-1=
-g48c1f0d8683b/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rp=
i-3-b-32.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.114-1=
-g48c1f0d8683b/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rp=
i-3-b-32.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/608442ecfbb234a2c29b7=
79e
        new failure (last pass: v5.4.114) =

 =20
