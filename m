Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18ECC4A6911
	for <lists+stable@lfdr.de>; Wed,  2 Feb 2022 01:08:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231210AbiBBAIr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Feb 2022 19:08:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230376AbiBBAIq (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Feb 2022 19:08:46 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2225C061714
        for <stable@vger.kernel.org>; Tue,  1 Feb 2022 16:08:46 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id r59so18651369pjg.4
        for <stable@vger.kernel.org>; Tue, 01 Feb 2022 16:08:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=rQvntirxFUQMuSlpArwvugYpl3evnVwcpSsc2DK7TFM=;
        b=3NZ7cR9nj6vo7HXnAlYHdYwokbwE/tmu0UngU2Biw7YWpxJP9B6oQj+W0r5BX78SF0
         uCEfqJREwavwNlqguM2WDENIp2yYS9zDZJqWgLpMwmO1F2lAXh7ke8EDyqTMpoIUciua
         gmbJSI3Zt/vFGAF6q/mMdvWioybtEux2dn86bKN6iJje/JxMPd5QpPSOI2KLAEQ8luCf
         8HklaEqMomDCrWcuAYGJNc4a/bxFSNDRDajhL7kcj5E2j7fZIiyxSqRVwyTj8zpZgDAa
         Sgs0xtMI93oNNaohz91MhE+IxXS3xUT2Pe0ZWQgFyIYwmZbM0RMsWSB9k6Pq+zTnJtXZ
         4ITA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=rQvntirxFUQMuSlpArwvugYpl3evnVwcpSsc2DK7TFM=;
        b=esxn4wmQYe9+SRKnVGmLEcLGVuwuEOdvPahf+SZircMbaJGyV7XMI6plfpGvjzpcOb
         h2gMH/OiUz4VYcxwBgQCWmBZC6CTTXezdFNr5V6ZZea3CfxO/LOi0vkwdAWpV4XHpbOp
         jS2AjtRjon3T7z6vEal6kf5Lk3lCi6Bq6nKoy4IhtjKzcmrd75yUXCBn207oxVV8ZtIy
         Ua/+uX42YAWpAAQ9LEJEziI4tXRYtx6H2erQL06+GmqpjFTOzEKHEvik0Pb4DJGqk6Zq
         6a69yJrUjmED9ycQ003IOQpMjGP8aSF9Di52tdrmUHfvMbCXMuHM3Dy7luRZdR+Ze4H+
         i+NQ==
X-Gm-Message-State: AOAM530HihDyM9GFnhNr8Hr2EWCcB/ItiCMFuzjZmJSEKkF+nhy1otTi
        Sq9sJV8hB0squVOS6NJ1upHTr+YoJ08y58/R
X-Google-Smtp-Source: ABdhPJz6ox0R1NnFZeM+5ooh8Dpp9SWV7g/2oCQzIX8Yt8mnrdy7cLeK+wDfQWL4BqKuynbbTFf0kA==
X-Received: by 2002:a17:902:e5cc:: with SMTP id u12mr27961131plf.21.1643760526008;
        Tue, 01 Feb 2022 16:08:46 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id pi9sm4238244pjb.46.2022.02.01.16.08.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Feb 2022 16:08:45 -0800 (PST)
Message-ID: <61f9cb8d.1c69fb81.3420f.b9b6@mx.google.com>
Date:   Tue, 01 Feb 2022 16:08:45 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.227-45-g388e07a2599d
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/4.19
Subject: stable-rc/queue/4.19 baseline: 140 runs,
 1 regressions (v4.19.227-45-g388e07a2599d)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 140 runs, 1 regressions (v4.19.227-45-g388e0=
7a2599d)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.227-45-g388e07a2599d/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.227-45-g388e07a2599d
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      388e07a2599d4f49bedb7adba1cc3f12d57fa2bb =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61f99403a297d77d195d6efb

  Results:     5 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.227=
-45-g388e07a2599d/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.227=
-45-g388e07a2599d/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61f99403a297d77=
d195d6f01
        new failure (last pass: v4.19.227-45-g1749fce68f74)
        2 lines

    2022-02-01T20:11:34.476659  <8>[   21.014617] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2022-02-01T20:11:34.528970  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/100
    2022-02-01T20:11:34.538324  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
cfc [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =20
