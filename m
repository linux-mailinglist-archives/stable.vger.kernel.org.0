Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 480FA65DFA9
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 23:12:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240478AbjADWMj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 17:12:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240460AbjADWMi (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 17:12:38 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E1D4193E7
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 14:12:38 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id j8-20020a17090a3e0800b00225fdd5007fso26337538pjc.2
        for <stable@vger.kernel.org>; Wed, 04 Jan 2023 14:12:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=fCrMf+Z6XPoVo8S3/t28vRvPxz9O3X+d8qqQMB2m1uc=;
        b=lfl7WkbV8lDxJM0lgBc8hUPekfBbTuPDwHzO7PSSJ+T684ZZCsVmSyR5pTf+3joNCS
         o89rlXRMfCz9fiGSPFsAeZDB2wul+Emo192CIIUJuuauJCnyqQFKapdUcld2F7LrgjUy
         zd19yZ+M7Ci0G0tQe85zlWzNkeWGNloU4fOh3FuN/E+Ozp5mihllsT1irkElDOU/g+rF
         9ldlMj0BOMX3y+9AEqiPS8aXB3Ld0JmOHoElsPUGi7+8UbX7X3I5EZeAeSXidzqiPr7D
         wcTv+CcfdZpVlYBgsIm3HbI7XTDcnQ5IBwf+CfZlBsrOwvi1B7oBBH++hgq2YiCX68FU
         xMDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fCrMf+Z6XPoVo8S3/t28vRvPxz9O3X+d8qqQMB2m1uc=;
        b=wZbcmJrxwwYomGxqaAxit/haD7cioU6NW+fts2NqAYE9P4+UA8/YYZ9hDq36A1ZXnx
         +coxIFjQfJMcD1ZbMrHw+HyPK0+ZRI/+ZY99vg4lDBJDpBkcJ6xVayovWgt2yMffdOAv
         3qYlHR+rL1er4efigQrt6xFk/QEem0K5hGKv+Jm6Tdku8C4ebAav6Q8b3hh93GmodgbR
         CWL4BHCaf8BIY51peIcXxYUoEdjTrJ6DzcN8HdcfpnkKS2F7qGcFcAT/CXvzpDPoylv8
         f6fBZXTBv6ZlZs5RtjoG8udAhJxQIaoYepOD7XfMBA59OLUlfPwchzZbu/4eH3fH2tAB
         UfEQ==
X-Gm-Message-State: AFqh2kokeklyY85okFTNg+QoZD7ZEOTKIG8J4J9AcyQpDasD9HxcBuB7
        j8zSAndDRc8gTYMvNbhNEWELnuNf/q+ldNqsnYNQDg==
X-Google-Smtp-Source: AMrXdXve9Xloiv6NNc0f3YVkhSA4/T9Lq2amcBiZlq/xUcLgEuBqKgSU1br2Hkah6txKoxT2fOPKbg==
X-Received: by 2002:a17:90b:198f:b0:226:28aa:eb17 with SMTP id mv15-20020a17090b198f00b0022628aaeb17mr25227066pjb.11.1672870357343;
        Wed, 04 Jan 2023 14:12:37 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id ha24-20020a17090af3d800b00225d92d69b6sm41181pjb.29.2023.01.04.14.12.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Jan 2023 14:12:37 -0800 (PST)
Message-ID: <63b5f9d5.170a0220.359f7.0193@mx.google.com>
Date:   Wed, 04 Jan 2023 14:12:37 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.10.162-691-g2ce514230813
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.10.y
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-5.10.y baseline: 76 runs,
 1 regressions (v5.10.162-691-g2ce514230813)
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

stable-rc/linux-5.10.y baseline: 76 runs, 1 regressions (v5.10.162-691-g2ce=
514230813)

Regressions Summary
-------------------

platform          | arch | lab     | compiler | defconfig          | regres=
sions
------------------+------+---------+----------+--------------------+-------=
-----
r8a7743-iwg20d-q7 | arm  | lab-cip | gcc-10   | shmobile_defconfig | 1     =
     =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.10.y/ker=
nel/v5.10.162-691-g2ce514230813/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.10.y
  Describe: v5.10.162-691-g2ce514230813
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      2ce514230813552874a3d82acdd38a3402b144c3 =



Test Regressions
---------------- =



platform          | arch | lab     | compiler | defconfig          | regres=
sions
------------------+------+---------+----------+--------------------+-------=
-----
r8a7743-iwg20d-q7 | arm  | lab-cip | gcc-10   | shmobile_defconfig | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/63b5c2633edd4ebcd54eee81

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: shmobile_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
62-691-g2ce514230813/arm/shmobile_defconfig/gcc-10/lab-cip/baseline-r8a7743=
-iwg20d-q7.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
62-691-g2ce514230813/arm/shmobile_defconfig/gcc-10/lab-cip/baseline-r8a7743=
-iwg20d-q7.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221230.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63b5c2633edd4ebcd54ee=
e82
        failing since 7 days (last pass: v5.10.161-561-g6081b6cc6ce7, first=
 fail: v5.10.161-575-g2bd054a0af64) =

 =20
