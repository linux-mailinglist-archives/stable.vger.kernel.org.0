Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9E2C297CDC
	for <lists+stable@lfdr.de>; Sat, 24 Oct 2020 16:42:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1762059AbgJXOmG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 24 Oct 2020 10:42:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1762030AbgJXOmE (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 24 Oct 2020 10:42:04 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7A42C0613CE
        for <stable@vger.kernel.org>; Sat, 24 Oct 2020 07:42:03 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id f19so3513521pfj.11
        for <stable@vger.kernel.org>; Sat, 24 Oct 2020 07:42:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=dUtXiGmh2KgLVULOOU7MkcLtaeXePW+NItGbid0cBKM=;
        b=BV/fdQUr12xfZyvJtEQHLK8YYmErGQsX4PIvqOclEWpzOCccNFmECYIDXRYNyVNuXY
         62a1QDFM4EOLdrNAiGRcFp5yr2L8Rq/rt1XzUgxWVRPUCI5Ur2TfHjy0Wnig7L6Mmtzl
         DhiRPSfHZO8MahnuvAbB5kfeCbQYokgTOu921rupbhVPVCSl+ZkUIH641GYDgLaZDONT
         uj6DFhSK5n6mqChu4FOPNADW5mRt6w8jL2hbbdMwTO6nbRigdYfn+FvnVk7Q7niPw5Cx
         rlBhaRfFxI5auZHXq+b8shWWf7MMgwX/JUcDgzr+gBsiL+6vYLKFR5XI9dtMGaqyBzXC
         DRFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=dUtXiGmh2KgLVULOOU7MkcLtaeXePW+NItGbid0cBKM=;
        b=bO7y+0/k5+exasdFpe+FjKzY8h1O62xdyNefQxInr47SMDUE4pces6ttXKyfOpJb82
         AWsWQAUJjX0sxE7ZCX44zdQh8/RJSg97r+GChrhowmyWg0pxbOdn2LPd2AHEkMgZTyea
         OBpA15Ii27idOsXTapjik+h3TrokQ26imbJb2udEvD7araa30gCwdVIaFkl3KR4Maqob
         TWwYtZYWzheUtJrx4goy0P2j7y9zOq2yAa3BUtgKhG3EysD3mUytE7rLctDNK/jPe44l
         UjRUOGhPcZu7cCkWqN0bzieo7gNQiWS7WplD8eVUFDfbuj8hZ7LleBKzBhLi9aHuzMdp
         cqYw==
X-Gm-Message-State: AOAM531MOUBJresCeQdGWaljJk74/ltepZDLpl/AlIh11nrGAYpi89q+
        qta0sCNdPQ11q9wTqgwUUFacNnLghwN+Pw==
X-Google-Smtp-Source: ABdhPJw9CxAoQ5rvgIOdrIPYBzIYDWTmobi0GzothExyJmW8mdHCPBqYeQFoVbd9HOnY9ffUvklOWg==
X-Received: by 2002:a63:7351:: with SMTP id d17mr6269142pgn.376.1603550522898;
        Sat, 24 Oct 2020 07:42:02 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id j20sm6066382pfd.40.2020.10.24.07.42.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 24 Oct 2020 07:42:02 -0700 (PDT)
Message-ID: <5f943d3a.1c69fb81.7e59b.b151@mx.google.com>
Date:   Sat, 24 Oct 2020 07:42:02 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.152-30-g31ec31f50737
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.19
Subject: stable-rc/queue/4.19 baseline: 169 runs,
 2 regressions (v4.19.152-30-g31ec31f50737)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 169 runs, 2 regressions (v4.19.152-30-g31ec3=
1f50737)

Regressions Summary
-------------------

platform        | arch  | lab           | compiler | defconfig           | =
regressions
----------------+-------+---------------+----------+---------------------+-=
-----------
bcm2837-rpi-3-b | arm64 | lab-baylibre  | gcc-8    | defconfig           | =
1          =

panda           | arm   | lab-collabora | gcc-8    | omap2plus_defconfig | =
1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.152-30-g31ec31f50737/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.152-30-g31ec31f50737
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      31ec31f50737fbc6e5d4c4222f62e81458cdc897 =



Test Regressions
---------------- =



platform        | arch  | lab           | compiler | defconfig           | =
regressions
----------------+-------+---------------+----------+---------------------+-=
-----------
bcm2837-rpi-3-b | arm64 | lab-baylibre  | gcc-8    | defconfig           | =
1          =


  Details:     https://kernelci.org/test/plan/id/5f9405e49806c6cb0338102b

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.152=
-30-g31ec31f50737/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3=
-b.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.152=
-30-g31ec31f50737/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3=
-b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.dmesg.crit: https://kernelci.org/test/case/id/5f9405e49806c6cb=
03381030
        failing since 1 day (last pass: v4.19.152-15-g0ea747efc059, first f=
ail: v4.19.152-15-gc47f727e21ba)
        1 lines

    2020-10-24 10:43:12.947000+00:00  Connected to bcm2837-rpi-3-b console =
[channel connected] (~$quit to exit)
    2020-10-24 10:43:12.947000+00:00  (user:khilman) is already connected
    2020-10-24 10:43:28.097000+00:00  =00
    2020-10-24 10:43:28.098000+00:00  =

    2020-10-24 10:43:28.098000+00:00  U-Boot 2018.11 (Dec 04 2018 - 10:54:3=
2 -0800)
    2020-10-24 10:43:28.098000+00:00  =

    2020-10-24 10:43:28.098000+00:00  DRAM:  948 MiB
    2020-10-24 10:43:28.113000+00:00  RPI 3 Model B (0xa02082)
    2020-10-24 10:43:28.199000+00:00  MMC:   mmc@7e202000: 0, sdhci@7e30000=
0: 1
    2020-10-24 10:43:28.231000+00:00  Loading Environment from FAT... *** W=
arning - bad CRC, using default environment =

    ... (378 line(s) more)  =

 =



platform        | arch  | lab           | compiler | defconfig           | =
regressions
----------------+-------+---------------+----------+---------------------+-=
-----------
panda           | arm   | lab-collabora | gcc-8    | omap2plus_defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/5f940a5da3f7565d41381035

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.152=
-30-g31ec31f50737/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.152=
-30-g31ec31f50737/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5f940a5da3f7565=
d4138103c
        new failure (last pass: v4.19.152-15-gc47f727e21ba)
        2 lines =

 =20
