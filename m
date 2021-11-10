Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75C5244C85F
	for <lists+stable@lfdr.de>; Wed, 10 Nov 2021 20:05:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233176AbhKJTH4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Nov 2021 14:07:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233301AbhKJTHx (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Nov 2021 14:07:53 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5336C049569
        for <stable@vger.kernel.org>; Wed, 10 Nov 2021 10:57:59 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id gx15-20020a17090b124f00b001a695f3734aso2621385pjb.0
        for <stable@vger.kernel.org>; Wed, 10 Nov 2021 10:57:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=hAkmL5khATGPXadCWaSNDN68jeyzr6KLgfzSnIMUotw=;
        b=HtLPR1N0mCu/RKcgMjcUtujGcqMB4pAOoMYlTtNDabGSP1Xq+jq7dVEpGVMSpAuTo+
         GyPbPLPQpzUlWNczTXgphb8eBlrAHFjTRJze3HL3QfQrYSM7/rdjtqYCR4okc1Ly+mvV
         m3AdOd89ihcpL9+xDM+UmhwhBFqzqKXCeIIc8pIEa+AYUgiTpYy8XHhFLHe3WvXN3p2E
         uA3vVmQ864Xn96fXPCoXdxLshLNuNXkk3XLNc8583biX9TJ/hslXlmw2/gSgHoBj9TOK
         CrqlJKETRyiSvriZIZxYzGMNRWNJb2bjo87AxLmSnVS/fh6jrY8bXs4KvJGkG3GEkvrL
         gLlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=hAkmL5khATGPXadCWaSNDN68jeyzr6KLgfzSnIMUotw=;
        b=2tNui7nTDUCJJPfezc6D9GpRLeh2qytwOUPRuDkSgU66NDoPPK1SwsZ1YEjiGeTaJv
         xkporvau+D4YfT9cESNZaYARcD5BvUNiOBmAIYLDdQ/KNZdmT+hGtUkRCANChSm9dLaT
         beV6xYs9e7PtCh8Td30xwZR+8TtKHqVAZu8b0NFNrt2LpmRvh0H8vW+HeDh+1Cm51gIm
         J78rZtdqNIZO3JUJlC436k/ZlSVDWTd8G7XuwsxPF1S05hF6pHOJsr0wzm2d2vyZUIlm
         3B3xW/tyoOkAZ8FDKKqZrRirSYZ0Pww+QkpcxGNYM2yblATj1JMQ1wyAsF0EUmJHQKEz
         EUbQ==
X-Gm-Message-State: AOAM533leltlcYVFx5Xs8AihmtzPEztbRTCI0P9sZ/DELBKmKbDdfOPE
        1+dEnhKqNp9PUZQ8T1q4yVMHKfminDrlWuNFJXA=
X-Google-Smtp-Source: ABdhPJy/BVBe/nctwoFzd6xr5VFk/BwOlkP4rbY/zZROQDQ4nE0FTP5c6aKOLaDzeY1gjFFWROniNA==
X-Received: by 2002:a17:90a:3e09:: with SMTP id j9mr1279721pjc.24.1636570679170;
        Wed, 10 Nov 2021 10:57:59 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id l11sm404154pfu.129.2021.11.10.10.57.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Nov 2021 10:57:58 -0800 (PST)
Message-ID: <618c1636.1c69fb81.a9748.180b@mx.google.com>
Date:   Wed, 10 Nov 2021 10:57:58 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.9
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.9.289-13-g0082655058e8
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.9 baseline: 151 runs,
 2 regressions (v4.9.289-13-g0082655058e8)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 151 runs, 2 regressions (v4.9.289-13-g0082655=
058e8)

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.289-13-g0082655058e8/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.289-13-g0082655058e8
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      0082655058e8717d0a4dd3bf371221cbb35c45d4 =



Test Regressions
---------------- =



platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
n...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/618bdbd4e88ac536a83358fb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.289-1=
3-g0082655058e8/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-minnowboard-turbot-E3826.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.289-1=
3-g0082655058e8/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-minnowboard-turbot-E3826.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/618bdbd4e88ac536a8335=
8fc
        failing since 0 day (last pass: v4.9.289-12-ga8dbc302bd30, first fa=
il: v4.9.289-13-gedccd370d9d7) =

 =



platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
panda                    | arm    | lab-collabora | gcc-10   | omap2plus_de=
fconfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/618bdc2c2c039975813358df

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.289-1=
3-g0082655058e8/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.289-1=
3-g0082655058e8/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/618bdc2c2c03997=
5813358e2
        new failure (last pass: v4.9.289-13-gedccd370d9d7)
        2 lines

    2021-11-10T14:50:02.158591  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/119
    2021-11-10T14:50:02.167374  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
230 [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1
    2021-11-10T14:50:02.183100  [   20.108703] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =20
