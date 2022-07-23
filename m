Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F2C357F02F
	for <lists+stable@lfdr.de>; Sat, 23 Jul 2022 18:04:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236316AbiGWQED (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 23 Jul 2022 12:04:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231846AbiGWQEC (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 23 Jul 2022 12:04:02 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E97B71F2DD
        for <stable@vger.kernel.org>; Sat, 23 Jul 2022 09:04:01 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id p8so6877716plq.13
        for <stable@vger.kernel.org>; Sat, 23 Jul 2022 09:04:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Agy2f+WCWbJ8lpNtamcoO0w/bqn9MQD+fWoD6atfnbo=;
        b=5TANceSAkDckf3xDY39nASgsiLn8z8aHyBiDLZE3lX1vqwW+DazqUhkTtsU7IEPD7z
         JWQGwQySBNGmj8DodUFUZg+Jq3uW7ggzjj86A1XraWmdob7yjRplLw48bnf+HK7zI/B8
         KBgOOYCzGVWZXaT5Y7CPr1sZP2uMMaLKmwybnmwKu/5pPrvXf9RPkbJGpL1mdXLi5ZGF
         xBwfF3lpDmYVbXuq0NjfAiqcc7MvVJ7jFMaNbw5t+PMh5UXy6WNCz0PPHnKQEeVuYRmQ
         nM5/wi//VgnDDGxzz0VtrNyYBs4/OYel5Udpwt4z5Z/Y6hUM5SfTlcbqPBflYRNdDgM7
         m+iA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Agy2f+WCWbJ8lpNtamcoO0w/bqn9MQD+fWoD6atfnbo=;
        b=OdBz23cJHyHMVDTP8o6ja2xw0SIH5EIuB5n9LWrzvEf2InFzsg2/ML2t2Olb5gaAZ1
         TGxdo6vlrlRuiiIw+7qvVHQP8Glhv5IEJN2cDNKNCMe848RwBwFQn4it6mCwiNZDI1dv
         T7PZuqyDqQ8t7+2tFaiyILUbK6W7ecD8Fqkc6JdXSeNpb8uFHgQA7UnNdu8ZXNqyPmsg
         O8lFlhYlQ56h1V/dmTIUC3TQw0TOGWpCpW0TTnGCW1LOBqbgMM3T9g0KUOO38fLg7C/0
         dHbZ1GWyPdPzpnH+cuh+YeF7espYs52aPk5u5CXH91qXF9CPWf6xv1igFrxGy2KzqEwL
         E/gQ==
X-Gm-Message-State: AJIora/BFbiMNsuC4O6TWWiMPxDIjpgf6aKwk6u+3itc2+xq8GMgfzY0
        jNYO1rMm4/fp4VEqI9p2eyBegiEERBzdkvYI
X-Google-Smtp-Source: AGRyM1vjlKYvyI0iDC4yVWAJJbuqhe0mV5tKNjgAvxiEaWzkRg60g9AwBNOt2VJ7c1Hz7QOgr5IFxA==
X-Received: by 2002:a17:90b:1c0d:b0:1f2:2939:9ad with SMTP id oc13-20020a17090b1c0d00b001f2293909admr17216214pjb.124.1658592241183;
        Sat, 23 Jul 2022 09:04:01 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id e8-20020a17090301c800b00168a216f629sm5879277plh.11.2022.07.23.09.04.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 Jul 2022 09:04:00 -0700 (PDT)
Message-ID: <62dc1bf0.1c69fb81.83391.90c7@mx.google.com>
Date:   Sat, 23 Jul 2022 09:04:00 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.18
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.18.13-70-g1808f6b94442
Subject: stable-rc/queue/5.18 baseline: 128 runs,
 1 regressions (v5.18.13-70-g1808f6b94442)
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

stable-rc/queue/5.18 baseline: 128 runs, 1 regressions (v5.18.13-70-g1808f6=
b94442)

Regressions Summary
-------------------

platform           | arch | lab             | compiler | defconfig         =
 | regressions
-------------------+------+-----------------+----------+-------------------=
-+------------
imx6ul-pico-hobbit | arm  | lab-pengutronix | gcc-10   | multi_v7_defconfig=
 | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.18/ker=
nel/v5.18.13-70-g1808f6b94442/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.18
  Describe: v5.18.13-70-g1808f6b94442
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      1808f6b94442f0a05b6699d4be1e1e6c9de8a84a =



Test Regressions
---------------- =



platform           | arch | lab             | compiler | defconfig         =
 | regressions
-------------------+------+-----------------+----------+-------------------=
-+------------
imx6ul-pico-hobbit | arm  | lab-pengutronix | gcc-10   | multi_v7_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/62dbe8a1bb6cd6f48ddaf05c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.13-=
70-g1808f6b94442/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-imx=
6ul-pico-hobbit.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.13-=
70-g1808f6b94442/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-imx=
6ul-pico-hobbit.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220716.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62dbe8a1bb6cd6f48ddaf=
05d
        failing since 17 days (last pass: v5.18.9-96-g91cfa3d0b94d, first f=
ail: v5.18.9-102-ga6b8287ea0b9) =

 =20
