Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3A94489F56
	for <lists+stable@lfdr.de>; Mon, 10 Jan 2022 19:38:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241421AbiAJSir (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Jan 2022 13:38:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238734AbiAJSir (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Jan 2022 13:38:47 -0500
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D284C06173F
        for <stable@vger.kernel.org>; Mon, 10 Jan 2022 10:38:47 -0800 (PST)
Received: by mail-pl1-x62f.google.com with SMTP id z3so13259113plg.8
        for <stable@vger.kernel.org>; Mon, 10 Jan 2022 10:38:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=EswMbeiRZDu8+tLg++NfWYisElt/1RYbyiHE2/15diA=;
        b=PKzMIqOutfLrE88vVdrGlt2oD9exXIyXpqtyJaZ8ms+7kb0SZTkwFGQp99KeGqzGbO
         TrwgPI9Ihh194tJMSH5koclNsv0UXIukAwyB/Zg5WrL99JieFwos+Qn4xZp8QA4peDS7
         eT6M4RqyY/MFxQ7obOJeCEkM66EA1f9anY3mIEqLfao8TvLj1fTmwWvDakGIU5S6UyQ+
         XKeGSFK4QY+AX+OLU7q6R7g7gS3XXvyPLGTELzK1vPFEdKND7dxqTCc4vM7gwbvdKB4G
         VaYrw3SIp2MTV9d2KrCsNB62xzaMkc7SaXqtHDvpdEn/qqHFaHl0kU3VogtrgA+9szQz
         B4eQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=EswMbeiRZDu8+tLg++NfWYisElt/1RYbyiHE2/15diA=;
        b=WFGA3ry8VdjF9Pv6diNPgDmGxmmkqAp+pSy5h6A0CEzdCKYBUL/2wTrN+p4IxF+Hen
         ZEArojzj1y+/B0xiIQm3kR887cU1/AHJ3gRpbSj16ohi35TmIcKCuHkkGrlZ2btJHNUM
         XpUJRANKlIBgwqhRtPQTRi3mipjyv+g/ooF+F/CD8TWJ3EHV9/RIlobdc6R5116fj2VI
         PmjJ3kV2OMUIoxzYrjVVzZH92brs5yhcXhJFB2rTEqBUeu+tJ8oNHqUaNLSpwxCWrXkp
         h5/aTAoDDhXbs/PytB1ReBeQPoq1D4bo5eyYH8y3ZmeqL4p8d2M7ml8BxHDKULjC+HRG
         dHMQ==
X-Gm-Message-State: AOAM530NiUHp3uFG6HlylUoe2GNhVcnFvJUXFKiRi76UKnla+szTOuGH
        zTOUVZPgBlVUtHn2s3KpWjmB/IpHKqb2jEyL
X-Google-Smtp-Source: ABdhPJxbe6IsCYQ2JYvh++mKrkvMgWc38BJ32wGlrV7gaP9AXRUitvqW0TRLXYm6x43HIGsRnkctdg==
X-Received: by 2002:a17:902:7105:b0:149:e08a:b31b with SMTP id a5-20020a170902710500b00149e08ab31bmr896500pll.171.1641839926624;
        Mon, 10 Jan 2022 10:38:46 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id j8sm8260438pfc.11.2022.01.10.10.38.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Jan 2022 10:38:46 -0800 (PST)
Message-ID: <61dc7d36.1c69fb81.db4ee.397d@mx.google.com>
Date:   Mon, 10 Jan 2022 10:38:46 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.9.296-22-g166c7a334704
X-Kernelci-Branch: linux-4.9.y
Subject: stable-rc/linux-4.9.y baseline: 103 runs,
 1 regressions (v4.9.296-22-g166c7a334704)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y baseline: 103 runs, 1 regressions (v4.9.296-22-g166c7=
a334704)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.9.y/kern=
el/v4.9.296-22-g166c7a334704/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.9.y
  Describe: v4.9.296-22-g166c7a334704
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      166c7a334704473e72e891612b8ffa513e43754d =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61dc48f4a939d87738ef673d

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.296=
-22-g166c7a334704/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.296=
-22-g166c7a334704/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61dc48f4a939d87=
738ef6740
        failing since 7 days (last pass: v4.9.295, first fail: v4.9.295-14-=
g584e15b1cb05)
        2 lines

    2022-01-10T14:55:31.101127  [   19.993041] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2022-01-10T14:55:31.146579  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/125
    2022-01-10T14:55:31.155643  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
230 [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
