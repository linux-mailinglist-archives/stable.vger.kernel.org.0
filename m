Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9172D4A3005
	for <lists+stable@lfdr.de>; Sat, 29 Jan 2022 15:19:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232370AbiA2OTy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 29 Jan 2022 09:19:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233635AbiA2OTv (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 29 Jan 2022 09:19:51 -0500
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7DECC061714
        for <stable@vger.kernel.org>; Sat, 29 Jan 2022 06:19:48 -0800 (PST)
Received: by mail-pl1-x634.google.com with SMTP id d1so8648636plh.10
        for <stable@vger.kernel.org>; Sat, 29 Jan 2022 06:19:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=iRg9nGSOF2E1cpVYIvpdEkU+Xf7zhoAscV4MOo5ZwV4=;
        b=kxdO4FxH+qi/sFBfdoTWyoyw4vGr6KHQPN7cF39qQQkIMNPwFFUks44eC9ZKle/lZK
         SL8IWKH7ykTwsCiZ2C4wSj2/9xWrnPnLeA6ooUOHXVl567hEMYeeE8rRJtxhNgpU3y0d
         KywNo4O+WRzq9n5rJsJCD7QMX/DIZ/aAReL/p542JDl434SH23DS6zmAluwEla5PLrhn
         Jm4B8v+540vwJFJ+3GS+9B2EFbfN7l8GoWMbAP6sl/8ccGpRg0JQ5KbK9H/2cvArNPu8
         CgUyqHcvl5veAitsX2CM/rlg93/W4AgknCUv2x6GfHMDmDNq7HYq9rvx6v+zORlMZPKP
         JEvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=iRg9nGSOF2E1cpVYIvpdEkU+Xf7zhoAscV4MOo5ZwV4=;
        b=li75btdKAq4/xPLYAa8cJedgTnIlm5Hc0tLzdOF68Qms1yFw+C3SVQ/X1eb84r65br
         +tMbfwmjiSwrFioRpCy8RYC2VDEKnCeFijDjM2FpXRxXlKAGs/x4sZKiKeiFMhfAlSSt
         EaL2SoWFG+QWK95J1bQj54LKg0YzgSJO9LBB2GEAClrIuNSmjtGU/VKcfin7Qq6jNHZr
         5UHPsS4ujI4D3xhvuuLRl0v883vwyLi6MDz9zA0Vnrcx3lGlk/1crBcSV9/BIFW0iUug
         l9addDhXpFydqJ2RSWDMyInxOUWTsKrJvcLenp3VzjsOIfn3qroDrnbu+5WYu/A9vxxC
         9dJQ==
X-Gm-Message-State: AOAM532ZRZdWFgjuKWaAqMFoiFRhakHUR/9qgnTNwc1Q/lEOeeHxasoh
        BfirMiIAPzb5o84bvYV5tzRsTOupTU4SA4y8
X-Google-Smtp-Source: ABdhPJzbvJdXc8HJiGBaLx0+ogkd29U9KtTcreZjmVPvaeLajfpWrDKjBIy/qIOsUzubddXMAn8bOQ==
X-Received: by 2002:a17:902:e88b:: with SMTP id w11mr12642399plg.153.1643465988065;
        Sat, 29 Jan 2022 06:19:48 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id p17sm3641192pfh.59.2022.01.29.06.19.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 29 Jan 2022 06:19:47 -0800 (PST)
Message-ID: <61f54d03.1c69fb81.5955c.9806@mx.google.com>
Date:   Sat, 29 Jan 2022 06:19:47 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.9.299
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-4.9.y
Subject: stable/linux-4.9.y baseline: 113 runs, 2 regressions (v4.9.299)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.9.y baseline: 113 runs, 2 regressions (v4.9.299)

Regressions Summary
-------------------

platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
asus-C523NA-A20057-coral | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
n...6-chromebook | 1          =

panda                    | arm    | lab-collabora | gcc-10   | omap2plus_de=
fconfig          | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-4.9.y/kernel/=
v4.9.299/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-4.9.y
  Describe: v4.9.299
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      224d99f50f25ec3234b99556c0076a7130e230c6 =



Test Regressions
---------------- =



platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
asus-C523NA-A20057-coral | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
n...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/61f514f82601cec290abbd3f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.9.y/v4.9.299/x8=
6_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-asus-C52=
3NA-A20057-coral.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.9.y/v4.9.299/x8=
6_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-asus-C52=
3NA-A20057-coral.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61f514f82601cec290abb=
d40
        new failure (last pass: v4.9.297) =

 =



platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
panda                    | arm    | lab-collabora | gcc-10   | omap2plus_de=
fconfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/61f51495a5b6ccfe8eabbd36

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.9.y/v4.9.299/ar=
m/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.9.y/v4.9.299/ar=
m/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61f51495a5b6ccf=
e8eabbd3c
        new failure (last pass: v4.9.298)
        2 lines

    2022-01-29T10:18:44.955026  [   20.202789] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2022-01-29T10:18:44.994319  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, kworker/0:1/19
    2022-01-29T10:18:45.003648  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
230 [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =20
