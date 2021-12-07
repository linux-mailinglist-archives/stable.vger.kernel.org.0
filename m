Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C712346AF28
	for <lists+stable@lfdr.de>; Tue,  7 Dec 2021 01:29:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349875AbhLGAcj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 19:32:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344456AbhLGAcj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 19:32:39 -0500
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1454FC061746
        for <stable@vger.kernel.org>; Mon,  6 Dec 2021 16:29:10 -0800 (PST)
Received: by mail-pf1-x432.google.com with SMTP id x131so11687614pfc.12
        for <stable@vger.kernel.org>; Mon, 06 Dec 2021 16:29:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=1Tq3CzCeRoP0GEb3lzX7xGb8osy6SzczYLMxFiivRp8=;
        b=gWKZCZpngCSbhhUfDe4o+FEcDIzTb5tXmr4Gukira1mnkv7h5oL5ZhZxESnK4MReqq
         rM5jidAKDykWlovZqahPM4tT5Y2xYdJi028H/NqkUbFeSdmh752NAr6gNWR662cX6Uuc
         OJLL7sHtJDaOcCYa5ULM9rXGYxTa9pCtOPS5BxkPZcBR82lqBTvwalI2mdXxCK2bya0u
         HhTxswG1tPT0S71ok4tLUOI+sXq0CaTb90rTFLIsrnFkow4tu5k7qxU9D8N0Kacg6+x8
         sreGALSaoLjdE7VjlD0haeH8xIqcDyA9Tr0AZw//yxJzyx5icK7uSv8OyLzVUS7aLSc/
         gVQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=1Tq3CzCeRoP0GEb3lzX7xGb8osy6SzczYLMxFiivRp8=;
        b=e5CdPV8qMPBvpbiBFRv6eP9wk1ZQ8KYR0sEjg8vBYBSfawvvYQOwvYy4WUmK3wVnZr
         GZtt5XBN7Qlm2PSovXyuxAWonFWLtCwU8QZBlTZR86ExgvSgTUBJA19g0DrE118aNG1H
         Rd8R/zKgestSOBlBC2Z11JaoVUgyj8ZN5E+L4u+kwsdfE+gVMFvQpvhqUtg0tv16ohex
         YX5uMr/w7tBR5v3NsZAYmXTewsccPP7aCIQIk33jxxbi8TfvG/sMgQW3q4foz1HQYSl6
         UEpl6u2CmM/U8ttCVwe87OuKYPeyIGuLG6LsCZp6vJrZw9D+gHck6f0FhI8aqQsT5eB3
         dBiA==
X-Gm-Message-State: AOAM53245aI9tMXkn/ey9usaqgGJRUmn1WffzHGSVM0ubJEMCBD9o6Ah
        6ixH3jzcTWOqFLryM6SklYsrWko2BVlAUnS9
X-Google-Smtp-Source: ABdhPJwKbjmLuUZTGH9UU9B7MmJpCPvnxaWGdlTBHy1a0/HqTZN+SN6aZZEAyQweSDtUB0D6vV63KQ==
X-Received: by 2002:a62:2503:0:b0:4a2:b772:25ac with SMTP id l3-20020a622503000000b004a2b77225acmr39504300pfl.53.1638836949438;
        Mon, 06 Dec 2021 16:29:09 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id nn4sm512611pjb.38.2021.12.06.16.29.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Dec 2021 16:29:09 -0800 (PST)
Message-ID: <61aeaad5.1c69fb81.58521.22ff@mx.google.com>
Date:   Mon, 06 Dec 2021 16:29:09 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.9.291-63-gb14dcd4dade2
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.9.y baseline: 103 runs,
 2 regressions (v4.9.291-63-gb14dcd4dade2)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y baseline: 103 runs, 2 regressions (v4.9.291-63-gb14dc=
d4dade2)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-baylibre  | gcc-10   | omap2plus_defconfig | 1       =
   =

panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.9.y/kern=
el/v4.9.291-63-gb14dcd4dade2/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.9.y
  Describe: v4.9.291-63-gb14dcd4dade2
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      b14dcd4dade22e4f6d6e07a965f92c5eac548baf =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-baylibre  | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61ae729634964ac3f71a94b5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.291=
-63-gb14dcd4dade2/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.291=
-63-gb14dcd4dade2/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61ae729634964ac3f71a9=
4b6
        new failure (last pass: v4.9.291-58-g806c3e48c0caf) =

 =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61ae715c5a77d1afd41a94b6

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.291=
-63-gb14dcd4dade2/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.291=
-63-gb14dcd4dade2/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61ae715c5a77d1a=
fd41a94b9
        failing since 23 days (last pass: v4.9.289-23-g6ecf94b5fd89, first =
fail: v4.9.290)
        2 lines

    2021-12-06T20:23:36.883486  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, syslogd/101
    2021-12-06T20:23:36.892964  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
230 [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =20
