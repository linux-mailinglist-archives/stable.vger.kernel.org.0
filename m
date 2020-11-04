Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7CF02A655D
	for <lists+stable@lfdr.de>; Wed,  4 Nov 2020 14:41:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729677AbgKDNlU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Nov 2020 08:41:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726691AbgKDNlT (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Nov 2020 08:41:19 -0500
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B741AC0613D3
        for <stable@vger.kernel.org>; Wed,  4 Nov 2020 05:41:18 -0800 (PST)
Received: by mail-pf1-x431.google.com with SMTP id b3so17330082pfo.2
        for <stable@vger.kernel.org>; Wed, 04 Nov 2020 05:41:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=bm0ho5vrd2+2MonqczFUZCok2/srE9UxeJ7WdD/4wRw=;
        b=CNQn7/S+hrscOthvP0xZdEin35yxWXTNHLaHwg+cG0bA/mrLCKqwTrWHnb2c6vo01L
         kb0uq/+RQWQF6clA+fFl86IpRNNhZ9NTB0hJmtfh8aGalRrz3XKjbMlSC+PF9ExeJGxP
         TMauz3cskPIcFpfL3NLoNc/+iHTCAr4Oej0OAUyWCZkpsuUsrfOHsN94hltWJiIpa+w7
         jzbQbAKV04OC6wm1agIQet8y6TJEQc5gQL0VFxpZ5qCzj5SuaeJLYvALerPHEAL1UEVg
         jnBVyul6fzOKJFtTxgFVf3MxTsi61kJ8LIGQezNmSR+Huf4TGK932KFACxU5OSdOfRvr
         OwlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=bm0ho5vrd2+2MonqczFUZCok2/srE9UxeJ7WdD/4wRw=;
        b=LEiOCnbNTU1u/qI6AH0Rq9/g9xIvSqHlpUBVEIBC3+/zaXY5T2XGdK7CaampSv8YMy
         YYz6YXo3TsSpNH9cTBnYyswimIs14KVoFCwr6Uh5mVFBmsqGYTDXRE5ZXA1IS0OZmVBj
         GK1A/fazIMrCRqd/infqP3sR/PkSlTgFN7o7NWCQSSIxtdEKoL0eWWI5vP71xUxEVe9R
         IhKLYV/v9oxZ4+gqAlYX22inytesl2HNLoR/5L2j9NsWeLOAlp5jua02RxUigl8u4R4G
         Cdpk8BSi9Zg4gBrAVGXZ5B1H6xZ7w1GWyzSt3RqgcxKrjPzTtGYyDFOP/vYHCfwma+NF
         or0Q==
X-Gm-Message-State: AOAM5323bqhVuK+TLbLsRzDGSsDwUzJr62A/oRDxwF5rC4BL9KPqIdyK
        C1KYxxYjfxIgiGjwUQrIhRFdwXYUC2pd8Q==
X-Google-Smtp-Source: ABdhPJxwdQhuM7OvKlAYaYDAsdcH1PShJmJO3rwfUJnNnOZLv8kqz9xzsXUQsVe1nPPmxUAOc+lVKA==
X-Received: by 2002:a17:90a:9f82:: with SMTP id o2mr4435700pjp.52.1604497277988;
        Wed, 04 Nov 2020 05:41:17 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id x123sm2602195pfb.212.2020.11.04.05.41.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2020 05:41:16 -0800 (PST)
Message-ID: <5fa2af7c.1c69fb81.d1c23.5dcd@mx.google.com>
Date:   Wed, 04 Nov 2020 05:41:16 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.203-124-gb8668b06092c
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/4.14
Subject: stable-rc/queue/4.14 baseline: 172 runs,
 1 regressions (v4.14.203-124-gb8668b06092c)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 172 runs, 1 regressions (v4.14.203-124-gb866=
8b06092c)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.203-124-gb8668b06092c/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.203-124-gb8668b06092c
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      b8668b06092cc7a3a3df81ec24f8ac1ec4404269 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/5fa27e91cd79a63951fb5323

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.203=
-124-gb8668b06092c/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pan=
da.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.203=
-124-gb8668b06092c/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pan=
da.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5fa27e91cd79a63=
951fb532a
        new failure (last pass: v4.14.203-125-g68bd10b5f0a3)
        2 lines

    2020-11-04 10:12:29.935000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xffffed34 [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
