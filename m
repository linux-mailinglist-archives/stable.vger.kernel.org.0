Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01FA9456846
	for <lists+stable@lfdr.de>; Fri, 19 Nov 2021 03:50:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231377AbhKSCxa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Nov 2021 21:53:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230059AbhKSCxa (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Nov 2021 21:53:30 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73990C061574
        for <stable@vger.kernel.org>; Thu, 18 Nov 2021 18:50:28 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id gb13-20020a17090b060d00b001a674e2c4a8so7591646pjb.4
        for <stable@vger.kernel.org>; Thu, 18 Nov 2021 18:50:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=C/c+QeDN+qYBvn6dOZfaeb4E7LHk5I4LLb9PvWI+3vg=;
        b=TpHEwQXy3yZP8mrxJP28rddY0DUWrVrwhKLLsdZslsLhmAQc0x/mx0MGEc1tsedxC+
         draHadxhpn6kEPZx/eq3nA7iK99MRSgyloja2JCCZC7Q59i9ncsHwZRmmBsO4IAR+cYR
         yIX4y4M16v+8p//99IcVbsR7dAQztfI1GlTwfZz17LpFc9iQADLhyvIx8GSlM15JQh8z
         rY+NCF6nTUfQgERFuhEGaKvJ5tO1o8h0nRd1eqJcnsuCPxrpamdVgQpP3Bx2tOrXAlpA
         k0MJDerWQRxWqozCWtVcr6rX7UgtCqkqodJOU08akElfL0EPuxBjZV+FVYaI+pIYv9ZT
         eHUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=C/c+QeDN+qYBvn6dOZfaeb4E7LHk5I4LLb9PvWI+3vg=;
        b=TIbw7Kc6l3EmYsUMnxJ96SXyx54qEKZcNXTsOvgQC2Zj/lv6LwgyTs8mjS2EdkWEL+
         28QyHexgpErXlH5JTk1o/Oak97ozQVpfH/4ibrRlHtUYqqgXMm3ytvxT7RcNLVNAwvU6
         Bt9RhS85gG9Xt3f0gMRBH1NgYvamahlZvHAl1H4VGWUQKjJFOEzRUnJcD/Kb6AUWfRj0
         S+qz0MCL14rtCp29bnnODwZYvJM85TLiIpw4rT6McGd4UKd5uZTxufXtUAE+AgNZKb8i
         +/h97Q6ghpLQAzVZNQwuiMgPzaiwGVCXP037w0Cz5WyS1KccH0ozgLaHlGNmu8H8iSV6
         YXXA==
X-Gm-Message-State: AOAM532/EIH6IZnZXAhKOGBYn8dRvj+Aq0ECJgRt0HOQtkp0yLhKJDsh
        3vZ3aWEO/pVE7zrDCuhCpjz5Ek9JuNWgxqEr
X-Google-Smtp-Source: ABdhPJyKejZeVzC2OZ136Skkkqkgpl0QS5FkaLfE1aMl7Xkrhpe7ik1nKU/NiDz6YvNLVbvY/Ph8kA==
X-Received: by 2002:a17:90a:9291:: with SMTP id n17mr324145pjo.219.1637290227851;
        Thu, 18 Nov 2021 18:50:27 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id nh21sm770452pjb.30.2021.11.18.18.50.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Nov 2021 18:50:27 -0800 (PST)
Message-ID: <619710f3.1c69fb81.c326a.3d7f@mx.google.com>
Date:   Thu, 18 Nov 2021 18:50:27 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.14.255-198-g6c15f0937144
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.14
Subject: stable-rc/queue/4.14 baseline: 121 runs,
 1 regressions (v4.14.255-198-g6c15f0937144)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 121 runs, 1 regressions (v4.14.255-198-g6c15=
f0937144)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.255-198-g6c15f0937144/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.255-198-g6c15f0937144
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      6c15f0937144cebd34374287939dc12854724ba3 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/6196d8234cc2adcba0e551dd

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.255=
-198-g6c15f0937144/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pa=
nda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.255=
-198-g6c15f0937144/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pa=
nda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/6196d8234cc2adc=
ba0e551e3
        new failure (last pass: v4.14.255-198-g2f5db329fc88)
        2 lines

    2021-11-18T22:47:46.065162  [   19.899810] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-11-18T22:47:46.109375  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/102
    2021-11-18T22:47:46.118237  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
d3c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
