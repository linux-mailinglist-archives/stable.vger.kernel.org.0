Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D20773E8593
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 23:42:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233555AbhHJVmh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 17:42:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234747AbhHJVmf (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Aug 2021 17:42:35 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C29FC06179B
        for <stable@vger.kernel.org>; Tue, 10 Aug 2021 14:41:59 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id oa17so158800pjb.1
        for <stable@vger.kernel.org>; Tue, 10 Aug 2021 14:41:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=xYEjH64Wp+CRC3CM+BXI789+o6U+/1W/ln3YTyZGwHk=;
        b=1TVl+HlM6Bx4H0xioOJDfYMTv2FrvLxanGOeyph9Kg33PCHC7ygVXltCROYZBo5p1G
         c4L+pR7nS0Y/g9POmdqHUXjlJUlpGbG+vPhw95mpXDA53bMM6OFfFgRwiD5heQOZshdC
         u8Q0htSWmB/NsXUyPh5+z5zzqm3d09GMl1lXoF5u9UxSdfPmFLDC3JSpbldvzpCLlMTp
         qD6/WICrkSY8WRRjPVgP/vN69UeAxc66s17qsA65yALAFnQksu9unYNBS2Uw5YpvM3dc
         X+k1kV7kYaHaT4K50bwYjErMELIiIxhU0CSvuf8SWpQ9jiYdrDgLDu0pBFhXLv1+lTmi
         itZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=xYEjH64Wp+CRC3CM+BXI789+o6U+/1W/ln3YTyZGwHk=;
        b=Xi2OIokXvvq901M0jXiP4fcxv9DqFjXK7agWdO1OgNjgDjtRM84h79iFmvxZvXpWSC
         kj+nqgyLAgVezoAy2xcZKtDysYmTMQoYN6FB3uApuYGiLBf7jlDs44jZr5bLmfAamLhk
         n6xQwAQr6b6/L2wImaBrbuvcfHaf//UQo7jGHilf6sDCd0KdUR2RB0KSrE2ImyuNQlAb
         cciAdQ7SE4gBv+pmsyFRzg8Czo3qRPhj230HAoXcoNjNVv/eQm44rugQ61XufK2QxOAU
         fcDFLLuDk3o+oQJ5N/QxDaJZrkZCBl2TejC81vRXW5Kv0cRvh+f4nme7yF5kKGckzWLk
         eQ0g==
X-Gm-Message-State: AOAM5324McWNz7tQMcHCuBnUGN3rH+HF5W5E/ZFevTmLEevnHwO4STHE
        wFGWyZibOkqGkGY5IDr/HLY6CnFIRucl73wY
X-Google-Smtp-Source: ABdhPJwQvN1JchyVTSx6a1VUNEcjLJdRdVkb1wmc14out9xHoh2ETnhM2ToW/fJUcuY9UBcHW+RZjg==
X-Received: by 2002:a17:90a:ba8e:: with SMTP id t14mr33808737pjr.176.1628631718527;
        Tue, 10 Aug 2021 14:41:58 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id x14sm24740043pfa.127.2021.08.10.14.41.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Aug 2021 14:41:58 -0700 (PDT)
Message-ID: <6112f2a6.1c69fb81.c1d6.88b9@mx.google.com>
Date:   Tue, 10 Aug 2021 14:41:58 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.14
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.14.243-38-g7e1cb7d15ad6
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.14 baseline: 105 runs,
 3 regressions (v4.14.243-38-g7e1cb7d15ad6)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 105 runs, 3 regressions (v4.14.243-38-g7e1cb=
7d15ad6)

Regressions Summary
-------------------

platform         | arch   | lab         | compiler | defconfig             =
       | regressions
-----------------+--------+-------------+----------+-----------------------=
-------+------------
fsl-ls2088a-rdb  | arm64  | lab-nxp     | gcc-8    | defconfig             =
       | 1          =

qemu_i386-uefi   | i386   | lab-broonie | gcc-8    | i386_defconfig        =
       | 1          =

qemu_x86_64-uefi | x86_64 | lab-broonie | gcc-8    | x86_64_defcon...6-chro=
mebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.243-38-g7e1cb7d15ad6/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.243-38-g7e1cb7d15ad6
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      7e1cb7d15ad6f4d1c6c64cd1adb4afb3dc99fde9 =



Test Regressions
---------------- =



platform         | arch   | lab         | compiler | defconfig             =
       | regressions
-----------------+--------+-------------+----------+-----------------------=
-------+------------
fsl-ls2088a-rdb  | arm64  | lab-nxp     | gcc-8    | defconfig             =
       | 1          =


  Details:     https://kernelci.org/test/plan/id/6112bd09cd5b9392a8b13687

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.243=
-38-g7e1cb7d15ad6/arm64/defconfig/gcc-8/lab-nxp/baseline-fsl-ls2088a-rdb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.243=
-38-g7e1cb7d15ad6/arm64/defconfig/gcc-8/lab-nxp/baseline-fsl-ls2088a-rdb.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6112bd0acd5b9392a8b13=
688
        new failure (last pass: v4.14.243-38-g066d35df140c) =

 =



platform         | arch   | lab         | compiler | defconfig             =
       | regressions
-----------------+--------+-------------+----------+-----------------------=
-------+------------
qemu_i386-uefi   | i386   | lab-broonie | gcc-8    | i386_defconfig        =
       | 1          =


  Details:     https://kernelci.org/test/plan/id/6112c2016f9056d11fb1366d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.243=
-38-g7e1cb7d15ad6/i386/i386_defconfig/gcc-8/lab-broonie/baseline-qemu_i386-=
uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.243=
-38-g7e1cb7d15ad6/i386/i386_defconfig/gcc-8/lab-broonie/baseline-qemu_i386-=
uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6112c2016f9056d11fb13=
66e
        new failure (last pass: v4.14.243-38-g066d35df140c) =

 =



platform         | arch   | lab         | compiler | defconfig             =
       | regressions
-----------------+--------+-------------+----------+-----------------------=
-------+------------
qemu_x86_64-uefi | x86_64 | lab-broonie | gcc-8    | x86_64_defcon...6-chro=
mebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6112c2514aca019dcab13662

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.243=
-38-g7e1cb7d15ad6/x86_64/x86_64_defconfig+x86-chromebook/gcc-8/lab-broonie/=
baseline-qemu_x86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.243=
-38-g7e1cb7d15ad6/x86_64/x86_64_defconfig+x86-chromebook/gcc-8/lab-broonie/=
baseline-qemu_x86_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6112c2514aca019dcab13=
663
        new failure (last pass: v4.14.243-38-g066d35df140c) =

 =20
