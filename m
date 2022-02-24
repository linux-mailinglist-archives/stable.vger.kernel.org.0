Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2D704C205A
	for <lists+stable@lfdr.de>; Thu, 24 Feb 2022 01:04:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245112AbiBXAEc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Feb 2022 19:04:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233871AbiBXAEb (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Feb 2022 19:04:31 -0500
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6638E58380
        for <stable@vger.kernel.org>; Wed, 23 Feb 2022 16:04:02 -0800 (PST)
Received: by mail-pl1-x62a.google.com with SMTP id e13so243885plh.3
        for <stable@vger.kernel.org>; Wed, 23 Feb 2022 16:04:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=YJRQq53dX9mSdvhitN3M8ocn1AmXGlk2KDjnh4pjEjE=;
        b=EE4pFXDKi0ZdOBI6NtI2I3BiEOpWwBvL+p3JiwfwM5j2aANTgbMExtklEZHu8EDoHa
         ykOjldF+U3uJolNQ67WmAyCDucCpm+o6teh7++pD85KgP6Sz+z/xekp9XyX9m2eQvTkq
         PNVhtMy4tQrab80Ph8+1QK/R1YXNvAhIEf9MJO7AK+3L5Q5K9KTOCs4JENklDLSRpw3p
         0frA/2JcB3HIAh/TDvVvmCE5BYOJThjW1PwA8GJbJCjNJfIqQ+BwKZts3D/lVgoBEQZ/
         dmTCAbs0D7g09q9W8lJ4wfBX6HKkqP8VPcJu7gUk+6Cs0PJLZ0jY6YV3VuvgdR5GZ5tz
         yKpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=YJRQq53dX9mSdvhitN3M8ocn1AmXGlk2KDjnh4pjEjE=;
        b=o4OgRjGVMLJqKE5ATD7w7oz8txUD3Vveaz1oxQQeQeOGT3d0YLeKrG6dx4hUnraSlr
         iN9uovXJF+6WaCLac1LHapbz7n4mrY0qD0cJ07vvueIhMyY/lgik1kT0NHYjga/6U0WD
         6AqiwMSTbJf0GznubQOutEL6ZnwQuEEwiU4M/HLet7fi7xkYcjwM0BMW6V2hP+/a4EDc
         oj8/TZj2VZL8Mfdwlsc67gq7iS4WsOjDuFZvoxfQVd57EcavzSj8tu8CKHUxtshG9tAp
         SyH61uErkTCwo4T1iIDDTIF4C35+FGdoJiM/8QXmE4nH013IXQ6jV4a1dPuBFKEoMocm
         EbGw==
X-Gm-Message-State: AOAM532FAcZ/nqAJXrlNZWaUMXNPUpoy2nJ1B3Mwpnjg3J9zMhDRIeQK
        u6p6mlN0GCK98vOycX7dw/Orpp0RneA6AfMKQJM=
X-Google-Smtp-Source: ABdhPJwlInmki5i9AuVRpO5AmSUxpVYtjlXRvF3XHqX4GQ4PO3ImHvBf/jmBVU/X7EjYKYkvj78+KA==
X-Received: by 2002:a17:903:18e:b0:14d:d208:58d3 with SMTP id z14-20020a170903018e00b0014dd20858d3mr88308plg.57.1645661041608;
        Wed, 23 Feb 2022 16:04:01 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id j7sm717199pfc.144.2022.02.23.16.04.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Feb 2022 16:04:01 -0800 (PST)
Message-ID: <6216cb71.1c69fb81.1379e.2ec9@mx.google.com>
Date:   Wed, 23 Feb 2022 16:04:01 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Kernel: v4.9.303
Subject: stable/linux-4.9.y baseline: 58 runs, 1 regressions (v4.9.303)
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

stable/linux-4.9.y baseline: 58 runs, 1 regressions (v4.9.303)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable/branch/linux-4.9.y/kernel/=
v4.9.303/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-4.9.y
  Describe: v4.9.303
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      9279031d74f8fe8760ce32ac527bc4658b578926 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/621690f5712a431bbcc629a8

  Results:     4 PASS, 1 FAIL, 2 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.9.y/v4.9.303/ar=
m/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.9.y/v4.9.303/ar=
m/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220218.1/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/621690f5712a431=
bbcc629ab
        failing since 25 days (last pass: v4.9.298, first fail: v4.9.299)
        2 lines

    2022-02-23T19:54:17.123392  [   20.315368] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2022-02-23T19:54:17.167152  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/129
    2022-02-23T19:54:17.176686  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
230 [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
