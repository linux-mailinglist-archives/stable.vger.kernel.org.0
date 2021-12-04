Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC4AA468475
	for <lists+stable@lfdr.de>; Sat,  4 Dec 2021 12:24:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354802AbhLDL1Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 4 Dec 2021 06:27:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240942AbhLDL1Y (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 4 Dec 2021 06:27:24 -0500
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6227C061751
        for <stable@vger.kernel.org>; Sat,  4 Dec 2021 03:23:58 -0800 (PST)
Received: by mail-pf1-x431.google.com with SMTP id g19so5441517pfb.8
        for <stable@vger.kernel.org>; Sat, 04 Dec 2021 03:23:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=U+TEt9uoqE2gxjrER284ceS8Vz/xBJwwFZdMBParggI=;
        b=t5NmMlvlpz5EQbAvPOAqXjSZFdUW5Z18LGiwMi7PQOhUdxgvmtj3U7Zqdap81tkLOO
         2Z4qcmG2wkFnDZQwRQWvtfjNQw2SfYZak7Gb4axG9GrtsM4m7lCedlr8jn6OhP+Gk/z8
         KJYi7nYupd/aXP5GbguZbOhAXJ5YXm5F6fmS0zv3PBJ4zgV8rqK/ZbHLDKe0Ce9COYx0
         WTvJlNMB2lwhj9uW/i9ZDXhDUJ6q8XlRA734clwBvrdXLCmfrUXyMq91dMRUHdp9sp+7
         e9r0wYAe7dlMFqz4CMcQI2LO1gy+56hfkmM3CLGRQUdkCttQwO+26I42Jqi1pJstNdC5
         JLaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=U+TEt9uoqE2gxjrER284ceS8Vz/xBJwwFZdMBParggI=;
        b=A9okc260EZUYFGPAj+8hk7bjv6VrATJDhAqrPatU+fiAATv4cLZ9HKOTvBeeA5go7+
         XWfdbyDqtk4v21z+wYpHn3DYWSmpndEN6I3xUOgiX+Mvg8Z9ls8Raefc+0F2bgCYrh+7
         3eKooDx6kgFH7AfDRuBgcdlbX/fHk/oaaR94TndfJDyOIMvCIIDU01qsQpwfdSO3xxul
         KD2YE0udPhpsxuXyH9pVyTw5O4hilxVYkp8JZhaGwca9ErQ1aftxSU1s4C9ueHIRi5xL
         uY9GfiUXiLY51pXQYWC1BuRYwsHn2NXG+eKj/emV9WXCKTZU947h8gYCjQN6hFeyb6m7
         7bTA==
X-Gm-Message-State: AOAM532DRRtJgFmnN5yQiZ9PTnQU/xKVsILQ+tuW8zQXYuPd3OxNCti4
        LPXPn5CLit3DSSWQBI6viCE3CvEhboh2Ddpz
X-Google-Smtp-Source: ABdhPJywwFIHjkB6aqgysPQt67P+UTXLthYjbilM/SmOS5AtuzodMzBHyAYKpGDoLuTZJ03ErgHwzA==
X-Received: by 2002:a63:89c2:: with SMTP id v185mr9070823pgd.252.1638617038092;
        Sat, 04 Dec 2021 03:23:58 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id on6sm9471031pjb.47.2021.12.04.03.23.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 Dec 2021 03:23:57 -0800 (PST)
Message-ID: <61ab4fcd.1c69fb81.8894a.8fdc@mx.google.com>
Date:   Sat, 04 Dec 2021 03:23:57 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.19.219-16-gb516c2c95dce
X-Kernelci-Branch: queue/4.19
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.19 baseline: 139 runs,
 1 regressions (v4.19.219-16-gb516c2c95dce)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 139 runs, 1 regressions (v4.19.219-16-gb516c=
2c95dce)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.219-16-gb516c2c95dce/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.219-16-gb516c2c95dce
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      b516c2c95dceab74693eb5024194dc35340a629f =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61ab15e19629ed3ec61a94cf

  Results:     5 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.219=
-16-gb516c2c95dce/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.219=
-16-gb516c2c95dce/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61ab15e19629ed3=
ec61a94d2
        failing since 0 day (last pass: v4.19.219-3-g91f80b6b7a49a, first f=
ail: v4.19.219-3-g04afdf3600b5e)
        2 lines

    2021-12-04T07:16:33.312552  <8>[   21.693725] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-12-04T07:16:33.358980  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/102
    2021-12-04T07:16:33.368178  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
cfc [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
