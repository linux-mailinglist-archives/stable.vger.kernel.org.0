Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92A30388E37
	for <lists+stable@lfdr.de>; Wed, 19 May 2021 14:38:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240999AbhESMjf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 May 2021 08:39:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239837AbhESMjf (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 May 2021 08:39:35 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70938C06175F
        for <stable@vger.kernel.org>; Wed, 19 May 2021 05:38:14 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id e15so322244plh.1
        for <stable@vger.kernel.org>; Wed, 19 May 2021 05:38:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=wPRSyYgCHeerVJH5MT5bGFUIfIscFdMtIgUMRXOta1I=;
        b=0mwHv0jE1g8IQkwEfbpOLE3onOL7yMOafKKuqCLb90/xlTpnZfv7H53QjkYbjAZigz
         0J1RvdDSCQ100UuMK5ktKkcUSOVYkrrMpKr3oW1kjHv+KFIVypen+1ANQDF5ML+qqPit
         YhwMIPLRbLtvUFvVMZB5I/aSKP57YzYsOYEzJ/NLGba76xbTOlXiySioRl69p6b1ytT6
         eVSQ7pKB8YwA4LA89e7O2rQOiuSsRHd+7Ya4xT2Xf3c7bq802aM5sK87H2MbPuBDBB7g
         o6NhrvLzr9yVRLyCvHL9CUCdzllex2k4UElk7S0gths43tIbySSmLlHU1hfEd8NXeSkh
         kWSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=wPRSyYgCHeerVJH5MT5bGFUIfIscFdMtIgUMRXOta1I=;
        b=M7NRJ9rnujFoDkmxp9GRa1jkR4c8yICQR1TQq/MSVf2rDZEwUnhHltLEwUuoprgt8k
         iyfXNQ3e0cRXusoQlFDKSjhOqaE+9iEGmMeO5LILhHo2EJ4850fQmhEH3XSP2OfnAqYl
         cFD/CLxJ0PmRgIyn+DOBULa2x3cF0FJGSmyZTvq23ALAcYpmBkwghXGvPLqZn2rfUT3j
         LQ4/v+bM0v1+E6iCSuOetb5PuemhEZdQFnJycUcmyJgF0n6Z1wAn/h52J02Jt3vLmUOC
         jzi2Dxloa29lL/55Dz9zmGsTS4FTMiFML2REVwcal7/waqTGdsoGOU5vAWu4pQ5SoaE4
         badg==
X-Gm-Message-State: AOAM532/LjHVBZITWIHGk2RDPM0G/kZAzkvqFk7hqDXXMPOQ7LwlDCEd
        LxrCHVEpDy1b2QyNCMXurQ9cFiW5h6z88w==
X-Google-Smtp-Source: ABdhPJyCdGRZrUTRoud2tOXqkVUaVOaTZjPEcJkeVAHNrm2ImRcloYCBSQSm+xbxcddQKHhza1skPg==
X-Received: by 2002:a17:90a:3041:: with SMTP id q1mr11036181pjl.191.1621427893634;
        Wed, 19 May 2021 05:38:13 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id l64sm15911780pgd.20.2021.05.19.05.38.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 May 2021 05:38:13 -0700 (PDT)
Message-ID: <60a506b5.1c69fb81.75cf.6031@mx.google.com>
Date:   Wed, 19 May 2021 05:38:13 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.12.4-363-g893c8b1b923f
X-Kernelci-Branch: queue/5.12
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.12 baseline: 117 runs,
 3 regressions (v5.12.4-363-g893c8b1b923f)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.12 baseline: 117 runs, 3 regressions (v5.12.4-363-g893c8b=
1b923f)

Regressions Summary
-------------------

platform           | arch | lab             | compiler | defconfig         =
  | regressions
-------------------+------+-----------------+----------+-------------------=
--+------------
bcm2837-rpi-3-b-32 | arm  | lab-baylibre    | gcc-8    | bcm2835_defconfig =
  | 2          =

imx6ul-pico-hobbit | arm  | lab-pengutronix | gcc-8    | imx_v6_v7_defconfi=
g | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.12/ker=
nel/v5.12.4-363-g893c8b1b923f/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.12
  Describe: v5.12.4-363-g893c8b1b923f
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      893c8b1b923f75fce0258b7b1709666a19d703a0 =



Test Regressions
---------------- =



platform           | arch | lab             | compiler | defconfig         =
  | regressions
-------------------+------+-----------------+----------+-------------------=
--+------------
bcm2837-rpi-3-b-32 | arm  | lab-baylibre    | gcc-8    | bcm2835_defconfig =
  | 2          =


  Details:     https://kernelci.org/test/plan/id/60a4d1f9f1c7f4b064b3afc9

  Results:     3 PASS, 2 FAIL, 0 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.4-3=
63-g893c8b1b923f/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837-=
rpi-3-b-32.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.4-3=
63-g893c8b1b923f/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837-=
rpi-3-b-32.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.alert: https://kernelci.org/test/case/id/60a4d1f9f1c7f4b=
064b3afcf
        new failure (last pass: v5.12.4-363-g2fd5d85fdab9)
        188 lines

    2021-05-19 08:52:43.977000+00:00  kern  :alert : addr:b6d91000 vm_flags=
:00000075 anon_vma:00000000 mapping:c1be60f0 index:22
    2021-05-19 08:52:43.978000+00:00  kern  :alert : file:libc-2.30.so faul=
t:filemap_fault mmap:generic_file_mmap readpage:simple_readpage
    2021-05-19 08:52:43.979000+00:00  kern  :alert : BUG: Bad page map in p=
rocess udevadm  pte:0275f18f pmd:04290835
    2021-05-19 08:52:43.980000+00:00  kern  :alert : addr:b6d71000 vm_flags=
:00000075 anon_vma:00000000 mapping:c1be60f0 index:22
    2021-05-19 08:52:44.019000+00:00  kern  :alert : file:libc-2.30.so faul=
t:filemap_fault mmap:generic_file_mmap readpage:simple_readpage
    2021-05-19 08:52:44.020000+00:00  kern  :alert : 8<--- cut here ---
    2021-05-19 08:52:44.022000+00:00  kern  :alert : Unable to handle kerne=
l paging request at virtual address c0e0fdc0
    2021-05-19 08:52:44.023000+00:00  kern  :alert : pgd =3D 121d6ed5
    2021-05-19 08:52:44.023000+00:00  kern  :alert : [c0e0fdc0] *pgd=3D00e0=
041e(bad)
    2021-05-19 08:52:44.024000+00:00  kern  :alert : 8<--- cut here --- =

    ... (165 line(s) more)  =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/60a4d1f9f1c7f4b=
064b3afd0
        new failure (last pass: v5.12.4-363-g2fd5d85fdab9)
        65 lines

    2021-05-19 08:52:45.374000+00:00  kern  :alert : BUG: Bad page map in p=
rocess S50pnp_networki  pte:0275f18f pmd:041b9835
    2021-05-19 08:52:45.376000+00:00  kern  :alert : addr:b6e76000 vm_flags=
:00000075 anon_vma:00000000 mapping:c1be60f0 index:22
    2021-05-19 08:52:45.377000+00:00  kern  :alert : file:libc-2.30.so faul=
t:filemap_fault mmap:generic_file_mmap readpage:simple_readpage
    2021-05-19 08:52:45.378000+00:00  kern  :alert : BUG: Bad page map in p=
rocess rcS  pte:0275f18f pmd:0415c835
    2021-05-19 08:52:45.379000+00:00  kern  :alert : addr:b6dbb000 vm_flags=
:00000075 anon_vma:00000000 mapping:c1be60f0 index:22
    2021-05-19 08:52:45.418000+00:00  kern  :alert : file:libc-2.30.so faul=
t:filemap_fault mmap:generic_file_mmap readpage:simple_readpage
    2021-05-19 08:52:45.419000+00:00  kern  :alert : BUG: Bad page map in p=
rocess lava-test-runne  pte:0275f18f pmd:04357835
    2021-05-19 08:52:45.421000+00:00  kern  :alert : addr:b6e33000 vm_flags=
:00000075 anon_vma:00000000 mapping:c1be60f0 index:22
    2021-05-19 08:52:45.422000+00:00  kern  :alert : file:libc-2.30.so faul=
t:filemap_fault mmap:generic_file_mmap readpage:simple_readpage
    2021-05-19 08:52:45.422000+00:00  kern  :alert : BUG: Bad page map in p=
rocess mkdir  pte:0275f18f pmd:04273835 =

    ... (48 line(s) more)  =

 =



platform           | arch | lab             | compiler | defconfig         =
  | regressions
-------------------+------+-----------------+----------+-------------------=
--+------------
imx6ul-pico-hobbit | arm  | lab-pengutronix | gcc-8    | imx_v6_v7_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60a4d295ae8fdc9597b3afc1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.4-3=
63-g893c8b1b923f/arm/imx_v6_v7_defconfig/gcc-8/lab-pengutronix/baseline-imx=
6ul-pico-hobbit.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.4-3=
63-g893c8b1b923f/arm/imx_v6_v7_defconfig/gcc-8/lab-pengutronix/baseline-imx=
6ul-pico-hobbit.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60a4d295ae8fdc9597b3a=
fc2
        new failure (last pass: v5.12.4-363-g2fd5d85fdab9) =

 =20
