Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A71F4FC6C5
	for <lists+stable@lfdr.de>; Mon, 11 Apr 2022 23:32:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241048AbiDKVfG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Apr 2022 17:35:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231789AbiDKVfF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Apr 2022 17:35:05 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B3F2B7EE
        for <stable@vger.kernel.org>; Mon, 11 Apr 2022 14:32:50 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id y6so15000901plg.2
        for <stable@vger.kernel.org>; Mon, 11 Apr 2022 14:32:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=2O/1H/cWPtNMzJhv+uB3Ha/iZJCf9h3AifpxsaNU3HU=;
        b=ZaVAUolgRWXusocU/BJMppIyGvnfImFcSOE1otsZpF+UK9Ofk/36KigD94gBDqdrcb
         NtvNLnMaPqtQuS3k50qOxPRzCWacnbKO5CZ55c80U9mTF2dHCPLuGNZeREveHjZoq1LO
         /vwC8/rvA93Pu9VRi0/y7jh3S8Ys7zVfFeQjIxFaf3wKepzuvuD31eiw0FZBQZjA/P94
         +7dZ1Q/fL4JGFoUSULsvm3ky4HYmky52+qjeBTMv1ohvtBw6CjmxuJF/Y9UKHISZ16Dt
         giAyXw6WRLTRPKe0IAPkg+LOJn2aD4ktskArTzn4plZiZwRxV6VfNPIYkYDKWj9LHgdi
         SENg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=2O/1H/cWPtNMzJhv+uB3Ha/iZJCf9h3AifpxsaNU3HU=;
        b=rxseRqOHC31ZDa8V3N7CJzXH1G3q2Zj/eocbOWvajSfxe8vnF6T4h84tMztq3+T5E6
         PY1Dj6+yQzelqnJfoQdxILP3PUGGvm6MR/Buzzs/C5riC7ruoDURxpufx+MpPBDYwMOw
         tvt3qHQZhVJw5y9wkjMwsoL3e+qzZBM6sjSpJeg314AI7N8GGfW5Jhm8pKDax8hDcDL7
         MLECzApKoCRUXPWkS6UMXb8l/i3KfXUdZQeJREu9UTjbqg5HaQtUXt4dGD+jTxts9Ty/
         2wrYnnr/XeDp065NjRSFfnvDY9tnzzifF79Q8QdLOmYz4t0diWVGK6IVxJHvEt1Lvp5a
         p8sQ==
X-Gm-Message-State: AOAM531+4UYGXjx5ZIxE2r82MLeLhK7xUi+4fT9J2RgK9HxpHxR6kzUU
        0v5c/osOGQk5YCAIPd58TPOe/I5+mwIM/byz
X-Google-Smtp-Source: ABdhPJzxm7ou5vjKE6zMl5/qH3OT/yKALqweIVC8D6bmMy4u9sanXOK9ESg0tSv3Nb6pedbBNbb8fQ==
X-Received: by 2002:a17:902:dac5:b0:158:5db6:3506 with SMTP id q5-20020a170902dac500b001585db63506mr7725272plx.0.1649712769707;
        Mon, 11 Apr 2022 14:32:49 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id nv11-20020a17090b1b4b00b001c71b0bf18bsm413279pjb.11.2022.04.11.14.32.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Apr 2022 14:32:48 -0700 (PDT)
Message-ID: <62549e80.1c69fb81.2d8ae.1736@mx.google.com>
Date:   Mon, 11 Apr 2022 14:32:48 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.16.y
X-Kernelci-Kernel: v5.16.19-286-g99cc9cff3df49
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-5.16.y baseline: 136 runs,
 2 regressions (v5.16.19-286-g99cc9cff3df49)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.16.y baseline: 136 runs, 2 regressions (v5.16.19-286-g99c=
c9cff3df49)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
at91sam9g20ek    | arm   | lab-broonie   | gcc-10   | at91_dt_defconfig    =
      | 1          =

rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.16.y/ker=
nel/v5.16.19-286-g99cc9cff3df49/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.16.y
  Describe: v5.16.19-286-g99cc9cff3df49
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      99cc9cff3df49971793874e9660cec2903899c25 =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
at91sam9g20ek    | arm   | lab-broonie   | gcc-10   | at91_dt_defconfig    =
      | 1          =


  Details:     https://kernelci.org/test/plan/id/625468e119e843a367ae06a1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: at91_dt_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.16.y/v5.16.1=
9-286-g99cc9cff3df49/arm/at91_dt_defconfig/gcc-10/lab-broonie/baseline-at91=
sam9g20ek.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.16.y/v5.16.1=
9-286-g99cc9cff3df49/arm/at91_dt_defconfig/gcc-10/lab-broonie/baseline-at91=
sam9g20ek.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220401.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/625468e119e843a367ae0=
6a2
        new failure (last pass: v5.16.18-1015-g18299e64680a0) =

 =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62546cf1892729346fae069e

  Results:     88 PASS, 4 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.16.y/v5.16.1=
9-286-g99cc9cff3df49/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/=
baseline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.16.y/v5.16.1=
9-286-g99cc9cff3df49/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/=
baseline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220401.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/62546cf1892729346fae06bf
        failing since 36 days (last pass: v5.16.12, first fail: v5.16.12-16=
6-g373826da847f)

    2022-04-11T18:01:10.335206  /lava-6064557/1/../bin/lava-test-case   =

 =20
