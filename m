Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C3E223BAA2
	for <lists+stable@lfdr.de>; Tue,  4 Aug 2020 14:45:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727809AbgHDMpq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Aug 2020 08:45:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727928AbgHDMpd (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Aug 2020 08:45:33 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27D32C06174A
        for <stable@vger.kernel.org>; Tue,  4 Aug 2020 05:45:33 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id d188so14072096pfd.2
        for <stable@vger.kernel.org>; Tue, 04 Aug 2020 05:45:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Ujlbcz5MFI/dPWrFMlKdiMVfyAhPrjwzR1VYhv+BJ+E=;
        b=Sl4DBp1H4UJ5fxmE3eFNOu8e3O7/ubWKzT0JLFsoNdsotGdX+TPEwBG8HE8cVNSY6Z
         XNkI9QGl12Ezsaxk5WVaO7EPskUS8pNFeKL7ErGoWhkwTawsSKybw8JKcWjQJgCXsRJE
         97//kXShQuHX5mabtVP1Uwhu8g8uQv7L2VrKsOErhFknqQ7lZWTxn8JxgiaResFQ9hk0
         q2JrqUX81temhYpG5ukDConm4JzucQBHuXcClEvNtGF+R7GTSwtVUUmzRRPq7zGog5cX
         64SIV27Wh6qXYiZs3RzRmeP275xGznICV+u9GUOOzpr0ymjcOMzd/QRqD7uj07eTLbmS
         jgsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Ujlbcz5MFI/dPWrFMlKdiMVfyAhPrjwzR1VYhv+BJ+E=;
        b=HMpQ/sSO/Z6vEeRDciyPJDvn2Ii6wDYS7gGrX40iXt9N01iWyIBYZWz2lOQUtWfbIB
         NespXDRALWL6k56Qq9gLWf4V+dJYpi4A9aaAW6qUYU2TsD0y7qZVeErAH8rFL+wNrylq
         7iHEcSkNdIki80dektjqwNJRjdYtjlmJ5VagJL08m1WkfygIIuGwCj9m+r7nAVkQsXXC
         usswM1Gqag/nOFeF63KBos09peiTlTQhHaT8c+n+UPA/TRD50yF4sMHjSn18afb5kym5
         2IU7nkp7zahrx39H2TAp0XS0T/z08aQKqSQ68Tc4GMPwdXcnpp0s3kt3lHFqxcuETKl2
         M80A==
X-Gm-Message-State: AOAM530dZi59KQQE6/mTJeqEUPgv/OXg2Qy79yUI2kAaxBEyGZD5nA8p
        0Fs1HVoku11WEkkUZcUeNlZLYJ9SYuE=
X-Google-Smtp-Source: ABdhPJyxtd5SyrMN1jdN+xun5hJ2HuFArzUG6dKUw43qwhdF40PDh0liLZ5L06PRtsviSCGbqtmFbQ==
X-Received: by 2002:aa7:8182:: with SMTP id g2mr14743613pfi.261.1596545132312;
        Tue, 04 Aug 2020 05:45:32 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id n13sm2661992pjb.20.2020.08.04.05.45.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Aug 2020 05:45:31 -0700 (PDT)
Message-ID: <5f29586b.1c69fb81.da903.6ce9@mx.google.com>
Date:   Tue, 04 Aug 2020 05:45:31 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.19.136-58-g1bfc1293a1a9
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.19.y baseline: 154 runs,
 2 regressions (v4.19.136-58-g1bfc1293a1a9)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y baseline: 154 runs, 2 regressions (v4.19.136-58-g1bf=
c1293a1a9)

Regressions Summary
-------------------

platform              | arch  | lab          | compiler | defconfig | resul=
ts
----------------------+-------+--------------+----------+-----------+------=
--
bcm2837-rpi-3-b       | arm64 | lab-baylibre | gcc-8    | defconfig | 4/5  =
  =

meson-gxm-khadas-vim2 | arm64 | lab-baylibre | gcc-8    | defconfig | 0/1  =
  =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.19.y/ker=
nel/v4.19.136-58-g1bfc1293a1a9/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.19.y
  Describe: v4.19.136-58-g1bfc1293a1a9
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      1bfc1293a1a92ef3e23b572c328ceca3c2531e26 =



Test Regressions
---------------- =



platform              | arch  | lab          | compiler | defconfig | resul=
ts
----------------------+-------+--------------+----------+-----------+------=
--
bcm2837-rpi-3-b       | arm64 | lab-baylibre | gcc-8    | defconfig | 4/5  =
  =


  Details:     https://kernelci.org/test/plan/id/5f2924009a5309dc9552c1b4

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
36-58-g1bfc1293a1a9/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi=
-3-b.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
36-58-g1bfc1293a1a9/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi=
-3-b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/arm64/baseline/rootfs.cpio.gz =


  * baseline.dmesg.crit: https://kernelci.org/test/case/id/5f2924009a5309dc=
9552c1b7
      failing since 2 days (last pass: v4.19.134-105-g62c048b85133, first f=
ail: v4.19.136)
      1 lines =



platform              | arch  | lab          | compiler | defconfig | resul=
ts
----------------------+-------+--------------+----------+-----------+------=
--
meson-gxm-khadas-vim2 | arm64 | lab-baylibre | gcc-8    | defconfig | 0/1  =
  =


  Details:     https://kernelci.org/test/plan/id/5f2924ea1908c2bb6c52c1b7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
36-58-g1bfc1293a1a9/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-k=
hadas-vim2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
36-58-g1bfc1293a1a9/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-k=
hadas-vim2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/arm64/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f2924ea1908c2bb6c52c=
1b8
      new failure (last pass: v4.19.136-57-g805f2d7d066e) =20
