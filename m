Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D14729A2B5
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 03:36:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728398AbgJ0CgZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Oct 2020 22:36:25 -0400
Received: from mail-pg1-f169.google.com ([209.85.215.169]:39803 "EHLO
        mail-pg1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728350AbgJ0CgY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Oct 2020 22:36:24 -0400
Received: by mail-pg1-f169.google.com with SMTP id o7so7171978pgv.6
        for <stable@vger.kernel.org>; Mon, 26 Oct 2020 19:36:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=rnnVaKu1Pu8L0/o2bENl9hRVLlJihQip67uZKNC4KfE=;
        b=iYysOYySxgCIhlAKrFSHevohmW4HRIEF8XnLSFaGlr/7ip0nb1qHtT06nT6FYx7Yq3
         LseN30lvle71b5fsNulLMku9ssQO78WU6nH/KZeS6mbo2W8GfAeUeMRFm2rjxJ5hBDpL
         jpUsNttccuuMCYvypA2Aik8N+c2TnYp0no9ADalNfMj38nsOarTD0i+lodnMzJvPz3ll
         CAlEkMCNKQ5QxhnWPc0uutIQQJHfRU2ecT9OyRSw8nx2ShZecCKkQmJOeDwJQIvt8+X8
         OYwhE+vDudUgaJcrO8QubmdRVV2aO8eFAXb8WVVvocW4FqOwcNjlsDQxIGzLpRrQPNNH
         +wCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=rnnVaKu1Pu8L0/o2bENl9hRVLlJihQip67uZKNC4KfE=;
        b=eYfWPXTOTKtjX/T59JNmVKjEWe7C7oFIlbz2lPku/W9K/ALfnwWzsNwCt1mARg4i66
         RElzyogjR3a5kkbDnUDMDqjz3xtxibR0CA0HTqx1mgAs/Nu0ovrAOEcZY0XIY4Stnj7T
         dk7Yd1cS/dt/9+t9CPiGokyjD2r5sQerG1xZsKhEE7MO8DhH+wHGzP54+78/PmouKcP7
         FYsOnOLoQCTWCi/0rUBP9VWX59+MmJIIGPInp1Xe7PZNivJ1qmAjSu1/TYKewrD77Waq
         nrGNdwOrwGYMWH61UJpnrA36Dl8tAWkvqnwd0ng4/LECC0npi5Vzo9hX0XO9EQcnMp/Z
         dB/g==
X-Gm-Message-State: AOAM533KX0UhQGM4am7+boNIAIgoJS6h3johOgjMetf864qXJygqqvRt
        CU77kw1l8i5ekxclE5l8Pt9qQF7zfb1t5Q==
X-Google-Smtp-Source: ABdhPJx1C9+IE+LEZXUjIZSDfuu3EyftJuSh+wWBBCph7laHDzy5Ajob1J0mmTUsneNls9EJ8IOHMw==
X-Received: by 2002:a62:51c4:0:b029:160:922:d7a1 with SMTP id f187-20020a6251c40000b02901600922d7a1mr77728pfb.34.1603766183662;
        Mon, 26 Oct 2020 19:36:23 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id o65sm12303394pga.42.2020.10.26.19.36.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Oct 2020 19:36:23 -0700 (PDT)
Message-ID: <5f9787a7.1c69fb81.a2844.9375@mx.google.com>
Date:   Mon, 26 Oct 2020 19:36:23 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.4.72-403-g1e06eeaf2ced
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.4
Subject: stable-rc/queue/5.4 baseline: 178 runs,
 3 regressions (v5.4.72-403-g1e06eeaf2ced)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 178 runs, 3 regressions (v5.4.72-403-g1e06eea=
f2ced)

Regressions Summary
-------------------

platform              | arch  | lab          | compiler | defconfig        =
  | regressions
----------------------+-------+--------------+----------+------------------=
--+------------
at91-sama5d4_xplained | arm   | lab-baylibre | gcc-8    | sama5_defconfig  =
  | 1          =

bcm2837-rpi-3-b       | arm64 | lab-baylibre | gcc-8    | defconfig        =
  | 1          =

stm32mp157c-dk2       | arm   | lab-baylibre | gcc-8    | multi_v7_defconfi=
g | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.72-403-g1e06eeaf2ced/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.72-403-g1e06eeaf2ced
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      1e06eeaf2cedfba12bad16d1702c473221e13d67 =



Test Regressions
---------------- =



platform              | arch  | lab          | compiler | defconfig        =
  | regressions
----------------------+-------+--------------+----------+------------------=
--+------------
at91-sama5d4_xplained | arm   | lab-baylibre | gcc-8    | sama5_defconfig  =
  | 1          =


  Details:     https://kernelci.org/test/plan/id/5f9754193cea56b181381029

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sama5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.72-40=
3-g1e06eeaf2ced/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5d=
4_xplained.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.72-40=
3-g1e06eeaf2ced/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5d=
4_xplained.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5f9754193cea56b181381=
02a
        failing since 2 days (last pass: v5.4.72-24-g088b4440ff14, first fa=
il: v5.4.72-54-g5ae53d8d80cb) =

 =



platform              | arch  | lab          | compiler | defconfig        =
  | regressions
----------------------+-------+--------------+----------+------------------=
--+------------
bcm2837-rpi-3-b       | arm64 | lab-baylibre | gcc-8    | defconfig        =
  | 1          =


  Details:     https://kernelci.org/test/plan/id/5f97551405992123fb381012

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.72-40=
3-g1e06eeaf2ced/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.72-40=
3-g1e06eeaf2ced/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.dmesg.crit: https://kernelci.org/test/case/id/5f97551405992123=
fb381017
        failing since 0 day (last pass: v5.4.72-402-g22eb6f319bc6, first fa=
il: v5.4.72-402-ga4d1bb864783)
        1 lines

    2020-10-26 22:58:37.989000+00:00  Connected to bcm2837-rpi-3-b console =
[channel connected] (~$quit to exit)
    2020-10-26 22:58:37.990000+00:00  (user:khilman) is already connected
    2020-10-26 22:58:53.754000+00:00  =00
    2020-10-26 22:58:53.754000+00:00  =

    2020-10-26 22:58:53.754000+00:00  U-Boot 2018.11 (Dec 04 2018 - 10:54:3=
2 -0800)
    2020-10-26 22:58:53.769000+00:00  =

    2020-10-26 22:58:53.769000+00:00  DRAM:  948 MiB
    2020-10-26 22:58:53.785000+00:00  RPI 3 Model B (0xa02082)
    2020-10-26 22:58:53.875000+00:00  MMC:   mmc@7e202000: 0, sdhci@7e30000=
0: 1
    2020-10-26 22:58:53.907000+00:00  Loading Environment from FAT... *** W=
arning - bad CRC, using default environment =

    ... (376 line(s) more)  =

 =



platform              | arch  | lab          | compiler | defconfig        =
  | regressions
----------------------+-------+--------------+----------+------------------=
--+------------
stm32mp157c-dk2       | arm   | lab-baylibre | gcc-8    | multi_v7_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/5f9758640285e2bd7c381016

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.72-40=
3-g1e06eeaf2ced/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-stm32mp1=
57c-dk2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.72-40=
3-g1e06eeaf2ced/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-stm32mp1=
57c-dk2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5f9758640285e2bd7c381=
017
        failing since 0 day (last pass: v5.4.72-54-gc97bc0eb3ef2, first fai=
l: v5.4.72-402-g22eb6f319bc6) =

 =20
