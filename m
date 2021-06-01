Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 693983976F5
	for <lists+stable@lfdr.de>; Tue,  1 Jun 2021 17:42:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234295AbhFAPoT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Jun 2021 11:44:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234177AbhFAPoS (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Jun 2021 11:44:18 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DBA5C061574
        for <stable@vger.kernel.org>; Tue,  1 Jun 2021 08:42:36 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id 6so11005400pgk.5
        for <stable@vger.kernel.org>; Tue, 01 Jun 2021 08:42:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=cFuQOZl8y/KtN05SJx/J1F4PKTDCR8mznhbqBs+pkIA=;
        b=pBYRpoZy/IeUviU7aUVUJIZz+0Te96Fa5KestD6uKeLy/jZT5/aPcHalQVgBaQg6KR
         M0oJxS4B85IaODg871o69FcCOeIPanuBNSy24kcCypYFnb0R8e4Tequ1Br/N7lK+KlIN
         bgUH6q1ec9aMfVS4lnPhJeyKvUK2y0Ea0O3drysE2QlQyRuGjNCepF+nd3/53o0kvERw
         20DVaJvFU8gUwa8BDw44U1t8fCV8IbSSsE0Yb/29Osz+myVp9AUe4ySzlu42BrQb3Sh1
         qyFNJMAXj0vP1upCYfu2rJfLIKDHqh9WCCaL4+A/QeZ08Dgva1e0HtggIPy48In2+5Nn
         bctg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=cFuQOZl8y/KtN05SJx/J1F4PKTDCR8mznhbqBs+pkIA=;
        b=uHRt1YZEtHvlceXnGJOL5Rl9JwMuIe2X1HaFgIxqjzEgR7sIqltkxV1pIL7hKcRdCo
         LnTf42AkH2CDl/AFuC1Crx3mGZX+PYEj2LoM3/FRUWZCUZwAY96E4363CSvqP44/kVcf
         KcJO33nlJefmWMK36PqF9EOgEoqtL4OU5mM+MwWeA+LVaPI9kNWak4u3cbKLeNxYSs5q
         jDepQxRkOR99BYgIgaDQHw0AUUnv+ipNfCCUDu3wcPmECzKqDZ7gQuXPeM4YkQoKH9z8
         YCt9b5Ppa9UvmWu8ofrmLjPSAT65Pf6nNgFvL7JubocvXw2A+0nj2IQaZsDH4XeCM+43
         0uQA==
X-Gm-Message-State: AOAM533jjnlW2Lb8fyunekA4f9yO9QL4DmkycaSPOXtRsr4px2eMnGhb
        Ye2bqOmZaLQmAk5OUls98p8K6ZO9BzRo+jCY
X-Google-Smtp-Source: ABdhPJygaPYhZIIaBxhjWk95BGtH5sg6FV1CDkyfFOQR5lFx2Ys2CmQRRifmqar3aW6jeImambBobg==
X-Received: by 2002:a62:78d4:0:b029:2ea:ba:234c with SMTP id t203-20020a6278d40000b02902ea00ba234cmr3840455pfc.53.1622562156045;
        Tue, 01 Jun 2021 08:42:36 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id t23sm5483845pgj.9.2021.06.01.08.42.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Jun 2021 08:42:35 -0700 (PDT)
Message-ID: <60b6556b.1c69fb81.50d82.0cf3@mx.google.com>
Date:   Tue, 01 Jun 2021 08:42:35 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.12.7-303-g89387db068ad
X-Kernelci-Branch: queue/5.12
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.12 baseline: 124 runs,
 1 regressions (v5.12.7-303-g89387db068ad)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.12 baseline: 124 runs, 1 regressions (v5.12.7-303-g89387d=
b068ad)

Regressions Summary
-------------------

platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.12/ker=
nel/v5.12.7-303-g89387db068ad/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.12
  Describe: v5.12.7-303-g89387db068ad
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      89387db068ad8f0da6fc180866138d7e93556eca =



Test Regressions
---------------- =



platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/60b61c5ffb406d0db1b3afb4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.7-3=
03-g89387db068ad/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.7-3=
03-g89387db068ad/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60b61c5ffb406d0db1b3a=
fb5
        new failure (last pass: v5.12.7-304-g7ade597cd7c1) =

 =20
