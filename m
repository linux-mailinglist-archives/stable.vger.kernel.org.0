Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAA1737EDB5
	for <lists+stable@lfdr.de>; Thu, 13 May 2021 00:43:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387978AbhELUlZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 16:41:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235666AbhELUN2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 May 2021 16:13:28 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AD4DC0613ED
        for <stable@vger.kernel.org>; Wed, 12 May 2021 13:06:13 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id c21so19066117pgg.3
        for <stable@vger.kernel.org>; Wed, 12 May 2021 13:06:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=B63/a8c1VKWIkpuekC+oBo3j32sltZAobQq9YUpMTwY=;
        b=A7HsfBZ0mqNPQfo5917YGj/OeWGfe446vVQL9X18EeeKyFaVPeUe1ulfgIPW8F5T4X
         MvzdxVwqCKWoN840PZjUIz5tP+Lg/zlGPOoEWjGGFgYMU+eZVkAT0ac15btDmjXDpBpG
         niSTvOlPV8zSKiYCWh9BHSdmPJoZI7lehEo3L+mnKQCI0Th3geyA+eqSYwaNdZ+ynfuQ
         iDFwTy6hLrd6iEt3EmQzwXa1r5aRpjvDF+PM3aiMUsZWIGYOTXGKmRj5nJHhpYtcbqiZ
         iDgZWf+9I6MXgrO+aniI6A+xlc0MTIQFrfk8a+hvmsUZvv4VWg/zJoQBCHquYNaezs+A
         Kv7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=B63/a8c1VKWIkpuekC+oBo3j32sltZAobQq9YUpMTwY=;
        b=c+ESY6GMwS2RHC6yPfdPV9u1cNzLg6sOuuVWCOpC1otKWqrYzxfVUggtvCxd14qzc9
         qyu22LlI/He+O/IZ3gx50EJhKgrSi1f8Er3tVFzS4gpc8XDYeLCB+MOaUTZzpsDvqcjm
         TyyMNwHsoiaV83R1GjTzGGQwOMl4YuSZeKGwCx6Z2z6KegWtM9iOPv4Ou6d9QcZj3jNd
         lU97/XlwfUIJz7wR8oczFdNvP52R/kg4sV9FVNF/YawViVile6B0Su8hHu7ZMHponmNp
         QR+f3vIZy0VI8VSCrB9wcKTqiQVMwLX8jXD2I5ox6NPeUdxhIiHv866TLLxSHLRthWJ0
         hudw==
X-Gm-Message-State: AOAM533an7KHOHMCoGG0i+6oxsPmgutKWnWbk7PTcX+SbmFe6RbE6VSI
        7PDqTLG+Vd7R7+FdRwrXLNua152IiV38Tb4Z
X-Google-Smtp-Source: ABdhPJxc7kefFpuruBZW6a4/+/a9IY+fmuoVNGKIc9vxoZrDZaX7I9jS8YtDkujaeUuAnK6utrkY/w==
X-Received: by 2002:a17:90b:4c0f:: with SMTP id na15mr243224pjb.150.1620849972402;
        Wed, 12 May 2021 13:06:12 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 80sm545937pgc.23.2021.05.12.13.06.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 May 2021 13:06:12 -0700 (PDT)
Message-ID: <609c3534.1c69fb81.549a4.2567@mx.google.com>
Date:   Wed, 12 May 2021 13:06:12 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.12.2-1061-gc146f01fc93ed
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.12
Subject: stable-rc/queue/5.12 baseline: 165 runs,
 1 regressions (v5.12.2-1061-gc146f01fc93ed)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.12 baseline: 165 runs, 1 regressions (v5.12.2-1061-gc146f=
01fc93ed)

Regressions Summary
-------------------

platform           | arch | lab             | compiler | defconfig         =
  | regressions
-------------------+------+-----------------+----------+-------------------=
--+------------
imx6ul-pico-hobbit | arm  | lab-pengutronix | gcc-8    | imx_v6_v7_defconfi=
g | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.12/ker=
nel/v5.12.2-1061-gc146f01fc93ed/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.12
  Describe: v5.12.2-1061-gc146f01fc93ed
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      c146f01fc93eda9307e56d68ff8d3d6c420ca9fa =



Test Regressions
---------------- =



platform           | arch | lab             | compiler | defconfig         =
  | regressions
-------------------+------+-----------------+----------+-------------------=
--+------------
imx6ul-pico-hobbit | arm  | lab-pengutronix | gcc-8    | imx_v6_v7_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/609bfdcc7c1cbb11b319929b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.2-1=
061-gc146f01fc93ed/arm/imx_v6_v7_defconfig/gcc-8/lab-pengutronix/baseline-i=
mx6ul-pico-hobbit.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.2-1=
061-gc146f01fc93ed/arm/imx_v6_v7_defconfig/gcc-8/lab-pengutronix/baseline-i=
mx6ul-pico-hobbit.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/609bfdcc7c1cbb11b3199=
29c
        new failure (last pass: v5.12.2-1059-g186fb6dfb37a0) =

 =20
