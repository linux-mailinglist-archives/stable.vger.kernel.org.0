Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0261A438749
	for <lists+stable@lfdr.de>; Sun, 24 Oct 2021 10:03:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230131AbhJXIF4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 24 Oct 2021 04:05:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229527AbhJXIFz (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 24 Oct 2021 04:05:55 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62B0AC061764
        for <stable@vger.kernel.org>; Sun, 24 Oct 2021 01:03:35 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id ls14-20020a17090b350e00b001a00e2251c8so6062126pjb.4
        for <stable@vger.kernel.org>; Sun, 24 Oct 2021 01:03:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=xiEkEw3Nc+9+tKMb8yHX4kzGH+OdscAkBTwsZG6SyxA=;
        b=FmUcO2U6qT0+k1TqRLlVH4x/bMdcRbnmW3yp5D9DjtlBM7MGIGCAM1z+Lwou8zW9zw
         DgYwLsoUvRdcOUrgXDqyZ4G7ZRhZEgs3kgHCg8gBaBWCmA7ya4xlaGv1xACPkhBTmNXu
         3ASr2jXWywBIkAFjYcm59Ue3SpIYWdQrJ6dwINZ4H17fQprGREQYlI8gG9XYd1rZ7I+U
         7CwHoCZv8RFcolNkC7/Gvc1D1fOCD7Ks4kAM4a/CpJoqKJAuHkPEeGRwfmzqO06f0dOW
         v8ceMbn2dr9AYDaP33UruPZEF9wwqMLSkXzXMcitftr34FywzJzI3gqVwed3JO7LCvUE
         uVqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=xiEkEw3Nc+9+tKMb8yHX4kzGH+OdscAkBTwsZG6SyxA=;
        b=kcLnNX2oKnddvxr5qyUL4qzzwvflDPq3FLHpwpv3rTtS/TDrUTXNSkYU0nTd6AkQCu
         F+POPE7ZK3D2Y52Ieo4uqWlONPVI+KkdUXevPEbiCr7XpnSGmwn9q82MrpXZWfHC9Jlx
         lrM7ljtDFypMXNJMfwYym51vO7zcb4EF+BttiCfA33QfKkT8xUtomu4cN712Gy9jMW4y
         Z+wJm0REosm2xqGqYncn1BcU/ZhhVlG6o4H5dr0toZj1SbtinZMIBTcKP+8NVhlvn+I6
         stQSRO4NGnnrELVntBVmUcHkOFr9DTa1FVeVxOlXIMzdtayBAitu++UVO4eOAD9So080
         kZpg==
X-Gm-Message-State: AOAM531I5cs5js/xNAg/M2URu3+7N/yJAO1aMBvuIeRp9tm2vHzldvC9
        VDacFiJ8OdMvGNxSnQYzACzKtJ4A4eTugKT2
X-Google-Smtp-Source: ABdhPJzEcv6Ud1Gb477+saSkvvbYP2ZA80M7Y3u5ZdaKT/iuYb18+JbZPzFfk9nUaHRtriY8d+9a+w==
X-Received: by 2002:a17:90b:4a81:: with SMTP id lp1mr12017802pjb.124.1635062613244;
        Sun, 24 Oct 2021 01:03:33 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id a7sm14850138pfo.32.2021.10.24.01.03.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 24 Oct 2021 01:03:32 -0700 (PDT)
Message-ID: <61751354.1c69fb81.dc684.8265@mx.google.com>
Date:   Sun, 24 Oct 2021 01:03:32 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.19
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.213-11-g617e1deeb1d8
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.19 baseline: 153 runs,
 1 regressions (v4.19.213-11-g617e1deeb1d8)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 153 runs, 1 regressions (v4.19.213-11-g617e1=
deeb1d8)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.213-11-g617e1deeb1d8/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.213-11-g617e1deeb1d8
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      617e1deeb1d8c6223d61b169c3240008963348c1 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/6174dd6771e3adee0a3358f7

  Results:     5 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.213=
-11-g617e1deeb1d8/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.213=
-11-g617e1deeb1d8/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/6174dd6771e3ade=
e0a3358fa
        new failure (last pass: v4.19.213-4-g9e118564b649)
        2 lines

    2021-10-24T04:13:11.500466  <8>[   21.277130] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-10-24T04:13:11.548488  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/101
    2021-10-24T04:13:11.557857  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
cfc [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
