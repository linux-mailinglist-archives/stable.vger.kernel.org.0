Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC76E2AEA27
	for <lists+stable@lfdr.de>; Wed, 11 Nov 2020 08:27:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726020AbgKKH16 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Nov 2020 02:27:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725900AbgKKH15 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Nov 2020 02:27:57 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B613C0613D1
        for <stable@vger.kernel.org>; Tue, 10 Nov 2020 23:27:58 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id w20so280196pjh.1
        for <stable@vger.kernel.org>; Tue, 10 Nov 2020 23:27:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=dUoa0huY+UGsa6a5Q5yZWjfLJGwyFnTR1rJq+eKEQF8=;
        b=vr/kEUBfr4aIp5dA7PqZFYbabAIw7oIVp0zY8X5A+67Rp1HsdtL1Mfk1cwifdfIsY8
         ctGPhjmFv9dEzR/vWt7tNm9a0EpQOgnDW2/tnVPcLQU24EiwsfHD66nvAXGb4F52mWUM
         fUK84Rw95bEDGSiCjbG61hmv29dejNW9AsiFPYuYRUwueFF/pz/W0MuX0vyR6GH04MxU
         g7iddOMDg560pj4h7ZMhMbGAqG6ckVHcCAkxwLerBEDuVLWl7cuV93UuLSVCE59hJ4S4
         9c/0MXya0lL6vjopVlSsKdTbG1abPxvmbMAEYUB698IeJo41TiXuGrNw9FtT7/Td7h7H
         1ccA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=dUoa0huY+UGsa6a5Q5yZWjfLJGwyFnTR1rJq+eKEQF8=;
        b=PSLESmRIHfL4Oe9yVqmGq28HXjTAI9GwwXEZnR8zGYR865otaipbuGDTyV5ZWEUMyL
         CEMtBfdfbdrmP1zD/IjpG1uRQCT+XaiTT5HA+DAjsRrV8VYtxLe07o7fy88SX2G4/a+K
         PEkfxMnT7ssJOzHjMbNdqJZ7z1avgcEBp9pwT7YyunRWTTDpemdD4Vb1AkkAnwihtNQ0
         298mv7UOKBk22mZeZ2DoZr+Fn0EAQ5Dl79Ne1QYZhIVh+/3JCSsk/ADlZmS80giStkIO
         P0bxFo3+67KQA6vzYWk2pEAmJ/bGhBFABR59fqXtpR++VND0mVJHO61j6mtp6OMzCph0
         ihuA==
X-Gm-Message-State: AOAM532Oal3OZrY0cDkxVqyNkWmBIC0XF86sLR8LXWNsgE4JV/1VecMa
        xUVUZAFHlFZnpaTpArng8kcYwfHTfeYm4Q==
X-Google-Smtp-Source: ABdhPJyvRT24wdDy/eFytHMmR2sLzAuZJ84Ql+r9bVahzPuxMZfgPeX1gwHwYwZW82YRX9qz+mhWWQ==
X-Received: by 2002:a17:902:70cc:b029:d7:e8ad:26d4 with SMTP id l12-20020a17090270ccb02900d7e8ad26d4mr10611355plt.33.1605079677507;
        Tue, 10 Nov 2020 23:27:57 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id j24sm1287592pji.24.2020.11.10.23.27.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Nov 2020 23:27:56 -0800 (PST)
Message-ID: <5fab927c.1c69fb81.2126b.352e@mx.google.com>
Date:   Tue, 10 Nov 2020 23:27:56 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Kernel: v5.4.77
Subject: stable-rc/linux-5.4.y baseline: 193 runs, 2 regressions (v5.4.77)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.4.y baseline: 193 runs, 2 regressions (v5.4.77)

Regressions Summary
-------------------

platform        | arch  | lab           | compiler | defconfig | regressions
----------------+-------+---------------+----------+-----------+------------
bcm2837-rpi-3-b | arm64 | lab-baylibre  | gcc-8    | defconfig | 1          =

hip07-d05       | arm64 | lab-collabora | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.4.y/kern=
el/v5.4.77/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.4.y
  Describe: v5.4.77
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      2544d06afd8d060f35b159809274e4b7477e63e8 =



Test Regressions
---------------- =



platform        | arch  | lab           | compiler | defconfig | regressions
----------------+-------+---------------+----------+-----------+------------
bcm2837-rpi-3-b | arm64 | lab-baylibre  | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fab5caa62df030762db887a

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.77/=
arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.77/=
arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.dmesg.crit: https://kernelci.org/test/case/id/5fab5caa62df0307=
62db887d
        failing since 1 day (last pass: v5.4.75-42-gdbf70e69694c, first fai=
l: v5.4.75-86-g0972a1f5fd7d)
        1 lines

    2020-11-11 03:36:06.074000+00:00  Connected to bcm2837-rpi-3-b console =
[channel connected] (~$quit to exit)
    2020-11-11 03:36:06.074000+00:00  (user:khilman) is already connected
    2020-11-11 03:36:20.863000+00:00  =00
    2020-11-11 03:36:20.863000+00:00  =

    2020-11-11 03:36:20.880000+00:00  U-Boot 2018.11 (Dec 04 2018 - 10:54:3=
2 -0800)
    2020-11-11 03:36:20.881000+00:00  =

    2020-11-11 03:36:20.881000+00:00  DRAM:  948 MiB
    2020-11-11 03:36:20.896000+00:00  RPI 3 Model B (0xa02082)
    2020-11-11 03:36:20.984000+00:00  MMC:   mmc@7e202000: 0, sdhci@7e30000=
0: 1
    2020-11-11 03:36:21.016000+00:00  Loading Environment from FAT... *** W=
arning - bad CRC, using default environment =

    ... (378 line(s) more)  =

 =



platform        | arch  | lab           | compiler | defconfig | regressions
----------------+-------+---------------+----------+-----------+------------
hip07-d05       | arm64 | lab-collabora | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fab5d338c2bd2e9d5db88ad

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.77/=
arm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.77/=
arm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fab5d338c2bd2e9d5db8=
8ae
        new failure (last pass: v5.4.76) =

 =20
