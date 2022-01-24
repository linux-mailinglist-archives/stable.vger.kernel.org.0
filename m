Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AB63499DA6
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 00:00:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1585929AbiAXWZW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 17:25:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1584559AbiAXWVZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 17:21:25 -0500
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 479B7C0424D4
        for <stable@vger.kernel.org>; Mon, 24 Jan 2022 12:50:33 -0800 (PST)
Received: by mail-pl1-x634.google.com with SMTP id d18so4338218plg.2
        for <stable@vger.kernel.org>; Mon, 24 Jan 2022 12:50:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=QAGAhC+PsM9b4wej+RFbTgm14JSzkBrBcVHkaFzgBRI=;
        b=qKbH4DrCdGl9k9Z6UBpwOFA8yKjUxXyGEFiy7QXTTFaT3VlmI9cmIoU4SUhUaowZyb
         ujR9QFzOMJ68+1NkGuZcd3LLxF6ghcrhxgZ4Sr2KKA7f8JZ0L0joiwqDyxw1TyEDilzp
         1Kj1o5aV5O3Nx2PFN6A+wQcvwoKhN40oQ4TdayK5YqZe8aQagt7bi4JHvE0pr6RMQem1
         U0q/he46FqlGVjU7uH7oTali4nArAeNBMLWbRWm0X1+sBMluQcZGwugFCUZ9QY5bbP9f
         imF/hIGh9YN9UCQexx/7oY+zPRsORUBTlKZr2hL7JQwCrGP3L7aKPZ5NavqfhutH+KuU
         B/Wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=QAGAhC+PsM9b4wej+RFbTgm14JSzkBrBcVHkaFzgBRI=;
        b=a+X1uR00iJJEmHuYiQlUee6vfV6o0mqL0xKxlPaixikLBEATRjTS8+4uySOyocjiWn
         UlakPtmdLl4/URpGhbuRNp3VurZ/oYtGpdbx638GDPrGZpImfjZtadV5ytRbIQQHlRUh
         1MS+Xcc0wpBgHz6rjif6WXJa6rWdsMhalXAL9L7VPCRnnc68SdbshFAxAkxP9KV/VU+W
         PGlts4cwdnImANeBrPy6GUrnERrU8ttV2jlEZf6FY0LjSAHwQpV624IQX+7sFhXDtgkZ
         DISQrkFiPtKzdV2sRo2oXiiroVeUePVSkQQlRP9inWvTexHkNd8YyT2Bvr9ZayZ6lzTS
         l32Q==
X-Gm-Message-State: AOAM5316d5HQ9+a9v3xwlLuc5BqBePgrg7/Jj6Q04H4qk/UK8RXIvzu7
        Z4x01+LPb/4zs+1TTxmGKatMvJ9lnItWCOiT
X-Google-Smtp-Source: ABdhPJwiyc4joB8yQQXouZS+swlysbvOU0iGtU2Ss8PviERYzm/MmCHq4Mef8HylRcPHvYUligsozg==
X-Received: by 2002:a17:902:f54b:b0:14b:5099:9063 with SMTP id h11-20020a170902f54b00b0014b50999063mr5965779plf.86.1643057432663;
        Mon, 24 Jan 2022 12:50:32 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 16sm13570720pgo.24.2022.01.24.12.50.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Jan 2022 12:50:32 -0800 (PST)
Message-ID: <61ef1118.1c69fb81.df62.5aad@mx.google.com>
Date:   Mon, 24 Jan 2022 12:50:32 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.14.262-185-g3be22c071889
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.14.y
Subject: stable-rc/linux-4.14.y baseline: 134 runs,
 1 regressions (v4.14.262-185-g3be22c071889)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y baseline: 134 runs, 1 regressions (v4.14.262-185-g3b=
e22c071889)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.14.y/ker=
nel/v4.14.262-185-g3be22c071889/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.14.y
  Describe: v4.14.262-185-g3be22c071889
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      3be22c0718896b2581787b25fe775671707ac3a2 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61eedce496bd22996babbd20

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
62-185-g3be22c071889/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-=
panda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
62-185-g3be22c071889/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-=
panda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61eedce496bd229=
96babbd26
        failing since 10 days (last pass: v4.14.262, first fail: v4.14.262-=
9-gcd595a3cc321)
        2 lines

    2022-01-24T17:07:30.916854  [   20.164367] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2022-01-24T17:07:30.958434  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, mmcqd/0/60
    2022-01-24T17:07:30.968310  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
d3c [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =20
