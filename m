Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 168614BEBB7
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 21:19:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233570AbiBUUUO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 15:20:14 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:50510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233565AbiBUUUN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 15:20:13 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0B2F17AB1
        for <stable@vger.kernel.org>; Mon, 21 Feb 2022 12:19:49 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id gi6so6620945pjb.1
        for <stable@vger.kernel.org>; Mon, 21 Feb 2022 12:19:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=e4CCOK8FEIG3ZHROCxTCERvSiBqUXVFs5p62Pe/WEsE=;
        b=wdRR8+DaoqLWP/9y755RHdyZ7PUeMF0or2QXIu5cK8ui10ZpdboFJJHUSIjDAXOSVC
         DSjpIdxTBqMJT4Nb62zvNHyVpnz5DQCP9+10Se9eyfvM4vTszrslZIKQ9md1yD3ysDpm
         7tnIhDLxeSNu+CuBLBm1/9mOBqJkTfYpUTQ6IDDQ0OXW+Uy0912tloJF0Kr3sECTQXa9
         ngmqdBUIL/1mqJzUCCSP2umgnVRwKVxhLuDkSA5eU6uJGoy8cgXIrXWhuGAgoyBrl7hH
         Gbgwgua0rkYpqUXcrWEJcuGpO/0lVDNWCAlwzo23lJKa4ZGtomQFNoC4z+F/6NhkcYSD
         6eXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=e4CCOK8FEIG3ZHROCxTCERvSiBqUXVFs5p62Pe/WEsE=;
        b=Oov1FeVWaq5oau0i58vrDg1rdSwYfUW+E4mvVfbM1SyTIPo1eBZHZ4x63Egf4+qbjR
         JDepLnsqx56Mh0eDlqG0W8GnUJmCt9E4GQEljUvjgIYj6LnvL5U6uIptt8q42wpRoRFm
         WbtIiNtz5WIjziRFwPTdvpNeXgZOLRKUaNGoPKQsQs0vLlnaQMPxe/jtIqLRaIDBGMXU
         XdZyhC9TrKoqEj78JRWlSjt+cfsTudMP5BeX1MLk1w4rYqirHBABl0AqjdK6Y6HKSOUw
         8qwmOF8GZrJFCRxbvjbqJTFmMaS6Ks9mHpMlssEH1ZJAutktzTWKU6vlbB+OGpGOJdx1
         tsRA==
X-Gm-Message-State: AOAM531SwNJeo9p67DrS6iKld2WT5A150s+eGOgYhL7qBpE5vBSgDh49
        4dBgkZJ5S3WRMQBaBcrtaAA4wEeDnjt1TC4p
X-Google-Smtp-Source: ABdhPJyyAWWV00EI1BwmSd9HVLsvc8vu1WIJJ6XXFHUCkouh+3+9O4FkEvATErh5wYPpMI5p+BXJ+A==
X-Received: by 2002:a17:902:b185:b0:14f:2d94:184 with SMTP id s5-20020a170902b18500b0014f2d940184mr20244336plr.56.1645474789004;
        Mon, 21 Feb 2022 12:19:49 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id q13sm14332543pfj.44.2022.02.21.12.19.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Feb 2022 12:19:48 -0800 (PST)
Message-ID: <6213f3e4.1c69fb81.5b9e0.7a7e@mx.google.com>
Date:   Mon, 21 Feb 2022 12:19:48 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.9
X-Kernelci-Kernel: v4.9.302-33-g87c80823742f
Subject: stable-rc/queue/4.9 baseline: 59 runs,
 1 regressions (v4.9.302-33-g87c80823742f)
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

stable-rc/queue/4.9 baseline: 59 runs, 1 regressions (v4.9.302-33-g87c80823=
742f)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.302-33-g87c80823742f/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.302-33-g87c80823742f
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      87c80823742f272df28ef6d2695192431b23d311 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/6213b987ab47d92818c62996

  Results:     4 PASS, 1 FAIL, 2 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.302-3=
3-g87c80823742f/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.302-3=
3-g87c80823742f/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220218.1/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/6213b987ab47d92=
818c6299a
        failing since 0 day (last pass: v4.9.302-26-gf49b0aafd7d5, first fa=
il: v4.9.302-28-g96ac67c43b2b)
        2 lines

    2022-02-21T16:10:31.413845  [   20.347503] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2022-02-21T16:10:31.458130  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/122
    2022-02-21T16:10:31.467436  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
230 [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =20
