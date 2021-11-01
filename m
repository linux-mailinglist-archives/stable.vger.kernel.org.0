Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFC52441350
	for <lists+stable@lfdr.de>; Mon,  1 Nov 2021 06:55:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229622AbhKAF6B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Nov 2021 01:58:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229528AbhKAF6A (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Nov 2021 01:58:00 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05CB6C061714
        for <stable@vger.kernel.org>; Sun, 31 Oct 2021 22:55:27 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id u33so3342727pfg.8
        for <stable@vger.kernel.org>; Sun, 31 Oct 2021 22:55:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=DnWZ1Q5P2sRX0OknTRsqtiLhZOjDNuguDMPm+40xXqg=;
        b=26IRjn+vUltEItP9rhTlBJMUn5EtkmEVd86f6ZfAl8IvMl+zvi2M9Oh0npH1djnZF6
         xfNZdLYMYsVZniiOF8U9/0sWfkooBnLgLkIzL1zry+NCyiIGjPM5r0pJY95ggEFb/GrR
         Q50MZK7w8luJ+8Q1U/1h7pSn/QbBdMI8/sj8gh0pZHK5mqXEsdQBh7tFCu8kySXA/+dV
         lK15Z0pXWMlS3olq00p1DfMsb0PLYA31nDzqDYsiCxNWBRnc56iP2Y9iV+LASPIISSYi
         fcNo2E+aECRJ502JRcUaeV55BSLrD+r22QNnXnasWmGy592XskZ5dBoq0AWOZfnnlMoY
         JfuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=DnWZ1Q5P2sRX0OknTRsqtiLhZOjDNuguDMPm+40xXqg=;
        b=RZrGoiirnNAM3xctZ4BO03H/RWjAVtgwZ17kjtNiNIrd5ffj7W5rZBvqi1OF/3rTcZ
         znz5moDhSvEhoE3mtoZm95cQEhH61+f5sQjK/9XR26GyYVGHq/+6+7fRf7G3J178u/1a
         0iJIF8PWyiI3dhuVqoPFdh6mpZXmail6isYcQqGjh4+gn8upRyIClV9wU2/XH21nZlcz
         JOsjqLQGH9nPKbLQP34HczHdB83Q7PDJ3Kjhr523nNP2L2+9JcHLmmONNLFDVZuPmoC4
         0kV6cDJcWZb+PrazVpwV8VVbIDigE0CZqPj8elL7wXsWVTZFIeVvKNs22HLpzw1nhmyE
         /OZw==
X-Gm-Message-State: AOAM533QjBUXf3c+Pz3Q2a3lgB1w0e/H34JbfqJi5x1iZNABIclcuxqJ
        6n6km42PFTs/W+NmwPbQ4aSEiW0vK2Kxnl8Y
X-Google-Smtp-Source: ABdhPJw+lS1E2cZvmHXnpvSvnhLHzdhWwCMFvzQ5SD6ixGFhfOKPmGn2YQF1TlHlFgYhQLGVvotaEw==
X-Received: by 2002:a05:6a00:1806:b0:481:1010:c22 with SMTP id y6-20020a056a00180600b0048110100c22mr2823920pfa.32.1635746127356;
        Sun, 31 Oct 2021 22:55:27 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id v14sm14019575pff.199.2021.10.31.22.55.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 31 Oct 2021 22:55:27 -0700 (PDT)
Message-ID: <617f814f.1c69fb81.ad78a.87e2@mx.google.com>
Date:   Sun, 31 Oct 2021 22:55:27 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.9
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.9.288-20-g7720b834ad25
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.9 baseline: 33 runs,
 1 regressions (v4.9.288-20-g7720b834ad25)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 33 runs, 1 regressions (v4.9.288-20-g7720b834=
ad25)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.288-20-g7720b834ad25/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.288-20-g7720b834ad25
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      7720b834ad250d689e28ee483d7192fba662e989 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/617f4df055123d61f23358fc

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.288-2=
0-g7720b834ad25/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.288-2=
0-g7720b834ad25/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/617f4df055123d6=
1f23358ff
        new failure (last pass: v4.9.288-20-g1a0db32ed119)
        2 lines

    2021-11-01T02:15:50.579850  [   20.300384] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-11-01T02:15:50.623391  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/127
    2021-11-01T02:15:50.632392  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
230 [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
