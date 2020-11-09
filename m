Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 523E22ABFD6
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 16:29:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730709AbgKIP3O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 10:29:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730555AbgKIP3O (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 Nov 2020 10:29:14 -0500
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45D3AC0613CF
        for <stable@vger.kernel.org>; Mon,  9 Nov 2020 07:29:14 -0800 (PST)
Received: by mail-pl1-x62f.google.com with SMTP id w11so4898121pll.8
        for <stable@vger.kernel.org>; Mon, 09 Nov 2020 07:29:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ore+ut4CJcFUiNQLJwvxPwdGvIwAUwXzCFWef4fpZkI=;
        b=IIFdW3hSdsJjhOZGUvhvbOguIfH13y0/H3UiC1/3JE3Gi/LBvAgrIRlRYWarBs0f6G
         5yt6qEgderK7lxCa6NPGTQvEWe5VYkVg/+gkUmbIDoBueGPVG6Ap+2qLWTWnGtfkscCJ
         6qsWWYqjXs1EW/EJJsil0sedSBjxgZnPnZRJJxHcEXlm16uMrRRdrUfiuhby6KL6fC+R
         Ev/Po5S39BiNm1O2gSoxnVpODpVutO67WgU033gBZ/tvLvvjg5UljnwuQc9tmZ1pikoQ
         AS18dkuiPLsdskiINBntceDbko8W4qe3hM2qdQa7pJB8pDMC0gEyFmvQr1uXNKRAh7je
         A84g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ore+ut4CJcFUiNQLJwvxPwdGvIwAUwXzCFWef4fpZkI=;
        b=k2wHijkKeIYACl5BWMY88M0DpPiiNKWmVaDUrseMOeosAyVaCtZv7V/zispsUEBB78
         726mD43hznPL5jre02RDmtC64UewqEc7D5Twjddnpz+69fZ+YKvlgsQciQhbsU28tYPX
         ZIj6o5HE1swz1435s8eQXiXqkEVCZy7QMMF9xYpB1CSGZG1hmvzCo13tTiPdVwISAIG7
         sIOvF2SpZcqIOLAlASB+AFsNP/DzTSpKoEgcj8MgQ/ompWAUUwsDAtnxCRE+byPuWgmH
         WdcKsuUAqRTDvsFKoG9XTEe+0KgQ0i0aueUbIg5aLRJRJzKeQ3EIdX9GxJQuvV6BHtKH
         i/Dg==
X-Gm-Message-State: AOAM531LfMDx1CRlHUYAEd86YxYfR9zdjfNQhjNWlWeTfBGUoWTrMspI
        e+XK0JMPxY7iocdfoLHg68fZr71leX9BFg==
X-Google-Smtp-Source: ABdhPJwLNQWZzoJEAgq0PtlnceoneMXpJatOQdW9Is+LUCAfRKQsYHQ+EsPf3Irhkr9bzRI9cLLUfA==
X-Received: by 2002:a17:902:d3ca:b029:d7:e0f9:b9c with SMTP id w10-20020a170902d3cab02900d7e0f90b9cmr4645750plb.2.1604935753408;
        Mon, 09 Nov 2020 07:29:13 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id v125sm11226858pfv.75.2020.11.09.07.29.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Nov 2020 07:29:12 -0800 (PST)
Message-ID: <5fa96048.1c69fb81.dc32b.7e1b@mx.google.com>
Date:   Mon, 09 Nov 2020 07:29:12 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.14
X-Kernelci-Kernel: v4.14.204-47-gd378e1df0e7d
Subject: stable-rc/queue/4.14 baseline: 168 runs,
 1 regressions (v4.14.204-47-gd378e1df0e7d)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 168 runs, 1 regressions (v4.14.204-47-gd378e=
1df0e7d)

Regressions Summary
-------------------

platform        | arch  | lab     | compiler | defconfig | regressions
----------------+-------+---------+----------+-----------+------------
fsl-ls2088a-rdb | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.204-47-gd378e1df0e7d/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.204-47-gd378e1df0e7d
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      d378e1df0e7db5bf417ec472a3a7006a9572fba4 =



Test Regressions
---------------- =



platform        | arch  | lab     | compiler | defconfig | regressions
----------------+-------+---------+----------+-----------+------------
fsl-ls2088a-rdb | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fa92fb50100329d5ddb886d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.204=
-47-gd378e1df0e7d/arm64/defconfig/gcc-8/lab-nxp/baseline-fsl-ls2088a-rdb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.204=
-47-gd378e1df0e7d/arm64/defconfig/gcc-8/lab-nxp/baseline-fsl-ls2088a-rdb.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fa92fb50100329d5ddb8=
86e
        new failure (last pass: v4.14.204-35-gb960076bb337) =

 =20
