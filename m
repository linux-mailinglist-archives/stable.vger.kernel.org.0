Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 011BE45C991
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 17:10:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242598AbhKXQNv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 11:13:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242693AbhKXQNu (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Nov 2021 11:13:50 -0500
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00CEEC061574
        for <stable@vger.kernel.org>; Wed, 24 Nov 2021 08:10:41 -0800 (PST)
Received: by mail-pf1-x430.google.com with SMTP id x131so3082821pfc.12
        for <stable@vger.kernel.org>; Wed, 24 Nov 2021 08:10:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=zPaYXo4GuJYnFDGsMEbt649NY9wykqF20kSeh7wkSuc=;
        b=PUT75qyd9o+Q1B2YHdHsiM2G+nDmL2CGZTe2SbvHdzmmvkfxY2GTNtA7exsla4mdjC
         dtj5x/Z3dTAqp02JZcap3yl+IunvZEQS92CfSCMu7qFZJYCGBMsuYlgzkPjqcHqWBdJI
         O1Pjo1XPHnUFvddx9YzH43vviMsDZtXFMorzJHFxIUlDhzjfL9lhgGl5CdWNcNvigCew
         JygIj82haAwG7C4s5zZJDXRU5QGRPBDBg9xEE6iqtmODBmx4VW29eD8nMrS3bq9Zo2GW
         foDIqZpZhaSsfQR8krsyuJO3OQbFmMmwjjupbXKqagr8mAdG3wOt27JZxPc5NNFwTaYv
         9PYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=zPaYXo4GuJYnFDGsMEbt649NY9wykqF20kSeh7wkSuc=;
        b=L7z/WjDCaTje/8lej3MPzgxAdryBz3VMScHPcBhwRrZE6hS3vhxHKf/cO2B3pG39M9
         IEDkANMwQQWHrgqbBVIPPfFmsrkfd1vPRLXlY/8fgJl4oNkfu4q/l3QF2oZcn9wnDTQI
         yB26ZS7xgE2cGoV8lfrmtyJKPe/W3rdHsF3Cd5Q7AVX88Q2SdU4lKjp8xZLJLG3APZv6
         io73YkkYhhPeAHSh6KozS5df6ZgYzKRVi9aeeaEwY2BAhHtIAfCf+ML3VDGQX+CCMtqo
         cH3lCgByHo7OVpZb/8NR1T7lDICLP98G5QncsmQON6jWBJflTcd2DA++bF8KpTt2XhWm
         u+0w==
X-Gm-Message-State: AOAM5331XX9pLl2YuTiFfr0RZR67c9tGraTPocvNzJ6ssKg6VHwXpx+B
        uMh4ZysVlxXHXN8Sxc4XDP1fQttzvGM/YpKlY4s=
X-Google-Smtp-Source: ABdhPJx2X6Wpx6EJCW9weUBYOhjh0NpA5OqsuPA/UENlCG++tRTxPZRBFvB36/KvnAGw8l6pX7yKOQ==
X-Received: by 2002:a62:5a02:0:b0:4a2:a6ee:4d8e with SMTP id o2-20020a625a02000000b004a2a6ee4d8emr7255946pfb.47.1637770240380;
        Wed, 24 Nov 2021 08:10:40 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id j7sm198684pfc.74.2021.11.24.08.10.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Nov 2021 08:10:40 -0800 (PST)
Message-ID: <619e6400.1c69fb81.ba20b.0ab1@mx.google.com>
Date:   Wed, 24 Nov 2021 08:10:40 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.4.292-162-g118b5f50cf5b5
X-Kernelci-Report-Type: test
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.4.y baseline: 87 runs,
 1 regressions (v4.4.292-162-g118b5f50cf5b5)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y baseline: 87 runs, 1 regressions (v4.4.292-162-g118b5=
f50cf5b5)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.4.y/kern=
el/v4.4.292-162-g118b5f50cf5b5/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.4.y
  Describe: v4.4.292-162-g118b5f50cf5b5
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      118b5f50cf5b541d1e26bbf2c24611f0104c545d =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/619e29eb96950ba229f2efbf

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.292=
-162-g118b5f50cf5b5/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-p=
anda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.292=
-162-g118b5f50cf5b5/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-p=
anda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/619e29eb96950ba=
229f2efc2
        failing since 0 day (last pass: v4.4.292, first fail: v4.4.292-160-=
g4ba1793245b0)
        2 lines

    2021-11-24T12:02:31.447015  [   19.445617] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-11-24T12:02:31.488908  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/121
    2021-11-24T12:02:31.498137  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
25c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0
    2021-11-24T12:02:31.513249  [   19.513763] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =20
