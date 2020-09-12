Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92CA8267C97
	for <lists+stable@lfdr.de>; Sat, 12 Sep 2020 23:38:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725888AbgILVhl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 12 Sep 2020 17:37:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725884AbgILVhk (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 12 Sep 2020 17:37:40 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50BF0C061573
        for <stable@vger.kernel.org>; Sat, 12 Sep 2020 14:37:39 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id s65so7652730pgb.0
        for <stable@vger.kernel.org>; Sat, 12 Sep 2020 14:37:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=k7RCC8PQg4vqZjT5Twk2vjV6KV9k7euyiF3lGKsYQN0=;
        b=KPPFA1S3imZKgBtlPJHGaPsW9y/EKzBsrQLGCURbFTyouGwW2hq37txRRdGwIAk6Q/
         4toYL25FXADKiC/ARHzbdApJ9W4OJlML1c9pFzzc1ik6yYSv5bXZ/rcY5o82V0OR6QHr
         Ua6S7Fm9w54O+dxWfqufWicL4zeiE2K9/cNBVKtkyGwCPnVOzM8uAfVMximphDEvI4Oq
         rdaBXxnJaroN4KQNQcN0y5TWIidgfRFwxsZbpt9HEkpTFw7jdqXYhZkI2K31mq8f41Vj
         coqEul7iBJzmRyyoizl8RThJRlK2/biteMQSuPk0KuO3l4E6XhRN40Lb+haLizmcdp9C
         BrsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=k7RCC8PQg4vqZjT5Twk2vjV6KV9k7euyiF3lGKsYQN0=;
        b=uKGtR3CSovRPPvYOD6yvjU+C4GgVOoDJ8FTssAYxZIVk9RC/R4pfCvZic83nadndQQ
         w6ngJVEJf51gE6VJ/hX7G7neneIEb7L8VwC9DDJHzB2sftDWqP4n9bCupIXI/06GAHo9
         5uTe0E8J5rSUzgt8bFaMs1oNXJBdVj9wLTl/zsWm9Ka1D1WT8LuBVLEcL7jQAqAB1y1P
         fQHzl+egnMCXiGSfxHeJihd6ZIRoJmbKnlmyqDMrrmOJaPfPElXp4ILbETgMlk9AH986
         bA7JK/KWlfMGuoOx55isb6uu0OOkNYqIOHy0YYwoaddVvtZAw8J9EbzkNIiP9TRr4tbI
         lJ0Q==
X-Gm-Message-State: AOAM531tWDLakpdc+22ztAE47z8lWKsiYuSd3l59g1t1pooswrX1jqcN
        v1jaPigBlde9kjjr5UenrdMbgdFnGYd2WQ==
X-Google-Smtp-Source: ABdhPJzCiR9R3K/c0DuZxZVD1/X8rPk5059Ms0TCESIOprOTfECzVdGmRoeroiF7etyL+u5C/YGH9A==
X-Received: by 2002:a63:2982:: with SMTP id p124mr5779367pgp.390.1599946655814;
        Sat, 12 Sep 2020 14:37:35 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y4sm4770550pgl.67.2020.09.12.14.37.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 12 Sep 2020 14:37:35 -0700 (PDT)
Message-ID: <5f5d3f9f.1c69fb81.95585.c395@mx.google.com>
Date:   Sat, 12 Sep 2020 14:37:35 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.145
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.19.y
Subject: stable-rc/linux-4.19.y baseline: 161 runs, 2 regressions (v4.19.145)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y baseline: 161 runs, 2 regressions (v4.19.145)

Regressions Summary
-------------------

platform        | arch  | lab          | compiler | defconfig      | results
----------------+-------+--------------+----------+----------------+--------
bcm2837-rpi-3-b | arm64 | lab-baylibre | gcc-8    | defconfig      | 3/4    =

hsdk            | arc   | lab-baylibre | gcc-8    | hsdk_defconfig | 0/1    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.19.y/ker=
nel/v4.19.145/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.19.y
  Describe: v4.19.145
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      a87f96283793d58b042618c689630db264715274 =



Test Regressions
---------------- =



platform        | arch  | lab          | compiler | defconfig      | results
----------------+-------+--------------+----------+----------------+--------
bcm2837-rpi-3-b | arm64 | lab-baylibre | gcc-8    | defconfig      | 3/4    =


  Details:     https://kernelci.org/test/plan/id/5f5d0b469563225fa6a60930

  Results:     3 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
45/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
45/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/arm64/baseline/rootfs.cpio.gz =


  * baseline.dmesg.crit: https://kernelci.org/test/case/id/5f5d0b469563225f=
a6a60932
      new failure (last pass: v4.19.144-9-gdc4669f837af)
      1 lines

    2020-09-12 17:52:25.832000  Connected to bcm2837-rpi-3-b console [chann=
el connected] (~$quit to exit)
    2020-09-12 17:52:25.832000  (user:khilman) is already connected
    2020-09-12 17:52:41.483000  =00
    2020-09-12 17:52:41.483000  =

    2020-09-12 17:52:41.483000  U-Boot 2018.11 (Dec 04 2018 - 10:54:32 -080=
0)
    2020-09-12 17:52:41.483000  =

    2020-09-12 17:52:41.483000  DRAM:  948 MiB
    2020-09-12 17:52:41.499000  RPI 3 Model B (0xa02082)
    2020-09-12 17:52:41.586000  MMC:   mmc@7e202000: 0, sdhci@7e300000: 1
    2020-09-12 17:52:41.619000  Loading Environment from FAT... *** Warning=
 - bad CRC, using default environment
    ... (362 line(s) more)
      =



platform        | arch  | lab          | compiler | defconfig      | results
----------------+-------+--------------+----------+----------------+--------
hsdk            | arc   | lab-baylibre | gcc-8    | hsdk_defconfig | 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f5d0d702f83994a31a60941

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: hsdk_defconfig
  Compiler:    gcc-8 (arc-elf32-gcc (ARCompact/ARCv2 ISA elf32 toolchain 20=
19.03-rc1) 8.3.1 20190225)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
45/arc/hsdk_defconfig/gcc-8/lab-baylibre/baseline-hsdk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
45/arc/hsdk_defconfig/gcc-8/lab-baylibre/baseline-hsdk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/arc/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f5d0d702f83994a31a60=
942
      failing since 54 days (last pass: v4.19.125-93-g80718197a8a3, first f=
ail: v4.19.133-134-g9d319b54cc24)  =20
