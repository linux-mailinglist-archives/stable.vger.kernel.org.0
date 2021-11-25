Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B430945E1DE
	for <lists+stable@lfdr.de>; Thu, 25 Nov 2021 21:56:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242831AbhKYU7y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Nov 2021 15:59:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243150AbhKYU5y (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Nov 2021 15:57:54 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 593CCC0613F2
        for <stable@vger.kernel.org>; Thu, 25 Nov 2021 12:53:00 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id np6-20020a17090b4c4600b001a90b011e06so6539287pjb.5
        for <stable@vger.kernel.org>; Thu, 25 Nov 2021 12:53:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=XxBcQdY2D0QNK3T5ztCmHD1cw3dNsye+YHlm191jkLc=;
        b=F6xIFuQ3e83HzMvlaXjvLvahOEYOy2+/xTOgv3yBLoN/9dUOVck1/wAkI4BM0fIm9A
         kmwR27W1Tc1l+YjFTXWmwJciqWNyAyGttUefYC4p+uV3/udjj2ZRIiIDVHjb7JTD2M0s
         4EnmKSVABVZmMHzrWSDuiXZHkn7fSGkxRp1DCflr2V5uZIGGmvtQKlGncLqlBmeMUuQW
         T6yZzEuWm4+iMAjjTp2ylKCrfwzAYEEW2CBFxAdnJw0+2n2rTiWT1hKQYXmIkJbgc9Yt
         wUTmBo3MDn1mTbnRTlbJCd50DyVQWWjPlRzHKB4Y4Dz4gynGZCWD7pJqo4FJdXcNgpvY
         0+JQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=XxBcQdY2D0QNK3T5ztCmHD1cw3dNsye+YHlm191jkLc=;
        b=vO1GqeLX6shKhtYIauaTME1h+C1jn6nmPyaT/aLJs+H9LydLApqkvQwTwFZLYA0An0
         0aoTQ7beQF+HldUnfkPxymPmsXq8X1aoosv4u1n4kuQpWU4v+0nTgzS8nbnUpD2ns9s+
         kqxKil1SHsSxBSDz61mrKQsaEMsZnE86hXkWdNKihem50MC2yEUKXl7ng8mfxglhF1FC
         p6wWW+EeeKUiamnyG8GZ0VMTCLwnlgB55FPIyLHBTXKLTWMH7l2o9osDCSWTaX25l2w6
         o0i+u750e3WjeMyoolsKLOklJ3oYuk4Ptq+4U/ogYk6YeDd5+uRVSnPJHiODpUaJ2FgT
         KaXQ==
X-Gm-Message-State: AOAM533srDHzr7Gp5SfcQbAMXgKyRw+A+1gMejxZDVrumRsbxaxLFD/E
        bRM+Q3CITEA+zgHzITwHlvwPQuZT5o2fvYLF/hg=
X-Google-Smtp-Source: ABdhPJxoa3onor/obyJ6sr3GYrhGVb18XoGItl5GWBskdbmBHwnOWaBLiv1mRQloW+rclFr1I9053w==
X-Received: by 2002:a17:902:e885:b0:142:1500:d2ba with SMTP id w5-20020a170902e88500b001421500d2bamr33266939plg.19.1637873579786;
        Thu, 25 Nov 2021 12:52:59 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id t3sm5071527pfg.94.2021.11.25.12.52.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Nov 2021 12:52:59 -0800 (PST)
Message-ID: <619ff7ab.1c69fb81.4dbca.d0cb@mx.google.com>
Date:   Thu, 25 Nov 2021 12:52:59 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.290-204-g44e61db84d33
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/4.9
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.9 baseline: 118 runs,
 1 regressions (v4.9.290-204-g44e61db84d33)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 118 runs, 1 regressions (v4.9.290-204-g44e61d=
b84d33)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.290-204-g44e61db84d33/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.290-204-g44e61db84d33
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      44e61db84d33dbcff23a717638e8dc4315c6cda8 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/619fc4713cce7f4387f2efa6

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.290-2=
04-g44e61db84d33/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.290-2=
04-g44e61db84d33/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/619fc4713cce7f4=
387f2efa9
        failing since 0 day (last pass: v4.9.290-204-g18a1d655aad4b, first =
fail: v4.9.290-206-ga3cd15a38615)
        2 lines

    2021-11-25T17:14:05.715361  [   20.058013] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-11-25T17:14:05.764625  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/125
    2021-11-25T17:14:05.774000  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
230 [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =20
