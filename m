Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 378DC488636
	for <lists+stable@lfdr.de>; Sat,  8 Jan 2022 22:01:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229778AbiAHVBy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 8 Jan 2022 16:01:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229593AbiAHVBy (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 8 Jan 2022 16:01:54 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12DE3C06173F
        for <stable@vger.kernel.org>; Sat,  8 Jan 2022 13:01:54 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id m13so9486195pji.3
        for <stable@vger.kernel.org>; Sat, 08 Jan 2022 13:01:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=VpHgfDYpF4bHwUJK7+0zyUQdGm5jVrmzeMpcxelxanQ=;
        b=uNty5KIpt/Tk6csfmIfQ16t799QHVsqLSdnaEpBLCVKDKfMmRIKGPUICFw/qNXX8S3
         kcv5+uB4dNNwHZpo7+c1eS1dJGg09sn6/fQORXohimT2CXEcqTh49aXemEGxhgS3u+/X
         gkiM4DbaBn26BsKpFruqt13/RGiRKnEhgG3JD6f3cB8bBIaco5PcZnVMM3bdSrFgItJm
         R7c4o/U6Q/IELxyDMc/5bC90hLxnCC9fwonffSliGnkwK9wUDwUOYW5Ad4Nnd+FJxe5i
         sSIdhcdRFoMtAnNiyEYwJBSvv2fEhtfdkmM4B19PqikRJMXzT9rH6LLQJo86EnSH1dxH
         6s1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=VpHgfDYpF4bHwUJK7+0zyUQdGm5jVrmzeMpcxelxanQ=;
        b=hCckume+ZALz3VcEXdbQPS/ChSZHxlegJl6Mx3VcTBG/WFynnVLefFZ3yaUghZDgmI
         jikzk4P3bpl+UUypJz7zYmkUlKLYU/81Cpl33YTKfYJ2DMrYfHRFUOHGoCfXi5V3eywX
         S21X0Q7O/BVnHP+mxTTkyPIACZWe7ovZA913iXWn5CkHJqokzOh5r+ouFF+3Cdw2tTw5
         5fXmige2kNI1s1fljpItzxUZKmzXXdlvMHvnoujEe9aZ08xmX0wB+PQzpEsqXit6uK7e
         jKHknEVSNm+C5JOnyAwOS30OiCswVb/APPz9BTOOT5fFl/wNOWTFFOMFOPxqW7nVdxOg
         +ldw==
X-Gm-Message-State: AOAM533qANsjSqS2BOeaeJi/jclFx1nasaLbd5/sEzaVZbA/dauBTZ23
        2zI0LKUeMf3ci+63zCrxsc5YIAjBSlnKjyEq
X-Google-Smtp-Source: ABdhPJw2WudF39BnQT4FZ1OYe8Henay0PXj6cg3U5JdkvXvl+fVuvFEVlk1KHjpjxY5etgbpVLOfmw==
X-Received: by 2002:a17:90b:3c0c:: with SMTP id pb12mr17225212pjb.45.1641675713495;
        Sat, 08 Jan 2022 13:01:53 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id c19sm2816491pfl.118.2022.01.08.13.01.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 08 Jan 2022 13:01:53 -0800 (PST)
Message-ID: <61d9fbc1.1c69fb81.286b8.6b56@mx.google.com>
Date:   Sat, 08 Jan 2022 13:01:53 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.14.261-12-g1c0b37e38dfb
X-Kernelci-Branch: queue/4.14
Subject: stable-rc/queue/4.14 baseline: 140 runs,
 1 regressions (v4.14.261-12-g1c0b37e38dfb)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 140 runs, 1 regressions (v4.14.261-12-g1c0b3=
7e38dfb)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.261-12-g1c0b37e38dfb/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.261-12-g1c0b37e38dfb
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      1c0b37e38dfbfd9110b5f6eafacc969da0a1ef9d =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61d9c81cf2213c9d72ef6751

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.261=
-12-g1c0b37e38dfb/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.261=
-12-g1c0b37e38dfb/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61d9c81cf2213c9=
d72ef6754
        failing since 5 days (last pass: v4.14.260-5-g5ba2b1f2b4df, first f=
ail: v4.14.260-9-gb7bb5018400c)
        2 lines

    2022-01-08T17:21:14.415066  [   20.194976] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2022-01-08T17:21:14.460290  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/98
    2022-01-08T17:21:14.469364  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
d3c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
