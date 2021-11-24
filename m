Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4133B45CD2C
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 20:25:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245479AbhKXT2z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 14:28:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245713AbhKXT2y (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Nov 2021 14:28:54 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04E53C06173E
        for <stable@vger.kernel.org>; Wed, 24 Nov 2021 11:25:44 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id x7so3350919pjn.0
        for <stable@vger.kernel.org>; Wed, 24 Nov 2021 11:25:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=7j1fRXZSEdabJd69PayA1GvK/Gr9b4hC1iEqZyvR+3c=;
        b=ajbnQ4ba4v6kIcLRd0cDfSgODHsnu6fwcIsamLgJaaU63Rl4wBaev9x26cLmEoU7ri
         MuA8S0iHwzoVdHZxLxOnOSTb9v1PxY5i7Adon857mCk+MAgjg3TdklXfXW+Y06r0N12R
         hW3DK99BhNMOfDug5b836nsRHHa9xNU1Xvx+7uXw7zyJRwchTeZhEaXiQY7zoydAt7NA
         qjqWgZR2cjr19IXlnwOeZJ6E77/4rBbiLr+cK77zxZ5/jjU5Ne82vKcTd/Ym9qU1ktaN
         83mzcfuFjp8LoBLAyxxzuo51CwHVWH8Gpmy2thbi9flXj4GEBCiUSxB1vPF8rFoazAGD
         FgJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=7j1fRXZSEdabJd69PayA1GvK/Gr9b4hC1iEqZyvR+3c=;
        b=lF2aOZyUawhHXSZOTceSKYavoun4CIXBNzQJlWRoT7fILz+8MB6SzEj4GValU+d8tp
         Nfjm5Nm5qZacwdLPvWvl9ChMGUewy6moa/JeYKRmpm/8Ikna1ygZgzWCdZTIBf39q6QI
         +O+AgN37Z5YDN8hSKHYMz+UVQGRDi3NcU91kErzJT6EHOG2l8ICiTAL74q+0d0E3BozI
         KAGbDXSFW9/D6i3haD5wArpY//7dWU0Cr13z6TqxdnJqp5ytOgcBgvdw7YhMWQ7e7IhP
         TVRIkyDzsRlb6yQUJCCb7ocB2hQ/74gwWKOpENvKJ2LrrqjNN+/4IOEQYoxIkV6nRpG+
         rB/g==
X-Gm-Message-State: AOAM531TD9CivLaJ4BrAuXe98iMEgVit/tBiPpIubICNgUdcVrV+a9HO
        9cDV5SR4qE/wX8SbIZJ2f0hbxjeCSebOkbY6IC4=
X-Google-Smtp-Source: ABdhPJwsfUdr6yqxg8RvJsJOrNWSKXaCeYF8RYWnw1X81eLxN3ZuiLjp2MLRoz9i6YH4B10Q6a8EZw==
X-Received: by 2002:a17:90a:fe1:: with SMTP id 88mr18938073pjz.24.1637781943468;
        Wed, 24 Nov 2021 11:25:43 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id h15sm515286pfc.134.2021.11.24.11.25.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Nov 2021 11:25:43 -0800 (PST)
Message-ID: <619e91b7.1c69fb81.e3c73.1f1b@mx.google.com>
Date:   Wed, 24 Nov 2021 11:25:43 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.217-321-gc8031cd679ef7
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/4.19
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.19 baseline: 143 runs,
 1 regressions (v4.19.217-321-gc8031cd679ef7)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 143 runs, 1 regressions (v4.19.217-321-gc803=
1cd679ef7)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.217-321-gc8031cd679ef7/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.217-321-gc8031cd679ef7
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      c8031cd679ef76f65f62d19750a34f5f751ab6cb =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/619e56e2e590f13ceaf2efad

  Results:     5 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.217=
-321-gc8031cd679ef7/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-p=
anda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.217=
-321-gc8031cd679ef7/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-p=
anda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/619e56e2e590f13=
ceaf2efb0
        new failure (last pass: v4.19.217-322-g9624de0ec0d55)
        2 lines

    2021-11-24T15:14:26.238143  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/103
    2021-11-24T15:14:26.247349  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
cfc [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0
    2021-11-24T15:14:26.268732  <8>[   21.251068] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>
    2021-11-24T15:14:26.268997  + set +x   =

 =20
