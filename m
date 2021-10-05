Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F03F422B74
	for <lists+stable@lfdr.de>; Tue,  5 Oct 2021 16:48:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235134AbhJEOuB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Oct 2021 10:50:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233705AbhJEOuA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Oct 2021 10:50:00 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34457C061749
        for <stable@vger.kernel.org>; Tue,  5 Oct 2021 07:48:10 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id t11so2465844plq.11
        for <stable@vger.kernel.org>; Tue, 05 Oct 2021 07:48:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ZYi80wlv8slaIWo/MSzP3nRyF1T0UPuqK+RbrW1n+vI=;
        b=UeZo4Td/oH93Dv946zLDG0On0l7r+l4kiUYrRaQaZgruZpVioS4vCRrVVI/oqZk+wz
         GeOt+6Ou5J6FciqlOwUqzd1YvICL1utd8kr3tyCccNgy5Oh0ITyb3FHlkAtNFoWhIQsQ
         SuUymeeY9M9MYB+tHwFASUXs9ul5Xze8RPMNyjnCYmtJBPab67lJL+uBBMnIQE2fpwzd
         yJiJXHq8RdlWUA9D71XLVyHLiuqmAzLG5ggQ9c6cwihxyvKwQWHXDNbvHSXkcmbOZrU+
         pCXRNCU1rBGwp3wmVjtubtf3r+536N3fmPl4z2jYDBbQhz8z3pD6qtlxZovXMsknVe+C
         uk+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ZYi80wlv8slaIWo/MSzP3nRyF1T0UPuqK+RbrW1n+vI=;
        b=pld8vsG99sv4llIlYaJ7L3DmcKr/YsDbekXzOxk9xdL9OnttQMbakL1bLQLE1whU/b
         OgiEsHGUfLI0bUGR3pq8gD/xkV2hVVhj67xjzLkJ+BBjP6mq+sGjc6ZGDBcpOPqJjzbG
         VzjY0HqDPRkKYOYYVxNk0ZsJJyCzTnpKJhg75BpdFgfUNRY8E1KYXUGrProcHzu4Lqoo
         9bbKvzD7aD50PhdiKuE3d2uUgcGJMMwVQo/y1Uz5G6eqgVTP+6xPRWKj0cOpRVmXmA3f
         0lf/3T8v/TCmG050B4T1hKT6986CVtgYRvFVmyiquFDeLKS1Os/vRWz6Jd14f8xvvVZ9
         qIKw==
X-Gm-Message-State: AOAM533dpVlfC6Wc10N1AZRUZpc3pLZwKN82jQjojJ+bGe1yQQY2pZW9
        +Gd3FqCtcZTuSXNIybv9y5kiOnfTRleKhy9e
X-Google-Smtp-Source: ABdhPJwJlFsIG8z6993KuQOdgyQ+hRsHC27cb35vdNsfci597z1dhapYB5NfWL3ifuO8s5pvtpVXEA==
X-Received: by 2002:a17:90a:df82:: with SMTP id p2mr2158098pjv.72.1633445289341;
        Tue, 05 Oct 2021 07:48:09 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id q11sm2576341pjf.14.2021.10.05.07.48.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Oct 2021 07:48:09 -0700 (PDT)
Message-ID: <615c65a9.1c69fb81.878f0.7893@mx.google.com>
Date:   Tue, 05 Oct 2021 07:48:09 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.248-76-gb56df9ef1a53
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.14.y
Subject: stable-rc/linux-4.14.y baseline: 110 runs,
 3 regressions (v4.14.248-76-gb56df9ef1a53)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y baseline: 110 runs, 3 regressions (v4.14.248-76-gb56=
df9ef1a53)

Regressions Summary
-------------------

platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-baylibre | gcc-8    | versatile_defconfig=
 | 1          =

qemu_arm-versatilepb | arm  | lab-broonie  | gcc-8    | versatile_defconfig=
 | 1          =

qemu_arm-versatilepb | arm  | lab-cip      | gcc-8    | versatile_defconfig=
 | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.14.y/ker=
nel/v4.14.248-76-gb56df9ef1a53/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.14.y
  Describe: v4.14.248-76-gb56df9ef1a53
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      b56df9ef1a53d484fa3653206dd4ae0e5c45c6ff =



Test Regressions
---------------- =



platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-baylibre | gcc-8    | versatile_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/615c2956067bcdc96299a2de

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-76-gb56df9ef1a53/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-76-gb56df9ef1a53/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615c2956067bcdc96299a=
2df
        failing since 324 days (last pass: v4.14.206-21-gf1262f26e4d0, firs=
t fail: v4.14.206-23-g520c3568920c8) =

 =



platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-broonie  | gcc-8    | versatile_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/615c44a2547da231ec99a2e6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-76-gb56df9ef1a53/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-76-gb56df9ef1a53/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615c44a2547da231ec99a=
2e7
        failing since 324 days (last pass: v4.14.206-21-gf1262f26e4d0, firs=
t fail: v4.14.206-23-g520c3568920c8) =

 =



platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-cip      | gcc-8    | versatile_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/615c2a6f240ff89a3899a30d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-76-gb56df9ef1a53/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
48-76-gb56df9ef1a53/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615c2a6f240ff89a3899a=
30e
        failing since 324 days (last pass: v4.14.206-21-gf1262f26e4d0, firs=
t fail: v4.14.206-23-g520c3568920c8) =

 =20
