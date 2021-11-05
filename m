Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85A0344698A
	for <lists+stable@lfdr.de>; Fri,  5 Nov 2021 21:19:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232861AbhKEUWa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Nov 2021 16:22:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230318AbhKEUWa (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 5 Nov 2021 16:22:30 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 422F7C061714
        for <stable@vger.kernel.org>; Fri,  5 Nov 2021 13:19:50 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id g19so3839987pfb.8
        for <stable@vger.kernel.org>; Fri, 05 Nov 2021 13:19:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=b8fbmvN5vst7tSZjUgKYdYfl53zCkYT1UBUNz3RirNA=;
        b=sbxQrWvHCj8pmuuLkemJLuQZAUuj08dtLn80kWEnPZ2u1Kn5qzH7GJEOcxORuI8m8t
         rqCBPVhrqNInfLpuRr8HN9aiftTe1ftem3VgOijeq6irUSorgIE0cLc61aBzKom/E21N
         X9fCsEoBp7v2ld7vemIMnetvKAcJ0jwxmNNjCD9ojn8W0BvIrzy1NBS3MIV7k3PG8fUw
         bjGlzo377IkbiPAY1mJgdxVf8aL7FXPoriGuAyiecISy8lM2IXQd++DM/FzmzJHj+mqO
         R266LX/n6t6UwFLEDdKqk/i4cC3Ktxuv4khkPYWyiS9qk1Sr9j2C1BliaYBQRWeUFQyk
         f0Ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=b8fbmvN5vst7tSZjUgKYdYfl53zCkYT1UBUNz3RirNA=;
        b=HXyknk7qUyepL0ujQil/jZ1zIXSVMXsWbcYWIR9McTmEUG8/5/VxWuyQTri6AbmxnJ
         nmh5LNiExXK837mAUP5R9npZdrs+E2m14p4t5oE0pECAe/gXjCN9Ta+5LwD2OBIePPu5
         sQvhTGuLkHIIiWQRw7F5cGZhMfTRVTzH8mQEfpPG+sXbRYMIPM+0lVPGuFJBbjqZMmUI
         6XIk02YAydlETdVGbgRiAPqRJH/HZ8QdtHK8Wcz3lXkZalIzFDcwx9dAY+rp1K97Y4qH
         UhXrBEC41Bd+eEhpNpCjpMF77QWmGQsr+7vU5NoP66l6W9OAm7+ULmrWc8FUGTOD+6C/
         +1Pg==
X-Gm-Message-State: AOAM530xUdEEfXI10X7u1jBz+s3+GpnYQ86vVaY53siIl1vTcOqZjkQs
        GkSuk5lmmE7nrTjwWOhVUcOZhZQDi1t0GQ90
X-Google-Smtp-Source: ABdhPJzHk8ltsPnbJVApdFZkawE2AhH0SOLCnmU2HU3mBT68PNKYIxqVnJpJqDv2CfDHSuWlNllPLQ==
X-Received: by 2002:a05:6a00:1309:b0:44d:4d1e:c930 with SMTP id j9-20020a056a00130900b0044d4d1ec930mr61246401pfu.65.1636143589659;
        Fri, 05 Nov 2021 13:19:49 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id e12sm6763248pgv.82.2021.11.05.13.19.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Nov 2021 13:19:49 -0700 (PDT)
Message-ID: <618591e5.1c69fb81.ce32c.6a8f@mx.google.com>
Date:   Fri, 05 Nov 2021 13:19:49 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.14
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.14.16-16-gb3f503991ac1
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.14 baseline: 136 runs,
 1 regressions (v5.14.16-16-gb3f503991ac1)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.14 baseline: 136 runs, 1 regressions (v5.14.16-16-gb3f503=
991ac1)

Regressions Summary
-------------------

platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.14/ker=
nel/v5.14.16-16-gb3f503991ac1/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.14
  Describe: v5.14.16-16-gb3f503991ac1
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      b3f503991ac1ab9e338bd55dc1d13bfd9e377e59 =



Test Regressions
---------------- =



platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61855f6d70a174f6dc3358de

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.16-=
16-gb3f503991ac1/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagl=
e-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.16-=
16-gb3f503991ac1/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagl=
e-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61855f6d70a174f6dc335=
8df
        failing since 12 days (last pass: v5.14.14-64-gb66eb77f69e4, first =
fail: v5.14.14-124-g710e5bbf51e3) =

 =20
