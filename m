Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A940638A58
	for <lists+stable@lfdr.de>; Fri, 25 Nov 2022 13:42:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229480AbiKYMmI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Nov 2022 07:42:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229827AbiKYMl7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Nov 2022 07:41:59 -0500
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E072134
        for <stable@vger.kernel.org>; Fri, 25 Nov 2022 04:41:58 -0800 (PST)
Received: by mail-pf1-x432.google.com with SMTP id 9so4047358pfx.11
        for <stable@vger.kernel.org>; Fri, 25 Nov 2022 04:41:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=4WujkcxFS1qhv8eTWhTo8Sn5jZqpxf0ADdmIDolNtmM=;
        b=kNOAHtLUoOtFDyGTsWP3oS6ekXdC2O/ZZiCzlndOj/K46ogmxYOlKBrOp7j78SFbVf
         xNhpHSA+E4nuelNqYK8wcJL31IX+bsEWwlaafnw0Qk+2aOFy+zXMV2Sb1ALZqmptSIjf
         KwCRZCh0c2YGRnQNu8Z0bq5vidltdt1pePJnh3g2i/L5a5Hga5/FaaKQWC0BgHcRAJB9
         vqTo0lONO1uYuHegMTYgole+tX7hXAGa/bc3Gf8dH+AADYwEaRvgIqFBquiN7/2ALm+Y
         v1983B/LRq37sy8AYDNCRK829uu51XgzmE/gQJbNCOU7B72Mfs1X4PWgpIKMOQjjUYTa
         Dccw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4WujkcxFS1qhv8eTWhTo8Sn5jZqpxf0ADdmIDolNtmM=;
        b=BkUuw4C26RlB2i7IwC+NcadkbecOisRWZUY7Zbv9CKOttXauX3Z41TDRBdzGeRC+Zu
         N/lHr+NEYioSH9U0qcs+lEkcskj6IjhKzUmoCFb4mRid+zxBOhjdmX/Uvk7n7HF7HwXt
         t+Cp7BILnOta1aQYmZWAZRwpPr99ZE6Vi3nbHiz1lPyuYd7uHaZ9UmC7gVt3FoMsyhJz
         j4bcCcCokrhel6e5ElBy/hz0XxXC0H7QNTORmfcKQmGPYsZIwEsjswluIqt1kA7XcvM/
         oisOIxhSpIo5xpF98M9Z8HRzlElxQJhUPO9VIbj+bd52ZWtU9yU2OESecjTxa/Mc7Vss
         OZ0A==
X-Gm-Message-State: ANoB5pkWXciKRStDslLciPwbKNP3Y2ky0K+gJOZ7T1G5+nyKaiVhzyKv
        GWx5nSqg1dh8mFo4Q2rkIiTIAQsKWt0OCnZ1DTM=
X-Google-Smtp-Source: AA0mqf6g+YRT9yhq0QHlxnPDoMMO6gABO98g0htckE0DEpplAYF7mCvOQlVsKsL//hzoX4Yo16DOSw==
X-Received: by 2002:a63:5325:0:b0:470:6559:a538 with SMTP id h37-20020a635325000000b004706559a538mr15265744pgb.427.1669380117493;
        Fri, 25 Nov 2022 04:41:57 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id f17-20020a170902f39100b00186efc56ab9sm3239869ple.221.2022.11.25.04.41.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Nov 2022 04:41:56 -0800 (PST)
Message-ID: <6380b814.170a0220.4ce1e.4248@mx.google.com>
Date:   Fri, 25 Nov 2022 04:41:56 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.15
X-Kernelci-Kernel: v5.15.79-180-g8c27062366ee
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.15 baseline: 124 runs,
 2 regressions (v5.15.79-180-g8c27062366ee)
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

stable-rc/queue/5.15 baseline: 124 runs, 2 regressions (v5.15.79-180-g8c270=
62366ee)

Regressions Summary
-------------------

platform    | arch | lab     | compiler | defconfig           | regressions
------------+------+---------+----------+---------------------+------------
imx7ulp-evk | arm  | lab-nxp | gcc-10   | imx_v6_v7_defconfig | 1          =

imx7ulp-evk | arm  | lab-nxp | gcc-10   | multi_v7_defconfig  | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.79-180-g8c27062366ee/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.79-180-g8c27062366ee
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      8c27062366eea1c27fa7d7430352a15590c1336b =



Test Regressions
---------------- =



platform    | arch | lab     | compiler | defconfig           | regressions
------------+------+---------+----------+---------------------+------------
imx7ulp-evk | arm  | lab-nxp | gcc-10   | imx_v6_v7_defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/63808759129f94f3192abd10

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.79-=
180-g8c27062366ee/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-e=
vk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.79-=
180-g8c27062366ee/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-e=
vk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221107.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63808759129f94f3192ab=
d11
        failing since 60 days (last pass: v5.15.70-117-g5ae36aa8ead6e, firs=
t fail: v5.15.70-133-gbad831d5b9cf) =

 =



platform    | arch | lab     | compiler | defconfig           | regressions
------------+------+---------+----------+---------------------+------------
imx7ulp-evk | arm  | lab-nxp | gcc-10   | multi_v7_defconfig  | 1          =


  Details:     https://kernelci.org/test/plan/id/638088d64ae91cee282abd23

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.79-=
180-g8c27062366ee/arm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-ev=
k.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.79-=
180-g8c27062366ee/arm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-ev=
k.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221107.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/638088d64ae91cee282ab=
d24
        failing since 60 days (last pass: v5.15.69-44-g09c929d3da79, first =
fail: v5.15.70-123-gaf951c1b9b36) =

 =20
