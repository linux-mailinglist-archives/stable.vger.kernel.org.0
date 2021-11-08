Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B80C0447F74
	for <lists+stable@lfdr.de>; Mon,  8 Nov 2021 13:22:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237354AbhKHMZQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Nov 2021 07:25:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232912AbhKHMZQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Nov 2021 07:25:16 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12AAAC061714
        for <stable@vger.kernel.org>; Mon,  8 Nov 2021 04:22:32 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id p18so15608358plf.13
        for <stable@vger.kernel.org>; Mon, 08 Nov 2021 04:22:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=TjSVxJ32Tgnix5ZRick/QhuB3bbEowzVTfCdfAjt3f8=;
        b=2892kGSeH6O70Yv5csvJbReDbA+rMhA1ioRfTHEpBFFlZtwtKGn/78njmHSiCC3Ofs
         +6yivCfgHAxae5LZuea+qWCYGkJJcdUxtVGEHKb999daEDR69aOzjI5RB+NvvUUg/GMv
         43i5Ax0SmhPDRpI4Aw8HVex7n3IMSPbVMc/ASoyqWzp6xqyuB25ven7v3EWTdblYpP76
         m21b9iSn7+XSjtDXE1XKBsU7p+mSsX206xgvDJXpe78BaB07rORHYBKTmyiIxjkC2FJ+
         vbwttg4cBe4ASIx+2Yy6wtOlb6vCGS6++6ROSVTQp6nC1JYYdJZjj9td/znZ9bFvI6yx
         x/eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=TjSVxJ32Tgnix5ZRick/QhuB3bbEowzVTfCdfAjt3f8=;
        b=2ooYXvrF6h4KHCKAtIw/hKTLP+9hlMskPFVMEE8zu9wi9LQ/FXgNd1TCv85LmoSrLu
         X8jBuJqkeHpare2G2OCmqO/JLcwQJnisqCKY+NznqKPZXWNHELelsIot8NSwn+o5joJb
         PU7f0j/GVVDUj9yvPCxdOO4KRE8RYl7L0L5gXMcv/ulHysSL2LctzkLxc+hj56ka7t3w
         Z0faTYORUZ2lpiAda23esv98aZtHwgHHtcNtvwOe42TopEv6DWT0x7P0727ogiX0P10d
         Qj5BPlPunlaflAUAXmVwGVfVD2BbgWx0XxyeGnMKiKrJFhwjNH3zvpVqarMg4nZ8cnUo
         H3Pw==
X-Gm-Message-State: AOAM531uml9o8rctg3URlw0kn+U4qNwBBEnadAXQOqo3YMFhiSfa/doh
        5SGpgI6zuIkiq5ulKpoxS9UqAMy89fbW37bB
X-Google-Smtp-Source: ABdhPJy1E/uv8jGPOsy88PvS4r2y+U8Px0jZtGYWueTmZGYzq+Ug1ZouXjqHxPobrq6Xlt/17SEtlQ==
X-Received: by 2002:a17:902:8d85:b0:142:892d:bfa with SMTP id v5-20020a1709028d8500b00142892d0bfamr1751790plo.76.1636374151413;
        Mon, 08 Nov 2021 04:22:31 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id u9sm7322645pfi.23.2021.11.08.04.22.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Nov 2021 04:22:31 -0800 (PST)
Message-ID: <61891687.1c69fb81.cb94.1d2c@mx.google.com>
Date:   Mon, 08 Nov 2021 04:22:31 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.9
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.9.289-6-g1ae2a4b84341
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.9 baseline: 132 runs,
 2 regressions (v4.9.289-6-g1ae2a4b84341)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 132 runs, 2 regressions (v4.9.289-6-g1ae2a4b8=
4341)

Regressions Summary
-------------------

platform         | arch   | lab           | compiler | defconfig           =
| regressions
-----------------+--------+---------------+----------+---------------------=
+------------
panda            | arm    | lab-collabora | gcc-10   | omap2plus_defconfig =
| 1          =

qemu_x86_64-uefi | x86_64 | lab-cip       | gcc-10   | x86_64_defconfig    =
| 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.289-6-g1ae2a4b84341/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.289-6-g1ae2a4b84341
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      1ae2a4b84341134fa6fdac434890c68d466d6b45 =



Test Regressions
---------------- =



platform         | arch   | lab           | compiler | defconfig           =
| regressions
-----------------+--------+---------------+----------+---------------------=
+------------
panda            | arm    | lab-collabora | gcc-10   | omap2plus_defconfig =
| 1          =


  Details:     https://kernelci.org/test/plan/id/6188d976666c52d1223358f0

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.289-6=
-g1ae2a4b84341/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.289-6=
-g1ae2a4b84341/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/6188d976666c52d=
1223358f3
        failing since 0 day (last pass: v4.9.289-5-ga04f0d029c20, first fai=
l: v4.9.289-5-g036ef9ffe416)
        2 lines

    2021-11-08T08:01:43.912178  [   20.466705] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-11-08T08:01:43.961696  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/128
    2021-11-08T08:01:43.971275  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
230 [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =



platform         | arch   | lab           | compiler | defconfig           =
| regressions
-----------------+--------+---------------+----------+---------------------=
+------------
qemu_x86_64-uefi | x86_64 | lab-cip       | gcc-10   | x86_64_defconfig    =
| 1          =


  Details:     https://kernelci.org/test/plan/id/6188d9ec3be39070893358df

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.289-6=
-g1ae2a4b84341/x86_64/x86_64_defconfig/gcc-10/lab-cip/baseline-qemu_x86_64-=
uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.289-6=
-g1ae2a4b84341/x86_64/x86_64_defconfig/gcc-10/lab-cip/baseline-qemu_x86_64-=
uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6188d9ec3be3907089335=
8e0
        new failure (last pass: v4.9.289-5-g036ef9ffe416) =

 =20
