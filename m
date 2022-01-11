Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E01F948B55B
	for <lists+stable@lfdr.de>; Tue, 11 Jan 2022 19:08:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242520AbiAKSIE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Jan 2022 13:08:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242188AbiAKSHF (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Jan 2022 13:07:05 -0500
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82C67C061756
        for <stable@vger.kernel.org>; Tue, 11 Jan 2022 10:06:41 -0800 (PST)
Received: by mail-pl1-x62d.google.com with SMTP id l15so18421649pls.7
        for <stable@vger.kernel.org>; Tue, 11 Jan 2022 10:06:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=s2FekhYHhKBD3328cdrY6cGe8arflUL6vSaTbno1opY=;
        b=XYCXRUfSVeZVo2tAUy5DH3vugy/ckgtF2CGUa5uCcBFmjfGvU+SSd6/yuE2ggFbPzm
         Y5kuyIuSSLEQ4EQMH2QQKJGwZ32xQ6IuWKQ1BtZzwXwSEoAvJlcWRyHp9naToXwv6rnI
         +uMYKvjsjidUTqiO5XWQes+DmZz3rrjFoaWEdhgVd+UBV2cDCoVUCNDqgEpQSNwUws/q
         /nZgKo9M/8G3hnCbub+O7V86LLooM6BIxNzWt6ZnAD0no+SzTTXJ+TNTxIWCqvxPOiqs
         nsbRfE3sh35loKT+QpFsDt28N6hUyzWq8dgJQ3PI3GWL+UnOQzYYKKH4jsqjJ8D8rVtq
         1cLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=s2FekhYHhKBD3328cdrY6cGe8arflUL6vSaTbno1opY=;
        b=e7Nw4LpSTwtXum8OFl5lSU4lb8oeMin+xg7jTT/ANTSX2i/geXtdN8URINKJOUmxpe
         nMBaaki/gExN2t6oN0+mOVeSCCdzYFXdXEI8rbQV1axKu7BC+a92MvW0pP1jFNx5f9ZA
         2tP51vxP+4OFjUhJtEU3qes9mgsY/CWh9auikJkn123vHJcl4eCKJQmMoBzEOm0LlkQq
         C+v8NjFMWqERJC6YVn9wwhO0hI1ws9H+kCUn8+eO8stybbYtoCi+m4/OZwdkI7PppNFR
         7bwjZt5u5BVU9zmIEo8hQK26dVFRZnOTJQ1S3aSVxUR6husKwSAb8qA9BCnxJ11XFD9v
         ykTg==
X-Gm-Message-State: AOAM530TXt+hk48k1QaNqESBHi5RNybzwlGi6v2MHJ5zlBPHRzBLevJQ
        puB4M6jjBhRVbZBQR3xwocNblEccaqKNwAU2
X-Google-Smtp-Source: ABdhPJxNWRMmsbCmOQeOozu4Md1NIUwQg2Lvbde4KJz2jvFpSHows6q2+8rfjGnJEMEbhkxGJSlUXA==
X-Received: by 2002:a17:902:b206:b0:149:3b5d:2b8b with SMTP id t6-20020a170902b20600b001493b5d2b8bmr5401076plr.162.1641924400915;
        Tue, 11 Jan 2022 10:06:40 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id m17sm2311951pfk.59.2022.01.11.10.06.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Jan 2022 10:06:40 -0800 (PST)
Message-ID: <61ddc730.1c69fb81.ccfa8.48ce@mx.google.com>
Date:   Tue, 11 Jan 2022 10:06:40 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.14.261-22-g2ac5503b0df0
X-Kernelci-Branch: queue/4.14
Subject: stable-rc/queue/4.14 baseline: 153 runs,
 2 regressions (v4.14.261-22-g2ac5503b0df0)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 153 runs, 2 regressions (v4.14.261-22-g2ac55=
03b0df0)

Regressions Summary
-------------------

platform    | arch | lab           | compiler | defconfig           | regre=
ssions
------------+------+---------------+----------+---------------------+------=
------
i945gsex-qs | i386 | lab-clabbe    | gcc-10   | i386_defconfig      | 1    =
      =

panda       | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1    =
      =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.261-22-g2ac5503b0df0/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.261-22-g2ac5503b0df0
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      2ac5503b0df0317675fdcffd4ea8f0bc7ad5982b =



Test Regressions
---------------- =



platform    | arch | lab           | compiler | defconfig           | regre=
ssions
------------+------+---------------+----------+---------------------+------=
------
i945gsex-qs | i386 | lab-clabbe    | gcc-10   | i386_defconfig      | 1    =
      =


  Details:     https://kernelci.org/test/plan/id/61dd943668290e209cef673d

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.261=
-22-g2ac5503b0df0/i386/i386_defconfig/gcc-10/lab-clabbe/baseline-i945gsex-q=
s.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.261=
-22-g2ac5503b0df0/i386/i386_defconfig/gcc-10/lab-clabbe/baseline-i945gsex-q=
s.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/x86/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61dd943668290e2=
09cef6742
        new failure (last pass: v4.14.261-22-g21eed7b761de)
        1 lines

    2022-01-11T14:28:49.059666  kern  :emerg : do_IRQ: 0.236 No irq handler=
 for vector
    2022-01-11T14:28:49.068724  [   12.244915] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D1>   =

 =



platform    | arch | lab           | compiler | defconfig           | regre=
ssions
------------+------+---------------+----------+---------------------+------=
------
panda       | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1    =
      =


  Details:     https://kernelci.org/test/plan/id/61dd95a2619d51e139ef6740

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.261=
-22-g2ac5503b0df0/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.261=
-22-g2ac5503b0df0/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61dd95a2619d51e=
139ef6743
        failing since 8 days (last pass: v4.14.260-5-g5ba2b1f2b4df, first f=
ail: v4.14.260-9-gb7bb5018400c)
        2 lines

    2022-01-11T14:34:57.533113  [   20.114654] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2022-01-11T14:34:57.571983  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/101
    2022-01-11T14:34:57.582686  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
d3c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
