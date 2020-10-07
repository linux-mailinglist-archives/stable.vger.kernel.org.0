Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1549E28681D
	for <lists+stable@lfdr.de>; Wed,  7 Oct 2020 21:13:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727878AbgJGTN3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Oct 2020 15:13:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726111AbgJGTN2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 7 Oct 2020 15:13:28 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB292C061755
        for <stable@vger.kernel.org>; Wed,  7 Oct 2020 12:13:28 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id b26so1924202pff.3
        for <stable@vger.kernel.org>; Wed, 07 Oct 2020 12:13:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=CVO28xEJVEehVtoeweWkvt04N7wErVhz7zBJwHaTvus=;
        b=w0Jnhz0Xr9/e9rqJkZ7+Q5vuUHmT49k4iaeB8OxK6CEaaapHZwfzSL4XkjWzx7rcQU
         CMxwdgpF7FhYao1hxF3RFZblyIELBe9h23tdKzYjWEOyBRFa0YVSlbP6OxdCRebQEyv5
         3VHaEApqGv01fYwbqDTmXrtjNPuA7cVNdAqjpjdcpiMkVkU42JJcifSo/hiPcLDbbKPK
         CjKRxOmDDwYD/Czo9Fn7yCsMAIOPvGimCD1WjB9xLx+d48BuQJXxSEp02vhohW9x5KuI
         iTG9vTz/4xVKeRQmAmsZjF5HN1C54PsCnUdjTr+5yblE0bQD8EQz+u7EYworVTO1NUdH
         +GIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=CVO28xEJVEehVtoeweWkvt04N7wErVhz7zBJwHaTvus=;
        b=VvjAOWT+zAzZN0YyfB7djuFCNXU+f+Siad9fDzCEJl4A6P12F4Rr8I9f+7j7eHqeWU
         qc4D+eGqhtJFOd/pY4vQKBsHJjVYH5PBC5f/Gwn5izBu1em4sSJl/nvFaoNwxWd7ZFqb
         o1uF7qVvWH9VhlThNK+WyhZb57Qtz0tS/7fngx3GHWUHxaen3nVtQx4suXhovAzmuQQJ
         hwArO+WtO+2fsxe0vQplEEuBN4MSUmfqEb5MeY9/mQ8YVHicLUMbOm/RpDvbBG3nbdy6
         NXylVksgHOtMI6mornSPNsCOVb2ZZo4IZw07NMXC3CJFyuZ0FJ2wyOulO6SY6tc86M72
         V0mQ==
X-Gm-Message-State: AOAM533lDSX7YzaKDV2NUf4uy3kIerMCZJmUWDZawmKoLWUZs13SBusA
        MwHE8soWzVMjdabSKyxciZ1dj1M1BqObhA==
X-Google-Smtp-Source: ABdhPJzP6qvtxC2QEXaZoTxGlSdZyvDeG+ANT42CNSYMbTq4t5kUjxbk0znEhhH+vGz3nb98E79XDA==
X-Received: by 2002:a63:1542:: with SMTP id 2mr4395930pgv.248.1602098008035;
        Wed, 07 Oct 2020 12:13:28 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id c7sm4218276pfj.84.2020.10.07.12.13.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Oct 2020 12:13:27 -0700 (PDT)
Message-ID: <5f7e1357.1c69fb81.69eda.7f3c@mx.google.com>
Date:   Wed, 07 Oct 2020 12:13:27 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.19.149-43-gf766dc7d9684
X-Kernelci-Branch: queue/4.19
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.19 baseline: 127 runs,
 1 regressions (v4.19.149-43-gf766dc7d9684)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 127 runs, 1 regressions (v4.19.149-43-gf766d=
c7d9684)

Regressions Summary
-------------------

platform        | arch  | lab          | compiler | defconfig | results
----------------+-------+--------------+----------+-----------+--------
bcm2837-rpi-3-b | arm64 | lab-baylibre | gcc-8    | defconfig | 3/4    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.149-43-gf766dc7d9684/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.149-43-gf766dc7d9684
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      f766dc7d9684903a19fa6b438efd9be0b70820e8 =



Test Regressions
---------------- =



platform        | arch  | lab          | compiler | defconfig | results
----------------+-------+--------------+----------+-----------+--------
bcm2837-rpi-3-b | arm64 | lab-baylibre | gcc-8    | defconfig | 3/4    =


  Details:     https://kernelci.org/test/plan/id/5f7dd812cb808fafed4ff41e

  Results:     3 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.149=
-43-gf766dc7d9684/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3=
-b.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.149=
-43-gf766dc7d9684/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3=
-b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-3-g27eeeac7da2d/arm64/baseline/rootfs.cpio.gz =


  * baseline.dmesg.crit: https://kernelci.org/test/case/id/5f7dd812cb808faf=
ed4ff422
      new failure (last pass: v4.19.149-40-g96fc1039735d)
      1 lines

    2020-10-07 14:58:44.338000  Connected to bcm2837-rpi-3-b console [chann=
el connected] (~$quit to exit)
    2020-10-07 14:58:44.339000  (user:khilman) is already connected
    2020-10-07 14:59:01.037000  =00
    2020-10-07 14:59:01.038000  =

    2020-10-07 14:59:01.038000  U-Boot 2018.11 (Dec 04 2018 - 10:54:32 -080=
0)
    2020-10-07 14:59:01.038000  =

    2020-10-07 14:59:01.038000  DRAM:  948 MiB
    2020-10-07 14:59:01.054000  RPI 3 Model B (0xa02082)
    2020-10-07 14:59:01.140000  MMC:   mmc@7e202000: 0, sdhci@7e300000: 1
    2020-10-07 14:59:01.172000  Loading Environment from FAT... *** Warning=
 - bad CRC, using default environment
    ... (362 line(s) more)
      =20
