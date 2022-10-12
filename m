Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E3C55FC71D
	for <lists+stable@lfdr.de>; Wed, 12 Oct 2022 16:18:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229624AbiJLOR5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Oct 2022 10:17:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229577AbiJLORz (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Oct 2022 10:17:55 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E641880BFD
        for <stable@vger.kernel.org>; Wed, 12 Oct 2022 07:17:53 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id a6-20020a17090abe0600b0020d7c0c6650so2155406pjs.0
        for <stable@vger.kernel.org>; Wed, 12 Oct 2022 07:17:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=7sw9fzernBVGLkxptjAEGFBhoJyafwfwT7RVkPosHgE=;
        b=6jGzgo9Qiewe8MF1UfCz36Jcc+NYydkdfXbmtkhAExUu3evI+ibxunZl8GMFQZzCMc
         QNF/i3JOQPyCyToY6r9m19+wMVx/B47l5GaohgGjIvQpcS6eI+vvirBNnLvSxSPvFIaG
         a8xWR6DMOyjs6UPjdWsnzd8SRKgePLhXalqYU/MnS9oQPWofmEQMYyATRWxOB7seJqkw
         GRnXIvH9UvX0LK35STVkUaUVa4+TBlllhWxOgHjKvatU8D0k3REIx5zoFz1R/PkRDnfy
         lXtZI6vs+DE/wmbVvYBFlMdmIAWcVMpBucUNYkPZAEVANteayB5q6Px+hCauAiHFx1nm
         6pIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7sw9fzernBVGLkxptjAEGFBhoJyafwfwT7RVkPosHgE=;
        b=rt35Rx/7r31CeHFBiQE6IDTTruA9fADKl6Z9HBuykKly/bE8IKaJkgRyUcwXIXX3a1
         8g1WmaVSaeivSDNcW3mjc76U3FtYzVIoNHima7H++d15/EP3NM7wjx47pZvkIzfk5kv7
         OBMLS5XvdmYwupRArpSd1I4w4e6OEoQJf9Wyx0s8p1IVdGL0H1Psw8fgTj3SZwtpi14f
         yodjf/csTNNOVDT99oXSeY11ZPo1Jj08BbAaQvocSepOEeEGhTSmq5yIJdmHTpxGImWO
         YLQGteqxkanJ2ffOkoYfYbEn2Hk2ucySVZ/0ssYVQCJt5IHsweL3o8MxoFMnbPLbO9U5
         yMew==
X-Gm-Message-State: ACrzQf2F1Gw3E08Xiv5aVa70L52PUVkpZwNbugBE95Ap0WlV/bqFXmsh
        MqggEUGSDwwbkJUuKr5O3JieExqDcsA841o0wCg=
X-Google-Smtp-Source: AMsMyM430+Q6iUb/lJ+fJoyChY++TTJDx8lxKwFE1GvC1RzlrmSv5ATwWEWEpMuH0LIM+LcLB8zLAQ==
X-Received: by 2002:a17:90b:4a43:b0:20d:8948:1733 with SMTP id lb3-20020a17090b4a4300b0020d89481733mr4421027pjb.79.1665584273215;
        Wed, 12 Oct 2022 07:17:53 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id oa10-20020a17090b1bca00b0020d747a6ebcsm1534694pjb.50.2022.10.12.07.17.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Oct 2022 07:17:52 -0700 (PDT)
Message-ID: <6346cc90.170a0220.89ed3.2d0d@mx.google.com>
Date:   Wed, 12 Oct 2022 07:17:52 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.15
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.15.72-36-g3886958cda706
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.15 baseline: 112 runs,
 2 regressions (v5.15.72-36-g3886958cda706)
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

stable-rc/queue/5.15 baseline: 112 runs, 2 regressions (v5.15.72-36-g388695=
8cda706)

Regressions Summary
-------------------

platform    | arch | lab     | compiler | defconfig           | regressions
------------+------+---------+----------+---------------------+------------
imx7ulp-evk | arm  | lab-nxp | gcc-10   | imx_v6_v7_defconfig | 1          =

imx7ulp-evk | arm  | lab-nxp | gcc-10   | multi_v7_defconfig  | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.72-36-g3886958cda706/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.72-36-g3886958cda706
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      3886958cda706857bb94fa0a830bfcc20f703c89 =



Test Regressions
---------------- =



platform    | arch | lab     | compiler | defconfig           | regressions
------------+------+---------+----------+---------------------+------------
imx7ulp-evk | arm  | lab-nxp | gcc-10   | imx_v6_v7_defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/6346985a28212d8287cab68f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.72-=
36-g3886958cda706/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-e=
vk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.72-=
36-g3886958cda706/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-e=
vk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221007.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6346985a28212d8287cab=
690
        failing since 16 days (last pass: v5.15.70-117-g5ae36aa8ead6e, firs=
t fail: v5.15.70-133-gbad831d5b9cf) =

 =



platform    | arch | lab     | compiler | defconfig           | regressions
------------+------+---------+----------+---------------------+------------
imx7ulp-evk | arm  | lab-nxp | gcc-10   | multi_v7_defconfig  | 1          =


  Details:     https://kernelci.org/test/plan/id/634699c2e846f3e585cab643

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.72-=
36-g3886958cda706/arm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-ev=
k.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.72-=
36-g3886958cda706/arm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-ev=
k.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221007.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/634699c2e846f3e585cab=
644
        failing since 16 days (last pass: v5.15.69-44-g09c929d3da79, first =
fail: v5.15.70-123-gaf951c1b9b36) =

 =20
