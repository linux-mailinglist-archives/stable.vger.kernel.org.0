Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C448049EFF0
	for <lists+stable@lfdr.de>; Fri, 28 Jan 2022 01:49:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241685AbiA1Ats (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Jan 2022 19:49:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344612AbiA1Ats (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Jan 2022 19:49:48 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E47FC061714
        for <stable@vger.kernel.org>; Thu, 27 Jan 2022 16:49:47 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id o11so4994126pjf.0
        for <stable@vger.kernel.org>; Thu, 27 Jan 2022 16:49:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=3qerjpaOHJuSNoduj7IKdiwpOzIz3AJwf9MccPtQBZQ=;
        b=N1zDjKEltZEZUvqvEiCmGMob+ye8qKqhDvg/BxGcKQtzE5RwCnByoW23/NphDBO3Bt
         GJ0wsL82voIZL1vJG9MpXeZOKgBP6FiuHADfQTFGPPE1AgG5BLECgF6HA1M0QEfHVlHG
         3QFHvU4U8dv8VDv8Jt/qt3TcN0bxISF1jTsWyDCijPu1ptLxHQXL/VUqGnrFK38HwFuK
         n6TDGXrxa5iVRoPib1dRA3M7YeHu71JRuHCRxzKOBanRPxmqHl1g0GZWNPboP7A1FTqu
         j1xcBg6s7/M+4J8W2DBGaH32Hv8ZGYKYqxq7L4JL7YWp+sCwQge4win4xOT6rMR1inGt
         D6dA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=3qerjpaOHJuSNoduj7IKdiwpOzIz3AJwf9MccPtQBZQ=;
        b=koKVOl9UkfZhnkr0FoLQoasT0JN5YMBRjMDSVpeB3uYsBDmm4VtVZgvCl2tP/QmEUd
         9SYhF4Gu+MYk8u14do8ToWLXHnW0HunfT8Kq/1Bn3pzRGNZXCv3RiLZsCXC6bPeks2B3
         5viVO+WrjpcTv69uXuxmuVqPrhwEXaKyzBuKBnuvsU70//zeAOe+lgW3DKRUBySkBULY
         xdnUrfyp7UNTzlmczeB72+hQiH7WBaSNvEUNQbKrdiHXJOZ+M3/me99P+UVX3RfojN/D
         IWRa2s1s0d52B8qu90nigQE11zaXB6Tp8ffYvUOKduINpwx5lnTU6XZzqVTgcCyPedAS
         JmnQ==
X-Gm-Message-State: AOAM533Lbn7vASBFF4pHaS9JukeS/aoPviyEe+2dGfqIww+5P16YxZjX
        /WEwcMDPICv7fPBBIVubkYz4NjBGmtwgVRTmheQ=
X-Google-Smtp-Source: ABdhPJxub5D2nLOETOE0LUi5jfSW8b9j1kwtKecX1gKtOW4poXxBmnywcsoMFaZ1Lq50e4DnJ5O7aw==
X-Received: by 2002:a17:902:d507:: with SMTP id b7mr5822549plg.44.1643330986920;
        Thu, 27 Jan 2022 16:49:46 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id h17sm1121248pfv.198.2022.01.27.16.49.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Jan 2022 16:49:46 -0800 (PST)
Message-ID: <61f33daa.1c69fb81.f1b99.4246@mx.google.com>
Date:   Thu, 27 Jan 2022 16:49:46 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.9.298-9-g2d90ef34d565
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.9
Subject: stable-rc/queue/4.9 baseline: 111 runs,
 1 regressions (v4.9.298-9-g2d90ef34d565)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 111 runs, 1 regressions (v4.9.298-9-g2d90ef34=
d565)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig          | regressio=
ns
---------+------+---------------+----------+--------------------+----------=
--
panda    | arm  | lab-collabora | gcc-10   | multi_v7_defconfig | 1        =
  =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.298-9-g2d90ef34d565/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.298-9-g2d90ef34d565
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      2d90ef34d56543433805d9ec3e8bb34ebbf9da6a =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig          | regressio=
ns
---------+------+---------------+----------+--------------------+----------=
--
panda    | arm  | lab-collabora | gcc-10   | multi_v7_defconfig | 1        =
  =


  Details:     https://kernelci.org/test/plan/id/61f30d6bdbd2eb7dfcabbd1a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.298-9=
-g2d90ef34d565/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-panda.t=
xt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.298-9=
-g2d90ef34d565/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-panda.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61f30d6bdbd2eb7dfcabb=
d1b
        new failure (last pass: v4.9.297-154-g670e79b3de6b) =

 =20
