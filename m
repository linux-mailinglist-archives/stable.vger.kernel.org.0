Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D0D03E3BA2
	for <lists+stable@lfdr.de>; Sun,  8 Aug 2021 18:43:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231199AbhHHQn1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 8 Aug 2021 12:43:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230169AbhHHQn0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 8 Aug 2021 12:43:26 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0699C061760
        for <stable@vger.kernel.org>; Sun,  8 Aug 2021 09:43:07 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id u16so13875835ple.2
        for <stable@vger.kernel.org>; Sun, 08 Aug 2021 09:43:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=/k9oxYd9taWCIJYrEe24tWrZ6+PPSAo7UwDcslIQJ68=;
        b=cIHp41/TmLPRFJrPEuJBlEtLPI2n81sWbNA17S7kCazGPxXwqnatAt0xqzw4vApKjB
         pjWAJ3cCF7k/sKqp3xyAqi6Ay8Zmp6UlNmPPZOBuxAnfdLcp0eKBIEBarmp+Ffjl0jwN
         RQgAqRl8ovx26w0m3AiD5uwcPg1DzcE/S5/6vv3iEiZWi8pKNHvQ0vFO1jgpvBivH0yY
         RzaoKMp+FVrtmekp0T3UMViv8Rvs8ggrT1hQd/71cOvwfb0Fw9nIK7/VhXGwxH++c3+m
         MNeRVARKELP17aYHayg5WhOM3hQXP5wtq5iG6S+nX0iNQQxRsp0ckI8V86WJ0oFoY8OR
         zhOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=/k9oxYd9taWCIJYrEe24tWrZ6+PPSAo7UwDcslIQJ68=;
        b=e0lT/hdOBk1iX6YM6+8k+YLmkq1uw1dmMBM1hqf9DKUdGc+gVMKFHgmqnffGycHP3c
         8+Oqa6VPSBTJAuohgl4DyJkSRQ3gIy6OCcs0cIDFptzCwzGcnNxtf6Rgzfk0XamLU6k2
         Yxf+9vLtPEEqHrlBxoiHVlA8IQexyIOgnPAp5xVwfnUyb7xu/RCYUaqjN47ZqrJBEz/h
         /DnAUWtWmaSCPnB8w5b3cVObUZaG6U0ssixMbYq1XvvrgcF2CNJnPUH5dQHMPMODNhFh
         pFj3WCNoI+TEICamIBbkWYJl56zR3Y8wiphGnqPX0OaYm7D5gK0t/mCo3SV/zZZJwgIW
         lvIw==
X-Gm-Message-State: AOAM533Du4aydX2NY5jvRG9en2GZpgARRQeTCjr/aTQLaVSthwWQiDW0
        sHQEwRMeLG7B6Hezyjw1EdbKk0lDTMwUgEps
X-Google-Smtp-Source: ABdhPJxTG6VV/D7i0OF8rvwbvHnPKNPDchvwZXJ9fUKv3sTmtQ0L5CJVZ4e4VZyUSEee23DODLz4rA==
X-Received: by 2002:a17:90a:748f:: with SMTP id p15mr20891362pjk.179.1628440986962;
        Sun, 08 Aug 2021 09:43:06 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id f1sm17743913pfk.115.2021.08.08.09.43.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 Aug 2021 09:43:06 -0700 (PDT)
Message-ID: <6110099a.1c69fb81.e6806.337f@mx.google.com>
Date:   Sun, 08 Aug 2021 09:43:06 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Tree: stable
X-Kernelci-Kernel: v5.4.139
X-Kernelci-Report-Type: test
Subject: stable/linux-5.4.y baseline: 127 runs, 1 regressions (v5.4.139)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.4.y baseline: 127 runs, 1 regressions (v5.4.139)

Regressions Summary
-------------------

platform    | arch | lab     | compiler | defconfig           | regressions
------------+------+---------+----------+---------------------+------------
imx7ulp-evk | arm  | lab-nxp | gcc-8    | imx_v6_v7_defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.4.y/kernel/=
v5.4.139/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.4.y
  Describe: v5.4.139
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      e350cd02e293be9a6b93398b2d3ff1edf7695ab2 =



Test Regressions
---------------- =



platform    | arch | lab     | compiler | defconfig           | regressions
------------+------+---------+----------+---------------------+------------
imx7ulp-evk | arm  | lab-nxp | gcc-8    | imx_v6_v7_defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/610fd2b79bc469f694b13661

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.139/ar=
m/imx_v6_v7_defconfig/gcc-8/lab-nxp/baseline-imx7ulp-evk.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.139/ar=
m/imx_v6_v7_defconfig/gcc-8/lab-nxp/baseline-imx7ulp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/610fd2b79bc469f694b13=
662
        new failure (last pass: v5.4.138) =

 =20
