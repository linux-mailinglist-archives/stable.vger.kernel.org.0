Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 500D3460829
	for <lists+stable@lfdr.de>; Sun, 28 Nov 2021 18:49:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344213AbhK1RxG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 28 Nov 2021 12:53:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344463AbhK1RvF (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 28 Nov 2021 12:51:05 -0500
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 728A5C061763
        for <stable@vger.kernel.org>; Sun, 28 Nov 2021 09:47:30 -0800 (PST)
Received: by mail-pf1-x42b.google.com with SMTP id r130so14298517pfc.1
        for <stable@vger.kernel.org>; Sun, 28 Nov 2021 09:47:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=SOOpOGPKs9/IiNRbMcPMsh2QNT9TkayeEx9I6Q9Dk6s=;
        b=H1U0ctf9HkxOCwEISpeZVwXprF3XLEEOFtzdwz7OYG0HsR+EKdl9GZQEMs7bzYil75
         lSmSRbN0xcX/atSV/CiRGTxHTZnUH+B2fcHGjtGLs+1xOc+IeqN6thwQtnHu1RWI7ANp
         hK8f4WqPgqVfzKRw1nBIiS+aEl5f4NmmggpehWSNdnju118WuxfJNsidEbafXsvPpYdh
         dGhnjfVP2vlh7vv08a4RfyuVBj/Vj7tHX6W8UloMDlVMmKZ4lQURjR8xyyOh2Z77MOfT
         4CJOp0K/GXGFk9kO/UjWh1kzCwrBAHRqNc/kMCt4yHYs7Alox8+/sv9oexO7KqozyBUe
         pxRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=SOOpOGPKs9/IiNRbMcPMsh2QNT9TkayeEx9I6Q9Dk6s=;
        b=TGA/aAi+1iQdgLLJsqBhtKI47EDtht80fOP4hMe1TOnY6r1yiDeZOTD1LHEdGOYvsr
         qG2TAE3ddkeXSf8HOAIzBwb44IjQqdW/MHexbgQ/lrNcoJKm627Wo2zzE7cXLQDJG6FW
         VmtKiM+qHlm28buMTPEIkWycJ3U/bQfVwdBpUkL/Q+6AW8GgeJhJETK0MvTA6kP3Rmjk
         6LrHoIWZohyjSmTZ77ioio7cb/eUr4UTNkAeYwDpuqxYNhcWOq5JYfbvpZbyGL1BPacw
         wCTqZyIFEcTEFkzxB15w2iovYOnGIqrsIOXIkHkJSQscM9M8hnZqrOK7TgvlMK7omBz7
         gpMQ==
X-Gm-Message-State: AOAM530LcU8hCNttE2f+FwUE9NWSuwDYly/IQat2P7mQuQ7X7miRN2LF
        YZ/pHV0UhHQj2IBKfbwjFex7QLhbv3IzVs3Z
X-Google-Smtp-Source: ABdhPJzvdmdSD3N6xeuvAvncAXGIJwGEsfavcEPjLTSaiMG88rXbimOXN/0FmCuHSUJI4opaW8ppYA==
X-Received: by 2002:a05:6a00:2401:b0:4a8:909:1d01 with SMTP id z1-20020a056a00240100b004a809091d01mr15711646pfh.83.1638121649831;
        Sun, 28 Nov 2021 09:47:29 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id h3sm15747969pjz.43.2021.11.28.09.47.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Nov 2021 09:47:29 -0800 (PST)
Message-ID: <61a3c0b1.1c69fb81.2d8dd.86be@mx.google.com>
Date:   Sun, 28 Nov 2021 09:47:29 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.19
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.19.218-14-gd6073091dc6a1
Subject: stable-rc/queue/4.19 baseline: 144 runs,
 2 regressions (v4.19.218-14-gd6073091dc6a1)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 144 runs, 2 regressions (v4.19.218-14-gd6073=
091dc6a1)

Regressions Summary
-------------------

platform    | arch   | lab           | compiler | defconfig                =
    | regressions
------------+--------+---------------+----------+--------------------------=
----+------------
panda       | arm    | lab-collabora | gcc-10   | omap2plus_defconfig      =
    | 1          =

qemu_x86_64 | x86_64 | lab-cip       | gcc-10   | x86_64_defcon...6-chromeb=
ook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.218-14-gd6073091dc6a1/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.218-14-gd6073091dc6a1
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      d6073091dc6a173353f268b7557c02d1faa1f9b3 =



Test Regressions
---------------- =



platform    | arch   | lab           | compiler | defconfig                =
    | regressions
------------+--------+---------------+----------+--------------------------=
----+------------
panda       | arm    | lab-collabora | gcc-10   | omap2plus_defconfig      =
    | 1          =


  Details:     https://kernelci.org/test/plan/id/61a38c13054a410c7418f6fc

  Results:     5 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.218=
-14-gd6073091dc6a1/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pa=
nda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.218=
-14-gd6073091dc6a1/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pa=
nda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61a38c13054a410=
c7418f702
        failing since 3 days (last pass: v4.19.217-320-gdc7db2be81d5, first=
 fail: v4.19.217-320-ge8717633e0ba)
        2 lines

    2021-11-28T14:02:45.775687  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/101
    2021-11-28T14:02:45.785627  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
cfc [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1
    2021-11-28T14:02:45.798976  <8>[   21.487823] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =



platform    | arch   | lab           | compiler | defconfig                =
    | regressions
------------+--------+---------------+----------+--------------------------=
----+------------
qemu_x86_64 | x86_64 | lab-cip       | gcc-10   | x86_64_defcon...6-chromeb=
ook | 1          =


  Details:     https://kernelci.org/test/plan/id/61a38ad87c2227b61518f6dd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.218=
-14-gd6073091dc6a1/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-cip/ba=
seline-qemu_x86_64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.218=
-14-gd6073091dc6a1/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-cip/ba=
seline-qemu_x86_64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61a38ad87c2227b61518f=
6de
        new failure (last pass: v4.19.217-320-g21a671bf3b0e) =

 =20
