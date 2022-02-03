Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4551D4A8952
	for <lists+stable@lfdr.de>; Thu,  3 Feb 2022 18:09:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233690AbiBCRJV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Feb 2022 12:09:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230439AbiBCRJU (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Feb 2022 12:09:20 -0500
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E3FBC061714
        for <stable@vger.kernel.org>; Thu,  3 Feb 2022 09:09:20 -0800 (PST)
Received: by mail-pg1-x52f.google.com with SMTP id q132so2770975pgq.7
        for <stable@vger.kernel.org>; Thu, 03 Feb 2022 09:09:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=+AO9rJvO2crPn/KYYgtBPm++9YLmNLyLO7E8iffPQKk=;
        b=zMloaTBxZjSeXKszb1iHTgDrJWQKuV3ZKPkCpHVanAnOcVC5S9Mr2jHQHokC9oPPkn
         Jojg/Bxp/WJewrELKiVfI/xI5Ku9RsHGdyHI4YEhVtpda7n22LUSZad+zRs9aeoVVvab
         1qlIvA6/M4twUgv/HKHuD71Ve2bMxeS1TwLyQDs1hhpsoEtp1RRP9Xuwo063cfhSV+8H
         3KCPpq6sAs8Emk+OsMMD3GVw3sT4Ysjz257Iw4BSg/3xJb9MJXZYFEBsupqBkME4sL5q
         XPBbjDbKWWg4WE5P1N8AzAl3rGNYWfoqaJX3a1YBC6cSi/kF2Qe/g1stoQCyp1TZmfUH
         VoPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=+AO9rJvO2crPn/KYYgtBPm++9YLmNLyLO7E8iffPQKk=;
        b=8LG/1RTkG4OX8gSQZOXUh/Y7JYBhF0HakGqtjODvdi4cnjiEpAtUkZGpcqgJKAT7rc
         fT0znXu/0YoYdkMEZPcM6D9lDymPCpctgY1vg04gHrwhpx1sjrOJI5P1vxRnneKxsYug
         Vr34jdbrBWoi+GIzZw1pAdPSajzoeZhew9HBsgeDVZH8ZAnVphlDs9G3X9Hrhv5HvNaQ
         qa7fmsw4l1szm/UHo57BfqB5sQOs1g/Cwv+aORav6j2AfDLdI1rweuJcfKuFr0bAsFnb
         0qwRDapjvHC0CrPnLmTSDLu+jlDIH/U0sBQzf4Df3Mva4cUXgrxp/gx+Hq5d8XfzlWk3
         AxbQ==
X-Gm-Message-State: AOAM532450g9cWbUosznHMJW04r2kaOkUPR9qaohTNEwoYI/iWcuwXMt
        2VUqaA7UJqILVd8p1tgnVoDMrRlZ5WiVq26f
X-Google-Smtp-Source: ABdhPJwXY/cVa5dhLia0nbQrkS4C0IQ1SuCGxcTHKXVpZxTJhwzftm/haOsRGqkC0dgrvTuBcpQZJQ==
X-Received: by 2002:aa7:8695:: with SMTP id d21mr35338416pfo.36.1643908159862;
        Thu, 03 Feb 2022 09:09:19 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id z1sm26839049pfh.137.2022.02.03.09.09.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Feb 2022 09:09:19 -0800 (PST)
Message-ID: <61fc0c3f.1c69fb81.54794.2831@mx.google.com>
Date:   Thu, 03 Feb 2022 09:09:19 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.227-45-g64c20ab4d0e4
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/4.19
Subject: stable-rc/queue/4.19 baseline: 126 runs,
 1 regressions (v4.19.227-45-g64c20ab4d0e4)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 126 runs, 1 regressions (v4.19.227-45-g64c20=
ab4d0e4)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.227-45-g64c20ab4d0e4/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.227-45-g64c20ab4d0e4
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      64c20ab4d0e4a401d43d1e989a2a0b198218b1af =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61fbd18fa89faf8bb95d6f1b

  Results:     5 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.227=
-45-g64c20ab4d0e4/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.227=
-45-g64c20ab4d0e4/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61fbd18fa89faf8=
bb95d6f21
        failing since 1 day (last pass: v4.19.227-45-g1749fce68f74, first f=
ail: v4.19.227-45-g388e07a2599d)
        2 lines

    2022-02-03T12:58:40.858964  <8>[   21.464385] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2022-02-03T12:58:40.911242  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/97
    2022-02-03T12:58:40.919743  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
cfc [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =20
