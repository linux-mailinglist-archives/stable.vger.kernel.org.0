Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7B21585BEA
	for <lists+stable@lfdr.de>; Sat, 30 Jul 2022 21:54:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230337AbiG3TyI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 30 Jul 2022 15:54:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230003AbiG3TyH (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 30 Jul 2022 15:54:07 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF08013F57
        for <stable@vger.kernel.org>; Sat, 30 Jul 2022 12:54:06 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id 15-20020a17090a098f00b001f305b453feso11420191pjo.1
        for <stable@vger.kernel.org>; Sat, 30 Jul 2022 12:54:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=OH3pj2O//u3OsoPIGb1Nhcpo3eOnIS8GqqMenwERafc=;
        b=jaXftiPDe2kaDSBRzNbWa5icQowDTI1nS9qqzf9rybSjkJDpdA13X6JrJRu9K0tEy9
         OCmDVQhdrvwRgTPK9ERYxVNvJganQLwyhmAB4D3bs77eZO4u/z2ww8Rkjxy/2NMqOw79
         6pqdZfO67ZA0jc6pwKez7LxTRzpQPtDpHMTnYzmPMVT94w9AWtcbl15C4xjWsMICbMAM
         4jvLlYZjKmvvzmh30unxHNTepquXCL9fT0GZO4BYc9cpPkD3tztnX7cVEH6KnEL2jKqV
         Atq2/1LXxPPxsp1D8/To77rly8uuM8Joo+2Sp2NBZ2PKljKwCSGFLmhzAPd0lJZ/ag0a
         betA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=OH3pj2O//u3OsoPIGb1Nhcpo3eOnIS8GqqMenwERafc=;
        b=qcyHNofkn7WBq7//bMJhU/EG6jxf5wKFDgKoo8wF7AlU3Lh3G2csKe+UMC8zC/OwfY
         WsOJnUZqu4dFrqoVPeB9871gMqAxFfHDYVdYR9wzXpRsjijMpIfmZoZ5BWRvRvTwmEQs
         sxtwJ3PTu/UJS9zndJBY9OpONClEbjsHa8lclyCLPs2Ae8IO2fg9WqXPKvqPtdDzYKFy
         S53GPfiGnIsu+ClLXhqEfCYQ6Up2BIXp/jLnX3Bn370357QJ8NThA07f70ujBmiXmtN1
         dZ5gDrXAJ1KGj/Tg28q8PY8nVUbCrXthBf+/DCmeCyM2ZX4odOr/ftG89baa2ueGyxkY
         1plw==
X-Gm-Message-State: ACgBeo3S7eIWvoUgcRkUeUsflG4F9pXthnCTOuOSRpN3ReOREprll4oK
        Bye4CUNVtDvcn0ZSmb/AQefXA4q0JdEBYLTs
X-Google-Smtp-Source: AA6agR7V4/1M8mSVjxiTs3eQIcl8zcMs5+VfGo7qEfJZh3dFsb0V1teHSAhnq9arhYg3Lbz6l2XN4A==
X-Received: by 2002:a17:90b:4c10:b0:1ef:eb4a:fbb with SMTP id na16-20020a17090b4c1000b001efeb4a0fbbmr11199095pjb.121.1659210846218;
        Sat, 30 Jul 2022 12:54:06 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id w1-20020a628201000000b0052ab7144de8sm5433813pfd.10.2022.07.30.12.54.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 30 Jul 2022 12:54:05 -0700 (PDT)
Message-ID: <62e58c5d.620a0220.824ff.8174@mx.google.com>
Date:   Sat, 30 Jul 2022 12:54:05 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.18
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.18.14-186-g9e5d3e20f8a4d
Subject: stable-rc/queue/5.18 baseline: 61 runs,
 1 regressions (v5.18.14-186-g9e5d3e20f8a4d)
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

stable-rc/queue/5.18 baseline: 61 runs, 1 regressions (v5.18.14-186-g9e5d3e=
20f8a4d)

Regressions Summary
-------------------

platform           | arch | lab             | compiler | defconfig         =
 | regressions
-------------------+------+-----------------+----------+-------------------=
-+------------
imx6ul-pico-hobbit | arm  | lab-pengutronix | gcc-10   | multi_v7_defconfig=
 | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.18/ker=
nel/v5.18.14-186-g9e5d3e20f8a4d/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.18
  Describe: v5.18.14-186-g9e5d3e20f8a4d
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      9e5d3e20f8a4d7c63f8dd598e644ddd4c83e2c92 =



Test Regressions
---------------- =



platform           | arch | lab             | compiler | defconfig         =
 | regressions
-------------------+------+-----------------+----------+-------------------=
-+------------
imx6ul-pico-hobbit | arm  | lab-pengutronix | gcc-10   | multi_v7_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/62e557aac3378728fbdaf064

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.14-=
186-g9e5d3e20f8a4d/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-i=
mx6ul-pico-hobbit.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.14-=
186-g9e5d3e20f8a4d/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-i=
mx6ul-pico-hobbit.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220718.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62e557aac3378728fbdaf=
065
        failing since 24 days (last pass: v5.18.9-96-g91cfa3d0b94d, first f=
ail: v5.18.9-102-ga6b8287ea0b9) =

 =20
