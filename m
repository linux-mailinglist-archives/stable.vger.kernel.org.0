Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D640044C287
	for <lists+stable@lfdr.de>; Wed, 10 Nov 2021 14:54:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231641AbhKJN4x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Nov 2021 08:56:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231607AbhKJN4x (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Nov 2021 08:56:53 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF88CC061764
        for <stable@vger.kernel.org>; Wed, 10 Nov 2021 05:54:05 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id x7so1602059pjn.0
        for <stable@vger.kernel.org>; Wed, 10 Nov 2021 05:54:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=fwoTFa0gB2dc1+UgoVPG1Pa4cmNm8W13/VRB3vVqDAk=;
        b=4fjsTOE76k3xeFnpEztDO5Rv+nz1zTFJihRcR/Mr3T/IPmyzrNC2d3d3JzRoqh71ni
         Fk3RhesUk2PcK56BBx7rCwaygu+SP+Y84r1OoeQhOZMAHQhKTiafBjWJULja9zlRms9V
         A1ywubo7xIfbO0LmFBaaiqkZH4SbYkapxc3nDh5CPPA4P+YZRYLOnHijwaD6dpptvyVh
         5lXO/9UCyHNXCdsxaruKOxgipZELr8M9WclZHlvkbcMwKG+QzDVcRO8fDIeGrSmu9IO6
         q0b++XBMDY/8BvitC0IMs8+bLU/lGNgQKyvdwWDSbwf+7ii87zbN8nGNDuJyFMPb6g6B
         gEnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=fwoTFa0gB2dc1+UgoVPG1Pa4cmNm8W13/VRB3vVqDAk=;
        b=h3suGs7pZwHXNhwlhGXmxPASHIqZccPg0vA1vGVfPNLcqOfbhcps1SCVL/T3r3arXv
         DwkURgzJ8LpoNG/xy1LJlpK39iptfAVc2uC4hqFQZjDlxKROoK0nxLzHq1S0YnYc2NB6
         hrzheuEe0GpOSvZtNsT8uv4ASwgW0d2nw3D8f8Xve+vXYTPuBWbOBBDjWputqgKIE1or
         YUIwHKsdhqKhBPQ7hdy0dKkZO55Xa/3l1Kvj3b3OTzkmXN5mnQEdy5kN0ErG8yQ4ER1l
         oY81LmvoK4PUfNpH8qslQkzi169nJBGbq46pOfxG52xg3dfY01kdPZhpIYoAqyR/TMCU
         9OiA==
X-Gm-Message-State: AOAM533XRPBsIGk8KZJYDHGFf+J0aDYqn/jd1SJ9HPwoB9j629BKYAEB
        mVAsFd2nUkkXdgJz8NdqKI7sCgP0UTgYnxN8
X-Google-Smtp-Source: ABdhPJzWaWS2yZW2v0fMU0AeKyLWqFF/o9A3VE1fnXA5cP3JBp7BQ/wgo4EzWxLULagKY1HKdArF+A==
X-Received: by 2002:a17:90a:cc01:: with SMTP id b1mr44710pju.226.1636552445263;
        Wed, 10 Nov 2021 05:54:05 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id c9sm18025978pgq.58.2021.11.10.05.54.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Nov 2021 05:54:04 -0800 (PST)
Message-ID: <618bcefc.1c69fb81.2c52b.78a8@mx.google.com>
Date:   Wed, 10 Nov 2021 05:54:04 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.4
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.4.291-9-g9556da22fdb2
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.4 baseline: 61 runs,
 1 regressions (v4.4.291-9-g9556da22fdb2)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 baseline: 61 runs, 1 regressions (v4.4.291-9-g9556da22f=
db2)

Regressions Summary
-------------------

platform | arch   | lab        | compiler | defconfig        | regressions
---------+--------+------------+----------+------------------+------------
d2500cc  | x86_64 | lab-clabbe | gcc-10   | x86_64_defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.4/kern=
el/v4.4.291-9-g9556da22fdb2/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.4
  Describe: v4.4.291-9-g9556da22fdb2
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      9556da22fdb29a26ef67b15122f515dcceece041 =



Test Regressions
---------------- =



platform | arch   | lab        | compiler | defconfig        | regressions
---------+--------+------------+----------+------------------+------------
d2500cc  | x86_64 | lab-clabbe | gcc-10   | x86_64_defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/618b956bc06439aecf3358fb

  Results:     3 PASS, 2 FAIL, 1 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.291-9=
-g9556da22fdb2/x86_64/x86_64_defconfig/gcc-10/lab-clabbe/baseline-d2500cc.t=
xt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.291-9=
-g9556da22fdb2/x86_64/x86_64_defconfig/gcc-10/lab-clabbe/baseline-d2500cc.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/618b956bc06439a=
ecf335900
        new failure (last pass: v4.4.291-8-g748a6d994abf)
        1 lines

    2021-11-10T09:48:19.389627  kern  :emerg : do_IRQ: 0.236 No irq handler=
 for vector
    2021-11-10T09:48:19.401087  [   14.234872] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D1>
    2021-11-10T09:48:19.401466  + set +x   =

 =20
