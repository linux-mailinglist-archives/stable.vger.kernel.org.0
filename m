Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1E255B7936
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 20:13:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230315AbiIMSNi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 14:13:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232332AbiIMSNO (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 14:13:14 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DC0D8B997
        for <stable@vger.kernel.org>; Tue, 13 Sep 2022 10:19:57 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id c2so12516307plo.3
        for <stable@vger.kernel.org>; Tue, 13 Sep 2022 10:19:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date;
        bh=jasweIiuk5R989HCbLs3jx8HPWD9dgnRtyzjqzDdwJM=;
        b=S2aRRz4u7B8gUt7FWqtmDy49IrUjMkPAUva1OaW4Z6M014oQbWe3jiQpD+Tq47qI2W
         S9TD/MKfZN/OITX8ZZm20QvCY4hQXmS3Mj1ykwTDOTrFv7CwJcQ9h5ZUgPBeDR/6rg9i
         mZ3X145+PUokFO3pEiDzR/OJFOjjHzJ9EFbTAkotteR95zOZg6iBvTpekezpb+ICt1NK
         Aq2nSgXUVnzQXR0G0a0GVtqr5gXJZiHujUC2ypayu/t6MyAQlNZaIxqpSVI+I/XC33U0
         7hV+eXiy+bumqWGM8OEHbzzrd6/UvcdYGc/4nXDjs4NyLoeSXcVHgV3ZpIMRqnyelUMB
         2SMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date;
        bh=jasweIiuk5R989HCbLs3jx8HPWD9dgnRtyzjqzDdwJM=;
        b=H+rUVUy6Hjfhq/Qm/3cLTLkXNT1AN9eYu5CTZtztzmlMbON1JhTzsE+EWhEQaSbdiQ
         z3/rDIwzPYPXPf5omjYrpC76h8js7bR0askpaBRmEiqOACrI4rXMPx6e45o+sHv0cbX7
         FtkWmND4B8Nw6wMGOF2+i4S+Zh/doSmGVxGQFtv8R5KJJpfaBMloLFhlgzw1uj9X4B+O
         CCTtMVvKjM9vhNQyqUXB+v5MGK0CFASDC6g6WbdulB65qA41Bn36ya70BsxXx0GTOQMJ
         Xi2sIhMPLY60wqWMcF8MGvwwvlb4ms+5h500PkEF9CDpEHWfvHkmZpd27yfiymu1QkhD
         WGXw==
X-Gm-Message-State: ACgBeo0dMWczBtIW6mYstp8PBKDlRdl8PW2tJ4KoKlRPeRqhAVb6Kmim
        HMdvAsHCA0clxZKYQ6OXg3LzJ8VjgJmJdhA159A=
X-Google-Smtp-Source: AA6agR6MN2dNdmeHOipCntpZe4fnuvi4mECFJ9lVfPnJNOjb+CMBeGMPOhvBa41BTLRVLnth4ZagaQ==
X-Received: by 2002:a17:903:32cf:b0:178:3d49:45b0 with SMTP id i15-20020a17090332cf00b001783d4945b0mr7547070plr.5.1663089596922;
        Tue, 13 Sep 2022 10:19:56 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id h9-20020a056a00000900b0053e5daf1a25sm8210323pfk.45.2022.09.13.10.19.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Sep 2022 10:19:56 -0700 (PDT)
Message-ID: <6320bbbc.050a0220.f2894.e091@mx.google.com>
Date:   Tue, 13 Sep 2022 10:19:56 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.15
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.15.66-120-gc6dfe18a873b2
Subject: stable-rc/queue/5.15 baseline: 177 runs,
 1 regressions (v5.15.66-120-gc6dfe18a873b2)
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

stable-rc/queue/5.15 baseline: 177 runs, 1 regressions (v5.15.66-120-gc6dfe=
18a873b2)

Regressions Summary
-------------------

platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.66-120-gc6dfe18a873b2/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.66-120-gc6dfe18a873b2
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      c6dfe18a873b28694fd6cbbc47647e4a06091b04 =



Test Regressions
---------------- =



platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/63208ae0431fcdd0c935566d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.66-=
120-gc6dfe18a873b2/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-bea=
gle-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.66-=
120-gc6dfe18a873b2/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-bea=
gle-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63208ae0431fcdd0c9355=
66e
        failing since 166 days (last pass: v5.15.31-2-g57d4301e22c2, first =
fail: v5.15.31-3-g4ae45332eb9c) =

 =20
