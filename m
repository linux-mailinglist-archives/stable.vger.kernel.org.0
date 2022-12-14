Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC08E64CF07
	for <lists+stable@lfdr.de>; Wed, 14 Dec 2022 19:00:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237499AbiLNSAI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Dec 2022 13:00:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229550AbiLNSAG (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Dec 2022 13:00:06 -0500
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 188369FEA
        for <stable@vger.kernel.org>; Wed, 14 Dec 2022 10:00:06 -0800 (PST)
Received: by mail-pl1-x632.google.com with SMTP id d3so4122505plr.10
        for <stable@vger.kernel.org>; Wed, 14 Dec 2022 10:00:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=ODzDQIco2nMmGNQ79ff7OzjRz9e2ODpJgM9Gcb75Ji0=;
        b=KWWL7xorqA8RFY4JCUtxg+QBiHXBf3XgO9PzObfRpUxDIYQp5UUgRxkcOxusxKCxhT
         RnN2JyfYrfrOHU16HAnNHR0WE4TEo6L6AVawPMlSHJ8JFqUdmyk1ysyjoW/9lCF7N90e
         EZI3B1IngfSkBooTa4cgdiwDmrm6ugn28IM56r9X5lVA9mi8LyVxR+8p7w3eoTALvIYh
         G3rEfK9NX3qhildqg3rP4pBP30rsKmMse84aQkuuJRy2QsBX8D+yUpV4O71RC2x9rWxO
         Dxsc7W44sCueZaV9qd9FyFDEFyAGP0b4lhQesABB0eVdAvlDG+qFeyHxtJBjks6J3XK3
         B9bQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ODzDQIco2nMmGNQ79ff7OzjRz9e2ODpJgM9Gcb75Ji0=;
        b=hFTsW7e5UNGtcqrzV5+pDmjjgqCA5d/pJqkJWS3BF+2ghjxW/nDirurxmXAohu1MfG
         5E4/UdLkhR6jpFDLUfbEmMt8xldFTIUxS3S3OHzb5WFyAL+a5u60P5dtku8/sWGm9i8P
         88yl01GayTeG1QlO7UcAu5JBCsv/rhVD7hnfdB6RDVlps4bEA97hXuroHNgY1pjYpLk4
         Ye89C+kzPMO8g7c7k8unsgF0LJ0b0KmvClajTjDqQ/h6uPtDJ2pziDL2wocg9R2libqd
         sxInMveQiDWQ74KXLqS6rJ+ZEYetc3CZFlXcs/tQWvgxVMNpATrIrxEtEh4MeMAKGBrn
         AVPA==
X-Gm-Message-State: ANoB5pmEOdIfTlFi+Hs0GZe4FyfW26GdOZGwbu//CIPzHe1RxfMHwRVz
        n3qDCRU1bIhFYsABI8BHkUWYP+ofP3A61HUDA6Oesg==
X-Google-Smtp-Source: AA0mqf7FEqkfBCQv+ROqAcpjX4LmZXnRYDTNf1V5/uXto5kOIbSwHqtRtfNknx+h3MiLQmptLgMIfA==
X-Received: by 2002:a17:903:1d1:b0:189:c47b:af27 with SMTP id e17-20020a17090301d100b00189c47baf27mr34791871plh.10.1671040803728;
        Wed, 14 Dec 2022 10:00:03 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id o9-20020a170902d4c900b001896522a23bsm2203035plg.39.2022.12.14.10.00.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Dec 2022 10:00:03 -0800 (PST)
Message-ID: <639a0f23.170a0220.e08b.4eaf@mx.google.com>
Date:   Wed, 14 Dec 2022 10:00:03 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Kernel: v4.19.269
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable
Subject: stable/linux-4.19.y baseline: 89 runs, 1 regressions (v4.19.269)
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

stable/linux-4.19.y baseline: 89 runs, 1 regressions (v4.19.269)

Regressions Summary
-------------------

platform          | arch | lab     | compiler | defconfig          | regres=
sions
------------------+------+---------+----------+--------------------+-------=
-----
r8a7743-iwg20d-q7 | arm  | lab-cip | gcc-10   | shmobile_defconfig | 1     =
     =


  Details:  https://kernelci.org/test/job/stable/branch/linux-4.19.y/kernel=
/v4.19.269/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-4.19.y
  Describe: v4.19.269
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      c652c812211c7a427d16be1d3f904eb02eb4265f =



Test Regressions
---------------- =



platform          | arch | lab     | compiler | defconfig          | regres=
sions
------------------+------+---------+----------+--------------------+-------=
-----
r8a7743-iwg20d-q7 | arm  | lab-cip | gcc-10   | shmobile_defconfig | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/6399d646341133a5812abd28

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: shmobile_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.269/=
arm/shmobile_defconfig/gcc-10/lab-cip/baseline-r8a7743-iwg20d-q7.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.269/=
arm/shmobile_defconfig/gcc-10/lab-cip/baseline-r8a7743-iwg20d-q7.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221209.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6399d646341133a5812ab=
d29
        failing since 18 days (last pass: v4.19.266, first fail: v4.19.267) =

 =20
