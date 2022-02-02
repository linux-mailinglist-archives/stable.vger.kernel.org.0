Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 732804A7BF4
	for <lists+stable@lfdr.de>; Thu,  3 Feb 2022 00:55:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232679AbiBBXyt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Feb 2022 18:54:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348153AbiBBXyt (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Feb 2022 18:54:49 -0500
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89CE1C061714
        for <stable@vger.kernel.org>; Wed,  2 Feb 2022 15:54:48 -0800 (PST)
Received: by mail-pl1-x62e.google.com with SMTP id d1so654951plh.10
        for <stable@vger.kernel.org>; Wed, 02 Feb 2022 15:54:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=1z+YmJTKWwky8f7gZ+UFU+Izr6GWrp+JMrUR/8oRmPI=;
        b=2RvE7i9qXjfKlbQ3M2UxnbJX5gnOjbadtak8J56ooixkIkyJ7JtZQbi4xWhezWhmYt
         PO9+NlYozHBHae7Qgi+InsXLr5ey9ucEHNRQLaEpjLVUILdrULffSWK/KmCRfgzG6Wg5
         CsTR213tW3+Y5+DhdeHAHDMBlylQIJ02WH40TJGVVZpZ//3mJAYI2Vf3V3iRywH9CQlj
         1lbGcn0eeD6IIDNmNcoHzuBOvSZHTfdHhkkQaUptvp3JqFGDUodPzCmA/cmCkHZhc2Zy
         79MynmNORfORe0aSbiVulMC/PltOHhCnbUFxwYqCu6UiBficbxg5M3MRGyOh1zSRWeo/
         mAvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=1z+YmJTKWwky8f7gZ+UFU+Izr6GWrp+JMrUR/8oRmPI=;
        b=U4bdCprZ7rgAdZ6+ULISV3jJrn6t4zA8h9TY8BPrOtKRhm6SF8/7Z3wA1rlKp5XMWP
         T5g1FdBDHMmMd+mnUX4QUhcQNB0b3hgPrZgHzgVVJX1mBOMgzg/468tDQROnH3kQjVnE
         SeHO0E2jkQV2pDkzT+8CcZ249BnTKk4NLPsi+nawmqjfOwvO6xFhkKBnixI2JvbwYgmp
         YAbmAJvKeLQxhBk7n0L7Z6gJJoy7W6EUAqRVNlalnwEqZY0SQGrm3HxrfqfKNbGBYaCA
         YZA0mWlLC9N/6DOLY3LWcZ1OcN6OMZW5gcyiXGsQt3DRWDbz/PEv6IefvnZ7UENB7ynT
         Fsrg==
X-Gm-Message-State: AOAM531gK6YWN6Vw6RXn7ZAyvUF3GABnj4pDWoBoDDIhKdGtGf/LQeAI
        LaXRL9e32nUwwWctsyr+B6jmyrH+QRX2qhDH
X-Google-Smtp-Source: ABdhPJy3WLXbKUwdpsa2UhEEpi+jeKMMQhH84UeVuGbLeOp6gPTlvIa+jEN8xWJnbwVQ3HcFmz6e1g==
X-Received: by 2002:a17:902:f683:: with SMTP id l3mr32593005plg.39.1643846087939;
        Wed, 02 Feb 2022 15:54:47 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id f12sm24181981pgg.35.2022.02.02.15.54.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Feb 2022 15:54:47 -0800 (PST)
Message-ID: <61fb19c7.1c69fb81.523f2.0d15@mx.google.com>
Date:   Wed, 02 Feb 2022 15:54:47 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.299-25-g9408ca1c7f0a
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/4.9
Subject: stable-rc/queue/4.9 baseline: 134 runs,
 1 regressions (v4.9.299-25-g9408ca1c7f0a)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 134 runs, 1 regressions (v4.9.299-25-g9408ca1=
c7f0a)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.299-25-g9408ca1c7f0a/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.299-25-g9408ca1c7f0a
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      9408ca1c7f0a9aabf795acd68f6cad7e3decaf12 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61fae3700c16d8d4cb5d6f09

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.299-2=
5-g9408ca1c7f0a/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.299-2=
5-g9408ca1c7f0a/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61fae3700c16d8d=
4cb5d6f0f
        failing since 1 day (last pass: v4.9.299-13-g3de150ae8483, first fa=
il: v4.9.299-25-g8ae76dc07a67)
        2 lines

    2022-02-02T20:02:37.206274  [   20.130584] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2022-02-02T20:02:37.250101  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/116
    2022-02-02T20:02:37.259550  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
230 [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =20
