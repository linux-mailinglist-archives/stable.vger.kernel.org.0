Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80DF84C214C
	for <lists+stable@lfdr.de>; Thu, 24 Feb 2022 02:49:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229752AbiBXBo1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Feb 2022 20:44:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229731AbiBXBoY (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Feb 2022 20:44:24 -0500
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1396FFF96
        for <stable@vger.kernel.org>; Wed, 23 Feb 2022 17:43:55 -0800 (PST)
Received: by mail-pl1-x62c.google.com with SMTP id m11so398330pls.5
        for <stable@vger.kernel.org>; Wed, 23 Feb 2022 17:43:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=4CoSr6yH2LpJW03CsFJ//6lig/j96V/AGMPeqKZV+o4=;
        b=TJJp24OYAxDTmDYS4z+wsO7JqxZy22e7PvUOMJgSUMtfifvOQ6P9YDwvqpW5cCVxGW
         MLEIfuypfDaRZ2vuj0emVszja/hU5zzUT7DZh9L/l57VCFlYyyS7515P262m4FLDOVIJ
         J1Lw7XpyPLDP07o8OH8dDJ4KQGYQsCesI43J7to1NsWTcB8Bvyw7yFuULI5mJcroaEh2
         3+Iy6H65S4jj4MZ1E97H1KuHSs157mPyxEfgv8fMdldDJDcD1uxQEqAgHqW61SKvKDaJ
         d9BPmoAHwDu4RK5RKzvyoD6KHj9Wv9Nq1IyzSijRt8GO1ni7j5ZC6B7XuXaZbxJEsc+g
         qAzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=4CoSr6yH2LpJW03CsFJ//6lig/j96V/AGMPeqKZV+o4=;
        b=OwEwNc+G7HjFVbDqdpyx2rrg6ZUmdcoHoNlcqusnKl+v5ZZMqeg66iG6gl5nJiBJdT
         gzWpvCzFzgd9Tn/W8pelBQ0Ep1ppmzDcfwDEskJ5UHTtyHUmzherix7/q/ZiHAPDRFOW
         +r7U4UP513NmFYTeJeqHg3pvrCraTP01mhZ3y5WPsgUJEISxGGU4jkaQJdwVXUccHZkk
         Yg3tGQBbAaee06O3U/NXfDNYBfPS8dkis4selWbLD/lQwV18bDmbde+joyFdZBlR6EPs
         sapeSDH1qzw014VNJx6IIJGbdKk/c3dN3zTMtppbyO0QmIL1r+hF2qFjRJd6q9zMtSlk
         v0wA==
X-Gm-Message-State: AOAM533ImOvxY7vwWuj9cDw93O5F1jcxYi26DUf8B8PUfGhGd9wDPhEO
        sH/rZ16OLJVnu4Rxmj/SRXQceg1zPy7tuoJVPac=
X-Google-Smtp-Source: ABdhPJyna26BVHfXemBAUr3D7XXCT+zrgYWrE3HTPRGs8LF+XSvjhtm0iKbowKpX1nXWnUy1h9prUA==
X-Received: by 2002:a17:90a:5802:b0:1b8:b737:a62b with SMTP id h2-20020a17090a580200b001b8b737a62bmr12212287pji.123.1645667035126;
        Wed, 23 Feb 2022 17:43:55 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id e20-20020a17090ab39400b001bc4f9ad3cbsm4128426pjr.3.2022.02.23.17.43.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Feb 2022 17:43:54 -0800 (PST)
Message-ID: <6216e2da.1c69fb81.60614.b22d@mx.google.com>
Date:   Wed, 23 Feb 2022 17:43:54 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Kernel: v4.9.303
Subject: stable-rc/linux-4.9.y baseline: 62 runs, 1 regressions (v4.9.303)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y baseline: 62 runs, 1 regressions (v4.9.303)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.9.y/kern=
el/v4.9.303/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.9.y
  Describe: v4.9.303
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      9279031d74f8fe8760ce32ac527bc4658b578926 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/6216a8a77b310c9db2c629b0

  Results:     4 PASS, 1 FAIL, 2 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.303=
/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.303=
/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220218.1/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/6216a8a77b310c9=
db2c629b3
        failing since 6 days (last pass: v4.9.301-35-g133617288e03, first f=
ail: v4.9.302)
        2 lines

    2022-02-23T21:35:19.836952  [   20.367553] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2022-02-23T21:35:19.880548  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/128
    2022-02-23T21:35:19.889768  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
230 [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
