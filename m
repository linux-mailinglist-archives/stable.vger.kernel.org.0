Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E85F45E185
	for <lists+stable@lfdr.de>; Thu, 25 Nov 2021 21:24:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356716AbhKYU14 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Nov 2021 15:27:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356920AbhKYUZ4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Nov 2021 15:25:56 -0500
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB57BC06175B
        for <stable@vger.kernel.org>; Thu, 25 Nov 2021 12:18:56 -0800 (PST)
Received: by mail-pl1-x635.google.com with SMTP id k4so5254717plx.8
        for <stable@vger.kernel.org>; Thu, 25 Nov 2021 12:18:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=/nMOw7oFmixBnGPAIpPcs2KJlVgyV/gAtArm+Nb9ZQc=;
        b=GyfEa11qIsQxVqHjbxgP52BK2ukmYZGpEeAoh/jENqiyrlGfCnnn1CcJHw+ItxorTJ
         rfrZcZULcmQm5RiSAEcUBk8rK7h925wAhncxDaPG7yqOgPB3qmcXmx8ZFF2vE0Rvk+LH
         zZnCQePZAYH+u7N75Q0eqfcxpk0mINJZnm38/ykNl0k5TjNsnV6owl40PlRtiPZ9LB4d
         8pwbT7QgE50XNQ5OfwazkSo6oQXICs6RQSSkOKA5pWSnmdmHFkzhY4+gzVPTp+FtitzY
         eTyqi9WMRxcY8XZVZF6/gKX/kE3RzUULhrzVZmz6re2Ol8UFWyNLeUuGghKozA/8V3Eb
         kwkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=/nMOw7oFmixBnGPAIpPcs2KJlVgyV/gAtArm+Nb9ZQc=;
        b=tYe3U+q1Ix942PPIpfACrP2uTkHPoL7LKPjCps7EFKoF9SEHV0nwTI82B2Hn7onqzk
         lXNQKIt5e360xYrLl8in338DUMOUNWSm5DmAfVuGucBDUr4XayDUSE+gSeE4ow25AGmr
         wEFcPLNm9Hw2YUZNH2VmPQhae5RPUThwJH2vY+JEWqaeY7lG8Ysky7QVcmyAMU1cAo9T
         oq8n7ADqXxM+VH0Yt4y71az7CqmMwJxrT7nThcXLetlgGbBjaM56JCOMvpbtLxTmfNuB
         dJFMUF7WN3FSKDKUdIOzho1oAIwy5pX0mBIRuhIqR5i6eLu5nJKWXGmuUY13wc1cWwTt
         A2gQ==
X-Gm-Message-State: AOAM532CBN+dKKTzXC9O1pLgnuyunGjtTYzVKKW0F3r2Nxh7Vzh/vgSK
        h5EC22KnIJ5QFGUmbtfZXOUrrcBthz8NLZw8IZ8=
X-Google-Smtp-Source: ABdhPJz3Y3Azo01OyF6bgPZZWjaS/e/S6PssRQMFN5oIPIB1qLtounAmCy7Wpo69OCLR9bXXG56gSA==
X-Received: by 2002:a17:90a:7e86:: with SMTP id j6mr10650594pjl.25.1637871536172;
        Thu, 25 Nov 2021 12:18:56 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id t7sm8757758pjs.45.2021.11.25.12.18.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Nov 2021 12:18:55 -0800 (PST)
Message-ID: <619fefaf.1c69fb81.ac454.5742@mx.google.com>
Date:   Thu, 25 Nov 2021 12:18:55 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.290-207-g7570749daf30
X-Kernelci-Report-Type: test
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.9.y baseline: 106 runs,
 2 regressions (v4.9.290-207-g7570749daf30)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y baseline: 106 runs, 2 regressions (v4.9.290-207-g7570=
749daf30)

Regressions Summary
-------------------

platform    | arch   | lab           | compiler | defconfig                =
    | regressions
------------+--------+---------------+----------+--------------------------=
----+------------
panda       | arm    | lab-collabora | gcc-10   | omap2plus_defconfig      =
    | 1          =

qemu_x86_64 | x86_64 | lab-broonie   | gcc-10   | x86_64_defcon...6-chromeb=
ook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.9.y/kern=
el/v4.9.290-207-g7570749daf30/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.9.y
  Describe: v4.9.290-207-g7570749daf30
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      7570749daf3033f4d207835e23099b5ca249f64f =



Test Regressions
---------------- =



platform    | arch   | lab           | compiler | defconfig                =
    | regressions
------------+--------+---------------+----------+--------------------------=
----+------------
panda       | arm    | lab-collabora | gcc-10   | omap2plus_defconfig      =
    | 1          =


  Details:     https://kernelci.org/test/plan/id/619fb5989657718307f2f008

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.290=
-207-g7570749daf30/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pa=
nda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.290=
-207-g7570749daf30/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pa=
nda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/619fb5989657718=
307f2f00b
        failing since 12 days (last pass: v4.9.289-23-g6ecf94b5fd89, first =
fail: v4.9.290)
        2 lines

    2021-11-25T16:10:43.713231  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/125
    2021-11-25T16:10:43.722847  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
230 [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0
    2021-11-25T16:10:43.736844  [   20.625183] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =



platform    | arch   | lab           | compiler | defconfig                =
    | regressions
------------+--------+---------------+----------+--------------------------=
----+------------
qemu_x86_64 | x86_64 | lab-broonie   | gcc-10   | x86_64_defcon...6-chromeb=
ook | 1          =


  Details:     https://kernelci.org/test/plan/id/619fc1f5f096364aa6f2f037

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.290=
-207-g7570749daf30/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-brooni=
e/baseline-qemu_x86_64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.290=
-207-g7570749daf30/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-brooni=
e/baseline-qemu_x86_64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/619fc1f5f096364aa6f2f=
038
        new failure (last pass: v4.9.290-208-gb2ae18f41670) =

 =20
