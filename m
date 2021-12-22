Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1C4047D673
	for <lists+stable@lfdr.de>; Wed, 22 Dec 2021 19:21:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344588AbhLVSVn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Dec 2021 13:21:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233546AbhLVSVn (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Dec 2021 13:21:43 -0500
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A04EC061574
        for <stable@vger.kernel.org>; Wed, 22 Dec 2021 10:21:43 -0800 (PST)
Received: by mail-pg1-x530.google.com with SMTP id s1so1285852pga.5
        for <stable@vger.kernel.org>; Wed, 22 Dec 2021 10:21:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=1SPU748iUTC6EScVLrfveGa+/bKBVeRO7qbzYrmMg+c=;
        b=jtVaDpaGP+dRRYmkQbnFn5mSgRVFPr+s0l7fTL+jhMcdcFCwaG87tChZ5gEU1rfoLi
         rYS0XHmTyo3m6Fqgv8LB9o9ymda4W0gyEV0+OVhl76lWpQVl+n47OdU6xu4ATNR7d5Zh
         ANLNCj74ixjeOKSDAUDZl2Y1TIdsRELljWVWLOeIPmy8EiA7BNJaGN6NN/5o3lQlqTne
         LoHKYKQRGIfYR5CeY9FoAk6ahiwnk0tTR4xLFf180/ZTZBIErrz2PDCDBol/m0PFsdT9
         JHDJ0WFpWJ2n2UB/IHVm6mLabtjAbluJcXag1e/JWp4sH63Oqxi7GSjZG907qJgcLDjo
         FdQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=1SPU748iUTC6EScVLrfveGa+/bKBVeRO7qbzYrmMg+c=;
        b=hGBNHn0x0Eo96DXvMEHsg1hF4eOgUX4YKtixboifVUT90Qt2cNEubtQwNHe/wClSeO
         OtZYLynYBmVwdeciHBuQPWntaIqBUxs3C809rXxQ9hRWgSlTPlrOURoxT8u5iBreJ+Ej
         tSYw5Lg9ngEoHq2EmRQNFQjbLuMIDr8t6AuNmyfLk8YzjgJXU/1bh4q5A9zhgPtS90dM
         0Ovns1k1EOAnvlpnW33pU64g5bW/avJwRTCcN1BmjVee4jAU2096hRJfDf4ZM0gAfhjd
         O9IthCee7hcTpQSgte9zyEf8OKqba0xabhdqvlNTDJtlqs5m0fcQN56TTKcRypum3VCr
         LlWw==
X-Gm-Message-State: AOAM530ePUuMUw6lUogb8o7VqzjUHj3oIjF5ZT4r+ARO6szgALZldzJA
        vjEdOTKqS5aBqBaQOZhhehC1anohUmndqZbGJPY=
X-Google-Smtp-Source: ABdhPJzqdA6R5f+klhy+suC/ApPphpU0wOgsRSri5kuKmfvW3O4+FjNRwo/2t7jZ8MvxZb4PG2Etlw==
X-Received: by 2002:a63:191d:: with SMTP id z29mr3833413pgl.358.1640197302908;
        Wed, 22 Dec 2021 10:21:42 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y11sm3488483pfi.80.2021.12.22.10.21.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Dec 2021 10:21:42 -0800 (PST)
Message-ID: <61c36cb6.1c69fb81.be5d6.9155@mx.google.com>
Date:   Wed, 22 Dec 2021 10:21:42 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.10.88-8-g724ee70700b6
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/5.10
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.10 baseline: 194 runs,
 1 regressions (v5.10.88-8-g724ee70700b6)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 194 runs, 1 regressions (v5.10.88-8-g724ee70=
700b6)

Regressions Summary
-------------------

platform        | arch  | lab          | compiler | defconfig              =
    | regressions
----------------+-------+--------------+----------+------------------------=
----+------------
meson-gxbb-p200 | arm64 | lab-baylibre | gcc-10   | defconfig+arm64-chromeb=
ook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.88-8-g724ee70700b6/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.88-8-g724ee70700b6
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      724ee70700b640c565b51e5942719d88a6993eae =



Test Regressions
---------------- =



platform        | arch  | lab          | compiler | defconfig              =
    | regressions
----------------+-------+--------------+----------+------------------------=
----+------------
meson-gxbb-p200 | arm64 | lab-baylibre | gcc-10   | defconfig+arm64-chromeb=
ook | 1          =


  Details:     https://kernelci.org/test/plan/id/61c334a27d9dc9691e39714a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.88-=
8-g724ee70700b6/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/baseli=
ne-meson-gxbb-p200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.88-=
8-g724ee70700b6/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/baseli=
ne-meson-gxbb-p200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61c334a27d9dc9691e397=
14b
        new failure (last pass: v5.10.87-98-g493843b2b209) =

 =20
