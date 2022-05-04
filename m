Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D0EB51ADCF
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 21:30:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235621AbiEDTeG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 15:34:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377517AbiEDTeE (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 15:34:04 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8148186E8
        for <stable@vger.kernel.org>; Wed,  4 May 2022 12:30:26 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id j8so2320530pll.11
        for <stable@vger.kernel.org>; Wed, 04 May 2022 12:30:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=mtrPc0qYiJDedJ8IpxMMTRmqH7Bf2VaQRsxuYOWJC9M=;
        b=PMjn2QX+AlK/3KxX6PG76yF4Eo2MginWtfQ2diwtXnbZF33O/yTEN/6lva2Kf/6mlB
         9FC30LstVhnhniyfcdRqJzd7r/paEbE2qGrW/88790gMsPi5cCDvFh0J05YNnaEaoTAh
         CJ6vV2OKD03oOsShhi2uV/ZbPzigMWI6Q4gMCdIyqh0r09BqP7jP4d3Fg9f+CBqi/yRS
         xkoAF2NUpbLrl/6mOeZCdfYCveEd+o6XHzM/Ic7/cIlzJTwHo+JBnub2dR/RlmBxE3DG
         OI1L0UK8b8iUFu5Vz31RPfmESi525lwHGzL94A3vEy+NwjJrOJbjSYxEk5eKhJdp3Wac
         xgJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=mtrPc0qYiJDedJ8IpxMMTRmqH7Bf2VaQRsxuYOWJC9M=;
        b=FV2QQ8vKzNL/uZ4XFcuZ8aK2aYnPtkY3Q3eJIQoSa/dwNQHeXx8IK19sHxgB8GA8/a
         lj3X2fRhPFiNT9qargTQt6l8zpvtH6Nwjb+AJRqKmDidEytyEhvnqHisN5lLBki7hk4T
         qdmi3ztE6WI3fZXuadzX74AemRWUL4dcuBCvZnwiPSuPNwqcvzvXcHnVanWj8rQ94Ues
         wlraLLFj/VEbXY9MvKAW+YnGMDg73WeBQRxi9EaFReqahQHjWPgBnG00tSq8aNUZh6CQ
         cs/y9YC28A9vc698p8h2jet/jW4Uk4e4sWOj9piSoR2AJCOGTnQe1Z0oyTPZGkOE7Nzh
         qndg==
X-Gm-Message-State: AOAM531vN6vNUPMD70KuazIQNwxz0trRW0UBDpE+vLYbhinkdzHLTbc4
        Fu5WwDBWNOHpUaNDjvlYijWjC4/Q52MOeGi6xsQ=
X-Google-Smtp-Source: ABdhPJz+ned5sN8RlFD8g+OrNVbG7onClbhFlP6qe8ZUtij9C8Rv4cpyQqZrsDUlKVMPvMwru3BL5w==
X-Received: by 2002:a17:902:a981:b0:156:52b2:40d6 with SMTP id bh1-20020a170902a98100b0015652b240d6mr23783781plb.34.1651692626231;
        Wed, 04 May 2022 12:30:26 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id e18-20020a170902ef5200b0015e8d4eb1e2sm8758760plx.44.2022.05.04.12.30.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 May 2022 12:30:25 -0700 (PDT)
Message-ID: <6272d451.1c69fb81.25797.5c7d@mx.google.com>
Date:   Wed, 04 May 2022 12:30:25 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.15
X-Kernelci-Kernel: v5.15.37-174-g3e309972807a
Subject: stable-rc/queue/5.15 baseline: 137 runs,
 1 regressions (v5.15.37-174-g3e309972807a)
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

stable-rc/queue/5.15 baseline: 137 runs, 1 regressions (v5.15.37-174-g3e309=
972807a)

Regressions Summary
-------------------

platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.37-174-g3e309972807a/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.37-174-g3e309972807a
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      3e309972807a465e28e872608b01c40fdf012d79 =



Test Regressions
---------------- =



platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/62729f19471e51d2a18f5747

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.37-=
174-g3e309972807a/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beag=
le-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.37-=
174-g3e309972807a/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beag=
le-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220428.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62729f19471e51d2a18f5=
748
        failing since 34 days (last pass: v5.15.31-2-g57d4301e22c2, first f=
ail: v5.15.31-3-g4ae45332eb9c) =

 =20
