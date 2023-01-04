Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FE6165DB32
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 18:21:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231423AbjADRVm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 12:21:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240133AbjADRVl (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 12:21:41 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A3553BE
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 09:21:40 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id v23so36780711pju.3
        for <stable@vger.kernel.org>; Wed, 04 Jan 2023 09:21:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=Nzx1VLkmRM8JuGCQk+EXKB2ofWvng+lCPd5jz6/jWDM=;
        b=vQkNzue/yLKs0fYCADD3JXpamOfzAczw9z9rzd138Urp0Yfu/Pvwa4TWUWwX2ywrs4
         63PGCtN0xbcbTEivQcXQUWFNtRXtwZyOQHTRR27BkNuSgpuGguHMCc8S1KvV5oQzmJ1y
         M3l7wnA+l/GYxHLbq0EHN+2Tn3XfdfVPatrU1tz+X9SqCrrTizqRhiuFr/MoUE5oLphk
         FrDhVkp1XW9/zpqI0fnO76cm9+AGVqDHoPC6EBrQ0mRupoCv+6r577YAQBqkSSRi/SL1
         sICBXJeba5uiXqxqXkqNvyZ1H/Qe571U2D6KUhWwWYlj8DTQFVk3avW2D2FYNlqXJyZ+
         ZYnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Nzx1VLkmRM8JuGCQk+EXKB2ofWvng+lCPd5jz6/jWDM=;
        b=zk9EeF6BKCzi4QLxYZvPIV1M5RAJ59UWEnuRA7b4irbjlBQHqlJB+m1kYFS7aHCJNn
         L5j2NwGKwyu5PDtYRjcitCzlv6skXyWHddEkPMmlCq53VbratWU39P+NNLb0cxbnGxYb
         TMaddeG+OU41a1+sBtSvHEkNM7CF2d6lIxBh/c2pImBzlFmQqEDy7KxBd32lsR2ooYXT
         TBjoKQLBIeLsC7SLTmkw+YyaQ/R8qSZu6h2ZvIMznE6ytNSxInoLCGAJ+BvdO45wv4/G
         GWrvMkfklOS69Ck7X6nBoUSGYobCPORt4/D1Ao8mvKDKl9CohYoOq/00lrO4VL+lYCYW
         M91g==
X-Gm-Message-State: AFqh2kozIf9Tyyb0aHGWFmXuwYBBwaI4cMIOsYM+HMgfgCfpYs2RV6ID
        AMwejiGBCVEl0HvRKnQ76sG0eXwbUjrw00DCO5rK0Q==
X-Google-Smtp-Source: AMrXdXsCGUmx8d8dJRP5zzPrGrdBvbMIulqtA3C/L+o3XzIIgjsVZC3IzCO5ONpnPBExtUQA+Pd1UQ==
X-Received: by 2002:a05:6a20:1586:b0:ad:5a5d:3571 with SMTP id h6-20020a056a20158600b000ad5a5d3571mr73500781pzj.4.1672852899302;
        Wed, 04 Jan 2023 09:21:39 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id a10-20020a1709027e4a00b0018913417ba2sm21945219pln.130.2023.01.04.09.21.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Jan 2023 09:21:38 -0800 (PST)
Message-ID: <63b5b5a2.170a0220.fec3a.20d3@mx.google.com>
Date:   Wed, 04 Jan 2023 09:21:38 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.10.162
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.10.y
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-5.10.y baseline: 127 runs, 1 regressions (v5.10.162)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.10.y baseline: 127 runs, 1 regressions (v5.10.162)

Regressions Summary
-------------------

platform          | arch | lab     | compiler | defconfig          | regres=
sions
------------------+------+---------+----------+--------------------+-------=
-----
r8a7743-iwg20d-q7 | arm  | lab-cip | gcc-10   | shmobile_defconfig | 1     =
     =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.10.y/ker=
nel/v5.10.162/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.10.y
  Describe: v5.10.162
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      0fe4548663f7dc2c3b549ef54ce9bb6d40a235be =



Test Regressions
---------------- =



platform          | arch | lab     | compiler | defconfig          | regres=
sions
------------------+------+---------+----------+--------------------+-------=
-----
r8a7743-iwg20d-q7 | arm  | lab-cip | gcc-10   | shmobile_defconfig | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/63b5837fc1634ca0c84eef60

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: shmobile_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
62/arm/shmobile_defconfig/gcc-10/lab-cip/baseline-r8a7743-iwg20d-q7.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
62/arm/shmobile_defconfig/gcc-10/lab-cip/baseline-r8a7743-iwg20d-q7.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221230.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63b5837fc1634ca0c84ee=
f61
        failing since 6 days (last pass: v5.10.161-561-g6081b6cc6ce7, first=
 fail: v5.10.161-575-g2bd054a0af64) =

 =20
