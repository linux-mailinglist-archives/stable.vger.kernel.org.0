Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 847C0383518
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 17:14:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243463AbhEQPQC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 11:16:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239819AbhEQPMk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 May 2021 11:12:40 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6506C08EB13
        for <stable@vger.kernel.org>; Mon, 17 May 2021 07:25:54 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id a11so3234455plh.3
        for <stable@vger.kernel.org>; Mon, 17 May 2021 07:25:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=1FTNSfKML/7yt3gstUjbSewhR5tqt38Sbscy38uisHg=;
        b=J009ETJaRsaUQ3xkKb8+8+g6Sp6mghmGscpJ8G37ryGevqJTtXf0DB/hqwfrSAEjPW
         uTWX3YaWV0NHq7KHatZlao5mYd4uG6hoHUM52+leQPOCCEK+RwC/HBiUfnl2ne8TN1Vm
         HfQ0f8SkA3WHcdPpBTm8C6DeA8HPtQs6zGiNWy1goKDtWpbk3fkWMGqYEqoER7WCfrTG
         G0bVdJ5U1JLKtnFTjEYPYEV2reFwqpWJSAwckAe3K+hNwxby5G6R+bvprUzsGl8CqYTv
         oho0TyweCXag2FaVbmlkBgOSgCU/RSfk+08BH5v3H9yjF2ojzrpAuAKkHnPadIGweaAQ
         FOrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=1FTNSfKML/7yt3gstUjbSewhR5tqt38Sbscy38uisHg=;
        b=RZ26v73gG2IL8GdmpBvFAFBKfqwvA64rZ6P7qr+TZz9ttefawhv0txGDd8R5y1qoDN
         BI9zkvcXopabGvRq0tLLXq7fPA4qUswudnNkkQ7n9ZRXXltBbVos0IxxXSb3Svymvi0Z
         mDiL6cZE4bntwUAnV7aMoTTWBecrOKram5db8oHZq0KE68eOWgBehPj/Pnnmh4YNRzfn
         jBueHUEeMc8XTomXs/3kKWdTt8qqQj9laI+P/w1HWdHro6Buu3USCjTdPLDaeSj1Uasp
         bOMevdAiv+NMYnpYoekojGOXHFj/DBlXi7zhdFe/UgFKcPeCRV6HmbJpHb6MxqQb2iXU
         25Jg==
X-Gm-Message-State: AOAM5329Wm/vkcLIx5ivI+BRaCG0+eU3bqV6LFv9UgKLR0BB2E7alGay
        is5b02Cs51NT227lO5YHzDDeACuQozGcZLe4
X-Google-Smtp-Source: ABdhPJzkQgXty15atqBg5/+aRVeVkPugCUYyzI8fYY1IUxbJ/AmU7fKSJDsXi66u/gvEvfwviVKsNg==
X-Received: by 2002:a17:902:7284:b029:ee:a57c:1dc9 with SMTP id d4-20020a1709027284b02900eea57c1dc9mr279004pll.36.1621261554206;
        Mon, 17 May 2021 07:25:54 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id c6sm9935399pfo.192.2021.05.17.07.25.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 May 2021 07:25:53 -0700 (PDT)
Message-ID: <60a27cf1.1c69fb81.b35a7.11d0@mx.google.com>
Date:   Mon, 17 May 2021 07:25:53 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.10.37-260-g2c9127d0fedb
X-Kernelci-Branch: queue/5.10
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.10 baseline: 132 runs,
 1 regressions (v5.10.37-260-g2c9127d0fedb)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 132 runs, 1 regressions (v5.10.37-260-g2c912=
7d0fedb)

Regressions Summary
-------------------

platform                 | arch  | lab     | compiler | defconfig | regress=
ions
-------------------------+-------+---------+----------+-----------+--------=
----
r8a774a1-hihope-rzg2m-ex | arm64 | lab-cip | gcc-8    | defconfig | 1      =
    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.37-260-g2c9127d0fedb/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.37-260-g2c9127d0fedb
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      2c9127d0fedb4edd70e5c25b2dc372ae17828353 =



Test Regressions
---------------- =



platform                 | arch  | lab     | compiler | defconfig | regress=
ions
-------------------------+-------+---------+----------+-----------+--------=
----
r8a774a1-hihope-rzg2m-ex | arm64 | lab-cip | gcc-8    | defconfig | 1      =
    =


  Details:     https://kernelci.org/test/plan/id/60a24b9fe71b71fc38b3afce

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.37-=
260-g2c9127d0fedb/arm64/defconfig/gcc-8/lab-cip/baseline-r8a774a1-hihope-rz=
g2m-ex.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.37-=
260-g2c9127d0fedb/arm64/defconfig/gcc-8/lab-cip/baseline-r8a774a1-hihope-rz=
g2m-ex.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60a24b9fe71b71fc38b3a=
fcf
        failing since 0 day (last pass: v5.10.37-193-gcd21757d3cec, first f=
ail: v5.10.37-239-g9ceb91ab8393) =

 =20
