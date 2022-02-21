Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9ACA24BEAEE
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 20:37:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229510AbiBUTgj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 14:36:39 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:54996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229927AbiBUTgi (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 14:36:38 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3062A2250E
        for <stable@vger.kernel.org>; Mon, 21 Feb 2022 11:36:14 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id qe15so16095752pjb.3
        for <stable@vger.kernel.org>; Mon, 21 Feb 2022 11:36:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=vEMHRYcbo1fWGU5Gd0fl4PzUB9u32QTAYA6VBZQRizg=;
        b=BFS9H7uh0VFzzR7gAiwJDDDonXrB08YG2f2FLrBdDUiOC3jGTy5LHxaLoyayqYp7rt
         yyEf7ltVqkoPEPrOO1fSswkjgWl3zwf4HtK0HNQybMUcpy1Z/66IhFxoX5EUvVNsm9AB
         zF5L8GFq5R6xg6p9H+wbFzARF6x/eal8ksaAa4b1FvX3UX65p4cJlPqk16WClh2N8/dd
         MMxgeVOUElcjl802ba7tEu2SbcLS7EHV6fmOfQ/55YacHpQvXhamO/pkCBfVW2IE0Uxt
         d4h+/qDExGpSDdEESKgEoGpn+iM3PLt3+ajGHdP0CbbONuxjOx1EzWwsO0phSt3iF5L/
         RR9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=vEMHRYcbo1fWGU5Gd0fl4PzUB9u32QTAYA6VBZQRizg=;
        b=x+lONXvtKsSrthzeAF8eJzoYjzz1/TYD4sS5Os85bcMoBmAu9lf06LZPfcWDh/9E0S
         NXpGmiPuejbpDG+JRhH8oEUmsrIWwXoThUBtsVBmK4k0OvAtxTp29ft0jtGGBr0bokW5
         182CPNuYhySUvUu0xIxCjrjvmo+hQO8RpD+D2AYX5cEM/3w/1npTmexRHbBFgN15zsee
         Q5owCRRKRjPAq/ZuVI6qq5Rm2toEI0EiI2ki3iFgweu2xiiUuUSltS5W+ubZKJ5OP7gm
         W2w7LaJPqOUDYDrPELqno32ZZrSJnfRTYhXQp60nCJjKGxBMmis6kyO1Xq7VUr+nWJVP
         JjhQ==
X-Gm-Message-State: AOAM5335YK51qXobdUwDC4HaJ1nw0vZfYqx1+7bFOKKi7lB4ketOU23h
        80wO4R/YZDAPca3ZqHCvTBI561G/e3lcsAUD
X-Google-Smtp-Source: ABdhPJyfbJzINI36cGFOwU/5+zgBhMWUeUHnO/5IkOpgT+1xEukHEk0Dq6SznX6ubHZ4p3zuliQ4fw==
X-Received: by 2002:a17:902:8a8a:b0:14d:bd69:e797 with SMTP id p10-20020a1709028a8a00b0014dbd69e797mr20487232plo.49.1645472173540;
        Mon, 21 Feb 2022 11:36:13 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id f17sm10529599pfj.125.2022.02.21.11.36.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Feb 2022 11:36:13 -0800 (PST)
Message-ID: <6213e9ad.1c69fb81.116b9.bdc8@mx.google.com>
Date:   Mon, 21 Feb 2022 11:36:13 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.14
X-Kernelci-Kernel: v4.14.267-45-g8a4a724f33d5
Subject: stable-rc/queue/4.14 baseline: 36 runs,
 1 regressions (v4.14.267-45-g8a4a724f33d5)
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

stable-rc/queue/4.14 baseline: 36 runs, 1 regressions (v4.14.267-45-g8a4a72=
4f33d5)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.267-45-g8a4a724f33d5/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.267-45-g8a4a724f33d5
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      8a4a724f33d533e71811016c239ddb11b971dfab =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/6213b70639c8286b5bc62968

  Results:     4 PASS, 1 FAIL, 2 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.267=
-45-g8a4a724f33d5/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.267=
-45-g8a4a724f33d5/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220218.1/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/6213b70639c8286=
b5bc6296b
        failing since 3 days (last pass: v4.14.267-16-g29c6a7cc89b2, first =
fail: v4.14.267-19-g5de9d8e4b432)
        2 lines

    2022-02-21T15:59:55.107758  [   20.714233] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2022-02-21T15:59:55.149918  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/97
    2022-02-21T15:59:55.159144  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
d3c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
