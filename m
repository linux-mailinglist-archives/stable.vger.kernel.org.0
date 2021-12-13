Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58C0947349C
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 20:03:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241970AbhLMTDN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 14:03:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240093AbhLMTDM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 14:03:12 -0500
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F268C061574
        for <stable@vger.kernel.org>; Mon, 13 Dec 2021 11:03:12 -0800 (PST)
Received: by mail-pg1-x531.google.com with SMTP id j11so15383306pgs.2
        for <stable@vger.kernel.org>; Mon, 13 Dec 2021 11:03:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=1urND9C9y+2d6pneFz8zbSY7ghzxpT3VtxfRQHgE1qE=;
        b=BIaIFl1y3rd2A5tBxK43g9QwfRIKg+32I9afdvcdnuNeWBLrMHVR9gel0XMG/Aq4Lq
         uJ2+5VaFVWZfzr3HB1v1yb47fBX+mijoueNyhVaC9t4hw/EVtqAkRVgzb/It/wbm8bl6
         G0YESJ07D/RQAzbzvotnUwlzJ6wIaMqfyjKZS7FlaAlrvBp16hg+NCqFCTMyET40LyZu
         LSktPWotcDxhEYyDWnumS8cFSkisV34fdVp6bD1v49ssLjKUklIm3FrPioUlxLX369Q3
         M6eJ+MIJihjQcnQLQQrFYAlmQs3AB+3OjmrIWrJdLRhawSqI/6xvFQapKgGreCrx5To0
         4W1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=1urND9C9y+2d6pneFz8zbSY7ghzxpT3VtxfRQHgE1qE=;
        b=8ByqEiq11yUZyh51mcR9p1vp2iPG/XM0Azvp0XQYVow/GQdUcjBZZ/A4Fk5KyJ5Tb7
         PFIMcN3XZeV3nUtkbFPCtSyx/A3vyHI+5XFYbDH93954mdvvvsfBjb9dDzCshZINESCV
         YVZBNsbyau77q9D7tDqw98NxNdGADSpyaIe8dLus7DH+jZqbwmU4S7bA+Bd06QCuFpVZ
         gOq993hqNSpkvothh6qSFrjaSN5/Ld9pHf7Ll4CIOTC5fWvTaqTHNaSM3eRQ1qIGb07M
         akV8r1k692wkLCesKc/dxZ1DVOK0Xa4DDKhGk0q7TiOyujFpgXjUK25BEOzTVqC5HVux
         Yenw==
X-Gm-Message-State: AOAM532LD5R7N8y9wpLsvl+CMxURcmPNrxjTlgLcoFd2FYSyFRee5HBw
        BqiA5F/cN9zaLeIa01KiYQCDdAF3QPyOAUbN
X-Google-Smtp-Source: ABdhPJy290j+MXfTt305LdFBHllkMem5f10NEt0VtPK+smeZWVncuoYuNHXrtWOsqEW9fBqsBaarZw==
X-Received: by 2002:a63:6687:: with SMTP id a129mr302817pgc.477.1639422191753;
        Mon, 13 Dec 2021 11:03:11 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id nm13sm7605979pjb.56.2021.12.13.11.03.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Dec 2021 11:03:11 -0800 (PST)
Message-ID: <61b798ef.1c69fb81.48f6d.486c@mx.google.com>
Date:   Mon, 13 Dec 2021 11:03:11 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.4.294-38-g597c1677683a
X-Kernelci-Report-Type: test
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.4.y baseline: 118 runs,
 2 regressions (v4.4.294-38-g597c1677683a)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y baseline: 118 runs, 2 regressions (v4.4.294-38-g597c1=
677683a)

Regressions Summary
-------------------

platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
n...6-chromebook | 1          =

panda                    | arm    | lab-collabora | gcc-10   | omap2plus_de=
fconfig          | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.4.y/kern=
el/v4.4.294-38-g597c1677683a/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.4.y
  Describe: v4.4.294-38-g597c1677683a
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      597c1677683ab7609f1804211e824a3cab9802e9 =



Test Regressions
---------------- =



platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
n...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/61b760e176b42cf8e6397151

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.294=
-38-g597c1677683a/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-minnowboard-turbot-E3826.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.294=
-38-g597c1677683a/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-minnowboard-turbot-E3826.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61b760e176b42cf8e6397=
152
        failing since 0 day (last pass: v4.4.292-160-g026850c9b4d0, first f=
ail: v4.4.294-28-g4af7e373e6fb) =

 =



platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
panda                    | arm    | lab-collabora | gcc-10   | omap2plus_de=
fconfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/61b75f2334f0908e08397142

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.294=
-38-g597c1677683a/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.294=
-38-g597c1677683a/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61b75f2334f0908=
e08397145
        new failure (last pass: v4.4.294-28-g4af7e373e6fb)
        2 lines

    2021-12-13T14:56:15.025374  [   19.150177] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-12-13T14:56:15.070547  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/110
    2021-12-13T14:56:15.080456  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
25c [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1
    2021-12-13T14:56:15.095210  [   19.219970] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =20
