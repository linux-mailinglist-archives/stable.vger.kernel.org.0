Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 648C447D928
	for <lists+stable@lfdr.de>; Wed, 22 Dec 2021 23:08:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230419AbhLVWIX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Dec 2021 17:08:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230063AbhLVWIX (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Dec 2021 17:08:23 -0500
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F18F4C061574
        for <stable@vger.kernel.org>; Wed, 22 Dec 2021 14:08:22 -0800 (PST)
Received: by mail-pl1-x62b.google.com with SMTP id c7so2862574plg.5
        for <stable@vger.kernel.org>; Wed, 22 Dec 2021 14:08:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=btXO5BpSJ+4k8rdzC8N+20OWLC6lfs43wH0A3Ajntc0=;
        b=Z7zolH1+wRRUe1DvwjXmSXD08hSb1u9tZZzC6ANqOTgMPv5WFim/VLHks+CqkUV0E4
         bWqY+BngxK4fVn/ZYCvjmdA5zQOSgSrhiXQUl4bSYP6cjQmROBwCW2elXzA+O4JFeng/
         t7y7HV3eDypQeqpkVxShT10FhSjaBGv7+oC/Zjv9MeOWdYgFLOCoKurSzQu2y4GItqVw
         ZNe92MHtncExnkcjkkLIia8ukPUlhBK39tQSgTEyckT2ef42LjXDGmtDYSEAbfUGMA2n
         OdsM4n3ugmPjzD3J3PPGW0U/jVMzlHgNxs7CM7ANMGA+aZDRGT/sX4iOfpu7bBf2S/xP
         nZ6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=btXO5BpSJ+4k8rdzC8N+20OWLC6lfs43wH0A3Ajntc0=;
        b=Y2PtPzxA3IDgEubYu5ReNwH+nMttetiBlzflwH7C+j7UlYUr6Ntvm6h9qFHMhYQ3XY
         ZKOgeZvd8TjsQg0UFNzZKac1LEBDOLnPv3TWy/hN3Y36sc6DQUf8BUOdZceD8adUCho0
         QQi85Gs4udWDCbbzjwvQSzDKugms4nuZ+vLJQpAPmGkqxOn0oukNaqnGDfdzYjq8V5AQ
         +Nf4QOtJ36gWXNwvUhXeQhufk/tDkZ/w25hhLkFFfEdSIq+1LVm/qUco6Q+WNvnQA+AA
         cpbXsEQmpbcrF9ADB1LW/txt9DYJSwqU0qJCcTWcaysgcWT2sGpX9wP1us3NkChePxTB
         cRTA==
X-Gm-Message-State: AOAM533Th9fTeVCm+txoUEIyuWOIxbsgg2vGbolP9TTSrafKvx+AyFOH
        l+9i4qfqOob0E4o+3B8tYJSYxffNTw8jCDmrNCU=
X-Google-Smtp-Source: ABdhPJw2K4NOspULGjjQRuW/LdPhfMVuNLHBCabJgl/qiX7ZOgWxFgbJdvxN6y8UlIDfOaYxByElxQ==
X-Received: by 2002:a17:903:249:b0:143:c077:59d3 with SMTP id j9-20020a170903024900b00143c07759d3mr4710846plh.26.1640210902197;
        Wed, 22 Dec 2021 14:08:22 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y65sm2876515pgd.79.2021.12.22.14.08.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Dec 2021 14:08:21 -0800 (PST)
Message-ID: <61c3a1d5.1c69fb81.49d95.857e@mx.google.com>
Date:   Wed, 22 Dec 2021 14:08:21 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.4.296-3-g1a7c963f71f9
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/4.4
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.4 baseline: 102 runs,
 2 regressions (v4.4.296-3-g1a7c963f71f9)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 baseline: 102 runs, 2 regressions (v4.4.296-3-g1a7c963f=
71f9)

Regressions Summary
-------------------

platform                 | arch   | lab           | compiler | defconfig   =
        | regressions
-------------------------+--------+---------------+----------+-------------=
--------+------------
minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
nfig    | 1          =

panda                    | arm    | lab-collabora | gcc-10   | omap2plus_de=
fconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.4/kern=
el/v4.4.296-3-g1a7c963f71f9/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.4
  Describe: v4.4.296-3-g1a7c963f71f9
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      1a7c963f71f9ca8689017efae66f816258884925 =



Test Regressions
---------------- =



platform                 | arch   | lab           | compiler | defconfig   =
        | regressions
-------------------------+--------+---------------+----------+-------------=
--------+------------
minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
nfig    | 1          =


  Details:     https://kernelci.org/test/plan/id/61c36806443090ba3a39715d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.296-3=
-g1a7c963f71f9/x86_64/x86_64_defconfig/gcc-10/lab-collabora/baseline-minnow=
board-turbot-E3826.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.296-3=
-g1a7c963f71f9/x86_64/x86_64_defconfig/gcc-10/lab-collabora/baseline-minnow=
board-turbot-E3826.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61c36806443090ba3a397=
15e
        new failure (last pass: v4.4.295-23-gcec9bc2aa5d3) =

 =



platform                 | arch   | lab           | compiler | defconfig   =
        | regressions
-------------------------+--------+---------------+----------+-------------=
--------+------------
panda                    | arm    | lab-collabora | gcc-10   | omap2plus_de=
fconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/61c368180fe969746039711e

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.296-3=
-g1a7c963f71f9/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.296-3=
-g1a7c963f71f9/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61c368180fe9697=
460397121
        failing since 1 day (last pass: v4.4.295-12-gd8298cd08f0d, first fa=
il: v4.4.295-23-gcec9bc2aa5d3)
        2 lines

    2021-12-22T18:01:37.793177  [   19.046508] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-12-22T18:01:37.836753  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/119
    2021-12-22T18:01:37.849152  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
25c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
