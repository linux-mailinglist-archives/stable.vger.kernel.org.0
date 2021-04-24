Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF58636A23C
	for <lists+stable@lfdr.de>; Sat, 24 Apr 2021 18:54:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231940AbhDXQyk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 24 Apr 2021 12:54:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230010AbhDXQyh (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 24 Apr 2021 12:54:37 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D33A8C061574
        for <stable@vger.kernel.org>; Sat, 24 Apr 2021 09:53:58 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id g16so9871092plq.3
        for <stable@vger.kernel.org>; Sat, 24 Apr 2021 09:53:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=3FTF9+GaOPjuGekj0Gffg6pYngekRA03bZcCwG1LmXU=;
        b=aOfofm+/veSi28R3ucPx03hWoNKSeEorpcDvr6cEMDmamHEEaZotOOgzNmJEMw+Ki1
         V74ipvAsCL2GlOzVOQTlfUgJ0hUYhxQJDOHdyAmmrgudrkrTfCHfQ81we4+8RknbUelQ
         nXkvvkSNywGA6FIvt6DuO8Ejk+m4PfFfglcXIb+ST5J65C8QCI+yySKOFOYIJj6pVpLW
         mG41E9tezgHTLiV0M2LyhsyKO/6DJkVwmeDS910AxczAbyzU65GVsh47oIfNpKZYzoE9
         MC+RyxudapEWHNNQlSqzN1i3Xw/jUxGM/sfQrEvWQMDHOP7hbOrARSjWehc4RYCXqfqM
         B8dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=3FTF9+GaOPjuGekj0Gffg6pYngekRA03bZcCwG1LmXU=;
        b=PxlWpPOIyaBVcHmyG5kV8BnYOjlJF92fFh6r3NrPjknuYLAUxqTynlQZUJzWuRjLGm
         K7wLks6vMMLY7KowFtPEVYKT69+EfoDJ1NI02AtZpiJjUQ/cNKGMBDhuMRcneW6NMatP
         EXiiB7546/9/sNzJ9lkwW7syep1Uoj/cIdUVZ3VQXezBd5DN6YYPqgZx/pvntxPeiV2Z
         Kyk3FsJTnBeKnrXOPtiK7/3ozKtSx+GZqYmjpp4pHLRD3iY4OoRvc9bxq/mG5UjS2L9C
         DLj2EIQk+fkyfXM+HCVtzXaTTT2L77o5TTzfCSxnLtNW1SKTnCoTUdcXxkjz/o1eE3cV
         jNQg==
X-Gm-Message-State: AOAM530F2KGPvGwNBnRAt5gxQMqmILHBtBD12CovywFQQiCYD8CZP5u/
        wwBAkhaBDhS+ZDRd3JwhwFW5f7Sz0gcD9oPU
X-Google-Smtp-Source: ABdhPJypoGW7zY+yBdGD8QpYvn7SseUjTh1ZKEwOsWaly8crBLfLn2q9PvUshJ+A9SjKlwb36UGgBg==
X-Received: by 2002:a17:902:b20e:b029:eb:47e3:5977 with SMTP id t14-20020a170902b20eb02900eb47e35977mr9659512plr.67.1619283238315;
        Sat, 24 Apr 2021 09:53:58 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id g1sm7834652pgi.64.2021.04.24.09.53.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 24 Apr 2021 09:53:58 -0700 (PDT)
Message-ID: <60844d26.1c69fb81.f404f.748b@mx.google.com>
Date:   Sat, 24 Apr 2021 09:53:58 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.4.267-21-g99e7ea61d93e7
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.4
Subject: stable-rc/queue/4.4 baseline: 70 runs,
 1 regressions (v4.4.267-21-g99e7ea61d93e7)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 baseline: 70 runs, 1 regressions (v4.4.267-21-g99e7ea61=
d93e7)

Regressions Summary
-------------------

platform   | arch | lab             | compiler | defconfig          | regre=
ssions
-----------+------+-----------------+----------+--------------------+------=
------
dove-cubox | arm  | lab-pengutronix | gcc-8    | mvebu_v7_defconfig | 1    =
      =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.4/kern=
el/v4.4.267-21-g99e7ea61d93e7/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.4
  Describe: v4.4.267-21-g99e7ea61d93e7
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      99e7ea61d93e76dee494fe563d43fcde27833394 =



Test Regressions
---------------- =



platform   | arch | lab             | compiler | defconfig          | regre=
ssions
-----------+------+-----------------+----------+--------------------+------=
------
dove-cubox | arm  | lab-pengutronix | gcc-8    | mvebu_v7_defconfig | 1    =
      =


  Details:     https://kernelci.org/test/plan/id/6084143dc42a259a929b7796

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: mvebu_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.267-2=
1-g99e7ea61d93e7/arm/mvebu_v7_defconfig/gcc-8/lab-pengutronix/baseline-dove=
-cubox.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.267-2=
1-g99e7ea61d93e7/arm/mvebu_v7_defconfig/gcc-8/lab-pengutronix/baseline-dove=
-cubox.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6084143dc42a259a929b7=
797
        new failure (last pass: v4.4.267-21-g788e05e2821e7) =

 =20
