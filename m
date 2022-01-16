Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9CD448FFA4
	for <lists+stable@lfdr.de>; Mon, 17 Jan 2022 00:25:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233923AbiAPXZZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 16 Jan 2022 18:25:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232895AbiAPXZZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 16 Jan 2022 18:25:25 -0500
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2F0EC061574
        for <stable@vger.kernel.org>; Sun, 16 Jan 2022 15:25:24 -0800 (PST)
Received: by mail-pf1-x42e.google.com with SMTP id p37so8511286pfh.4
        for <stable@vger.kernel.org>; Sun, 16 Jan 2022 15:25:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=mNtYjd49oZOXqjJDw5LTSlMb+yuiIiGfceMzYuTZKec=;
        b=nPp6kvhk9Q/P77x7iKC7h7wi5VZOR3O//bqdevd1pf1T4CohAe0zb9ZjpDdYW0UTmZ
         U7RpsrBY1Xzn0ZpUevj3X/qZXIeCIucy1sv5W8jjyi9Ufw+6zgky7UJqd8bzbq+mewws
         hKpVjYjnIh7q/OIoy2C+Z23/MOl9Wj/C3CnVh5HRLXIHwuVqQvZXVhRMkR9O3CpX9+5u
         BWFcCgeLNTXgjWqDayp6fvk8oPs1QCYljQX1cgFbryUYqYk0RqFdn2151CndqZTus2hb
         d9W71XMgnmyzcGs+6+N6WbU/OU90EzVoyMGNnXmRM9CGzt3oDKKMVhG5ZG1kj5iluHrx
         GJzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=mNtYjd49oZOXqjJDw5LTSlMb+yuiIiGfceMzYuTZKec=;
        b=Jd8baUwowE/IuFISXpI6VHpv2QJ+AkIt/Ac/bmZJOx1stdtB/fappe9TdzhgoCdeT1
         ogV0KaB+T6oqXNnUqQ2eB7SDuatVF4/GcUW+OKzeanWbisgFB3Hcmd7aoqD11YNoJCAi
         R8PcYf56CCKif2Dzk9sPVsh5rG2fizneYIth2/MZRGBu/Pv6H4Arnw2E5D/Xt9cljY7i
         0eVx3h0iBALf/1Jfo+SWtdriN9UMQjdhsN8A77ZKx6b8zF2MyrIaSoGpLQmO1R7cN+Ay
         EnVshsJAywTxMXJZI0xBUULIfAahub2nQhKR7cuWO58KUMZ4xNBnAdRVZkjIXAFU5Bp7
         XVXQ==
X-Gm-Message-State: AOAM533XNQT9XnfKO/Na/uVSKw+4yMszgLJsqmBpWRIhIazsML5x5J8m
        Oec/XOIyce45jypsdelzj/CnX0aG3JALbFSG
X-Google-Smtp-Source: ABdhPJz6IwVZhYZSlZtPyFVztRMgBWS6sOugBk189MYZELAc/T+tpnWMdelrhGirJiPPJdO9dKOEFw==
X-Received: by 2002:a62:5251:0:b0:4bd:bc3a:2f77 with SMTP id g78-20020a625251000000b004bdbc3a2f77mr18779700pfb.3.1642375524120;
        Sun, 16 Jan 2022 15:25:24 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id m12sm2899861pjl.15.2022.01.16.15.25.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 16 Jan 2022 15:25:23 -0800 (PST)
Message-ID: <61e4a963.1c69fb81.c1b4b.8159@mx.google.com>
Date:   Sun, 16 Jan 2022 15:25:23 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.14.262-10-g19825a46b36b
X-Kernelci-Branch: queue/4.14
Subject: stable-rc/queue/4.14 baseline: 145 runs,
 1 regressions (v4.14.262-10-g19825a46b36b)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 145 runs, 1 regressions (v4.14.262-10-g19825=
a46b36b)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.262-10-g19825a46b36b/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.262-10-g19825a46b36b
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      19825a46b36beef007c6332f77bd8a13a53e98d0 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61e472ee3752fed352ef6755

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.262=
-10-g19825a46b36b/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.262=
-10-g19825a46b36b/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61e472ee3752fed=
352ef6758
        failing since 13 days (last pass: v4.14.260-5-g5ba2b1f2b4df, first =
fail: v4.14.260-9-gb7bb5018400c)
        2 lines

    2022-01-16T19:32:40.661584  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/104
    2022-01-16T19:32:40.670742  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
d3c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0
    2022-01-16T19:32:40.686044  [   20.404235] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =20
