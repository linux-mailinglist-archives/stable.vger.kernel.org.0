Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45FF551B7D5
	for <lists+stable@lfdr.de>; Thu,  5 May 2022 08:15:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234120AbiEEGTG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 May 2022 02:19:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244290AbiEEGTA (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 May 2022 02:19:00 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46447D7A
        for <stable@vger.kernel.org>; Wed,  4 May 2022 23:15:19 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id c9so2795495plh.2
        for <stable@vger.kernel.org>; Wed, 04 May 2022 23:15:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=2kBxZFsSgD9Qh2Su2ubss6k0tEgvjjKHa5iPh9UD1tQ=;
        b=OQM2rhEJOVSvqlxTx2OGpoZaRxS+9ULMWcMeS+GUsVU1yk2v9jO58KN79Kinixgnmd
         QFnCEbIb4ZUw+tNZvjD9gQKsQqObJPGn/KHqBfDLlBzJ1OQkpPQ+7UyT7xYok0ZTOvP3
         rtrAYuqOn5hk9iApL5HNf2CTygUVygYaatNlSYakNcrVjpHYxagUSY+8Fo8XaeqLHWVl
         75B1y/o104YyG7xwakxlLAz7djARtB9NK0rc9T8eUB1caV7odPljgcF7wSD1iRDk+rNg
         tsgC0EYyB/iTOUIjKw95qub5IXeE9nc2wHLAxIbHFnOwn1qpKsVsioNEoYbv0ytNhwjl
         lMKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=2kBxZFsSgD9Qh2Su2ubss6k0tEgvjjKHa5iPh9UD1tQ=;
        b=O/pOiVpPPtDIm+2EDH4AIbMllXfnGfyuFAqC+r2KYibd4lID685iftZpnaMIL36Ss8
         U80CEZK7Dts/bJj0mDYpL851I7ofhHrmMV9In7eEmkEnRGAWP9D1rP1UCYHVPqXaIwNh
         JevNR3XysgkYTlGglwliEAgMkKfAmA7OiMGoQba3Mei9NYe0+mW8U4CwHB4Cn8HkS91I
         67eKm0ASQZtKcgJ06LYOr/3WsUBo9J+LvzVsPn8CLWt2x9jCR6+uOjuSmqgrqa9f0HN7
         mxFs3sRzj8HFoUo3B3YgUBJ2bJ8hNTZCX2VeJJjg1D7+xERGV/irc3CAY2u37T9MavOB
         kfPg==
X-Gm-Message-State: AOAM530E9SIJEZMt57iGlkd+X+7izzI0voToOmu1Scf5V70vWwfPsBWW
        FujimkCgTHTEg1MDTlTlyrI1ZMS0tmLsJDhNaqI=
X-Google-Smtp-Source: ABdhPJy0ucCgpIRMP8gUytXfOZKpcigoyzdnM4dJiFf7ByYU7eQVoHUzBdyB4GtyzHUsofRtv7M8Zw==
X-Received: by 2002:a17:90a:4413:b0:1cd:2d00:9d0b with SMTP id s19-20020a17090a441300b001cd2d009d0bmr4150037pjg.81.1651731318731;
        Wed, 04 May 2022 23:15:18 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id r21-20020a170902be1500b0015e8d4eb247sm573822pls.145.2022.05.04.23.15.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 May 2022 23:15:18 -0700 (PDT)
Message-ID: <62736b76.1c69fb81.79e68.17f5@mx.google.com>
Date:   Wed, 04 May 2022 23:15:18 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.17.y
X-Kernelci-Kernel: v5.17.5-226-gd7a932089173
Subject: stable-rc/linux-5.17.y baseline: 85 runs,
 1 regressions (v5.17.5-226-gd7a932089173)
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

stable-rc/linux-5.17.y baseline: 85 runs, 1 regressions (v5.17.5-226-gd7a93=
2089173)

Regressions Summary
-------------------

platform      | arch | lab         | compiler | defconfig         | regress=
ions
--------------+------+-------------+----------+-------------------+--------=
----
at91sam9g20ek | arm  | lab-broonie | gcc-10   | at91_dt_defconfig | 1      =
    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.17.y/ker=
nel/v5.17.5-226-gd7a932089173/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.17.y
  Describe: v5.17.5-226-gd7a932089173
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      d7a9320891735782606dab06b81711f1ea6fdff6 =



Test Regressions
---------------- =



platform      | arch | lab         | compiler | defconfig         | regress=
ions
--------------+------+-------------+----------+-------------------+--------=
----
at91sam9g20ek | arm  | lab-broonie | gcc-10   | at91_dt_defconfig | 1      =
    =


  Details:     https://kernelci.org/test/plan/id/6273376b449d83696d8f5737

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: at91_dt_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.17.y/v5.17.5=
-226-gd7a932089173/arm/at91_dt_defconfig/gcc-10/lab-broonie/baseline-at91sa=
m9g20ek.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.17.y/v5.17.5=
-226-gd7a932089173/arm/at91_dt_defconfig/gcc-10/lab-broonie/baseline-at91sa=
m9g20ek.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220428.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6273376b449d83696d8f5=
738
        new failure (last pass: v5.17.5) =

 =20
