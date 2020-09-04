Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15E7E25E40F
	for <lists+stable@lfdr.de>; Sat,  5 Sep 2020 01:11:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728450AbgIDXK4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Sep 2020 19:10:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728376AbgIDXKx (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Sep 2020 19:10:53 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D320C061244
        for <stable@vger.kernel.org>; Fri,  4 Sep 2020 16:10:51 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id g29so5069231pgl.2
        for <stable@vger.kernel.org>; Fri, 04 Sep 2020 16:10:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=txKoretHbkLUYYqX4u6eQuV961cErRwq4AQW1Ga4MTI=;
        b=lIcQujjAuwyrRbxkfOcD0qlLxKxZZ2ueSgLrR/LjerhB7BbYjytjFEjfiwmyLlNqLo
         qVs6T4P62ZIBXR/DRMmZrXsfE5Srjrv3XG1b1T0mtLYofL+bTPT85PlvcFOyilvdQ/Ah
         +SP4yxlclvDAkIkRL+/Rl3ipgMh+Cyq1oRj5GrdWVLY0qwueE6ohSYz3At8Ilq1eWMRo
         cU28NUhF/QCckYaluaoXDjDBV+XRfaTwRjx48kCZMBPPNdLZeUMvcGRe8lBVGTo/eOnL
         57yGApzNjXqCbQzR8UDIuSTXz7cn/WOUZPm+M5Q16Zc1zyHTNchOsPYSBgkX6FV9FVET
         fKoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=txKoretHbkLUYYqX4u6eQuV961cErRwq4AQW1Ga4MTI=;
        b=pRhqtidmmdUazAehomG1igDQClVLdpc85jzhqHOpeYUcoR75MFQVzr42HdUE9sxsms
         L/zh9nzFd2JyRE4htR7jzP3GAbaWRdzYhdwwwgm447PqxOlrakf9r89/IYSk1dckGx7k
         cyreTEPtZ80/jc4ctsdgJHNXAg5W4V3t3ZIyxLKiHw7H817px6/X9MxVDIJA0hPSELJR
         RAI+dOHBeCAk5xW9kTMz1AkFbvKRIrkHwli+teQJWsfgOH/06K0HB2ZkLnytZRnHWNMm
         YidoTkS9/O9Xh1JEWD5QrV7VwD3F7olMjVC/N6185kX/6Q6YBxmptBsIImE+QBI4pDbp
         seVw==
X-Gm-Message-State: AOAM530TW7M1Q0eQGocHN+kOoTRog+HtiqdVSqvuhGiMlAjpgG3I/nTp
        ail0eD6C9NIzFJdIh3D2lAEcdFvsJBsfiQ==
X-Google-Smtp-Source: ABdhPJwHKqaTaiVyz6SuiyTwB/2kV1Op6Lsrs+NLBaUXoYHDWkLAXniRS1u0ZBzAIDd8nShu2Aou9w==
X-Received: by 2002:aa7:92c7:: with SMTP id k7mr10731955pfa.239.1599261050228;
        Fri, 04 Sep 2020 16:10:50 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 82sm6591473pgd.6.2020.09.04.16.10.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Sep 2020 16:10:49 -0700 (PDT)
Message-ID: <5f52c979.1c69fb81.5d9d4.edb2@mx.google.com>
Date:   Fri, 04 Sep 2020 16:10:49 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.4.61-231-gef2051e79e05
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-5.4.y baseline: 185 runs,
 1 regressions (v5.4.61-231-gef2051e79e05)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.4.y baseline: 185 runs, 1 regressions (v5.4.61-231-gef205=
1e79e05)

Regressions Summary
-------------------

platform        | arch  | lab          | compiler | defconfig | results
----------------+-------+--------------+----------+-----------+--------
bcm2837-rpi-3-b | arm64 | lab-baylibre | gcc-8    | defconfig | 3/4    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.4.y/kern=
el/v5.4.61-231-gef2051e79e05/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.4.y
  Describe: v5.4.61-231-gef2051e79e05
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      ef2051e79e05700a5c8814fe4d5b7a8a93503251 =



Test Regressions
---------------- =



platform        | arch  | lab          | compiler | defconfig | results
----------------+-------+--------------+----------+-----------+--------
bcm2837-rpi-3-b | arm64 | lab-baylibre | gcc-8    | defconfig | 3/4    =


  Details:     https://kernelci.org/test/plan/id/5f5291df8fcf155d88d35392

  Results:     3 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.61-=
231-gef2051e79e05/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3=
-b.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.61-=
231-gef2051e79e05/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3=
-b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/arm64/baseline/rootfs.cpio.gz =


  * baseline.dmesg.crit: https://kernelci.org/test/case/id/5f5291df8fcf155d=
88d35394
      new failure (last pass: v5.4.61-214-g04f875777fa6)
      1 lines

    2020-09-04 19:11:34.744000  Connected to bcm2837-rpi-3-b console [chann=
el connected] (~$quit to exit)
    2020-09-04 19:11:34.744000  (user:khilman) is already connected
    2020-09-04 19:11:49.866000  =00
    2020-09-04 19:11:49.866000  =

    2020-09-04 19:11:49.882000  U-Boot 2018.11 (Dec 04 2018 - 10:54:32 -080=
0)
    2020-09-04 19:11:49.882000  =

    2020-09-04 19:11:49.883000  DRAM:  948 MiB
    2020-09-04 19:11:49.898000  RPI 3 Model B (0xa02082)
    2020-09-04 19:11:49.989000  MMC:   mmc@7e202000: 0, sdhci@7e300000: 1
    2020-09-04 19:11:50.022000  Loading Environment from FAT... *** Warning=
 - bad CRC, using default environment
    ... (375 line(s) more)
      =20
