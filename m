Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 475314564A2
	for <lists+stable@lfdr.de>; Thu, 18 Nov 2021 22:00:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232950AbhKRVDj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Nov 2021 16:03:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230422AbhKRVDi (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Nov 2021 16:03:38 -0500
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80281C061574
        for <stable@vger.kernel.org>; Thu, 18 Nov 2021 13:00:37 -0800 (PST)
Received: by mail-pl1-x631.google.com with SMTP id q17so6324302plr.11
        for <stable@vger.kernel.org>; Thu, 18 Nov 2021 13:00:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=sHFSsoaojBLefLuO/L5Nx8mcsDpGYIaPb5vjIPNvNys=;
        b=Haf/9rpMkLF1vjgOhlgGolWEQPsIJ0IBBh0Gd7P8fWGUgfJlJUfp9GZQWitF0Cf6Ft
         bCETUm8dd6Fkj4++7D6W1Sn6dimnP545RdT7+jQYmzAWUFuLPHkAa/1CDz9UKo1bAmh9
         fkIvS2raK/bGEyS0nZYPoqYNCPC34jGcuIlStuy0OQVSSB74Wg1FgWey5yWqTGxZuA93
         dQ9h4aAWiv575RXVNQTwzWnYsC6UsUwNAMJ5vs8qHfb9GdgrmNG0P11D60xqvBw3WNEA
         On8kB1ajPuHRa6SfZagsc+cyzjU+8JVUMcj9CMnYrIsQP/P8gFqOLYVWKRJyAFGWPWFZ
         WmEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=sHFSsoaojBLefLuO/L5Nx8mcsDpGYIaPb5vjIPNvNys=;
        b=GRnwjZ1yXeMJvpIN0vWkHtnUniHpMKEer1O5j7GF8v9xHteNk6myab/5c0BL7GWcby
         0PhYJSt69c7eiAyxybI3LNHUHE5Fa60rP0as5pubk78sf1y5JmHjAF5xr10pfJbiOkNh
         C9d1m6X1H9JTBVlGxC0OLXYjvVvJDolvKAMdc3HI9xB5XV9yyRehjHM3v6BQi7mNpeg9
         hpHaoAtZI7bM8xoDRI+VbxNnfn5qp0r3jxJNc/qBTUN3HmDIK6aYXbg9nm5RNh1shDtP
         1F/0bADtdoA45rGw0uH0paCrmq5Ex+pjrZ+p8i9NZcR3f1voHkrsg5cEN4Nk7mC58GtT
         rZvg==
X-Gm-Message-State: AOAM532ekQUMWZREmcNQdMbaYFIVemUqRWJ7bP+GoCRT/AQVnPOm484u
        WPiR5ikdPJl03E1L1BbR8MZo5RBIb4GazG8Z
X-Google-Smtp-Source: ABdhPJyiH44w31Sr9FTmV5SOf25raxhX8r5G8WvpE8RHO3o+FlL3okj5xPfONNCdKmjVd4JwKVaS/A==
X-Received: by 2002:a17:90b:97:: with SMTP id bb23mr369pjb.201.1637269236716;
        Thu, 18 Nov 2021 13:00:36 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id e18sm405495pgl.50.2021.11.18.13.00.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Nov 2021 13:00:36 -0800 (PST)
Message-ID: <6196bef4.1c69fb81.f6794.1d26@mx.google.com>
Date:   Thu, 18 Nov 2021 13:00:36 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.9.290-159-gacda9050a82b
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.9
Subject: stable-rc/queue/4.9 baseline: 103 runs,
 2 regressions (v4.9.290-159-gacda9050a82b)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 103 runs, 2 regressions (v4.9.290-159-gacda90=
50a82b)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-baylibre  | gcc-10   | multi_v7_defconfig  | 1       =
   =

panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.290-159-gacda9050a82b/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.290-159-gacda9050a82b
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      acda9050a82bb4c15f111de98eb29600099acb45 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-baylibre  | gcc-10   | multi_v7_defconfig  | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61968ba5e75f1fbd55e5524f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.290-1=
59-gacda9050a82b/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-panda.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.290-1=
59-gacda9050a82b/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-panda.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61968ba5e75f1fbd55e55=
250
        new failure (last pass: v4.9.290-159-gbf72a0fffb43) =

 =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/619687c265262b4de4e551de

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.290-1=
59-gacda9050a82b/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.290-1=
59-gacda9050a82b/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/619687c265262b4=
de4e551e4
        new failure (last pass: v4.9.290-159-gbf72a0fffb43)
        2 lines

    2021-11-18T17:04:47.254411  [   20.110137] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-11-18T17:04:47.297900  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, syslogd/101
    2021-11-18T17:04:47.307502  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
230 [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =20
