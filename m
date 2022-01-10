Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E4274898C9
	for <lists+stable@lfdr.de>; Mon, 10 Jan 2022 13:42:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245626AbiAJMmU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Jan 2022 07:42:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245599AbiAJMmS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Jan 2022 07:42:18 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45BFCC06173F
        for <stable@vger.kernel.org>; Mon, 10 Jan 2022 04:42:18 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id r16-20020a17090a0ad000b001b276aa3aabso22410077pje.0
        for <stable@vger.kernel.org>; Mon, 10 Jan 2022 04:42:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=WrXr9DXXuTWsP/97HB+7sRtMd5VkTvVp5sHj4aOhvtk=;
        b=3emcFPnCIW/M3HXxqmbLskUcmj4Y1N/5e3xkKT2EJNRkShszpOnFOd412fa2qn/Xv/
         O3BJI3RlTwKZl1JPKDXWLD+zdPePY1m/vxWNs70/VMlWFHQksgf/SyMQJa8cq1RuHU5d
         AgodIUXzVN752Ly5lv6L5+ElVDJTzfAtPdzByY5tZLLUq8JPx1YedBsBYdYS8BKMtBrB
         1d+W/IwmjAxAPSJAxt875uBbRL2kX4jFUo9uyFq8W6C6aK9xXVbjABFvwodmY5PnDAXl
         te79BJkIn7yIrlekxrU0bnkWCT9vgk1PimiXzkJhsv72fvivYstqJtACuqzSEGAoZQpC
         fLQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=WrXr9DXXuTWsP/97HB+7sRtMd5VkTvVp5sHj4aOhvtk=;
        b=i3OI0Ono31Wgye3dh56raY8Qn8Io5DpnVmI3rF75HM8rK6LcYt/RpA2bVGX1xZu9WG
         iUESI2TyG0va5dV+FeVc1safY3b5FxUZEJzNrNyfsvlVQTYXsIY59KjCyO+0gtYTSQU3
         CA9glqNL6/l70UgWE2vSmF4XP2ZPgc9jZLZsykLwyjRNEJJEMK0vA4YAg9ctFR+OegfF
         ADi+2yGGFEHY3V8/0/92u/jQGcZkRNmOfKFegD+TT4LwzTn9P5PYpCJ+gqLHdL7Ipqhi
         ufJNpi+IsEh2acyzS1sG2WgSTdk89EuBNkPh5i9Cgv5insYXBEd27tI97xuhwE9Y5E7N
         eNmA==
X-Gm-Message-State: AOAM532rz1lseg6R+AMnBaDSdQVzrr7wzEoPPe51IDoZB9pibAb6hfii
        cXzxckChKRq+eBs05JAT0DwNAHhtQVKdr4jQ
X-Google-Smtp-Source: ABdhPJytLw2VDwfJscNk8g+69EXL6em7dw370+PR7yUCXx8Mut8mEepVhx/+2k990myNLKzfH8+T7g==
X-Received: by 2002:a17:902:b40c:b0:14a:792:741f with SMTP id x12-20020a170902b40c00b0014a0792741fmr14282111plr.113.1641818537714;
        Mon, 10 Jan 2022 04:42:17 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id l21sm3476016pgk.41.2022.01.10.04.42.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Jan 2022 04:42:17 -0800 (PST)
Message-ID: <61dc29a9.1c69fb81.20f7e.86ff@mx.google.com>
Date:   Mon, 10 Jan 2022 04:42:17 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.224-21-g8ae57b7315c2
X-Kernelci-Branch: queue/4.19
Subject: stable-rc/queue/4.19 baseline: 133 runs,
 1 regressions (v4.19.224-21-g8ae57b7315c2)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 133 runs, 1 regressions (v4.19.224-21-g8ae57=
b7315c2)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.224-21-g8ae57b7315c2/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.224-21-g8ae57b7315c2
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      8ae57b7315c28f4957fff8978e64723bdf746586 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61dbea7fe08ec32bbdef674d

  Results:     5 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.224=
-21-g8ae57b7315c2/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.224=
-21-g8ae57b7315c2/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61dbea7fe08ec32=
bbdef6750
        failing since 6 days (last pass: v4.19.223-16-ge86e6ad8a5c1, first =
fail: v4.19.223-27-g939eabea13d4)
        2 lines

    2022-01-10T08:12:29.446500  <8>[   21.253112] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2022-01-10T08:12:29.494614  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, w1_bus_master1/115
    2022-01-10T08:12:29.504735  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
cfc [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1
    2022-01-10T08:12:29.526837  <8>[   21.326110] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =20
