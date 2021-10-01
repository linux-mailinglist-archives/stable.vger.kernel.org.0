Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E31B141E5E3
	for <lists+stable@lfdr.de>; Fri,  1 Oct 2021 03:41:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351413AbhJABn1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Sep 2021 21:43:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351220AbhJABn1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Sep 2021 21:43:27 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50573C06176A
        for <stable@vger.kernel.org>; Thu, 30 Sep 2021 18:41:44 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id y5so5290645pll.3
        for <stable@vger.kernel.org>; Thu, 30 Sep 2021 18:41:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=rC3YF7NGPaH4Ay4Uv3t81/1cUMIrRBCYub2Vtdvsq7U=;
        b=vIVYkeLje3EeKLaGDz99DupOGdZLTmp8P3wSw0kBi0S+gxrPz/TGVZI6s4VAOTP19U
         NBLoB3FctrbkkVwyqJArJ7zSGIwxO9y6xSCCq7wtqXpZPAKTC5+p1HnAa9k0TacwWh5i
         qeblX2/G9Or0gG7u3tQFJYAn+TRNAID1zp5WBml9Q2C8yUUZMwW52oDcFWKkt/0Ve8de
         aU3Kjz3Ph1ABdLAyNLqpnl+2IES1W5u0D1EZo3xq3icMw/f4IU99M/L92Y0Th8p3tpfz
         V8LZ9QrkfPs1qVeJOWfIXGKrdWSD+LtGfCExDsNPgYJ5xyNfswlz5+OnYIagTI+hYXeX
         rWOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=rC3YF7NGPaH4Ay4Uv3t81/1cUMIrRBCYub2Vtdvsq7U=;
        b=B86jtFIOdbd6otGArkGOGMrE+1EnddYQyl318MT98gwmyJORqIv8s1Yk2fNy0oozHw
         wxQ67JRj6ZfGvi/DR9TP8FnnQLxPOMQKrms4vWyNz3OvQBEuEGea7RlIJOcbpK5jmIM9
         +BK2bP2KvjAlT8Y5ZUoUhmBo81s0h1Oqcc2uwq8bUcnJolPwqPDQvPD7pn3zfNpDw6nA
         YVRDBBXeJAKqce8wZg56RI6AcRRgzGGELFpP1WOpscdwBcnBFTJcgrOLICjcb3uje3yJ
         CWYLOLZspcwuXENMS7+zF0PxqViw92t17R8yAyrml90+rwEBb1vqv8ZNVjVf2V7UpXZw
         AwXQ==
X-Gm-Message-State: AOAM533rqTN3ASh7czROVDi8zrL2cyBy5UjVKuaGoRWjZiX0aj5tM842
        p/OFiZfYB7hlMw67wl6NfuQLjIqi2s9F+HIG
X-Google-Smtp-Source: ABdhPJzqA3R1i/iedaZutEwSkCKx3EAvDzxd+tRTZ7czRHM1gWzCfw8BDAMHUP/u7l+P+bWX2SVQjw==
X-Received: by 2002:a17:90b:14d6:: with SMTP id jz22mr9988044pjb.61.1633052503700;
        Thu, 30 Sep 2021 18:41:43 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id k14sm4236289pgg.92.2021.09.30.18.41.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Sep 2021 18:41:43 -0700 (PDT)
Message-ID: <61566757.1c69fb81.9f419.d653@mx.google.com>
Date:   Thu, 30 Sep 2021 18:41:43 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.248-41-g3a7374d64da1
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.14
Subject: stable-rc/queue/4.14 baseline: 90 runs,
 1 regressions (v4.14.248-41-g3a7374d64da1)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 90 runs, 1 regressions (v4.14.248-41-g3a7374=
d64da1)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.248-41-g3a7374d64da1/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.248-41-g3a7374d64da1
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      3a7374d64da1d247765424c082c8c5a36cce6013 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61562ffd206ee26e3199a2ef

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.248=
-41-g3a7374d64da1/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.248=
-41-g3a7374d64da1/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61562ffd206ee26=
e3199a2f5
        new failure (last pass: v4.14.248-41-g21c962756cf5)
        2 lines

    2021-09-30T21:45:15.962178  [   20.805084] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-09-30T21:45:16.006045  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/107
    2021-09-30T21:45:16.014902  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
d34 [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
