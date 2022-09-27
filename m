Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92EE05ECC86
	for <lists+stable@lfdr.de>; Tue, 27 Sep 2022 21:00:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230445AbiI0TAA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Sep 2022 15:00:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230081AbiI0S77 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Sep 2022 14:59:59 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02F7AA2209
        for <stable@vger.kernel.org>; Tue, 27 Sep 2022 11:59:58 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id v10-20020a17090a634a00b00205e48cf845so1220844pjs.4
        for <stable@vger.kernel.org>; Tue, 27 Sep 2022 11:59:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date;
        bh=CpHCPXP2YW12GQuUF579JxUL1N7GFJ272ozln2YOAbU=;
        b=rYghNKVtYaxKfNh1N3e0opa+Eb4dxJYcC8icFtz3NaIyWxMa3gvwuKFGCQjoarzKKj
         uDrFSQSKKC59p+mRTpGAv1dKdx4WkP9eXy8n/lfQc4H6TUoCSKDVz+iwTYA0/wKKk83X
         zPO1iISMP+H373ddOJnLRGSZo4Z20hl/9GTt/eu1YQjOTcG89ZDi0s3XjyRr0BoAvdz2
         o5d7VfvhCUxv/KzcK4HvjH8zUVzE9BodN2QmA71iEKqrBhnrlQOTnHtHqLnT4Ji683Ad
         DNuJ339PC96IAg0swjb9Sxf6Z7FYaxWR5iYJsVw5n57tmfla38R/zmMxEG3ejwAmKTry
         piJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date;
        bh=CpHCPXP2YW12GQuUF579JxUL1N7GFJ272ozln2YOAbU=;
        b=TSuYxL4zgzSYumrSSjY39cFtSOc7PPLDHg3LOZTjcJWCHt1iZT/a6Aabo5Mhaat9Kr
         NK0aC50LZMRe/BFCy7i43MvMg22F5iu6/+I7TXVvAhQN7QJlUadmaa2U4InIgdxrUIQc
         7kYYiMjF6kl0R5nVtt+AFxUhRfeUfrbsj4cZUrmBZM40BqgJuWF8Im5lcDmj2GqBOCGE
         Ng4RKVZlka6wNmYfld9qVZrQFpYupAvClXevhoIb27v6MSlXT1gCYUOVx2TiFvY8nDSf
         qvm6ZsAaZV/asKl6+ETzv6EyMVGf4mEGuvEu25+86g2qE829Qu01Wk5lxD0fsrewvf3q
         yMew==
X-Gm-Message-State: ACrzQf0fBcL8Tg1V+B89fiG2kNlLJW3nsX6fdj+T7DMFsUsytnTb2uQn
        65HQirOS3MNmR4WpPEJ9H2XMNx1ohkvnU262
X-Google-Smtp-Source: AMsMyM52nBqJB21ORgArXLQK+tsTvhlAdKzDRDs1pWH+bEYr6xjgTvh4hvTRHLLVMRI0MTEisq7waA==
X-Received: by 2002:a17:903:2290:b0:178:272b:e41e with SMTP id b16-20020a170903229000b00178272be41emr27665642plh.48.1664305197161;
        Tue, 27 Sep 2022 11:59:57 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id w3-20020a170902ca0300b0016f85feae65sm1914514pld.87.2022.09.27.11.59.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Sep 2022 11:59:56 -0700 (PDT)
Message-ID: <6333482c.170a0220.1de4c.35fd@mx.google.com>
Date:   Tue, 27 Sep 2022 11:59:56 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.15.70-143-g91e7595aebe8
X-Kernelci-Branch: queue/5.15
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.15 baseline: 124 runs,
 2 regressions (v5.15.70-143-g91e7595aebe8)
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

stable-rc/queue/5.15 baseline: 124 runs, 2 regressions (v5.15.70-143-g91e75=
95aebe8)

Regressions Summary
-------------------

platform    | arch | lab          | compiler | defconfig           | regres=
sions
------------+------+--------------+----------+---------------------+-------=
-----
imx7ulp-evk | arm  | lab-nxp      | gcc-10   | imx_v6_v7_defconfig | 1     =
     =

panda       | arm  | lab-baylibre | gcc-10   | omap2plus_defconfig | 1     =
     =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.70-143-g91e7595aebe8/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.70-143-g91e7595aebe8
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      91e7595aebe896c634df65d8f1e66faf2361d394 =



Test Regressions
---------------- =



platform    | arch | lab          | compiler | defconfig           | regres=
sions
------------+------+--------------+----------+---------------------+-------=
-----
imx7ulp-evk | arm  | lab-nxp      | gcc-10   | imx_v6_v7_defconfig | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/63330fdb87b9770344ec4ed3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.70-=
143-g91e7595aebe8/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-e=
vk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.70-=
143-g91e7595aebe8/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-e=
vk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63330fdb87b9770344ec4=
ed4
        failing since 1 day (last pass: v5.15.70-117-g5ae36aa8ead6e, first =
fail: v5.15.70-133-gbad831d5b9cf) =

 =



platform    | arch | lab          | compiler | defconfig           | regres=
sions
------------+------+--------------+----------+---------------------+-------=
-----
panda       | arm  | lab-baylibre | gcc-10   | omap2plus_defconfig | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/633327158c59f0ae5dec4eb7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.70-=
143-g91e7595aebe8/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.70-=
143-g91e7595aebe8/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/633327158c59f0ae5dec4=
eb8
        failing since 35 days (last pass: v5.15.61-1-geccb923b9eab2, first =
fail: v5.15.62-232-g7f3b8845612d) =

 =20
