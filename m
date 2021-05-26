Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACD7D3922A5
	for <lists+stable@lfdr.de>; Thu, 27 May 2021 00:21:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233788AbhEZWW5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 May 2021 18:22:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234300AbhEZWWt (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 May 2021 18:22:49 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4404C061574
        for <stable@vger.kernel.org>; Wed, 26 May 2021 15:21:15 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id u7so1333320plq.4
        for <stable@vger.kernel.org>; Wed, 26 May 2021 15:21:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ogmAb8+IFkoILTaHdudYTbfbVz5HB2W+RQrkFGYZ3qo=;
        b=A/cwsoqrYPDjHvPzzYxghxdQBgPyMX2ptAhY/LNpZRkI8qzYCW6usmHAmRBu8WSiSH
         7ocQ7mTSg0wayFg8AlMwT1ZqLlVEfPUxlxxV0Z69O+9q1BTMjkNes/bE/3W4FOPjHZ2I
         QBW4pwgKZMCWK2kRqPGLD0Tp6jol0Pqiy8IjL6bAdf1mdaRn9UBkkC8pReJ7mkbLSKqu
         VK6CMryIPY9qs8TTK2IvogGothAC/8ncfx41PnwE1IMdk0ML4nF6DBXmQXUhjpje59ID
         qmpoKJJKH9WRtQ+OC+OK4U/lAqaqqznTX650yHI2q1UlQEQe9W6vxe8nNYg94JZN1j3E
         b6pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ogmAb8+IFkoILTaHdudYTbfbVz5HB2W+RQrkFGYZ3qo=;
        b=Awy+DvfblNCqLiJKyn9IVy1cWJObVSw49jPpHBIxXL9ns97LzDRzv9nL72Y6RcMdzF
         xz+WKtDdbCY1On4EP9ULDStgSplRD2zZGZwm5t7vS9xuP1smfo/lwQAOaTrBbgMfi6VV
         /h3NfL4wLFZzD2C/YJXp9lq6lZWnRpq7F4CPjIuq1rdrdPzqCy28IEO+ndIgwQ7wK6ND
         q6EeaeyH5Zc8RZMdfYGEBmVMgc3tlLB2fRIGdyPKELZL7vrP4Vsc+3abrYLqZm7aDA8s
         vLzoauVWHymW2mSmHpVvuIwEehgyUcHr8ipYR7i3aCaHY+pyxfZz780EXNyuTeMrZ1tA
         k/oQ==
X-Gm-Message-State: AOAM532+x3dACOdQFnTnSvTJ2Zxf3KFhxex3mPb6meuV7hl9ZzCLJ64b
        8iWcDvDrRq14eGTHsBZv0eMIKmQuf9qPPF0a
X-Google-Smtp-Source: ABdhPJwrWLBzi2YNMvBvMi1jev0ArqELKmOt41+cE63BZmEADFORoYPanMWwkhcuqhwPwg8RBYWSnQ==
X-Received: by 2002:a17:902:c406:b029:ef:7ba2:f308 with SMTP id k6-20020a170902c406b02900ef7ba2f308mr335350plk.9.1622067675125;
        Wed, 26 May 2021 15:21:15 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id q24sm83663pgb.19.2021.05.26.15.21.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 May 2021 15:21:14 -0700 (PDT)
Message-ID: <60aec9da.1c69fb81.c7dc8.07ca@mx.google.com>
Date:   Wed, 26 May 2021 15:21:14 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.12.7
X-Kernelci-Branch: linux-5.12.y
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-5.12.y baseline: 116 runs, 3 regressions (v5.12.7)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.12.y baseline: 116 runs, 3 regressions (v5.12.7)

Regressions Summary
-------------------

platform                 | arch  | lab          | compiler | defconfig     =
    | regressions
-------------------------+-------+--------------+----------+---------------=
----+------------
bcm2837-rpi-3-b-32       | arm   | lab-baylibre | gcc-8    | bcm2835_defcon=
fig | 2          =

r8a774a1-hihope-rzg2m-ex | arm64 | lab-cip      | gcc-8    | defconfig     =
    | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.12.y/ker=
nel/v5.12.7/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.12.y
  Describe: v5.12.7
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      55c17a63e51a668438d3d9fa5ff8ef959fe90a4c =



Test Regressions
---------------- =



platform                 | arch  | lab          | compiler | defconfig     =
    | regressions
-------------------------+-------+--------------+----------+---------------=
----+------------
bcm2837-rpi-3-b-32       | arm   | lab-baylibre | gcc-8    | bcm2835_defcon=
fig | 2          =


  Details:     https://kernelci.org/test/plan/id/60ae92a3856c598462b3afb9

  Results:     3 PASS, 2 FAIL, 0 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.12.y/v5.12.7=
/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b-32.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.12.y/v5.12.7=
/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b-32.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.alert: https://kernelci.org/test/case/id/60ae92a3856c598=
462b3afbf
        new failure (last pass: v5.12.6-128-g63b7a7baa77d)
        9 lines

    2021-05-26 18:25:26.051000+00:00  kern  :alert : Unable to handle kerne=
l paging request at virtual address 15554554
    2021-05-26 18:25:26.052000+00:00  ke<8>[   42.760626] <LAVA_SIGNAL_TEST=
CASE TEST_CASE_ID=3Dalert RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D9>
    2021-05-26 18:25:26.053000+00:00  rn  :alert : pgd =3D 5501338c
    2021-05-26 18:25:26.053000+00:00  kern  :alert : [15554554] *pgd=3D0000=
0000
    2021-05-26 18:25:26.054000+00:00  kern  :alert : 8<--- cut here ---   =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/60ae92a3856c598=
462b3afc0
        new failure (last pass: v5.12.6-128-g63b7a7baa77d)
        167 lines

    2021-05-26 18:25:26.058000+00:00  kern  :alert : pgd =3D e4d9efaa
    2021-05-26 18:25:26.059000+00:00  kern  :alert : [15554554] *pgd=3D0000=
0000
    2021-05-26 18:25:26.096000+00:00  kern  :alert : Fixing recursive fault=
 but reboot is needed!
    2021-05-26 18:25:26.097000+00:00  kern  :emerg : Internal error: Oops: =
5 [#1] ARM
    2021-05-26 18:25:26.098000+00:00  kern  :emerg : Process udevd (pid: 10=
7, stack limit =3D 0x636e8a13)
    2021-05-26 18:25:26.098000+00:00  kern  :emerg : Stack: (0xc4277d40 to =
0xc4278000)
    2021-05-26 18:25:26.099000+00:00  kern  :emerg : 7d40: c4277d94 c4277d5=
0 c01f7100 c01f4e18 c4277ef8 c1820a04 00000009 00090000
    2021-05-26 18:25:26.100000+00:00  kern  :emerg : 7d60: c2d7f4c0 0000000=
0 00000000 126a4886 00080001 c4277ef8 00000009 eaa9fce0
    2021-05-26 18:25:26.101000+00:00  kern  :emerg : 7d80: c1820a00 0000000=
8 c4277e5c c4277d98 c01f8cb8 c01f700c 00000000 c05af5b8
    2021-05-26 18:25:26.139000+00:00  kern  :emerg : 7da0: c1820910 c1820a0=
0 00000021 00000000 00000000 00000000 00000200 00000000 =

    ... (134 line(s) more)  =

 =



platform                 | arch  | lab          | compiler | defconfig     =
    | regressions
-------------------------+-------+--------------+----------+---------------=
----+------------
r8a774a1-hihope-rzg2m-ex | arm64 | lab-cip      | gcc-8    | defconfig     =
    | 1          =


  Details:     https://kernelci.org/test/plan/id/60ae9660ea27ff4e9bb3afa5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.12.y/v5.12.7=
/arm64/defconfig/gcc-8/lab-cip/baseline-r8a774a1-hihope-rzg2m-ex.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.12.y/v5.12.7=
/arm64/defconfig/gcc-8/lab-cip/baseline-r8a774a1-hihope-rzg2m-ex.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ae9660ea27ff4e9bb3a=
fa6
        new failure (last pass: v5.12.6-128-g63b7a7baa77d) =

 =20
