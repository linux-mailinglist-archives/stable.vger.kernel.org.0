Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94FE82908A9
	for <lists+stable@lfdr.de>; Fri, 16 Oct 2020 17:40:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407437AbgJPPkj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Oct 2020 11:40:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406010AbgJPPkj (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Oct 2020 11:40:39 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93BACC061755
        for <stable@vger.kernel.org>; Fri, 16 Oct 2020 08:40:39 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id l18so1690348pgg.0
        for <stable@vger.kernel.org>; Fri, 16 Oct 2020 08:40:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=U5aZC7DhJAY0VjsGA/khRQQeO0Imm5xNrS+/3gBxpFU=;
        b=Z5XNG664eSDD7GDZn3pUd8FDpitB7LdUVpljuD+vyJZr3mdyYzxsjLPaokldOLLbJe
         m/arUX/X4k+D2eBIvRdMI0IzBrUkExpNuFGdvaizCCT/ZSv3oZvDmtJnotv4+CwtwGD3
         r5TEtws8Q6Lhc26GMh2oCGBZMIJEaGWGivX3STY/8EQsHfdPcJ5fjVVPznXHaX8lAFF3
         3zybRbxj6ntdQy3nx32CpRIGhlqK3HvTNpyomhC7mSZpXrJFnUQC+D74b1b1Wbalommr
         lMjPtBvogUk+m2lB0lYS5rLXhnca/eRpzZUjDaro/CTKR6XRzhPQqLOhtX6ITZ4Vzlre
         xw8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=U5aZC7DhJAY0VjsGA/khRQQeO0Imm5xNrS+/3gBxpFU=;
        b=kfpAG+ho3aAXBTdlFlJulQO7uAWoAqSZp1gfw5dz0pKDs55DNpFeicD74RI0OvCfH/
         5NVd+CLBE7kCXWtAg7ZvcLpIrqtaEPOx3cthtQR2T41pBXE76xTHuAR/0JqHqvRaWWBf
         SiNy3jBZEPGiG6Kmgd73Uagtc0uK0Ydq6UgQu14fg4fPVwVpRKSrgT7uywXdPSxz8F2D
         Ls80bWpszEgGu9F+sci23O/c7mDmAnWiZa9mvuLI2D2J7jgXzjUAMMxLt3rAwoKRbx9m
         +cB/+UYnwITpJBfr6n1fmX21clbhO7CbmADKgXP6/TAKX6qGR6N+9CPyXRvoAdfCAoyz
         hblQ==
X-Gm-Message-State: AOAM530I89+X4ER31siMXcFYsw5f2XtDPJgSLzsmg1TS+VAlwcGNStln
        qXRIoUgYOEQYnZi3Y/geLEwMjSBafdY5Bw==
X-Google-Smtp-Source: ABdhPJz9mcSz0u34vxtagr1ywhy91SyeSSQ+tv+LMW//fPCAWQABzeugTlitUjoKTuANEPysywtQ/g==
X-Received: by 2002:aa7:93b6:0:b029:155:3b0b:d47a with SMTP id x22-20020aa793b60000b02901553b0bd47amr4265214pff.47.1602862838683;
        Fri, 16 Oct 2020 08:40:38 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id e19sm3285372pff.34.2020.10.16.08.40.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Oct 2020 08:40:37 -0700 (PDT)
Message-ID: <5f89bef5.1c69fb81.8fc63.6962@mx.google.com>
Date:   Fri, 16 Oct 2020 08:40:37 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.8.15-15-ga69084e6863a
X-Kernelci-Branch: linux-5.8.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-5.8.y baseline: 206 runs,
 1 regressions (v5.8.15-15-ga69084e6863a)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.8.y baseline: 206 runs, 1 regressions (v5.8.15-15-ga69084=
e6863a)

Regressions Summary
-------------------

platform        | arch  | lab          | compiler | defconfig | results
----------------+-------+--------------+----------+-----------+--------
bcm2837-rpi-3-b | arm64 | lab-baylibre | gcc-8    | defconfig | 3/4    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.8.y/kern=
el/v5.8.15-15-ga69084e6863a/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.8.y
  Describe: v5.8.15-15-ga69084e6863a
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      a69084e6863a56b57c00d2ab5f4da07ea351cdd7 =



Test Regressions
---------------- =



platform        | arch  | lab          | compiler | defconfig | results
----------------+-------+--------------+----------+-----------+--------
bcm2837-rpi-3-b | arm64 | lab-baylibre | gcc-8    | defconfig | 3/4    =


  Details:     https://kernelci.org/test/plan/id/5f897fa38ee8ace11c4ff3e0

  Results:     3 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.8.y/v5.8.15-=
15-ga69084e6863a/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-=
b.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.8.y/v5.8.15-=
15-ga69084e6863a/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-=
b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-3-g27eeeac7da2d/arm64/baseline/rootfs.cpio.gz =


  * baseline.dmesg.crit: https://kernelci.org/test/case/id/5f897fa38ee8ace1=
1c4ff3e4
      failing since 0 day (last pass: v5.8.14-125-gf4ed6fb8f168, first fail=
: v5.8.15)
      2 lines

    2020-10-16 11:07:37.743000  Connected to bcm2837-rpi-3-b console [chann=
el connected] (~$quit to exit)
    2020-10-16 11:07:37.743000  (user:khilman) is already connected
    2020-10-16 11:07:54.254000  =00
    2020-10-16 11:07:54.254000  =

    2020-10-16 11:07:54.255000  U-Boot 2018.11 (Dec 04 2018 - 10:54:32 -080=
0)
    2020-10-16 11:07:54.255000  =

    2020-10-16 11:07:54.255000  DRAM:  948 MiB
    2020-10-16 11:07:54.270000  RPI 3 Model B (0xa02082)
    2020-10-16 11:07:54.359000  MMC:   mmc@7e202000: 0, sdhci@7e300000: 1
    2020-10-16 11:07:54.389000  Loading Environment from FAT... *** Warning=
 - bad CRC, using default environment
    ... (389 line(s) more)
      =20
