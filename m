Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AFD2757EAB5
	for <lists+stable@lfdr.de>; Sat, 23 Jul 2022 02:50:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229573AbiGWAu1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Jul 2022 20:50:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231853AbiGWAu0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 22 Jul 2022 20:50:26 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E009923178
        for <stable@vger.kernel.org>; Fri, 22 Jul 2022 17:50:25 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id c6so5843424pla.6
        for <stable@vger.kernel.org>; Fri, 22 Jul 2022 17:50:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=V3vBMEe2S8/R7DSXtgiVEeqGKsi8rgn7IWwwambTj+E=;
        b=x8Q6/n/uo13F/6vIf0w1XYCsuvMyUpS9U1QIJ3xLILzviuyrjiGuWCOE43aQc/1G3S
         47aUxKEVcqRRmz3HOPiUc9erPgr3YEMapshTjKtR6KcGQKCo0GFKYv8FmILqMEHVbj8O
         VKwV8xoAluh8ZxUEWCfHAfPUm36SwEVpTSVKLZ3nBWadCY96gkFElJS+i4QUSN1zQ7kB
         ajzkFBBRrZKRVOtddn0KJOVzHO/+WFmVc5G0osfT70YDLpjmzYlXme7TyrpAf4n50Kkq
         6EiQWRwfPXTYHkhafnwaUR12+Z0Dj+LTgJVQkypp/xjpdi2n3oEtPRLn6OpHeNgRWyv1
         fL4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=V3vBMEe2S8/R7DSXtgiVEeqGKsi8rgn7IWwwambTj+E=;
        b=z6D3pQg50Zx16f6LcAbyT9taDEu9S0G7YyozuYe9fHaO/yTp/QsrGiy96ENgSvCFH9
         JtrV9BXGxuO8do1SMJa5MxDAcpVmzsNPmR2zCSUfIx7ueDZeJ1dfSmxKYQwovDNFnoek
         t2fMczjnSsOt6nF1viTzC8rlMcE7UpvZyrvfFyR+v40TS6RIRjB5b0/xZ55wvgU1Ay+g
         cyvQJ5GnBcOh83FSJrqI+WCpOFahcZrjCDFW1iV+wQzsgE3AmpnqftQFo65jlDder5Q6
         uh4ueDueYo1UJewKRrtIMnWi7cC7Y/8x7jmC4m/N/MHkh0/Iae2z85WiOzubfTWARyTU
         wYyw==
X-Gm-Message-State: AJIora/Fwd8FzdXnojVegWoOvpP69/0FYQ6F07fVJZY435NG7iOGF9d1
        eYAJG7Q0fcInluyASCRf9xIZ+M/TLxsVR80E
X-Google-Smtp-Source: AGRyM1uawwkUgbJ1JQoxWHeqzBdjJ/iA0FHBZMhUntqQDjbAe1W3RaglFWZf0gPnGjCFYuSzxcpO/A==
X-Received: by 2002:a17:902:da91:b0:16d:3bc2:ff49 with SMTP id j17-20020a170902da9100b0016d3bc2ff49mr2038620plx.85.1658537425086;
        Fri, 22 Jul 2022 17:50:25 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id s29-20020a63215d000000b0041166bf9ca8sm4066438pgm.34.2022.07.22.17.50.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Jul 2022 17:50:24 -0700 (PDT)
Message-ID: <62db45d0.1c69fb81.4bbf.6b9b@mx.google.com>
Date:   Fri, 22 Jul 2022 17:50:24 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-5.18.y
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.18.13
Subject: stable/linux-5.18.y baseline: 157 runs, 2 regressions (v5.18.13)
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

stable/linux-5.18.y baseline: 157 runs, 2 regressions (v5.18.13)

Regressions Summary
-------------------

platform           | arch   | lab             | compiler | defconfig       =
             | regressions
-------------------+--------+-----------------+----------+-----------------=
-------------+------------
hp-x360-14-G1-sona | x86_64 | lab-collabora   | gcc-10   | x86_64_defcon...=
6-chromebook | 1          =

imx6ul-pico-hobbit | arm    | lab-pengutronix | gcc-10   | imx_v6_v7_defcon=
fig          | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.18.y/kernel=
/v5.18.13/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.18.y
  Describe: v5.18.13
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      0283cbd1473380d3ae46f653eac128aebb288423 =



Test Regressions
---------------- =



platform           | arch   | lab             | compiler | defconfig       =
             | regressions
-------------------+--------+-----------------+----------+-----------------=
-------------+------------
hp-x360-14-G1-sona | x86_64 | lab-collabora   | gcc-10   | x86_64_defcon...=
6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62db13f060e33ffaa5daf05f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.18.y/v5.18.13/x=
86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-hp-x360=
-14-G1-sona.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.18.y/v5.18.13/x=
86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-hp-x360=
-14-G1-sona.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220716.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62db13f060e33ffaa5daf=
060
        new failure (last pass: v5.18.11) =

 =



platform           | arch   | lab             | compiler | defconfig       =
             | regressions
-------------------+--------+-----------------+----------+-----------------=
-------------+------------
imx6ul-pico-hobbit | arm    | lab-pengutronix | gcc-10   | imx_v6_v7_defcon=
fig          | 1          =


  Details:     https://kernelci.org/test/plan/id/62db2e7233f828e6bddaf0b9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.18.y/v5.18.13/a=
rm/imx_v6_v7_defconfig/gcc-10/lab-pengutronix/baseline-imx6ul-pico-hobbit.t=
xt
  HTML log:    https://storage.kernelci.org//stable/linux-5.18.y/v5.18.13/a=
rm/imx_v6_v7_defconfig/gcc-10/lab-pengutronix/baseline-imx6ul-pico-hobbit.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220716.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62db2e7233f828e6bddaf=
0ba
        failing since 7 days (last pass: v5.18.11, first fail: v5.18.12) =

 =20
