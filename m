Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE5FD424A71
	for <lists+stable@lfdr.de>; Thu,  7 Oct 2021 01:18:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231274AbhJFXUR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Oct 2021 19:20:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229809AbhJFXUQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Oct 2021 19:20:16 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1567C061746
        for <stable@vger.kernel.org>; Wed,  6 Oct 2021 16:18:23 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id l6so2648076plh.9
        for <stable@vger.kernel.org>; Wed, 06 Oct 2021 16:18:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=W3BBt5PrDCGEnRAAjyO9WrBXiyRmFuEemvOaq46CiY0=;
        b=qE9osyX7h+9ef7sb7XXGH+hp7/kRfj22AFDmII00x6Bxu6IQKe06U+siCnFLusxpr1
         8dpLTJ8qx1yPhtlWRwDGkn350z/0aUCupH8g/302E2EXuUVjT//RZrOku9Cqweyw4+hz
         fwxWU7RdK7OVQQflEnVtVmQ8ZU/4GrJYoeknmwj7EJJQEJgB0VHD9YnMH9fFteWM9pMX
         1hH/3BKbw4/Qx7toxswWn9e+zfgBVRjxd39s97bqO1WxEymlZYMG9VStXrPUMysz4C+W
         u4mgZM22mBxy/gWQOl0FgQD1ZE21sg8/VCaf3MAGU1ySDabftKQwVSML7TEYK0pGQ766
         sa1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=W3BBt5PrDCGEnRAAjyO9WrBXiyRmFuEemvOaq46CiY0=;
        b=ZEo9s65YdMlxMoiN3CWgRrmx0ca7oG2ayJG204LMmF72RqEncWb3I/HTGQN/TxkB6/
         CPSJMBr74CEqBRXSSjuS1/Am5A5mfqlDZyd9+30welLqFUjHQvem1LU4gZdsndXn/ens
         ZMH33FjiCZAnlChFwqhueplsrRCaJpgJ1iUrzSSfcDyzctSkPhR/hi+mGNEnbr7O/LCE
         m+7XcBajbbJi6mXxLcOcg+N5r8XNC5F4qaj7r02laXCVeKohC3YHkC1dfAV5/h4483PD
         jrcjxCrsfRzmbg0DR5xHtJ4ZVEBJKFJN77xv5iHg37DqBHyKngbzd/awIYAwtxUaCTFm
         xYMg==
X-Gm-Message-State: AOAM530ugVkzndEbty563Zr4wRF2wWNlNJlqy4lEpwlGeeWWmHpxnJqW
        rLZ7SH2fwt5+5HAHnHne4WAADuLC9fgwx9ga
X-Google-Smtp-Source: ABdhPJwCHf4pl8hN4JZCpZgJQK63nUigAS+TGBrdIvloYev3bukWqUr+19KiQqA8iqcFPQFDJpGQZg==
X-Received: by 2002:a17:90a:f287:: with SMTP id fs7mr1670842pjb.98.1633562303312;
        Wed, 06 Oct 2021 16:18:23 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id o12sm21043534pgn.33.2021.10.06.16.18.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Oct 2021 16:18:23 -0700 (PDT)
Message-ID: <615e2ebf.1c69fb81.7cf19.f9b7@mx.google.com>
Date:   Wed, 06 Oct 2021 16:18:23 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.248-75-gddb29baac18c
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.14
Subject: stable-rc/queue/4.14 baseline: 134 runs,
 3 regressions (v4.14.248-75-gddb29baac18c)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 134 runs, 3 regressions (v4.14.248-75-gddb29=
baac18c)

Regressions Summary
-------------------

platform        | arch  | lab           | compiler | defconfig           | =
regressions
----------------+-------+---------------+----------+---------------------+-=
-----------
fsl-ls2088a-rdb | arm64 | lab-nxp       | gcc-8    | defconfig           | =
1          =

panda           | arm   | lab-collabora | gcc-8    | omap2plus_defconfig | =
1          =

qemu_i386-uefi  | i386  | lab-broonie   | gcc-8    | i386_defconfig      | =
1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.248-75-gddb29baac18c/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.248-75-gddb29baac18c
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      ddb29baac18c33a59906b7d289d2592a3e291605 =



Test Regressions
---------------- =



platform        | arch  | lab           | compiler | defconfig           | =
regressions
----------------+-------+---------------+----------+---------------------+-=
-----------
fsl-ls2088a-rdb | arm64 | lab-nxp       | gcc-8    | defconfig           | =
1          =


  Details:     https://kernelci.org/test/plan/id/615dffa04676be4ce299a36f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.248=
-75-gddb29baac18c/arm64/defconfig/gcc-8/lab-nxp/baseline-fsl-ls2088a-rdb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.248=
-75-gddb29baac18c/arm64/defconfig/gcc-8/lab-nxp/baseline-fsl-ls2088a-rdb.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615dffa04676be4ce299a=
370
        new failure (last pass: v4.14.248-75-ga54482216787) =

 =



platform        | arch  | lab           | compiler | defconfig           | =
regressions
----------------+-------+---------------+----------+---------------------+-=
-----------
panda           | arm   | lab-collabora | gcc-8    | omap2plus_defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/615df5c1294af5c4d299a2ee

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.248=
-75-gddb29baac18c/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.248=
-75-gddb29baac18c/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/615df5c2294af5c=
4d299a2f4
        new failure (last pass: v4.14.248-75-ga54482216787)
        2 lines

    2021-10-06T19:14:43.921563  [   20.627136] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-10-06T19:14:43.962940  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/99
    2021-10-06T19:14:43.971727  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
d34 [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0
    2021-10-06T19:14:43.984855  [   20.692993] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =



platform        | arch  | lab           | compiler | defconfig           | =
regressions
----------------+-------+---------------+----------+---------------------+-=
-----------
qemu_i386-uefi  | i386  | lab-broonie   | gcc-8    | i386_defconfig      | =
1          =


  Details:     https://kernelci.org/test/plan/id/615df5d49ae806047299a2e5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.248=
-75-gddb29baac18c/i386/i386_defconfig/gcc-8/lab-broonie/baseline-qemu_i386-=
uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.248=
-75-gddb29baac18c/i386/i386_defconfig/gcc-8/lab-broonie/baseline-qemu_i386-=
uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615df5d49ae806047299a=
2e6
        new failure (last pass: v4.14.248-75-ga54482216787) =

 =20
