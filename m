Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4EC884A86AE
	for <lists+stable@lfdr.de>; Thu,  3 Feb 2022 15:37:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233339AbiBCOhc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Feb 2022 09:37:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238732AbiBCOgy (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Feb 2022 09:36:54 -0500
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B349C06173E
        for <stable@vger.kernel.org>; Thu,  3 Feb 2022 06:36:54 -0800 (PST)
Received: by mail-pl1-x629.google.com with SMTP id c3so2295410pls.5
        for <stable@vger.kernel.org>; Thu, 03 Feb 2022 06:36:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Dywlz/mQ0oMsbcXLe9dwrNhE76ikzUdJf9NSFvua+TU=;
        b=od0IOi+0BQ9mld/QDPBzovY3Z1Y1rC3omOM0kZEjDNR3RrbSFpH+PSAucaz87Pitnz
         sdoZ04IV7aj8kewTl0i9Fo34wjbULpmZVAnYVFj+oXINbOWHwlTYo6pyzga0GyPHmSa9
         t7ycbmDMRNwmJXJGJ8PoViH4prkEX57xoyg8ynO8NwIyLUV0LaGgUyjmuVaBPV5QJchq
         ZHTkS/mGw49qwWwrNEFOZWApNrAbktwuiiPICEusbDBApO5V2nyF8mlA5J89RhMMxOUF
         vEh1xZMyVrxg7zURQYjD//BCB8MeFUnBbIdFsXOVoQpPdS0mpxmXuFRJbGQMi3oYNV9B
         D3ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Dywlz/mQ0oMsbcXLe9dwrNhE76ikzUdJf9NSFvua+TU=;
        b=m0D1p64gnQCEA9rIQmW41Q2HzBFZtpiGh0/XpIOHOm3qePqiT1xgU1BwuzwhDLohwI
         xSf3R2uyCYHmoBhJlnF6Jvx/pMdYhDdPwq2msCOx5ETTyzZswaPqRgrpeeCQ5XN89V6S
         etlPu+Z5Rf8LjeuopcHMCLpj7uUcu9RzS/+6DU07mFkVbeaEAX04UBQSsVfm8XY1A5Ug
         kmPOkmC7gdz338Rsukpes/fBhZnxr6MfZdiVbfcjSeKo1sgyuWg0IroWcUe2aEBEa5o0
         s+v0/tpjUfvaJitCiRQlIyGoRSgcgolJHww4pA4uN8A1HDyGllWYbDDh8PjwIet9Tqjv
         s7tg==
X-Gm-Message-State: AOAM530UYozziOovVXuTyG+iAOk0FtnGneYCCxypmxSGy+UTzY7CdVq1
        9aAOU/q4o9JnX4r12DbtOrbE17CFjWofqnFa
X-Google-Smtp-Source: ABdhPJxkYgvxqcw4+2Wkuik9SBES4i2MEjvc9Qnf+DB0hA3MN9gN/gqqRfaNbDLIMJ8i8fq145KoZA==
X-Received: by 2002:a17:902:d2d1:: with SMTP id n17mr35523857plc.89.1643899013646;
        Thu, 03 Feb 2022 06:36:53 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id d20sm2985542pfu.9.2022.02.03.06.36.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Feb 2022 06:36:53 -0800 (PST)
Message-ID: <61fbe885.1c69fb81.e4ea4.6480@mx.google.com>
Date:   Thu, 03 Feb 2022 06:36:53 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.4.302
X-Kernelci-Tree: stable
X-Kernelci-Report-Type: test
X-Kernelci-Branch: linux-4.4.y
Subject: stable/linux-4.4.y baseline: 121 runs, 1 regressions (v4.4.302)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.4.y baseline: 121 runs, 1 regressions (v4.4.302)

Regressions Summary
-------------------

platform         | arch | lab     | compiler | defconfig           | regres=
sions
-----------------+------+---------+----------+---------------------+-------=
-----
beaglebone-black | arm  | lab-cip | gcc-10   | omap2plus_defconfig | 1     =
     =


  Details:  https://kernelci.org/test/job/stable/branch/linux-4.4.y/kernel/=
v4.4.302/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-4.4.y
  Describe: v4.4.302
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      a09b2d8f61ea0e9ae735c400399b97966a9418d6 =



Test Regressions
---------------- =



platform         | arch | lab     | compiler | defconfig           | regres=
sions
-----------------+------+---------+----------+---------------------+-------=
-----
beaglebone-black | arm  | lab-cip | gcc-10   | omap2plus_defconfig | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/61fbb5b398b0b9cedf5d6ef8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.4.y/v4.4.302/ar=
m/omap2plus_defconfig/gcc-10/lab-cip/baseline-beaglebone-black.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.4.y/v4.4.302/ar=
m/omap2plus_defconfig/gcc-10/lab-cip/baseline-beaglebone-black.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61fbb5b398b0b9cedf5d6=
ef9
        new failure (last pass: v4.4.301) =

 =20
