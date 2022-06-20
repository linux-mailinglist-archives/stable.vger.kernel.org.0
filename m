Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 718575514E7
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 11:52:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239006AbiFTJv6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 05:51:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240222AbiFTJvx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 05:51:53 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27DA813E2B
        for <stable@vger.kernel.org>; Mon, 20 Jun 2022 02:51:47 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id k7so9277287plg.7
        for <stable@vger.kernel.org>; Mon, 20 Jun 2022 02:51:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=HjsCi6MAsZ90WH5ZWDyP6I6j/Jttt04vSoGOG9gawSA=;
        b=QmDM1iiExYsWHHKWsJ6569ZnmPBlIEVHgEJkttl1Le8RLGWZR8uQcLtkScval27OBE
         13/jssggcxZIkrLb/YuWHhNcmfFKxFG+NMwVQX9rtSiAtx7d4PWvU8tXJS+wCVylhqGc
         xluDdhl16Bjl+U5dXo2YPpmWmgENwybSEeAP7MA9Kxxw8Gs3akkBhPpLkKIwt7X4qYt5
         uBSzUUKiHOgLHT2aK4fmGQVj0Txnd5AXXUNnGY6NgEDKaJCQe1b0B4CdmqMTCrVpUdvE
         R4eCC74ZFWoDSU277k0mHXtDA/0HW8i7/GtzQ0729FfatGjrx61sKjnKBCaIe5hKU28U
         8p2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=HjsCi6MAsZ90WH5ZWDyP6I6j/Jttt04vSoGOG9gawSA=;
        b=SRwUO3NTzDOFPZS5onlsjlIOvibsH7L0A262/JsbAO+KfGgY1C8mj/ZGXPoywib5Fj
         dyKN9qUlE7AhP2F5oezKlsoTjZuzZET7n+DuAuM5r2qW5kJ9xQCjPias5nyEiw1GEOOK
         lH/4+PAU5sTK2BtFGv5TaBj3iP0BwcSQpMptuMtXeyvqJ0QmIl2CfrewrJlRCLaeSj1E
         n+orbk11PBAztDYu/RcsSGdUm9gURX6pBRYmkYL5jYaEUBnZ46tgU8GQ9ZtucWfYguxw
         vvH7bmqCRdtKGdmUojo5z8xJeG+RHifREqJXkT5kDrOz837rmuNnvaJyM61nq7WMrO2s
         KVoA==
X-Gm-Message-State: AJIora8MwPiE51E8ojjVSQ0BMwvDvSt9YF2IyDV26uCA1C6V0wGqBnRu
        SXiCzRxWtnl7hITwcvlzM3w49ksud7s3lN4oR9k=
X-Google-Smtp-Source: AGRyM1sefjdTX2iojdhsWYRd3JGuN+bBQnoKjC6PqTJzYJSl2V190WV+jTjPMm840BFp3NRHyYBu3A==
X-Received: by 2002:a17:902:7088:b0:167:78c0:e05e with SMTP id z8-20020a170902708800b0016778c0e05emr22802586plk.149.1655718706507;
        Mon, 20 Jun 2022 02:51:46 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id u1-20020a1709026e0100b0016160b3331bsm8203059plk.305.2022.06.20.02.51.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jun 2022 02:51:46 -0700 (PDT)
Message-ID: <62b04332.1c69fb81.b6196.b70d@mx.google.com>
Date:   Mon, 20 Jun 2022 02:51:46 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.19.248-199-ga2b1f2fe381ed
X-Kernelci-Branch: queue/4.19
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.19 baseline: 57 runs,
 1 regressions (v4.19.248-199-ga2b1f2fe381ed)
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

stable-rc/queue/4.19 baseline: 57 runs, 1 regressions (v4.19.248-199-ga2b1f=
2fe381ed)

Regressions Summary
-------------------

platform           | arch   | lab           | compiler | defconfig         =
           | regressions
-------------------+--------+---------------+----------+-------------------=
-----------+------------
hp-11A-G6-EE-grunt | x86_64 | lab-collabora | gcc-10   | x86_64_defcon...6-=
chromebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.248-199-ga2b1f2fe381ed/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.248-199-ga2b1f2fe381ed
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      a2b1f2fe381edc4a36fdbb26c10072f60557d95c =



Test Regressions
---------------- =



platform           | arch   | lab           | compiler | defconfig         =
           | regressions
-------------------+--------+---------------+----------+-------------------=
-----------+------------
hp-11A-G6-EE-grunt | x86_64 | lab-collabora | gcc-10   | x86_64_defcon...6-=
chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62ae2028757b7ba188a39c1a

  Results:     17 PASS, 1 FAIL, 1 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.248=
-199-ga2b1f2fe381ed/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-colla=
bora/baseline-hp-11A-G6-EE-grunt.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.248=
-199-ga2b1f2fe381ed/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-colla=
bora/baseline-hp-11A-G6-EE-grunt.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220610.1/x86/rootfs.cpio.gz =



  * baseline.bootrr.thermal-device-probed: https://kernelci.org/test/case/i=
d/62ae2028757b7ba188a39c1f
        failing since 11 days (last pass: v4.19.245-30-g0625a97aa45db, firs=
t fail: v4.19.246-188-g0ca7a8ff35400)

    2022-06-18T18:57:26.610500  /lava-6644926/1/../bin/lava-test-case
    2022-06-18T18:57:26.616883  <8>[   12.003613] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dthermal-device-probed RESULT=3Dfail>   =

 =20
