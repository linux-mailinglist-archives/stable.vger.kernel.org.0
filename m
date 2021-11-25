Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DE0C45D268
	for <lists+stable@lfdr.de>; Thu, 25 Nov 2021 02:19:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245558AbhKYBWR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 20:22:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346230AbhKYBUR (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Nov 2021 20:20:17 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5301CC08EC6E
        for <stable@vger.kernel.org>; Wed, 24 Nov 2021 16:31:41 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id x7so3845559pjn.0
        for <stable@vger.kernel.org>; Wed, 24 Nov 2021 16:31:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=uEnopFvGtT0Qy4Rnz4K/So1SoqSDgOSFIpVETqkPSA4=;
        b=vx427FvkK/Y1pXx/YC+wNL/TTVvhV/0bmhxr1/tcOCPTM7I3IAcAV/Wy7uYAdtusXl
         P4jMnJzqgEI2qykXECHebrZnWflgxUjIJRhDtOmyRs+1NEK3NYrVndjPvZMpwZXiB7nf
         J9sPcVhrGqNoQMi49HHlaUaoNGUcviF3YCzCEFKrC0PFBTTd84w0OpdG6d86G14KHVST
         YamRSihDRghkq3fS8ofuy6jbnlZQTlmdQ4A2tEP6/3YEI8wJyAsoP4JWbnUcnB608wXB
         D9pJLxXIcoqLqzausdnlmK2WnHs29jn3msTp2dHQHai+09qXFufZscr2ziPpeDdE15ii
         l7yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=uEnopFvGtT0Qy4Rnz4K/So1SoqSDgOSFIpVETqkPSA4=;
        b=M0kJENO6wEWHbTLTkw7YRrlioXwPW2H6eNCzYigjbP5mR63ylnSZ+huxv70FUUcjrq
         flmSwWs64QcP74ixLjxnokw8hmHwCBilKEiRPfEo+TBQYcEPmCesD5vrQOR+qlh8oBkX
         h1DTDOEfpSWNYPekSmTAeqPqqcDr5jWmgFJr5TmkVWI5OP2mKdPOgFKbKC5w+vEqxHwn
         sMubnOciISRDs0eH4x4iX9GjY5a7wFkEJC5g2K4wWlcvVhCgfjHZ/z9P+CLYVGHxMajf
         /pPk9rIcYDUAZeVUvxL/sJsaKoLMtTNU0B0g/3UfPgG7nn1bcumAcTR8iS2F1Y28MU1R
         ET/Q==
X-Gm-Message-State: AOAM532JbEgyHseFGuamvD4JZbUqydE0SQgAGukBpTGm3i0kUQlsFZk7
        0bNagsG3YwBuEtozBKB3BdPEnUUObmvOIEVp5Bs=
X-Google-Smtp-Source: ABdhPJzyQJz9EJpdTLx/GHor0DkcjDBUNyDQaa8G4T8YD+aUt5uo+LGKoEaN4zPl0Z7T+d9q5JsvvA==
X-Received: by 2002:a17:902:da8e:b0:141:fa9d:806d with SMTP id j14-20020a170902da8e00b00141fa9d806dmr23956254plx.26.1637800300564;
        Wed, 24 Nov 2021 16:31:40 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id pj12sm6155217pjb.51.2021.11.24.16.31.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Nov 2021 16:31:40 -0800 (PST)
Message-ID: <619ed96c.1c69fb81.2206a.f219@mx.google.com>
Date:   Wed, 24 Nov 2021 16:31:40 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.290-204-g84aaeeeb7ed1
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/4.9
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.9 baseline: 116 runs,
 1 regressions (v4.9.290-204-g84aaeeeb7ed1)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 116 runs, 1 regressions (v4.9.290-204-g84aaee=
eb7ed1)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.290-204-g84aaeeeb7ed1/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.290-204-g84aaeeeb7ed1
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      84aaeeeb7ed1f53cf7ce97cf78a9e495f8a87383 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/619e9f6603e5f922b7f2efc7

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.290-2=
04-g84aaeeeb7ed1/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.290-2=
04-g84aaeeeb7ed1/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/619e9f6603e5f92=
2b7f2efca
        failing since 1 day (last pass: v4.9.290-204-g0f8512aac86d, first f=
ail: v4.9.290-204-g6644175930559)
        2 lines

    2021-11-24T20:23:59.018023  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/122
    2021-11-24T20:23:59.027145  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
230 [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0
    2021-11-24T20:23:59.043039  [   20.132934] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =20
