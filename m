Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E304622083
	for <lists+stable@lfdr.de>; Wed,  9 Nov 2022 00:57:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229511AbiKHX47 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 18:56:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229887AbiKHX46 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 18:56:58 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A2AD21812
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 15:56:57 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id b11so15222753pjp.2
        for <stable@vger.kernel.org>; Tue, 08 Nov 2022 15:56:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=MMyMukdrKIfLqmxNdoD72eiARwbPTrVUE5AOyuj7NP0=;
        b=z+oNeq9yJ06FN9IA25NhRdp7BXnWmytr6XL3vvwo5pdP5XOvBgwaIyXyuf0xEOQdtq
         zNEmNPnh72MMPluanYCzMzjuakAvVqmDBXgEISaX/fxCXHstqAAgb1f5AZxXLNTJaLmV
         ud+ign42PpC3CIeGl0Qp3z//8Eie3CQFi6APw199WsGsK/orqnHYeBQ0st12IXmWs1Ci
         Z1RZhf1GP6yLNI8QyfQYjfXOt0hcHEO+FzLddv4WNctWfNr5AIm+GHE5W5c0z3/Pin1r
         3OkHRr/sGWA6vkuYykiTNPjNeEhdahvXfawVIXhKOPG7dhW4QUGiS39qb7N/5nB7Za+q
         /lZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MMyMukdrKIfLqmxNdoD72eiARwbPTrVUE5AOyuj7NP0=;
        b=zIMHDJcXxfGrAvqotxRSXvw6VsbgRTDNe6B6Dk80IVJl7FXkmTAAHzjtgrZanOZu6P
         Ow8PMynmEJ0kVQ5GsF3zQZ+A/pYaxpbp4GstU3Y7qsQF8FPZF/B3fScsm/tNngq5a0YU
         rJH0J887Jz/xob7k00YA570yyyjvCg2bFFN+lggu6x5phDvGOtNGoWd0RxD3RK6f+7kF
         TMHzVhP8rQdex5TIZt3ISaeXErWMezNcgE7OYdV30TeMK3uLKCZfof9wM3aexCUWyIXw
         C1MtMxO6LEq6Uyrv+XLCAZdD2wRFJQpZN4CLTmg8yX9i8/+eWkZi6M2cdYQqGLDU7BLt
         fz2w==
X-Gm-Message-State: ACrzQf1MoaTv+teSm3zr7WCanZ23ZSYc1jtzS+kPNffvZKTw7c5fN60n
        d1AZ38Qnl/HWdwIGXBcSWpGFwhwD7xiHnzSp
X-Google-Smtp-Source: AMsMyM44Sh7yQLZ0g7E8p49JNW/QNm/pes7mFep0y148ot4Soxa8YsVyivLd6JJUbV/VVNwdQKuz0Q==
X-Received: by 2002:a17:90b:1d09:b0:213:773a:b4b2 with SMTP id on9-20020a17090b1d0900b00213773ab4b2mr69065207pjb.40.1667951816694;
        Tue, 08 Nov 2022 15:56:56 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id g17-20020a635651000000b0046f7e1ca434sm6361031pgm.0.2022.11.08.15.56.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Nov 2022 15:56:56 -0800 (PST)
Message-ID: <636aecc8.630a0220.67f00.a6f3@mx.google.com>
Date:   Tue, 08 Nov 2022 15:56:56 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.15.77-144-g06c96c8d6c7c
X-Kernelci-Branch: queue/5.15
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.15 baseline: 139 runs,
 2 regressions (v5.15.77-144-g06c96c8d6c7c)
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

stable-rc/queue/5.15 baseline: 139 runs, 2 regressions (v5.15.77-144-g06c96=
c8d6c7c)

Regressions Summary
-------------------

platform    | arch | lab     | compiler | defconfig           | regressions
------------+------+---------+----------+---------------------+------------
imx7ulp-evk | arm  | lab-nxp | gcc-10   | imx_v6_v7_defconfig | 1          =

imx7ulp-evk | arm  | lab-nxp | gcc-10   | multi_v7_defconfig  | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.77-144-g06c96c8d6c7c/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.77-144-g06c96c8d6c7c
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      06c96c8d6c7c7930b5d2c93606f2e46df9703860 =



Test Regressions
---------------- =



platform    | arch | lab     | compiler | defconfig           | regressions
------------+------+---------+----------+---------------------+------------
imx7ulp-evk | arm  | lab-nxp | gcc-10   | imx_v6_v7_defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/636abf5ef1527d6f8de7db65

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.77-=
144-g06c96c8d6c7c/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-e=
vk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.77-=
144-g06c96c8d6c7c/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-e=
vk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221024.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/636abf5ef1527d6f8de7d=
b66
        failing since 44 days (last pass: v5.15.70-117-g5ae36aa8ead6e, firs=
t fail: v5.15.70-133-gbad831d5b9cf) =

 =



platform    | arch | lab     | compiler | defconfig           | regressions
------------+------+---------+----------+---------------------+------------
imx7ulp-evk | arm  | lab-nxp | gcc-10   | multi_v7_defconfig  | 1          =


  Details:     https://kernelci.org/test/plan/id/636ac13e5d1f9449cfe7db6c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.77-=
144-g06c96c8d6c7c/arm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-ev=
k.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.77-=
144-g06c96c8d6c7c/arm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-ev=
k.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221024.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/636ac13e5d1f9449cfe7d=
b6d
        failing since 44 days (last pass: v5.15.69-44-g09c929d3da79, first =
fail: v5.15.70-123-gaf951c1b9b36) =

 =20
