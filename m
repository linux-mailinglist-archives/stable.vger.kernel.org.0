Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B11B64DD8E
	for <lists+stable@lfdr.de>; Thu, 15 Dec 2022 16:16:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229798AbiLOPQO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Dec 2022 10:16:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229975AbiLOPPv (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Dec 2022 10:15:51 -0500
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D86F7C7E
        for <stable@vger.kernel.org>; Thu, 15 Dec 2022 07:15:39 -0800 (PST)
Received: by mail-pl1-x62b.google.com with SMTP id t2so7202904ply.2
        for <stable@vger.kernel.org>; Thu, 15 Dec 2022 07:15:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=dUSZolvoaE/s/fPLFOx0u//WiTYP19h1eHImKSZ3bBM=;
        b=BZhjyfePIugHhkGjjrewrscCAAAA78Vc2GJMvz8pG8/K3mBeanbCg/M0jTt4jMRabh
         /HeO8ScsiXAd5u6rMzfCcyNPDuH6i7OiQpJhcMpCLCQnE2mcWCh1VZLwg09gjPgdroeB
         wD9VL6lltwCzvjInBhwlmLxqV3vHj6MiPbipnNfK8Gb5e0SIsKs96N7lfF4HCbxPhacM
         nPAYnzwtwwpzPys3Zb17J+k+MVAtDbapHw5pouT5+9rBqV1AZuknqBHo1TF/UL/FXuAY
         kuMzNln16Ex9LoBkdLnijm22aa/OCWRLvmr4B/EPKUCzG7wGfI7FyuHSktJIRIEc+Muc
         7Heg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dUSZolvoaE/s/fPLFOx0u//WiTYP19h1eHImKSZ3bBM=;
        b=kNqWvgcmuJKBLqo7pSiQ8/ZlCOk8RMsxn8AemzLWDUvwMmP2/T8SxF7DmvOZS5ReLG
         PTthTDDZptnWPAiVtkQEVGYjdWakMwLnoK8VQYaEItnbz3OLMkGwFrn3O2nLInssfpTA
         Po82quwkMsDpoKKgVLtPhwg2/Q4X5rpJg5u4FdHl/Pe/0XLUhKFZfovNzOyXbYuTeIWc
         CSvLemd2Ug5BniTf6A7OxyzYgM3Xc9ERe6/ZetgdwMkq+4SZ+8W9h1cVz3H7M059Tx0U
         slAOYZfBE2uvIX87Vu3GqBlNKZfcoC9pGQYKp5Z2obIq8iMPtlPvsNiJ7VLxhzvF3Irk
         m0tQ==
X-Gm-Message-State: ANoB5pkDEu2T2HYeFt0iIG+WnYvVf19AKKHK3R7NxiqzlZF2Wi/bcX3j
        TQE6/7+B2qr/tQt9iwYCA+LbGVLp4K8PIokMn28=
X-Google-Smtp-Source: AA0mqf79BGLfYogDGJ1tik5dCc7hfu/a+mMDNJzHm8DhR4EQutfGdjUUwW4nGP4/GAbwoUi3HxoB7w==
X-Received: by 2002:a17:902:c183:b0:189:854e:93a3 with SMTP id d3-20020a170902c18300b00189854e93a3mr28241043pld.69.1671117339056;
        Thu, 15 Dec 2022 07:15:39 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id n7-20020a170902e54700b0018997f6fc88sm3971184plf.34.2022.12.15.07.15.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Dec 2022 07:15:38 -0800 (PST)
Message-ID: <639b3a1a.170a0220.77063.8948@mx.google.com>
Date:   Thu, 15 Dec 2022 07:15:38 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.9
X-Kernelci-Kernel: v4.9.336-3-g71cea72f81b2
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.9 baseline: 89 runs,
 1 regressions (v4.9.336-3-g71cea72f81b2)
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

stable-rc/queue/4.9 baseline: 89 runs, 1 regressions (v4.9.336-3-g71cea72f8=
1b2)

Regressions Summary
-------------------

platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.336-3-g71cea72f81b2/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.336-3-g71cea72f81b2
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      71cea72f81b257b16933d51340f16b5ab0bcb6a7 =



Test Regressions
---------------- =



platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/639afebe1c9db9d5952abcff

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.336-3=
-g71cea72f81b2/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagle-=
xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.336-3=
-g71cea72f81b2/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagle-=
xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221209.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/639afebe1c9db9d5952ab=
d00
        new failure (last pass: v4.9.336-3-g8819f37f1b9c) =

 =20
