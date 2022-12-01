Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBC2263F9C2
	for <lists+stable@lfdr.de>; Thu,  1 Dec 2022 22:24:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229755AbiLAVYG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Dec 2022 16:24:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229623AbiLAVYG (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Dec 2022 16:24:06 -0500
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF125C1BF6
        for <stable@vger.kernel.org>; Thu,  1 Dec 2022 13:24:05 -0800 (PST)
Received: by mail-pl1-x635.google.com with SMTP id y17so2874203plp.3
        for <stable@vger.kernel.org>; Thu, 01 Dec 2022 13:24:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=4HTIXAYNina3mVffaBXsqwf3yv+KdXKcjsyx1AfgihY=;
        b=LRXVkRwrHaE/LwT4qAykceCT31aTfULb2dITZkmRYM9sxpHGqGza1d2f/BJfZSqK1J
         X1ZjCBm7Ks0z20jO2xfFfHHdEx53JpsI1GbY7dPnrzStzXG7F8MGYAj7qMYnJPk9Ripd
         ubL0pLfHgP9GNk4CdDOTykISSkQiSzxL+jGazd49YmRovlRWqUlyttIFoRuz/Yln8Ck0
         cgH8lElJgdfc1VUKlE0HEaIc8oKNjt31nc5SqHdGqIAF8zpfvuNZ31Qzkg6B027euVz+
         Z6JF439ZC6bJHBjRmR8EnikBeG5nHftRMOGrUZpdqYVfd+opdemoC8P1vRHyRCaPF9zv
         QH2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4HTIXAYNina3mVffaBXsqwf3yv+KdXKcjsyx1AfgihY=;
        b=FQFflRjsCP4yzRTf8xY1Pj/UdTDouHjfO6FjYbR//TEqYONn98xH1TrmlbuMJ2sFF4
         6ZddkcX/z3NEE0h4Pn2hDDLc1cvGtXIBumQR8NWPSecvRd35e/AeKgok6DrbMDGnTeCq
         KqbebvMg/IOuBOsxl9DgB4sKVlPfThYgAiK26r1LkoyVnuefuM/JPbI5bcEmlHQM+La2
         dG2lHQaOmlobb66rGBSRx+25FCe9we+eyhfI41LijCZQgk4rb2/TMoT11SSgnqaldsoZ
         HyZFATpoyh0dNDNDV9O/IicjFuygkjrOYQbK813KM18iIemvuvdNAhxvtQduO/TtAQs8
         oR2w==
X-Gm-Message-State: ANoB5plsYt4wwFIKrEqGe/FZVGZ7mls36/6BUfSg9mHRD86T4o7SjIr7
        yP/g4o9bPC3IzI8SOCqcdAHA8iV5zjj3XmScqxs=
X-Google-Smtp-Source: AA0mqf4aE/Jqr9+1S1OjqkhQHIHJCtqEVcZhxXX4tah8Ja5ggVCaqBqTv5vWDu5Zvn7gxXlQxw/STQ==
X-Received: by 2002:a17:90a:de91:b0:219:5f45:7626 with SMTP id n17-20020a17090ade9100b002195f457626mr11916385pjv.119.1669929844924;
        Thu, 01 Dec 2022 13:24:04 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id c126-20020a621c84000000b005629b6a8b53sm3796362pfc.15.2022.12.01.13.24.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Dec 2022 13:24:04 -0800 (PST)
Message-ID: <63891b74.620a0220.e23f.7e33@mx.google.com>
Date:   Thu, 01 Dec 2022 13:24:04 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.10.y
X-Kernelci-Kernel: v5.10.155-309-g64cb1fe918e7
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-5.10.y baseline: 139 runs,
 1 regressions (v5.10.155-309-g64cb1fe918e7)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.10.y baseline: 139 runs, 1 regressions (v5.10.155-309-g64=
cb1fe918e7)

Regressions Summary
-------------------

platform          | arch | lab     | compiler | defconfig          | regres=
sions
------------------+------+---------+----------+--------------------+-------=
-----
r8a7743-iwg20d-q7 | arm  | lab-cip | gcc-10   | shmobile_defconfig | 1     =
     =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.10.y/ker=
nel/v5.10.155-309-g64cb1fe918e7/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.10.y
  Describe: v5.10.155-309-g64cb1fe918e7
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      64cb1fe918e7087e5ba84f25403607cd6ae7404d =



Test Regressions
---------------- =



platform          | arch | lab     | compiler | defconfig          | regres=
sions
------------------+------+---------+----------+--------------------+-------=
-----
r8a7743-iwg20d-q7 | arm  | lab-cip | gcc-10   | shmobile_defconfig | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/6388e62b2c9296f0282abd07

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: shmobile_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
55-309-g64cb1fe918e7/arm/shmobile_defconfig/gcc-10/lab-cip/baseline-r8a7743=
-iwg20d-q7.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
55-309-g64cb1fe918e7/arm/shmobile_defconfig/gcc-10/lab-cip/baseline-r8a7743=
-iwg20d-q7.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221125.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6388e62b2c9296f0282ab=
d08
        failing since 17 days (last pass: v5.10.154, first fail: v5.10.154-=
96-gd59f46a55fcd) =

 =20
