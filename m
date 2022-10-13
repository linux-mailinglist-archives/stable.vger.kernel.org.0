Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 134BD5FDCC9
	for <lists+stable@lfdr.de>; Thu, 13 Oct 2022 17:02:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229542AbiJMPCi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Oct 2022 11:02:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229485AbiJMPCi (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Oct 2022 11:02:38 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE996C823A
        for <stable@vger.kernel.org>; Thu, 13 Oct 2022 08:02:34 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id h13so2186744pfr.7
        for <stable@vger.kernel.org>; Thu, 13 Oct 2022 08:02:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=jOM4Fxb7KNey2jmByXjOB4R69xxq/H93bWglppFe8fc=;
        b=RZrNgng0z9BLkCZkexTzrow4/dHMnC3fpxBElBeG9QUUywbx6ZsTDqrsSRwnnok3x9
         m8DVfiUGZzQ5xJNkz6QkfJr47aMoglewQ77wZl1EkO42OdwSiC6e3Eo85SRGyzpWRpKf
         FooDQ3YdLEm7kkCM4FLLnfT2L/8qUFgBaLF4jHuuFuxbUT08vWe8hMlr10S1QPni/k7v
         AzZ8ZBRKvCb/n8Ftsxd7Ubo6a2FbZBsO4hPPirfrzebZGWny3eQTyf7f2ZKFPGn8ZwYZ
         c73VtJhcn7ECUFoTqV9C5KN9hfozii98V6WsF+9ShKesjNoWjjKPulewPfcG33G1iYgi
         ZPqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jOM4Fxb7KNey2jmByXjOB4R69xxq/H93bWglppFe8fc=;
        b=jXeEkI3Ea1ZscMX6yc7hHQN+uNH1QXwZVPTyodE/po4N8b7fmnQ6fDuMOYspErclza
         Rm71QiK7Zfd/Oi6qKWBDLwG3nrtKiN1F4eqe1Qgf1tP2XrrpLYaa6XnV4wnrmK6+pamU
         zvyF04lQN7RoF5ZVYxLF75IY3FUgEp6Q7x4wNioMWC0AeKaIOJuN2oZBR4xWIExRhiZP
         WW2dBLv3EECHxgjZ7hqT0qA7gUR6S6FXcYEWuUUu22YJykiRNZb3gzAHmxAJSL9yYKiQ
         dbgDpQnCH+Du8/QJe8uGaa2Dmuee+Aumt/3RnaCDY8jK5QxaVv/wuLg3VSx8elc7c7Sb
         rQVg==
X-Gm-Message-State: ACrzQf0ksOq3ienEegTs7xu3WJSpfN5GHhW7yp5T/qfmApN7D/nfrIMc
        FMkR/DP8GXKKEwZxsrvrqI7wUS6FPYpQY1UH
X-Google-Smtp-Source: AMsMyM5tyciSg08VwN98yQx3JoopeIvEu8PDbltWBbTUIGS1EI7Ec/JGf+30KbNSwZAV/zbBNXfcNQ==
X-Received: by 2002:a63:1317:0:b0:42a:e7a5:ef5a with SMTP id i23-20020a631317000000b0042ae7a5ef5amr280710pgl.392.1665673353502;
        Thu, 13 Oct 2022 08:02:33 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id i68-20020a626d47000000b005631f2b9ba2sm2204999pfc.14.2022.10.13.08.02.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Oct 2022 08:02:32 -0700 (PDT)
Message-ID: <63482888.620a0220.80dad.3ff8@mx.google.com>
Date:   Thu, 13 Oct 2022 08:02:32 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.19
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.19.15-6-gd3e1520e4af9f
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.19 baseline: 125 runs,
 2 regressions (v5.19.15-6-gd3e1520e4af9f)
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

stable-rc/queue/5.19 baseline: 125 runs, 2 regressions (v5.19.15-6-gd3e1520=
e4af9f)

Regressions Summary
-------------------

platform    | arch | lab     | compiler | defconfig           | regressions
------------+------+---------+----------+---------------------+------------
imx7ulp-evk | arm  | lab-nxp | gcc-10   | imx_v6_v7_defconfig | 1          =

imx7ulp-evk | arm  | lab-nxp | gcc-10   | multi_v7_defconfig  | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.19/ker=
nel/v5.19.15-6-gd3e1520e4af9f/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.19
  Describe: v5.19.15-6-gd3e1520e4af9f
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      d3e1520e4af9ff08bab49defe193e643b856459f =



Test Regressions
---------------- =



platform    | arch | lab     | compiler | defconfig           | regressions
------------+------+---------+----------+---------------------+------------
imx7ulp-evk | arm  | lab-nxp | gcc-10   | imx_v6_v7_defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/6347f6b59f24f850facab610

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.15-=
6-gd3e1520e4af9f/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-ev=
k.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.15-=
6-gd3e1520e4af9f/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-ev=
k.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221007.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6347f6b59f24f850facab=
611
        failing since 17 days (last pass: v5.19.11-158-gc8a84e45064d0, firs=
t fail: v5.19.11-186-ge96864168d41) =

 =



platform    | arch | lab     | compiler | defconfig           | regressions
------------+------+---------+----------+---------------------+------------
imx7ulp-evk | arm  | lab-nxp | gcc-10   | multi_v7_defconfig  | 1          =


  Details:     https://kernelci.org/test/plan/id/6347f856b9e762bbf1cab606

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.15-=
6-gd3e1520e4af9f/arm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-evk=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.15-=
6-gd3e1520e4af9f/arm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-evk=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221007.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6347f856b9e762bbf1cab=
607
        failing since 16 days (last pass: v5.19.11-158-gc8a84e45064d0, firs=
t fail: v5.19.11-206-g444111497b13) =

 =20
