Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 710F7479166
	for <lists+stable@lfdr.de>; Fri, 17 Dec 2021 17:23:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239086AbhLQQXM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Dec 2021 11:23:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239083AbhLQQXM (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Dec 2021 11:23:12 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16D9EC061574
        for <stable@vger.kernel.org>; Fri, 17 Dec 2021 08:23:12 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id z6so2277844plk.6
        for <stable@vger.kernel.org>; Fri, 17 Dec 2021 08:23:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=TKMhU8XrepXFOHUXiFc1gKtrdUqbnktP0ll10LPu4Qo=;
        b=AX5k3+jcxOx7M07kJ5Ps6HawIBy+Riq9j58oxZJLcaQAOrqfDOWpwGHlYGRoF7DhsH
         Kq20LhNXEPA4XyjAOePa35EU543qtlX3g7HvdzQnj7LQhhNtaAb9QEMVNhW3CrnXBasS
         AQi+OSZ/7vgGCP/CibfvJ8rJX+Y71zSdFwXyTIlGxq0t2GNkhrUTrghyqHPKgjl22D48
         AsUVB7tb6Tvrf8Q8wwhFS7bZMb7C1SxTbfUk9dcOKRu/yTZDRZ5shLV7HYZdcq9kq2sA
         Ehsxc4lJlXapZM4Ww++3/A6Ch0g/If541Nar1Cv6c0PezSX+gkJCP6PXoRJIuQ/DTsPF
         kmKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=TKMhU8XrepXFOHUXiFc1gKtrdUqbnktP0ll10LPu4Qo=;
        b=bCzr139p4wlLmEyYwTyg6p5RGkox+eofSVZ3RlXPYl3w5IgJH9/gT3a9bguTgPG7vL
         o3XrmxwMOWIeeutOqkfSIKgt2ftx4LYKZ5Oki4tSg+i7gIBdhgIKQofLJKP+glXIJxyW
         yZ0BdikExKBE8jejQfJ+Af0siSb6bnMr6uNq6XAnZZDI3w1p9nDo7AhQ43pMuFB3gOI/
         YpuB7nfzHKBIV24NQvtweX193u5BDK/mBryCZ62cGMKjhvGG7SRdhJ7Jvc3abZyUexS8
         ZSdIxufypyu5e+uQdDeodIzz0JC5V3IJlPIZdmimdVthp3ruRhHxhInr9Sq3b8nEpamh
         hSCw==
X-Gm-Message-State: AOAM533uMW+Tse9MXpD/tJXKUAQdSAcZn/DWSGCbtS4Eldzhkbz3K+XI
        ADDI/1jZJC8T7pSF0pomYAZPXIH0BfnkCMZ3
X-Google-Smtp-Source: ABdhPJwf5H963gqzJrN+AhiZllqH7ubkWN6JBaHXdVoXBW6zHaEKIetjeEepTe77s85iYr5iSx+luQ==
X-Received: by 2002:a17:90b:4c49:: with SMTP id np9mr3895396pjb.138.1639758191473;
        Fri, 17 Dec 2021 08:23:11 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id n6sm9935871pfa.28.2021.12.17.08.23.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Dec 2021 08:23:11 -0800 (PST)
Message-ID: <61bcb96f.1c69fb81.62577.beeb@mx.google.com>
Date:   Fri, 17 Dec 2021 08:23:11 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.15.8-42-gd38bf047f9df
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/5.15
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.15 baseline: 174 runs,
 1 regressions (v5.15.8-42-gd38bf047f9df)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.15 baseline: 174 runs, 1 regressions (v5.15.8-42-gd38bf04=
7f9df)

Regressions Summary
-------------------

platform                | arch  | lab        | compiler | defconfig        =
          | regressions
------------------------+-------+------------+----------+------------------=
----------+------------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe | gcc-10   | defconfig+arm64-c=
hromebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.8-42-gd38bf047f9df/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.8-42-gd38bf047f9df
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      d38bf047f9dfd12fbc331461d9b7cd8b704616b1 =



Test Regressions
---------------- =



platform                | arch  | lab        | compiler | defconfig        =
          | regressions
------------------------+-------+------------+----------+------------------=
----------+------------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe | gcc-10   | defconfig+arm64-c=
hromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/61bc863c0bea4daf3d39712d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.8-4=
2-gd38bf047f9df/arm64/defconfig+arm64-chromebook/gcc-10/lab-clabbe/baseline=
-sun50i-a64-bananapi-m64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.8-4=
2-gd38bf047f9df/arm64/defconfig+arm64-chromebook/gcc-10/lab-clabbe/baseline=
-sun50i-a64-bananapi-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61bc863c0bea4daf3d397=
12e
        new failure (last pass: v5.15.8-42-g0a07fadfda6d) =

 =20
