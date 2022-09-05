Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DD4B5AD76E
	for <lists+stable@lfdr.de>; Mon,  5 Sep 2022 18:27:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231454AbiIEQ10 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Sep 2022 12:27:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231697AbiIEQ1W (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Sep 2022 12:27:22 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96D611056D
        for <stable@vger.kernel.org>; Mon,  5 Sep 2022 09:27:21 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id x1so4563068plv.5
        for <stable@vger.kernel.org>; Mon, 05 Sep 2022 09:27:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date;
        bh=VBhP43NX5KfajnWBx07hqFQAI00O/IvmGFF3pWyXods=;
        b=HTRM76x/Ja+u7fUg7AjP1K835hLQgGu3HQUYhqkoHEWxsu2AmmWNliZm5NkTqPeROk
         pMfJVmFGBVVrp2MMk9xqdye1gvVhIVuSPMjM2GxQXFaRwhQlvkMeOsGMrTS4hTp4T3YT
         1Q5mvphwcap66ZZIMDaKzKVwz4HZgrgPurhQXaiuzHMeNooiQxEpYFHtReBeNyVpl/1d
         W1yM4BbdzVPllbodP+LznihnoGd0/lhWsTYapooDyPoZBVFKJrWJLt7zgnS5MAC9S9Qc
         3I63a18XeFdgAh+QXfUzF4ylSe8cpVR5cbhX94p5Vwjo9p9qXqAYqSENgkZxPkE8OQgW
         WWzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date;
        bh=VBhP43NX5KfajnWBx07hqFQAI00O/IvmGFF3pWyXods=;
        b=4KgCGira2jS8M4X+QSi30azjuFWhuAMoZU2qxmVOLAGFUv8S7UQDKW6nM7DBzFyi9O
         FgAtq+uIpj7Au3Y35dxtFy3aUoRtEbcE9AagKG9d2AVSeSobbB5FAN2pY8LEhPzIZRjE
         Txc5EaiPa1Pk91Umj+3d7PjdHFT2BmtNC/dbHGZJ6mKfV972+5t2/R/ugorTvykAf1rr
         BuBDqPfBIfO1bSQNX5KErY/ULPHDRut/cCMDvNmPhl0wa3coctrPegN9xHPTxQbkPsiR
         88EzwmUUAkQ9fd01W0opV+5eVNfqGt8k2G86a174jGJytpvxQPh6jti+PcplUZOmbeJI
         ueXw==
X-Gm-Message-State: ACgBeo12SM0fQoPo32aiUvdbRPOgiHofQp3qIgHHR2v7LSUGJfN72Vwq
        8ZBV50fF9ICQiLJ/2KBNvwmiPwTyRvaYwKoZat4=
X-Google-Smtp-Source: AA6agR7pAiU3anmmUeoXtXqYLKAN6kWQQ1QbGm7+M04tfQjEzIoFN+MBOZc8/IezbzTwDdWTKAi+hA==
X-Received: by 2002:a17:902:da86:b0:174:cbcf:5f98 with SMTP id j6-20020a170902da8600b00174cbcf5f98mr38723775plx.49.1662395240477;
        Mon, 05 Sep 2022 09:27:20 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b18-20020aa79512000000b00537e40747b0sm8000116pfp.42.2022.09.05.09.27.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Sep 2022 09:27:20 -0700 (PDT)
Message-ID: <63162368.a70a0220.35bc9.c65f@mx.google.com>
Date:   Mon, 05 Sep 2022 09:27:20 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.19
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.19.4-233-gb132f8879934e
Subject: stable-rc/queue/5.19 baseline: 192 runs,
 2 regressions (v5.19.4-233-gb132f8879934e)
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

stable-rc/queue/5.19 baseline: 192 runs, 2 regressions (v5.19.4-233-gb132f8=
879934e)

Regressions Summary
-------------------

platform           | arch  | lab             | compiler | defconfig        =
   | regressions
-------------------+-------+-----------------+----------+------------------=
---+------------
imx6ul-pico-hobbit | arm   | lab-pengutronix | gcc-10   | imx_v6_v7_defconf=
ig | 1          =

kontron-pitx-imx8m | arm64 | lab-kontron     | gcc-10   | defconfig        =
   | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.19/ker=
nel/v5.19.4-233-gb132f8879934e/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.19
  Describe: v5.19.4-233-gb132f8879934e
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      b132f8879934e15cf0a2ac9c5c76b964abfe3cd8 =



Test Regressions
---------------- =



platform           | arch  | lab             | compiler | defconfig        =
   | regressions
-------------------+-------+-----------------+----------+------------------=
---+------------
imx6ul-pico-hobbit | arm   | lab-pengutronix | gcc-10   | imx_v6_v7_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/6315ee8a5da8e9a707355674

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.4-2=
33-gb132f8879934e/arm/imx_v6_v7_defconfig/gcc-10/lab-pengutronix/baseline-i=
mx6ul-pico-hobbit.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.4-2=
33-gb132f8879934e/arm/imx_v6_v7_defconfig/gcc-10/lab-pengutronix/baseline-i=
mx6ul-pico-hobbit.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6315ee8a5da8e9a707355=
675
        failing since 19 days (last pass: v5.19.1-1157-g615e53e38bef5, firs=
t fail: v5.19.1-1159-g6c70b627ef512) =

 =



platform           | arch  | lab             | compiler | defconfig        =
   | regressions
-------------------+-------+-----------------+----------+------------------=
---+------------
kontron-pitx-imx8m | arm64 | lab-kontron     | gcc-10   | defconfig        =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/6315f3b7b12e9c0a4935567d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.4-2=
33-gb132f8879934e/arm64/defconfig/gcc-10/lab-kontron/baseline-kontron-pitx-=
imx8m.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.4-2=
33-gb132f8879934e/arm64/defconfig/gcc-10/lab-kontron/baseline-kontron-pitx-=
imx8m.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6315f3b7b12e9c0a49355=
67e
        failing since 2 days (last pass: v5.19.3-364-gd819f988752b, first f=
ail: v5.19.4-233-g65485bdafd38) =

 =20
