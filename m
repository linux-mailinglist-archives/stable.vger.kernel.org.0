Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C16C672070
	for <lists+stable@lfdr.de>; Wed, 18 Jan 2023 16:02:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231571AbjARPCj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Jan 2023 10:02:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231537AbjARPCW (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 Jan 2023 10:02:22 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61C0E37F31
        for <stable@vger.kernel.org>; Wed, 18 Jan 2023 06:59:58 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id o7-20020a17090a0a0700b00226c9b82c3aso2407400pjo.3
        for <stable@vger.kernel.org>; Wed, 18 Jan 2023 06:59:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=MSkwBmI3dDm0bkoJlJBOklDYMKidCF7rJu5HZuWtqgY=;
        b=g0M/lCbpxyRClPCiFEr3807oebGpHLgUal++CamxLGfhKBKkM2q7tV9z5jZ9RWpooA
         SXorMKsuw+7bM/QLBwGE+UkUgwBMdx40GnDGjibNPdLHiYXfqtgS5Eg4E1hK+qtEq2pv
         +WIGOdONVn1XFY/S28YYTINgKnFFh6OSYJXYcIOpT0ZcT7cMLofUZ9RdlMdQmrhpfd7R
         /XP0ji7X2C2wsFI8MY7P6ye78u+Cy164h2y6/Aj2nCAItabEFS/tEThANnRxSwIUA44v
         6vFivElGnWZYpis3A4nyqEEckHkEYce8cykFyXxGepjTDqoPxU1tqZUanax5+MCt+qOC
         xl4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MSkwBmI3dDm0bkoJlJBOklDYMKidCF7rJu5HZuWtqgY=;
        b=RFoVbWLr5AnVQqOh3/ZFa4E5QKcus9ZFEvjDCZvNJ/bL1BPPe75GsOAFKflq7nJIGh
         XsRiklZz6kIPobSOsMy3x152aZ28rvmWLChhmKyLH+YoPyDnhiJp0QVwt5a4JxzAFmNl
         ttOFiH3cNZs/+WMhMD4ViVN+5xvKy06Du3/LjSYqizuoYU+ItoNk6kiMIXJL8gUwSAeF
         UOEgr03+9q5reQo3UIPd5OPKde15CpYEn6kRPvZmyD0dWNwatNJKo3d/nevXgw+kCSId
         w89liR5lbYsAvn34M6OqxLKHwla15N/VKaMRpBHrITST4vkApeRn7pGJXMgZb1V4uRRu
         l4pg==
X-Gm-Message-State: AFqh2krpNtfGZHrD4izBOi3a8kvMjhTbZR9apPS01quEsOXdPbO7tTgu
        ma+/WDynuhXgQbr22BdcV4adLmxU2UMpMc8XUt5MpA==
X-Google-Smtp-Source: AMrXdXv15Qz9A+jm2TSno35F6qci9hWMjclrsNN/vrSJxMtB5nRM0/TiZxfe2oNW1xEhT5tHPNXoLQ==
X-Received: by 2002:a17:902:e88e:b0:192:b2d3:4fc8 with SMTP id w14-20020a170902e88e00b00192b2d34fc8mr9266563plg.1.1674053997440;
        Wed, 18 Jan 2023 06:59:57 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id n20-20020a170902d0d400b00192e1590349sm23089742pln.216.2023.01.18.06.59.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Jan 2023 06:59:57 -0800 (PST)
Message-ID: <63c8096d.170a0220.45799.53ce@mx.google.com>
Date:   Wed, 18 Jan 2023 06:59:57 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.15
X-Kernelci-Kernel: v5.15.87-100-g8dfbf622429a
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.15 baseline: 159 runs,
 1 regressions (v5.15.87-100-g8dfbf622429a)
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

stable-rc/queue/5.15 baseline: 159 runs, 1 regressions (v5.15.87-100-g8dfbf=
622429a)

Regressions Summary
-------------------

platform   | arch | lab          | compiler | defconfig          | regressi=
ons
-----------+------+--------------+----------+--------------------+---------=
---
cubietruck | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.87-100-g8dfbf622429a/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.87-100-g8dfbf622429a
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      8dfbf622429ac88e143eb328365789a2f8cd0bfd =



Test Regressions
---------------- =



platform   | arch | lab          | compiler | defconfig          | regressi=
ons
-----------+------+--------------+----------+--------------------+---------=
---
cubietruck | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/63c7f00af1615b50e8915ebe

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.87-=
100-g8dfbf622429a/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubie=
truck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.87-=
100-g8dfbf622429a/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubie=
truck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230114.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63c7f00af1615b50e8915ec3
        failing since 1 day (last pass: v5.15.82-123-gd03dbdba21ef, first f=
ail: v5.15.87-100-ge215d5ead661)

    2023-01-18T13:11:15.121024  <8>[   10.015457] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3156474_1.5.2.4.1>
    2023-01-18T13:11:15.227951  / # #
    2023-01-18T13:11:15.329670  export SHELL=3D/bin/sh
    2023-01-18T13:11:15.330043  #
    2023-01-18T13:11:15.431375  / # export SHELL=3D/bin/sh. /lava-3156474/e=
nvironment
    2023-01-18T13:11:15.432383  =

    2023-01-18T13:11:15.534150  / # . /lava-3156474/environment/lava-315647=
4/bin/lava-test-runner /lava-3156474/1
    2023-01-18T13:11:15.534944  =

    2023-01-18T13:11:15.541070  / # /lava-3156474/bin/lava-test-runner /lav=
a-3156474/1
    2023-01-18T13:11:15.617856  <3>[   10.513792] Bluetooth: hci0: command =
0x0c03 tx timeout =

    ... (12 line(s) more)  =

 =20
