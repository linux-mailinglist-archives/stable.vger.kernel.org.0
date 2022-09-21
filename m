Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9BD25E566C
	for <lists+stable@lfdr.de>; Thu, 22 Sep 2022 00:57:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229814AbiIUW5A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Sep 2022 18:57:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230323AbiIUW45 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Sep 2022 18:56:57 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3076FA8CC9
        for <stable@vger.kernel.org>; Wed, 21 Sep 2022 15:56:55 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id d64-20020a17090a6f4600b00202ce056566so311783pjk.4
        for <stable@vger.kernel.org>; Wed, 21 Sep 2022 15:56:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date;
        bh=/iiyDDBOSitO40lHti1guOB927grBcpa5/Smc/n5/EI=;
        b=kdZanGjzKpWQlWl+9bCq36Y1wKD/1g9R6g+kK4+TvNDZ1G4TiVFdqD1gghewNRmxMJ
         UL7/n8NoCeaVHAlln4i3703bIv51Tu1uzbfku/zJSrAhJiIR9+GMakegR01LmJnCzpnq
         a8Yb2t8uF8qpHT5wV6FeN01ImnhEfsWnjA/Cc+kDPjhj82cSbZBMUg1FJ0GskX42i3r6
         I24ZT7CJtLAHZrYbHDD0anrvG7qwZ1bA5IPLs3oh2L/56mtAWyeG1ArH3oDO4QvxZ4Ly
         6luLkX+MfGxNEHFXtBS8SDOMHkDqf3BrCs3xdDRBoDHPhXNAX9Ya4KaHqURqqxrONhrl
         KcWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date;
        bh=/iiyDDBOSitO40lHti1guOB927grBcpa5/Smc/n5/EI=;
        b=dOhFl8IPhYuE1o0ouDtnFA3rneNwKD0LM22ZzRL2DTQG+kAYI7jGnM69RFl6jrvYT3
         kVnezbgqKP4PB+p0cgedjKTclGO+L3wppKFJslX7+2b5FaVOr0imZmSvBmR93Jx2tc5p
         lGwSZigEMsbw+MTIYmJEQSo1uZvGtJpjsjlLkhKjZQACR64NPIXbhmmF0BDbKfzZVl84
         3SjlCQNWJCrlo0lmEWMj39iLRVSimIjuZPHuvXSRJLexIAeG6994GwYNHdVZ/FMXeAXZ
         Jruq1z6eAlEMj07Ez1rorhFH3ZzN6Dj5ZhxSOQo5BLV+GAedDl+IYYroU1trfspCnnCU
         HybA==
X-Gm-Message-State: ACrzQf3wDWXZ+1bJQtH4ydAjl66+v/vtWkyIvUMjd3FERW88Ej/FxQfL
        ccqjfADSWK9W+cuaGeqxrXAgtUzYlbbQxNt7IfE=
X-Google-Smtp-Source: AMsMyM6u59UoricuRlpPNMNgCgKL3SYyoZmJtu0+pzQByTDKeOlugpyabgGcsL5YHLra6lWOqm8OYA==
X-Received: by 2002:a17:90b:4b88:b0:202:e381:e643 with SMTP id lr8-20020a17090b4b8800b00202e381e643mr11884682pjb.148.1663801015363;
        Wed, 21 Sep 2022 15:56:55 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id jf13-20020a170903268d00b00172b87d97cbsm2547437plb.67.2022.09.21.15.56.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Sep 2022 15:56:55 -0700 (PDT)
Message-ID: <632b96b7.170a0220.2b1b2.62f1@mx.google.com>
Date:   Wed, 21 Sep 2022 15:56:55 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.19.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.19.10-40-g8d4fd61ab089
Subject: stable-rc/linux-5.19.y baseline: 151 runs,
 1 regressions (v5.19.10-40-g8d4fd61ab089)
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

stable-rc/linux-5.19.y baseline: 151 runs, 1 regressions (v5.19.10-40-g8d4f=
d61ab089)

Regressions Summary
-------------------

platform       | arch | lab     | compiler | defconfig           | regressi=
ons
---------------+------+---------+----------+---------------------+---------=
---
imx6qp-sabresd | arm  | lab-nxp | gcc-10   | imx_v6_v7_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.19.y/ker=
nel/v5.19.10-40-g8d4fd61ab089/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.19.y
  Describe: v5.19.10-40-g8d4fd61ab089
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      8d4fd61ab089cbb028a32652f9096cf53dfe54b3 =



Test Regressions
---------------- =



platform       | arch | lab     | compiler | defconfig           | regressi=
ons
---------------+------+---------+----------+---------------------+---------=
---
imx6qp-sabresd | arm  | lab-nxp | gcc-10   | imx_v6_v7_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/632b64f63a068919303556ae

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.19.y/v5.19.1=
0-40-g8d4fd61ab089/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx6qp-s=
abresd.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.19.y/v5.19.1=
0-40-g8d4fd61ab089/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx6qp-s=
abresd.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/632b64f63a06891930355=
6af
        new failure (last pass: v5.19.9-39-gf5066a94bca4) =

 =20
