Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EF6B30BABC
	for <lists+stable@lfdr.de>; Tue,  2 Feb 2021 10:18:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232676AbhBBJQF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 04:16:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232956AbhBBJOD (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Feb 2021 04:14:03 -0500
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05F59C06178B
        for <stable@vger.kernel.org>; Tue,  2 Feb 2021 01:12:38 -0800 (PST)
Received: by mail-pg1-x529.google.com with SMTP id b21so14483910pgk.7
        for <stable@vger.kernel.org>; Tue, 02 Feb 2021 01:12:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=WRVCaeEpvENHwxyMIqaj0zOilDIR/vriLZZwK+QI+fQ=;
        b=SlDfk9hjChf9YfYCP7CM/jQ8TWNG0b19Ch5iRhHcrfBM56zSkh4WkVKPFGNYE4ZkxC
         OYFimAUHNmlTeT/FLG49d82ZAjLfxkHtDS8Kh5NvpfSryRqADVia0wTXXzODI2n/1Xiz
         oeWjTzAAupvORZpd0kgs2IurKw7vG2g+NLBok7hnaHxbL1D3UzOxlPz+fOhYtB91Qoqj
         oUxfI0xA1c4rjYafGhhFlHXuX7IoaTtHP+h+vDk8+bLn20aeMUXvrJXsRVXtrLcyhe8o
         0Wfsn9LNZNrGsIjJpNqD4tQw/pnETRqKKPGz/JLN1n4ErBsl83SbBubHpzSZKqbv4V3Q
         8vWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=WRVCaeEpvENHwxyMIqaj0zOilDIR/vriLZZwK+QI+fQ=;
        b=P7IOPSizl6NtPB3yeeCbKeFcowpsze1Mwk2wqLm/pPPsaM7WkHPN+RwuOvUbACfF6B
         +CviG+9PDG2fMDK270/xuwcK7lK8tC4fbYxVg/k7EpUhCAoUfiDLMSzf7heB9n4jqGle
         TIBA7JRmoK/e2yOGad1hH6p1z3v8jUz8ukqWz/7Di0qMAAsiWVNFpZRRUKfrUr3XyB7O
         fqQRixqK5oBNmiga5weOj0BMigDSgNf42JwUpkS/Cse3Jsxw94ot77bdekj4sfpf6rJ3
         yljHgpvNk46f0GWiRHy+/oI/Qd6SgbngdYf8FqTVC2L0GJfgrv+bamNy/R04HG6km6lm
         86Eg==
X-Gm-Message-State: AOAM532ZHUFZOA3Tok3ZIBAolezkRfK5VVQPtSp4xu8JPGN9JTuBLX2Z
        hbKNT6Nw6auJ6r2nkB/bsf5uYNw4RblFWg==
X-Google-Smtp-Source: ABdhPJyBdToDEOhO19gGjnJbegV+SdmzuXAqKAK9DEZYkli2P+S5NCW9JwsD+CUQCCDpT6DaV2Lp1g==
X-Received: by 2002:a63:4f1e:: with SMTP id d30mr7730262pgb.203.1612257157185;
        Tue, 02 Feb 2021 01:12:37 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id j4sm15540757pfa.131.2021.02.02.01.12.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Feb 2021 01:12:36 -0800 (PST)
Message-ID: <60191784.1c69fb81.c7a8.4641@mx.google.com>
Date:   Tue, 02 Feb 2021 01:12:36 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.10.12-131-gd0ba7d735ad1d
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
Subject: stable-rc/queue/5.10 baseline: 181 runs,
 2 regressions (v5.10.12-131-gd0ba7d735ad1d)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 181 runs, 2 regressions (v5.10.12-131-gd0ba7=
d735ad1d)

Regressions Summary
-------------------

platform           | arch  | lab          | compiler | defconfig         | =
regressions
-------------------+-------+--------------+----------+-------------------+-=
-----------
bcm2837-rpi-3-b-32 | arm   | lab-baylibre | gcc-8    | bcm2835_defconfig | =
1          =

imx8mp-evk         | arm64 | lab-nxp      | gcc-8    | defconfig         | =
1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.12-131-gd0ba7d735ad1d/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.12-131-gd0ba7d735ad1d
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      d0ba7d735ad1d3bac65370270608a138aac73c79 =



Test Regressions
---------------- =



platform           | arch  | lab          | compiler | defconfig         | =
regressions
-------------------+-------+--------------+----------+-------------------+-=
-----------
bcm2837-rpi-3-b-32 | arm   | lab-baylibre | gcc-8    | bcm2835_defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/6018b3d40b99a8631ed3dfd4

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.12-=
131-gd0ba7d735ad1d/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm283=
7-rpi-3-b-32.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.12-=
131-gd0ba7d735ad1d/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm283=
7-rpi-3-b-32.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.alert: https://kernelci.org/test/case/id/6018b3d40b99a86=
31ed3dfd8
        new failure (last pass: v5.10.12-31-g38757cf9716b)
        51 lines

    2021-02-02 02:06:58.891000+00:00  <4>[   15.635835] page:ad569f8f refco=
unt:-382871556 mapcount:-509558775 mapping:3666783e index:0x42 pfn:0x275f
    2021-02-02 02:06:58.892000+00:00  <4>[   15.645785] aops:ramfs_aops ino=
:1e35 dentry name:\"libc-2.30.so\"
    2021-02-02 02:06:58.893000+00:00  <4>[   15.652093] flags: 0x10081e(ref=
erenced|uptodate|dirty|lru|arch_1|unevictable)
    2021-02-02 02:06:58.928000+00:00  <4>[   15.659638] raw: 0010081e eaa66=
bc4 eaa66c04 c1bd90f0 00000042 00000000 e1a0c008 e92dd7fc
    2021-02-02 02:06:58.933000+00:00  <4>[   15.668138] page dumped because=
: bad pte
    2021-02-02 02:06:58.935000+00:00  <1>[   15.672391] addr:b6e6a000 vm_fl=
ags:00000075 anon_vma:00000000 mapping:c1bd90f0 index:42
    2021-02-02 02:06:58.935000+00:00  <1>[   15.680814] file:libc-2.30.so f=
ault:filemap_fault mmap:generic_file_mmap readpage:simple_readpage
    2021-02-02 02:06:58.936000+00:00  <4>[   15.690104] CPU: 0 PID: 164 Com=
m: lava-test-case Tainted: G    B   WC        5.10.12 #1
    2021-02-02 02:06:58.938000+00:00  <4>[   15.698518] Hardware name: BCM2=
835
    2021-02-02 02:06:58.938000+00:00  <4>[   15.702258] Backtrace:  =

    ... (157 line(s) more)  =

 =



platform           | arch  | lab          | compiler | defconfig         | =
regressions
-------------------+-------+--------------+----------+-------------------+-=
-----------
imx8mp-evk         | arm64 | lab-nxp      | gcc-8    | defconfig         | =
1          =


  Details:     https://kernelci.org/test/plan/id/6018b947a62deceda5d3dfee

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.12-=
131-gd0ba7d735ad1d/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.12-=
131-gd0ba7d735ad1d/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6018b947a62deceda5d3d=
fef
        failing since 1 day (last pass: v5.10.12-3-g0bb4aea7b36b5, first fa=
il: v5.10.12-31-g38757cf9716b) =

 =20
