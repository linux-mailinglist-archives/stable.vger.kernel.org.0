Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C78FF2AC5AC
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 21:01:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729452AbgKIUBM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 15:01:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726410AbgKIUBM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 Nov 2020 15:01:12 -0500
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F056C0613CF
        for <stable@vger.kernel.org>; Mon,  9 Nov 2020 12:01:12 -0800 (PST)
Received: by mail-pg1-x529.google.com with SMTP id z24so8080610pgk.3
        for <stable@vger.kernel.org>; Mon, 09 Nov 2020 12:01:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=cDgUNBi/yB3V7t/7Ix9Y9yGJwZCXq7QiAo5dWOlzn3w=;
        b=bGiufRCJptfsPgSiDvQw05QJV2BqlqYl4wFuoKCns0y0v7175ydjd679JmWmEiSVn7
         zHD0Ca8fCEWjLIG4TSbuirRNqEf6oH3pb4L7W/o/QHacSCVX2nDaqzqoOC6A22J1FeGX
         FGfWec2SW4TXIZgYG1US/3KRpscHdrsCq32/9OEHywfaQ+p1wwgh5MAC9AVMJAPzaoJU
         GnzY1vFTrYda5XlJYiOXWE1w7lqa310Rm9ZeXEtV5HRGFAnDqhxpqDzMpu34L2OUmnbP
         vrFsNX2S/jLo2D73EpzWvM8zAu2ZW8zTf0p5AWjOYZSKkdokBaieJ9Ud3Ii2xvBPqDxg
         ftMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=cDgUNBi/yB3V7t/7Ix9Y9yGJwZCXq7QiAo5dWOlzn3w=;
        b=KdoajSWeSClTB+mcoSrP1ibeO/v2E6P7hW1PPAgPBF337MOjp1zVx/NCA/L7qNot2d
         XaiE/NKU93/lRrjNrV9DINO8zh6RutqaeRtbTho9KS8+n+vs7JzH+gNqFO5cqlp84+cY
         J1rxHP6rQY7r/ahd3wz/10ZKPLm1zkbIGWkworHpddKyh4vtG4zN9uh2QmeyS9Cvn6jd
         /gOMhEZvbCHJKoBqRhB6Topny/z3H4SUHjBHu6bxU3/ChoLeopgi/12qpI775yoR0fls
         kFgDxR8wM88tzznCuLtXlVGdZfCc77iQUiE3em2H+fEVxyFX5g3hSlyrTU8jSbHUP9/O
         TtrA==
X-Gm-Message-State: AOAM533jOAFsE+CiJhgHU+aGsTlS19SsCEh1aXDT2rwMxiGLFH6HtAMn
        iqlTvTf/UYKs0jNs0O7o/WLye95A3roi2A==
X-Google-Smtp-Source: ABdhPJxohy4I4tmkXdWEsL6XmRi2dhSIgOo9/I8pTuRuVMsRJGA4y1lJfCMgYx9ZdgmMlbVxlVg8EQ==
X-Received: by 2002:a63:7847:: with SMTP id t68mr9294255pgc.422.1604952071831;
        Mon, 09 Nov 2020 12:01:11 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id f7sm4387410pfe.30.2020.11.09.12.01.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Nov 2020 12:01:11 -0800 (PST)
Message-ID: <5fa9a007.1c69fb81.125c.9ec6@mx.google.com>
Date:   Mon, 09 Nov 2020 12:01:11 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Kernel: v5.4.75-86-g0972a1f5fd7d
Subject: stable-rc/linux-5.4.y baseline: 202 runs,
 1 regressions (v5.4.75-86-g0972a1f5fd7d)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.4.y baseline: 202 runs, 1 regressions (v5.4.75-86-g0972a1=
f5fd7d)

Regressions Summary
-------------------

platform        | arch  | lab          | compiler | defconfig | regressions
----------------+-------+--------------+----------+-----------+------------
bcm2837-rpi-3-b | arm64 | lab-baylibre | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.4.y/kern=
el/v5.4.75-86-g0972a1f5fd7d/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.4.y
  Describe: v5.4.75-86-g0972a1f5fd7d
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      0972a1f5fd7d894036d1060885a60a3c7f702de3 =



Test Regressions
---------------- =



platform        | arch  | lab          | compiler | defconfig | regressions
----------------+-------+--------------+----------+-----------+------------
bcm2837-rpi-3-b | arm64 | lab-baylibre | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fa96f5aae021aeb8bdb887c

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.75-=
86-g0972a1f5fd7d/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-=
b.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.75-=
86-g0972a1f5fd7d/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-=
b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.dmesg.crit: https://kernelci.org/test/case/id/5fa96f5aae021aeb=
8bdb887f
        new failure (last pass: v5.4.75-42-gdbf70e69694c)
        1 lines

    2020-11-09 16:31:25.071000+00:00  Connected to bcm2837-rpi-3-b console =
[channel connected] (~$quit to exit)
    2020-11-09 16:31:25.072000+00:00  (user:khilman) is already connected
    2020-11-09 16:31:40.253000+00:00  =00
    2020-11-09 16:31:40.253000+00:00  =

    2020-11-09 16:31:40.253000+00:00  U-Boot 2018.11 (Dec 04 2018 - 10:54:3=
2 -0800)
    2020-11-09 16:31:40.253000+00:00  =

    2020-11-09 16:31:40.254000+00:00  DRAM:  948 MiB
    2020-11-09 16:31:40.268000+00:00  RPI 3 Model B (0xa02082)
    2020-11-09 16:31:40.355000+00:00  MMC:   mmc@7e202000: 0, sdhci@7e30000=
0: 1
    2020-11-09 16:31:40.387000+00:00  Loading Environment from FAT... *** W=
arning - bad CRC, using default environment =

    ... (376 line(s) more)  =

 =20
